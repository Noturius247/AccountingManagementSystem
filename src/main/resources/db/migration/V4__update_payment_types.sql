-- Modify the type enum to include new payment types
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