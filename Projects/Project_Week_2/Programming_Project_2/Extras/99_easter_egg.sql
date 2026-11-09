-- OPTIONAL LOCAL EXTRA
-- Not included in the graded Project 2 submission.

USE HolidayPlanner;

ALTER TABLE FamilyMember
COMMENT =
'Keown White Easter Egg | My first console was bought with money from my dad''s contracting breakthrough. Whether I had permission to use that money is outside the scope of this query.';

-- Find the easter egg:
SELECT TABLE_COMMENT
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'HolidayPlanner'
  AND LOCATE('Keown White', TABLE_COMMENT) > 0;
