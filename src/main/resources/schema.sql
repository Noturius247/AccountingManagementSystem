-- Drop existing tables if they exist
DROP TABLE IF EXISTS payment_items;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS payment_queues;
DROP TABLE IF EXISTS payment_disputes;
DROP TABLE IF EXISTS payment_receipts;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS documents;
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS queues;
DROP TABLE IF EXISTS user_roles;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS system_settings;
DROP TABLE IF EXISTS user_notification_settings;
DROP TABLE IF EXISTS managers;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS document;
DROP TABLE IF EXISTS transaction;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS user_role;
DROP TABLE IF EXISTS role;
DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS notification;
DROP TABLE IF EXISTS payment;
DROP TABLE IF EXISTS payment_queue;

-- Create users table
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20),
    address TEXT,
    balance DECIMAL(38,2) NOT NULL DEFAULT 0.00,
    role VARCHAR(255) NOT NULL DEFAULT 'USER',
    registration_status ENUM('PENDING', 'APPROVED', 'REJECTED') NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_activity TIMESTAMP,
    last_login TIMESTAMP,
    enabled BOOLEAN DEFAULT TRUE,
    account_non_expired BOOLEAN DEFAULT TRUE,
    account_non_locked BOOLEAN DEFAULT TRUE,
    credentials_non_expired BOOLEAN DEFAULT TRUE,
    online_status BOOLEAN DEFAULT FALSE,
    CONSTRAINT chk_email CHECK (email LIKE '%@%.%')
);

-- Create roles table
CREATE TABLE roles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

-- Create user_roles table
CREATE TABLE user_roles (
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
);

-- Create user_notification_settings table
CREATE TABLE user_notification_settings (
    user_id BIGINT NOT NULL,
    setting_key VARCHAR(50) NOT NULL,
    setting_value TEXT,
    PRIMARY KEY (user_id, setting_key),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create managers table
CREATE TABLE managers (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    department VARCHAR(100),
    employee_id VARCHAR(20) UNIQUE,
    profile_image VARCHAR(255),
    status VARCHAR(20) DEFAULT 'ACTIVE',
    last_active_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create students table
CREATE TABLE students (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    student_id VARCHAR(20) NOT NULL UNIQUE,
    program VARCHAR(100) NOT NULL,
    year_level INTEGER NOT NULL,
    academic_year VARCHAR(9) NOT NULL,
    semester VARCHAR(20) NOT NULL,
    registration_status ENUM('PENDING', 'APPROVED', 'REJECTED') NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create queues table
CREATE TABLE queues (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    queue_number VARCHAR(50) NOT NULL UNIQUE,
    student_id VARCHAR(20),
    user_id BIGINT NOT NULL,
    user_username VARCHAR(255) NOT NULL,
    status ENUM('PENDING', 'PROCESSING', 'COMPLETED', 'CANCELLED', 'FAILED') NOT NULL DEFAULT 'PENDING',
    priority ENUM('LOW', 'NORMAL', 'MEDIUM', 'HIGH', 'URGENT') NOT NULL DEFAULT 'NORMAL',
    position INT NOT NULL,
    estimated_wait_time INT,
    payment_id BIGINT,
    payment_number VARCHAR(50),
    amount DECIMAL(38,2),
    description TEXT,
    error_message TEXT,
    payment_gateway_response TEXT,
    schedule VARCHAR(50),
    schedule_id VARCHAR(50),
    type ENUM('BANK', 'CASH', 'CARD', 'ONLINE'),
    receipt_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    processed_at TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- Create payments table
CREATE TABLE payments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    payment_number VARCHAR(50) NOT NULL UNIQUE,
    transaction_id VARCHAR(50) UNIQUE,
    user_id BIGINT NOT NULL,
    queue_number VARCHAR(50),
    amount DECIMAL(19,2) NOT NULL,
    tax_amount DECIMAL(19,2) DEFAULT 0.00,
    total_amount DECIMAL(19,2) GENERATED ALWAYS AS (amount + tax_amount) VIRTUAL,
    description TEXT,
    purpose ENUM('EMPLOYMENT', 'FURTHER_STUDIES', 'BOARD_EXAM', 'PERSONAL'),
    copies INT,
    status ENUM('PENDING', 'PROCESSING', 'COMPLETED', 'FAILED', 'REFUNDED', 'PARTIALLY_REFUNDED', 'SCHEDULED', 'CANCELLED', 'DISPUTED') NOT NULL,
    type ENUM('CASH', 'CREDIT', 'DEBIT', 'BANK_TRANSFER') NOT NULL,
    payment_method VARCHAR(50),
    currency VARCHAR(3) DEFAULT 'USD',
    error_message TEXT,
    payment_gateway_response TEXT,
    schedule VARCHAR(50),
    schedule_id VARCHAR(50),
    receipt_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    processed_at TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_copies_positive CHECK (copies > 0)
);

-- Create payment_items table
CREATE TABLE payment_items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    payment_id BIGINT,
    name VARCHAR(100) NOT NULL,
    amount DECIMAL(19,2) NOT NULL,
    description TEXT,
    FOREIGN KEY (payment_id) REFERENCES payments(id) ON DELETE SET NULL,
    CONSTRAINT chk_payment_item_amount CHECK (amount >= 0)
);

-- Create payment_disputes table
CREATE TABLE payment_disputes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    dispute_number VARCHAR(50) NOT NULL UNIQUE,
    payment_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    reason VARCHAR(255) NOT NULL,
    status VARCHAR(50) NOT NULL,
    priority VARCHAR(20) DEFAULT 'NORMAL',
    evidence TEXT,
    resolution TEXT,
    refund_requested BOOLEAN DEFAULT FALSE,
    refund_approved BOOLEAN DEFAULT FALSE,
    assigned_to BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP,
    FOREIGN KEY (payment_id) REFERENCES payments(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (assigned_to) REFERENCES users(id)
);

-- Create payment_receipts table
CREATE TABLE payment_receipts (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    receipt_number VARCHAR(50) NOT NULL UNIQUE,
    payment_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    queue_number VARCHAR(50),
    terminal_id VARCHAR(50),
    service_name VARCHAR(100),
    amount DECIMAL(19,2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    receipt_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (payment_id) REFERENCES payments(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Create transactions table
CREATE TABLE transactions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    transaction_number VARCHAR(50) NOT NULL UNIQUE,
    receipt_id VARCHAR(50),
    amount DECIMAL(19,2) NOT NULL,
    description TEXT,
    status ENUM('PENDING', 'COMPLETED', 'FAILED', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
    type ENUM('PAYMENT', 'REFUND', 'ADJUSTMENT') NOT NULL,
    priority ENUM('LOW', 'NORMAL', 'HIGH', 'URGENT') NOT NULL DEFAULT 'NORMAL',
    category VARCHAR(100),
    sub_category VARCHAR(100),
    currency VARCHAR(3) DEFAULT 'USD',
    tax_amount DECIMAL(19,2) DEFAULT 0.00,
    notes TEXT,
    is_recurring BOOLEAN DEFAULT FALSE,
    recurring_frequency VARCHAR(50),
    next_due_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    processed_at TIMESTAMP,
    created_by VARCHAR(50),
    updated_by VARCHAR(50),
    user_id BIGINT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_transaction_amount CHECK (amount >= 0),
    CONSTRAINT chk_transaction_tax CHECK (tax_amount >= 0)
);

-- Create notifications table
CREATE TABLE notifications (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    message TEXT NOT NULL,
    type ENUM('INFO', 'WARNING', 'ERROR', 'SUCCESS') NOT NULL,
    status ENUM('UNREAD', 'READ') NOT NULL DEFAULT 'UNREAD',
    priority ENUM('LOW', 'NORMAL', 'HIGH', 'URGENT') NOT NULL DEFAULT 'NORMAL',
    is_system_notification BOOLEAN DEFAULT FALSE,
    settings TEXT NOT NULL DEFAULT '{}',
    payment_settings TEXT NOT NULL DEFAULT '{"allowedMethods": ["CASH"], "defaultMethod": "CASH", "cashOnly": true, "version": "1.0"}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP,
    user_id BIGINT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create documents table
CREATE TABLE documents (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    document_number VARCHAR(50) NOT NULL UNIQUE,
    document_type VARCHAR(50) NOT NULL,
    reference_number VARCHAR(50) NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    content_type VARCHAR(100) NOT NULL,
    size BIGINT NOT NULL,
    content LONGBLOB,
    file_path VARCHAR(255) NOT NULL,
    type ENUM('RECEIPT', 'INVOICE', 'CONTRACT', 'OTHER') NOT NULL,
    status ENUM('PENDING', 'APPROVED', 'REJECTED', 'ACTIVE') NOT NULL DEFAULT 'PENDING',
    priority ENUM('LOW', 'NORMAL', 'HIGH') NOT NULL DEFAULT 'NORMAL',
    description TEXT,
    user_id BIGINT NOT NULL,
    transaction_id BIGINT,
    reference_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (transaction_id) REFERENCES transactions(id)
);

-- Create system_settings table
CREATE TABLE system_settings (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(50) NOT NULL UNIQUE,
    setting_value TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_user_username ON users(username);
CREATE INDEX idx_user_email ON users(email);
CREATE INDEX idx_user_online ON users(online_status);
CREATE INDEX idx_queue_status ON queues(status);
CREATE INDEX idx_queue_priority ON queues(priority);
CREATE INDEX idx_queue_user ON queues(user_id);
CREATE INDEX idx_queue_number ON queues(queue_number);
CREATE INDEX idx_queue_student ON queues(student_id);
CREATE INDEX idx_transaction_number ON transactions(transaction_number);
CREATE INDEX idx_transaction_status ON transactions(status);
CREATE INDEX idx_transaction_type ON transactions(type);
CREATE INDEX idx_transaction_user ON transactions(user_id);
CREATE INDEX idx_transaction_created ON transactions(created_at);
CREATE INDEX idx_notification_system ON notifications(is_system_notification);
CREATE INDEX idx_notification_read ON notifications(is_read);
CREATE INDEX idx_notification_user ON notifications(user_id);
CREATE INDEX idx_notification_created ON notifications(created_at);
CREATE INDEX idx_payment_status ON payments(status);
CREATE INDEX idx_payment_type ON payments(type);
CREATE INDEX idx_payment_user ON payments(user_id);
CREATE INDEX idx_payment_number ON payments(payment_number);
CREATE INDEX idx_payment_transaction ON payments(transaction_id);
CREATE INDEX idx_payment_queue ON payments(queue_number);
CREATE INDEX idx_payment_created ON payments(created_at);
CREATE INDEX idx_payment_purpose ON payments(purpose);
CREATE INDEX idx_payment_items_payment ON payment_items(payment_id);
CREATE INDEX idx_payment_disputes_payment ON payment_disputes(payment_id);
CREATE INDEX idx_payment_disputes_user ON payment_disputes(user_id);
CREATE INDEX idx_payment_disputes_number ON payment_disputes(dispute_number);
CREATE INDEX idx_payment_receipts_payment ON payment_receipts(payment_id);
CREATE INDEX idx_payment_receipts_user ON payment_receipts(user_id);
CREATE INDEX idx_payment_receipts_number ON payment_receipts(receipt_number);
CREATE INDEX idx_document_user ON documents(user_id);
CREATE INDEX idx_document_type ON documents(document_type);
CREATE INDEX idx_document_status ON documents(status);
CREATE INDEX idx_document_number ON documents(document_number);
CREATE INDEX idx_settings_key ON system_settings(setting_key);
CREATE INDEX idx_manager_user ON managers(user_id);
CREATE INDEX idx_manager_employee ON managers(employee_id);
CREATE INDEX idx_student_user ON students(user_id);
CREATE INDEX idx_student_id ON students(student_id);

-- Insert default roles
INSERT INTO roles (name, description) VALUES 
('ROLE_ADMIN', 'Administrator with full system access'),
('ROLE_MANAGER', 'Manager with elevated privileges'),
('ROLE_USER', 'Regular user with basic access'),
('ROLE_STUDENT', 'Student with academic access');

-- Insert default system settings
INSERT INTO system_settings (setting_key, setting_value, description) VALUES
('system.name', 'Accounting Management System', 'Name of the system'),
('system.version', '1.0.0', 'Current system version'),
('system.maintenance', 'false', 'System maintenance mode'),
('system.timezone', 'UTC', 'System timezone'),
('system.currency', 'USD', 'Default system currency'),
('system.queue.max_wait_time', '30', 'Maximum wait time in minutes'),
('system.notification.enabled', 'true', 'Enable system notifications'),
('system.payment.methods', 'CASH,CREDIT_CARD,BANK_TRANSFER', 'Available payment methods');

-- Create User table
CREATE TABLE user (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    enabled BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create Role table
CREATE TABLE role (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- Create User_Role join table
CREATE TABLE user_role (
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (role_id) REFERENCES role(id)
);

-- Create Student table
CREATE TABLE student (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    student_id VARCHAR(20) NOT NULL UNIQUE,
    program VARCHAR(100) NOT NULL,
    year_level INTEGER NOT NULL,
    academic_year VARCHAR(9) NOT NULL,
    semester VARCHAR(20) NOT NULL,
    registration_status ENUM('PENDING', 'APPROVED', 'REJECTED') NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(id)
);

-- Create Transaction table
CREATE TABLE transaction (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    transaction_number VARCHAR(50) NOT NULL UNIQUE,
    receipt_id VARCHAR(50),
    amount DECIMAL(19,2) NOT NULL,
    status ENUM('PENDING', 'COMPLETED', 'FAILED', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
    type ENUM('PAYMENT', 'REFUND', 'ADJUSTMENT') NOT NULL,
    priority ENUM('NORMAL', 'HIGH', 'URGENT') NOT NULL DEFAULT 'NORMAL',
    category VARCHAR(100),
    sub_category VARCHAR(100),
    currency VARCHAR(3) NOT NULL DEFAULT 'USD',
    tax_amount DECIMAL(19,2) DEFAULT 0.00,
    notes TEXT,
    is_recurring BOOLEAN DEFAULT FALSE,
    recurring_frequency VARCHAR(50),
    next_due_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    processed_at TIMESTAMP,
    created_by VARCHAR(50),
    updated_by VARCHAR(50),
    user_id BIGINT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(id)
);

-- Create Document table
CREATE TABLE document (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    file_name VARCHAR(255) NOT NULL,
    content_type VARCHAR(100) NOT NULL,
    size BIGINT NOT NULL,
    content LONGBLOB,
    type ENUM('RECEIPT', 'INVOICE', 'CONTRACT', 'OTHER') NOT NULL,
    status ENUM('PENDING', 'APPROVED', 'REJECTED') NOT NULL DEFAULT 'PENDING',
    priority ENUM('LOW', 'NORMAL', 'HIGH') NOT NULL DEFAULT 'NORMAL',
    description TEXT,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id BIGINT NOT NULL,
    transaction_id BIGINT,
    reference_id BIGINT,
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (transaction_id) REFERENCES transaction(id)
);

-- Insert default roles
INSERT INTO role (name) VALUES ('ROLE_USER');
INSERT INTO role (name) VALUES ('ROLE_ADMIN');
INSERT INTO role (name) VALUES ('ROLE_STUDENT');

-- Create Notification table
CREATE TABLE notification (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    message TEXT NOT NULL,
    type ENUM('INFO', 'WARNING', 'ERROR', 'SUCCESS') NOT NULL,
    status ENUM('UNREAD', 'READ') NOT NULL DEFAULT 'UNREAD',
    priority ENUM('LOW', 'NORMAL', 'HIGH', 'URGENT') NOT NULL DEFAULT 'NORMAL',
    is_system_notification BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP,
    user_id BIGINT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(id)
);

-- Create Payment Queue table
CREATE TABLE payment_queue (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    queue_number VARCHAR(20) NOT NULL UNIQUE,
    status ENUM('WAITING', 'PROCESSING', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'WAITING',
    priority ENUM('NORMAL', 'HIGH', 'URGENT') NOT NULL DEFAULT 'NORMAL',
    position INT NOT NULL,
    estimated_wait_time INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    processed_at TIMESTAMP,
    user_id BIGINT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(id)
);

-- Create Payment table
CREATE TABLE payment (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    payment_number VARCHAR(50) NOT NULL UNIQUE,
    amount DECIMAL(19,2) NOT NULL,
    status ENUM('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED') NOT NULL DEFAULT 'PENDING',
    type ENUM('CASH', 'CREDIT_CARD', 'BANK_TRANSFER') NOT NULL,
    currency VARCHAR(3) NOT NULL DEFAULT 'USD',
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    processed_at TIMESTAMP,
    user_id BIGINT NOT NULL,
    payment_queue_id BIGINT,
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (payment_queue_id) REFERENCES payment_queue(id)
); 