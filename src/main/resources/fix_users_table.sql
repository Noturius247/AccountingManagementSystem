-- Drop the existing table if it exists
DROP TABLE IF EXISTS users;

-- Create the users table with correct constraints
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    address TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    enabled TINYINT(1) DEFAULT 1,
    account_non_expired TINYINT(1) DEFAULT 1,
    account_non_locked TINYINT(1) DEFAULT 1,
    credentials_non_expired TINYINT(1) DEFAULT 1,
    last_login TIMESTAMP NULL DEFAULT NULL,
    online_status TINYINT(1) DEFAULT 0,
    balance DECIMAL(38,2) NOT NULL DEFAULT 0.00,
    last_activity DATETIME,
    role VARCHAR(255) NOT NULL,
    registration_status ENUM('PENDING', 'APPROVED', 'REJECTED') NOT NULL DEFAULT 'PENDING',
    CONSTRAINT chk_email CHECK (email LIKE '%@%.%')
); 