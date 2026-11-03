-- CSC6302 Database Principles
-- Module 01 Exercise 01
-- Family Spooky Vacation Database
-- Verified relational queries

USE FamilySpookyVacation;

-- =========================================================
-- QUERY 1
-- Display each family member's ranked vacation preferences
-- =========================================================

SELECT
    fm.MemberName,
    vs.SiteName,
    fs.PreferenceRank
FROM FAMILY_SITE AS fs
JOIN FAMILY_MEMBER AS fm
    ON fs.MemberID = fm.MemberID
JOIN VACATION_SITE AS vs
    ON fs.SiteID = vs.SiteID
ORDER BY
    fm.MemberID,
    fs.PreferenceRank;
