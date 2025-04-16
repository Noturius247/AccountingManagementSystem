-- Drop existing default values and constraints
ALTER TABLE payments ALTER COLUMN status DROP DEFAULT;
ALTER TABLE payments ALTER COLUMN type DROP DEFAULT;

-- Modify existing columns
ALTER TABLE payments 
    MODIFY COLUMN amount DECIMAL(19,2) NOT NULL,
    MODIFY COLUMN status ENUM('PENDING', 'PROCESSED', 'FAILED', 'REFUNDED') NOT NULL,
    MODIFY COLUMN type ENUM('BANK', 'CASH', 'CARD', 'ONLINE') NOT NULL,
    MODIFY COLUMN currency VARCHAR(3) NOT NULL DEFAULT 'USD',
    MODIFY COLUMN tax_amount DECIMAL(19,2) NOT NULL DEFAULT 0.00;

-- Add new columns for aggregation queries
ALTER TABLE payments ADD COLUMN total_amount DECIMAL(19,2) AS (amount + tax_amount) VIRTUAL;

-- Add indexes for better query performance
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_payments_type ON payments(type);
CREATE INDEX idx_payments_created_at ON payments(created_at);
CREATE INDEX idx_payments_user_id ON payments(user_id);

-- Add foreign key constraint
ALTER TABLE payments
    ADD CONSTRAINT fk_payments_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE; 