CREATE database data1;
USE data1;
DROP database data1;

DROP TABLE classes;
DROP TABLE students;
DROP TABLE teachers;
DROP TABLE subjects;
DROP TABLE Enrollment;
DROP TABLE score;

CREATE TABLE classes (
	class_id int primary key auto_increment,
    class_name varchar(50) not null unique,
    schoolYear date not null
);

create table teachers (
	teacher_id int auto_increment primary key,
    teacher_name varchar(50),
    email varchar(50) not null unique,
    check(email LIKE '%@%.%')
);

CREATE TABLE students (
	student_id int auto_increment primary key,
    full_name varchar(50) not null,
    date_of_birth date not null,
    gpa decimal(3,2) check(gpa >= 0),
	phoneNumber char(10) unique,
    gmail varchar(50) unique,
    `profile` blob not null,
    class_id int not null,
    foreign key(class_id) references classes(class_id)
);

create table subjects (
	subject_id int auto_increment primary key,
    course_name varchar(50),
	number_of_credit int check(number_of_credit >= 0),
    teacher_id int not null,
    foreign key (teacher_id) references teachers (teacher_id)
);

create table Enrollment  (
	student_id int not null,
    subject_id int not null,
	primary key (student_id, subject_id),
    foreign key (student_id) references students(student_id),
	foreign key (subject_id) references subjects(subject_id)
);

create table score (
	student_id int not null,
    subject_id int not null,
	primary key (student_id,subject_id),
    foreign key (student_id) references students(student_id),
	foreign key (subject_id) references subjects(subject_id),
    processPoint decimal (3,1) default (0),
    final_score decimal (3,1) default (0),
    check (processPoint between 0 and 10),
	check (final_score between 0 and 10)
);

-- alter table students