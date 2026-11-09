-- CSC6302 Database Principles
-- Programming Project 2
-- Holiday Planner revisions required by Project 2 queries
--
-- Run AFTER the final Module 2 HolidayPlanner create and insert scripts.

USE HolidayPlanner;

-- =========================================================
-- 1. SCHEMA REVISIONS
-- =========================================================

-- Identify the family member representing "you" for personal packing queries.
ALTER TABLE FamilyMember
    ADD COLUMN is_self BOOLEAN NOT NULL DEFAULT FALSE;

-- The original Module 2 design used a generic Parent value.
-- Project 2 specifically asks for the mother, so preserve the general
-- categories while allowing Mother and Father to be represented explicitly.
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


-- Store an individual family member's outing preference on the
-- member-to-outing relationship rather than on Outing itself.
ALTER TABLE OutingParticipant
    ADD COLUMN is_preferred BOOLEAN NOT NULL DEFAULT FALSE;


-- Store estimated distance on each travel leg so "furthest away"
-- can be answered using the complete itinerary.
ALTER TABLE TravelLeg
    ADD COLUMN estimated_distance_miles DECIMAL(8,1) NULL;


-- Store the normal useful season for an activity.
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
-- 2. EASTER EGG
-- =========================================================
-- Stored as schema metadata so it does not interfere with any project query.
ALTER TABLE FamilyMember
COMMENT =
'Keown White Easter Egg | My first console was bought with money from my dad''s contracting breakthrough. Whether I had permission to use that money is outside the scope of this query.';


-- =========================================================
-- 3. SEASONAL ACTIVITY DATA
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
-- 4. DISTANCES FOR EXISTING TRAVEL LEGS
-- =========================================================
-- Approximate planning distances. These values are sample planning data,
-- not route-navigation measurements.

SET @old_safe_updates = @@SQL_SAFE_UPDATES;
SET SQL_SAFE_UPDATES = 0;

UPDATE TravelLeg tl
JOIN Outing o ON o.outing_id = tl.outing_id
SET tl.estimated_distance_miles =
    CASE
        WHEN o.outing_name = 'Fall Pumpkin Picking' AND tl.sequence_number IN (1, 2)
            THEN 15.0

        WHEN o.outing_name = 'Halloween Adventure Day' AND tl.sequence_number = 1
            THEN 35.0
        WHEN o.outing_name = 'Halloween Adventure Day' AND tl.sequence_number = 2
            THEN 15.0
        WHEN o.outing_name = 'Halloween Adventure Day' AND tl.sequence_number = 3
            THEN 25.0
        WHEN o.outing_name = 'Halloween Adventure Day' AND tl.sequence_number = 4
            THEN 5.0
        WHEN o.outing_name = 'Halloween Adventure Day' AND tl.sequence_number = 5
            THEN 10.0

        WHEN o.outing_name = 'Winter Mountain Weekend' AND tl.sequence_number IN (1, 2)
            THEN 130.0

        WHEN o.outing_name = 'Boston Holiday Weekend' AND tl.sequence_number IN (1, 2)
            THEN 170.0

        WHEN o.outing_name = 'Adirondack Summer Week' AND tl.sequence_number = 1
            THEN 140.0
        WHEN o.outing_name = 'Adirondack Summer Week' AND tl.sequence_number = 2
            THEN 10.0
        WHEN o.outing_name = 'Adirondack Summer Week' AND tl.sequence_number = 3
            THEN 145.0

        WHEN o.outing_name = 'Chicago Christmas Week' AND tl.sequence_number IN (1, 6)
            THEN 10.0
        WHEN o.outing_name = 'Chicago Christmas Week' AND tl.sequence_number IN (2, 5)
            THEN 840.0
        WHEN o.outing_name = 'Chicago Christmas Week' AND tl.sequence_number IN (3, 4)
            THEN 18.0

        ELSE tl.estimated_distance_miles
    END
WHERE o.outing_name IN (
    'Fall Pumpkin Picking',
    'Halloween Adventure Day',
    'Winter Mountain Weekend',
    'Boston Holiday Weekend',
    'Adirondack Summer Week',
    'Chicago Christmas Week'
);

-- Make sure every existing leg received a value before enforcing NOT NULL.
SELECT COUNT(*) AS missing_existing_distances
FROM TravelLeg
WHERE estimated_distance_miles IS NULL;

ALTER TABLE TravelLeg
    MODIFY estimated_distance_miles DECIMAL(8,1) NOT NULL,
    ADD CONSTRAINT chk_tl_distance
        CHECK (estimated_distance_miles > 0);

SET SQL_SAFE_UPDATES = @old_safe_updates;


-- =========================================================
-- 5. NEW HOLIDAYS
-- =========================================================

INSERT INTO Holiday (holiday_name, description)
VALUES
('Fourth of July', 'Independence Day family holiday'),
('Beach Holiday', 'Single-day summer beach outing'),
('Thanksgiving', 'Thanksgiving family holiday'),
('Memorial Day', 'Memorial Day family holiday');


-- =========================================================
-- 6. NEW LOCATIONS
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
    'Jones Beach State Park',
    '1 Ocean Parkway',
    'Wantagh',
    'New York',
    '11793',
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
-- 7. NEW ACCOMMODATION
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
-- 8. LOOKUP VARIABLES
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

SET @beach_holiday = (
    SELECT holiday_id FROM Holiday
    WHERE holiday_name = 'Beach Holiday'
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
-- 9. NEW OUTINGS
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
    (SELECT location_id FROM Location WHERE location_name = 'Jones Beach State Park'),
    @beach_holiday,
    '2027-06-19',
    '2027-06-19',
    'Single-day summer beach outing'
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
-- 10. PARTICIPANTS AND PREFERENCES
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

-- Taylor is the sample-data mother. Mark several preferences so the
-- shortest-preferred-outing query has a meaningful choice to make.
UPDATE OutingParticipant op
JOIN FamilyMember fm
    ON fm.member_id = op.member_id
JOIN Outing o
    ON o.outing_id = op.outing_id
SET op.is_preferred = TRUE
WHERE fm.relationship_to_household = 'Mother'
  AND o.outing_name IN (
      'Fall Pumpkin Picking',
      'Boston Holiday Weekend',
      'Chicago Christmas Week'
  );


-- =========================================================
-- 11. ACTIVITIES FOR NEW OUTINGS
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
-- Fourth of July: one activity each day
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

-- Single-day Beach Holiday
(
    @beach, '2027-06-19', 1,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Swimming'),
    (SELECT location_id FROM Location WHERE location_name = 'Jones Beach State Park'),
    '11:00:00', 120, 'Primary beach activity'
),
(
    @beach, '2027-06-19', 2,
    (SELECT activity_id FROM Activity WHERE activity_name = 'Sightseeing'),
    (SELECT location_id FROM Location WHERE location_name = 'Jones Beach State Park'),
    '14:00:00', 90, 'Boardwalk and shoreline sightseeing'
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
-- 12. TRAVEL FOR NEW OUTINGS
-- =========================================================

INSERT INTO TravelLeg (
    outing_id,
    sequence_number,
    travel_mode_id,
    from_location_id,
    to_location_id,
    departure_datetime,
    planned_duration_minutes,
    estimated_cost_total_usd,
    estimated_distance_miles
)
VALUES
-- Miami Fourth of July
(
    @miami_fourth, 1, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    (SELECT location_id FROM Location WHERE location_name = 'Albany International Airport'),
    '2027-07-03 06:30:00', 25, 6.00, 10.0
),
(
    @miami_fourth, 2, @plane,
    (SELECT location_id FROM Location WHERE location_name = 'Albany International Airport'),
    (SELECT location_id FROM Location WHERE location_name = 'Miami International Airport'),
    '2027-07-03 09:00:00', 195, 1400.00, 1220.0
),
(
    @miami_fourth, 3, @other,
    (SELECT location_id FROM Location WHERE location_name = 'Miami International Airport'),
    (SELECT location_id FROM Location WHERE location_name = 'Miami Beach'),
    '2027-07-03 13:00:00', 35, 45.00, 12.0
),
(
    @miami_fourth, 4, @other,
    (SELECT location_id FROM Location WHERE location_name = 'Miami Beach'),
    (SELECT location_id FROM Location WHERE location_name = 'Miami International Airport'),
    '2027-07-05 12:00:00', 35, 45.00, 12.0
),
(
    @miami_fourth, 5, @plane,
    (SELECT location_id FROM Location WHERE location_name = 'Miami International Airport'),
    (SELECT location_id FROM Location WHERE location_name = 'Albany International Airport'),
    '2027-07-05 15:00:00', 195, 1400.00, 1220.0
),
(
    @miami_fourth, 6, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Albany International Airport'),
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    '2027-07-05 19:00:00', 25, 6.00, 10.0
),

-- Beach Holiday
(
    @beach, 1, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    (SELECT location_id FROM Location WHERE location_name = 'Jones Beach State Park'),
    '2027-06-19 07:00:00', 180, 45.00, 165.0
),
(
    @beach, 2, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Jones Beach State Park'),
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    '2027-06-19 17:00:00', 180, 45.00, 165.0
),

-- Boston Thanksgiving
(
    @thanksgiving_boston, 1, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    (SELECT location_id FROM Location WHERE location_name = 'Downtown Boston'),
    '2027-11-25 08:00:00', 180, 55.00, 170.0
),
(
    @thanksgiving_boston, 2, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Downtown Boston'),
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    '2027-11-27 14:00:00', 180, 55.00, 170.0
),

-- Mountain Thanksgiving
(
    @thanksgiving_mountain, 1, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    (SELECT location_id FROM Location WHERE location_name = 'White Pine Mountain Resort'),
    '2027-11-25 08:00:00', 150, 35.00, 130.0
),
(
    @thanksgiving_mountain, 2, @car,
    (SELECT location_id FROM Location WHERE location_name = 'White Pine Mountain Resort'),
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    '2027-11-27 14:00:00', 150, 35.00, 130.0
),

-- Memorial Day overnight
(
    @memorial_overnight, 1, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    (SELECT location_id FROM Location WHERE location_name = 'Lake Placid Village'),
    '2027-05-30 09:00:00', 165, 40.00, 140.0
),
(
    @memorial_overnight, 2, @car,
    (SELECT location_id FROM Location WHERE location_name = 'Lake Placid Village'),
    (SELECT location_id FROM Location WHERE location_name = 'Hart Home'),
    '2027-05-31 14:00:00', 165, 40.00, 140.0
);


-- =========================================================
-- 13. ACCOMMODATION FOR NEW OVERNIGHT OUTINGS
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
-- 14. PACKING DATA NEEDED BY PROJECT 2
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

-- Youngest family member now has a reusable Single Afternoon packing list.
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
-- 15. FINAL REVISION CHECKS
-- =========================================================

SELECT COUNT(*) AS self_member_count
FROM FamilyMember
WHERE is_self = TRUE;

SELECT COUNT(*) AS mother_count
FROM FamilyMember
WHERE relationship_to_household = 'Mother';

SELECT COUNT(*) AS missing_distance_count
FROM TravelLeg
WHERE estimated_distance_miles IS NULL
   OR estimated_distance_miles <= 0;

SELECT COUNT(*) AS new_holiday_count
FROM Holiday
WHERE holiday_name IN (
    'Fourth of July',
    'Beach Holiday',
    'Thanksgiving',
    'Memorial Day'
);

SELECT COUNT(*) AS new_outing_count
FROM Outing
WHERE outing_name IN (
    'Miami Fourth of July Weekend',
    'Beach Holiday',
    'Boston Thanksgiving Weekend',
    'Mountain Thanksgiving Weekend',
    'Memorial Day Lake Placid Overnight'
);
