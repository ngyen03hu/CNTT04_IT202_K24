create table Likes (
    like_id int auto_increment primary key,
    user_id int,
    post_id int,
    liked_at datetime default current_timestamp,
    foreign key (user_id) references Users(user_id) on delete cascade,
    foreign key (post_id) references Posts(post_id) on delete cascade
);

alter table Posts add like_count int default 0;

insert into Likes (user_id, post_id, liked_at) values
(2, 1, '2025-01-10 11:00:00'),
(3, 1, '2025-01-10 13:00:00'),
(1, 3, '2025-01-11 10:00:00'),
(3, 4, '2025-01-12 16:00:00');

delimiter //

create trigger Tg_after_like_insert
after insert on Likes
for each row
begin
    update Posts
    set like_count = like_count + 1
    where post_id = new.post_id;
end //

create trigger Tg_after_like_delete
after delete on Likes
for each row
begin
    update Posts
    set like_count = like_count - 1
    where post_id = old.post_id;
end //

delimiter ;

create view User_statistics as
select 
    u.user_id,
    u.username,
    count(distinct p.post_id) as post_count,
    ifnull(sum(p.like_count), 0) as total_likes
from Users u
left join Posts p on u.user_id = p.user_id
group by u.user_id, u.username;

insert into Likes (user_id, post_id, liked_at)
values (2, 4, now());

select * from Posts where post_id = 4;
select * from User_statistics;

delete from Likes
where user_id = 2 and post_id = 4;

select * from Posts where post_id = 4;
select * from User_statistics;
