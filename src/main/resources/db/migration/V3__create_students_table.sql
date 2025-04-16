CREATE TABLE students (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(20) NOT NULL UNIQUE,
    user_id BIGINT NOT NULL,
    program VARCHAR(100) NOT NULL,
    year_level INT,
    section VARCHAR(50),
    academic_year VARCHAR(20),
    semester INT,
    FOREIGN KEY (user_id) REFERENCES users(id)
); 