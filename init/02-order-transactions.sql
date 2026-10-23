-- Multi-table transactions for the CDC learning project.
--
-- Adds a product catalog, stock levels and order line items. The generator
-- (generator/simulate.py) then changes several of these tables inside ONE
-- database transaction:
--
--   checkout = INSERT orders + INSERT order_items (1-3) + UPDATE inventory
--   cancel   = UPDATE inventory (restock) + DELETE orders
--              (ON DELETE CASCADE also deletes the order_items rows)
--
-- Debezium emits one change event per row, spread over several topics, so a
-- single transaction arrives in Kafka as many independent messages. With
-- provide.transaction.metadata=true (connectors/register-postgres.json) every
-- event carries its transaction id, and BEGIN/END markers on the
-- shop.transaction topic say how many events each transaction produced.
--
-- On a fresh database this runs automatically after 01-schema.sql, before
-- Debezium exists, so these rows reach Kafka via the initial snapshot. To add
-- it to a RUNNING stack, update the connector config first and then run this
-- file (see README, "Multi-table transactions"). It is safe to re-run.

CREATE TABLE IF NOT EXISTS products (
    id         SERIAL PRIMARY KEY,
    sku        TEXT NOT NULL UNIQUE,
    name       TEXT NOT NULL UNIQUE,
    price      NUMERIC(10, 2) NOT NULL CHECK (price > 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- A checkout that would take quantity below zero violates the CHECK and rolls
-- the whole transaction back, so none of its changes ever reach the WAL stream.
CREATE TABLE IF NOT EXISTS inventory (
    product_id INTEGER PRIMARY KEY REFERENCES products(id),
    quantity   INTEGER NOT NULL CHECK (quantity >= 0),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS order_items (
    id         SERIAL PRIMARY KEY,
    order_id   INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(id),
    quantity   INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10, 2) NOT NULL
);

CREATE INDEX IF NOT EXISTS order_items_order_id_idx ON order_items (order_id);

ALTER TABLE products    REPLICA IDENTITY FULL;
ALTER TABLE inventory   REPLICA IDENTITY FULL;
ALTER TABLE order_items REPLICA IDENTITY FULL;

-- SET (rather than ADD) lists the full membership and keeps this file
-- re-runnable; tables already in the publication are left untouched.
ALTER PUBLICATION cdc_publication
    SET TABLE customers, orders, products, inventory, order_items;

-- Catalog and opening stock, committed together: one transaction, two tables.
BEGIN;

INSERT INTO products (sku, name, price) VALUES
    ('KB-MECH-01',  'Mechanical Keyboard',         129.99),
    ('HP-ANC-01',   'Noise Cancelling Headphones', 249.50),
    ('DSK-STD-01',  'Standing Desk',               399.00),
    ('MON-UW-01',   'Ultrawide Monitor',           649.00),
    ('CHR-ERG-01',  'Ergonomic Chair',             459.00),
    ('DOCK-USBC-01','USB-C Dock',                  149.00),
    ('CAM-HD-01',   'Webcam',                       89.99),
    ('LMP-LED-01',  'Desk Lamp',                    49.99)
ON CONFLICT (sku) DO NOTHING;

-- Deliberately uneven stock so the scarce items sell out and exercise the
-- rollback path in the generator.
INSERT INTO inventory (product_id, quantity)
SELECT p.id, s.quantity
FROM (VALUES
    ('KB-MECH-01',   40),
    ('HP-ANC-01',    30),
    ('DSK-STD-01',   15),
    ('MON-UW-01',     8),
    ('CHR-ERG-01',   12),
    ('DOCK-USBC-01', 50),
    ('CAM-HD-01',    60),
    ('LMP-LED-01',   80)
) AS s (sku, quantity)
JOIN products p USING (sku)
ON CONFLICT (product_id) DO NOTHING;

COMMIT;

-- Give every pre-existing order one line item so that, for ALL orders,
-- orders.amount = SUM(order_items.quantity * order_items.unit_price).
-- On a running stack this is one large transaction: its END marker on
-- shop.transaction reports one event per backfilled order.
BEGIN;

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
SELECT o.id, p.id, 1, o.amount
FROM orders o
JOIN products p ON p.name = o.product
WHERE NOT EXISTS (SELECT 1 FROM order_items i WHERE i.order_id = o.id)
ORDER BY o.id;

COMMIT;
