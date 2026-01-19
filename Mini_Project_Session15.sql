drop database if exists social_network;
create database social_network;
use social_network;

-- users
create table users (
    user_id int auto_increment primary key,
    username varchar(50) not null unique,
    password varchar(255) not null,
    email varchar(100) not null unique,
    created_at datetime default current_timestamp
);

-- posts
create table posts (
    post_id int auto_increment primary key,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    like_count int default 0,
    foreign key (user_id) references users(user_id) on delete cascade
);

-- comments
create table comments (
    comment_id int auto_increment primary key,
    post_id int not null,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (post_id) references posts(post_id) on delete cascade,
    foreign key (user_id) references users(user_id) on delete cascade
);

-- likes
create table likes (
    user_id int,
    post_id int,
    created_at datetime default current_timestamp,
    primary key (user_id, post_id),
    foreign key (user_id) references users(user_id) on delete cascade,
    foreign key (post_id) references posts(post_id) on delete cascade
);

-- friends
create table friends (
    user_id int,
    friend_id int,
    status varchar(20) default 'pending',
    created_at datetime default current_timestamp,
    check (status in ('pending','accepted')),
    primary key (user_id, friend_id),
    foreign key (user_id) references users(user_id) on delete cascade,
    foreign key (friend_id) references users(user_id) on delete cascade
);
-- bài 1 đăng ký thành viên (procedure + trigger)
create table user_log (
    log_id int auto_increment primary key,
    user_id int,
    action varchar(100),
    log_time datetime default current_timestamp
);

procedure đăng ký
delimiter $$

create procedure sp_register_user(
    in p_username varchar(50),
    in p_password varchar(255),
    in p_email varchar(100)
)
begin
    if exists (select 1 from users where username = p_username) then
        signal sqlstate '45000' set message_text = 'username da ton tai';
    elseif exists (select 1 from users where email = p_email) then
        signal sqlstate '45000' set message_text = 'email da ton tai';
    else
        insert into users(username, password, email)
        values (p_username, p_password, p_email);
    end if;
end$$

delimiter ;

trigger ghi log
delimiter $$

create trigger trg_user_register
after insert on users
for each row
begin
    insert into user_log(user_id, action)
    values (new.user_id, 'dang ky tai khoan');
end$$

delimiter ;

-- demo
call sp_register_user('anh','123','anh@gmail.com');
call sp_register_user('binh','123','binh@gmail.com');

select * from users;
select * from user_log;

-- 3. – đăng bài viết
create table post_log (
    log_id int auto_increment primary key,
    post_id int,
    action varchar(100),
    log_time datetime default current_timestamp
);

procedure đăng bài
delimiter $$

create procedure sp_create_post(
    in p_user_id int,
    in p_content text
)
begin
    if p_content is null or length(p_content) = 0 then
        signal sqlstate '45000' set message_text = 'noi dung rong';
    else
        insert into posts(user_id, content)
        values (p_user_id, p_content);
    end if;
end$$

delimiter ;

trigger log
delimiter $$

create trigger trg_post_log
after insert on posts
for each row
begin
    insert into post_log(post_id, action)
    values (new.post_id, 'dang bai viet');
end$$

delimiter ;

-- 4.  like / unlike (trigger)
-- like
delimiter $$

create trigger trg_like_insert
after insert on likes
for each row
begin
    update posts
    set like_count = like_count + 1
    where post_id = new.post_id;
end$$

delimiter ;

-- unlike
delimiter $$

create trigger trg_like_delete
after delete on likes
for each row
begin
    update posts
    set like_count = like_count - 1
    where post_id = old.post_id;
end$$

delimiter ;

-- 5. gửi lời mời kết bạn
delimiter $$

create procedure sp_send_friend_request(
    in p_user_id int,
    in p_friend_id int
)
begin
    if p_user_id = p_friend_id then
        signal sqlstate '45000' set message_text = 'khong the tu ket ban';
    elseif exists (
        select 1 from friends
        where user_id = p_user_id and friend_id = p_friend_id
    ) then
        signal sqlstate '45000' set message_text = 'da gui loi moi';
    else
        insert into friends(user_id, friend_id)
        values (p_user_id, p_friend_id);
    end if;
end$$

delimiter ;

-- 6. chấp nhận lời mời (tạo quan hệ đối xứng)
delimiter $$

create trigger trg_accept_friend
after update on friends
for each row
begin
    if new.status = 'accepted' then
        insert ignore into friends(user_id, friend_id, status)
        values (new.friend_id, new.user_id, 'accepted');
    end if;
end$$

delimiter ;

-- 7. xóa quan hệ bạn bè (transaction)
delimiter $$

create procedure sp_remove_friend(
    in p_user_id int,
    in p_friend_id int
)
begin
    start transaction;

    delete from friends
    where (user_id = p_user_id and friend_id = p_friend_id)
       or (user_id = p_friend_id and friend_id = p_user_id);

    commit;
end$$

delimiter ;

-- 8.xóa bài viết (transaction)
delimiter $$

create procedure sp_delete_post(
    in p_post_id int,
    in p_user_id int
)
begin
    start transaction;

    if not exists (
        select 1 from posts
        where post_id = p_post_id and user_id = p_user_id
    ) then
        rollback;
        signal sqlstate '45000' set message_text = 'khong co quyen xoa';
    end if;

    delete from posts where post_id = p_post_id;

    commit;
end$$

delimiter ;

-- 9. xóa tài khoản người dùng
delimiter //

create procedure sp_delete_user(
    in p_user_id int
)
begin
    start transaction;

    delete from users where user_id = p_user_id;

    commit;
end //

delimiter ;