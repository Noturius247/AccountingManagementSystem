-- First backup existing settings
ALTER TABLE notifications 
ADD COLUMN old_settings TEXT;

UPDATE notifications 
SET old_settings = settings;

-- Drop existing settings column
ALTER TABLE notifications 
DROP COLUMN settings;

-- Add settings column
ALTER TABLE notifications 
ADD COLUMN settings TEXT;

-- Set default value for settings
UPDATE notifications 
SET settings = '{}';

-- Make settings NOT NULL after setting default
ALTER TABLE notifications 
MODIFY COLUMN settings TEXT NOT NULL;

-- Copy data back if exists
UPDATE notifications 
SET settings = CASE 
    WHEN old_settings IS NOT NULL AND old_settings != '' 
    THEN old_settings 
    ELSE '{}' 
END;

-- Drop backup column
ALTER TABLE notifications 
DROP COLUMN old_settings;

-- Add payment_settings column
ALTER TABLE notifications
ADD COLUMN payment_settings TEXT;

-- Set default value for payment_settings
UPDATE notifications 
SET payment_settings = '{"allowedMethods": ["CASH"], "defaultMethod": "CASH", "cashOnly": true, "version": "1.0"}';

-- Make payment_settings NOT NULL after setting default
ALTER TABLE notifications 
MODIFY COLUMN payment_settings TEXT NOT NULL; 