-- Add transcript-specific columns to payments table
ALTER TABLE payments
    ADD COLUMN copies INT,
    ADD COLUMN purpose VARCHAR(50),
    ADD COLUMN delivery_method VARCHAR(20),
    ADD COLUMN base_price DECIMAL(19,2),
    ADD COLUMN courier_fee DECIMAL(19,2);

-- Add index for common queries
CREATE INDEX idx_payments_purpose ON payments(purpose);
CREATE INDEX idx_payments_delivery_method ON payments(delivery_method); 