CREATE TABLE Subject (
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL,
    credit INT NOT NULL CHECK (credit > 0)
);
INSERT INTO Subject (subject_id, subject_name, credit)
VALUES
(101, 'Cơ sở dữ liệu', 3),
(102, 'Lập trình Java', 4),
(103, 'Mạng máy tính', 3);
UPDATE Subject
SET credit = 5
WHERE subject_id = 102;
UPDATE Subject
SET subject_name = 'Cơ sở dữ liệu nâng cao'
WHERE subject_id = 101;
SELECT * FROM Subject;
