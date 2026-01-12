USE social_network_mini;
create view view_user_post 
as
select u.user_id,  count(p.user_id) as total_user_post from users u
join posts p on p.user_id = u.user_id
group by u.user_id
order by total_user_post desc;

select * from view_user_post;
select u.user_id, u.full_name, v.total_user_post
from users u
join view_user_post v on v.user_id = u.user_id
order by user_id;

explain select * from view_user_post;