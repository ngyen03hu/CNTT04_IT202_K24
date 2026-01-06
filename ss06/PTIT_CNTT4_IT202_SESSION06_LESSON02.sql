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

-- Hiển thị danh sách đơn hàng kèm tên khách hàng
select o.order_id, c.full_name 
from Orders o Join Customers c on c.customer_id = o.customer_id;
select c.customer_id, c.full_name, COUNT(o.order_id) as total_orders
from Customers c
left join Orders o on c.customer_id = o.customer_id
group by c.customer_id,c.full_name;
select c.customer_id, c.full_name, COUNT(o.order_id) AS total_orders
from Customers c JOIN Orders o ON c.customer_id = o.customer_id
group by c.customer_id
having COUNT(o.order_id) >= 1;

                             	                         