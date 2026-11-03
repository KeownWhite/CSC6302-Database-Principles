-- CSC6302 Database Principles
-- Module 01 Exercise 01
-- Family Spooky Vacation Database
-- Valid sample data for testing

USE FamilySpookyVacation;

-- =========================================================
-- CLEAN EXISTING DATA
-- Delete children before parents so foreign keys remain valid
-- =========================================================

DELETE FROM MEMBER_ITEM;
DELETE FROM SITE_ACTIVITY;
DELETE FROM FAMILY_SITE;
DELETE FROM PACKING_ITEM;
DELETE FROM ACTIVITY;
DELETE FROM VACATION_SITE;
DELETE FROM FAMILY_MEMBER;

ALTER TABLE FAMILY_MEMBER AUTO_INCREMENT = 1;
ALTER TABLE VACATION_SITE AUTO_INCREMENT = 1;
ALTER TABLE ACTIVITY AUTO_INCREMENT = 1;
ALTER TABLE PACKING_ITEM AUTO_INCREMENT = 1;


-- =========================================================
-- FAMILY MEMBERS
-- =========================================================

INSERT INTO FAMILY_MEMBER
    (MemberID, MemberName)
VALUES
    (1, 'Alex Carter'),
    (2, 'Jordan Carter'),
    (3, 'Maya Carter'),
    (4, 'Noah Carter');


-- =========================================================
-- SPOOKY VACATION DESTINATIONS
-- =========================================================

INSERT INTO VACATION_SITE
    (SiteID, SiteName, Location, SpookinessLevel)
VALUES
    (1, 'Raven Hollow Lodge', 'Hudson Valley, NY', 4),
    (2, 'Blackwood Manor', 'Berkshires, MA', 5),
    (3, 'Coldwater Observatory', 'Litchfield Hills, CT', 3),
    (4, 'Hollow Creek Inn', 'Green Mountains, VT', 2);


-- =========================================================
-- ACTIVITIES
-- =========================================================

INSERT INTO ACTIVITY
    (ActivityID, ActivityName, ActivityCategory)
VALUES
    (1, 'Night Photography', 'Photography'),
    (2, 'Historic Architecture Tour', 'Tour'),
    (3, 'Lantern Trail Walk', 'Outdoor'),
    (4, 'Stargazing', 'Observation'),
    (5, 'Costume Dinner', 'Entertainment'),
    (6, 'Local Folklore Tour', 'Tour');


-- =========================================================
-- PACKING ITEMS
-- =========================================================

INSERT INTO PACKING_ITEM
    (ItemID, ItemName, ItemCategory)
VALUES
    (1, 'Flashlight', 'Equipment'),
    (2, 'First-Aid Kit', 'Safety'),
    (3, 'Hand Warmers', 'Comfort'),
    (4, 'Snacks', 'Food'),
    (5, 'Victorian Costume', 'Costume'),
    (6, 'Warm Boots', 'Comfort'),
    (7, 'Portable Charger', 'Equipment'),
    (8, 'Glowsticks', 'Safety');


-- =========================================================
-- FAMILY DESTINATION PREFERENCES
-- Each member uses each numerical rank only once
-- =========================================================

INSERT INTO FAMILY_SITE
    (MemberID, SiteID, PreferenceRank)
VALUES
    (1, 2, 1),
    (1, 1, 2),
    (1, 3, 3),

    (2, 1, 1),
    (2, 4, 2),
    (2, 2, 3),

    (3, 3, 1),
    (3, 2, 2),
    (3, 1, 3),

    (4, 4, 1),
    (4, 3, 2),
    (4, 1, 3);


-- =========================================================
-- ACTIVITIES AVAILABLE AT EACH SITE
-- =========================================================

INSERT INTO SITE_ACTIVITY
    (SiteID, ActivityID)
VALUES
    (1, 1),
    (1, 3),
    (1, 6),

    (2, 1),
    (2, 2),
    (2, 5),

    (3, 1),
    (3, 4),

    (4, 3),
    (4, 4),
    (4, 6);


-- =========================================================
-- FAMILY PACKING ASSIGNMENTS
-- =========================================================

INSERT INTO MEMBER_ITEM
    (MemberID, ItemID, Quantity, PackedStatus)
VALUES
    (1, 1, 1, FALSE),
    (1, 2, 1, TRUE),
    (1, 7, 2, FALSE),

    (2, 3, 4, TRUE),
    (2, 5, 1, FALSE),
    (2, 6, 1, TRUE),

    (3, 1, 1, TRUE),
    (3, 4, 3, FALSE),
    (3, 8, 4, FALSE),

    (4, 2, 1, TRUE),
    (4, 4, 2, TRUE),
    (4, 6, 1, FALSE);
