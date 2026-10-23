# CDC Platform Learning

A hands-on playground for **Change Data Capture (CDC)**: streaming row-level
changes (inserts/updates/deletes) out of a database in near real-time,
instead of batch-polling it.

## How this stack works

```
     SOURCE DB                                                      TARGET DB
  postgres / "shop"                                          postgres-target / "shop_replica"
         |                                                                ^
         | WAL --logical decoding-->                                      | SQL upsert/delete
         v                                                                |
  Debezium source connector  --> Kafka topics -->  Debezium JDBC sink connector
  (shop-postgres-connector)      shop.public.*        (shop-jdbc-sink)
                                      |
                                      +--> consumer/consume.py (independent reader)
```

1. **Postgres** runs with `wal_level=logical`, so every committed change is
   recorded in its write-ahead log (WAL) in a decodable format.
2. A **PUBLICATION** (`cdc_publication`) tells Postgres which tables to
   expose to logical replication consumers.
3. **Debezium**, running inside **Kafka Connect**, acts as a replication
   client: it opens a replication slot against Postgres, reads the WAL
   stream, and turns each change into a structured JSON event
   (`before` / `after` / `op` / `source` metadata).
4. Debezium publishes one Kafka topic per table (e.g. `shop.public.orders`),
   with one event per change — in order, exactly as it happened.
5. Any number of **consumers** can read those topics independently: a
   warehouse loader, a cache invalidator, a search indexer, this repo's demo
   script, etc. This decouples "capturing changes" from "doing something
   with them."
6. A **sink connector** (`shop-jdbc-sink`) is one such consumer: it reads
   those same topics and applies each change as SQL against a *second*
   database (`shop_replica`), keeping it in sync with the first. Note that
   the sink is just a normal Kafka consumer — it has no direct connection to
   the source database at all.

This is **log-based CDC**, the production-grade approach (used by Debezium,
AWS DMS, etc.) — as opposed to trigger-based CDC (DB triggers write to a
shadow table) or query-based CDC (polling with a timestamp/version column,
which can miss deletes and creates load on the source DB).

## Prerequisites

This machine has `podman` (not Docker) with `podman-compose` installed, and
the `podman-compose` commands below assume that. If you have Docker instead,
swap `podman compose` for `docker compose`.

## 1. Start the stack

```bash
podman compose up -d
```

This starts:
- `postgres` (localhost:**5432**) — the **source/main** DB, `shop`
  (`customers`, `orders`, `products`, `inventory`, `order_items` tables + sample rows,
  see [init/01-schema.sql](init/01-schema.sql) and
  [init/02-order-transactions.sql](init/02-order-transactions.sql))
- `postgres-target` (localhost:**5433**) — the **target** DB, `shop_replica`,
  starts completely empty; the sink connector creates its tables
- `kafka` (localhost:29092 from your host, `kafka:9092` inside the compose network)
- `connect` — Kafka Connect + Debezium (localhost:8083, REST API)
- `kafka-ui` (http://localhost:8080) — browse topics/messages/connectors visually

Give it ~30-60s for Kafka Connect to finish starting.

## 2. Register the connectors

Neither connector runs until registered via Kafka Connect's REST API.

**Source** (Postgres WAL → Kafka):

```bash
curl -X POST -H "Content-Type: application/json" \
  http://localhost:8083/connectors \
  -d @connectors/register-postgres.json
```

**Sink** (Kafka → target Postgres):

```bash
curl -X POST -H "Content-Type: application/json" \
  http://localhost:8083/connectors \
  -d @connectors/register-jdbc-sink.json
```

Check both are running:

```bash
curl -s http://localhost:8083/connectors/shop-postgres-connector/status
curl -s http://localhost:8083/connectors/shop-jdbc-sink/status
```

On registration, the source takes an initial **snapshot** of existing rows
(as `op: "r"` read events) then streams live WAL changes. The sink reads
from the beginning of the topics, so it backfills that snapshot into the
target DB before following along live.

### What the sink config is doing

Two Single Message Transforms (SMTs) in [connectors/register-jdbc-sink.json](connectors/register-jdbc-sink.json)
do the heavy lifting:

- **`unwrap`** (`ExtractNewRecordState`) — the sink wants a plain row, but
  Debezium emits a nested `{before, after, op, source}` envelope. This SMT
  flattens it to just the `after` row. `delete.tombstone.handling.mode:
  tombstone` keeps delete tombstones flowing so deletes propagate rather
  than being silently dropped.
- **`route`** (`RegexRouter`) — rewrites topic `shop.public.orders` to just
  `orders`, so the sink writes to a sensibly-named target table instead of
  one literally called `shop.public.orders`.

Plus `insert.mode: upsert` (so re-delivered events are idempotent rather
than causing duplicate-key errors) and `schema.evolution: basic` (so the
sink issues `CREATE TABLE` / `ALTER TABLE` itself).

## 3. Verify the two databases are in sync

```bash
podman exec cdc-postgres psql -U cdcuser -d shop -c "SELECT id,product,status FROM orders ORDER BY id;"
podman exec cdc-postgres-target psql -U sinkuser -d shop_replica -c "SELECT id,product,status FROM orders ORDER BY id;"
```

Make a change in the **source** and re-run both queries to watch it appear
downstream within a few seconds:

```bash
podman exec cdc-postgres psql -U cdcuser -d shop -c "DELETE FROM orders WHERE id = 2;"
```

## 4. Watch raw change events arrive

Install the consumer's dependency and run it:

```bash
pip install -r consumer/requirements.txt
python consumer/consume.py
```

Leave it running. You should immediately see the snapshot events for the
rows seeded in `init/01-schema.sql` and `init/02-order-transactions.sql`,
then each live change tagged with its transaction, plus the `BEGIN`/`END`
markers from `shop.transaction` (see [Multi-table transactions](#multi-table-transactions)).

(Alternatively, browse the `shop.*` topics in kafka-ui at http://localhost:8080.)

## 5. Make some changes and watch them stream through

In another terminal:

```bash
podman exec -it cdc-postgres psql -U cdcuser -d shop
```

Then try each of these and watch the consumer print the resulting event:

```sql
-- INSERT -> op "c", after populated, before null
INSERT INTO customers (name, email) VALUES ('Margaret Hamilton', 'margaret@example.com');

-- UPDATE -> op "u", both before and after populated
UPDATE orders SET status = 'shipped' WHERE id = 1;

-- DELETE -> op "d", before populated, after null
DELETE FROM orders WHERE id = 2;
```

Notice:
- Events arrive in the same order the statements committed.
- `UPDATE`/`DELETE` events include the full **before** image because the
  tables have `REPLICA IDENTITY FULL` — without that, Postgres only logs
  the primary key for deletes/updates, and Debezium can't tell you what
  the row used to look like.

## Multi-table transactions

A real checkout changes several tables at once.
[init/02-order-transactions.sql](init/02-order-transactions.sql) adds a product
catalog (`products`), stock levels (`inventory`) and order line items
(`order_items`), and [generator/simulate.py](generator/simulate.py) changes them
together inside single database transactions:

| Generator operation | What its one transaction does |
|---|---|
| `checkout` | `INSERT orders`, then for each of 1-3 line items `INSERT order_items` + `UPDATE inventory` |
| `cancel_order` | `UPDATE inventory` (restock) + `DELETE orders`; `ON DELETE CASCADE` also deletes the order's `order_items` |
| `checkout` that oversells | fails `CHECK (quantity >= 0)` on `inventory` and **rolls back**: nothing is captured |

Postgres commits each transaction atomically, but Debezium emits one event per
changed row, on one topic per table. A 3-item checkout becomes 7 independent
Kafka messages:

```
                          +--> shop.public.orders        1 event
  one Postgres COMMIT  ---+--> shop.public.order_items   3 events, spread over 3 partitions
  (xid 1654)              +--> shop.public.inventory     3 events, spread over 3 partitions
                          +--> shop.transaction          BEGIN, END {"event_count": 7, ...}
```

Kafka only orders messages *within* a partition, so a consumer can see part of
a transaction: an order whose items haven't arrived yet, or stock that dropped
for an order it can't see. `"provide.transaction.metadata": "true"` in
[connectors/register-postgres.json](connectors/register-postgres.json) adds
what's needed to reassemble them:

- Every data event gets a `transaction` block: its position in the whole
  transaction (`total_order`) and among that table's events in it
  (`data_collection_order`):

  ```json
  "transaction": {"id": "1654:32233448", "total_order": 2, "data_collection_order": 1}
  ```

- The `shop.transaction` topic gets a `BEGIN` and an `END` marker for every
  transaction. `END` says how many events to expect, per table:

  ```json
  {"status": "END", "id": "1654:32234720", "event_count": 7,
   "data_collections": [{"data_collection": "public.inventory", "event_count": 3},
                        {"data_collection": "public.orders", "event_count": 1},
                        {"data_collection": "public.order_items", "event_count": 3}],
   "ts_ms": ...}
  ```

A consumer that needs transactional consistency buffers events per transaction
and applies them only once it holds everything the `END` marker promised. Note
that the `id` differs on every message of the same transaction; see
[Gotchas](#gotchas-worth-understanding).

### New topics

| Topic | Partitions | Written by |
|---|---|---|
| `shop.public.products` | 1 | the catalog seed |
| `shop.public.inventory` | 3 | every checkout, cancel and restock |
| `shop.public.order_items` | 3 | every checkout and cancel |
| `shop.transaction` | 1 | a `BEGIN`/`END` pair per transaction |

Kafka Connect creates these itself from the `topic.creation.*` rules in the
connector config, rather than relying on the broker's auto-create defaults: a
`default` group (1 partition) and a `highvolume` group giving topics that
match `shop\.public\.(order_items|inventory)` 3 partitions. Debezium keys each
message by the row's primary key, so every change to one row lands on the same
partition and stays in order; ordering is lost only *across* rows, partitions
and topics. The rules apply only when a topic is created, so the existing
`customers` and `orders` topics keep their single partition.

### Applying it

On a **fresh stack** nothing extra is needed: both `02-order-transactions.sql`
files run on first start, and the connector's initial snapshot covers the new
tables. Snapshot events carry `"transaction": null`; transaction metadata
starts with the first live change.

To add it to a **running stack**, order matters:

```bash
# 1. Reconfigure the connector FIRST, so the new tables are already in
#    table.include.list when rows arrive. PUT takes only the inner "config" object.
python3 -c 'import json; print(json.dumps(json.load(open("connectors/register-postgres.json"))["config"]))' \
  | curl -s -X PUT -H "Content-Type: application/json" --data @- \
      http://localhost:8083/connectors/shop-postgres-connector/config

# 2. Create the tables, add them to the publication, seed them, and backfill one
#    line item per existing order (a single transaction, so one large END marker).
podman exec -i cdc-postgres psql -U cdcuser -d shop -v ON_ERROR_STOP=1 \
  < init/02-order-transactions.sql

# 3. Create the ClickHouse side; it reads the new topics from the beginning.
podman exec -i cdc-clickhouse clickhouse-client --user olapuser --password olappass \
  --multiquery < init-clickhouse/02-order-transactions.sql
```

If you run step 2 first, Debezium streams the new rows while their tables are
still excluded and drops them, and it won't snapshot those tables later either
(backfilling a table added to a running connector takes an incremental
snapshot via a signal table, which this repo doesn't set up). Both SQL files
are safe to re-run.

### Reading transactions back

[consumer/consume.py](consumer/consume.py) also reads the new topics and
`shop.transaction`, and tags each event with its transaction. Real output from
this repo, filtered to one transaction:

```
[shop.public.order_items p0] CREATE  tx=1654 event #4 (#2 in this table)
[shop.public.orders p0] CREATE  tx=1654 event #1 (#1 in this table)
[shop.transaction p0] BEGIN tx=1654
[shop.transaction p0] END   tx=1654: 7 events (public.inventory=3, public.orders=1, public.order_items=3)
[shop.public.inventory p0] UPDATE  tx=1654 event #5 (#2 in this table)
[shop.public.inventory p1] UPDATE  tx=1654 event #7 (#3 in this table)
[shop.public.inventory p2] UPDATE  tx=1654 event #3 (#1 in this table)
[shop.public.order_items p1] CREATE  tx=1654 event #2 (#1 in this table)
[shop.public.order_items p1] CREATE  tx=1654 event #6 (#3 in this table)
```

Event #4 arrived before #1, `BEGIN` after two of the events, and `END` before
most of them: a consumer reading several topics and partitions gets no
ordering across them.

ClickHouse ([init-clickhouse/02-order-transactions.sql](init-clickhouse/02-order-transactions.sql))
gets `products_current`, `inventory_current` and `order_items_current`, built
like the existing tables, plus:

- `cdc_events`: a ledger of every change event from the five table topics,
  with the transaction's xid, `total_order`, table, op, key, and the Kafka
  topic/partition/offset it came from. It uses its own consumer group,
  independent of the per-table pipelines.
- `cdc_transactions`: the `BEGIN`/`END` markers.
- `transaction_completeness`: for each transaction, the events its `END`
  marker promised vs. the events that reached `cdc_events`.

Query them in the Play UI at http://localhost:8123/play (user `olapuser`,
password `olappass`) or via
`podman exec -it cdc-clickhouse clickhouse-client --user olapuser --password olappass`:

```sql
-- The latest multi-table transaction, as it was scattered over topics and partitions
SELECT total_order, data_collection, op, row_key, kafka_topic, kafka_partition
FROM analytics.cdc_events
WHERE txid = (SELECT txid FROM analytics.transaction_completeness
              WHERE length(mapKeys(expected_by_table)) > 1
              ORDER BY committed_at DESC LIMIT 1)
ORDER BY total_order;

-- Has every transaction fully arrived?
SELECT count() AS transactions, countIf(NOT is_complete) AS in_flight
FROM analytics.transaction_completeness;
```

`in_flight` is normally 0; while the generator runs it can briefly count
transactions whose `END` marker landed before all of their events.

### Exercises

1. **Torn reads.** Each ClickHouse table follows its own topic through its own
   consumer, at its own pace. Pause the `order_items` pipeline while the
   generator runs, and look for orders without items:

   ```sql
   DETACH TABLE analytics.mv_order_items;   -- shop.public.order_items stops being consumed

   SELECT count() FROM analytics.orders_current
   WHERE id NOT IN (SELECT order_id FROM analytics.order_items_current);

   ATTACH TABLE analytics.mv_order_items;   -- resumes from the last committed offset
   ```

   The count climbs while the view is detached (39 orders after a 12-second
   run here) and returns to 0 after `ATTACH`, with nothing lost. Meanwhile
   `transaction_completeness` reports every transaction complete, because the
   ledger reads the topics through its own consumer group: whether a
   transaction looks complete depends on which consumer is asking.

2. **Rollbacks never reach Kafka.** When a checkout oversells, the generator
   prints something like
   `ROLLBACK checkout: Ergonomic Chair out of stock; order 394 and its items never reach Kafka`.
   The order row and line items it had already inserted are rolled back too,
   and Debezium only decodes committed transactions:

   ```sql
   SELECT count() FROM analytics.cdc_events                     -- 0
   WHERE data_collection = 'public.orders' AND row_key = '{"id":394}';
   ```

   The id is still used up (sequences aren't transactional), so `orders.id`
   has a gap there. A cancelled order also leaves a gap, but it has a `c` and
   a `d` event in `cdc_events`.

3. **Cascades are captured.** `cancel_order` deletes only the `orders` row, yet
   its transaction also holds a delete event for each `order_items` row that
   `ON DELETE CASCADE` removed, right after the parent's:

   ```sql
   SELECT total_order, data_collection, op, row_key
   FROM analytics.cdc_events
   WHERE txid = (SELECT txid FROM analytics.cdc_events
                 WHERE data_collection = 'public.order_items' AND op = 'd'
                 ORDER BY lsn DESC LIMIT 1)
   ORDER BY total_order;
   ```

## Gotchas worth understanding

- **Decimal columns are base64 by default.** Debezium represents Postgres
  `NUMERIC`/`DECIMAL` columns using Kafka Connect's `Decimal` logical type,
  which the JSON converter serializes as base64-encoded bytes (you'd see
  `amount: "Msc="` instead of `129.99`). `connectors/register-postgres.json`
  sets `"decimal.handling.mode": "string"` to get plain decimal strings
  instead. **The tradeoff is visible in the target DB**: `orders.amount` is
  `numeric(10,2)` in the source but auto-created as `text` in `shop_replica`,
  so arithmetic downstream needs a cast. Values stay correct either way —
  it's the type fidelity you lose.
- **Deletes need tombstones, end to end.** The source sets
  `"tombstones.on.delete": "true"` and the sink SMT sets
  `delete.tombstone.handling.mode: tombstone`. If either side drops them,
  inserts and updates still replicate perfectly while deletes silently
  vanish — the target slowly accumulates rows the source no longer has.
  This is an easy bug to miss because nothing errors.
- **The replicated schema isn't a full copy.** The sink creates tables and
  primary keys, but not foreign keys, sequences/identity defaults, check
  constraints, or indexes. `shop_replica` is a data mirror, not a
  structural clone — fine for analytics/read replicas, not a backup.
- **Consumer groups remember their position.** If you stop and restart
  `consume.py`, it resumes from its last committed offset — it will *not*
  replay the snapshot again. That's correct Kafka behavior (the whole point
  of consumer groups), but it surprises people expecting every run to
  replay history. To see the snapshot again, use a different `group.id` in
  `consumer/consume.py`, or delete the group:
  `podman exec cdc-kafka kafka-consumer-groups --bootstrap-server localhost:9092 --delete --group cdc-learning-consumer`.
- **Group a transaction's events by xid, not by the full `transaction.id`.**
  Debezium documents the PostgreSQL id as `<xid>:<LSN of the given operation>`,
  so it differs on every message of one transaction (tx 1654: `BEGIN`
  `1654:32233136`, one of its events `1654:32233448`, `END` `1654:32234720`).
  Only the xid prefix, also sent on every data event as `source.txId`, is
  shared, so `consume.py` and the ClickHouse tables key on it. Postgres xids
  are 32-bit and eventually wrap around, so don't treat them as unique forever.
- **Transaction markers can repeat, or be empty.** You may see a
  `BEGIN`/`END` pair with `"event_count": 0`; this repo got one right after
  the connector was reconfigured and restarted. Combined with Kafka's
  at-least-once delivery, consumers must tolerate repeats:
  `transaction_completeness` keeps the largest `event_count` per xid and
  counts each `(xid, total_order)` once.

## 6. Tear down

```bash
podman compose down -v
```

(`-v` also removes both Postgres data volumes so the next `up` starts clean.)

## Project layout

- [docker-compose.yml](docker-compose.yml) — source Postgres, target Postgres, Kafka (KRaft, single node), Kafka Connect + Debezium, Kafka UI
- [init/01-schema.sql](init/01-schema.sql) — sample schema, publication, seed data (source DB only)
- [init/02-order-transactions.sql](init/02-order-transactions.sql) — products, inventory and order_items tables, publication update, seed and backfill ([multi-table transactions](#multi-table-transactions))
- [init-clickhouse/02-order-transactions.sql](init-clickhouse/02-order-transactions.sql) — ClickHouse tables for the new topics, change-event ledger, transaction completeness view
- [connectors/register-postgres.json](connectors/register-postgres.json) — Debezium **source** connector config
- [connectors/register-jdbc-sink.json](connectors/register-jdbc-sink.json) — Debezium **JDBC sink** connector config
- [consumer/consume.py](consumer/consume.py) — minimal Python consumer that pretty-prints change events

## Where to go next

- Try `table.include.list` with more tables, or filter/transform events
  with Debezium's **Single Message Transforms (SMTs)**.
- Break things on purpose: stop `connect`, make Postgres changes while it's
  down, restart it, and see both the source resume from its replication slot
  and the sink catch the target DB back up — with no data loss.
- Inspect the WAL plumbing directly: `SELECT * FROM pg_replication_slots;`
  on the source shows `confirmed_flush_lsn`, the point Debezium has
  acknowledged. It stops advancing when tables go idle, so Postgres retains
  WAL indefinitely — adding `heartbeat.interval.ms` to the source connector
  keeps it moving.
- Point a *different* kind of sink at the same topics (Elasticsearch, S3) to
  see the real payoff of the Kafka middle layer: one capture, many
  independent destinations.
