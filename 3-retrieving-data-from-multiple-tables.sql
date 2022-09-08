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
