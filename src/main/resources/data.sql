-- Insert initial data for the application

-- Insert mock user with BCrypt encoded password ('password')
INSERT INTO users (username, password, email, first_name, last_name, created_at, updated_at) 
VALUES ('admin', '$2a$10$GRLdNijSQMUvl/au9ofL.eDwmoohzzS7.rmNSJZ.0FxO/BTk76klW', 
        'admin@example.com', 'Admin', 'User', '2024-04-05T00:00:00', '2024-04-05T00:00:00');

-- Insert roles
INSERT INTO roles (name) VALUES ('ROLE_USER');
INSERT INTO roles (name) VALUES ('ROLE_ADMIN');

-- Assign admin role to admin user
INSERT INTO user_roles (user_id, role_id) 
SELECT u.id, r.id 
FROM users u, roles r 
WHERE u.username = 'admin' AND r.name = 'ROLE_ADMIN'; 