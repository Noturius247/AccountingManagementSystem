-- Insert initial data for the application

-- Insert mock user with BCrypt encoded password ('password')
INSERT INTO users (username, password, email, first_name, last_name, enabled, created_at, updated_at) 
VALUES ('admin', '$2a$10$GRLdNijSQMUvl/au9ofL.eDwmoohzzS7.rmNSJZ.0FxO/BTk76klW', 
        'admin@example.com', 'Admin', 'User', true, '2024-04-05T00:00:00', '2024-04-05T00:00:00');

-- Insert roles
INSERT INTO roles (name) VALUES ('ROLE_USER');
INSERT INTO roles (name) VALUES ('ROLE_ADMIN');

-- Assign admin role to admin user
INSERT INTO user_roles (user_id, role_id) 
SELECT u.id, r.id 
FROM users u, roles r 
WHERE u.username = 'admin' AND r.name = 'ROLE_ADMIN';

-- Insert mock transactions
INSERT INTO transaction (amount, description, status, timestamp, user_id, created_at, updated_at)
SELECT 
    1000.00, 'Salary Payment', 'COMPLETED', '2024-04-01T09:00:00', u.id, '2024-04-01T09:00:00', '2024-04-01T09:00:00'
FROM users u WHERE u.username = 'admin';

INSERT INTO transaction (amount, description, status, timestamp, user_id, created_at, updated_at)
SELECT 
    500.00, 'Bonus Payment', 'COMPLETED', '2024-04-01T10:00:00', u.id, '2024-04-01T10:00:00', '2024-04-01T10:00:00'
FROM users u WHERE u.username = 'admin';

INSERT INTO transaction (amount, description, status, timestamp, user_id, created_at, updated_at)
SELECT 
    200.00, 'Expense Reimbursement', 'COMPLETED', '2024-04-02T11:00:00', u.id, '2024-04-02T11:00:00', '2024-04-02T11:00:00'
FROM users u WHERE u.username = 'admin';

INSERT INTO transaction (amount, description, status, timestamp, user_id, created_at, updated_at)
SELECT 
    300.00, 'Project Payment', 'COMPLETED', '2024-04-03T14:00:00', u.id, '2024-04-03T14:00:00', '2024-04-03T14:00:00'
FROM users u WHERE u.username = 'admin';

INSERT INTO transaction (amount, description, status, timestamp, user_id, created_at, updated_at)
SELECT 
    150.00, 'Consulting Fee', 'PENDING', '2024-04-04T15:00:00', u.id, '2024-04-04T15:00:00', '2024-04-04T15:00:00'
FROM users u WHERE u.username = 'admin'; 