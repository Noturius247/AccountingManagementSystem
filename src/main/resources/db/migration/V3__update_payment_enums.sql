-- First, modify the status enum to include all possible values
ALTER TABLE payments 
    MODIFY COLUMN status ENUM(
        'PENDING',
        'PROCESSING',
        'COMPLETED',
        'FAILED',
        'REFUNDED',
        'PARTIALLY_REFUNDED',
        'SCHEDULED',
        'CANCELLED',
        'DISPUTED'
    ) NOT NULL;

-- Then, modify the type enum to match PaymentType.java
ALTER TABLE payments 
    MODIFY COLUMN type ENUM(
        'CASH',
        'CREDIT',
        'DEBIT',
        'BANK_TRANSFER'
    ) NOT NULL;

-- Update existing records to match new enum values
UPDATE payments SET status = 'COMPLETED' WHERE status = 'PROCESSED';
UPDATE payments SET type = 'BANK_TRANSFER' WHERE type = 'BANK';
UPDATE payments SET type = 'CREDIT' WHERE type = 'CARD';
UPDATE payments SET type = 'CASH' WHERE type = 'ONLINE'; 