-- Creating Views
USE sql_invoicing;

CREATE VIEW sales_by_client AS
SELECT c.client_id,
       c.name,
       SUM(i.invoice_total) AS total_sales
FROM clients c
         JOIN invoices i USING (client_id)
GROUP BY c.client_id, c.name;

SELECT *
FROM sales_by_client
ORDER BY total_sales DESC;

SELECT client_id, total_sales
FROM sales_by_client
WHERE total_sales > 500;

SELECT *
FROM sales_by_client
         JOIN clients c USING (client_id);

CREATE VIEW clients_balance AS
SELECT c.client_id, c.name, SUM(i.invoice_total - i.payment_total) AS balance
FROM clients c
         JOIN invoices i USING (client_id)
GROUP BY c.client_id, c.name, c.name;

SELECT *
FROM clients_balance;

-- Altering or Dropping Views
USE sql_invoicing;

DROP VIEW sales_by_client;

CREATE OR REPLACE VIEW sales_by_client AS
SELECT c.client_id,
       c.name,
       SUM(i.invoice_total) AS total_sales
FROM clients c
         JOIN invoices i USING (client_id)
GROUP BY c.client_id, c.name
ORDER BY total_sales DESC;

-- Updatable Views
USE sql_invoicing;

CREATE OR REPLACE VIEW invoices_with_balance AS
SELECT invoice_id,
       number,
       client_id,
       invoice_total,
       payment_total,
       invoice_total - payment_total AS balance,
       invoice_date,
       due_date,
       payment_date
FROM invoices
WHERE (invoice_total - payment_total) > 0;

DELETE
FROM invoices_with_balance
WHERE invoice_id = 1;

UPDATE invoices_with_balance
SET due_date = DATE_ADD(due_date, INTERVAL 2 DAY)
WHERE invoice_id = 2;

-- The WITH OPTION CHECK Clause
USE sql_invoicing;

UPDATE invoices_with_balance
SET payment_total = invoice_total
WHERE invoice_id = 3;

CREATE OR REPLACE VIEW invoices_with_balance AS
SELECT invoice_id,
       number,
       client_id,
       invoice_total,
       payment_total,
       invoice_total - payment_total AS balance,
       invoice_date,
       due_date,
       payment_date
FROM invoices
WHERE (invoice_total - payment_total) > 0
WITH CHECK OPTION;
