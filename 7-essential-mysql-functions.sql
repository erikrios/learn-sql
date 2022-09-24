-- Numeric Functions
SELECT ROUND(5.7345, 2);

SELECT TRUNCATE(5.7345, 2);

SELECT CEILING(5.2);

SELECT FLOOR(5.7);

SELECT ABS(-5.2);

SELECT RAND();

-- String Functions
SELECT LENGTH('sky');

SELECT UPPER('sky');

SELECT LOWER('Sky');

SELECT LTRIM('    Sky');

SELECT RTRIM('Sky        ');

SELECT TRIM('    Sky    ');

SELECT LEFT('Kindergarten', 4);

SELECT RIGHT('Kindergarten', 6);

SELECT SUBSTRING('Kindergarten', 3, 5);

SELECT SUBSTRING('Kindergarten', 3);

SELECT LOCATE('N', 'Kindergarten');

SELECT LOCATE('q', 'Kindergarten');

SELECT LOCATE('garten', 'Kindergarten');

SELECT REPLACE('Kindergarten', 'garten', 'garden');

SELECT CONCAT('first', 'last');

USE sql_store;

SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM customers;

-- Date Functions in MySQL
SELECT NOW(), CURDATE(), CURTIME();

SELECT YEAR(NOW()),
       MONTH(NOW()),
       MONTHNAME(NOW()),
       DAY(NOW()),
       DAYNAME(NOW()),
       HOUR(NOW()),
       MINUTE(NOW()),
       SECOND(NOW());

SELECT EXTRACT(YEAR FROM NOW());

USE sql_store;

SELECT *
FROM orders
WHERE YEAR(order_date) = YEAR(NOW());

-- Formatting Dates and Times
SELECT DATE_FORMAT(NOW(), '%y');

SELECT DATE_FORMAT(NOW(), '%Y');

SELECT DATE_FORMAT(NOW(), '%m %Y');

SELECT DATE_FORMAT(NOW(), '%M %Y');

SELECT DATE_FORMAT(NOW(), '%M %d %Y');

SELECT TIME_FORMAT(NOW(), '%H:%i %p');

-- Calculating Dates and Times
SELECT DATE_ADD(NOW(), INTERVAL 1 DAY);

SELECT DATE_ADD(NOW(), INTERVAL -1 YEAR);

SELECT DATE_SUB(NOW(), INTERVAL 1 YEAR);

SELECT DATEDIFF('2019-01-05 09:00', '2019-01-01 17:00');

SELECT DATEDIFF('2019-01-01 17:00', '2019-01-05 09:00');

SELECT TIME_TO_SEC('09:00') - TIME_TO_SEC('09:02');

-- The IFNULL and COALESCE Functions
USE sql_store;

SELECT order_id, IFNULL(shipper_id, 'Not Assigned') AS shipper
FROM orders;

SELECT order_id, COALESCE(shipper_id, comments, 'Not Assigned') AS shipper
FROM orders;

SELECT CONCAT(first_name, ' ', last_name) AS customer, IFNULL(phone, 'Unknown') AS phone
FROM customers;

-- The IF Function
USE sql_store;

SELECT order_id,
       order_date,
       IF(
                   YEAR(order_date) = YEAR(NOW()),
                   'Active',
                   'Archived') AS category
FROM orders;

SELECT p.product_id,
       p.name,
       COUNT(*)                               AS orders,
       IF(COUNT(*) > 1, 'Many times', 'Once') AS frequency
FROM products p
         JOIN order_items oi USING (product_id)
GROUP BY p.product_id, p.name;

-- The Case Operator
USE sql_store;

SELECT order_id,
       CASE
           WHEN YEAR(order_date) = YEAR(NOW()) THEN 'Active'
           WHEN YEAR(order_date) = YEAR(NOW()) - 1 THEN 'Last Year'
           WHEN YEAR(order_date) < YEAR(NOW()) - 1 THEN 'Archived'
           ELSE 'Future'
           END AS category
FROM orders;

SELECT CONCAT(first_name, ' ', last_name) AS customer,
       points,
       CASE
           WHEN points > 3000 THEN 'Gold'
           WHEN points >= 2000 THEN 'Silver'
           ELSE 'Bronze'
           END                            AS category
FROM customers
ORDER BY points DESC;
