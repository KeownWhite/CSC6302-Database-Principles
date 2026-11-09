-- CSC6302 Database Principles
-- Programming Project 2
-- Holiday Planner post-revision verification

USE HolidayPlanner;


-- =========================================================
-- 1. PROJECT 2 STRUCTURE
-- Expected: five rows
-- =========================================================

SELECT
    TABLE_NAME,
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
      (TABLE_NAME = 'Location' AND COLUMN_NAME = 'distance_from_home_miles')
      OR
      (TABLE_NAME = 'Activity' AND COLUMN_NAME IN (
          'season_start_month',
          'season_end_month'
      ))
  )
ORDER BY TABLE_NAME, ORDINAL_POSITION;


-- =========================================================
-- 2. REVISION CHECKS
-- Expected values: 1, 1, 0, 3, 0, 5
-- =========================================================

SELECT COUNT(*) AS self_member_count
FROM FamilyMember
WHERE is_self = TRUE;

SELECT COUNT(*) AS mother_count
FROM FamilyMember
WHERE relationship_to_household = 'Mother';

SELECT COUNT(*) AS invalid_location_distance_count
FROM Location
WHERE distance_from_home_miles < 0;

SELECT COUNT(*) AS project2_holiday_count
FROM Holiday
WHERE holiday_name IN (
    'Fourth of July',
    'Thanksgiving',
    'Memorial Day'
);

SELECT COUNT(*) AS beach_holiday_lookup_rows
FROM Holiday
WHERE holiday_name = 'Beach Holiday';

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
-- 3. QUERY-SPECIFIC DATA
-- =========================================================

SELECT COUNT(*) AS overnight_christmas_outings
FROM Outing o
JOIN Holiday h ON h.holiday_id = o.holiday_id
WHERE h.holiday_name = 'Christmas'
  AND o.end_date > o.start_date;

SELECT COUNT(*) AS halloween_outings
FROM Outing o
JOIN Holiday h ON h.holiday_id = o.holiday_id
WHERE h.holiday_name = 'Halloween';

SELECT COUNT(DISTINCT o.outing_id) AS flyable_fourth_of_july_outings
FROM Outing o
JOIN Holiday h ON h.holiday_id = o.holiday_id
JOIN TravelLeg tl ON tl.outing_id = o.outing_id
JOIN TravelMode tm ON tm.travel_mode_id = tl.travel_mode_id
WHERE h.holiday_name = 'Fourth of July'
  AND tm.travel_mode_name = 'Plane';

-- Q4 should include the youngest member's car rule "Road Snacks".
SELECT
    fm.first_name,
    pi.item_name,
    mvp.quantity,
    mvp.bag_type
FROM FamilyMember fm
JOIN MemberTravelPackingItem mvp ON mvp.member_id = fm.member_id
JOIN TravelMode tm ON tm.travel_mode_id = mvp.travel_mode_id
JOIN PackingItem pi ON pi.item_id = mvp.item_id
WHERE fm.birth_date = (SELECT MAX(birth_date) FROM FamilyMember)
  AND tm.travel_mode_name = 'Car'
  AND pi.item_name = 'Road Snacks';

-- Nearby beach outing should have no Holiday lookup row and short travel.
SELECT
    o.outing_name,
    o.holiday_id,
    MAX(tl.planned_duration_minutes) AS longest_travel_leg_minutes
FROM Outing o
JOIN TravelLeg tl ON tl.outing_id = o.outing_id
WHERE o.outing_name = 'Beach Holiday'
GROUP BY o.outing_id, o.outing_name, o.holiday_id;

-- Mother's preferred list contains two tied one-day shortest outings.
SELECT
    o.outing_name,
    DATEDIFF(o.end_date, o.start_date) + 1 AS duration_days
FROM FamilyMember fm
JOIN OutingParticipant op ON op.member_id = fm.member_id
JOIN Outing o ON o.outing_id = op.outing_id
WHERE fm.relationship_to_household = 'Mother'
  AND op.is_preferred = TRUE
ORDER BY duration_days, o.outing_name;

SELECT COUNT(*) AS thanksgiving_outings
FROM Outing o
JOIN Holiday h ON h.holiday_id = o.holiday_id
WHERE h.holiday_name = 'Thanksgiving';

SELECT COUNT(*) AS memorial_day_overnight_outings
FROM Outing o
JOIN Holiday h ON h.holiday_id = o.holiday_id
WHERE h.holiday_name = 'Memorial Day'
  AND o.end_date > o.start_date;


-- =========================================================
-- 4. EXISTING BUSINESS-RULE AUDITS
-- All should return zero rows.
-- =========================================================

SELECT oa.*
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

SELECT outacc.*
FROM OutingAccommodation outacc
JOIN Outing o
    ON o.outing_id = outacc.outing_id
WHERE outacc.check_in_date < o.start_date
   OR outacc.check_out_date > o.end_date;


-- =========================================================
-- 5. HIGH-VALUE EXPECTED RESULTS
-- =========================================================

-- Furthest one-way destination should be Miami Beach at 1220 miles.
SELECT
    o.outing_name,
    l.location_name,
    l.distance_from_home_miles
FROM Outing o
JOIN Location l ON l.location_id = o.primary_location_id
WHERE l.distance_from_home_miles = (
    SELECT MAX(l2.distance_from_home_miles)
    FROM Outing o2
    JOIN Location l2 ON l2.location_id = o2.primary_location_id
);

-- Thanksgiving average remains $600.00.
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
