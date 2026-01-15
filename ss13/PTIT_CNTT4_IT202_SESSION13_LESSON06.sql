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
create table Friendships (
    follower_id int,
    followee_id int,
    status enum('pending','accepted') default 'accepted',
    primary key (follower_id, followee_id),
    foreign key (follower_id) references Users(user_id) on delete cascade,
    foreign key (followee_id) references Users(user_id) on delete cascade
);
insert into Users (username, email, created_at) values
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

insert into Posts (user_id, content, created_at) values
(1, 'Alice first post', '2025-01-10 10:00:00'),
(2, 'Bob first post', '2025-01-11 09:00:00'),
(3, 'Charlie first post', '2025-01-12 15:00:00');

update Users set post_count = 1;

insert into Likes (user_id, post_id) values
(2,1),(3,1),(1,2);

update Posts set like_count = 2 where post_id = 1;
update Posts set like_count = 1 where post_id = 2;

-- ===== TRIGGER: FOLLOW COUNT =====
delimiter //

create trigger Tg_follow_after_insert
after insert on Friendships
for each row
begin
    if new.status = 'accepted' then
        update Users
        set follower_count = follower_count + 1
        where user_id = new.followee_id;
    end if;
end //

create trigger Tg_follow_after_delete
after delete on Friendships
for each row
begin
    if old.status = 'accepted' then
        update Users
        set follower_count = follower_count - 1
        where user_id = old.followee_id;
    end if;
end //

delimiter ;

--  PROCEDURE FOLLOW / UNFOLLOW 
delimiter //

create procedure follow_user(
    in p_follower_id int,
    in p_followee_id int,
    in p_status enum('pending','accepted')
)
begin
    -- không cho tự follow
    if p_follower_id = p_followee_id then
        signal sqlstate '45000'
        set message_text = 'Không thể follow chính mình';
    end if;

    -- tránh trùng
    if exists (
        select 1 from Friendships
        where follower_id = p_follower_id
          and followee_id = p_followee_id
    ) then
        signal sqlstate '45000'
        set message_text = 'Quan hệ follow đã tồn tại';
    end if;

    insert into Friendships (follower_id, followee_id, status)
    values (p_follower_id, p_followee_id, p_status);
end //

delimiter ;

--  VIEW USER PROFILE 
create view User_profile as
select
    u.user_id,
    u.username,
    u.follower_count,
    u.post_count,
    ifnull(sum(p.like_count),0) as total_likes,
    group_concat(p.content order by p.created_at desc separator ' | ') as recent_posts
from Users u
left join Posts p on u.user_id = p.user_id
group by u.user_id, u.username, u.follower_count, u.post_count;

-- ===== TEST =====

-- follow hợp lệ
call follow_user(2,1,'accepted');
call follow_user(3,1,'accepted');

-- pending follow
call follow_user(1,3,'pending');

-- unfollow
delete from Friendships where follower_id = 2 and followee_id = 1;

-- kiểm tra
select * from Users;
select * from Friendships;
select * from User_profile;
