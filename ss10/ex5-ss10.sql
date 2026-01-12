USE social_network_pro;
drop index idx_hometown on users;
explain select u.*, p.post_id, p.content from users u
join posts p on u.user_id = p.user_id
where u.hometown = "Hà Nội"
order by u.username desc
limit 10;

create index idx_hometown on users(hometown);

explain select u.*, p.post_id, p.content from users u
join posts p on u.user_id = p.user_id
where u.hometown = "Hà Nội"
order by u.username desc
limit 10;