-- CSC6302 Database Principles
-- Week 1 Programming Assignment
-- Required ALTER TABLE Operations
--
-- This script is designed to run more than once without failure.

USE ParanormalExpedition;

-- =========================================================
-- ADD COLUMN
-- Add review_status only when it does not already exist.
-- =========================================================

SET @add_review_status = (
    SELECT IF(
        COUNT(*) = 0,
        'ALTER TABLE Evidence ADD COLUMN review_status VARCHAR(20) NOT NULL DEFAULT ''Pending''',
        'SELECT ''review_status already exists; no change required'' AS status_message'
    )
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'Evidence'
      AND COLUMN_NAME = 'review_status'
);

PREPARE add_column_statement FROM @add_review_status;
EXECUTE add_column_statement;
DEALLOCATE PREPARE add_column_statement;


-- =========================================================
-- DROP COLUMN
-- Remove legacy_code only when it still exists.
-- =========================================================

SET @drop_legacy_code = (
    SELECT IF(
        COUNT(*) = 1,
        'ALTER TABLE Equipment DROP COLUMN legacy_code',
        'SELECT ''legacy_code already removed; no change required'' AS status_message'
    )
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'Equipment'
      AND COLUMN_NAME = 'legacy_code'
);

PREPARE drop_column_statement FROM @drop_legacy_code;
EXECUTE drop_column_statement;
DEALLOCATE PREPARE drop_column_statement;


-- =========================================================
-- VERIFY FINAL STRUCTURE
-- =========================================================

DESCRIBE Evidence;
DESCRIBE Equipment;