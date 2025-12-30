CREATE TABLE Enrollment (
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    enroll_date DATE DEFAULT CURRENT_DATE,

    PRIMARY KEY (student_id, subject_id),

    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
);

INSERT INTO Enrollment (student_id, subject_id)
VALUES
(1, 101),
(1, 102),
(2, 101),
(2, 103);

SELECT * FROM Enrollment;

SELECT *
FROM Enrollment
WHERE student_id = 1;
