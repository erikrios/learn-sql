-- Creating Transactions
USE sql_store;

START TRANSACTION;

INSERT INTO orders (customer_id, order_date, status)
VALUES (1, '2019-01-01', 1);

INSERT INTO order_items
VALUES (LAST_INSERT_ID(), 1, 1, 1);

COMMIT;

SHOW VARIABLES LIKE 'autocommit';

-- Concurrency and Locking
USE sql_store;

START TRANSACTION;

UPDATE customers
SET points = points + 10
WHERE customer_id = 1;

COMMIT;

-- Transaction Isolation Levels
USE sql_store;

SHOW VARIABLES LIKE 'transaction_isolation';
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET GLOBAL TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- READ UNCOMMITTED Isolation Level
USE sql_store;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT points
FROM customers
WHERE customer_id = 1;

-- another instance
USE sql_store;

START TRANSACTION;

UPDATE customers
SET points = 20
WHERE customer_id = 1;

ROLLBACK;

-- READ COMMITTED Isolation Level
-- instance 1
USE sql_store;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT points
FROM customers
WHERE customer_id = 1;

-- instance 2
USE sql_store;

START TRANSACTION;

UPDATE customers
SET points = 20
WHERE customer_id = 1;

COMMIT;

-- instance 1
USE sql_store;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION ;
SELECT points FROM customers WHERE customer_id = 1;
SELECT points FROM customers WHERE customer_id = 1;
COMMIT;

-- instance 2
START TRANSACTION;

UPDATE customers
SET points = 30
WHERE customer_id = 1;

COMMIT;

-- REPEATABLE READ Isolation Level
-- instance 1
USE sql_store;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION ;
SELECT points FROM customers WHERE customer_id = 1;
SELECT points FROM customers WHERE customer_id = 1;
COMMIT;

-- instance 2
START TRANSACTION;

UPDATE customers
SET points = 40
WHERE customer_id = 1;

COMMIT;

-- instance 1
USE sql_store;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION ;
SELECT * FROM customers WHERE state = 'VA';
COMMIT;

-- instance 2
START TRANSACTION;

UPDATE customers
SET state = 'VA'
WHERE customer_id = 1;

COMMIT;

-- SERIALIZABLE Isolation Level
-- instance 1
USE sql_store;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION ;
SELECT * FROM customers WHERE state = 'VA';
COMMIT;

-- instance 2
START TRANSACTION;

UPDATE customers
SET state = 'VA'
WHERE customer_id = 3;

COMMIT;

-- Deadlocks

-- instance 1
USE sql_store;
START TRANSACTION;
UPDATE customers SET state = 'VA' WHERE customer_id = 1;
UPDATE orders SET status = 1 WHERE order_id = 1;
COMMIT;

-- instance 2
USE sql_store;
START TRANSACTION;
UPDATE orders SET status = 1 WHERE order_id = 1;
UPDATE customers SET state = 'VA' WHERE customer_id = 1;
COMMIT;
