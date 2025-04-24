-- Add purpose and copies columns to payments table
ALTER TABLE payments
    ADD COLUMN purpose VARCHAR(50),
    ADD COLUMN copies INT;

-- Create an index on purpose for better query performance
CREATE INDEX idx_payments_purpose ON payments(purpose);

-- Add check constraint to ensure copies is positive
ALTER TABLE payments
    ADD CONSTRAINT chk_copies_positive CHECK (copies > 0);

-- Add check constraint to validate purpose values
ALTER TABLE payments
    ADD CONSTRAINT chk_purpose_values 
    CHECK (purpose IN ('EMPLOYMENT', 'FURTHER_STUDIES', 'BOARD_EXAM', 'PERSONAL')); 