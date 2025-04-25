-- Convert type column from ENUM to VARCHAR
ALTER TABLE payments 
    MODIFY COLUMN type VARCHAR(10) NOT NULL;

-- Add a comment to explain the change
-- Payment types will now be stored as simple strings: TUI, LIB, LAB, ID, GRAD, TOR, CHEM, ENR 