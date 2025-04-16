-- Add payment_number column
ALTER TABLE payments 
ADD COLUMN payment_number VARCHAR(50) NOT NULL UNIQUE;

-- Update any null payment numbers with a generated value
UPDATE payments 
SET payment_number = CONCAT('PAY-', DATE_FORMAT(created_at, '%Y%m%d'), '-', LPAD(id, 5, '0'))
WHERE payment_number IS NULL OR payment_number = ''; 