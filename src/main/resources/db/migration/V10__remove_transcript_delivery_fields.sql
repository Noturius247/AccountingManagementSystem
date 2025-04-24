-- Remove delivery-related columns from payments table
ALTER TABLE payments
    DROP COLUMN delivery_method,
    DROP COLUMN courier_fee;
 
-- Drop the index for delivery_method since we're removing the column
DROP INDEX idx_payments_delivery_method ON payments; 