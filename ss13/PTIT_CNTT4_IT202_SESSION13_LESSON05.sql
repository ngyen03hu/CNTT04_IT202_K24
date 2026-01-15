drop database if exists SocialNetworkDB;
create database SocialNetworkDB;
use SocialNetworkDB;
create table Users (
    user_id int auto_increment primary key,
    username varchar(50) not null unique,
    email varchar(100) not null unique,
    created_at date
);
delimiter //

create trigger Tg_check_user_before_insert
before insert on Users
for each row
begin
    -- kiểm tra email hợp lệ
    if new.email not like '%@%.%' then
        signal sqlstate '45000'
        set message_text = 'Email không hợp lệ';
    end if;

    -- kiểm tra username chỉ chứa chữ, số, underscore
    if new.username regexp '[^a-zA-Z0-9_]' then
        signal sqlstate '45000'
        set message_text = 'Username chỉ được chứa chữ cái, số và dấu gạch dưới';
    end if;
end //

delimiter ;

delimiter //

create procedure add_user(
    in p_username varchar(50),
    in p_email varchar(100),
    in p_created_at date
)
begin
    insert into Users(username, email, created_at)
    values (p_username, p_email, p_created_at);
end //

delimiter ;

-- hợp lệ
call add_user('alice_01', 'alice@example.com', '2025-01-01');
call add_user('bob_user', 'bob@gmail.com', '2025-01-02');

-- lỗi email
call add_user('charlie', 'charlieexample.com', '2025-01-03');

-- lỗi username
call add_user('david@123', 'david@mail.com', '2025-01-04');

-- kiểm tra kết quả
select * from Users;
