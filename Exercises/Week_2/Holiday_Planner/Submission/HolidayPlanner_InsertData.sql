-- CSC6302 Database Principles
-- Module 2 Practice: Holiday Planner
-- Final corrected realistic sample data
--
-- Run after:
--   01_create_database.sql
--   02_create_tables.sql

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
-- Boston Logan removed because the Boston scenario is now
-- a road trip and no record references that airport.
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


-- Boston Logan should not remain as unused data.

SELECT *
FROM Location
WHERE location_name = 'Boston Logan International Airport';