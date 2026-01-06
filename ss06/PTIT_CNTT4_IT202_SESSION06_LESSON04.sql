drop database if exists session06;
create database session06;
use session06;

create table orders (
    order_id int primary key,
    order_date date,
    total_amount decimal(10,2),
    status enum('pending', 'completed', 'cancelled')
);

insert into orders (order_id, order_date, total_amount, status) values
(1, '2024-01-01', 6000000, 'completed'),
(2, '2024-01-01', 5000000, 'completed'),
(3, '2024-01-02', 3000000, 'completed'),
(4, '2024-01-02', 9000000, 'completed'),
(5, '2024-01-03', 12000000, 'completed'),
(6, '2024-01-03', 2000000, 'pending'),
(7, '2024-01-04', 8000000, 'completed'),
(8, '2024-01-04', 4000000, 'completed');

select order_date, sum(total_amount) as total_revenue
from orders
where status = 'completed'
group by order_date;

select order_date, count(order_id) as total_orders
from orders
where status = 'completed'
group by order_date;

select order_date, sum(total_amount) as total_revenue
from orders
where status = 'completed'
group by order_date
having sum(total_amount) > 10000000;
