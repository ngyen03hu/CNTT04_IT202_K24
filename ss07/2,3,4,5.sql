create database ss7;
use ss7;


CREATE TABLE customers (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE orders (
    id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2)
);

CREATE TABLE products (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10,2)
);

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT
);

INSERT INTO customers (id, name, email) VALUES
(1, 'Nguyen Van A', 'a@gmail.com'),
(2, 'Tran Thi B', 'b@gmail.com'),
(3, 'Le Van C', 'c@gmail.com'),
(4, 'Pham Thi D', 'd@gmail.com'),
(5, 'Hoang Van E', 'e@gmail.com'),
(6, 'Do Thi F', 'f@gmail.com'),
(7, 'Vu Van G', 'g@gmail.com');

INSERT INTO orders (id, customer_id, order_date, total_amount) VALUES
(101, 1, '2025-01-01', 500000),
(102, 2, '2025-01-03', 750000),
(103, 1, '2025-01-05', 300000),
(104, 4, '2025-01-07', 900000),
(105, 5, '2025-01-10', 1200000),
(106, 2, '2025-01-12', 450000),
(107, 6, '2025-01-15', 650000);

INSERT INTO products (id, name, price) VALUES
(1, 'Laptop', 15000000),
(2, 'Chuột', 300000),
(3, 'Bàn phím', 500000),
(4, 'Tai nghe', 700000),
(5, 'Màn hình', 3500000),
(6, 'USB', 150000),
(7, 'Ổ cứng', 2000000);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(101, 1, 1),
(101, 2, 2),
(102, 3, 1),
(103, 5, 1),
(104, 1, 1),
(105, 6, 3),
(106, 4, 1);

SELECT *
FROM customers
WHERE id IN (
    SELECT customer_id
    FROM orders
);

SELECT *
FROM products
WHERE id IN (
    SELECT product_id
    FROM order_items
);

SELECT *
FROM orders
WHERE total_amount > (
    SELECT AVG(total_amount)
    FROM orders
);

SELECT
    name,
    (
        SELECT COUNT(*)
        FROM orders
        WHERE orders.customer_id = customers.id
    ) AS order_count
FROM customers;
