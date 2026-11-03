-- CSC6302 Database Principles
-- Week 1 Programming Assignment
-- Required ALTER TABLE Operations

USE ParanormalExpedition;

-- =========================================================
-- ADD COLUMN
-- Add a non-nullable column with a default value.
-- Existing evidence records will receive the default value.
-- =========================================================

ALTER TABLE Evidence
ADD COLUMN review_status VARCHAR(20) NOT NULL DEFAULT 'Pending';


-- =========================================================
-- DROP COLUMN
-- Remove the temporary legacy equipment tracking field.
-- =========================================================

ALTER TABLE Equipment
DROP COLUMN legacy_code;


-- =========================================================
-- VERIFY CHANGES
-- =========================================================

DESCRIBE Evidence;

DESCRIBE Equipment;