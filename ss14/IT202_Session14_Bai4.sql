-- ss14b4
USE social_network;

ALTER TABLE posts
ADD COLUMN comments_count INT DEFAULT 0;

CREATE TABLE comments (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_comment_post
        FOREIGN KEY (post_id) REFERENCES posts(post_id),
    CONSTRAINT fk_comment_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
);

DELIMITER //

CREATE PROCEDURE post_comment (
    IN p_post_id INT,
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Comment bai viet that bai';
    END;

    START TRANSACTION;

    INSERT INTO comments (post_id, user_id, content)
    VALUES (p_post_id, p_user_id, p_content);

    SAVEPOINT after_insert;

    UPDATE posts
    SET comments_count = comments_count + 1
    WHERE post_id = p_post_id;

    -- Kiểm tra UPDATE có tác động không (post_id không tồn tại → lỗi logic)
    IF ROW_COUNT() = 0 THEN
        -- Rollback chỉ phần update
        ROLLBACK TO after_insert;
    END IF;

    COMMIT;
END //

CALL post_comment(1, 1, 'Bình luận hợp lệ');

CALL post_comment(999, 1, 'Bình luận test savepoint');