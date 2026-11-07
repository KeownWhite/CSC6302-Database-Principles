-- CSC6302 Database Principles
-- Module 2 Holiday Planner
-- Internal Query-Plan and Index Verification

USE HolidayPlanner;


-- =========================================================
-- 1. CURRENT INDEX INVENTORY
-- =========================================================

SELECT
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME,
    SEQ_IN_INDEX,
    NON_UNIQUE
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'HolidayPlanner'
ORDER BY TABLE_NAME, INDEX_NAME, SEQ_IN_INDEX;


-- =========================================================
-- 2. ITINERARY QUERY
-- Tests Outing -> OutingActivity -> Activity -> Location
-- =========================================================

EXPLAIN ANALYZE
SELECT
    o.outing_name,
    oa.activity_date,
    oa.sequence_number,
    a.activity_name,
    l.location_name,
    oa.start_time,
    oa.planned_duration_minutes
FROM Outing o
JOIN OutingActivity oa
    ON oa.outing_id = o.outing_id
JOIN Activity a
    ON a.activity_id = oa.activity_id
JOIN Location l
    ON l.location_id = oa.location_id
WHERE o.outing_name = 'Chicago Christmas Week'
ORDER BY
    oa.activity_date,
    oa.sequence_number;


-- =========================================================
-- 3. TRAVEL PLAN QUERY
-- Tests Outing -> TravelLeg -> TravelMode -> Location
-- =========================================================

EXPLAIN ANALYZE
SELECT
    o.outing_name,
    tl.sequence_number,
    tm.travel_mode_name,
    origin.location_name AS origin,
    destination.location_name AS destination,
    tl.departure_datetime,
    tl.planned_duration_minutes,
    tl.estimated_cost
FROM Outing o
JOIN TravelLeg tl
    ON tl.outing_id = o.outing_id
JOIN TravelMode tm
    ON tm.travel_mode_id = tl.travel_mode_id
JOIN Location origin
    ON origin.location_id = tl.from_location_id
JOIN Location destination
    ON destination.location_id = tl.to_location_id
WHERE o.outing_name = 'Boston Holiday Weekend'
ORDER BY tl.sequence_number;


-- =========================================================
-- 4. ACCOMMODATION QUERY
-- =========================================================

EXPLAIN ANALYZE
SELECT
    o.outing_name,
    a.accommodation_name,
    oa.check_in_date,
    oa.check_out_date,
    oa.nightly_rate
FROM Outing o
JOIN OutingAccommodation oa
    ON oa.outing_id = o.outing_id
JOIN Accommodation a
    ON a.accommodation_id = oa.accommodation_id
WHERE o.outing_name = 'Adirondack Summer Week'
ORDER BY oa.check_in_date;


-- =========================================================
-- 5. TRIP-TYPE PACKING QUERY
-- =========================================================

EXPLAIN ANALYZE
SELECT
    fm.first_name,
    tt.trip_type_name,
    pi.item_name,
    mtpi.bag_type,
    mtpi.quantity
FROM MemberTripPackingItem mtpi
JOIN FamilyMember fm
    ON fm.member_id = mtpi.member_id
JOIN TripType tt
    ON tt.trip_type_id = mtpi.trip_type_id
JOIN PackingItem pi
    ON pi.item_id = mtpi.item_id
WHERE fm.first_name = 'Jordan'
  AND fm.last_name = 'Hart'
  AND tt.trip_type_name = 'Week Long'
ORDER BY mtpi.bag_type, pi.item_name;


-- =========================================================
-- 6. TRAVEL-MODE PACKING QUERY
-- =========================================================

EXPLAIN ANALYZE
SELECT
    fm.first_name,
    tm.travel_mode_name,
    pi.item_name,
    mtpi.bag_type,
    mtpi.quantity
FROM MemberTravelPackingItem mtpi
JOIN FamilyMember fm
    ON fm.member_id = mtpi.member_id
JOIN TravelMode tm
    ON tm.travel_mode_id = mtpi.travel_mode_id
JOIN PackingItem pi
    ON pi.item_id = mtpi.item_id
WHERE fm.first_name = 'Jordan'
  AND fm.last_name = 'Hart'
  AND tm.travel_mode_name = 'Plane'
ORDER BY pi.item_name;


-- =========================================================
-- 7. ACTIVITY PACKING QUERY
-- =========================================================

EXPLAIN ANALYZE
SELECT
    a.activity_name,
    pi.item_name,
    api.quantity,
    api.requirement_level
FROM ActivityPackingItem api
JOIN Activity a
    ON a.activity_id = api.activity_id
JOIN PackingItem pi
    ON pi.item_id = api.item_id
WHERE a.activity_name = 'Skiing'
ORDER BY api.requirement_level, pi.item_name;


-- =========================================================
-- 8. FOREIGN-KEY INDEX REVIEW
-- MySQL creates/uses supporting indexes for FK relationships.
-- =========================================================

SELECT
    TABLE_NAME,
    INDEX_NAME,
    GROUP_CONCAT(
        COLUMN_NAME
        ORDER BY SEQ_IN_INDEX
        SEPARATOR ', '
    ) AS indexed_columns
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'HolidayPlanner'
GROUP BY TABLE_NAME, INDEX_NAME
ORDER BY TABLE_NAME, INDEX_NAME;