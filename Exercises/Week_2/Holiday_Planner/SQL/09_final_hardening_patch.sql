-- CSC6302 Database Principles
-- Module 2 Holiday Planner
-- Final Regrade Hardening Patch
--
-- RUN IN MYSQL WORKBENCH, NOT POWERSHELL.

USE HolidayPlanner;


-- =========================================================
-- 1. GENERIC HOUSEHOLD + ACCOMMODATION DOMAINS
-- =========================================================

ALTER TABLE FamilyMember
    DROP CHECK chk_family_relationship;

ALTER TABLE FamilyMember
    ADD CONSTRAINT chk_family_relationship
        CHECK (
            relationship_to_household IN (
                'Parent',
                'Child',
                'Guardian',
                'Grandparent',
                'Other'
            )
        );


ALTER TABLE Accommodation
    DROP CHECK chk_accommodation_type;

ALTER TABLE Accommodation
    ADD CONSTRAINT chk_accommodation_type
        CHECK (
            accommodation_type IN (
                'Hotel',
                'Lodge',
                'Cabin',
                'Resort',
                'Rental',
                'Other'
            )
        );


-- =========================================================
-- 2. OUTING ACTIVITY DATE + MAXIMUM COUNT ENFORCEMENT
-- =========================================================

DROP TRIGGER IF EXISTS bi_oa_validate_schedule;
DROP TRIGGER IF EXISTS bu_oa_validate_schedule;

DELIMITER $$

CREATE TRIGGER bi_oa_validate_schedule
BEFORE INSERT ON OutingActivity
FOR EACH ROW
BEGIN
    DECLARE v_start_date DATE;
    DECLARE v_end_date DATE;
    DECLARE v_max_activities TINYINT UNSIGNED;
    DECLARE v_activity_count INT;

    SELECT
        o.start_date,
        o.end_date,
        tt.max_activities_per_day
    INTO
        v_start_date,
        v_end_date,
        v_max_activities
    FROM Outing o
    JOIN TripType tt
        ON tt.trip_type_id = o.trip_type_id
    WHERE o.outing_id = NEW.outing_id;

    IF NEW.activity_date < v_start_date
       OR NEW.activity_date > v_end_date THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Activity date must fall within the Outing date range';

    END IF;

    SELECT COUNT(*)
    INTO v_activity_count
    FROM OutingActivity
    WHERE outing_id = NEW.outing_id
      AND activity_date = NEW.activity_date;

    IF v_activity_count >= v_max_activities THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Activity count would exceed the TripType daily maximum';

    END IF;
END$$


CREATE TRIGGER bu_oa_validate_schedule
BEFORE UPDATE ON OutingActivity
FOR EACH ROW
BEGIN
    DECLARE v_start_date DATE;
    DECLARE v_end_date DATE;
    DECLARE v_max_activities TINYINT UNSIGNED;
    DECLARE v_activity_count INT;

    SELECT
        o.start_date,
        o.end_date,
        tt.max_activities_per_day
    INTO
        v_start_date,
        v_end_date,
        v_max_activities
    FROM Outing o
    JOIN TripType tt
        ON tt.trip_type_id = o.trip_type_id
    WHERE o.outing_id = NEW.outing_id;

    IF NEW.activity_date < v_start_date
       OR NEW.activity_date > v_end_date THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Activity date must fall within the Outing date range';

    END IF;

    SELECT COUNT(*)
    INTO v_activity_count
    FROM OutingActivity
    WHERE outing_id = NEW.outing_id
      AND activity_date = NEW.activity_date
      AND NOT (
          outing_id = OLD.outing_id
          AND activity_date = OLD.activity_date
          AND sequence_number = OLD.sequence_number
      );

    IF v_activity_count >= v_max_activities THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Activity count would exceed the TripType daily maximum';

    END IF;
END$$

DELIMITER ;


-- =========================================================
-- 3. ACCOMMODATION DATE ENFORCEMENT
-- =========================================================

DROP TRIGGER IF EXISTS bi_outacc_validate_dates;
DROP TRIGGER IF EXISTS bu_outacc_validate_dates;

DELIMITER $$

CREATE TRIGGER bi_outacc_validate_dates
BEFORE INSERT ON OutingAccommodation
FOR EACH ROW
BEGIN
    DECLARE v_start_date DATE;
    DECLARE v_end_date DATE;

    SELECT start_date, end_date
    INTO v_start_date, v_end_date
    FROM Outing
    WHERE outing_id = NEW.outing_id;

    IF NEW.check_in_date < v_start_date
       OR NEW.check_out_date > v_end_date THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Accommodation dates must fall within the Outing date range';

    END IF;
END$$


CREATE TRIGGER bu_outacc_validate_dates
BEFORE UPDATE ON OutingAccommodation
FOR EACH ROW
BEGIN
    DECLARE v_start_date DATE;
    DECLARE v_end_date DATE;

    SELECT start_date, end_date
    INTO v_start_date, v_end_date
    FROM Outing
    WHERE outing_id = NEW.outing_id;

    IF NEW.check_in_date < v_start_date
       OR NEW.check_out_date > v_end_date THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Accommodation dates must fall within the Outing date range';

    END IF;
END$$

DELIMITER ;


-- =========================================================
-- 4. STRENGTHEN OUTING UPDATE ENFORCEMENT
--
-- Prevent shrinking/changing an Outing in a way that leaves
-- activities or accommodations outside the new date range.
-- Also prevent changing to a TripType whose daily maximum
-- is already exceeded by scheduled activities.
-- =========================================================

DROP TRIGGER IF EXISTS bu_outing_validate_duration;

DELIMITER $$

CREATE TRIGGER bu_outing_validate_duration
BEFORE UPDATE ON Outing
FOR EACH ROW
BEGIN
    DECLARE v_min_days TINYINT UNSIGNED;
    DECLARE v_max_days TINYINT UNSIGNED;
    DECLARE v_max_activities TINYINT UNSIGNED;
    DECLARE v_trip_days INT;

    SELECT
        min_days,
        max_days,
        max_activities_per_day
    INTO
        v_min_days,
        v_max_days,
        v_max_activities
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

    IF EXISTS (
        SELECT 1
        FROM OutingActivity oa
        WHERE oa.outing_id = OLD.outing_id
          AND (
              oa.activity_date < NEW.start_date
              OR oa.activity_date > NEW.end_date
          )
    ) THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Outing date change would leave activities outside the Outing';

    END IF;

    IF EXISTS (
        SELECT 1
        FROM OutingAccommodation x
        WHERE x.outing_id = OLD.outing_id
          AND (
              x.check_in_date < NEW.start_date
              OR x.check_out_date > NEW.end_date
          )
    ) THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Outing date change would leave accommodation outside the Outing';

    END IF;

    IF EXISTS (
        SELECT 1
        FROM (
            SELECT
                activity_date,
                COUNT(*) AS activity_count
            FROM OutingActivity
            WHERE outing_id = OLD.outing_id
            GROUP BY activity_date
        ) counts_by_day
        WHERE counts_by_day.activity_count > v_max_activities
    ) THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Existing activities exceed the selected TripType daily maximum';

    END IF;
END$$

DELIMITER ;


-- =========================================================
-- 5. REMOVE UNUSED BOSTON AIRPORT
-- =========================================================

DELETE FROM Location
WHERE location_name = 'Boston Logan International Airport';


-- =========================================================
-- 6. CHICAGO LOCAL TRANSPORT
-- Use Other for taxi/rideshare between O'Hare and downtown.
-- =========================================================

SET @chicago = (
    SELECT outing_id
    FROM Outing
    WHERE outing_name = 'Chicago Christmas Week'
      AND start_date = '2027-12-20'
);

SET @other = (
    SELECT travel_mode_id
    FROM TravelMode
    WHERE travel_mode_name = 'Other'
);

SET @chicago_leg_3 = (
    SELECT travel_leg_id
    FROM TravelLeg
    WHERE outing_id = @chicago
      AND sequence_number = 3
);

SET @chicago_leg_4 = (
    SELECT travel_leg_id
    FROM TravelLeg
    WHERE outing_id = @chicago
      AND sequence_number = 4
);

UPDATE TravelLeg
SET travel_mode_id = @other
WHERE travel_leg_id = @chicago_leg_3;

UPDATE TravelLeg
SET travel_mode_id = @other
WHERE travel_leg_id = @chicago_leg_4;


-- =========================================================
-- 7. IMPROVE ADIRONDACK ITINERARY VARIETY
-- =========================================================

SET @adirondack = (
    SELECT outing_id
    FROM Outing
    WHERE outing_name = 'Adirondack Summer Week'
      AND start_date = '2027-07-11'
);

UPDATE OutingActivity
SET
    activity_id = (
        SELECT activity_id
        FROM Activity
        WHERE activity_name = 'Dinner'
    ),
    location_id = (
        SELECT location_id
        FROM Location
        WHERE location_name = 'Lake Placid Village'
    ),
    start_time = '18:00:00',
    planned_duration_minutes = 90,
    notes = 'Dinner after changing accommodations'
WHERE outing_id = @adirondack
  AND activity_date = '2027-07-15'
  AND sequence_number = 1;


UPDATE OutingActivity
SET
    activity_id = (
        SELECT activity_id
        FROM Activity
        WHERE activity_name = 'Hiking'
    ),
    location_id = (
        SELECT location_id
        FROM Location
        WHERE location_name = 'Adirondack Trailhead'
    ),
    start_time = '08:00:00',
    planned_duration_minutes = 120,
    notes = 'Short final-morning hike before returning home'
WHERE outing_id = @adirondack
  AND activity_date = '2027-07-17'
  AND sequence_number = 1;


-- =========================================================
-- 8. FINAL ENFORCEMENT AUDITS
-- Every query below should return 0 rows.
-- =========================================================


-- Activity dates outside the parent Outing.

SELECT
    o.outing_name,
    oa.activity_date,
    o.start_date,
    o.end_date
FROM OutingActivity oa
JOIN Outing o
    ON o.outing_id = oa.outing_id
WHERE oa.activity_date < o.start_date
   OR oa.activity_date > o.end_date;


-- Accommodation dates outside the parent Outing.

SELECT
    o.outing_name,
    x.check_in_date,
    x.check_out_date,
    o.start_date,
    o.end_date
FROM OutingAccommodation x
JOIN Outing o
    ON o.outing_id = x.outing_id
WHERE x.check_in_date < o.start_date
   OR x.check_out_date > o.end_date;


-- Daily activity count outside the TripType minimum/maximum.
-- This audit also verifies that every required day has enough
-- scheduled activities after all itinerary rows are loaded.

WITH RECURSIVE outing_days AS (
    SELECT
        o.outing_id,
        o.outing_name,
        o.trip_type_id,
        o.start_date AS activity_date,
        o.end_date
    FROM Outing o

    UNION ALL

    SELECT
        outing_id,
        outing_name,
        trip_type_id,
        DATE_ADD(activity_date, INTERVAL 1 DAY),
        end_date
    FROM outing_days
    WHERE activity_date < end_date
)
SELECT
    od.outing_name,
    od.activity_date,
    COUNT(oa.activity_id) AS activity_count,
    tt.min_activities_per_day,
    tt.max_activities_per_day
FROM outing_days od
JOIN TripType tt
    ON tt.trip_type_id = od.trip_type_id
LEFT JOIN OutingActivity oa
    ON oa.outing_id = od.outing_id
   AND oa.activity_date = od.activity_date
GROUP BY
    od.outing_id,
    od.outing_name,
    od.activity_date,
    tt.min_activities_per_day,
    tt.max_activities_per_day
HAVING COUNT(oa.activity_id) < tt.min_activities_per_day
    OR COUNT(oa.activity_id) > tt.max_activities_per_day
ORDER BY od.outing_id, od.activity_date;


-- Confirm Boston Logan is gone.

SELECT *
FROM Location
WHERE location_name = 'Boston Logan International Airport';


-- Confirm new trigger count.

SELECT COUNT(*) AS trigger_count
FROM information_schema.TRIGGERS
WHERE TRIGGER_SCHEMA = 'HolidayPlanner';