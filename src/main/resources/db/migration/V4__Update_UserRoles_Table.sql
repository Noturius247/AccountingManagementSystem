-- First drop the foreign key constraints
ALTER TABLE user_roles DROP FOREIGN KEY fk_user_roles_role;
ALTER TABLE user_roles DROP FOREIGN KEY fk_user_roles_user;

-- Drop the primary key constraint
ALTER TABLE user_roles DROP PRIMARY KEY;

-- Drop columns that are no longer needed
ALTER TABLE user_roles DROP COLUMN role_id;
ALTER TABLE user_roles DROP COLUMN id;

-- Add or modify the role column
ALTER TABLE user_roles ADD COLUMN role VARCHAR(50) NOT NULL;

-- Add new primary key constraint
ALTER TABLE user_roles ADD PRIMARY KEY (user_id, role);

-- Add new foreign key constraint
ALTER TABLE user_roles ADD CONSTRAINT fk_user_roles_user 
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE; 