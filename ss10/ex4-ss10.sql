USE social_network_pro;

explain select post_id, content, created_at from posts where user_id = 1 and year(created_at) = 2026;

create index idx_created_at_user_id on posts(created_at, user_id);

explain select post_id, content, created_at from posts where user_id = 1 and year(created_at) = 2026;

explain select user_id, username, email from users where email = 'an@gmail.com';

create unique index idx_email on users(email);

explain select user_id, username, email from users where email = 'an@gmail.com';

drop index idx_created_at_user_id on posts;

drop index idx_email on users;