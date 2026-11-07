-- CSC6302 Database Principles
-- Module 2 Practice: Holiday Planner
-- Corrected table, constraint, relationship, and trigger definitions
--
-- Run after 01_create_database.sql.

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
                'Child'
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
-- Controlled holiday vocabulary instead of free text.
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
                'Cabin'
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
-- Delete policy:
-- Historical outing participation is preserved with RESTRICT
-- when deleting a FamilyMember.
--
-- Packing rules later use CASCADE because those rows are
-- preferences owned by the member rather than trip history.
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
-- estimated_cost_total_usd is the total estimated cost
-- associated with the entire family travel leg.
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
-- nightly_rate_usd explicitly identifies the currency.
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
--
-- TripType packing may use Personal Item or Suitcase.
-- Suitcase eligibility is additionally enforced by trigger.
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
--
-- Travel-mode-specific rules may use Personal Item or
-- Vehicle. Travel rules never assign items to Suitcase.
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
-- TRIGGER 1-2
-- Enforce Outing duration against the selected TripType.
-- =========================================================

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


-- =========================================================
-- TRIGGER 3-4
-- Enforce suitcase eligibility and cross-table bag rules.
-- =========================================================

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


-- =========================================================
-- TRIGGER 5-6
-- Enforce cross-table bag consistency from travel rules.
-- =========================================================

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