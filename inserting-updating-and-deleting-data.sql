-- Inserting a Row
USE sql_store;

INSERT INTO customers
VALUES (DEFAULT,
        'John',
        'Smith',
        '1990-01-01',
        NULL,
        'St 1 Alovena',
        'New York',
        'CA',
        DEFAULT);

INSERT INTO customers (last_name,
                       first_name,
                       birth_date,
                       address,
                       city,
                       state)
VALUES ('Smith',
        'John',
        '1990-01-01',
        'St 1 Alovena',
        'New York',
        'CA');

-- Inserting Multiple Rows
INSERT INTO shippers (name)
VALUES ('Shipper 1'),
       ('Shipper 2'),
       ('Shipper 3');

INSERT INTO products(name, quantity_in_stock, unit_price)
VALUES ('Product 1', 10, 1.95),
       ('Product 2', 11, 1.80),
       ('Product 3', 12, 2.01);

-- Inserting Hierarchical Rows
INSERT INTO orders (customer_id, order_date, status)
VALUES (1, '2019-01-02', 1);

INSERT INTO order_items
VALUES (LAST_INSERT_ID(), 1, 1, 2.95),
       (LAST_INSERT_ID(), 2, 1, 3.95);

-- Creating a Copy of a Table
CREATE TABLE orders_archived AS
SELECT *
FROM orders;

TRUNCATE orders_archived;

INSERT INTO orders_archived
SELECT *
FROM orders
WHERE order_date < '2019-01-01';

USE sql_invoicing;

CREATE TABLE invoices_archived AS
SELECT i.invoice_id,
       i.number,
       c.name AS client,
       i.invoice_total,
       i.payment_total,
       i.invoice_date,
       i.payment_date,
       i.due_date
FROM invoices i
         JOIN clients c USING (client_id)
WHERE payment_date IS NOT NULL;

-- Updating a Single Row
UPDATE invoices
SET payment_total = 10,
    payment_date  = '2019-03-01'
WHERE invoice_id = 1;

UPDATE invoices
SET payment_total = DEFAULT,
    payment_date  = NULL
WHERE invoice_id = 1;

UPDATE invoices
SET payment_total = invoice_total * 0.5,
    payment_date  = due_date
WHERE invoice_id = 3;

-- Updating Multiple Rows
UPDATE invoices
SET payment_total = invoice_total * 0.5,
    payment_date  = due_date
WHERE client_id = 3;

UPDATE invoices
SET payment_total = invoice_total * 0.5,
    payment_date  = due_date
WHERE client_id IN (3, 4);

USE sql_store;

UPDATE customers
SET points = points + 50
WHERE birth_date < '1990-01-01';

-- Using Sub-queries in Updates
USE sql_invoicing;

UPDATE invoices
SET payment_total = invoice_total * 0.5,
    payment_date  = due_date
WHERE client_id IN (
    SELECT client_id
    FROM clients
    WHERE state IN ('CA', 'NY'));

USE sql_store;

UPDATE orders
SET comments = 'Gold customer'
WHERE customer_id IN (SELECT customer_id FROM customers WHERE points > 300);

-- Deleting Rows
USE sql_invoicing;

DELETE
FROM invoices
WHERE client_id = (SELECT client_id FROM clients WHERE name = 'Myworks');
