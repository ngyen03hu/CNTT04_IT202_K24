drop database if exists ecommerce_system;
create database ecommerce_system;
use ecommerce_system;

create table customers (
    customer_id int auto_increment primary key,
    customer_name varchar(100) not null,
    email varchar(100) not null unique,
    phone varchar(10) not null unique
);

create table categories (
    category_id int auto_increment primary key,
    category_name varchar(255) not null unique
);

create table products (
    product_id int auto_increment primary key,
    product_name varchar(255) not null unique,
    price decimal(10,2) not null check (price > 0),
    category_id int not null,
    foreign key (category_id) references categories(category_id)
);

create table orders (
    order_id int auto_increment primary key,
    customer_id int not null,
    order_date datetime default current_timestamp,
    status enum('pending','completed','cancel') default 'pending',
    foreign key (customer_id) references customers(customer_id)
);

create table order_items (
    order_item_id int auto_increment primary key,
    order_id int,
    product_id int,
    quantity int not null check (quantity > 0),
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id)
);
insert into customers (customer_name, email, phone) values
('vu thi f','f@gmail.com','0900000006'),
('do van g','g@gmail.com','0900000007'),
('nguyen thi h','h@gmail.com','0900000008'),
('pham van i','i@gmail.com','0900000009'),
('le thi k','k@gmail.com','0900000010');


insert into categories (category_name) values
('tablet'),
('smartwatch'),
('laptop'),
('phone'),
('accessory');

insert into products (product_name, price, category_id) values
('ipad',18000000,4),
('samsung tab',14000000,4),
('apple watch',12000000,5),
('galaxy watch',9000000,5),
('usb',150000,3),
('charger',250000,3),
('gaming mouse',1200000,3),
('macbook pro',35000000,1),
('asus rog',30000000,1),
('pixel phone',20000000,2);


insert into orders (customer_id, order_date, status) values
(5,'2025-01-07','completed'),
(6,'2025-01-08','completed'),
(6,'2025-01-09','pending'),
(7,'2025-01-10','completed'),
(7,'2025-01-11','completed'),
(8,'2025-01-12','cancel'),
(9,'2025-01-13','completed'),
(10,'2025-01-14','pending'),
(1,'2025-01-15','completed'),
(2,'2025-01-16','completed');

insert into order_items (order_id, product_id, quantity) values
(6,8,1),
(6,5,2),
(7,9,1),
(7,7,1),
(7,6,3),
(8,4,1),
(9,3,2),
(9,10,1),
(10,1,1),
(10,11,2),
(11,12,1),
(11,5,1),
(11,6,1),
(12,2,1),
(13,8,1),
(13,14,1),
(14,15,2),
(15,3,1),
(15,6,2);




-- Phần a – truy vấn cơ bản
-- 1. lấy tất cả danh mục sản phẩm
select * from categories;

-- 2. lấy đơn hàng có trạng thái completed
select * 
from orders
where status = 'completed';

-- 3. lấy danh sách sản phẩm, sắp xếp giá giảm dần
select *
from products
order by price desc;

-- 4. lấy 5 sản phẩm giá cao nhất, bỏ qua 2 sản phẩm đầu
select *
from products
order by price desc
limit 5 offset 2;

-- Phần b – truy vấn nâng cao
-- 5. lấy sản phẩm kèm tên danh mục
select p.product_name, c.category_name
from products p
join categories c on p.category_id = c.category_id;

-- 6. lấy danh sách đơn hàng (order + customer)
select o.order_id, o.order_date, c.customer_name, o.status
from orders o
join customers c on o.customer_id = c.customer_id;

-- 7. tổng số lượng sản phẩm trong từng đơn hàng
select order_id, sum(quantity) as total_quantity
from order_items
group by order_id;

-- 8. thống kê số đơn hàng của mỗi khách hàng
select c.customer_name, o.customer_id, count(o.order_id) as total_orders
from orders o
join customers c on o.customer_id = c.customer_id
group by o.customer_id, c.customer_name;

-- 9. khách hàng có số đơn hàng ≥ 2
select customer_id
from orders
group by customer_id
having count(order_id) >= 2;

-- 10. thống kê giá theo danh mục
select category_id,
       avg(price) as avg_price,
       min(price) as min_price,
       max(price) as max_price
from products
group by category_id;

-- Phần c – truy vấn lồng 
-- 11. sản phẩm có giá cao hơn giá trung bình
select *
from products
where price > (
    select avg(price) from products
);

-- 12. khách hàng đã từng đặt ít nhất một đơn hàng
select *
from customers
where customer_id in (
    select distinct customer_id
    from orders
);

-- 13. đơn hàng có tổng số lượng sản phẩm lớn nhất
select order_id
from order_items
group by order_id
having sum(quantity) = (
    select max(total_q)
    from (
        select sum(quantity) as total_q
        from order_items
        group by order_id
    ) t
);

-- 14. khách hàng mua sản phẩm thuộc danh mục có giá trung bình cao nhất
select customer_name
from customers
where customer_id in (
    select o.customer_id
    from orders o
    join order_items oi on o.order_id = oi.order_id
    join products p on oi.product_id = p.product_id
    where p.category_id = (
        select category_id
        from products
        group by category_id
        order by avg(price) desc
        limit 1
    )
);

-- 15. thống kê tổng số lượng sản phẩm đã mua của từng khách hàng
select customer_id, sum(quantity) as total_products
from (
    select o.customer_id, oi.quantity
    from orders o
    join order_items oi on o.order_id = oi.order_id
) t
group by customer_id;

-- 16. sản phẩm có giá cao nhất (subquery chỉ trả về 1 giá trị)
select *
from products
where price = (
    select max(price) from products
);