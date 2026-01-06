drop database if exists Session06;
CREATE DATABASE Session06;
use Session06;      
create table Customers(
	customer_id int auto_increment primary key,
    full_name varchar(55),
    city varchar(55)
);                    
create table Orders(
	order_id int primary key,
    customer_id int,
    foreign key (customer_id) references Customers(customer_id),
    order_date date,
    status ENUM('pending', 'completed', 'cancelled')
);
INSERT INTO Customers (full_name, city) VALUES
('Nguyễn Văn An', 'Hà Nội'),
('Trần Thị Bình', 'Hải Phòng'),
('Lê Văn Cường', 'Đà Nẵng'),
('Phạm Thị Dung', 'Huế'),
('Hoàng Văn Em', 'TP Hồ Chí Minh'),
('Đỗ Thị Hạnh', 'Cần Thơ'),
('Vũ Văn Long', 'Nam Định'),
('Bùi Thị Mai', 'Ninh Bình'),
('Ngô Văn Nam', 'Quảng Ninh'),
('Phan Thị Oanh', 'Bắc Ninh');
INSERT INTO Orders (order_id, customer_id, order_date, status) VALUES
(1, 1, '2024-01-05', 'completed'),
(2, 2, '2024-01-10', 'pending'),
(3, 3, '2024-01-15', 'completed'),
(4, 4, '2024-01-20', 'cancelled'),
(5, 5, '2024-02-01', 'completed'),
(6, 6, '2024-02-05', 'pending'),
(7, 7, '2024-02-10', 'completed'),
(8, 8, '2024-02-15', 'cancelled'),
(9, 9, '2024-03-01', 'completed'),
(10, 10, '2024-03-05', 'pending');

ALTER TABLE Orders
ADD total_amount DECIMAL(10,2);

UPDATE Orders SET total_amount = 2500000 WHERE order_id = 1;
UPDATE Orders SET total_amount = 1800000 WHERE order_id = 2;
UPDATE Orders SET total_amount = 3200000 WHERE order_id = 3;
UPDATE Orders SET total_amount = 1500000 WHERE order_id = 4;
UPDATE Orders SET total_amount = 4000000 WHERE order_id = 5;
UPDATE Orders SET total_amount = 2100000 WHERE order_id = 6;
UPDATE Orders SET total_amount = 3500000 WHERE order_id = 7;
UPDATE Orders SET total_amount = 1700000 WHERE order_id = 8;
UPDATE Orders SET total_amount = 2900000 WHERE order_id = 9;
UPDATE Orders SET total_amount = 2300000 WHERE order_id = 10;

SELECT 
*
FROM Orders ;
SELECT 
    c.customer_id,
    c.full_name,
    SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;
SELECT 
    c.customer_id,
    c.full_name,
    MAX(o.total_amount) AS max_order_value
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;
SELECT 
    c.customer_id,
    c.full_name,
    SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_spent DESC;
