drop database if exists Session6;
create database Session6;
use Session6;

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
('tai nghe sony', 3000000),
('loa bluetooth', 2500000),
('usb kingston', 300000);
insert into order_items (order_id, product_id, quantity) values
(1, 1, 2),
(1, 2, 5),
(1, 7, 10),
(2, 3, 4),
(2, 5, 3),
(3, 1, 3),
(3, 4, 2),
(4, 6, 6),
(4, 2, 5),
(5, 3, 6),
(5, 7, 8),
(6, 5, 4),
(6, 6, 5),
(7, 1, 4),
(7, 3, 3),
(7, 4, 2);

select
    p.product_name,
    sum(oi.quantity) as total_quantity_sold,
    sum(oi.quantity * p.price) as total_revenue,
    sum(oi.quantity * p.price) / sum(oi.quantity) as avg_price
from products p
join order_items oi on p.product_id = oi.product_id
group by p.product_id, p.product_name
having sum(oi.quantity) >= 10
order by total_revenue desc
limit 5;
