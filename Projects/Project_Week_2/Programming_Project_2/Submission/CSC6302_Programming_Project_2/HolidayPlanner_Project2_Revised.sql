-- CSC6302 Database Principles
-- Programming Project 2
-- Revised Holiday Planning Database
-- Self-contained rebuild: base schema + base data + Project 2 revisions

-- =========================================================
-- BASE DATABASE SCHEMA
-- =========================================================
-- CSC6302 Database Principles
-- Module 2 Practice: Holiday Planner
-- Database and table creation script

DROP DATABASE IF EXISTS HolidayPlanner;
CREATE DATABASE HolidayPlanner;
USE HolidayPlanner;

-- =========================================================
-- 1. FAMILY MEMBER
-- =========================================================

CREATE TABLE IF NOT EXISTS FamilyMember (
    member_id INT UNSIGNED AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE NOT NULL,
    relationship_to_household VARCHAR(40) NOT NULL,

    CONSTRAINT pk_family_member
        PRIMARY KEY (member_id),

    CONSTRAINT uq_family_member_identity
        UNIQUE (first_name, last_name, birth_date),

    CONSTRAINT chk_family_relationship
        CHECK (
            relationship_to_household IN (
                'Parent',
                'Child',
                'Guardian',
                'Grandparent',
                'Other'
            )
        )
);


-- =========================================================
-- 2. TRIP TYPE
-- =========================================================

CREATE TABLE IF NOT EXISTS TripType (
    trip_type_id SMALLINT UNSIGNED AUTO_INCREMENT,
    trip_type_name VARCHAR(50) NOT NULL,
    min_days TINYINT UNSIGNED NOT NULL,
    max_days TINYINT UNSIGNED NOT NULL,
    min_activities_per_day TINYINT UNSIGNED NOT NULL,
    max_activities_per_day TINYINT UNSIGNED NOT NULL,
    description VARCHAR(255),

    CONSTRAINT pk_trip_type
        PRIMARY KEY (trip_type_id),

    CONSTRAINT uq_trip_type_name
        UNIQUE (trip_type_name),

    CONSTRAINT chk_trip_type_min_days
        CHECK (min_days >= 1),

    CONSTRAINT chk_trip_type_day_range
        CHECK (max_days >= min_days),

    CONSTRAINT chk_trip_type_activity_min
        CHECK (min_activities_per_day >= 1),

    CONSTRAINT chk_trip_type_activity_range
        CHECK (
            max_activities_per_day >= min_activities_per_day
        )
);


-- =========================================================
-- 3. HOLIDAY
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


-- =========================================================
-- 4. LOCATION
-- =========================================================

CREATE TABLE IF NOT EXISTS Location (
    location_id INT UNSIGNED AUTO_INCREMENT,
    location_name VARCHAR(120) NOT NULL,
    address_line1 VARCHAR(150),
    city VARCHAR(80) NOT NULL,
    state_province VARCHAR(80) NOT NULL,
    postal_code VARCHAR(20),
    country VARCHAR(80) NOT NULL DEFAULT 'United States',
    location_type VARCHAR(40) NOT NULL,

    CONSTRAINT pk_location
        PRIMARY KEY (location_id),

    CONSTRAINT uq_location_name
        UNIQUE (location_name),

    CONSTRAINT chk_location_type
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
        )
);


-- =========================================================
-- 5. ACTIVITY
-- =========================================================

CREATE TABLE IF NOT EXISTS Activity (
    activity_id INT UNSIGNED AUTO_INCREMENT,
    activity_name VARCHAR(100) NOT NULL,
    activity_category VARCHAR(50) NOT NULL,
    default_duration_minutes SMALLINT UNSIGNED,
    min_participants TINYINT UNSIGNED NOT NULL DEFAULT 1,
    description VARCHAR(255),

    CONSTRAINT pk_activity
        PRIMARY KEY (activity_id),

    CONSTRAINT uq_activity_name
        UNIQUE (activity_name),

    CONSTRAINT chk_activity_category
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
        ),

    CONSTRAINT chk_activity_duration
        CHECK (
            default_duration_minutes IS NULL
            OR default_duration_minutes > 0
        ),

    CONSTRAINT chk_activity_participants
        CHECK (min_participants > 0)
);


-- =========================================================
-- 6. TRAVEL MODE
-- =========================================================

CREATE TABLE IF NOT EXISTS TravelMode (
    travel_mode_id SMALLINT UNSIGNED AUTO_INCREMENT,
    travel_mode_name VARCHAR(30) NOT NULL,
    description VARCHAR(255),

    CONSTRAINT pk_travel_mode
        PRIMARY KEY (travel_mode_id),

    CONSTRAINT uq_travel_mode_name
        UNIQUE (travel_mode_name)
);


-- =========================================================
-- 7. PACKING ITEM
-- =========================================================

CREATE TABLE IF NOT EXISTS PackingItem (
    item_id INT UNSIGNED AUTO_INCREMENT,
    item_name VARCHAR(100) NOT NULL,
    item_category VARCHAR(50) NOT NULL,
    description VARCHAR(255),

    CONSTRAINT pk_packing_item
        PRIMARY KEY (item_id),

    CONSTRAINT uq_packing_item_name
        UNIQUE (item_name),

    CONSTRAINT chk_packing_item_category
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
        )
);


-- =========================================================
-- 8. ACCOMMODATION
-- =========================================================

CREATE TABLE IF NOT EXISTS Accommodation (
    accommodation_id INT UNSIGNED AUTO_INCREMENT,
    accommodation_name VARCHAR(120) NOT NULL,
    location_id INT UNSIGNED NOT NULL,
    accommodation_type VARCHAR(40) NOT NULL,
    phone VARCHAR(25),
    website VARCHAR(255),

    CONSTRAINT pk_accommodation
        PRIMARY KEY (accommodation_id),

    CONSTRAINT uq_accommodation_name_location
        UNIQUE (accommodation_name, location_id),

    CONSTRAINT fk_accommodation_location
        FOREIGN KEY (location_id)
        REFERENCES Location(location_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT chk_accommodation_type
        CHECK (
            accommodation_type IN (
                'Hotel',
                'Lodge',
                'Cabin',
                'Resort',
                'Rental',
                'Other'
            )
        )
);


-- =========================================================
-- 9. OUTING
-- =========================================================

CREATE TABLE IF NOT EXISTS Outing (
    outing_id INT UNSIGNED AUTO_INCREMENT,
    outing_name VARCHAR(120) NOT NULL,
    trip_type_id SMALLINT UNSIGNED NOT NULL,
    primary_location_id INT UNSIGNED NOT NULL,
    holiday_id SMALLINT UNSIGNED,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    description VARCHAR(255),

    CONSTRAINT pk_outing
        PRIMARY KEY (outing_id),

    CONSTRAINT uq_outing_name_start_date
        UNIQUE (outing_name, start_date),

    CONSTRAINT fk_outing_trip_type
        FOREIGN KEY (trip_type_id)
        REFERENCES TripType(trip_type_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_outing_primary_location
        FOREIGN KEY (primary_location_id)
        REFERENCES Location(location_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT fk_outing_holiday
        FOREIGN KEY (holiday_id)
        REFERENCES Holiday(holiday_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT chk_outing_dates
        CHECK (end_date >= start_date)
);


-- =========================================================
-- 10. OUTING PARTICIPANT
--
-- Historical participation uses RESTRICT when deleting a
-- FamilyMember. Packing preferences later use CASCADE
-- because they belong to the member rather than trip history.
-- =========================================================

CREATE TABLE IF NOT EXISTS OutingParticipant (
    outing_id INT UNSIGNED NOT NULL,
    member_id INT UNSIGNED NOT NULL,
    attendance_status VARCHAR(20) NOT NULL DEFAULT 'Confirmed',

    CONSTRAINT pk_outing_participant
        PRIMARY KEY (outing_id, member_id),

    CONSTRAINT fk_op_outing
        FOREIGN KEY (outing_id)
        REFERENCES Outing(outing_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_op_member
        FOREIGN KEY (member_id)
        REFERENCES FamilyMember(member_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_attendance_status
        CHECK (
            attendance_status IN (
                'Invited',
                'Confirmed',
                'Declined'
            )
        )
);


-- =========================================================
-- 11. OUTING ACTIVITY
-- =========================================================

CREATE TABLE IF NOT EXISTS OutingActivity (
    outing_id INT UNSIGNED NOT NULL,
    activity_date DATE NOT NULL,
    sequence_number SMALLINT UNSIGNED NOT NULL,
    activity_id INT UNSIGNED NOT NULL,
    location_id INT UNSIGNED NOT NULL,
    start_time TIME,
    planned_duration_minutes SMALLINT UNSIGNED NOT NULL,
    notes VARCHAR(255),

    CONSTRAINT pk_outing_activity
        PRIMARY KEY (
            outing_id,
            activity_date,
            sequence_number
        ),

    CONSTRAINT fk_oa_outing
        FOREIGN KEY (outing_id)
        REFERENCES Outing(outing_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_oa_activity
        FOREIGN KEY (activity_id)
        REFERENCES Activity(activity_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_oa_location
        FOREIGN KEY (location_id)
        REFERENCES Location(location_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT chk_oa_sequence
        CHECK (sequence_number > 0),

    CONSTRAINT chk_oa_duration
        CHECK (planned_duration_minutes > 0)
);


-- =========================================================
-- 12. TRAVEL LEG
-- Cost means total estimated USD cost for the family leg.
-- =========================================================

CREATE TABLE IF NOT EXISTS TravelLeg (
    travel_leg_id INT UNSIGNED AUTO_INCREMENT,
    outing_id INT UNSIGNED NOT NULL,
    sequence_number SMALLINT UNSIGNED NOT NULL,
    travel_mode_id SMALLINT UNSIGNED NOT NULL,
    from_location_id INT UNSIGNED NOT NULL,
    to_location_id INT UNSIGNED NOT NULL,
    departure_datetime DATETIME,
    planned_duration_minutes SMALLINT UNSIGNED NOT NULL,
    estimated_cost_total_usd DECIMAL(10,2) NOT NULL,

    CONSTRAINT pk_travel_leg
        PRIMARY KEY (travel_leg_id),

    CONSTRAINT uq_travel_leg_sequence
        UNIQUE (outing_id, sequence_number),

    CONSTRAINT fk_tl_outing
        FOREIGN KEY (outing_id)
        REFERENCES Outing(outing_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_tl_mode
        FOREIGN KEY (travel_mode_id)
        REFERENCES TravelMode(travel_mode_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_tl_from_location
        FOREIGN KEY (from_location_id)
        REFERENCES Location(location_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT fk_tl_to_location
        FOREIGN KEY (to_location_id)
        REFERENCES Location(location_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT chk_tl_sequence
        CHECK (sequence_number > 0),

    CONSTRAINT chk_tl_duration
        CHECK (planned_duration_minutes > 0),

    CONSTRAINT chk_tl_cost
        CHECK (estimated_cost_total_usd >= 0),

    CONSTRAINT chk_tl_locations
        CHECK (from_location_id <> to_location_id)
);


-- =========================================================
-- 13. OUTING ACCOMMODATION
-- =========================================================

CREATE TABLE IF NOT EXISTS OutingAccommodation (
    outing_id INT UNSIGNED NOT NULL,
    accommodation_id INT UNSIGNED NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    nightly_rate_usd DECIMAL(10,2) NOT NULL,
    booking_reference VARCHAR(80),

    CONSTRAINT pk_outing_accommodation
        PRIMARY KEY (
            outing_id,
            accommodation_id,
            check_in_date
        ),

    CONSTRAINT fk_outacc_outing
        FOREIGN KEY (outing_id)
        REFERENCES Outing(outing_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_outacc_accommodation
        FOREIGN KEY (accommodation_id)
        REFERENCES Accommodation(accommodation_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_outacc_dates
        CHECK (check_out_date > check_in_date),

    CONSTRAINT chk_outacc_rate
        CHECK (nightly_rate_usd >= 0)
);


-- =========================================================
-- 14. MEMBER TRIP PACKING ITEM
-- =========================================================

CREATE TABLE IF NOT EXISTS MemberTripPackingItem (
    member_id INT UNSIGNED NOT NULL,
    trip_type_id SMALLINT UNSIGNED NOT NULL,
    item_id INT UNSIGNED NOT NULL,
    bag_type VARCHAR(20) NOT NULL,
    quantity SMALLINT UNSIGNED NOT NULL DEFAULT 1,

    CONSTRAINT pk_member_trip_item
        PRIMARY KEY (
            member_id,
            trip_type_id,
            item_id
        ),

    CONSTRAINT fk_mtp_member
        FOREIGN KEY (member_id)
        REFERENCES FamilyMember(member_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_mtp_trip_type
        FOREIGN KEY (trip_type_id)
        REFERENCES TripType(trip_type_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_mtp_item
        FOREIGN KEY (item_id)
        REFERENCES PackingItem(item_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_mtp_bag
        CHECK (
            bag_type IN (
                'Personal Item',
                'Suitcase'
            )
        ),

    CONSTRAINT chk_mtp_quantity
        CHECK (quantity > 0)
);


-- =========================================================
-- 15. MEMBER TRAVEL PACKING ITEM
-- =========================================================

CREATE TABLE IF NOT EXISTS MemberTravelPackingItem (
    member_id INT UNSIGNED NOT NULL,
    travel_mode_id SMALLINT UNSIGNED NOT NULL,
    item_id INT UNSIGNED NOT NULL,
    bag_type VARCHAR(20) NOT NULL,
    quantity SMALLINT UNSIGNED NOT NULL DEFAULT 1,

    CONSTRAINT pk_member_travel_item
        PRIMARY KEY (
            member_id,
            travel_mode_id,
            item_id
        ),

    CONSTRAINT fk_mvp_member
        FOREIGN KEY (member_id)
        REFERENCES FamilyMember(member_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_mvp_travel_mode
        FOREIGN KEY (travel_mode_id)
        REFERENCES TravelMode(travel_mode_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_mvp_item
        FOREIGN KEY (item_id)
        REFERENCES PackingItem(item_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_mvp_bag
        CHECK (
            bag_type IN (
                'Personal Item',
                'Vehicle'
            )
        ),

    CONSTRAINT chk_mvp_quantity
        CHECK (quantity > 0)
);


-- =========================================================
-- 16. ACTIVITY PACKING ITEM
-- =========================================================

CREATE TABLE IF NOT EXISTS ActivityPackingItem (
    activity_id INT UNSIGNED NOT NULL,
    item_id INT UNSIGNED NOT NULL,
    quantity SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    requirement_level VARCHAR(20) NOT NULL DEFAULT 'Required',

    CONSTRAINT pk_activity_packing_item
        PRIMARY KEY (activity_id, item_id),

    CONSTRAINT fk_api_activity
        FOREIGN KEY (activity_id)
        REFERENCES Activity(activity_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_api_item
        FOREIGN KEY (item_id)
        REFERENCES PackingItem(item_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_api_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_api_requirement
        CHECK (
            requirement_level IN (
                'Required',
                'Recommended'
            )
        )
);


-- =========================================================
-- TRIGGERS
-- =========================================================



DELIMITER $$


-- ---------------------------------------------------------
-- Outing INSERT:
-- enforce TripType duration.
-- ---------------------------------------------------------

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


-- ---------------------------------------------------------
-- Outing UPDATE:
-- enforce duration and prevent child rows from being
-- stranded outside a changed date range.
-- ---------------------------------------------------------

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


-- ---------------------------------------------------------
-- OutingActivity INSERT:
-- enforce parent dates and TripType daily maximum.
-- ---------------------------------------------------------

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


-- ---------------------------------------------------------
-- OutingActivity UPDATE.
-- ---------------------------------------------------------

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
    FROM OutingActivity oa
    WHERE oa.outing_id = NEW.outing_id
      AND oa.activity_date = NEW.activity_date
      AND NOT (
          oa.outing_id = OLD.outing_id
          AND oa.activity_date = OLD.activity_date
          AND oa.sequence_number = OLD.sequence_number
      );

    IF v_activity_count >= v_max_activities THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Activity count would exceed the TripType daily maximum';

    END IF;
END$$


-- ---------------------------------------------------------
-- OutingAccommodation INSERT.
-- ---------------------------------------------------------

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


-- ---------------------------------------------------------
-- OutingAccommodation UPDATE.
-- ---------------------------------------------------------

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


-- ---------------------------------------------------------
-- MemberTripPackingItem INSERT.
-- ---------------------------------------------------------

CREATE TRIGGER bi_mtp_validate_packing
BEFORE INSERT ON MemberTripPackingItem
FOR EACH ROW
BEGIN
    DECLARE v_max_days TINYINT UNSIGNED;

    SELECT max_days
    INTO v_max_days
    FROM TripType
    WHERE trip_type_id = NEW.trip_type_id;

    IF NEW.bag_type = 'Suitcase'
       AND v_max_days < 2 THEN

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


-- ---------------------------------------------------------
-- MemberTripPackingItem UPDATE.
-- ---------------------------------------------------------

CREATE TRIGGER bu_mtp_validate_packing
BEFORE UPDATE ON MemberTripPackingItem
FOR EACH ROW
BEGIN
    DECLARE v_max_days TINYINT UNSIGNED;

    SELECT max_days
    INTO v_max_days
    FROM TripType
    WHERE trip_type_id = NEW.trip_type_id;

    IF NEW.bag_type = 'Suitcase'
       AND v_max_days < 2 THEN

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


-- ---------------------------------------------------------
-- MemberTravelPackingItem INSERT.
-- ---------------------------------------------------------

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


-- ---------------------------------------------------------
-- MemberTravelPackingItem UPDATE.
-- ---------------------------------------------------------

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



-- ---------------------------------------------------------
-- TripType UPDATE:
-- prevent rule changes that invalidate existing outings,
-- scheduled activities, or suitcase packing definitions.
-- ---------------------------------------------------------

CREATE TRIGGER bu_triptype_validate_rules
BEFORE UPDATE ON TripType
FOR EACH ROW
BEGIN

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

-- =========================================================
-- BASE SAMPLE DATA
-- =========================================================
-- CSC6302 Database Principles
-- Module 2 Practice: Holiday Planner
-- Realistic sample data
--

USE HolidayPlanner;

-- =========================================================
-- 1. FAMILY MEMBERS
-- =========================================================

INSERT INTO FamilyMember (
    first_name,
    middle_name,
    last_name,
    birth_date,
    relationship_to_household
)
VALUES
('Jordan', NULL, 'Hart', '1988-04-12', 'Parent'),
('Taylor', 'Marie', 'Hart', '1990-09-21', 'Parent'),
('Avery', NULL, 'Hart', '2013-03-14', 'Child'),
('Riley', 'James', 'Hart', '2017-07-08', 'Child');


-- =========================================================
-- 2. TRIP TYPES
-- =========================================================

INSERT INTO TripType (
    trip_type_name,
    min_days,
    max_days,
    min_activities_per_day,
    max_activities_per_day,
    description
)
VALUES
(
    'Single Afternoon',
    1, 1, 1, 2,
    'One-day outing centered on one or two activities'
),
(
    'Multi-Activity Day',
    1, 1, 3, 8,
    'One-day outing containing several activities in sequence'
),
(
    'Weekend',
    2, 3, 1, 8,
    'Two- or three-day family trip'
),
(
    'Week Long',
    5, 8, 1, 8,
    'Extended family trip lasting approximately one week'
);


-- =========================================================
-- 3. HOLIDAYS
-- =========================================================

INSERT INTO Holiday (
    holiday_name,
    description
)
VALUES
('Halloween', 'Halloween-related family outing'),
('Christmas', 'Christmas-season family outing');


-- =========================================================
-- 4. TRAVEL MODES
-- =========================================================

INSERT INTO TravelMode (
    travel_mode_name,
    description
)
VALUES
('Car', 'Private automobile travel'),
('Plane', 'Commercial airline travel'),
('Train', 'Passenger rail travel'),
('Bus', 'Public or motor-coach bus travel'),
('Other', 'Taxi, rideshare, shuttle, or another local transportation mode');


-- =========================================================
-- 5. LOCATIONS
-- =========================================================

INSERT INTO Location (
    location_name,
    address_line1,
    city,
    state_province,
    postal_code,
    country,
    location_type
)
VALUES
('Hart Home', '10 Maple Lane', 'Albany', 'New York', '12203', 'United States', 'Home'),
('Sunny Acres Farm', '120 Harvest Road', 'Voorheesville', 'New York', '12186', 'United States', 'Farm'),
('Hudson Valley Orchard', '44 Orchard Way', 'Hudson', 'New York', '12534', 'United States', 'Farm'),
('Harvest Corn Maze', '88 Autumn Road', 'Kinderhook', 'New York', '12106', 'United States', 'Attraction'),
('Black Lantern Manor', '31 Hollow Street', 'Troy', 'New York', '12180', 'United States', 'Attraction'),
('Harvest Bistro', '72 River Street', 'Troy', 'New York', '12180', 'United States', 'Restaurant'),
('Albany International Airport', '737 Albany Shaker Road', 'Albany', 'New York', '12211', 'United States', 'Airport'),
('Downtown Boston', NULL, 'Boston', 'Massachusetts', '02108', 'United States', 'City'),
('White Pine Mountain Resort', '140 Mountain Road', 'Lake Placid', 'New York', '12946', 'United States', 'Resort'),
('Adirondack Lake Cabin Area', '22 Lake Shore Road', 'Saranac Lake', 'New York', '12983', 'United States', 'Cabin Area'),
('Adirondack Trailhead', '4 Summit Road', 'Lake Placid', 'New York', '12946', 'United States', 'Trailhead'),
('Mirror Lake', '1 Lake Drive', 'Lake Placid', 'New York', '12946', 'United States', 'Lake'),
('Lake Placid Village', NULL, 'Lake Placid', 'New York', '12946', 'United States', 'Town'),
('Chicago O Hare International Airport', '10000 W O Hare Avenue', 'Chicago', 'Illinois', '60666', 'United States', 'Airport'),
('Downtown Chicago', NULL, 'Chicago', 'Illinois', '60601', 'United States', 'City'),
('Millennium Park', '201 E Randolph Street', 'Chicago', 'Illinois', '60602', 'United States', 'Park'),
('Museum Campus', '337 E Randolph Street', 'Chicago', 'Illinois', '60601', 'United States', 'Museum District'),
('Chicago Holiday Market', '50 W Washington Street', 'Chicago', 'Illinois', '60602', 'United States', 'Market');


-- =========================================================
-- 6. ACTIVITIES
-- =========================================================

INSERT INTO Activity (
    activity_name,
    activity_category,
    default_duration_minutes,
    min_participants,
    description
)
VALUES
('Pumpkin Picking', 'Outdoor', 90, 1, 'Select pumpkins at a farm'),
('Farm Market', 'Shopping', 60, 1, 'Visit a farm market'),
('Apple Picking', 'Outdoor', 90, 1, 'Pick apples at an orchard'),
('Corn Maze', 'Outdoor', 75, 2, 'Complete a seasonal corn maze'),
('Haunted House', 'Entertainment', 60, 2, 'Walk through a haunted attraction'),
('Dinner', 'Dining', 90, 1, 'Family restaurant meal'),
('Skiing', 'Winter Sport', 240, 1, 'Downhill skiing'),
('Hot Tub', 'Recreation', 60, 1, 'Relaxation activity'),
('Snowshoeing', 'Winter Sport', 120, 1, 'Snowshoe trail activity'),
('Hiking', 'Outdoor', 180, 1, 'Trail hiking'),
('Kayaking', 'Water Sport', 120, 1, 'Recreational kayaking'),
('Sightseeing', 'Tourism', 120, 1, 'Visit local attractions'),
('Swimming', 'Water Sport', 90, 1, 'Recreational swimming'),
('Museum Visit', 'Education', 150, 1, 'Visit a museum'),
('Ice Skating', 'Winter Sport', 90, 1, 'Outdoor or indoor ice skating'),
('Holiday Market', 'Shopping', 120, 1, 'Visit a seasonal holiday market');


-- =========================================================
-- 7. PACKING ITEMS
-- =========================================================

INSERT INTO PackingItem (
    item_name,
    item_category,
    description
)
VALUES
('Phone', 'Electronics', 'Mobile phone'),
('Wallet', 'Personal', 'Wallet and payment cards'),
('Water Bottle', 'Food and Drink', 'Reusable water bottle'),
('Snacks', 'Food and Drink', 'General snacks'),
('Boots', 'Clothing', 'Outdoor boots'),
('Gloves', 'Clothing', 'Cold-weather gloves'),
('Phone Charger', 'Electronics', 'Standard phone charger'),
('Medication', 'Health', 'Regular personal medication'),
('Toothbrush', 'Toiletries', 'Personal toothbrush'),
('Clothing', 'Clothing', 'General change of clothing'),
('Toiletries', 'Toiletries', 'General hygiene supplies'),
('Sleepwear', 'Clothing', 'Night clothing'),
('Ski Goggles', 'Sport Equipment', 'Protective ski goggles'),
('Travel Documents', 'Travel', 'Identification and travel documents'),
('Approved Liquids Bag', 'Travel', 'Airline-compliant liquids bag'),
('Road Snacks', 'Food and Drink', 'Food intended for road travel'),
('Cooler', 'Travel', 'Portable cooler for automobile trips'),
('Vehicle Emergency Kit', 'Safety', 'Emergency supplies for automobile travel'),
('Hiking Boots', 'Sport Equipment', 'Footwear for hiking'),
('Sunscreen', 'Health', 'Sun protection'),
('Swimsuit', 'Clothing', 'Swimming clothing'),
('Carry-On Charger', 'Electronics', 'Charger stored in personal carry-on');


-- =========================================================
-- 8. ACCOMMODATIONS
-- =========================================================

INSERT INTO Accommodation (
    accommodation_name,
    location_id,
    accommodation_type,
    phone,
    website
)
VALUES
(
    'White Pine Mountain Lodge',
    (SELECT location_id FROM Location WHERE location_name = 'White Pine Mountain Resort'),
    'Lodge',
    '518-555-0101',
    'https://example.com/white-pine'
),
(
    'Boston Harbor Hotel',
    (SELECT location_id FROM Location WHERE location_name = 'Downtown Boston'),
    'Hotel',
    '617-555-0102',
    'https://example.com/boston-harbor'
),
(
    'Adirondack Family Cabin',
    (SELECT location_id FROM Location WHERE location_name = 'Adirondack Lake Cabin Area'),
    'Cabin',
    '518-555-0103',
    'https://example.com/adirondack-cabin'
),
(
    'Lake Placid Inn',
    (SELECT location_id FROM Location WHERE location_name = 'Lake Placid Village'),
    'Hotel',
    '518-555-0104',
    'https://example.com/lake-placid'
),
(
    'Chicago Central Hotel',
    (SELECT location_id FROM Location WHERE location_name = 'Downtown Chicago'),
    'Hotel',
    '312-555-0105',
    'https://example.com/chicago-central'
),
(
    'Chicago Riverside Hotel',
    (SELECT location_id FROM Location WHERE location_name = 'Downtown Chicago'),
    'Hotel',
    '312-555-0106',
    'https://example.com/chicago-riverside'
);


-- =========================================================
-- 9. LOOKUP VARIABLES
-- =========================================================

SET @single_afternoon = (
    SELECT trip_type_id FROM TripType
    WHERE trip_type_name = 'Single Afternoon'
);

SET @multi_activity_day = (
    SELECT trip_type_id FROM TripType
    WHERE trip_type_name = 'Multi-Activity Day'
);

SET @weekend = (
    SELECT trip_type_id FROM TripType
    WHERE trip_type_name = 'Weekend'
);

SET @week_long = (
    SELECT trip_type_id FROM TripType
    WHERE trip_type_name = 'Week Long'
);

SET @halloween_holiday = (
    SELECT holiday_id FROM Holiday
    WHERE holiday_name = 'Halloween'
);

SET @christmas_holiday = (
    SELECT holiday_id FROM Holiday
    WHERE holiday_name = 'Christmas'
);

SET @car = (
    SELECT travel_mode_id FROM TravelMode
    WHERE travel_mode_name = 'Car'
);

SET @plane = (
    SELECT travel_mode_id FROM TravelMode
    WHERE travel_mode_name = 'Plane'
);

SET @other = (
    SELECT travel_mode_id FROM TravelMode
    WHERE travel_mode_name = 'Other'
);


-- =========================================================
-- 10. OUTINGS
-- =========================================================

INSERT INTO Outing (
    outing_name,
    trip_type_id,
    primary_location_id,
    holiday_id,
    start_date,
    end_date,
    description
)
VALUES
(
    'Fall Pumpkin Picking',
    @single_afternoon,
    (SELECT location_id FROM Location WHERE location_name = 'Sunny Acres Farm'),
    NULL,
    '2026-10-10',
    '2026-10-10',
    'Single-afternoon family farm outing'
),
(
    'Halloween Adventure Day',
    @multi_activity_day,
    (SELECT location_id FROM Location WHERE location_name = 'Hudson Valley Orchard'),
    @halloween_holiday,
    '2026-10-31',
    '2026-10-31',
    'Several Halloween activities completed in sequence'
),
(
    'Winter Mountain Weekend',
    @weekend,
    (SELECT location_id FROM Location WHERE location_name = 'White Pine Mountain Resort'),
    NULL,
    '2027-01-15',
    '2027-01-17',
    'Weekend winter trip reached by automobile'
),
(
    'Boston Holiday Weekend',
    @weekend,
    (SELECT location_id FROM Location WHERE location_name = 'Downtown Boston'),
    @christmas_holiday,
    '2026-12-18',
    '2026-12-20',
    'Weekend family road trip from Albany to Boston'
),
(
    'Adirondack Summer Week',
    @week_long,
    (SELECT location_id FROM Location WHERE location_name = 'Lake Placid Village'),
    NULL,
    '2027-07-11',
    '2027-07-17',
    'Week-long driving vacation with two accommodations'
),
(
    'Chicago Christmas Week',
    @week_long,
    (SELECT location_id FROM Location WHERE location_name = 'Downtown Chicago'),
    @christmas_holiday,
    '2027-12-20',
    '2027-12-27',
    'Week-long family holiday requiring airplane travel'
);


SET @pumpkin = (
    SELECT outing_id FROM Outing
    WHERE outing_name = 'Fall Pumpkin Picking'
      AND start_date = '2026-10-10'
);

SET @halloween = (
    SELECT outing_id FROM Outing
    WHERE outing_name = 'Halloween Adventure Day'
      AND start_date = '2026-10-31'
);

SET @mountain = (
    SELECT outing_id FROM Outing
    WHERE outing_name = 'Winter Mountain Weekend'
      AND start_date = '2027-01-15'
);

SET @boston = (
    SELECT outing_id FROM Outing
    WHERE outing_name = 'Boston Holiday Weekend'
      AND start_date = '2026-12-18'
);

SET @adirondack = (
    SELECT outing_id FROM Outing
    WHERE outing_name = 'Adirondack Summer Week'
      AND start_date = '2027-07-11'
);

SET @chicago = (
    SELECT outing_id FROM Outing
    WHERE outing_name = 'Chicago Christmas Week'
      AND start_date = '2027-12-20'
);


-- =========================================================
-- 11. OUTING PARTICIPANTS
-- =========================================================

INSERT INTO OutingParticipant (
    outing_id,
    member_id,
    attendance_status
)
SELECT
    o.outing_id,
    f.member_id,
    'Confirmed'
FROM Outing o
CROSS JOIN FamilyMember f;


-- =========================================================
-- 12. OUTING ACTIVITIES
-- =========================================================

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

-- Single Afternoon
(
    @pumpkin, '2026-10-10', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Pumpkin Picking'),
    (SELECT location_id FROM Location WHERE location_name = 'Sunny Acres Farm'),
    '13:00:00', 90, 'Primary afternoon activity'
),
(
    @pumpkin, '2026-10-10', 2,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Farm Market'),
    (SELECT location_id FROM Location WHERE location_name = 'Sunny Acres Farm'),
    '15:00:00', 60, 'Farm market visit before returning home'
),

-- Multi-Activity Day
(
    @halloween, '2026-10-31', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Apple Picking'),
    (SELECT location_id FROM Location WHERE location_name = 'Hudson Valley Orchard'),
    '10:00:00', 90, NULL
),
(
    @halloween, '2026-10-31', 2,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Corn Maze'),
    (SELECT location_id FROM Location WHERE location_name = 'Harvest Corn Maze'),
    '12:00:00', 75, NULL
),
(
    @halloween, '2026-10-31', 3,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Haunted House'),
    (SELECT location_id FROM Location WHERE location_name = 'Black Lantern Manor'),
    '15:00:00', 60, NULL
),
(
    @halloween, '2026-10-31', 4,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Dinner'),
    (SELECT location_id FROM Location WHERE location_name = 'Harvest Bistro'),
    '17:30:00', 90, NULL
),

-- Winter Weekend
(
    @mountain, '2027-01-15', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Dinner'),
    (SELECT location_id FROM Location WHERE location_name = 'White Pine Mountain Resort'),
    '19:00:00', 90, NULL
),
(
    @mountain, '2027-01-16', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Skiing'),
    (SELECT location_id FROM Location WHERE location_name = 'White Pine Mountain Resort'),
    '09:00:00', 240, NULL
),
(
    @mountain, '2027-01-16', 2,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Hot Tub'),
    (SELECT location_id FROM Location WHERE location_name = 'White Pine Mountain Resort'),
    '16:00:00', 60, NULL
),
(
    @mountain, '2027-01-17', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Snowshoeing'),
    (SELECT location_id FROM Location WHERE location_name = 'White Pine Mountain Resort'),
    '09:30:00', 120, NULL
),

-- Boston Weekend
(
    @boston, '2026-12-18', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Dinner'),
    (SELECT location_id FROM Location WHERE location_name = 'Downtown Boston'),
    '19:00:00', 90, 'Arrival-day dinner'
),
(
    @boston, '2026-12-19', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Sightseeing'),
    (SELECT location_id FROM Location WHERE location_name = 'Downtown Boston'),
    '10:00:00', 180, NULL
),
(
    @boston, '2026-12-20', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Sightseeing'),
    (SELECT location_id FROM Location WHERE location_name = 'Downtown Boston'),
    '09:00:00', 120, 'Final morning before driving home'
),

-- Adirondack Week
(
    @adirondack, '2027-07-11', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Sightseeing'),
    (SELECT location_id FROM Location WHERE location_name = 'Lake Placid Village'),
    '16:00:00', 120, 'Arrival-day village visit'
),
(
    @adirondack, '2027-07-12', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Hiking'),
    (SELECT location_id FROM Location WHERE location_name = 'Adirondack Trailhead'),
    '09:00:00', 180, NULL
),
(
    @adirondack, '2027-07-13', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Kayaking'),
    (SELECT location_id FROM Location WHERE location_name = 'Mirror Lake'),
    '10:00:00', 120, NULL
),
(
    @adirondack, '2027-07-14', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Swimming'),
    (SELECT location_id FROM Location WHERE location_name = 'Mirror Lake'),
    '13:00:00', 90, NULL
),
(
    @adirondack, '2027-07-15', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Dinner'),
    (SELECT location_id FROM Location WHERE location_name = 'Lake Placid Village'),
    '18:00:00', 90, 'Dinner after changing accommodations'
),
(
    @adirondack, '2027-07-16', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Sightseeing'),
    (SELECT location_id FROM Location WHERE location_name = 'Lake Placid Village'),
    '10:00:00', 180, NULL
),
(
    @adirondack, '2027-07-17', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Hiking'),
    (SELECT location_id FROM Location WHERE location_name = 'Adirondack Trailhead'),
    '08:00:00', 120, 'Short final-morning hike before returning home'
),

-- Chicago Week
(
    @chicago, '2027-12-20', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Dinner'),
    (SELECT location_id FROM Location WHERE location_name = 'Downtown Chicago'),
    '19:00:00', 90, 'Arrival-day dinner'
),
(
    @chicago, '2027-12-21', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Holiday Market'),
    (SELECT location_id FROM Location WHERE location_name = 'Chicago Holiday Market'),
    '10:00:00', 120, NULL
),
(
    @chicago, '2027-12-22', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Museum Visit'),
    (SELECT location_id FROM Location WHERE location_name = 'Museum Campus'),
    '10:00:00', 150, NULL
),
(
    @chicago, '2027-12-23', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Ice Skating'),
    (SELECT location_id FROM Location WHERE location_name = 'Millennium Park'),
    '13:00:00', 90, NULL
),
(
    @chicago, '2027-12-24', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Sightseeing'),
    (SELECT location_id FROM Location WHERE location_name = 'Downtown Chicago'),
    '11:00:00', 120, NULL
),
(
    @chicago, '2027-12-25', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Sightseeing'),
    (SELECT location_id FROM Location WHERE location_name = 'Millennium Park'),
    '11:00:00', 120, 'Christmas Day sightseeing'
),
(
    @chicago, '2027-12-26', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Museum Visit'),
    (SELECT location_id FROM Location WHERE location_name = 'Museum Campus'),
    '11:00:00', 150, NULL
),
(
    @chicago, '2027-12-27', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Sightseeing'),
    (SELECT location_id FROM Location WHERE location_name = 'Downtown Chicago'),
    '09:00:00', 120, 'Final morning before departure'
);


-- =========================================================
-- 13. TRAVEL LEGS
-- =========================================================

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

-- Pumpkin
(
    @pumpkin, 1, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    (SELECT location_id FROM Location WHERE location_name = 'Sunny Acres Farm'),
    '2026-10-10 12:00:00', 35, 8.00
),
(
    @pumpkin, 2, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Sunny Acres Farm'),
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    '2026-10-10 16:30:00', 35, 8.00
),

-- Halloween
(
    @halloween, 1, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    (SELECT location_id FROM Location WHERE location_name = 'Hudson Valley Orchard'),
    '2026-10-31 08:30:00', 45, 10.00
),
(
    @halloween, 2, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Hudson Valley Orchard'),
    (SELECT location_id FROM Location WHERE location_name = 'Harvest Corn Maze'),
    '2026-10-31 11:40:00', 20, 4.00
),
(
    @halloween, 3, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Harvest Corn Maze'),
    (SELECT location_id FROM Location WHERE location_name = 'Black Lantern Manor'),
    '2026-10-31 14:15:00', 30, 6.00
),
(
    @halloween, 4, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Black Lantern Manor'),
    (SELECT location_id FROM Location WHERE location_name = 'Harvest Bistro'),
    '2026-10-31 16:20:00', 20, 4.00
),
(
    @halloween, 5, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Harvest Bistro'),
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    '2026-10-31 19:15:00', 25, 6.00
),

-- Mountain
(
    @mountain, 1, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    (SELECT location_id FROM Location WHERE location_name = 'White Pine Mountain Resort'),
    '2027-01-15 14:00:00', 150, 35.00
),
(
    @mountain, 2, @car,
    (SELECT location_id FROM Location WHERE location_name = 'White Pine Mountain Resort'),
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    '2027-01-17 14:00:00', 150, 35.00
),

-- Boston
(
    @boston, 1, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    (SELECT location_id FROM Location WHERE location_name = 'Downtown Boston'),
    '2026-12-18 08:00:00', 180, 55.00
),
(
    @boston, 2, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Downtown Boston'),
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    '2026-12-20 14:00:00', 180, 55.00
),

-- Adirondack
(
    @adirondack, 1, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    (SELECT location_id FROM Location WHERE location_name = 'Adirondack Lake Cabin Area'),
    '2027-07-11 09:00:00', 150, 35.00
),
(
    @adirondack, 2, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Adirondack Lake Cabin Area'),
    (SELECT location_id FROM Location WHERE location_name = 'Lake Placid Village'),
    '2027-07-15 09:00:00', 35, 10.00
),
(
    @adirondack, 3, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Lake Placid Village'),
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    '2027-07-17 13:00:00', 165, 40.00
),

-- Chicago
(
    @chicago, 1, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    (SELECT location_id FROM Location WHERE location_name = 'Albany International Airport'),
    '2027-12-20 07:30:00', 25, 6.00
),
(
    @chicago, 2, @plane,
    (SELECT location_id FROM Location WHERE location_name = 'Albany International Airport'),
    (SELECT location_id FROM Location WHERE location_name = 'Chicago O Hare International Airport'),
    '2027-12-20 10:00:00', 150, 1200.00
),
(
    @chicago, 3, @other,
    (SELECT location_id FROM Location WHERE location_name = 'Chicago O Hare International Airport'),
    (SELECT location_id FROM Location WHERE location_name = 'Downtown Chicago'),
    '2027-12-20 12:45:00', 45, 75.00
),
(
    @chicago, 4, @other,
    (SELECT location_id FROM Location WHERE location_name = 'Downtown Chicago'),
    (SELECT location_id FROM Location WHERE location_name = 'Chicago O Hare International Airport'),
    '2027-12-27 13:00:00', 45, 75.00
),
(
    @chicago, 5, @plane,
    (SELECT location_id FROM Location WHERE location_name = 'Chicago O Hare International Airport'),
    (SELECT location_id FROM Location WHERE location_name = 'Albany International Airport'),
    '2027-12-27 16:00:00', 150, 1200.00
),
(
    @chicago, 6, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Albany International Airport'),
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    '2027-12-27 19:00:00', 25, 6.00
);


-- =========================================================
-- 14. ACCOMMODATION BOOKINGS
-- =========================================================

INSERT INTO OutingAccommodation (
    outing_id,
    accommodation_id,
    check_in_date,
    check_out_date,
    nightly_rate_usd,
    booking_reference
)
VALUES
(
    @mountain,
    (SELECT accommodation_id FROM Accommodation WHERE accommodation_name = 'White Pine Mountain Lodge'),
    '2027-01-15', '2027-01-17', 210.00, 'MTN-2027-001'
),
(
    @boston,
    (SELECT accommodation_id FROM Accommodation WHERE accommodation_name = 'Boston Harbor Hotel'),
    '2026-12-18', '2026-12-20', 265.00, 'BOS-2026-001'
),
(
    @adirondack,
    (SELECT accommodation_id FROM Accommodation WHERE accommodation_name = 'Adirondack Family Cabin'),
    '2027-07-11', '2027-07-15', 180.00, 'ADK-2027-001'
),
(
    @adirondack,
    (SELECT accommodation_id FROM Accommodation WHERE accommodation_name = 'Lake Placid Inn'),
    '2027-07-15', '2027-07-17', 225.00, 'ADK-2027-002'
),
(
    @chicago,
    (SELECT accommodation_id FROM Accommodation WHERE accommodation_name = 'Chicago Central Hotel'),
    '2027-12-20', '2027-12-24', 245.00, 'CHI-2027-001'
),
(
    @chicago,
    (SELECT accommodation_id FROM Accommodation WHERE accommodation_name = 'Chicago Riverside Hotel'),
    '2027-12-24', '2027-12-27', 260.00, 'CHI-2027-002'
);


-- =========================================================
-- 15. PACKING LOOKUPS
-- =========================================================

SET @jordan = (
    SELECT member_id FROM FamilyMember
    WHERE first_name = 'Jordan'
      AND last_name = 'Hart'
      AND birth_date = '1988-04-12'
);

SET @taylor = (
    SELECT member_id FROM FamilyMember
    WHERE first_name = 'Taylor'
      AND last_name = 'Hart'
      AND birth_date = '1990-09-21'
);

SET @avery = (
    SELECT member_id FROM FamilyMember
    WHERE first_name = 'Avery'
      AND last_name = 'Hart'
      AND birth_date = '2013-03-14'
);

SET @riley = (
    SELECT member_id FROM FamilyMember
    WHERE first_name = 'Riley'
      AND last_name = 'Hart'
      AND birth_date = '2017-07-08'
);

SET @phone = (SELECT item_id FROM PackingItem WHERE item_name = 'Phone');
SET @wallet = (SELECT item_id FROM PackingItem WHERE item_name = 'Wallet');
SET @water = (SELECT item_id FROM PackingItem WHERE item_name = 'Water Bottle');
SET @snacks = (SELECT item_id FROM PackingItem WHERE item_name = 'Snacks');
SET @boots = (SELECT item_id FROM PackingItem WHERE item_name = 'Boots');
SET @gloves = (SELECT item_id FROM PackingItem WHERE item_name = 'Gloves');
SET @medication = (SELECT item_id FROM PackingItem WHERE item_name = 'Medication');
SET @toothbrush = (SELECT item_id FROM PackingItem WHERE item_name = 'Toothbrush');
SET @clothing = (SELECT item_id FROM PackingItem WHERE item_name = 'Clothing');
SET @toiletries = (SELECT item_id FROM PackingItem WHERE item_name = 'Toiletries');
SET @sleepwear = (SELECT item_id FROM PackingItem WHERE item_name = 'Sleepwear');
SET @ski_goggles = (SELECT item_id FROM PackingItem WHERE item_name = 'Ski Goggles');
SET @documents = (SELECT item_id FROM PackingItem WHERE item_name = 'Travel Documents');
SET @liquids = (SELECT item_id FROM PackingItem WHERE item_name = 'Approved Liquids Bag');
SET @road_snacks = (SELECT item_id FROM PackingItem WHERE item_name = 'Road Snacks');
SET @cooler = (SELECT item_id FROM PackingItem WHERE item_name = 'Cooler');
SET @emergency = (SELECT item_id FROM PackingItem WHERE item_name = 'Vehicle Emergency Kit');
SET @hiking_boots = (SELECT item_id FROM PackingItem WHERE item_name = 'Hiking Boots');
SET @sunscreen = (SELECT item_id FROM PackingItem WHERE item_name = 'Sunscreen');
SET @swimsuit = (SELECT item_id FROM PackingItem WHERE item_name = 'Swimsuit');
SET @carry_charger = (SELECT item_id FROM PackingItem WHERE item_name = 'Carry-On Charger');


-- =========================================================
-- 16. MEMBER TRIP PACKING
-- =========================================================

INSERT INTO MemberTripPackingItem (
    member_id,
    trip_type_id,
    item_id,
    bag_type,
    quantity
)
VALUES

(@jordan, @single_afternoon, @phone, 'Personal Item', 1),
(@jordan, @single_afternoon, @wallet, 'Personal Item', 1),
(@jordan, @single_afternoon, @water, 'Personal Item', 1),

(@jordan, @multi_activity_day, @phone, 'Personal Item', 1),
(@jordan, @multi_activity_day, @wallet, 'Personal Item', 1),
(@jordan, @multi_activity_day, @water, 'Personal Item', 1),

(@jordan, @weekend, @phone, 'Personal Item', 1),
(@jordan, @weekend, @wallet, 'Personal Item', 1),
(@jordan, @weekend, @medication, 'Personal Item', 1),
(@jordan, @weekend, @toothbrush, 'Suitcase', 1),
(@jordan, @weekend, @clothing, 'Suitcase', 2),
(@jordan, @weekend, @sleepwear, 'Suitcase', 1),

(@jordan, @week_long, @phone, 'Personal Item', 1),
(@jordan, @week_long, @wallet, 'Personal Item', 1),
(@jordan, @week_long, @medication, 'Personal Item', 1),
(@jordan, @week_long, @toothbrush, 'Suitcase', 1),
(@jordan, @week_long, @clothing, 'Suitcase', 7),
(@jordan, @week_long, @toiletries, 'Suitcase', 1),
(@jordan, @week_long, @sleepwear, 'Suitcase', 2),

(@taylor, @single_afternoon, @phone, 'Personal Item', 1),
(@taylor, @single_afternoon, @wallet, 'Personal Item', 1),
(@taylor, @single_afternoon, @water, 'Personal Item', 1),

(@taylor, @weekend, @phone, 'Personal Item', 1),
(@taylor, @weekend, @wallet, 'Personal Item', 1),
(@taylor, @weekend, @toothbrush, 'Suitcase', 1),
(@taylor, @weekend, @clothing, 'Suitcase', 2),
(@taylor, @weekend, @sleepwear, 'Suitcase', 1),

(@taylor, @week_long, @phone, 'Personal Item', 1),
(@taylor, @week_long, @wallet, 'Personal Item', 1),
(@taylor, @week_long, @toothbrush, 'Suitcase', 1),
(@taylor, @week_long, @clothing, 'Suitcase', 7),
(@taylor, @week_long, @toiletries, 'Suitcase', 1),

(@avery, @weekend, @phone, 'Personal Item', 1),
(@avery, @weekend, @water, 'Personal Item', 1),
(@avery, @weekend, @toothbrush, 'Suitcase', 1),
(@avery, @weekend, @clothing, 'Suitcase', 2),

(@avery, @week_long, @phone, 'Personal Item', 1),
(@avery, @week_long, @water, 'Personal Item', 1),
(@avery, @week_long, @toothbrush, 'Suitcase', 1),
(@avery, @week_long, @clothing, 'Suitcase', 7),

(@riley, @weekend, @water, 'Personal Item', 1),
(@riley, @weekend, @snacks, 'Personal Item', 2),
(@riley, @weekend, @toothbrush, 'Suitcase', 1),
(@riley, @weekend, @clothing, 'Suitcase', 3),

(@riley, @week_long, @water, 'Personal Item', 1),
(@riley, @week_long, @snacks, 'Personal Item', 2),
(@riley, @week_long, @toothbrush, 'Suitcase', 1),
(@riley, @week_long, @clothing, 'Suitcase', 8);


-- =========================================================
-- 17. MEMBER TRAVEL PACKING
-- =========================================================

INSERT INTO MemberTravelPackingItem (
    member_id,
    travel_mode_id,
    item_id,
    bag_type,
    quantity
)
VALUES
(@jordan, @plane, @documents, 'Personal Item', 1),
(@jordan, @plane, @liquids, 'Personal Item', 1),
(@jordan, @plane, @carry_charger, 'Personal Item', 1),

(@taylor, @plane, @documents, 'Personal Item', 1),
(@taylor, @plane, @liquids, 'Personal Item', 1),
(@taylor, @plane, @carry_charger, 'Personal Item', 1),

(@avery, @plane, @documents, 'Personal Item', 1),
(@avery, @plane, @carry_charger, 'Personal Item', 1),

(@riley, @plane, @documents, 'Personal Item', 1),

(@jordan, @car, @road_snacks, 'Personal Item', 1),
(@jordan, @car, @cooler, 'Vehicle', 1),
(@jordan, @car, @emergency, 'Vehicle', 1),

(@taylor, @car, @road_snacks, 'Personal Item', 1),
(@avery, @car, @road_snacks, 'Personal Item', 1),
(@riley, @car, @road_snacks, 'Personal Item', 1);


-- =========================================================
-- 18. ACTIVITY PACKING
-- =========================================================

INSERT INTO ActivityPackingItem (
    activity_id,
    item_id,
    quantity,
    requirement_level
)
VALUES
((SELECT activity_id FROM Activity WHERE activity_name = 'Pumpkin Picking'), @boots, 1, 'Recommended'),
((SELECT activity_id FROM Activity WHERE activity_name = 'Pumpkin Picking'), @gloves, 1, 'Recommended'),
((SELECT activity_id FROM Activity WHERE activity_name = 'Skiing'), @gloves, 1, 'Required'),
((SELECT activity_id FROM Activity WHERE activity_name = 'Skiing'), @ski_goggles, 1, 'Required'),
((SELECT activity_id FROM Activity WHERE activity_name = 'Snowshoeing'), @boots, 1, 'Required'),
((SELECT activity_id FROM Activity WHERE activity_name = 'Hiking'), @hiking_boots, 1, 'Required'),
((SELECT activity_id FROM Activity WHERE activity_name = 'Hiking'), @water, 1, 'Required'),
((SELECT activity_id FROM Activity WHERE activity_name = 'Kayaking'), @water, 1, 'Required'),
((SELECT activity_id FROM Activity WHERE activity_name = 'Kayaking'), @sunscreen, 1, 'Recommended'),
((SELECT activity_id FROM Activity WHERE activity_name = 'Swimming'), @swimsuit, 1, 'Required'),
((SELECT activity_id FROM Activity WHERE activity_name = 'Swimming'), @sunscreen, 1, 'Recommended'),
((SELECT activity_id FROM Activity WHERE activity_name = 'Ice Skating'), @gloves, 1, 'Recommended');


-- =========================================================
-- 19. ROW COUNTS
-- =========================================================

SELECT 'FamilyMember' AS table_name, COUNT(*) AS row_count FROM FamilyMember
UNION ALL SELECT 'TripType', COUNT(*) FROM TripType
UNION ALL SELECT 'Holiday', COUNT(*) FROM Holiday
UNION ALL SELECT 'Location', COUNT(*) FROM Location
UNION ALL SELECT 'Outing', COUNT(*) FROM Outing
UNION ALL SELECT 'OutingParticipant', COUNT(*) FROM OutingParticipant
UNION ALL SELECT 'Activity', COUNT(*) FROM Activity
UNION ALL SELECT 'OutingActivity', COUNT(*) FROM OutingActivity
UNION ALL SELECT 'TravelMode', COUNT(*) FROM TravelMode
UNION ALL SELECT 'TravelLeg', COUNT(*) FROM TravelLeg
UNION ALL SELECT 'Accommodation', COUNT(*) FROM Accommodation
UNION ALL SELECT 'OutingAccommodation', COUNT(*) FROM OutingAccommodation
UNION ALL SELECT 'PackingItem', COUNT(*) FROM PackingItem
UNION ALL SELECT 'MemberTripPackingItem', COUNT(*) FROM MemberTripPackingItem
UNION ALL SELECT 'MemberTravelPackingItem', COUNT(*) FROM MemberTravelPackingItem
UNION ALL SELECT 'ActivityPackingItem', COUNT(*) FROM ActivityPackingItem;


-- =========================================================
-- 20. FINAL ZERO-ROW AUDITS
-- Every query below should return 0 rows.
-- =========================================================


-- Activity must fall inside parent Outing dates.

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


-- Accommodation must fall inside parent Outing dates.

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


-- Outing duration must match TripType.

SELECT
    o.outing_name,
    DATEDIFF(o.end_date, o.start_date) + 1 AS outing_days,
    tt.min_days,
    tt.max_days
FROM Outing o
JOIN TripType tt
    ON tt.trip_type_id = o.trip_type_id
WHERE DATEDIFF(o.end_date, o.start_date) + 1
      NOT BETWEEN tt.min_days AND tt.max_days;


-- Every day must satisfy the TripType activity minimum
-- and maximum after the itinerary has been fully loaded.

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




-- =========================================================
-- PROGRAMMING PROJECT 2 REVISIONS
-- =========================================================
-- CSC6302 Database Principles
-- Programming Project 2
-- Holiday Planner database revisions
--
-- These revisions are incorporated into the final self-contained
-- HolidayPlanner_Project2_Revised.sql submission.

USE HolidayPlanner;


-- =========================================================
-- 1. SCHEMA REVISIONS
-- =========================================================

ALTER TABLE FamilyMember
    ADD COLUMN is_self BOOLEAN NOT NULL DEFAULT FALSE;

ALTER TABLE FamilyMember
    DROP CHECK chk_family_relationship;

ALTER TABLE FamilyMember
    ADD CONSTRAINT chk_family_relationship
    CHECK (
        relationship_to_household IN (
            'Parent',
            'Mother',
            'Father',
            'Child',
            'Guardian',
            'Grandparent',
            'Other'
        )
    );

UPDATE FamilyMember
SET relationship_to_household = 'Father',
    is_self = TRUE
WHERE first_name = 'Jordan'
  AND last_name = 'Hart'
  AND birth_date = '1988-04-12';

UPDATE FamilyMember
SET relationship_to_household = 'Mother'
WHERE first_name = 'Taylor'
  AND last_name = 'Hart'
  AND birth_date = '1990-09-21';


-- Preference belongs to the member-to-outing relationship because
-- different family members may prefer different outings.
ALTER TABLE OutingParticipant
    ADD COLUMN is_preferred BOOLEAN NOT NULL DEFAULT FALSE;


-- "Furthest away" is a property of a destination relative to home,
-- not a property of each individual travel leg. Storing the one-way
-- distance once on Location avoids duplicated, contradictory values.
ALTER TABLE Location
    ADD COLUMN distance_from_home_miles DECIMAL(8,1) NULL;


-- NULL/NULL means the activity is reasonable year-round.
ALTER TABLE Activity
    ADD COLUMN season_start_month TINYINT UNSIGNED NULL,
    ADD COLUMN season_end_month TINYINT UNSIGNED NULL,
    ADD CONSTRAINT chk_activity_season_months
        CHECK (
            (season_start_month IS NULL AND season_end_month IS NULL)
            OR
            (
                season_start_month BETWEEN 1 AND 12
                AND season_end_month BETWEEN 1 AND 12
            )
        );


-- =========================================================
-- 2. SEASONAL ACTIVITY DATA
-- =========================================================

UPDATE Activity SET season_start_month = 9,  season_end_month = 10
WHERE activity_name = 'Pumpkin Picking';

UPDATE Activity SET season_start_month = 8,  season_end_month = 10
WHERE activity_name = 'Apple Picking';

UPDATE Activity SET season_start_month = 9,  season_end_month = 11
WHERE activity_name = 'Corn Maze';

UPDATE Activity SET season_start_month = 9,  season_end_month = 11
WHERE activity_name = 'Haunted House';

UPDATE Activity SET season_start_month = 12, season_end_month = 3
WHERE activity_name = 'Skiing';

UPDATE Activity SET season_start_month = 12, season_end_month = 3
WHERE activity_name = 'Snowshoeing';

UPDATE Activity SET season_start_month = 4,  season_end_month = 11
WHERE activity_name = 'Hiking';

UPDATE Activity SET season_start_month = 5,  season_end_month = 9
WHERE activity_name = 'Kayaking';

UPDATE Activity SET season_start_month = 5,  season_end_month = 9
WHERE activity_name = 'Swimming';

UPDATE Activity SET season_start_month = 11, season_end_month = 3
WHERE activity_name = 'Ice Skating';

UPDATE Activity SET season_start_month = 11, season_end_month = 12
WHERE activity_name = 'Holiday Market';

-- Farm Market, Dinner, Hot Tub, Sightseeing, and Museum Visit
-- intentionally remain NULL/NULL to represent year-round suitability.


-- =========================================================
-- 3. NEW HOLIDAYS
-- =========================================================
-- Beach Holiday is an outing name, not a calendar holiday, so it is
-- intentionally NOT inserted into the Holiday lookup table.

INSERT INTO Holiday (holiday_name, description)
VALUES
('Fourth of July', 'Independence Day family holiday'),
('Thanksgiving', 'Thanksgiving family holiday'),
('Memorial Day', 'Memorial Day family holiday');


-- =========================================================
-- 4. NEW LOCATIONS
-- =========================================================

INSERT INTO Location (
    location_name,
    address_line1,
    city,
    state_province,
    postal_code,
    country,
    location_type
)
VALUES
(
    'Grafton Lakes State Park',
    '254 Grafton Lakes State Park Way',
    'Grafton',
    'New York',
    '12082',
    'United States',
    'Park'
),
(
    'Miami International Airport',
    '2100 NW 42nd Avenue',
    'Miami',
    'Florida',
    '33142',
    'United States',
    'Airport'
),
(
    'Miami Beach',
    NULL,
    'Miami Beach',
    'Florida',
    '33139',
    'United States',
    'City'
);


-- =========================================================
-- 5. DISTANCE FROM HOME
-- =========================================================
-- Approximate planning distances from Hart Home. Each value is stored
-- once on Location so every outing to the same destination uses the
-- same one-way distance.

SET @old_safe_updates = @@SQL_SAFE_UPDATES;
SET SQL_SAFE_UPDATES = 0;

UPDATE Location
SET distance_from_home_miles =
    CASE location_name
        WHEN 'Hart Home' THEN 0.0
        WHEN 'Sunny Acres Farm' THEN 15.0
        WHEN 'Hudson Valley Orchard' THEN 35.0
        WHEN 'Harvest Corn Maze' THEN 25.0
        WHEN 'Black Lantern Manor' THEN 10.0
        WHEN 'Harvest Bistro' THEN 10.0
        WHEN 'Albany International Airport' THEN 10.0
        WHEN 'Downtown Boston' THEN 170.0
        WHEN 'White Pine Mountain Resort' THEN 130.0
        WHEN 'Adirondack Lake Cabin Area' THEN 140.0
        WHEN 'Adirondack Trailhead' THEN 145.0
        WHEN 'Mirror Lake' THEN 145.0
        WHEN 'Lake Placid Village' THEN 145.0
        WHEN 'Chicago O Hare International Airport' THEN 840.0
        WHEN 'Downtown Chicago' THEN 840.0
        WHEN 'Millennium Park' THEN 840.0
        WHEN 'Museum Campus' THEN 840.0
        WHEN 'Chicago Holiday Market' THEN 840.0
        WHEN 'Grafton Lakes State Park' THEN 30.0
        WHEN 'Miami International Airport' THEN 1220.0
        WHEN 'Miami Beach' THEN 1220.0
        ELSE distance_from_home_miles
    END
WHERE location_id > 0;

SELECT COUNT(*) AS missing_location_distances
FROM Location
WHERE distance_from_home_miles IS NULL;

ALTER TABLE Location
    MODIFY distance_from_home_miles DECIMAL(8,1) NOT NULL,
    ADD CONSTRAINT chk_location_distance_from_home
        CHECK (distance_from_home_miles >= 0);

SET SQL_SAFE_UPDATES = @old_safe_updates;


-- =========================================================
-- 6. NEW ACCOMMODATION
-- =========================================================

INSERT INTO Accommodation (
    accommodation_name,
    location_id,
    accommodation_type,
    phone,
    website
)
VALUES
(
    'Miami Beach Family Hotel',
    (SELECT location_id
     FROM Location
     WHERE location_name = 'Miami Beach'),
    'Hotel',
    '305-555-0107',
    'https://example.com/miami-family'
);


-- =========================================================
-- 7. LOOKUP VARIABLES
-- =========================================================

SET @single_afternoon = (
    SELECT trip_type_id
    FROM TripType
    WHERE trip_type_name = 'Single Afternoon'
);

SET @weekend = (
    SELECT trip_type_id
    FROM TripType
    WHERE trip_type_name = 'Weekend'
);

SET @fourth = (
    SELECT holiday_id FROM Holiday
    WHERE holiday_name = 'Fourth of July'
);

SET @thanksgiving = (
    SELECT holiday_id FROM Holiday
    WHERE holiday_name = 'Thanksgiving'
);

SET @memorial = (
    SELECT holiday_id FROM Holiday
    WHERE holiday_name = 'Memorial Day'
);

SET @car = (
    SELECT travel_mode_id FROM TravelMode
    WHERE travel_mode_name = 'Car'
);

SET @plane = (
    SELECT travel_mode_id FROM TravelMode
    WHERE travel_mode_name = 'Plane'
);

SET @other = (
    SELECT travel_mode_id FROM TravelMode
    WHERE travel_mode_name = 'Other'
);


-- =========================================================
-- 8. NEW OUTINGS
-- =========================================================

INSERT INTO Outing (
    outing_name,
    trip_type_id,
    primary_location_id,
    holiday_id,
    start_date,
    end_date,
    description
)
VALUES
(
    'Miami Fourth of July Weekend',
    @weekend,
    (SELECT location_id FROM Location WHERE location_name = 'Miami Beach'),
    @fourth,
    '2027-07-03',
    '2027-07-05',
    'Three-day Fourth of July holiday requiring airplane travel'
),
(
    'Beach Holiday',
    @single_afternoon,
    (SELECT location_id FROM Location WHERE location_name = 'Grafton Lakes State Park'),
    NULL,
    '2027-06-19',
    '2027-06-19',
    'Single-afternoon beach outing at a nearby state park'
),
(
    'Boston Thanksgiving Weekend',
    @weekend,
    (SELECT location_id FROM Location WHERE location_name = 'Downtown Boston'),
    @thanksgiving,
    '2027-11-25',
    '2027-11-27',
    'Three-day Thanksgiving road trip to Boston'
),
(
    'Mountain Thanksgiving Weekend',
    @weekend,
    (SELECT location_id FROM Location WHERE location_name = 'White Pine Mountain Resort'),
    @thanksgiving,
    '2027-11-25',
    '2027-11-27',
    'Three-day Thanksgiving mountain trip'
),
(
    'Memorial Day Lake Placid Overnight',
    @weekend,
    (SELECT location_id FROM Location WHERE location_name = 'Lake Placid Village'),
    @memorial,
    '2027-05-30',
    '2027-05-31',
    'Overnight Memorial Day family trip'
);

SET @miami_fourth = (
    SELECT outing_id FROM Outing
    WHERE outing_name = 'Miami Fourth of July Weekend'
      AND start_date = '2027-07-03'
);

SET @beach = (
    SELECT outing_id FROM Outing
    WHERE outing_name = 'Beach Holiday'
      AND start_date = '2027-06-19'
);

SET @thanksgiving_boston = (
    SELECT outing_id FROM Outing
    WHERE outing_name = 'Boston Thanksgiving Weekend'
      AND start_date = '2027-11-25'
);

SET @thanksgiving_mountain = (
    SELECT outing_id FROM Outing
    WHERE outing_name = 'Mountain Thanksgiving Weekend'
      AND start_date = '2027-11-25'
);

SET @memorial_overnight = (
    SELECT outing_id FROM Outing
    WHERE outing_name = 'Memorial Day Lake Placid Overnight'
      AND start_date = '2027-05-30'
);


-- =========================================================
-- 9. PARTICIPANTS AND PREFERENCES
-- =========================================================

INSERT INTO OutingParticipant (
    outing_id,
    member_id,
    attendance_status,
    is_preferred
)
SELECT
    o.outing_id,
    fm.member_id,
    'Confirmed',
    FALSE
FROM Outing o
CROSS JOIN FamilyMember fm
WHERE o.outing_id IN (
    @miami_fourth,
    @beach,
    @thanksgiving_boston,
    @thanksgiving_mountain,
    @memorial_overnight
);

-- Mark multiple mother preferences, including a tied one-day minimum,
-- so the final query must correctly return every shortest tie.
UPDATE OutingParticipant op
JOIN FamilyMember fm
    ON fm.member_id = op.member_id
JOIN Outing o
    ON o.outing_id = op.outing_id
SET op.is_preferred = TRUE
WHERE fm.relationship_to_household = 'Mother'
  AND o.outing_name IN (
      'Fall Pumpkin Picking',
      'Halloween Adventure Day',
      'Boston Holiday Weekend',
      'Chicago Christmas Week'
  );


-- =========================================================
-- 10. ACTIVITIES FOR NEW OUTINGS
-- =========================================================

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
-- Fourth of July
(
    @miami_fourth, '2027-07-03', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Sightseeing'),
    (SELECT location_id FROM Location WHERE location_name = 'Miami Beach'),
    '16:00:00', 120, 'Arrival-day sightseeing'
),
(
    @miami_fourth, '2027-07-04', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Swimming'),
    (SELECT location_id FROM Location WHERE location_name = 'Miami Beach'),
    '11:00:00', 120, 'Fourth of July beach activity'
),
(
    @miami_fourth, '2027-07-05', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Sightseeing'),
    (SELECT location_id FROM Location WHERE location_name = 'Miami Beach'),
    '09:00:00', 90, 'Final morning before departure'
),

-- Nearby Single Afternoon Beach Holiday
(
    @beach, '2027-06-19', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Swimming'),
    (SELECT location_id FROM Location WHERE location_name = 'Grafton Lakes State Park'),
    '11:00:00', 120, 'Primary beach activity'
),
(
    @beach, '2027-06-19', 2,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Sightseeing'),
    (SELECT location_id FROM Location WHERE location_name = 'Grafton Lakes State Park'),
    '13:15:00', 60, 'Lake and park sightseeing'
),

-- Boston Thanksgiving
(
    @thanksgiving_boston, '2027-11-25', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Dinner'),
    (SELECT location_id FROM Location WHERE location_name = 'Downtown Boston'),
    '17:00:00', 120, 'Thanksgiving dinner'
),
(
    @thanksgiving_boston, '2027-11-26', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Sightseeing'),
    (SELECT location_id FROM Location WHERE location_name = 'Downtown Boston'),
    '10:00:00', 180, NULL
),
(
    @thanksgiving_boston, '2027-11-27', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Sightseeing'),
    (SELECT location_id FROM Location WHERE location_name = 'Downtown Boston'),
    '09:00:00', 120, 'Final morning'
),

-- Mountain Thanksgiving
(
    @thanksgiving_mountain, '2027-11-25', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Dinner'),
    (SELECT location_id FROM Location WHERE location_name = 'White Pine Mountain Resort'),
    '17:00:00', 120, 'Thanksgiving dinner'
),
(
    @thanksgiving_mountain, '2027-11-26', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Hiking'),
    (SELECT location_id FROM Location WHERE location_name = 'White Pine Mountain Resort'),
    '10:00:00', 180, NULL
),
(
    @thanksgiving_mountain, '2027-11-27', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Sightseeing'),
    (SELECT location_id FROM Location WHERE location_name = 'White Pine Mountain Resort'),
    '09:00:00', 120, 'Final morning'
),

-- Memorial Day overnight
(
    @memorial_overnight, '2027-05-30', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Sightseeing'),
    (SELECT location_id FROM Location WHERE location_name = 'Lake Placid Village'),
    '14:00:00', 150, 'Arrival-day village sightseeing'
),
(
    @memorial_overnight, '2027-05-31', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Hiking'),
    (SELECT location_id FROM Location WHERE location_name = 'Adirondack Trailhead'),
    '09:00:00', 180, 'Memorial Day morning hike'
);


-- =========================================================
-- 11. TRAVEL FOR NEW OUTINGS
-- =========================================================

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
-- Miami Fourth of July
(
    @miami_fourth, 1, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    (SELECT location_id FROM Location WHERE location_name = 'Albany International Airport'),
    '2027-07-03 06:30:00', 25, 6.00
),
(
    @miami_fourth, 2, @plane,
    (SELECT location_id FROM Location WHERE location_name = 'Albany International Airport'),
    (SELECT location_id FROM Location WHERE location_name = 'Miami International Airport'),
    '2027-07-03 09:00:00', 195, 1400.00
),
(
    @miami_fourth, 3, @other,
    (SELECT location_id FROM Location WHERE location_name = 'Miami International Airport'),
    (SELECT location_id FROM Location WHERE location_name = 'Miami Beach'),
    '2027-07-03 13:00:00', 35, 45.00
),
(
    @miami_fourth, 4, @other,
    (SELECT location_id FROM Location WHERE location_name = 'Miami Beach'),
    (SELECT location_id FROM Location WHERE location_name = 'Miami International Airport'),
    '2027-07-05 12:00:00', 35, 45.00
),
(
    @miami_fourth, 5, @plane,
    (SELECT location_id FROM Location WHERE location_name = 'Miami International Airport'),
    (SELECT location_id FROM Location WHERE location_name = 'Albany International Airport'),
    '2027-07-05 15:00:00', 195, 1400.00
),
(
    @miami_fourth, 6, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Albany International Airport'),
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    '2027-07-05 19:00:00', 25, 6.00
),

-- Nearby Beach Holiday
(
    @beach, 1, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    (SELECT location_id FROM Location WHERE location_name = 'Grafton Lakes State Park'),
    '2027-06-19 10:00:00', 35, 8.00
),
(
    @beach, 2, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Grafton Lakes State Park'),
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    '2027-06-19 15:30:00', 35, 8.00
),

-- Boston Thanksgiving
(
    @thanksgiving_boston, 1, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    (SELECT location_id FROM Location WHERE location_name = 'Downtown Boston'),
    '2027-11-25 08:00:00', 180, 55.00
),
(
    @thanksgiving_boston, 2, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Downtown Boston'),
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    '2027-11-27 14:00:00', 180, 55.00
),

-- Mountain Thanksgiving
(
    @thanksgiving_mountain, 1, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    (SELECT location_id FROM Location WHERE location_name = 'White Pine Mountain Resort'),
    '2027-11-25 08:00:00', 150, 35.00
),
(
    @thanksgiving_mountain, 2, @car,
    (SELECT location_id FROM Location WHERE location_name = 'White Pine Mountain Resort'),
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    '2027-11-27 14:00:00', 150, 35.00
),

-- Memorial Day overnight
(
    @memorial_overnight, 1, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    (SELECT location_id FROM Location WHERE location_name = 'Lake Placid Village'),
    '2027-05-30 09:00:00', 165, 40.00
),
(
    @memorial_overnight, 2, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Lake Placid Village'),
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    '2027-05-31 14:00:00', 165, 40.00
);


-- =========================================================
-- 12. ACCOMMODATION FOR NEW OVERNIGHT OUTINGS
-- =========================================================

INSERT INTO OutingAccommodation (
    outing_id,
    accommodation_id,
    check_in_date,
    check_out_date,
    nightly_rate_usd,
    booking_reference
)
VALUES
(
    @miami_fourth,
    (SELECT accommodation_id
     FROM Accommodation
     WHERE accommodation_name = 'Miami Beach Family Hotel'),
    '2027-07-03',
    '2027-07-05',
    320.00,
    'MIA-2027-004'
),
(
    @thanksgiving_boston,
    (SELECT accommodation_id
     FROM Accommodation
     WHERE accommodation_name = 'Boston Harbor Hotel'),
    '2027-11-25',
    '2027-11-27',
    280.00,
    'BOS-2027-THX'
),
(
    @thanksgiving_mountain,
    (SELECT accommodation_id
     FROM Accommodation
     WHERE accommodation_name = 'White Pine Mountain Lodge'),
    '2027-11-25',
    '2027-11-27',
    230.00,
    'MTN-2027-THX'
),
(
    @memorial_overnight,
    (SELECT accommodation_id
     FROM Accommodation
     WHERE accommodation_name = 'Lake Placid Inn'),
    '2027-05-30',
    '2027-05-31',
    225.00,
    'LP-2027-MEM'
);


-- =========================================================
-- 13. PACKING DATA NEEDED BY PROJECT 2
-- =========================================================

SET @riley = (
    SELECT member_id
    FROM FamilyMember
    WHERE first_name = 'Riley'
      AND last_name = 'Hart'
      AND birth_date = '2017-07-08'
);

SET @water = (
    SELECT item_id FROM PackingItem
    WHERE item_name = 'Water Bottle'
);

SET @snacks = (
    SELECT item_id FROM PackingItem
    WHERE item_name = 'Snacks'
);

SET @boots = (
    SELECT item_id FROM PackingItem
    WHERE item_name = 'Boots'
);

SET @sunscreen = (
    SELECT item_id FROM PackingItem
    WHERE item_name = 'Sunscreen'
);

-- Youngest family member reusable Single Afternoon packing.
INSERT INTO MemberTripPackingItem (
    member_id,
    trip_type_id,
    item_id,
    bag_type,
    quantity
)
VALUES
(@riley, @single_afternoon, @water, 'Personal Item', 1),
(@riley, @single_afternoon, @snacks, 'Personal Item', 2);

-- Apple-picking-specific packing requirements.
INSERT INTO ActivityPackingItem (
    activity_id,
    item_id,
    quantity,
    requirement_level
)
VALUES
(
    (SELECT activity_id FROM Activity WHERE activity_name = 'Apple Picking'),
    @boots,
    1,
    'Recommended'
),
(
    (SELECT activity_id FROM Activity WHERE activity_name = 'Apple Picking'),
    @sunscreen,
    1,
    'Recommended'
);


-- =========================================================
-- 14. FINAL REVISION CHECKS
-- =========================================================

SELECT COUNT(*) AS self_member_count
FROM FamilyMember
WHERE is_self = TRUE;

SELECT COUNT(*) AS mother_count
FROM FamilyMember
WHERE relationship_to_household = 'Mother';

SELECT COUNT(*) AS missing_location_distance_count
FROM Location
WHERE distance_from_home_miles IS NULL
   OR distance_from_home_miles < 0;

SELECT COUNT(*) AS new_holiday_count
FROM Holiday
WHERE holiday_name IN (
    'Fourth of July',
    'Thanksgiving',
    'Memorial Day'
);

SELECT COUNT(*) AS beach_holiday_lookup_rows
FROM Holiday
WHERE holiday_name = 'Beach Holiday';

SELECT COUNT(*) AS new_outing_count
FROM Outing
WHERE outing_name IN (
    'Miami Fourth of July Weekend',
    'Beach Holiday',
    'Boston Thanksgiving Weekend',
    'Mountain Thanksgiving Weekend',
    'Memorial Day Lake Placid Overnight'
);
