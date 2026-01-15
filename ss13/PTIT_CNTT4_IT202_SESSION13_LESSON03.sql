
create database SocialNetworkDB;
use SocialNetworkDB;

create table Users (
    user_id int auto_increment primary key,
    username varchar(50) not null unique,
    email varchar(100) not null unique,
    created_at date,
    follower_count int default 0,
    post_count int default 0
);
create table Posts (
    post_id int auto_increment primary key,
    user_id int,
    content text,
    created_at datetime,
    like_count int default 0,
    foreign key (user_id) references Users(user_id) on delete cascade
);
create table Likes (
    like_id int auto_increment primary key,
    user_id int,
    post_id int,
    liked_at datetime default current_timestamp,
    foreign key (user_id) references Users(user_id) on delete cascade,
    foreign key (post_id) references Posts(post_id) on delete cascade
);
insert into Users (username, email, created_at) values
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

insert into Posts (user_id, content, created_at) values
(1, 'Hello world from Alice!', '2025-01-10 10:00:00'),
(1, 'Second post by Alice', '2025-01-10 12:00:00'),
(2, 'Bob first post', '2025-01-11 09:00:00'),
(3, 'Charlie sharing thoughts', '2025-01-12 15:00:00');

update Users set post_count = 2 where user_id = 1;
update Users set post_count = 1 where user_id = 2;
update Users set post_count = 1 where user_id = 3;

-- RIGGER: CHECK SELF LIKE
delimiter //

create trigger Tg_check_self_like
before insert on Likes
for each row
begin
    declare post_owner int;

    select user_id
    into post_owner
    from Posts
    where post_id = new.post_id;

    if new.user_id = post_owner then
        signal sqlstate '45000'
        set message_text = 'Không được phép like bài viết của chính mình';
    end if;
end //

delimiter ;

-- RIGGER: AFTER INSERT LIKE 
delimiter //

create trigger Tg_like_after_insert
after insert on Likes
for each row
begin
    update Posts
    set like_count = like_count + 1
    where post_id = new.post_id;
end //

delimiter ;

-- ===== TRIGGER: AFTER DELETE LIKE =====
delimiter //

create trigger Tg_like_after_delete
after delete on Likes
for each row
begin
    update Posts
    set like_count = like_count - 1
    where post_id = old.post_id;
end //

delimiter ;

--  TRIGGER: AFTER UPDATE LIKE 
delimiter //

create trigger Tg_like_after_update
after update on Likes
for each row
begin
    if old.post_id <> new.post_id then
        update Posts
        set like_count = like_count - 1
        where post_id = old.post_id;

        update Posts
        set like_count = like_count + 1
        where post_id = new.post_id;
    end if;
end //

delimiter ;

-- ===== VIEW USER STATISTICS =====
create view User_statistics as
select 
    u.user_id,
    u.username,
    u.post_count,
    ifnull(sum(p.like_count), 0) as total_likes
from Users u
left join Posts p on u.user_id = p.user_id
group by u.user_id, u.username, u.post_count;

-- ===== TEST =====

-- like hợp lệ
insert into Likes (user_id, post_id) values
(2, 1),
(3, 1),
(1, 3),
(3, 4);

-- thêm like
insert into Likes (user_id, post_id) values (2, 4);

-- update like
update Likes set post_id = 2 where user_id = 2 and post_id = 4;

-- delete like
delete from Likes where user_id = 3 and post_id = 1;

-- kiểm tra
select * from Posts;
select * from User_statistics;
