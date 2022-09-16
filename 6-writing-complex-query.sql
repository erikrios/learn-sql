-- Sub-queries
USE sql_store;

SELECT *
FROM products
WHERE unit_price > (SELECT unit_price FROM products WHERE product_id = 3);

USE sql_hr;

SELECT *
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- The IN Operator
USE sql_store;

SELECT *
FROM products
WHERE product_id NOT IN (SELECT DISTINCT product_id FROM order_items);

USE sql_invoicing;

SELECT *
FROM clients
WHERE client_id NOT IN (
    SELECT DISTINCT client_id
    FROM invoices);

-- Sub-queries vs Joins
USE sql_invoicing;

SELECT *
FROM clients c
         LEFT JOIN invoices i USING (client_id)
WHERE i.invoice_id IS NULL;

USE sql_store;

SELECT *
FROM customers
WHERE customer_id IN (SELECT customer_id
                      FROM orders
                      WHERE order_id IN (SELECT order_id
                                         FROM order_items
                                         WHERE product_id = 3
                      ));

SELECT DISTINCT c.customer_id,
                first_name,
                last_name,
                birth_date,
                phone,
                address,
                city,
                state,
                points
FROM customers c
         JOIN orders o USING (customer_id)
         JOIN order_items oi USING (order_id)
WHERE oi.product_id = 3;

-- The ALL Keyword
USE sql_invoicing;

SELECT *
FROM invoices
WHERE invoice_total > (SELECT MAX(invoice_total) FROM invoices WHERE client_id = 3);

SELECT *
FROM invoices
WHERE invoice_total > ALL (SELECT invoice_total FROM invoices WHERE client_id = 3);

-- The ANY Keyword
USE sql_invoicing;

SELECT *
FROM clients
WHERE client_id IN (
    SELECT client_id
    FROM invoices
    GROUP BY client_id
    HAVING COUNT(*) >= 2);

SELECT *
FROM clients
WHERE client_id = ANY (
    SELECT client_id
    FROM invoices
    GROUP BY client_id
    HAVING COUNT(*) >= 2);

-- Correlated Sub-queries
USE sql_hr;

SELECT *
FROM employees e
WHERE salary > (SELECT AVG(salary) FROM employees WHERE office_id = e.office_id);

USE sql_invoicing;

SELECT *
FROM invoices i
WHERE invoice_total > (SELECT AVG(invoice_total) FROM invoices WHERE client_id = i.client_id);

-- The EXISTS Operator
USE sql_invoicing;

SELECT *
FROM clients
WHERE client_id IN (SELECT DISTINCT client_id FROM invoices);

SELECT DISTINCT client_id,
                name,
                address,
                city,
                state,
                phone
FROM clients c
         JOIN invoices i USING (client_id);

SELECT *
FROM clients c
WHERE EXISTS(SELECT client_id FROM invoices WHERE client_id = c.client_id);

USE sql_store;

SELECT *
FROM products p
WHERE NOT EXISTS(SELECT product_id FROM order_items WHERE product_id = p.product_id);

-- Sub-queries in the SELECT Clause
USE sql_invoicing;

SELECT invoice_id,
       invoice_total,
       (SELECT AVG(invoice_total) FROM invoices) AS invoice_average,
       (SELECT invoice_total - invoice_average)  AS difference
FROM invoices;

SELECT client_id,
       name,
       (SELECT SUM(invoice_total) FROM invoices i WHERE i.client_id = c.client_id) AS total_sales,
       (SELECT AVG(invoice_total) FROM invoices)                                   AS average,
       (SELECT total_sales - average)                                              AS difference
FROM clients c;

-- Sub-queries in the FROM Clause
SELECT *
FROM (
         SELECT client_id,
                name,
                (SELECT SUM(invoice_total) FROM invoices i WHERE i.client_id = c.client_id) AS total_sales,
                (SELECT AVG(invoice_total) FROM invoices)                                   AS average,
                (SELECT total_sales - average)                                              AS difference
         FROM clients c
     ) AS sales_summary
WHERE total_sales IS NOT NULL;
