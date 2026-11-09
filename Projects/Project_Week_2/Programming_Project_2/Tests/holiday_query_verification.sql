-- CSC6302 Database Principles
-- Programming Project 2
-- Holiday Planner verification
--
-- Every section should return the expected value/result before submission.

USE HolidayPlanner;


-- =========================================================
-- 1. STRUCTURE
-- =========================================================

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'HolidayPlanner'
  AND (
      (TABLE_NAME = 'FamilyMember' AND COLUMN_NAME = 'is_self')
      OR
      (TABLE_NAME = 'OutingParticipant' AND COLUMN_NAME = 'is_preferred')
      OR
      (TABLE_NAME = 'TravelLeg' AND COLUMN_NAME = 'estimated_distance_miles')
      OR
      (TABLE_NAME = 'Activity' AND COLUMN_NAME IN (
          'season_start_month',
          'season_end_month'
      ))
  )
ORDER BY TABLE_NAME, ORDINAL_POSITION;


-- =========================================================
-- 2. CORE REVISION CHECKS
-- Expected: 1, 1, 0, 4, 5
-- =========================================================

SELECT COUNT(*) AS self_member_count
FROM FamilyMember
WHERE is_self = TRUE;

SELECT COUNT(*) AS mother_count
FROM FamilyMember
WHERE relationship_to_household = 'Mother';

SELECT COUNT(*) AS invalid_distance_count
FROM TravelLeg
WHERE estimated_distance_miles <= 0;

SELECT COUNT(*) AS project2_holiday_count
FROM Holiday
WHERE holiday_name IN (
    'Fourth of July',
    'Beach Holiday',
    'Thanksgiving',
    'Memorial Day'
);

SELECT COUNT(*) AS project2_outing_count
FROM Outing
WHERE outing_name IN (
    'Miami Fourth of July Weekend',
    'Beach Holiday',
    'Boston Thanksgiving Weekend',
    'Mountain Thanksgiving Weekend',
    'Memorial Day Lake Placid Overnight'
);


-- =========================================================
-- 3. QUERY-SPECIFIC DATA CHECKS
-- =========================================================

-- Christmas overnight outings: expected at least 2.
SELECT COUNT(*) AS overnight_christmas_outings
FROM Outing o
JOIN Holiday h ON h.holiday_id = o.holiday_id
WHERE h.holiday_name = 'Christmas'
  AND o.end_date > o.start_date;

-- Halloween outings: expected 1.
SELECT COUNT(*) AS halloween_outings
FROM Outing o
JOIN Holiday h ON h.holiday_id = o.holiday_id
WHERE h.holiday_name = 'Halloween';

-- Fourth of July trips with at least one Plane leg: expected 1.
SELECT COUNT(DISTINCT o.outing_id) AS flyable_fourth_of_july_outings
FROM Outing o
JOIN Holiday h ON h.holiday_id = o.holiday_id
JOIN TravelLeg tl ON tl.outing_id = o.outing_id
JOIN TravelMode tm ON tm.travel_mode_id = tl.travel_mode_id
WHERE h.holiday_name = 'Fourth of July'
  AND tm.travel_mode_name = 'Plane';

-- Youngest member Single Afternoon packing: expected at least 2.
SELECT COUNT(*) AS youngest_single_afternoon_items
FROM MemberTripPackingItem mtpi
JOIN FamilyMember fm ON fm.member_id = mtpi.member_id
JOIN TripType tt ON tt.trip_type_id = mtpi.trip_type_id
WHERE fm.birth_date = (SELECT MAX(birth_date) FROM FamilyMember)
  AND tt.trip_type_name = 'Single Afternoon';

-- Beach Holiday activities: expected 2.
SELECT COUNT(*) AS beach_holiday_activities
FROM Outing o
JOIN Holiday h ON h.holiday_id = o.holiday_id
JOIN OutingActivity oa ON oa.outing_id = o.outing_id
WHERE h.holiday_name = 'Beach Holiday';

-- Mother's preferred outings: expected 3.
SELECT COUNT(*) AS mothers_preferred_outings
FROM FamilyMember fm
JOIN OutingParticipant op ON op.member_id = fm.member_id
WHERE fm.relationship_to_household = 'Mother'
  AND op.is_preferred = TRUE;

-- Thanksgiving options: expected 2.
SELECT COUNT(*) AS thanksgiving_outings
FROM Outing o
JOIN Holiday h ON h.holiday_id = o.holiday_id
WHERE h.holiday_name = 'Thanksgiving';

-- Memorial Day overnight options: expected 1.
SELECT COUNT(*) AS memorial_day_overnight_outings
FROM Outing o
JOIN Holiday h ON h.holiday_id = o.holiday_id
WHERE h.holiday_name = 'Memorial Day'
  AND o.end_date > o.start_date;


-- =========================================================
-- 4. EXISTING BUSINESS-RULE AUDITS
-- All queries below should return 0 rows.
-- =========================================================

SELECT
    oa.*
FROM OutingActivity oa
JOIN Outing o
    ON o.outing_id = oa.outing_id
WHERE oa.activity_date < o.start_date
   OR oa.activity_date > o.end_date;

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

SELECT
    oa.outing_id,
    oa.activity_date,
    COUNT(*) AS activity_count,
    tt.max_activities_per_day
FROM OutingActivity oa
JOIN Outing o
    ON o.outing_id = oa.outing_id
JOIN TripType tt
    ON tt.trip_type_id = o.trip_type_id
GROUP BY
    oa.outing_id,
    oa.activity_date,
    tt.max_activities_per_day
HAVING COUNT(*) > tt.max_activities_per_day;

SELECT
    outacc.*
FROM OutingAccommodation outacc
JOIN Outing o
    ON o.outing_id = outacc.outing_id
WHERE outacc.check_in_date < o.start_date
   OR outacc.check_out_date > o.end_date;


-- =========================================================
-- 5. EXPECTED HIGH-VALUE ANSWERS
-- =========================================================

-- Furthest outing should be Miami Fourth of July Weekend.
SELECT
    o.outing_name,
    SUM(tl.estimated_distance_miles) AS total_distance_miles
FROM Outing o
JOIN Holiday h ON h.holiday_id = o.holiday_id
JOIN TravelLeg tl ON tl.outing_id = o.outing_id
GROUP BY o.outing_id, o.outing_name
ORDER BY total_distance_miles DESC
LIMIT 1;

-- Average Thanksgiving price should be 600.00 with the supplied sample data.
SELECT
    ROUND(
        AVG(
            COALESCE(travel.TravelCost, 0)
            + COALESCE(lodging.LodgingCost, 0)
        ),
        2
    ) AS AverageThanksgivingTripPrice
FROM Outing o
JOIN Holiday h
    ON h.holiday_id = o.holiday_id
LEFT JOIN (
    SELECT outing_id, SUM(estimated_cost_total_usd) AS TravelCost
    FROM TravelLeg
    GROUP BY outing_id
) travel
    ON travel.outing_id = o.outing_id
LEFT JOIN (
    SELECT
        outing_id,
        SUM(DATEDIFF(check_out_date, check_in_date) * nightly_rate_usd)
            AS LodgingCost
    FROM OutingAccommodation
    GROUP BY outing_id
) lodging
    ON lodging.outing_id = o.outing_id
WHERE h.holiday_name = 'Thanksgiving';
