-- CSC6302 Database Principles
-- Module 2 Holiday Planner
-- Regrade Adversarial Constraint Tests
--
-- These tests intentionally attempt invalid inserts.
-- PASS means the database rejected the invalid operation.

USE HolidayPlanner;

DROP PROCEDURE IF EXISTS run_regrade_tests;

DELIMITER $$

CREATE PROCEDURE run_regrade_tests()
BEGIN

    DECLARE v_error INT DEFAULT 0;

    DECLARE v_weekend SMALLINT UNSIGNED;
    DECLARE v_single SMALLINT UNSIGNED;
    DECLARE v_home INT UNSIGNED;
    DECLARE v_jordan INT UNSIGNED;
    DECLARE v_car SMALLINT UNSIGNED;
    DECLARE v_toothbrush INT UNSIGNED;
    DECLARE v_goggles INT UNSIGNED;
    DECLARE v_phone INT UNSIGNED;


    SELECT trip_type_id
    INTO v_weekend
    FROM TripType
    WHERE trip_type_name = 'Weekend';


    SELECT trip_type_id
    INTO v_single
    FROM TripType
    WHERE trip_type_name = 'Single Afternoon';


    SELECT location_id
    INTO v_home
    FROM Location
    WHERE location_name = 'Hart Home';


    SELECT member_id
    INTO v_jordan
    FROM FamilyMember
    WHERE first_name = 'Jordan'
      AND last_name = 'Hart'
      AND birth_date = '1988-04-12';


    SELECT travel_mode_id
    INTO v_car
    FROM TravelMode
    WHERE travel_mode_name = 'Car';


    SELECT item_id
    INTO v_toothbrush
    FROM PackingItem
    WHERE item_name = 'Toothbrush';


    SELECT item_id
    INTO v_goggles
    FROM PackingItem
    WHERE item_name = 'Ski Goggles';


    SELECT item_id
    INTO v_phone
    FROM PackingItem
    WHERE item_name = 'Phone';


    -- =====================================================
    -- TEST 1
    -- 9-day Weekend must be rejected.
    -- =====================================================

    SET v_error = 0;

    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
            SET v_error = 1;

        INSERT INTO Outing (
            outing_name,
            trip_type_id,
            primary_location_id,
            holiday_id,
            start_date,
            end_date,
            description
        )
        VALUES (
            'TEST Invalid Weekend',
            v_weekend,
            v_home,
            NULL,
            '2027-08-01',
            '2027-08-09',
            'This row should never be accepted'
        );
    END;

    SELECT
        '9-day Weekend rejected' AS test_name,
        IF(v_error = 1, 'PASS', 'FAIL') AS result;

    DELETE FROM Outing
    WHERE outing_name = 'TEST Invalid Weekend'
      AND start_date = '2027-08-01';


    -- =====================================================
    -- TEST 2
    -- Suitcase on Single Afternoon must be rejected.
    -- =====================================================

    SET v_error = 0;

    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
            SET v_error = 1;

        INSERT INTO MemberTripPackingItem (
            member_id,
            trip_type_id,
            item_id,
            bag_type,
            quantity
        )
        VALUES (
            v_jordan,
            v_single,
            v_toothbrush,
            'Suitcase',
            1
        );
    END;

    SELECT
        'Suitcase on Single Afternoon rejected' AS test_name,
        IF(v_error = 1, 'PASS', 'FAIL') AS result;

    DELETE FROM MemberTripPackingItem
    WHERE member_id = v_jordan
      AND trip_type_id = v_single
      AND item_id = v_toothbrush;


    -- =====================================================
    -- TEST 3
    -- Duplicate location_name must be rejected.
    -- =====================================================

    SET v_error = 0;

    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
            SET v_error = 1;

        INSERT INTO Location (
            location_name,
            address_line1,
            city,
            state_province,
            postal_code,
            country,
            location_type
        )
        VALUES (
            'Hart Home',
            '999 Duplicate Road',
            'Albany',
            'New York',
            '12203',
            'United States',
            'Home'
        );
    END;

    SELECT
        'Duplicate Location rejected' AS test_name,
        IF(v_error = 1, 'PASS', 'FAIL') AS result;


    -- =====================================================
    -- TEST 4
    -- Duplicate family identity must be rejected.
    -- =====================================================

    SET v_error = 0;

    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
            SET v_error = 1;

        INSERT INTO FamilyMember (
            first_name,
            middle_name,
            last_name,
            birth_date,
            relationship_to_household
        )
        VALUES (
            'Jordan',
            'Duplicate',
            'Hart',
            '1988-04-12',
            'Parent'
        );
    END;

    SELECT
        'Duplicate FamilyMember rejected' AS test_name,
        IF(v_error = 1, 'PASS', 'FAIL') AS result;


    -- =====================================================
    -- TEST 5
    -- Duplicate outing name + start date must be rejected.
    -- =====================================================

    SET v_error = 0;

    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
            SET v_error = 1;

        INSERT INTO Outing (
            outing_name,
            trip_type_id,
            primary_location_id,
            holiday_id,
            start_date,
            end_date,
            description
        )
        SELECT
            outing_name,
            trip_type_id,
            primary_location_id,
            holiday_id,
            start_date,
            end_date,
            'Duplicate test'
        FROM Outing
        WHERE outing_name = 'Fall Pumpkin Picking'
          AND start_date = '2026-10-10';
    END;

    SELECT
        'Duplicate Outing rejected' AS test_name,
        IF(v_error = 1, 'PASS', 'FAIL') AS result;


    -- =====================================================
    -- TEST 6
    -- Invalid category must be rejected.
    -- =====================================================

    SET v_error = 0;

    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
            SET v_error = 1;

        INSERT INTO Location (
            location_name,
            address_line1,
            city,
            state_province,
            postal_code,
            country,
            location_type
        )
        VALUES (
            'TEST Invalid Location Type',
            NULL,
            'Albany',
            'New York',
            '12203',
            'United States',
            'Spaceship'
        );
    END;

    SELECT
        'Invalid Location category rejected' AS test_name,
        IF(v_error = 1, 'PASS', 'FAIL') AS result;

    DELETE FROM Location
    WHERE location_name = 'TEST Invalid Location Type';


    -- =====================================================
    -- TEST 7
    -- Travel packing must not use Suitcase.
    -- =====================================================

    SET v_error = 0;

    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
            SET v_error = 1;

        INSERT INTO MemberTravelPackingItem (
            member_id,
            travel_mode_id,
            item_id,
            bag_type,
            quantity
        )
        VALUES (
            v_jordan,
            v_car,
            v_goggles,
            'Suitcase',
            1
        );
    END;

    SELECT
        'Travel Suitcase rejected' AS test_name,
        IF(v_error = 1, 'PASS', 'FAIL') AS result;

    DELETE FROM MemberTravelPackingItem
    WHERE member_id = v_jordan
      AND travel_mode_id = v_car
      AND item_id = v_goggles;


    -- =====================================================
    -- TEST 8
    -- Same member/item cannot conflict across bag rules.
    --
    -- Jordan already has Phone as Personal Item in
    -- MemberTripPackingItem. Trying Vehicle must fail.
    -- =====================================================

    SET v_error = 0;

    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
            SET v_error = 1;

        INSERT INTO MemberTravelPackingItem (
            member_id,
            travel_mode_id,
            item_id,
            bag_type,
            quantity
        )
        VALUES (
            v_jordan,
            v_car,
            v_phone,
            'Vehicle',
            1
        );
    END;

    SELECT
        'Cross-table bag conflict rejected' AS test_name,
        IF(v_error = 1, 'PASS', 'FAIL') AS result;

    DELETE FROM MemberTravelPackingItem
    WHERE member_id = v_jordan
      AND travel_mode_id = v_car
      AND item_id = v_phone;

END$$

DELIMITER ;

CALL run_regrade_tests();

DROP PROCEDURE run_regrade_tests;