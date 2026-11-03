-- CSC6302 Database Principles
-- Module 01 Exercise 01
-- Family Spooky Vacation Database

CREATE DATABASE IF NOT EXISTS FamilySpookyVacation;

USE FamilySpookyVacation;


CREATE TABLE FAMILY_MEMBER (
    MemberID INT UNSIGNED AUTO_INCREMENT,
    MemberName VARCHAR(80) NOT NULL,

    CONSTRAINT pk_family_member
        PRIMARY KEY (MemberID)
);


CREATE TABLE VACATION_SITE (
    SiteID INT UNSIGNED AUTO_INCREMENT,
    SiteName VARCHAR(100) NOT NULL,
    Location VARCHAR(100) NOT NULL,
    SpookinessLevel TINYINT UNSIGNED NOT NULL,

    CONSTRAINT pk_vacation_site
        PRIMARY KEY (SiteID),

    CONSTRAINT chk_spookiness_level
        CHECK (SpookinessLevel BETWEEN 1 AND 5)
);


CREATE TABLE ACTIVITY (
    ActivityID INT UNSIGNED AUTO_INCREMENT,
    ActivityName VARCHAR(100) NOT NULL,
    ActivityCategory VARCHAR(40) NOT NULL,

    CONSTRAINT pk_activity
        PRIMARY KEY (ActivityID)
);


CREATE TABLE PACKING_ITEM (
    ItemID INT UNSIGNED AUTO_INCREMENT,
    ItemName VARCHAR(100) NOT NULL,
    ItemCategory VARCHAR(20) NOT NULL,

    CONSTRAINT pk_packing_item
        PRIMARY KEY (ItemID),

    CONSTRAINT chk_item_category
        CHECK (
            ItemCategory IN (
                'Costume',
                'Safety',
                'Comfort',
                'Food',
                'Equipment'
            )
        )
);


CREATE TABLE FAMILY_SITE (
    MemberID INT UNSIGNED NOT NULL,
    SiteID INT UNSIGNED NOT NULL,
    PreferenceRank TINYINT UNSIGNED NOT NULL,

    CONSTRAINT pk_family_site
        PRIMARY KEY (MemberID, SiteID),

    CONSTRAINT uq_family_preference_rank
        UNIQUE (MemberID, PreferenceRank),

    CONSTRAINT chk_preference_rank
        CHECK (PreferenceRank > 0),

    CONSTRAINT fk_family_site_member
        FOREIGN KEY (MemberID)
        REFERENCES FAMILY_MEMBER(MemberID),

    CONSTRAINT fk_family_site_site
        FOREIGN KEY (SiteID)
        REFERENCES VACATION_SITE(SiteID)
);


CREATE TABLE SITE_ACTIVITY (
    SiteID INT UNSIGNED NOT NULL,
    ActivityID INT UNSIGNED NOT NULL,

    CONSTRAINT pk_site_activity
        PRIMARY KEY (SiteID, ActivityID),

    CONSTRAINT fk_site_activity_site
        FOREIGN KEY (SiteID)
        REFERENCES VACATION_SITE(SiteID),

    CONSTRAINT fk_site_activity_activity
        FOREIGN KEY (ActivityID)
        REFERENCES ACTIVITY(ActivityID)
);


CREATE TABLE MEMBER_ITEM (
    MemberID INT UNSIGNED NOT NULL,
    ItemID INT UNSIGNED NOT NULL,
    Quantity TINYINT UNSIGNED NOT NULL,
    PackedStatus BOOLEAN NOT NULL DEFAULT FALSE,

    CONSTRAINT pk_member_item
        PRIMARY KEY (MemberID, ItemID),

    CONSTRAINT chk_member_item_quantity
        CHECK (Quantity > 0),

    CONSTRAINT fk_member_item_member
        FOREIGN KEY (MemberID)
        REFERENCES FAMILY_MEMBER(MemberID),

    CONSTRAINT fk_member_item_item
        FOREIGN KEY (ItemID)
        REFERENCES PACKING_ITEM(ItemID)
);
