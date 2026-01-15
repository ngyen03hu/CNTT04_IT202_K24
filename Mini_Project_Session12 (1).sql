drop database if exists social_network;
create database social_network;
use social_network;

-- phần 1. tạo bảng

create table Users (
    user_id int auto_increment primary key,
    username varchar(50) not null unique,
    password varchar(255) not null,
    email varchar(100) not null unique,
    created_at datetime default current_timestamp
);

create table Posts (
    post_id int auto_increment primary key,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (user_id) references Users(user_id)
);

create table Comments (
    comment_id int auto_increment primary key,
    post_id int not null,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (post_id) references Posts(post_id),
    foreign key (user_id) references Users(user_id)
);

create table Friends (
    user_id int,
    friend_id int,
    status varchar(20),
    check (status in ('pending', 'accepted')),
    primary key (user_id, friend_id),
    foreign key (user_id) references Users(user_id),
    foreign key (friend_id) references Users(user_id)
);

create table Likes (
    user_id int,
    post_id int,
    primary key (user_id, post_id),
    foreign key (user_id) references Users(user_id),
    foreign key (post_id) references Posts(post_id)
);

-- bài 1. thêm & hiển thị user

insert into Users(username, password, email)
values ('anh', '123456', 'anh@gmail.com');

select * from Users;

-- bài 2. view công khai

create view vw_public_users as
select user_id, username, created_at
from Users;

select * from vw_public_users;

-- bài 3. index tìm kiếm user

create index idx_users_username on Users(username);

select * from Users where username = 'anh';

-- bài 4. stored procedure đăng bài


delimiter $$

create procedure sp_create_post(
    in p_user_id int,
    in p_content text
)
begin
    if exists (select 1 from Users where user_id = p_user_id) then
        insert into Posts(user_id, content)
        values (p_user_id, p_content);
    else
        signal sqlstate '45000'
        set message_text = 'user not exists';
    end if;
end$$

delimiter ;

call sp_create_post(1, 'hello social network');
-- bài 5. view news feed (7 ngày)


create view vw_recent_posts as
select *
from Posts
where created_at >= now() - interval 7 day;

select * from vw_recent_posts;
-- bài 6. composite index

create index idx_posts_user_time
on Posts(user_id, created_at);

select *
from Posts
where user_id = 1
order by created_at desc;

-- bài 7. đếm bài viết theo user

delimiter $$

create procedure sp_count_posts(
    in p_user_id int,
    out p_total int
)
begin
    select count(*) into p_total
    from Posts
    where user_id = p_user_id;
end$$

delimiter ;

call sp_count_posts(1, @total);
select @total;

-- bài 8. view with check option

create view vw_active_users as
select u.user_id, u.username
from Users u
where exists (
    select 1 from Posts p where p.user_id = u.user_id
)
with check option;

-- bài 9. kết bạn

delimiter //

create procedure sp_add_friend(
    in p_user_id int,
    in p_friend_id int
)
begin
    if p_user_id = p_friend_id then
        signal sqlstate '45000'
        set message_text = 'cannot add yourself';
    else
        insert into Friends(user_id, friend_id, status)
        values (p_user_id, p_friend_id, 'pending');
    end if;
end//

delimiter ;

-- bài 10. gợi ý bạn bè

delimiter //

create procedure sp_suggest_friends(
    in p_user_id int,
    in p_limit int
)
begin
    select user_id, username
    from Users
    where user_id != p_user_id
    limit p_limit;
end//

delimiter ;

call sp_suggest_friends(1, 5);
-- bài 11. top 5 bài viết nhiều like

create index idx_likes_post on Likes(post_id);

create view vw_top_posts as
select post_id, count(*) as total_likes
from Likes
group by post_id
order by total_likes desc
limit 5;

select * from vw_top_posts;

-- bài 12. bình luận

delimiter //

create procedure sp_add_comment(
    in p_user_id int,
    in p_post_id int,
    in p_content text
)
begin
    if not exists (select 1 from Users where user_id = p_user_id) then
        signal sqlstate '45000'
        set message_text = 'user not exists';
    elseif not exists (select 1 from Posts where post_id = p_post_id) then
        signal sqlstate '45000'
        set message_text = 'post not exists';
    else
        insert into Comments(user_id, post_id, content)
        values (p_user_id, p_post_id, p_content);
    end if;
end//

delimiter ;

create view vw_post_comments as
select c.content, u.username, c.created_at
from Comments c
join Users u on c.user_id = u.user_id;

-- bài 13. like bài viết

delimiter //

create procedure sp_like_post(
    in p_user_id int,
    in p_post_id int
)
begin
    if exists (
        select 1 from Likes
        where user_id = p_user_id and post_id = p_post_id
    ) then
        signal sqlstate '45000'
        set message_text = 'already liked';
    else
        insert into Likes(user_id, post_id)
        values (p_user_id, p_post_id);
    end if;
end//

delimiter ;

create view vw_post_likes as
select post_id, count(*) as total_likes
from Likes
group by post_id;

-- bài 14. tìm kiếm user / post

delimiter //

create procedure sp_search_social(
    in p_option int,
    in p_keyword varchar(100)
)
begin
    if p_option = 1 then
        select * from Users
        where username like concat('%', p_keyword, '%');
    elseif p_option = 2 then
        select * from Posts
        where content like concat('%', p_keyword, '%');
    else
        signal sqlstate '45000'
        set message_text = 'invalid option';
    end if;
end//

delimiter ;

call sp_search_social(1, 'an');
call sp_search_social(2, 'hello');
