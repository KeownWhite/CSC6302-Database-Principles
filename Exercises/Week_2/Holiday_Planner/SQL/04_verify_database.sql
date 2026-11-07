-- CSC6302 Database Principles
-- Module 2 Holiday Planner
-- Internal Implementation Verification
--
-- This script does not modify production/sample data.
-- Any violation query should return 0 rows or a count of 0.

USE HolidayPlanner;


-- =========================================================
-- 1. TABLE ROW COUNTS
-- Confirm every relation contains realistic sample data.
-- =========================================================

SELECT 'FamilyMember' AS table_name, COUNT(*) AS row_count FROM FamilyMember
UNION ALL
SELECT 'TripType', COUNT(*) FROM TripType
UNION ALL
SELECT 'Location', COUNT(*) FROM Location
UNION ALL
SELECT 'Outing', COUNT(*) FROM Outing
UNION ALL
SELECT 'OutingParticipant', COUNT(*) FROM OutingParticipant
UNION ALL
SELECT 'Activity', COUNT(*) FROM Activity
UNION ALL
SELECT 'OutingActivity', COUNT(*) FROM OutingActivity
UNION ALL
SELECT 'TravelMode', COUNT(*) FROM TravelMode
UNION ALL
SELECT 'TravelLeg', COUNT(*) FROM TravelLeg
UNION ALL
SELECT 'Accommodation', COUNT(*) FROM Accommodation
UNION ALL
SELECT 'OutingAccommodation', COUNT(*) FROM OutingAccommodation
UNION ALL
SELECT 'PackingItem', COUNT(*) FROM PackingItem
UNION ALL
SELECT 'MemberTripPackingItem', COUNT(*) FROM MemberTripPackingItem
UNION ALL
SELECT 'MemberTravelPackingItem', COUNT(*) FROM MemberTravelPackingItem
UNION ALL
SELECT 'ActivityPackingItem', COUNT(*) FROM ActivityPackingItem;


-- =========================================================
-- 2. STRUCTURAL METADATA
-- Expected:
-- table_count = 15
-- foreign_key_count = 22
-- =========================================================

SELECT COUNT(*) AS table_count
FROM information_schema.tables
WHERE table_schema = 'HolidayPlanner';

SELECT COUNT(*) AS foreign_key_count
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'HolidayPlanner'
  AND REFERENCED_TABLE_NAME IS NOT NULL;


-- =========================================================
-- 3. BUSINESS-RULE AUDIT
-- Every violation_count should equal 0.
-- =========================================================

SELECT 'Invalid Outing date range' AS audit,
       COUNT(*) AS violation_count
FROM Outing
WHERE end_date < start_date

UNION ALL

SELECT 'TripType duration mismatch',
       COUNT(*)
FROM Outing o
JOIN TripType t
  ON t.trip_type_id = o.trip_type_id
WHERE DATEDIFF(o.end_date, o.start_date) + 1
      NOT BETWEEN t.min_days AND t.max_days

UNION ALL

SELECT 'OutingActivity outside Outing dates',
       COUNT(*)
FROM OutingActivity oa
JOIN Outing o
  ON o.outing_id = oa.outing_id
WHERE oa.activity_date < o.start_date
   OR oa.activity_date > o.end_date

UNION ALL

SELECT 'Accommodation outside Outing dates',
       COUNT(*)
FROM OutingAccommodation x
JOIN Outing o
  ON o.outing_id = x.outing_id
WHERE x.check_in_date < o.start_date
   OR x.check_out_date > DATE_ADD(o.end_date, INTERVAL 1 DAY)

UNION ALL

SELECT 'Invalid Accommodation date range',
       COUNT(*)
FROM OutingAccommodation
WHERE check_out_date <= check_in_date

UNION ALL

SELECT 'Travel leg same origin and destination',
       COUNT(*)
FROM TravelLeg
WHERE from_location_id = to_location_id

UNION ALL

SELECT 'Invalid Travel duration',
       COUNT(*)
FROM TravelLeg
WHERE planned_duration_minutes <= 0

UNION ALL

SELECT 'Negative Travel cost',
       COUNT(*)
FROM TravelLeg
WHERE estimated_cost < 0

UNION ALL

SELECT 'Invalid Activity duration',
       COUNT(*)
FROM OutingActivity
WHERE planned_duration_minutes <= 0

UNION ALL

SELECT 'Invalid MemberTripPacking quantity',
       COUNT(*)
FROM MemberTripPackingItem
WHERE quantity <= 0

UNION ALL

SELECT 'Invalid MemberTravelPacking quantity',
       COUNT(*)
FROM MemberTravelPackingItem
WHERE quantity <= 0

UNION ALL

SELECT 'Invalid ActivityPacking quantity',
       COUNT(*)
FROM ActivityPackingItem
WHERE quantity <= 0;


-- =========================================================
-- 4. DOMAIN AUDIT
-- Every violation_count should equal 0.
-- =========================================================

SELECT 'Invalid attendance_status' AS audit,
       COUNT(*) AS violation_count
FROM OutingParticipant
WHERE attendance_status NOT IN (
    'Invited',
    'Confirmed',
    'Declined'
)

UNION ALL

SELECT 'Invalid MemberTripPacking bag_type',
       COUNT(*)
FROM MemberTripPackingItem
WHERE bag_type NOT IN (
    'Personal Item',
    'Suitcase'
)

UNION ALL

SELECT 'Invalid MemberTravelPacking bag_type',
       COUNT(*)
FROM MemberTravelPackingItem
WHERE bag_type NOT IN (
    'Personal Item',
    'Suitcase'
)

UNION ALL

SELECT 'Invalid ActivityPacking requirement_level',
       COUNT(*)
FROM ActivityPackingItem
WHERE requirement_level NOT IN (
    'Required',
    'Recommended'
);


-- =========================================================
-- 5. FOREIGN-KEY ORPHAN AUDIT
-- Every orphan_count should equal 0.
-- =========================================================

SELECT 'Accommodation -> Location' AS relationship,
       COUNT(*) AS orphan_count
FROM Accommodation c
LEFT JOIN Location p
  ON p.location_id = c.location_id
WHERE p.location_id IS NULL

UNION ALL

SELECT 'Outing -> TripType',
       COUNT(*)
FROM Outing c
LEFT JOIN TripType p
  ON p.trip_type_id = c.trip_type_id
WHERE p.trip_type_id IS NULL

UNION ALL

SELECT 'Outing -> Location',
       COUNT(*)
FROM Outing c
LEFT JOIN Location p
  ON p.location_id = c.primary_location_id
WHERE p.location_id IS NULL

UNION ALL

SELECT 'OutingParticipant -> Outing',
       COUNT(*)
FROM OutingParticipant c
LEFT JOIN Outing p
  ON p.outing_id = c.outing_id
WHERE p.outing_id IS NULL

UNION ALL

SELECT 'OutingParticipant -> FamilyMember',
       COUNT(*)
FROM OutingParticipant c
LEFT JOIN FamilyMember p
  ON p.member_id = c.member_id
WHERE p.member_id IS NULL

UNION ALL

SELECT 'OutingActivity -> Outing',
       COUNT(*)
FROM OutingActivity c
LEFT JOIN Outing p
  ON p.outing_id = c.outing_id
WHERE p.outing_id IS NULL

UNION ALL

SELECT 'OutingActivity -> Activity',
       COUNT(*)
FROM OutingActivity c
LEFT JOIN Activity p
  ON p.activity_id = c.activity_id
WHERE p.activity_id IS NULL

UNION ALL

SELECT 'OutingActivity -> Location',
       COUNT(*)
FROM OutingActivity c
LEFT JOIN Location p
  ON p.location_id = c.location_id
WHERE p.location_id IS NULL

UNION ALL

SELECT 'TravelLeg -> Outing',
       COUNT(*)
FROM TravelLeg c
LEFT JOIN Outing p
  ON p.outing_id = c.outing_id
WHERE p.outing_id IS NULL

UNION ALL

SELECT 'TravelLeg -> TravelMode',
       COUNT(*)
FROM TravelLeg c
LEFT JOIN TravelMode p
  ON p.travel_mode_id = c.travel_mode_id
WHERE p.travel_mode_id IS NULL

UNION ALL

SELECT 'TravelLeg -> From Location',
       COUNT(*)
FROM TravelLeg c
LEFT JOIN Location p
  ON p.location_id = c.from_location_id
WHERE p.location_id IS NULL

UNION ALL

SELECT 'TravelLeg -> To Location',
       COUNT(*)
FROM TravelLeg c
LEFT JOIN Location p
  ON p.location_id = c.to_location_id
WHERE p.location_id IS NULL

UNION ALL

SELECT 'OutingAccommodation -> Outing',
       COUNT(*)
FROM OutingAccommodation c
LEFT JOIN Outing p
  ON p.outing_id = c.outing_id
WHERE p.outing_id IS NULL

UNION ALL

SELECT 'OutingAccommodation -> Accommodation',
       COUNT(*)
FROM OutingAccommodation c
LEFT JOIN Accommodation p
  ON p.accommodation_id = c.accommodation_id
WHERE p.accommodation_id IS NULL

UNION ALL

SELECT 'MemberTripPackingItem -> FamilyMember',
       COUNT(*)
FROM MemberTripPackingItem c
LEFT JOIN FamilyMember p
  ON p.member_id = c.member_id
WHERE p.member_id IS NULL

UNION ALL

SELECT 'MemberTripPackingItem -> TripType',
       COUNT(*)
FROM MemberTripPackingItem c
LEFT JOIN TripType p
  ON p.trip_type_id = c.trip_type_id
WHERE p.trip_type_id IS NULL

UNION ALL

SELECT 'MemberTripPackingItem -> PackingItem',
       COUNT(*)
FROM MemberTripPackingItem c
LEFT JOIN PackingItem p
  ON p.item_id = c.item_id
WHERE p.item_id IS NULL

UNION ALL

SELECT 'MemberTravelPackingItem -> FamilyMember',
       COUNT(*)
FROM MemberTravelPackingItem c
LEFT JOIN FamilyMember p
  ON p.member_id = c.member_id
WHERE p.member_id IS NULL

UNION ALL

SELECT 'MemberTravelPackingItem -> TravelMode',
       COUNT(*)
FROM MemberTravelPackingItem c
LEFT JOIN TravelMode p
  ON p.travel_mode_id = c.travel_mode_id
WHERE p.travel_mode_id IS NULL

UNION ALL

SELECT 'MemberTravelPackingItem -> PackingItem',
       COUNT(*)
FROM MemberTravelPackingItem c
LEFT JOIN PackingItem p
  ON p.item_id = c.item_id
WHERE p.item_id IS NULL

UNION ALL

SELECT 'ActivityPackingItem -> Activity',
       COUNT(*)
FROM ActivityPackingItem c
LEFT JOIN Activity p
  ON p.activity_id = c.activity_id
WHERE p.activity_id IS NULL

UNION ALL

SELECT 'ActivityPackingItem -> PackingItem',
       COUNT(*)
FROM ActivityPackingItem c
LEFT JOIN PackingItem p
  ON p.item_id = c.item_id
WHERE p.item_id IS NULL;


-- =========================================================
-- 6. PARTICIPANT REQUIREMENT AUDIT
-- A scheduled activity should have enough confirmed
-- outing participants to meet Activity.min_participants.
-- Expected: 0 rows.
-- =========================================================

SELECT
    o.outing_name,
    a.activity_name,
    a.min_participants,
    COUNT(op.member_id) AS confirmed_participants
FROM OutingActivity oa
JOIN Outing o
  ON o.outing_id = oa.outing_id
JOIN Activity a
  ON a.activity_id = oa.activity_id
LEFT JOIN OutingParticipant op
  ON op.outing_id = oa.outing_id
 AND op.attendance_status = 'Confirmed'
GROUP BY
    oa.outing_id,
    oa.activity_date,
    oa.sequence_number,
    o.outing_name,
    a.activity_name,
    a.min_participants
HAVING COUNT(op.member_id) < a.min_participants;


-- =========================================================
-- 7. TRAVEL-SEQUENCE CONTINUITY
-- Every leg except the final leg should end where the
-- following leg begins.
-- Expected: 0 rows.
-- =========================================================

WITH TravelSequence AS (
    SELECT
        travel_leg_id,
        outing_id,
        sequence_number,
        from_location_id,
        to_location_id,
        LEAD(from_location_id) OVER (
            PARTITION BY outing_id
            ORDER BY sequence_number
        ) AS next_from_location_id
    FROM TravelLeg
)
SELECT *
FROM TravelSequence
WHERE next_from_location_id IS NOT NULL
  AND to_location_id <> next_from_location_id;


-- =========================================================
-- 8. TRAVEL-SEQUENCE NUMBER AUDIT
-- Sequence numbering should begin at 1 and contain no gaps.
-- Expected: 0 rows.
-- =========================================================

SELECT
    outing_id,
    MIN(sequence_number) AS minimum_sequence,
    MAX(sequence_number) AS maximum_sequence,
    COUNT(*) AS leg_count
FROM TravelLeg
GROUP BY outing_id
HAVING MIN(sequence_number) <> 1
    OR MAX(sequence_number) <> COUNT(*);


-- =========================================================
-- 9. IMPLEMENTATION VERIFICATION SUMMARY
-- These values should all be zero.
-- =========================================================

SELECT
    (
        SELECT COUNT(*)
        FROM OutingActivity oa
        JOIN Outing o
          ON o.outing_id = oa.outing_id
        WHERE oa.activity_date < o.start_date
           OR oa.activity_date > o.end_date
    ) AS invalid_activity_dates,

    (
        SELECT COUNT(*)
        FROM OutingAccommodation x
        JOIN Outing o
          ON o.outing_id = x.outing_id
        WHERE x.check_in_date < o.start_date
           OR x.check_out_date > DATE_ADD(o.end_date, INTERVAL 1 DAY)
    ) AS invalid_accommodation_dates,

    (
        SELECT COUNT(*)
        FROM Outing o
        JOIN TripType t
          ON t.trip_type_id = o.trip_type_id
        WHERE DATEDIFF(o.end_date, o.start_date) + 1
              NOT BETWEEN t.min_days AND t.max_days
    ) AS invalid_trip_type_durations,

    (
        SELECT COUNT(*)
        FROM TravelLeg
        WHERE from_location_id = to_location_id
    ) AS invalid_travel_locations;