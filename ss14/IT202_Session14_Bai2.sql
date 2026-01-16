-- ss14b2
USE social_network;


CREATE TABLE likes (
    like_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    CONSTRAINT fk_likes_post
        FOREIGN KEY (post_id)
        REFERENCES posts(post_id),
    CONSTRAINT fk_likes_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id),
    CONSTRAINT unique_like UNIQUE (post_id, user_id)
);

DELIMITER //

CREATE PROCEDURE like_post (
    IN p_post_id INT,
    IN p_user_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Like bai viet that bai';
    END;

    START TRANSACTION;

    INSERT INTO likes (post_id, user_id)
    VALUES (p_post_id, p_user_id);

    UPDATE posts
    SET likes_count = likes_count + 1
    WHERE post_id = p_post_id;

    COMMIT;
END //

CALL like_post(1, 1);

CALL like_post(1, 1);

SELECT * FROM posts;