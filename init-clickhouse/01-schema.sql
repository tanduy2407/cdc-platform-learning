-- ClickHouse (OLAP target) schema for the CDC pipeline.
--
-- Three layers per table:
--   1. kafka_*_raw   — Kafka engine table. ClickHouse PULLS from Kafka itself;
--                      there is no Kafka Connect sink connector involved.
--                      Reads each message as one raw JSON string.
--   2. mv_*          — Materialized view. Fires on each batch arriving in the
--                      Kafka table, parses the Debezium envelope, and inserts
--                      the result into the analytical table below.
--   3. customers/orders — ReplacingMergeTree. The actual queryable table.
--
-- Why ReplacingMergeTree: OLAP engines are append-only and have no real UPDATE
-- or DELETE. Every CDC event is therefore inserted as a new row, and
-- ReplacingMergeTree collapses rows sharing an ORDER BY key, keeping only the
-- one with the highest _version. Deletes are "soft": we keep the row but set
-- _is_deleted = 1 and filter it out at query time.

CREATE TABLE IF NOT EXISTS analytics.kafka_customers_raw
(
    message String
)
ENGINE = Kafka
SETTINGS
    kafka_broker_list = 'kafka:9092',
    kafka_topic_list = 'shop.public.customers',
    kafka_group_name = 'clickhouse-customers',
    kafka_format = 'JSONAsString',
    kafka_num_consumers = 1;

CREATE TABLE IF NOT EXISTS analytics.kafka_orders_raw
(
    message String
)
ENGINE = Kafka
SETTINGS
    kafka_broker_list = 'kafka:9092',
    kafka_topic_list = 'shop.public.orders',
    kafka_group_name = 'clickhouse-orders',
    kafka_format = 'JSONAsString',
    kafka_num_consumers = 1;

CREATE TABLE IF NOT EXISTS analytics.customers
(
    id          Int32,
    name        String,
    email       String,
    created_at  DateTime64(6),
    _op         LowCardinality(String),
    _version    UInt64,
    _is_deleted UInt8
)
ENGINE = ReplacingMergeTree(_version)
ORDER BY id;

CREATE TABLE IF NOT EXISTS analytics.orders
(
    id          Int32,
    customer_id Int32,
    product     String,
    amount      Decimal64(2),
    status      LowCardinality(String),
    created_at  DateTime64(6),
    updated_at  DateTime64(6),
    _op         LowCardinality(String),
    _version    UInt64,
    _is_deleted UInt8
)
ENGINE = ReplacingMergeTree(_version)
ORDER BY id;

-- On a delete event Debezium sets "after": null, so the row data lives in
-- "before" instead. The inner subquery picks whichever side is populated.
CREATE MATERIALIZED VIEW IF NOT EXISTS analytics.mv_customers
TO analytics.customers AS
SELECT
    JSONExtractInt(_row, 'id')                                        AS id,
    JSONExtractString(_row, 'name')                                   AS name,
    JSONExtractString(_row, 'email')                                  AS email,
    parseDateTime64BestEffortOrZero(JSONExtractString(_row, 'created_at'), 6) AS created_at,
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
    FROM analytics.kafka_customers_raw
    WHERE length(message) > 0
);

-- amount is carried as a string on the wire (decimal.handling.mode=string),
-- so cast it back to a real Decimal here — unlike the JDBC sink, a
-- materialized view lets us choose the target type explicitly.
CREATE MATERIALIZED VIEW IF NOT EXISTS analytics.mv_orders
TO analytics.orders AS
SELECT
    JSONExtractInt(_row, 'id')                                        AS id,
    JSONExtractInt(_row, 'customer_id')                               AS customer_id,
    JSONExtractString(_row, 'product')                                AS product,
    toDecimal64OrZero(JSONExtractString(_row, 'amount'), 2)           AS amount,
    JSONExtractString(_row, 'status')                                 AS status,
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
    FROM analytics.kafka_orders_raw
    WHERE length(message) > 0
);

-- Convenience views: the "current state" of each table, with superseded
-- versions collapsed (FINAL) and soft-deleted rows filtered out.
CREATE VIEW IF NOT EXISTS analytics.customers_current AS
SELECT id, name, email, created_at
FROM analytics.customers FINAL
WHERE _is_deleted = 0;

CREATE VIEW IF NOT EXISTS analytics.orders_current AS
SELECT id, customer_id, product, amount, status, created_at, updated_at
FROM analytics.orders FINAL
WHERE _is_deleted = 0;
