-- ss14b5
USE social_network;

CREATE TABLE IF NOT EXISTS delete_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT NOT NULL,
    deleted_by INT NOT NULL,
    deleted_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE PROCEDURE delete_post (
    IN p_post_id INT,
    IN p_user_id INT
)
BEGIN
    DECLARE v_owner_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Xoa bai viet that bai';
    END;

    SELECT user_id INTO v_owner_id
    FROM posts
    WHERE post_id = p_post_id;

    IF v_owner_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bai viet khong ton tai';
    END IF;

    IF v_owner_id <> p_user_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Khong co quyen xoa bai viet nay';
    END IF;

    START TRANSACTION;

    DELETE FROM likes
    WHERE post_id = p_post_id;

    DELETE FROM comments
    WHERE post_id = p_post_id;

    DELETE FROM posts
    WHERE post_id = p_post_id;

    UPDATE users
    SET posts_count = posts_count - 1
    WHERE user_id = p_user_id
      AND posts_count > 0;

    INSERT INTO delete_log (post_id, deleted_by)
    VALUES (p_post_id, p_user_id);

    COMMIT;
END //

CALL delete_post(1, 1);

CALL delete_post(2, 1);