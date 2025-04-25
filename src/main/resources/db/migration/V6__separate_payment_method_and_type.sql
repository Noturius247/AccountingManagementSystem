-- Revert type column to only include payment types
ALTER TABLE payments 
    MODIFY COLUMN type ENUM(
        'TUITION',
        'LIBRARY',
        'LAB',
        'ID',
        'GRADUATION',
        'TRANSCRIPT',
        'CHEMISTRY',
        'ENROLLMENT'
    ) NOT NULL;

-- Modify payment_method column to be an ENUM
ALTER TABLE payments 
    MODIFY COLUMN payment_method ENUM(
        'CASH',
        'CREDIT_CARD',
        'DEBIT_CARD',
        'BANK_TRANSFER',
        'ONLINE_PAYMENT',
        'KIOSK',
        'OTHER'
    ) NOT NULL; 