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
