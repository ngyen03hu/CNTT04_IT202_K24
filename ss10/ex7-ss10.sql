
use social_network_pro;

create or replace view view_user_activity_status as
select 
    u.user_id,
    u.username,
    u.gender,
    u.created_at,
    case 
        when exists(select 1 from posts p where p.user_id = u.user_id) 
             or exists(select 1 from comments c where c.user_id = u.user_id)
        then 'Active'
        else 'Inactive'
    end as status
from users u;

select * from view_user_activity_status;

select 
    status as 'ten trang thai',
    count(user_id) as user_count
from view_user_activity_status
group by status
order by user_count desc;
