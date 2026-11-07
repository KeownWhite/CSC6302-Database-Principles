-- CSC6302 Database Principles
-- Module 2 Holiday Planner
-- Regrade Schema and Data Repair
--
-- RUN THIS FILE IN MYSQL WORKBENCH, NOT POWERSHELL.

USE HolidayPlanner;


-- =========================================================
-- 1. HOLIDAY LOOKUP TABLE
-- Replaces free-text Outing.holiday_name.
-- =========================================================

CREATE TABLE IF NOT EXISTS Holiday (
    holiday_id SMALLINT UNSIGNED AUTO_INCREMENT,
    holiday_name VARCHAR(80) NOT NULL,
    description VARCHAR(255),

    CONSTRAINT pk_holiday
        PRIMARY KEY (holiday_id),

    CONSTRAINT uq_holiday_name
        UNIQUE (holiday_name)
);

INSERT IGNORE INTO Holiday (holiday_name)
SELECT DISTINCT holiday_name
FROM Outing
WHERE holiday_name IS NOT NULL;


ALTER TABLE Outing
    ADD COLUMN holiday_id SMALLINT UNSIGNED NULL
    AFTER primary_location_id;


UPDATE Outing o
JOIN Holiday h
    ON h.holiday_name = o.holiday_name
SET o.holiday_id = h.holiday_id
WHERE o.outing_id > 0
  AND o.holiday_name IS NOT NULL;


ALTER TABLE Outing
    DROP COLUMN holiday_name;


ALTER TABLE Outing
    ADD CONSTRAINT fk_outing_holiday
        FOREIGN KEY (holiday_id)
        REFERENCES Holiday(holiday_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT;


-- =========================================================
-- 2. DIFFERENTIATE TRIP TYPES
-- =========================================================

ALTER TABLE TripType
    ADD COLUMN min_activities_per_day TINYINT UNSIGNED NOT NULL DEFAULT 1
        AFTER max_days,
    ADD COLUMN max_activities_per_day TINYINT UNSIGNED NOT NULL DEFAULT 8
        AFTER min_activities_per_day;


UPDATE TripType
SET min_activities_per_day = 1,
    max_activities_per_day = 2
WHERE trip_type_name = 'Single Afternoon';


UPDATE TripType
SET min_activities_per_day = 3,
    max_activities_per_day = 8
WHERE trip_type_name = 'Multi-Activity Day';


UPDATE TripType
SET min_activities_per_day = 1,
    max_activities_per_day = 8
WHERE trip_type_name IN ('Weekend', 'Week Long');


ALTER TABLE TripType
    ADD CONSTRAINT chk_trip_type_activity_min
        CHECK (min_activities_per_day >= 1),

    ADD CONSTRAINT chk_trip_type_activity_range
        CHECK (max_activities_per_day >= min_activities_per_day);


-- =========================================================
-- 3. NATURAL / BUSINESS UNIQUE KEYS
-- =========================================================

ALTER TABLE FamilyMember
    ADD CONSTRAINT uq_family_member_identity
        UNIQUE (first_name, last_name, birth_date);


ALTER TABLE Location
    ADD CONSTRAINT uq_location_name
        UNIQUE (location_name);



ALTER TABLE Outing
    ADD CONSTRAINT uq_outing_name_start_date
        UNIQUE (outing_name, start_date);


-- =========================================================
-- 4. CONTROLLED CATEGORY DOMAINS
-- =========================================================

ALTER TABLE FamilyMember
    ADD CONSTRAINT chk_family_relationship
        CHECK (
            relationship_to_household IN (
                'Parent',
                'Child'
            )
        );


ALTER TABLE Location
    ADD CONSTRAINT chk_location_type
        CHECK (
            location_type IN (
                'Home',
                'Farm',
                'Attraction',
                'Restaurant',
                'Airport',
                'City',
                'Resort',
                'Cabin Area',
                'Trailhead',
                'Lake',
                'Town',
                'Park',
                'Museum District',
                'Market'
            )
        );


ALTER TABLE Activity
    ADD CONSTRAINT chk_activity_category
        CHECK (
            activity_category IN (
                'Outdoor',
                'Shopping',
                'Entertainment',
                'Dining',
                'Winter Sport',
                'Recreation',
                'Water Sport',
                'Tourism',
                'Education'
            )
        );


ALTER TABLE Accommodation
    ADD CONSTRAINT chk_accommodation_type
        CHECK (
            accommodation_type IN (
                'Hotel',
                'Lodge',
                'Cabin'
            )
        );


ALTER TABLE PackingItem
    ADD CONSTRAINT chk_packing_item_category
        CHECK (
            item_category IN (
                'Electronics',
                'Personal',
                'Food and Drink',
                'Clothing',
                'Health',
                'Toiletries',
                'Sport Equipment',
                'Travel',
                'Safety'
            )
        );


-- =========================================================
-- 5. CONSISTENT DURATION TYPE
-- =========================================================

ALTER TABLE TravelLeg
    MODIFY COLUMN planned_duration_minutes
        SMALLINT UNSIGNED NOT NULL;


-- =========================================================
-- 6. MAKE COST MEANING AND CURRENCY EXPLICIT
-- =========================================================

ALTER TABLE TravelLeg
    DROP CHECK chk_tl_cost;


ALTER TABLE TravelLeg
    CHANGE COLUMN estimated_cost
        estimated_cost_total_usd DECIMAL(10,2) NOT NULL;


ALTER TABLE TravelLeg
    ADD CONSTRAINT chk_tl_cost
        CHECK (estimated_cost_total_usd >= 0);


ALTER TABLE OutingAccommodation
    DROP CHECK chk_outacc_rate;


ALTER TABLE OutingAccommodation
    CHANGE COLUMN nightly_rate
        nightly_rate_usd DECIMAL(10,2) NOT NULL;


ALTER TABLE OutingAccommodation
    ADD CONSTRAINT chk_outacc_rate
        CHECK (nightly_rate_usd >= 0);


-- =========================================================
-- 7. CONSISTENT LOCATION ON UPDATE POLICY
--
-- Location IDs are surrogate AUTO_INCREMENT identifiers.
-- They are treated as permanent identifiers and therefore
-- use RESTRICT rather than CASCADE when an ID update is tried.
-- =========================================================

ALTER TABLE Accommodation
    DROP FOREIGN KEY fk_accommodation_location;

ALTER TABLE Accommodation
    ADD CONSTRAINT fk_accommodation_location
        FOREIGN KEY (location_id)
        REFERENCES Location(location_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT;


ALTER TABLE Outing
    DROP FOREIGN KEY fk_outing_primary_location;

ALTER TABLE Outing
    ADD CONSTRAINT fk_outing_primary_location
        FOREIGN KEY (primary_location_id)
        REFERENCES Location(location_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT;


ALTER TABLE OutingActivity
    DROP FOREIGN KEY fk_oa_location;

ALTER TABLE OutingActivity
    ADD CONSTRAINT fk_oa_location
        FOREIGN KEY (location_id)
        REFERENCES Location(location_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT;


ALTER TABLE TravelLeg
    DROP FOREIGN KEY fk_tl_from_location;

ALTER TABLE TravelLeg
    DROP FOREIGN KEY fk_tl_to_location;


ALTER TABLE TravelLeg
    ADD CONSTRAINT fk_tl_from_location
        FOREIGN KEY (from_location_id)
        REFERENCES Location(location_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    ADD CONSTRAINT fk_tl_to_location
        FOREIGN KEY (to_location_id)
        REFERENCES Location(location_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT;


-- =========================================================
-- 8. TRAVEL PACKING
--
-- Travel-specific rules may use:
-- Personal Item
-- Vehicle
--
-- Suitcase belongs only to TripType packing.
-- =========================================================

ALTER TABLE MemberTravelPackingItem
    DROP CHECK chk_mvp_bag;


UPDATE MemberTravelPackingItem mt
JOIN PackingItem pi
    ON pi.item_id = mt.item_id
SET mt.bag_type = 'Vehicle'
WHERE pi.item_name IN (
    'Cooler',
    'Vehicle Emergency Kit'
);


ALTER TABLE MemberTravelPackingItem
    ADD CONSTRAINT chk_mvp_bag
        CHECK (
            bag_type IN (
                'Personal Item',
                'Vehicle'
            )
        );


-- =========================================================
-- 9. TRIP DURATION ENFORCEMENT
-- Prevents examples such as a 9-day Weekend.
-- =========================================================

DROP TRIGGER IF EXISTS bi_outing_validate_duration;
DROP TRIGGER IF EXISTS bu_outing_validate_duration;

DELIMITER $$

CREATE TRIGGER bi_outing_validate_duration
BEFORE INSERT ON Outing
FOR EACH ROW
BEGIN
    DECLARE v_min_days TINYINT UNSIGNED;
    DECLARE v_max_days TINYINT UNSIGNED;
    DECLARE v_trip_days INT;

    SELECT min_days, max_days
    INTO v_min_days, v_max_days
    FROM TripType
    WHERE trip_type_id = NEW.trip_type_id;

    SET v_trip_days =
        DATEDIFF(NEW.end_date, NEW.start_date) + 1;

    IF v_trip_days < v_min_days
       OR v_trip_days > v_max_days THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Outing duration does not match the selected TripType';

    END IF;
END$$


CREATE TRIGGER bu_outing_validate_duration
BEFORE UPDATE ON Outing
FOR EACH ROW
BEGIN
    DECLARE v_min_days TINYINT UNSIGNED;
    DECLARE v_max_days TINYINT UNSIGNED;
    DECLARE v_trip_days INT;

    SELECT min_days, max_days
    INTO v_min_days, v_max_days
    FROM TripType
    WHERE trip_type_id = NEW.trip_type_id;

    SET v_trip_days =
        DATEDIFF(NEW.end_date, NEW.start_date) + 1;

    IF v_trip_days < v_min_days
       OR v_trip_days > v_max_days THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Outing duration does not match the selected TripType';

    END IF;
END$$

DELIMITER ;


-- =========================================================
-- 10. SUITCASE + CROSS-TABLE BAG CONFLICT ENFORCEMENT
-- =========================================================

DROP TRIGGER IF EXISTS bi_mtp_validate_packing;
DROP TRIGGER IF EXISTS bu_mtp_validate_packing;
DROP TRIGGER IF EXISTS bi_mvp_validate_packing;
DROP TRIGGER IF EXISTS bu_mvp_validate_packing;

DELIMITER $$

CREATE TRIGGER bi_mtp_validate_packing
BEFORE INSERT ON MemberTripPackingItem
FOR EACH ROW
BEGIN
    DECLARE v_min_days TINYINT UNSIGNED;

    SELECT min_days
    INTO v_min_days
    FROM TripType
    WHERE trip_type_id = NEW.trip_type_id;

    IF NEW.bag_type = 'Suitcase'
       AND v_min_days < 2 THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Suitcases are allowed only for multi-day TripTypes';

    END IF;

    IF (
        SELECT COUNT(*)
        FROM MemberTravelPackingItem
        WHERE member_id = NEW.member_id
          AND item_id = NEW.item_id
          AND bag_type <> NEW.bag_type
    ) > 0 THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Conflicting bag assignment exists for this member and item';

    END IF;
END$$


CREATE TRIGGER bu_mtp_validate_packing
BEFORE UPDATE ON MemberTripPackingItem
FOR EACH ROW
BEGIN
    DECLARE v_min_days TINYINT UNSIGNED;

    SELECT min_days
    INTO v_min_days
    FROM TripType
    WHERE trip_type_id = NEW.trip_type_id;

    IF NEW.bag_type = 'Suitcase'
       AND v_min_days < 2 THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Suitcases are allowed only for multi-day TripTypes';

    END IF;

    IF (
        SELECT COUNT(*)
        FROM MemberTravelPackingItem
        WHERE member_id = NEW.member_id
          AND item_id = NEW.item_id
          AND bag_type <> NEW.bag_type
    ) > 0 THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Conflicting bag assignment exists for this member and item';

    END IF;
END$$


CREATE TRIGGER bi_mvp_validate_packing
BEFORE INSERT ON MemberTravelPackingItem
FOR EACH ROW
BEGIN

    IF (
        SELECT COUNT(*)
        FROM MemberTripPackingItem
        WHERE member_id = NEW.member_id
          AND item_id = NEW.item_id
          AND bag_type <> NEW.bag_type
    ) > 0 THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Conflicting bag assignment exists for this member and item';

    END IF;
END$$


CREATE TRIGGER bu_mvp_validate_packing
BEFORE UPDATE ON MemberTravelPackingItem
FOR EACH ROW
BEGIN

    IF (
        SELECT COUNT(*)
        FROM MemberTripPackingItem
        WHERE member_id = NEW.member_id
          AND item_id = NEW.item_id
          AND bag_type <> NEW.bag_type
    ) > 0 THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Conflicting bag assignment exists for this member and item';

    END IF;
END$$

DELIMITER ;


-- =========================================================
-- 11. BOSTON TRAVEL DATA
-- Replace unrealistic Albany-Boston flights and Logan train.
-- Boston becomes a realistic driveable weekend trip.
-- Chicago remains the airplane example.
-- =========================================================

SET @boston = (
    SELECT outing_id
    FROM Outing
    WHERE outing_name = 'Boston Holiday Weekend'
      AND start_date = '2026-12-18'
);

SET @car = (
    SELECT travel_mode_id
    FROM TravelMode
    WHERE travel_mode_name = 'Car'
);


DELETE FROM TravelLeg
WHERE outing_id = @boston;


INSERT INTO TravelLeg (
    outing_id,
    sequence_number,
    travel_mode_id,
    from_location_id,
    to_location_id,
    departure_datetime,
    planned_duration_minutes,
    estimated_cost_total_usd
)
VALUES
(
    @boston,
    1,
    @car,
    (
        SELECT location_id
        FROM Location
        WHERE location_name = 'Hart Home'
    ),
    (
        SELECT location_id
        FROM Location
        WHERE location_name = 'Downtown Boston'
    ),
    '2026-12-18 08:00:00',
    180,
    55.00
),
(
    @boston,
    2,
    @car,
    (
        SELECT location_id
        FROM Location
        WHERE location_name = 'Downtown Boston'
    ),
    (
        SELECT location_id
        FROM Location
        WHERE location_name = 'Hart Home'
    ),
    '2026-12-20 14:00:00',
    180,
    55.00
);


UPDATE Outing
SET description =
    'Weekend family road trip from Albany to Boston'
WHERE outing_id = @boston;


-- =========================================================
-- 12. EVERY DAY OF MULTI-DAY OUTINGS GETS AN ACTIVITY
-- =========================================================

SET @adirondack = (
    SELECT outing_id
    FROM Outing
    WHERE outing_name = 'Adirondack Summer Week'
      AND start_date = '2027-07-11'
);

SET @chicago = (
    SELECT outing_id
    FROM Outing
    WHERE outing_name = 'Chicago Christmas Week'
      AND start_date = '2027-12-20'
);


-- Boston: missing 12/20

INSERT INTO OutingActivity (
    outing_id,
    activity_date,
    sequence_number,
    activity_id,
    location_id,
    start_time,
    planned_duration_minutes,
    notes
)
VALUES (
    @boston,
    '2026-12-20',
    1,
    (
        SELECT activity_id
        FROM Activity
        WHERE activity_name = 'Sightseeing'
    ),
    (
        SELECT location_id
        FROM Location
        WHERE location_name = 'Downtown Boston'
    ),
    '09:00:00',
    120,
    'Final morning in Boston before driving home'
);


-- Adirondack: missing 7/11, 7/15, and 7/17

INSERT INTO OutingActivity (
    outing_id,
    activity_date,
    sequence_number,
    activity_id,
    location_id,
    start_time,
    planned_duration_minutes,
    notes
)
VALUES
(
    @adirondack,
    '2027-07-11',
    1,
    (
        SELECT activity_id
        FROM Activity
        WHERE activity_name = 'Sightseeing'
    ),
    (
        SELECT location_id
        FROM Location
        WHERE location_name = 'Lake Placid Village'
    ),
    '16:00:00',
    120,
    'Arrival-day village visit'
),
(
    @adirondack,
    '2027-07-15',
    1,
    (
        SELECT activity_id
        FROM Activity
        WHERE activity_name = 'Sightseeing'
    ),
    (
        SELECT location_id
        FROM Location
        WHERE location_name = 'Lake Placid Village'
    ),
    '11:00:00',
    120,
    'Activity during accommodation transition day'
),
(
    @adirondack,
    '2027-07-17',
    1,
    (
        SELECT activity_id
        FROM Activity
        WHERE activity_name = 'Sightseeing'
    ),
    (
        SELECT location_id
        FROM Location
        WHERE location_name = 'Lake Placid Village'
    ),
    '09:00:00',
    120,
    'Final morning activity before departure'
);


-- Chicago: missing 12/20 and 12/25 through 12/27

INSERT INTO OutingActivity (
    outing_id,
    activity_date,
    sequence_number,
    activity_id,
    location_id,
    start_time,
    planned_duration_minutes,
    notes
)
VALUES
(
    @chicago,
    '2027-12-20',
    1,
    (
        SELECT activity_id
        FROM Activity
        WHERE activity_name = 'Dinner'
    ),
    (
        SELECT location_id
        FROM Location
        WHERE location_name = 'Downtown Chicago'
    ),
    '19:00:00',
    90,
    'Arrival-day dinner'
),
(
    @chicago,
    '2027-12-25',
    1,
    (
        SELECT activity_id
        FROM Activity
        WHERE activity_name = 'Sightseeing'
    ),
    (
        SELECT location_id
        FROM Location
        WHERE location_name = 'Millennium Park'
    ),
    '11:00:00',
    120,
    'Christmas Day sightseeing'
),
(
    @chicago,
    '2027-12-26',
    1,
    (
        SELECT activity_id
        FROM Activity
        WHERE activity_name = 'Museum Visit'
    ),
    (
        SELECT location_id
        FROM Location
        WHERE location_name = 'Museum Campus'
    ),
    '11:00:00',
    150,
    'Post-holiday museum visit'
),
(
    @chicago,
    '2027-12-27',
    1,
    (
        SELECT activity_id
        FROM Activity
        WHERE activity_name = 'Sightseeing'
    ),
    (
        SELECT location_id
        FROM Location
        WHERE location_name = 'Downtown Chicago'
    ),
    '09:00:00',
    120,
    'Final morning activity before departure'
);


-- =========================================================
-- 13. STRUCTURAL SUMMARY
-- =========================================================

SELECT COUNT(*) AS table_count
FROM information_schema.tables
WHERE table_schema = 'HolidayPlanner';


SELECT COUNT(*) AS foreign_key_count
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'HolidayPlanner'
  AND REFERENCED_TABLE_NAME IS NOT NULL;


SELECT
    TABLE_NAME,
    COLUMN_NAME,
    COLUMN_TYPE
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'HolidayPlanner'
  AND COLUMN_NAME LIKE '%duration%minute%'
ORDER BY TABLE_NAME, COLUMN_NAME;


-- =========================================================
-- 14. VERIFY EVERY MULTI-DAY CALENDAR DATE HAS AN ACTIVITY
-- Expected result: 0 rows.
-- =========================================================

WITH RECURSIVE outing_days AS (
    SELECT
        outing_id,
        outing_name,
        start_date AS activity_date,
        end_date
    FROM Outing
    WHERE end_date > start_date

    UNION ALL

    SELECT
        outing_id,
        outing_name,
        DATE_ADD(activity_date, INTERVAL 1 DAY),
        end_date
    FROM outing_days
    WHERE activity_date < end_date
)
SELECT
    od.outing_id,
    od.outing_name,
    od.activity_date
FROM outing_days od
LEFT JOIN OutingActivity oa
    ON oa.outing_id = od.outing_id
   AND oa.activity_date = od.activity_date
WHERE oa.outing_id IS NULL
ORDER BY od.outing_id, od.activity_date;


