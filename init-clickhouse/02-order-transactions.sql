-- ClickHouse side of the multi-table transaction demo
-- (source tables: init/02-order-transactions.sql).
--
--   1. products / inventory / order_items — the same three layers as
--      01-schema.sql: Kafka engine table -> materialized view ->
--      ReplacingMergeTree, plus a *_current view.
--   2. cdc_events — an append-only ledger of EVERY change event from all five
--      table topics, with the transaction each event belongs to and the
--      topic/partition/offset it was read from. It has its own Kafka engine
--      table and consumer group, so it reads the topics independently of the
--      per-table pipelines (and backfills them from the earliest offset).
--   3. cdc_transactions — the BEGIN/END markers from shop.transaction.
--   4. transaction_completeness — for each finished transaction, the number of
--      events its END marker promised vs. the number that reached cdc_events.
--
-- Transactions are keyed by the Postgres transaction id (xid). Debezium's
-- transaction "id" is documented as "<xid>:<lsn of the given operation>", so
-- it differs between BEGIN, each data event and END; only the xid prefix
-- (also sent as source.txId) identifies a transaction.

-- 1. Per-table state ---------------------------------------------------------

CREATE TABLE IF NOT EXISTS analytics.kafka_products_raw
(
    message String
)
ENGINE = Kafka
SETTINGS
    kafka_broker_list = 'kafka:9092',
    kafka_topic_list = 'shop.public.products',
    kafka_group_name = 'clickhouse-products',
    kafka_format = 'JSONAsString',
    kafka_num_consumers = 1;

-- inventory and order_items have 3 partitions (topic.creation rules in
-- connectors/register-postgres.json); one consumer reads all of them.
CREATE TABLE IF NOT EXISTS analytics.kafka_inventory_raw
(
    message String
)
ENGINE = Kafka
SETTINGS
    kafka_broker_list = 'kafka:9092',
    kafka_topic_list = 'shop.public.inventory',
    kafka_group_name = 'clickhouse-inventory',
    kafka_format = 'JSONAsString',
    kafka_num_consumers = 1;

CREATE TABLE IF NOT EXISTS analytics.kafka_order_items_raw
(
    message String
)
ENGINE = Kafka
SETTINGS
    kafka_broker_list = 'kafka:9092',
    kafka_topic_list = 'shop.public.order_items',
    kafka_group_name = 'clickhouse-order-items',
    kafka_format = 'JSONAsString',
    kafka_num_consumers = 1;

CREATE TABLE IF NOT EXISTS analytics.products
(
    id          Int32,
    sku         String,
    name        String,
    price       Decimal64(2),
    created_at  DateTime64(6),
    updated_at  DateTime64(6),
    _op         LowCardinality(String),
    _version    UInt64,
    _is_deleted UInt8
)
ENGINE = ReplacingMergeTree(_version)
ORDER BY id;

CREATE TABLE IF NOT EXISTS analytics.inventory
(
    product_id  Int32,
    quantity    Int32,
    updated_at  DateTime64(6),
    _op         LowCardinality(String),
    _version    UInt64,
    _is_deleted UInt8
)
ENGINE = ReplacingMergeTree(_version)
ORDER BY product_id;

CREATE TABLE IF NOT EXISTS analytics.order_items
(
    id          Int32,
    order_id    Int32,
    product_id  Int32,
    quantity    Int32,
    unit_price  Decimal64(2),
    _op         LowCardinality(String),
    _version    UInt64,
    _is_deleted UInt8
)
ENGINE = ReplacingMergeTree(_version)
ORDER BY id;

CREATE MATERIALIZED VIEW IF NOT EXISTS analytics.mv_products
TO analytics.products AS
SELECT
    JSONExtractInt(_row, 'id')                                        AS id,
    JSONExtractString(_row, 'sku')                                    AS sku,
    JSONExtractString(_row, 'name')                                   AS name,
    toDecimal64OrZero(JSONExtractString(_row, 'price'), 2)            AS price,
    parseDateTime64BestEffortOrZero(JSONExtractString(_row, 'created_at'), 6) AS created_at,
    parseDateTime64BestEffortOrZero(JSONExtractString(_row, 'updated_at'), 6) AS updated_at,
    _op,
    _version,
    _is_deleted
FROM
(
    SELECT
        JSONExtractString(message, 'op') AS _op,
        if(_op = 'd', JSONExtractRaw(message, 'before'), JSONExtractRaw(message, 'after')) AS _row,
        JSONExtractUInt(message, 'ts_ms') AS _version,
        if(_op = 'd', 1, 0) AS _is_deleted
    FROM analytics.kafka_products_raw
    WHERE length(message) > 0
);

CREATE MATERIALIZED VIEW IF NOT EXISTS analytics.mv_inventory
TO analytics.inventory AS
SELECT
    JSONExtractInt(_row, 'product_id')                                AS product_id,
    JSONExtractInt(_row, 'quantity')                                  AS quantity,
    parseDateTime64BestEffortOrZero(JSONExtractString(_row, 'updated_at'), 6) AS updated_at,
    _op,
    _version,
    _is_deleted
FROM
(
    SELECT
        JSONExtractString(message, 'op') AS _op,
        if(_op = 'd', JSONExtractRaw(message, 'before'), JSONExtractRaw(message, 'after')) AS _row,
        JSONExtractUInt(message, 'ts_ms') AS _version,
        if(_op = 'd', 1, 0) AS _is_deleted
    FROM analytics.kafka_inventory_raw
    WHERE length(message) > 0
);

CREATE MATERIALIZED VIEW IF NOT EXISTS analytics.mv_order_items
TO analytics.order_items AS
SELECT
    JSONExtractInt(_row, 'id')                                        AS id,
    JSONExtractInt(_row, 'order_id')                                  AS order_id,
    JSONExtractInt(_row, 'product_id')                                AS product_id,
    JSONExtractInt(_row, 'quantity')                                  AS quantity,
    toDecimal64OrZero(JSONExtractString(_row, 'unit_price'), 2)       AS unit_price,
    _op,
    _version,
    _is_deleted
FROM
(
    SELECT
        JSONExtractString(message, 'op') AS _op,
        if(_op = 'd', JSONExtractRaw(message, 'before'), JSONExtractRaw(message, 'after')) AS _row,
        JSONExtractUInt(message, 'ts_ms') AS _version,
        if(_op = 'd', 1, 0) AS _is_deleted
    FROM analytics.kafka_order_items_raw
    WHERE length(message) > 0
);

CREATE VIEW IF NOT EXISTS analytics.products_current AS
SELECT id, sku, name, price, created_at, updated_at
FROM analytics.products FINAL
WHERE _is_deleted = 0;

CREATE VIEW IF NOT EXISTS analytics.inventory_current AS
SELECT product_id, quantity, updated_at
FROM analytics.inventory FINAL
WHERE _is_deleted = 0;

CREATE VIEW IF NOT EXISTS analytics.order_items_current AS
SELECT id, order_id, product_id, quantity, unit_price
FROM analytics.order_items FINAL
WHERE _is_deleted = 0;

-- 2. Change-event ledger -----------------------------------------------------

CREATE TABLE IF NOT EXISTS analytics.kafka_cdc_events_raw
(
    message String
)
ENGINE = Kafka
SETTINGS
    kafka_broker_list = 'kafka:9092',
    kafka_topic_list = 'shop.public.customers,shop.public.orders,shop.public.products,shop.public.inventory,shop.public.order_items',
    kafka_group_name = 'clickhouse-cdc-events',
    kafka_format = 'JSONAsString',
    kafka_num_consumers = 1;

-- total_order = 0 means the event carried no transaction metadata: snapshot
-- reads, or changes captured before provide.transaction.metadata was enabled.
CREATE TABLE IF NOT EXISTS analytics.cdc_events
(
    txid             UInt64,
    total_order      UInt64,
    collection_order UInt64,
    data_collection  LowCardinality(String),
    op               LowCardinality(String),
    row_key          String,
    lsn              UInt64,
    committed_at     DateTime64(3),
    kafka_topic      LowCardinality(String),
    kafka_partition  UInt64,
    kafka_offset     UInt64
)
ENGINE = MergeTree
ORDER BY (txid, total_order);

CREATE MATERIALIZED VIEW IF NOT EXISTS analytics.mv_cdc_events
TO analytics.cdc_events AS
SELECT
    JSONExtractUInt(message, 'source', 'txId')                          AS txid,
    JSONExtractUInt(message, 'transaction', 'total_order')              AS total_order,
    JSONExtractUInt(message, 'transaction', 'data_collection_order')    AS collection_order,
    concat(JSONExtractString(message, 'source', 'schema'), '.',
           JSONExtractString(message, 'source', 'table'))               AS data_collection,
    JSONExtractString(message, 'op')                                    AS op,
    _key                                                                AS row_key,
    JSONExtractUInt(message, 'source', 'lsn')                           AS lsn,
    fromUnixTimestamp64Milli(JSONExtractInt(message, 'source', 'ts_ms')) AS committed_at,
    _topic                                                              AS kafka_topic,
    _partition                                                          AS kafka_partition,
    _offset                                                             AS kafka_offset
FROM analytics.kafka_cdc_events_raw
WHERE length(message) > 0;

-- 3. Transaction markers -----------------------------------------------------

CREATE TABLE IF NOT EXISTS analytics.kafka_transactions_raw
(
    message String
)
ENGINE = Kafka
SETTINGS
    kafka_broker_list = 'kafka:9092',
    kafka_topic_list = 'shop.transaction',
    kafka_group_name = 'clickhouse-transactions',
    kafka_format = 'JSONAsString',
    kafka_num_consumers = 1;

-- event_count and data_collections are only populated on END markers.
CREATE TABLE IF NOT EXISTS analytics.cdc_transactions
(
    txid             UInt64,
    status           LowCardinality(String),
    event_count      UInt64,
    data_collections Map(String, UInt64),
    debezium_id      String,
    committed_at     DateTime64(3)
)
ENGINE = MergeTree
ORDER BY (txid, status);

CREATE MATERIALIZED VIEW IF NOT EXISTS analytics.mv_cdc_transactions
TO analytics.cdc_transactions AS
SELECT
    toUInt64OrZero(splitByChar(':', JSONExtractString(message, 'id'))[1]) AS txid,
    JSONExtractString(message, 'status')                                   AS status,
    JSONExtractUInt(message, 'event_count')                                AS event_count,
    mapFromArrays(arrayMap(x -> x.1, collections),
                  arrayMap(x -> x.2, collections))                         AS data_collections,
    JSONExtractString(message, 'id')                                       AS debezium_id,
    fromUnixTimestamp64Milli(JSONExtractInt(message, 'ts_ms'))             AS committed_at
FROM
(
    SELECT
        message,
        JSONExtract(message, 'data_collections',
                    'Array(Tuple(data_collection String, event_count UInt64))') AS collections
    FROM analytics.kafka_transactions_raw
    WHERE length(message) > 0
);

-- 4. Completeness check ------------------------------------------------------

-- is_complete = 0 means the END marker has arrived but some of the
-- transaction's events have not (yet) landed: the transaction is in flight.
CREATE VIEW IF NOT EXISTS analytics.transaction_completeness AS
SELECT
    t.txid                                AS txid,
    t.committed_at                        AS committed_at,
    t.expected_events                     AS expected_events,
    e.received_events                     AS received_events,
    t.expected_by_table                   AS expected_by_table,
    e.received_by_table                   AS received_by_table,
    e.received_events = t.expected_events AS is_complete
FROM
(
    -- After a connector restart Debezium can re-send a transaction's markers,
    -- with event_count 0 if its events were already delivered: keep the max.
    SELECT
        txid,
        max(committed_at)                     AS committed_at,
        max(event_count)                      AS expected_events,
        argMax(data_collections, event_count) AS expected_by_table
    FROM analytics.cdc_transactions
    WHERE status = 'END'
    GROUP BY txid
) AS t
LEFT JOIN
(
    -- Kafka delivery is at-least-once; total_order is unique within a
    -- transaction, so DISTINCT counts each event once.
    SELECT
        txid,
        count()                                AS received_events,
        sumMap(map(data_collection, toUInt64(1))) AS received_by_table
    FROM
    (
        SELECT DISTINCT txid, total_order, data_collection
        FROM analytics.cdc_events
        WHERE total_order > 0
    )
    GROUP BY txid
) AS e ON e.txid = t.txid;
