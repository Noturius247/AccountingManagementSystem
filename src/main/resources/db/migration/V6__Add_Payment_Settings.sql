-- Add payment_settings column with default cash-only configuration
ALTER TABLE notifications
ADD COLUMN payment_settings TEXT NOT NULL DEFAULT '{"allowedMethods": ["CASH"], "defaultMethod": "CASH", "cashOnly": true, "version": "1.0"}'; 