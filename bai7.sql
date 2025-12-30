CREATE DATABASE IF NOT EXISTS demo_;
USE demo_;

DROP TABLE IF EXISTS Score;
DROP TABLE IF EXISTS Enrollment;
DROP TABLE IF EXISTS Subject;
DROP TABLE IF EXISTS Student;

CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE
);
CREATE TABLE Subject (
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL,
    credit INT NOT NULL CHECK (credit > 0)
);
CREATE TABLE Enrollment (
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    enroll_date DATE DEFAULT DATE,
    PRIMARY KEY (student_id, subject_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
);
CREATE TABLE Score (
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    mid_score DECIMAL(4,2) CHECK (mid_score BETWEEN 0 AND 10),
    final_score DECIMAL(4,2) CHECK (final_score BETWEEN 0 AND 10),
    PRIMARY KEY (student_id, subject_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
);
INSERT INTO Student (student_id, full_name, date_of_birth, email)
VALUES
(1, 'Nguyen Van A', '2003-05-10', 'a.nguyen@gmail.com'),
(2, 'Tran Thi B', '2004-08-22', 'b.tran@gmail.com'),
(3, 'Le Van C', '2003-12-01', 'c.le@gmail.com'),
(10, 'Pham Tien Dat', '2004-06-15', 'dat.pham@gmail.com');
INSERT INTO Subject (subject_id, subject_name, credit)

VALUES
(101, 'Cơ sở dữ liệu', 3),
(102, 'Lập trình Java', 4),
(103, 'Mạng máy tính', 3);

INSERT INTO Enrollment (student_id, subject_id)
VALUES
(1, 101),
(1, 102),
(2, 101),
(2, 103),
(10, 101),
(10, 102);

INSERT INTO Score (student_id, subject_id, mid_score, final_score)
VALUES
(1, 101, 7.5, 8.5),
(1, 102, 6.0, 7.0),
(2, 101, 8.0, 9.0),
(2, 103, 7.0, 8.0),
(10, 101, 7.0, 8.0),
(10, 102, 6.5, 7.5);
UPDATE Score
SET final_score = 8.5
WHERE student_id = 10 AND subject_id = 102;
DELETE FROM Enrollment
WHERE student_id = 10 AND subject_id = 103;
SELECT * FROM Student;
SELECT * FROM Enrollment;
SELECT * FROM Score;
SELECT
    s.student_id,
    s.full_name,
    sub.subject_name,
    sc.mid_score,
    sc.final_score
FROM Score sc
JOIN Student s ON sc.student_id = s.student_id
JOIN Subject sub ON sc.subject_id = sub.subject_id
ORDER BY s.student_id;