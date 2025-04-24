-- Remove delivery-related columns from transcript payments only
ALTER TABLE payments
    DROP COLUMN IF EXISTS delivery_method,
    DROP COLUMN IF EXISTS courier_fee
WHERE type = 'TRANSCRIPT';
 
-- Drop the index for delivery_method if it exists
DROP INDEX IF EXISTS idx_payments_delivery_method; 