#!/usr/bin/env python3
"""Simulate a live OLTP application writing to the source database.

Continuously runs INSERT / UPDATE / DELETE transactions against the `shop`
database so the CDC pipeline has a realistic, never-ending change stream to
carry, instead of the handful of hand-typed psql statements in the README.

Two operations change several tables inside ONE transaction:

    checkout      INSERT orders + INSERT order_items + UPDATE inventory per item
    cancel_order  UPDATE inventory (restock) + DELETE orders, which cascades
                  to that order's order_items rows

Debezium turns each of them into several change events on different topics
that share one transaction id, plus BEGIN/END markers on shop.transaction.
A checkout that runs a product out of stock fails the inventory CHECK
constraint and rolls back, so none of its changes reach Kafka. Every other
operation is a single-statement transaction.

Requires init/02-order-transactions.sql (products, inventory, order_items).

Usage:
    python generator/simulate.py                  # 2 transactions/sec until Ctrl+C
    python generator/simulate.py --rate 20        # 20 transactions/sec
    python generator/simulate.py --duration 60    # stop after 60 seconds
    python generator/simulate.py --rate 50 --quiet
"""

import argparse
import random
import signal
import sys
import time
from collections import Counter

import psycopg2
import psycopg2.errors

DSN = {
    "host": "localhost",
    "port": 5432,
    "dbname": "shop",
    "user": "cdcuser",
    "password": "cdcpass",
}

FIRST_NAMES = [
    "Ada", "Grace", "Alan", "Katherine", "Margaret", "Dorothy", "Linus",
    "Barbara", "Edsger", "Donald", "Frances", "Radia", "Ken", "Shafi",
]
LAST_NAMES = [
    "Lovelace", "Hopper", "Turing", "Johnson", "Hamilton", "Vaughan",
    "Torvalds", "Liskov", "Dijkstra", "Knuth", "Allen", "Perlman",
    "Thompson", "Goldwasser",
]

# Orders walk forward through this lifecycle; once delivered they stop moving.
STATUS_FLOW = ["pending", "paid", "shipped", "delivered"]

# Relative likelihood of each operation. Weighted so the stream looks like a
# real app: lots of reads-turned-writes, fewer signups, rare cancellations.
OPERATIONS = [
    ("checkout", 40),
    ("advance_order", 30),
    ("new_customer", 8),
    ("restock", 8),
    ("update_customer", 7),
    ("cancel_order", 7),
]

# Restock only products below this level, so stock stays low enough for the
# occasional checkout to sell out and roll back.
RESTOCK_BELOW = 10
RESTOCK_AMOUNT = (10, 30)


class OutOfStock(Exception):
    """A checkout hit the inventory CHECK constraint; its transaction is void."""


class Simulator:
    def __init__(self, conn, rng):
        self.conn = conn
        self.rng = rng
        self.counts = Counter()
        self.customer_ids = []
        # (id, name, price) rows from the products table
        self.products = []
        # order_id -> index into STATUS_FLOW
        self.order_status = {}
        self._load_existing_state()

    def _load_existing_state(self):
        """Seed in-memory state from whatever is already in the database."""
        with self.conn.cursor() as cur:
            cur.execute("SELECT id FROM customers ORDER BY id")
            self.customer_ids = [r[0] for r in cur.fetchall()]
            cur.execute("SELECT id, name, price FROM products ORDER BY id")
            self.products = cur.fetchall()
            cur.execute("SELECT id, status FROM orders ORDER BY id")
            for order_id, status in cur.fetchall():
                idx = STATUS_FLOW.index(status) if status in STATUS_FLOW else 0
                self.order_status[order_id] = idx
        self.conn.commit()

    # --- individual operations -------------------------------------------

    def new_customer(self):
        name = f"{self.rng.choice(FIRST_NAMES)} {self.rng.choice(LAST_NAMES)}"
        # Suffix keeps emails unique across long runs.
        email = f"{name.lower().replace(' ', '.')}.{self.rng.randint(1000, 9999)}@example.com"
        with self.conn.cursor() as cur:
            cur.execute(
                "INSERT INTO customers (name, email) VALUES (%s, %s) RETURNING id",
                (name, email),
            )
            new_id = cur.fetchone()[0]
        self.conn.commit()
        self.customer_ids.append(new_id)
        return f"INSERT customers  id={new_id} {name}"

    def checkout(self):
        """Place an order with 1-3 line items as ONE transaction over 3 tables."""
        if not self.customer_ids:
            return self.new_customer()
        customer_id = self.rng.choice(self.customer_ids)
        line_count = min(len(self.products), self.rng.randint(1, 3))
        lines = [(product, self.rng.randint(1, 2))
                 for product in self.rng.sample(self.products, line_count)]
        total = sum(price * qty for (_, _, price), qty in lines)
        summary = lines[0][0][1]
        if len(lines) > 1:
            summary += f" +{len(lines) - 1} more"
        with self.conn.cursor() as cur:
            cur.execute(
                "INSERT INTO orders (customer_id, product, amount, status) "
                "VALUES (%s, %s, %s, 'pending') RETURNING id",
                (customer_id, summary, total),
            )
            order_id = cur.fetchone()[0]
            for (product_id, name, price), qty in lines:
                cur.execute(
                    "INSERT INTO order_items (order_id, product_id, quantity, unit_price) "
                    "VALUES (%s, %s, %s, %s)",
                    (order_id, product_id, qty, price),
                )
                try:
                    cur.execute(
                        "UPDATE inventory SET quantity = quantity - %s, updated_at = now() "
                        "WHERE product_id = %s",
                        (qty, product_id),
                    )
                except psycopg2.errors.CheckViolation:
                    raise OutOfStock(
                        f"{name} out of stock; order {order_id} and its items "
                        f"never reach Kafka") from None
        self.conn.commit()
        self.order_status[order_id] = 0
        return (f"TX checkout       order={order_id} ${total}: orders + "
                f"{len(lines)} order_items + {len(lines)} inventory")

    def advance_order(self):
        """Move one order forward in its lifecycle (pending -> ... -> delivered)."""
        movable = [oid for oid, idx in self.order_status.items()
                   if idx < len(STATUS_FLOW) - 1]
        if not movable:
            return self.checkout()
        order_id = self.rng.choice(movable)
        next_idx = self.order_status[order_id] + 1
        next_status = STATUS_FLOW[next_idx]
        with self.conn.cursor() as cur:
            cur.execute(
                "UPDATE orders SET status = %s, updated_at = now() WHERE id = %s",
                (next_status, order_id),
            )
            changed = cur.rowcount
        self.conn.commit()
        if not changed:
            # Row vanished (e.g. cancelled by a concurrent run); forget it.
            self.order_status.pop(order_id, None)
            return None
        self.order_status[order_id] = next_idx
        return f"UPDATE orders     id={order_id} -> {next_status}"

    def update_customer(self):
        if not self.customer_ids:
            return self.new_customer()
        customer_id = self.rng.choice(self.customer_ids)
        new_email = f"user{customer_id}.{self.rng.randint(1000, 9999)}@example.com"
        with self.conn.cursor() as cur:
            cur.execute(
                "UPDATE customers SET email = %s WHERE id = %s",
                (new_email, customer_id),
            )
            changed = cur.rowcount
        self.conn.commit()
        if not changed:
            self.customer_ids.remove(customer_id)
            return None
        return f"UPDATE customers  id={customer_id} -> {new_email}"

    def cancel_order(self):
        """Cancel an unshipped order: return its stock and delete it, atomically.

        Only the orders row is deleted explicitly; ON DELETE CASCADE removes its
        order_items rows, and those cascaded deletes are captured as well.
        """
        cancellable = [oid for oid, idx in self.order_status.items() if idx <= 1]
        if not cancellable:
            return self.checkout()
        order_id = self.rng.choice(cancellable)
        with self.conn.cursor() as cur:
            cur.execute(
                "UPDATE inventory i SET quantity = i.quantity + oi.quantity, updated_at = now() "
                "FROM (SELECT product_id, sum(quantity) AS quantity FROM order_items "
                "      WHERE order_id = %s GROUP BY product_id) oi "
                "WHERE i.product_id = oi.product_id",
                (order_id,),
            )
            restocked = cur.rowcount
            cur.execute("DELETE FROM orders WHERE id = %s", (order_id,))
            changed = cur.rowcount
        self.conn.commit()
        self.order_status.pop(order_id, None)
        if not changed:
            return None
        return (f"TX cancel_order   order={order_id}: {restocked} inventory + orders"
                f" + order_items (cascade)")

    def restock(self):
        """Top up the scarcest product, if it is running low."""
        with self.conn.cursor() as cur:
            cur.execute(
                "UPDATE inventory SET quantity = quantity + %s, updated_at = now() "
                "WHERE product_id = (SELECT product_id FROM inventory "
                "                    WHERE quantity < %s "
                "                    ORDER BY quantity, product_id LIMIT 1) "
                "RETURNING product_id, quantity",
                (self.rng.randint(*RESTOCK_AMOUNT), RESTOCK_BELOW),
            )
            row = cur.fetchone()
        self.conn.commit()
        if row is None:
            return None
        return f"UPDATE inventory  product_id={row[0]} -> {row[1]} in stock"

    # --- driver -----------------------------------------------------------

    def step(self):
        names = [name for name, _ in OPERATIONS]
        weights = [weight for _, weight in OPERATIONS]
        op = self.rng.choices(names, weights=weights, k=1)[0]
        try:
            description = getattr(self, op)()
        except OutOfStock as exc:
            self.conn.rollback()
            self.counts["rolled_back"] += 1
            return f"ROLLBACK {op}: {exc}"
        except psycopg2.Error as exc:
            self.conn.rollback()
            self.counts["errors"] += 1
            return f"ERROR {op}: {str(exc).strip()}"
        if description is None:
            return None
        self.counts[op] += 1
        return description

    def committed(self):
        """Number of transactions that committed (and so reached the WAL)."""
        return sum(v for k, v in self.counts.items()
                   if k not in ("errors", "rolled_back"))


def build_arg_parser():
    parser = argparse.ArgumentParser(
        description="Generate a continuous OLTP workload for the CDC pipeline."
    )
    parser.add_argument("--rate", type=float, default=2.0,
                        help="target transactions per second (default: 2)")
    parser.add_argument("--duration", type=float, default=0,
                        help="seconds to run; 0 means run until Ctrl+C (default: 0)")
    parser.add_argument("--seed", type=int, default=None,
                        help="random seed for reproducible workloads")
    parser.add_argument("--quiet", action="store_true",
                        help="only print periodic summaries, not every transaction")
    parser.add_argument("--stats-every", type=float, default=10.0,
                        help="seconds between summary lines (default: 10)")
    return parser


def main():
    args = build_arg_parser().parse_args()
    if args.rate <= 0:
        print("--rate must be greater than 0", file=sys.stderr)
        return 2

    rng = random.Random(args.seed)

    try:
        conn = psycopg2.connect(**DSN)
    except psycopg2.OperationalError as exc:
        print(f"Could not connect to Postgres at "
              f"{DSN['host']}:{DSN['port']}/{DSN['dbname']}:\n  {exc}".rstrip(),
              file=sys.stderr)
        print("Is the stack running?  podman compose up -d", file=sys.stderr)
        return 1

    try:
        sim = Simulator(conn, rng)
    except psycopg2.errors.UndefinedTable as exc:
        print(f"{str(exc).strip()}\nApply init/02-order-transactions.sql first "
              f"(see README, \"Multi-table transactions\").", file=sys.stderr)
        return 1
    if not sim.products:
        print("The products table is empty; checkouts need a catalog. "
              "Re-run init/02-order-transactions.sql.", file=sys.stderr)
        return 1

    running = {"flag": True}

    def handle_stop(_signum, _frame):
        running["flag"] = False

    signal.signal(signal.SIGINT, handle_stop)
    signal.signal(signal.SIGTERM, handle_stop)

    interval = 1.0 / args.rate
    started = time.monotonic()
    last_stats = started

    print(f"Writing to {DSN['dbname']}@{DSN['host']}:{DSN['port']} "
          f"at ~{args.rate} transactions/sec "
          f"({'until Ctrl+C' if not args.duration else f'for {args.duration:g}s'})")
    print(f"Seeded with {len(sim.customer_ids)} customers, "
          f"{len(sim.order_status)} orders, {len(sim.products)} products\n")

    while running["flag"]:
        now = time.monotonic()
        if args.duration and (now - started) >= args.duration:
            break

        description = sim.step()
        if description and not args.quiet:
            print(description)

        if (now - last_stats) >= args.stats_every:
            elapsed = now - started
            total = sim.committed()
            print(f"  -- {total} transactions in {elapsed:.0f}s "
                  f"({total / elapsed:.1f}/s): {dict(sim.counts)}")
            last_stats = now

        # Jitter keeps the stream from looking like a metronome.
        time.sleep(max(0.0, rng.uniform(0.5, 1.5) * interval))

    elapsed = time.monotonic() - started
    total = sim.committed()
    print(f"\nStopped after {elapsed:.1f}s — {total} transactions "
          f"({total / elapsed:.1f}/s)")
    for name, count in sorted(sim.counts.items(), key=lambda kv: -kv[1]):
        print(f"  {name:16} {count}")
    conn.close()
    return 0


if __name__ == "__main__":
    sys.exit(main())
