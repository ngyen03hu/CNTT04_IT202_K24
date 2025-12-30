CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE
);

INSERT INTO Student (student_id, full_name, date_of_birth, email)
VALUES
(1, 'Nguyen Van A', '2003-05-10', 'a.nguyen@gmail.com'),
(2, 'Tran Thi B', '2004-08-22', 'b.tran@gmail.com'),
(3, 'Le Van C', '2003-12-01', 'c.le@gmail.com');

SELECT * FROM Student;

SELECT student_id, full_name
FROM Student;
