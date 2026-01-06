drop database if exists session06;
create database session06;
use session06;

create table customers (
    customer_id int auto_increment primary key,
    full_name varchar(100),
    city varchar(50)
);

create table orders (
    order_id int auto_increment primary key,
    customer_id int,
    order_date date,
    total_amount decimal(10,2),
    status enum('pending', 'completed', 'cancelled'),
    foreign key (customer_id) references customers(customer_id)
);
insert into customers (full_name, city) values
('nguyen van an', 'ha noi'),
('tran thi binh', 'hai phong'),
('le van cuong', 'da nang'),
('pham thi dung', 'hue'),
('hoang van em', 'tp ho chi minh');
insert into orders (customer_id, order_date, total_amount, status) values
(1, '2024-01-05', 4000000, 'completed'),
(1, '2024-01-10', 3500000, 'completed'),
(1, '2024-02-01', 3000000, 'completed'),
(2, '2024-01-08', 2000000, 'completed'),
(2, '2024-02-12', 2500000, 'completed'),
(3, '2024-01-15', 5000000, 'completed'),
(3, '2024-02-18', 6000000, 'completed'),
(3, '2024-03-01', 4000000, 'completed'),
(4, '2024-01-20', 1500000, 'completed'),
(5, '2024-02-05', 7000000, 'completed'),
(5, '2024-02-20', 5000000, 'completed'),
(5, '2024-03-10', 3000000, 'pending');

select
    c.customer_id,
    c.full_name,
    count(o.order_id) as total_orders,
    sum(o.total_amount) as total_spent,
    avg(o.total_amount) as avg_order_value
from customers c
join orders o on c.customer_id = o.customer_id
where o.status = 'completed'
group by c.customer_id, c.full_name
having count(o.order_id) >= 3
   and sum(o.total_amount) > 10000000
order by total_spent desc;

