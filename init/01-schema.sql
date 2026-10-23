-- Sample schema for the CDC learning project.
-- Debezium captures row-level changes from the Postgres write-ahead log (WAL)
-- via logical decoding, so every table it watches needs REPLICA IDENTITY FULL
-- (to include the "before" image on updates/deletes) and must belong to a
-- PUBLICATION that the connector reads from.

CREATE TABLE customers (
    id         SERIAL PRIMARY KEY,
    name       TEXT NOT NULL,
    email      TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE orders (
    id          SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(id),
    product     TEXT NOT NULL,
    amount      NUMERIC(10, 2) NOT NULL,
    status      TEXT NOT NULL DEFAULT 'pending',
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE customers REPLICA IDENTITY FULL;
ALTER TABLE orders REPLICA IDENTITY FULL;

CREATE PUBLICATION cdc_publication FOR TABLE customers, orders;

INSERT INTO customers (name, email) VALUES
    ('Ada Lovelace', 'ada@example.com'),
    ('Grace Hopper', 'grace@example.com'),
    ('Alan Turing', 'alan@example.com');

INSERT INTO orders (customer_id, product, amount, status) VALUES
    (1, 'Mechanical Keyboard', 129.99, 'pending'),
    (2, 'Noise Cancelling Headphones', 249.50, 'pending'),
    (3, 'Standing Desk', 399.00, 'shipped');
