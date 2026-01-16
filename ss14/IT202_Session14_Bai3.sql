-- ss14b3
USE social_network;

ALTER TABLE users
ADD COLUMN following_count INT DEFAULT 0,
ADD COLUMN followers_count INT DEFAULT 0;

CREATE TABLE followers (
    follower_id INT NOT NULL,
    followed_id INT NOT NULL,
    PRIMARY KEY (follower_id, followed_id),
    CONSTRAINT fk_follower_user
        FOREIGN KEY (follower_id)
        REFERENCES users(user_id),
    CONSTRAINT fk_followed_user
        FOREIGN KEY (followed_id)
        REFERENCES users(user_id)
);

DELIMITER //

CREATE PROCEDURE sp_follow_user (
    IN p_follower_id INT,
    IN p_followed_id INT
)
BEGIN
    DECLARE v_count INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Follow that bai';
    END;

    -- Không tự follow
    IF p_follower_id = p_followed_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Khong the tu follow chinh minh';
    END IF;

    -- Kiểm tra follower tồn tại
    SELECT COUNT(*) INTO v_count
    FROM users
    WHERE user_id = p_follower_id;

    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Follower khong ton tai';
    END IF;

    -- Kiểm tra followed tồn tại
    SELECT COUNT(*) INTO v_count
    FROM users
    WHERE user_id = p_followed_id;

    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nguoi duoc follow khong ton tai';
    END IF;

    -- Kiểm tra follow trùng
    SELECT COUNT(*) INTO v_count
    FROM followers
    WHERE follower_id = p_follower_id
      AND followed_id = p_followed_id;

    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Da follow nguoi nay truoc do';
    END IF;

    START TRANSACTION;

    INSERT INTO followers (follower_id, followed_id)
    VALUES (p_follower_id, p_followed_id);

    UPDATE users
    SET following_count = following_count + 1
    WHERE user_id = p_follower_id;

    UPDATE users
    SET followers_count = followers_count + 1
    WHERE user_id = p_followed_id;

    COMMIT;
END //

CALL sp_follow_user(1, 2);

CALL sp_follow_user(1, 2);

CALL sp_follow_user(1, 1);

CALL sp_follow_user(1, 999);
