-- ss14b1
CREATE DATABASE social_network;
USE social_network;

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    posts_count INT DEFAULT 0
);

CREATE TABLE posts (
    post_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_posts_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
);

INSERT INTO users (username) VALUES
('alice'),
('bob');

DELIMITER //

CREATE PROCEDURE create_post (
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Dang bai viet that bai';
    END;
    
    START TRANSACTION;

    INSERT INTO posts (user_id, content)
    VALUES (p_user_id, p_content);

    UPDATE users
    SET posts_count = posts_count + 1
    WHERE user_id = p_user_id;

    COMMIT;
END //

CALL create_post(1,'test');

CALL create_post(99,'');

SELECT * FROM posts;