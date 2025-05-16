-- ===============================
-- 🧠 DATABASE INDEXING & SECURITY ASSIGNMENT
-- ===============================

-- ✅ USE DATABASE
CREATE DATABASE IF NOT EXISTS salesDB;
USE salesDB;

-- ===============================
-- 📦 TABLE: customers
-- ===============================
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100),
    country VARCHAR(50),
    phone_number VARCHAR(20),
    credit_limit DECIMAL(10,2)
);

-- ✅ Insert small sample dataset
INSERT INTO customers (customer_name, country, phone_number, credit_limit) VALUES
('John Smith', 'USA', '+1234567890', 5000.00),
('Jane Doe', 'Canada', '+1987654321', 3000.00),
('Ali Khan', 'Pakistan', '+923001234567', 4500.00),
('Maria Lopez', 'Mexico', '+521234567890', 6200.00),
('Chen Li', 'China', '+8613900123456', 4000.00);

-- ===============================
-- 🔁 INSERT BULK FAKE DATA (10,000 rows)
-- ===============================
-- For testing index performance, generate bulk dummy data
-- You can run this block multiple times to increase size
INSERT INTO customers (customer_name, country, phone_number, credit_limit)
SELECT 
    CONCAT('Customer_', FLOOR(RAND() * 10000)),
    'USA',
    CONCAT('+1', FLOOR(1000000000 + RAND() * 9000000000)),
    FLOOR(1000 + RAND() * 9000)
FROM information_schema.tables
LIMIT 10000;

-- ===============================
-- ✅ Q1: DROP INDEX
-- ===============================
-- Drop index named IdxPhone (if it exists)
DROP INDEX IF EXISTS IdxPhone ON customers;

-- ===============================
-- ✅ Q2: CREATE USER 'bob'
-- ===============================
CREATE USER IF NOT EXISTS 'bob'@'localhost' IDENTIFIED BY 'S$cu3r3!';

-- ===============================
-- ✅ Q3: GRANT INSERT PRIVILEGE
-- ===============================
GRANT INSERT ON salesDB.* TO 'bob'@'localhost';

-- ===============================
-- ✅ Q4: CHANGE PASSWORD FOR USER
-- ===============================
ALTER USER 'bob'@'localhost' IDENTIFIED BY 'P$55!23';

-- ===============================
-- ⚡ CREATE INDEX FOR OPTIMIZATION TESTING
-- ===============================
-- Create index on phone_number
CREATE INDEX IdxPhone ON customers(phone_number);

-- ===============================
-- 🧪 EXPLAIN QUERY PERFORMANCE (Before and After Index)
-- ===============================
-- Without index (if dropped): Full table scan
EXPLAIN SELECT * FROM customers WHERE phone_number = '+27791956257';

-- With index
EXPLAIN SELECT * FROM customers WHERE phone_number = '+27791956257';

-- ===============================
-- 🧠 COMPOSITE INDEX: country + phone_number
-- ===============================
CREATE INDEX idx_country_phone ON customers(country, phone_number);

-- Query with composite filter
EXPLAIN SELECT * FROM customers 
WHERE country = 'RSA' AND phone_number = '+27791956257';

-- ===============================
-- 🧹 CLEANUP (Optional)
-- ===============================
-- DROP INDEX IdxPhone ON customers;
-- DROP INDEX idx_country_phone ON customers;
-- DROP USER 'bob'@'localhost';
