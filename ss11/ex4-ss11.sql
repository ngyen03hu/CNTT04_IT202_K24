use social_network_pro;
DELIMITER $$
create procedure  CreatePostWithValidation (
  IN p_user_id INT,
   IN p_content TEXT,
   OUT result_message VARCHAR(255) 
)
BEGIN 
    IF LENGTH(p_content) < 5 THEN
    SET result_message="Nội dung quá ngắn";
    ELSE
       INSERT INTO posts(user_id,content,created_at)
       VALUES (p_user_id,p_content,NOW());
    SET result_message="“Thêm bài viết thành công";
    END IF;
END$$
DELIMITER ;
-- 3) Gọi thủ tục và thử insert các trường hợp
-- Truong hop 1: noi dung qua ngan 
SET @msg ='';
CALL CreatePostWithValidation (1,'ai',@msg);

-- Truong hop 2: noi dung hop le-- ND dai-- them thanh cong
SET @msg ='';
CALL CreatePostWithValidation (1,'day la noi dung hop le ',@msg);


-- 4) Kiểm tra các kết quả
-- truong hop 1: kiem tra thong bao tra ve
SELECT @msg AS ketqua;

-- truong hop 2: kiem tra bai viet da dc them chua
SELECT p_user_id,p_content,result_message,created_at
FROM posts
WHERE user_id=1;
-- 5) Xóa thủ tục vừa khởi tạo trên
DROP procedure IF EXISTS  CreatePostWithValidation

