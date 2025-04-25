-- Modify the type enum to include all payment types from PaymentType.java
ALTER TABLE payments 
    MODIFY COLUMN type ENUM(
        'CASH',
        'CREDIT_CARD',
        'DEBIT_CARD',
        'BANK_TRANSFER',
        'ONLINE_PAYMENT',
        'OTHER',
        'TUITION',
        'LIBRARY',
        'LAB',
        'ID',
        'GRADUATION',
        'TRANSCRIPT',
        'CHEMISTRY',
        'ENROLLMENT'
    ) NOT NULL; 