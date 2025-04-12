-- Update admin password to 'admin123'
UPDATE users 
SET password = '$2a$10$N/qw.hC1J8JNvvtUOsX3q.1.1X1OYtYRwK1AOLZ9vMh.Rj0YH8yaW'
WHERE username = 'admin';

-- Update manager password to 'manager123'
UPDATE users 
SET password = '$2a$10$N/qw.hC1J8JNvvtUOsX3q.1.1X1OYtYRwK1AOLZ9vMh.Rj0YH8yaW'
WHERE username = 'manager'; 