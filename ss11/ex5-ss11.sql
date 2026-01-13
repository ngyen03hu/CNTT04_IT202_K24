use  social_network_pro ;
DELIMITER $$
create procedure  CalculateUserActivityScore (
        IN p_user_id INT,
        OUT activity_score INT,
         OUT activity_level VARCHAR(50)
)
BEGIN 
   DECLARE post_count INT DEFAULT 0;
   DECLARE like_count INT DEFAULT 0;
   DECLARE comment_count INT DEFAULT 0;

-- ĐẾM SỐ BÀI VIẾT
SELECT COUNT(*)
INTO post_count
FROM posts
WHERE user_id=p_user_id;

-- ĐẾM SỐ LIKE BÀI VIẾT JOIN posts và likes)
SELECT COUNT(*)
INTO like_count
FROM likes l
JOIN posts p ON l.post_id=p.post_id
WHERE user_id=p_user_id;

-- ĐẾM SỐ LIKE BÀI VIẾT
SELECT COUNT(*)
INTO comment_count
FROM posts
WHERE user_id=p_user_id;

--  tính tổng điểm
SET activity_score= post_count *10 + comment_count *5 + like_count *3;

-- phân loại mức độ hoạt động
SET activity_level= CASE
      WHEN activity_score > 500 THEN 'Rất tích cực '
       WHEN activity_score BETWEEN 200 AND 500 THEN ' tích cực '
       ELSE 'Binh Thuong '
END ;
END $$
DELIMITER ;

-- 3) Gọi thủ tục trên select ra activity_score và activity_level
SET  @activity_score =100;
CALL CalculateUserActivityScore(2,@activity_score );

SET  @activity_level ='Binh Thuong';
CALL CalculateUserActivityScore(2,@activity_level);


-- 4) Xóa thủ tục vừa khởi tạo trên
DROP PROCEDURE IF EXISTS CalculateUserActivityScore;

