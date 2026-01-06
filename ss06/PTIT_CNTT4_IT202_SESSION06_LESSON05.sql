drop database if exists Session06;
create database Session06;
use Session06;

create table products (
    product_id int auto_increment primary key,
    product_name varchar(255),
    price decimal(10,2)
);

create table order_items (
    order_item_id int auto_increment primary key,
    order_id int,
    product_id int,
    quantity int,
    foreign key (product_id) references products(product_id)
);

insert into products (product_name, price) values
('laptop dell', 15000000),
('chuot logitech', 500000),
('ban phim co', 2000000),
('man hinh samsung', 7000000),
('tai nghe sony', 3000000);
insert into order_items (order_id, product_id, quantity) values
(1, 1, 1),
(1, 2, 2),
(2, 3, 1),
(3, 4, 1),
(3, 5, 2),
(4, 1, 1),
(5, 3, 2);
select p.product_id, p.product_name, sum(oi.quantity) as total_quantity
from products p
join order_items oi on p.product_id = oi.product_id
group by p.product_id, p.product_name;

select p.product_id, p.product_name, sum(oi.quantity * p.price) as revenue
from products p
join order_items oi on p.product_id = oi.product_id
group by p.product_id, p.product_name;

select p.product_id, p.product_name, sum(oi.quantity * p.price) as revenue
from products p
join order_items oi on p.product_id = oi.product_id
group by p.product_id, p.product_name
having sum(oi.quantity * p.price) > 5000000;
