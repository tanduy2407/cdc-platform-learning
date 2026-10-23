"""Pretty-print Debezium change events as they arrive on Kafka.

Each Debezium record has an envelope with:
  - op:          "c" (create), "u" (update), "d" (delete), "r" (snapshot read)
  - before:      row state before the change (null for inserts)
  - after:       row state after the change (null for deletes)
  - source:      metadata about where the change came from (table, lsn, ts_ms, ...)
  - transaction: which transaction the change belongs to, and its position in
                 it (null for snapshot reads)

Reads the per-table topics (topic.prefix "shop" + schema + table, per
connectors/register-postgres.json) plus "shop.transaction", where Debezium
writes a BEGIN and an END marker for every transaction. The END marker says
how many events the transaction produced, per table.

One consumer reads all of these topics, but Kafka only orders messages within
a single partition, so a transaction's events can print before its BEGIN or
after its END, interleaved with other transactions.
"""

import json
import sys

from confluent_kafka import Consumer

BOOTSTRAP_SERVERS = "localhost:29092"
TRANSACTION_TOPIC = "shop.transaction"
TOPICS = [
    "shop.public.customers",
    "shop.public.orders",
    "shop.public.products",
    "shop.public.inventory",
    "shop.public.order_items",
    TRANSACTION_TOPIC,
]

OP_LABELS = {
    "c": "CREATE",
    "u": "UPDATE",
    "d": "DELETE",
    "r": "SNAPSHOT",
}


def unwrap(raw_bytes):
    if raw_bytes is None:
        return None
    data = json.loads(raw_bytes.decode("utf-8"))
    # When the connector's converter has schemas enabled, the real
    # record is nested under "payload"; otherwise it's the top level.
    return data.get("payload", data) if isinstance(data, dict) else data


def xid(debezium_tx_id):
    # Debezium's Postgres transaction id is "<xid>:<lsn>". The LSN part differs
    # between events of the same transaction, so only the xid identifies it.
    return str(debezium_tx_id).split(":", 1)[0]


def describe_marker(marker):
    status = marker.get("status")
    if status != "END":
        return f"{status} tx={xid(marker.get('id'))}"
    per_table = ", ".join(f"{c['data_collection']}={c['event_count']}"
                          for c in marker.get("data_collections") or [])
    return (f"END   tx={xid(marker.get('id'))}: "
            f"{marker.get('event_count')} events ({per_table})")


def main():
    consumer = Consumer({
        "bootstrap.servers": BOOTSTRAP_SERVERS,
        "group.id": "cdc-learning-consumer",
        "auto.offset.reset": "earliest",
    })
    consumer.subscribe(TOPICS)

    print(f"Listening on {TOPICS} ...\n")
    try:
        while True:
            msg = consumer.poll(1.0)
            if msg is None:
                continue
            if msg.error():
                print(f"consumer error: {msg.error()}", file=sys.stderr)
                continue

            payload = unwrap(msg.value())
            where = f"{msg.topic()} p{msg.partition()}"
            if payload is None:
                print(f"[{where}] tombstone for key={msg.key()}")
                continue

            if msg.topic() == TRANSACTION_TOPIC:
                print(f"[{where}] {describe_marker(payload)}\n")
                continue

            op = OP_LABELS.get(payload.get("op"), payload.get("op"))
            before = payload.get("before")
            after = payload.get("after")
            tx = payload.get("transaction")
            tx_info = ""
            if tx:
                tx_info = (f"  tx={xid(tx['id'])} event #{tx['total_order']}"
                           f" (#{tx['data_collection_order']} in this table)")

            print(f"[{where}] {op}{tx_info}")
            if before is not None:
                print(f"  before: {before}")
            if after is not None:
                print(f"  after:  {after}")
            print()
    except KeyboardInterrupt:
        pass
    finally:
        consumer.close()


if __name__ == "__main__":
    main()
