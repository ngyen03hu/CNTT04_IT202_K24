USE social_network_pro;
DELIMITER $$
create procedure  CalculateBonusPoints (
      IN p_user_id INT,
      OUT p_bonus_points INT 
)
BEGIN   
   DECLARE post_count INT DEFAULT 0;

-- đếm số bài viết user 
	   SELECT COUNT(*)
       INTO p_bonus_points -- nhận giá trị ban đầu
       FROM posts
       WHERE user_id=p_user_id;

-- Cộng điểm theo số bài viết
IF post_count >= 20 THEN 
     SET p_bonus_points = p_bonus_points  +100;
ELSEIF post_count >= 10 THEN 
          SET p_bonus_points = p_bonus_points  +50;
END IF;
END $$
DELIMITER ;


-- 3) Gọi thủ tục trên với giá trị id user và p_bonus_points bất kì mà bạn muốn cập nhật
-- bước 1: khai bao biến INOUT
SET @bonus_points =100;
-- Bước 2: Gọi stored procedure
CALL CalculateBonusPoints(5,@bonus_points );
-- 4) Select ra p_bonus_points
SELECT @bonus_points AS BonusPointsSauCapNhat;

-- 5.Xóa stored procedure vừa tạo
DROP procedure IF EXISTS CalculateBonusPoints;
