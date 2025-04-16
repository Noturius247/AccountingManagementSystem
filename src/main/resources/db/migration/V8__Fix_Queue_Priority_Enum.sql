-- First update any invalid priority values to a default value
UPDATE queues SET priority = 'NORMAL' WHERE priority NOT IN ('LOW', 'NORMAL', 'MEDIUM', 'HIGH', 'URGENT');

-- Then modify the column
ALTER TABLE queues 
MODIFY COLUMN priority ENUM('LOW', 'NORMAL', 'MEDIUM', 'HIGH', 'URGENT') NOT NULL DEFAULT 'NORMAL'; 