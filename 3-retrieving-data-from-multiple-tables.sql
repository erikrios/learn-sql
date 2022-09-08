-- Inner Joins
USE sql_store;

SELECT order_id, o.customer_id, first_name, last_name
FROM orders o
         JOIN customers c ON o.customer_id = c.customer_id;

SELECT order_id, oi.product_id, p.name, quantity, oi.unit_price
FROM order_items oi
         JOIN products p ON oi.product_id = p.product_id;

-- Joining Across Databases
USE sql_store;

SELECT *
FROM order_items oi
         JOIN sql_inventory.products p ON oi.product_id = p.product_id;

USE sql_inventory;

SELECT *
FROM sql_store.order_items oi
         JOIN products p ON oi.product_id = p.product_id;

-- Self Joins
USE sql_hr;

SELECT e.employee_id, e.first_name, m.employee_id AS manager_id, m.first_name AS manager
FROM employees e
         JOIN employees m ON e.reports_to = m.employee_id;

-- Joining Multiple Tables
USE sql_store;

SELECT o.order_id, o.order_date, c.first_name, c.last_name, os.name AS status
FROM orders o
         JOIN customers c ON o.customer_id = c.customer_id
         JOIN order_statuses os ON o.status = os.order_status_id;

USE sql_invoicing;

SELECT p.date, p.invoice_id, p.amount, c.name, pm.name
FROM payments p
         JOIN clients c ON p.client_id = c.client_id
         JOIN payment_methods pm ON p.payment_method = pm.payment_method_id;

-- Compound Join Conditions
USE sql_store;

SELECT *
FROM order_items oi
         JOIN order_item_notes oin
              ON oi.order_id = oin.order_id
                  AND oi.product_id = oin.product_id;

-- Implicit Join Syntax
USE sql_store;

SELECT *
FROM orders o,
     customers c
WHERE o.customer_id = c.customer_id;

-- Outer Joins
USE sql_store;

SELECT c.customer_id, c.first_name, o.order_id
FROM customers c
         LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

SELECT c.customer_id, c.first_name, o.order_id
FROM orders o
         RIGHT JOIN customers c ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

SELECT p.product_id, p.name, oi.quantity
FROM products p
         LEFT JOIN order_items oi ON p.product_id = oi.product_id;

-- Outer Joins Between Multiple Tables
SELECT c.customer_id, c.first_name, o.order_id, s.name AS shipper
FROM customers c
         LEFT JOIN orders o ON c.customer_id = o.customer_id
         LEFT JOIN shippers s ON o.shipper_id = s.shipper_id
ORDER BY c.customer_id;

SELECT o.order_id, o.order_date, c.first_name AS customer, s.name AS shipper, os.name AS status
FROM orders o
         JOIN customers c ON o.customer_id = c.customer_id
         LEFT JOIN shippers s ON o.shipper_id = s.shipper_id
         JOIN order_statuses os ON o.status = os.order_status_id;

-- Self Outer Joins
USE sql_hr;

SELECT e.employee_id, e.first_name, m.first_name AS manager
FROM employees e
         LEFT JOIN employees m ON e.reports_to = m.employee_id;

-- The USING Clause
use sql_store;

SELECT o.order_id, c.first_name, s.name AS shipper
FROM orders o
         JOIN customers c USING (customer_id)
         LEFT JOIN shippers s USING (shipper_id);

SELECT *
FROM order_items oi
         JOIN order_item_notes oin USING (order_id, product_id);

USE sql_invoicing;

SELECT p.date, c.name AS client, p.amount, pm.name AS payment_method
FROM payments p
         JOIN clients c USING (client_id)
         JOIN payment_methods pm ON p.payment_method = pm.payment_method_id;

-- Natural Joins
USE sql_store;

SELECT o.order_id, c.first_name
FROM orders o
         NATURAL JOIN customers c;

-- Cross Joins
SELECT c.first_name AS customer, p.name AS product
FROM customers c
         CROSS JOIN products p
ORDER BY customer;

SELECT c.first_name AS customer, p.name AS product
FROM customers c,
     products p
ORDER BY customer;

SELECT s.name AS shipper, p.name AS product
FROM shippers s
         CROSS JOIN products p
ORDER BY shipper;

SELECT s.name AS shipper, p.name AS product
FROM shippers s,
     products p
ORDER BY shipper;

-- Unions
SELECT o.order_id, o.order_date, 'Active' AS status
FROM orders o
WHERE o.order_date >= '2019-01-01'
UNION
SELECT o.order_id, o.order_date, 'Archived' AS status
FROM orders o
WHERE o.order_date < '2019-01-01';

SELECT c.first_name
FROM customers c
UNION
SELECT s.name
FROM shippers s;

SELECT c.customer_id, c.first_name, c.points, 'Gold' AS type
FROM customers c
WHERE points > 3000
UNION
SELECT c.customer_id, c.first_name, c.points, 'Silver'
FROM customers c
WHERE points BETWEEN 2000 AND 3000
UNION
SELECT c.customer_id, c.first_name, c.points, 'Bronze'
FROM customers c
WHERE points < 2000
ORDER BY first_name;
