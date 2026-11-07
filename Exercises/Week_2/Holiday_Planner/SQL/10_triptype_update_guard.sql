-- CSC6302 Database Principles
-- Module 2 Holiday Planner
-- Final TripType update protection

USE HolidayPlanner;

DROP TRIGGER IF EXISTS bu_triptype_validate_rules;

DELIMITER $$

CREATE TRIGGER bu_triptype_validate_rules
BEFORE UPDATE ON TripType
FOR EACH ROW
BEGIN

    -- -----------------------------------------------------
    -- Existing outings must fit the proposed day range.
    -- -----------------------------------------------------

    IF EXISTS (
        SELECT 1
        FROM Outing o
        WHERE o.trip_type_id = OLD.trip_type_id
          AND (
              DATEDIFF(o.end_date, o.start_date) + 1 < NEW.min_days
              OR
              DATEDIFF(o.end_date, o.start_date) + 1 > NEW.max_days
          )
    ) THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'TripType update would invalidate an existing Outing duration';

    END IF;


    -- -----------------------------------------------------
    -- Existing scheduled days must not exceed the proposed
    -- maximum number of activities per day.
    -- -----------------------------------------------------

    IF EXISTS (
        SELECT 1
        FROM Outing o
        JOIN OutingActivity oa
            ON oa.outing_id = o.outing_id
        WHERE o.trip_type_id = OLD.trip_type_id
        GROUP BY
            oa.outing_id,
            oa.activity_date
        HAVING COUNT(*) > NEW.max_activities_per_day
    ) THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'TripType update would invalidate an existing daily activity count';

    END IF;


    -- -----------------------------------------------------
    -- A TripType that can no longer be multi-day cannot
    -- retain Suitcase packing rules.
    -- -----------------------------------------------------

    IF NEW.max_days < 2
       AND EXISTS (
            SELECT 1
            FROM MemberTripPackingItem mtpi
            WHERE mtpi.trip_type_id = OLD.trip_type_id
              AND mtpi.bag_type = 'Suitcase'
       ) THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'TripType update would invalidate existing Suitcase packing rules';

    END IF;

END$$

DELIMITER ;