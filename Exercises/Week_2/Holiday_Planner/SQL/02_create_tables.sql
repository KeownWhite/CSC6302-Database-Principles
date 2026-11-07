-- CSC6302 Database Principles
-- Module 2 Practice
-- Holiday Planner Table Creation

USE HolidayPlanner;


-- =========================================================
-- 1. FamilyMember
-- =========================================================

CREATE TABLE IF NOT EXISTS FamilyMember (
    member_id INT UNSIGNED AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE NOT NULL,
    relationship_to_household VARCHAR(40) NOT NULL,

    CONSTRAINT pk_family_member
        PRIMARY KEY (member_id)
);


-- =========================================================
-- 2. TripType
-- =========================================================

CREATE TABLE IF NOT EXISTS TripType (
    trip_type_id SMALLINT UNSIGNED AUTO_INCREMENT,
    trip_type_name VARCHAR(50) NOT NULL,
    min_days TINYINT UNSIGNED NOT NULL,
    max_days TINYINT UNSIGNED NOT NULL,
    description VARCHAR(255),

    CONSTRAINT pk_trip_type
        PRIMARY KEY (trip_type_id),

    CONSTRAINT uq_trip_type_name
        UNIQUE (trip_type_name),

    CONSTRAINT chk_trip_type_min_days
        CHECK (min_days >= 1),

    CONSTRAINT chk_trip_type_day_range
        CHECK (max_days >= min_days)
);


-- =========================================================
-- 3. Location
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
        PRIMARY KEY (location_id)
);


-- =========================================================
-- 4. Activity
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

    CONSTRAINT chk_activity_duration
        CHECK (
            default_duration_minutes IS NULL
            OR default_duration_minutes > 0
        ),

    CONSTRAINT chk_activity_participants
        CHECK (min_participants > 0)
);


-- =========================================================
-- 5. TravelMode
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
-- 6. PackingItem
-- =========================================================

CREATE TABLE IF NOT EXISTS PackingItem (
    item_id INT UNSIGNED AUTO_INCREMENT,
    item_name VARCHAR(100) NOT NULL,
    item_category VARCHAR(50) NOT NULL,
    description VARCHAR(255),

    CONSTRAINT pk_packing_item
        PRIMARY KEY (item_id),

    CONSTRAINT uq_packing_item_name
        UNIQUE (item_name)
);


-- =========================================================
-- 7. Accommodation
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
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


-- =========================================================
-- 8. Outing
-- =========================================================

CREATE TABLE IF NOT EXISTS Outing (
    outing_id INT UNSIGNED AUTO_INCREMENT,
    outing_name VARCHAR(120) NOT NULL,
    trip_type_id SMALLINT UNSIGNED NOT NULL,
    primary_location_id INT UNSIGNED NOT NULL,
    holiday_name VARCHAR(80),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    description VARCHAR(255),

    CONSTRAINT pk_outing
        PRIMARY KEY (outing_id),

    CONSTRAINT fk_outing_trip_type
        FOREIGN KEY (trip_type_id)
        REFERENCES TripType(trip_type_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_outing_primary_location
        FOREIGN KEY (primary_location_id)
        REFERENCES Location(location_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_outing_dates
        CHECK (end_date >= start_date)
);


-- =========================================================
-- 9. OutingParticipant
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
-- 10. OutingActivity
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
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_oa_sequence
        CHECK (sequence_number > 0),

    CONSTRAINT chk_oa_duration
        CHECK (planned_duration_minutes > 0)
);


-- =========================================================
-- 11. TravelLeg
-- =========================================================

CREATE TABLE IF NOT EXISTS TravelLeg (
    travel_leg_id INT UNSIGNED AUTO_INCREMENT,
    outing_id INT UNSIGNED NOT NULL,
    sequence_number SMALLINT UNSIGNED NOT NULL,
    travel_mode_id SMALLINT UNSIGNED NOT NULL,
    from_location_id INT UNSIGNED NOT NULL,
    to_location_id INT UNSIGNED NOT NULL,
    departure_datetime DATETIME,
    planned_duration_minutes INT UNSIGNED NOT NULL,
    estimated_cost DECIMAL(10,2) NOT NULL,

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
        CHECK (estimated_cost >= 0),

    CONSTRAINT chk_tl_locations
        CHECK (from_location_id <> to_location_id)
);


-- =========================================================
-- 12. OutingAccommodation
-- =========================================================

CREATE TABLE IF NOT EXISTS OutingAccommodation (
    outing_id INT UNSIGNED NOT NULL,
    accommodation_id INT UNSIGNED NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    nightly_rate DECIMAL(10,2) NOT NULL,
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
        CHECK (nightly_rate >= 0)
);


-- =========================================================
-- 13. MemberTripPackingItem
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
-- 14. MemberTravelPackingItem
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
                'Suitcase'
            )
        ),

    CONSTRAINT chk_mvp_quantity
        CHECK (quantity > 0)
);


-- =========================================================
-- 15. ActivityPackingItem
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