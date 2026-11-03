-- CSC6302 Database Principles
-- Module 01 Exercise 01
-- Family Spooky Vacation Database
-- Integrity Constraint Test Suite

USE FamilySpookyVacation;

-- =========================================================
-- TEST 1: PRIMARY KEY
-- EXPECTED RESULT: FAIL
-- MemberID 1 already exists.
-- =========================================================

INSERT INTO FAMILY_MEMBER
    (MemberID, MemberName)
VALUES
    (1, 'Duplicate Alex');


-- =========================================================
-- TEST 2: NOT NULL
-- EXPECTED RESULT: FAIL
-- MemberName is required.
-- =========================================================

INSERT INTO FAMILY_MEMBER
    (MemberID, MemberName)
VALUES
    (50, NULL);


-- =========================================================
-- TEST 3: CHECK - SPOOKINESS LEVEL
-- EXPECTED RESULT: FAIL
-- Allowed range is 1 through 5.
-- =========================================================

INSERT INTO VACATION_SITE
    (SiteID, SiteName, Location, SpookinessLevel)
VALUES
    (50, 'Impossible Manor', 'Nowhere', 9);


-- =========================================================
-- TEST 4: FOREIGN KEY
-- EXPECTED RESULT: FAIL
-- MemberID 999 does not exist.
-- =========================================================

INSERT INTO FAMILY_SITE
    (MemberID, SiteID, PreferenceRank)
VALUES
    (999, 1, 1);


-- =========================================================
-- TEST 5: ALTERNATE CANDIDATE KEY / UNIQUE
-- EXPECTED RESULT: FAIL
-- Alex already assigned PreferenceRank 1.
-- =========================================================

INSERT INTO FAMILY_SITE
    (MemberID, SiteID, PreferenceRank)
VALUES
    (1, 4, 1);


-- =========================================================
-- TEST 6: CHECK - PREFERENCE RANK
-- EXPECTED RESULT: FAIL
-- PreferenceRank must be greater than zero.
-- =========================================================

INSERT INTO FAMILY_SITE
    (MemberID, SiteID, PreferenceRank)
VALUES
    (1, 4, 0);


-- =========================================================
-- TEST 7: CHECK - ITEM CATEGORY
-- EXPECTED RESULT: FAIL
-- Magic is not an allowed ItemCategory.
-- =========================================================

INSERT INTO PACKING_ITEM
    (ItemID, ItemName, ItemCategory)
VALUES
    (50, 'Crystal Ball', 'Magic');


-- =========================================================
-- TEST 8: CHECK - QUANTITY
-- EXPECTED RESULT: FAIL
-- Quantity must be greater than zero.
-- =========================================================

INSERT INTO MEMBER_ITEM
    (MemberID, ItemID, Quantity, PackedStatus)
VALUES
    (1, 8, 0, FALSE);


-- =========================================================
-- TEST 9: DEFAULT VALUE
-- EXPECTED RESULT: PASS
-- PackedStatus is omitted and should default to FALSE.
-- =========================================================

INSERT INTO MEMBER_ITEM
    (MemberID, ItemID, Quantity)
VALUES
    (1, 8, 2);

SELECT
    MemberID,
    ItemID,
    Quantity,
    PackedStatus
FROM MEMBER_ITEM
WHERE MemberID = 1
  AND ItemID = 8;


-- Clean up the successful temporary test row.

DELETE FROM MEMBER_ITEM
WHERE MemberID = 1
  AND ItemID = 8;


-- =========================================================
-- TEST 10: REFERENTIAL INTEGRITY ON DELETE
-- EXPECTED RESULT: FAIL
-- SiteID 1 is referenced by child rows.
-- =========================================================

DELETE FROM VACATION_SITE
WHERE SiteID = 1;
