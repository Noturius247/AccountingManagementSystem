-- Clear existing data (if any)
DELETE FROM payment_items;
DELETE FROM payments;
DELETE FROM payment_queues;
DELETE FROM transactions;
DELETE FROM notifications;
DELETE FROM queues;
DELETE FROM user_roles;
DELETE FROM roles;
DELETE FROM users;
DELETE FROM system_settings;

-- Insert roles (if not exists)
MERGE INTO roles (name, description) KEY(name) VALUES 
('ROLE_ADMIN', 'Administrator with full system access'),
('ROLE_MANAGER', 'Manager with elevated privileges'),
('ROLE_USER', 'Regular user with basic access');

-- Insert admin user (if not exists)
MERGE INTO users (username, password, email, first_name, last_name, enabled, created_at, updated_at) KEY(username)
VALUES ('admin', '$2a$10$GRLdNijSQMUvl/au9ofL.eDwmoohzzS7.rmNSJZ.0FxO/BTk76klW', 
        'admin@example.com', 'Admin', 'User', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert manager user (if not exists)
MERGE INTO users (username, password, email, first_name, last_name, enabled, created_at, updated_at) KEY(username)
VALUES ('manager', '$2a$10$GRLdNijSQMUvl/au9ofL.eDwmoohzzS7.rmNSJZ.0FxO/BTk76klW', 
        'manager@example.com', 'Manager', 'User', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Assign roles to users
MERGE INTO user_roles (user_id, role_id) KEY(user_id, role_id)
SELECT u.id, r.id FROM users u, roles r 
WHERE u.username = 'admin' AND r.name = 'ROLE_ADMIN';

MERGE INTO user_roles (user_id, role_id) KEY(user_id, role_id)
SELECT u.id, r.id FROM users u, roles r 
WHERE u.username = 'manager' AND r.name = 'ROLE_MANAGER';

-- Insert payment items
INSERT INTO payment_items (name, amount, description)
VALUES 
('Tuition Fee', 5000.00, 'Semester tuition payment'),
('Library Fee', 100.00, 'Library membership fee'),
('Lab Fee', 200.00, 'Laboratory equipment fee'),
('ID Replacement', 50.00, 'Student ID card replacement');

-- Insert queues
INSERT INTO queues (queue_number, status, priority, position, user_id, created_at)
SELECT 
    '230820-001', 'WAITING', 'REGULAR', 1, u.id, CURRENT_TIMESTAMP
FROM users u
WHERE u.username = 'admin';

-- Insert transactions
INSERT INTO transactions (transaction_number, amount, description, status, type, priority, user_id, created_at)
SELECT 
    'TRX-001', 5000.00, 'Tuition Fee Payment', 'COMPLETED', 'PAYMENT', 'NORMAL', u.id, CURRENT_TIMESTAMP
FROM users u
WHERE u.username = 'admin';

-- Insert notifications
INSERT INTO notifications (title, message, type, status, priority, is_read, user_id, created_at)
SELECT 
    'Welcome to the System', 
    'Your account has been created successfully', 
    'INFO', 
    'UNREAD', 
    'NORMAL', 
    false, 
    u.id, 
    CURRENT_TIMESTAMP
FROM users u
WHERE u.username = 'admin';

-- Insert payment queues
INSERT INTO payment_queues (queue_number, status, priority, position, user_id, created_at)
SELECT 
    'PAY-001', 'WAITING', 'REGULAR', 1, u.id, CURRENT_TIMESTAMP
FROM users u
WHERE u.username = 'admin';

-- Insert payments
INSERT INTO payments (payment_number, amount, description, status, type, priority, user_id, payment_queue_id, created_at)
SELECT 
    'PAY-001', 
    5000.00, 
    'Tuition Fee Payment', 
    'PENDING', 
    'CASH', 
    'NORMAL', 
    u.id, 
    pq.id, 
    CURRENT_TIMESTAMP
FROM users u, payment_queues pq
WHERE u.username = 'admin' AND pq.queue_number = 'PAY-001';

-- Insert system settings
INSERT INTO system_settings (setting_key, setting_value, description)
VALUES 
('system.name', 'Accounting Management System', 'Name of the system'),
('system.version', '1.0.0', 'Current system version'),
('system.maintenance', 'false', 'System maintenance mode'),
('system.timezone', 'UTC', 'System timezone'),
('system.currency', 'USD', 'Default system currency'),
('system.queue.max_wait_time', '30', 'Maximum wait time in minutes'),
('system.notification.enabled', 'true', 'Enable system notifications'),
('system.payment.methods', 'CASH,CREDIT_CARD,BANK_TRANSFER', 'Available payment methods'); 