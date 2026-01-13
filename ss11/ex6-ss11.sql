use social_network_pro;
DELIMITER $$
create procedure NotifyFriendsOnNewPost (
      IN p_user_id  INT,
      OUT p_content  TEXT
)
BEGIN
    DECLARE v_post_id INT;
    DECLARE v_full_name VARCHAR(100);
    
    -- lay ten day du cua nguoi dung
    SELECT full_name
    INTO v_full_name 
    FROM users
    WHERE user_id=p_user_id;
    
    -- Them bai viet moi
    INSERT INTO posts( user_id,content, created_at)
    VALUES(p_user_id,p_content,NOW());
    
    -- lấy post_id vua tạo
    SET v_post_id = LAST_INSERT_ID();
    
    -- gui thông báo cho bạn bè ( 2 chiều , trạng thái accrpted)
    INSERT INTO notifications ( user_id,type,messenge,created_at)
    SELECT
        friend_id,
        'new_post',
        CONCAT(v_full_name,'đã đăng 1 bài viết mới');
        NOW()
	FROM (
    -- user la requested 
        SELECT f.friend_id
        FROM friends f
        WHERE f.user_id=p_user_id
        AND f.status='accepted'
        
        UNION
        -- user la ng dc kban
        SELECT f.user_id
         FROM friends f
        WHERE f.user_id=p_user_id
        AND f.status='accepted'
        )AS accepted_friends
        WHERE friend_id <> p_user_id;
	
END ;
DELIMITER;

-- 3) Gọi procedue trên và thêm bài viết mới 
CALL NotifyFriendsOnNewPost(
    3,
    'Hôm nay mình vừa đăng bài mới để test thông báo'
);

-- Select ra các thông báo của bài viết vừa đăng
SELECT 
    n.notification_id,
    n.user_id,
    u.full_name,
    n.type,
    n.message,
    n.created_at
FROM notifications n
JOIN users u ON n.user_id = u.user_id
WHERE n.type = 'new_post'
ORDER BY n.created_at DESC;

-- Xóa stored procedure vừa tạo
DROP PROCEDURE IF EXISTS NotifyFriendsOnNewPost;

