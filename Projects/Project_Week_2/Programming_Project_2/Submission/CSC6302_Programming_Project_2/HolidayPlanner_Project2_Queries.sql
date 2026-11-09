-- CSC6302 Database Principles
-- Programming Project 2
-- Holiday Planner: Ten Required Queries
--
-- Run after HolidayPlanner_Project2_Revised.sql.

USE HolidayPlanner;


-- =========================================================
-- 1. What are the possible overnight Christmas holidays
--    your family could take?
-- =========================================================

SELECT
    o.outing_name AS ChristmasHoliday,
    l.location_name AS Destination,
    o.start_date AS StartDate,
    o.end_date AS EndDate,
    DATEDIFF(o.end_date, o.start_date) AS Nights
FROM Outing o
JOIN Holiday h
    ON h.holiday_id = o.holiday_id
JOIN Location l
    ON l.location_id = o.primary_location_id
WHERE h.holiday_name = 'Christmas'
  AND o.end_date > o.start_date
ORDER BY o.start_date;


-- =========================================================
-- 2. How many possible Halloween outings exist?
--
-- This query intentionally uses the unit's Cartesian-product form:
-- tables are listed in FROM and the join predicate is placed in WHERE.
-- =========================================================

SELECT
    COUNT(*) AS NumberOfHalloweenOutings
FROM Outing o, Holiday h
WHERE o.holiday_id = h.holiday_id
  AND h.holiday_name = 'Halloween';


-- =========================================================
-- 3. What holidays can your family fly to
--    for the Fourth of July?
--
-- This is a second Cartesian-product example using WHERE predicates.
-- =========================================================

SELECT DISTINCT
    o.outing_name AS FourthOfJulyHoliday,
    l.location_name AS Destination
FROM Outing o, Holiday h, Location l, TravelLeg tl, TravelMode tm
WHERE o.holiday_id = h.holiday_id
  AND o.primary_location_id = l.location_id
  AND tl.outing_id = o.outing_id
  AND tm.travel_mode_id = tl.travel_mode_id
  AND h.holiday_name = 'Fourth of July'
  AND tm.travel_mode_name = 'Plane'
ORDER BY o.outing_name;


-- =========================================================
-- 4. What will the youngest member of your family be
--    packing for an afternoon trip to an apple orchard?
--
-- Combines reusable Single Afternoon packing, Car packing,
-- and Apple Picking activity requirements. CONCAT demonstrates
-- the string-function material from this unit.
-- =========================================================

SELECT
    CONCAT(fm.first_name, ' ', fm.last_name) AS YoungestFamilyMember,
    pi.item_name AS PackingItem,
    packing.quantity AS Quantity,
    packing.bag_or_requirement AS BagOrRequirement,
    packing.rule_source AS RuleSource
FROM FamilyMember fm
JOIN (
    SELECT
        mtpi.member_id,
        mtpi.item_id,
        mtpi.quantity,
        mtpi.bag_type AS bag_or_requirement,
        'Single Afternoon' AS rule_source
    FROM MemberTripPackingItem mtpi
    JOIN TripType tt
        ON tt.trip_type_id = mtpi.trip_type_id
    WHERE tt.trip_type_name = 'Single Afternoon'

    UNION ALL

    SELECT
        mvp.member_id,
        mvp.item_id,
        mvp.quantity,
        mvp.bag_type,
        'Car Travel'
    FROM MemberTravelPackingItem mvp
    JOIN TravelMode tm
        ON tm.travel_mode_id = mvp.travel_mode_id
    WHERE tm.travel_mode_name = 'Car'

    UNION ALL

    SELECT
        fm2.member_id,
        api.item_id,
        api.quantity,
        CONCAT('Activity ', api.requirement_level),
        'Apple Picking'
    FROM FamilyMember fm2
    CROSS JOIN Activity a
    JOIN ActivityPackingItem api
        ON api.activity_id = a.activity_id
    WHERE a.activity_name = 'Apple Picking'
) packing
    ON packing.member_id = fm.member_id
JOIN PackingItem pi
    ON pi.item_id = packing.item_id
WHERE fm.birth_date = (
    SELECT MAX(birth_date)
    FROM FamilyMember
)
ORDER BY pi.item_name, packing.rule_source;


-- =========================================================
-- 5. What activities can you do on your upcoming
--    single day Beach Holiday?
--
-- "Beach Holiday" is the outing name, not a Holiday lookup value.
-- The sample outing uses a nearby state-park beach so the
-- Single Afternoon classification remains internally consistent.
-- =========================================================

SELECT
    a.activity_name AS BeachHolidayActivity,
    oa.start_time AS PlannedStartTime
FROM Outing o
JOIN TripType tt
    ON tt.trip_type_id = o.trip_type_id
JOIN OutingActivity oa
    ON oa.outing_id = o.outing_id
JOIN Activity a
    ON a.activity_id = oa.activity_id
WHERE o.outing_name = 'Beach Holiday'
  AND tt.trip_type_name = 'Single Afternoon'
  AND o.start_date = o.end_date
  AND o.start_date >= CURRENT_DATE
ORDER BY oa.activity_date, oa.sequence_number;


-- =========================================================
-- 6. What holiday outing is the furthest away?
--
-- distance_from_home_miles is stored once on Location, so the
-- answer is one-way distance from home and does not double-count
-- return travel. No Holiday join is used because an outing may be
-- valid even when holiday_id is NULL.
-- =========================================================

SELECT
    o.outing_name AS FurthestOuting,
    l.location_name AS Destination,
    l.distance_from_home_miles AS OneWayDistanceMiles
FROM Outing o
JOIN Location l
    ON l.location_id = o.primary_location_id
WHERE l.distance_from_home_miles = (
    SELECT MAX(l2.distance_from_home_miles)
    FROM Outing o2
    JOIN Location l2
        ON l2.location_id = o2.primary_location_id
)
ORDER BY o.outing_name;


-- =========================================================
-- 7. What is the shortest outing preferred by your mother,
--    regardless of the actual holiday it is associated with?
--
-- The MIN subquery returns every tied shortest preferred outing
-- instead of silently dropping ties with LIMIT 1.
-- =========================================================

SELECT
    o.outing_name AS MothersShortestPreferredOuting,
    COALESCE(h.holiday_name, 'No specific holiday') AS Holiday,
    DATEDIFF(o.end_date, o.start_date) + 1 AS DurationDays
FROM FamilyMember fm
JOIN OutingParticipant op
    ON op.member_id = fm.member_id
JOIN Outing o
    ON o.outing_id = op.outing_id
LEFT JOIN Holiday h
    ON h.holiday_id = o.holiday_id
WHERE fm.relationship_to_household = 'Mother'
  AND op.is_preferred = TRUE
  AND DATEDIFF(o.end_date, o.start_date) + 1 = (
      SELECT MIN(DATEDIFF(o2.end_date, o2.start_date) + 1)
      FROM FamilyMember fm2, OutingParticipant op2, Outing o2
      WHERE fm2.member_id = op2.member_id
        AND op2.outing_id = o2.outing_id
        AND fm2.relationship_to_household = 'Mother'
        AND op2.is_preferred = TRUE
  )
ORDER BY o.start_date, o.outing_name;


-- =========================================================
-- 8. What activities are sensible between
--    the months of October and February?
--
-- Interpretation: "between October and February" means an activity
-- is sensible if its normal season overlaps AT LEAST ONE month in
-- the October-through-February window. Therefore an Aug-Oct activity
-- is included because October overlaps the requested period.
--
-- NULL/NULL season values represent year-round activities.
-- The logic also handles seasons that wrap across December/January.
-- =========================================================

SELECT DISTINCT
    a.activity_name AS SensibleActivity
FROM Activity a
JOIN (
    SELECT 10 AS month_number
    UNION ALL SELECT 11
    UNION ALL SELECT 12
    UNION ALL SELECT 1
    UNION ALL SELECT 2
) target_month
    ON
       (a.season_start_month IS NULL AND a.season_end_month IS NULL)
       OR
       (
           a.season_start_month <= a.season_end_month
           AND target_month.month_number
               BETWEEN a.season_start_month AND a.season_end_month
       )
       OR
       (
           a.season_start_month > a.season_end_month
           AND (
               target_month.month_number >= a.season_start_month
               OR target_month.month_number <= a.season_end_month
           )
       )
ORDER BY a.activity_name;


-- =========================================================
-- 9. What is the average price of a Thanksgiving trip?
--
-- Trip price = planned travel cost + lodging cost.
-- Lodging cost = number of nights * nightly rate.
-- =========================================================

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
    SELECT
        outing_id,
        SUM(estimated_cost_total_usd) AS TravelCost
    FROM TravelLeg
    GROUP BY outing_id
) travel
    ON travel.outing_id = o.outing_id
LEFT JOIN (
    SELECT
        outing_id,
        SUM(
            DATEDIFF(check_out_date, check_in_date)
            * nightly_rate_usd
        ) AS LodgingCost
    FROM OutingAccommodation
    GROUP BY outing_id
) lodging
    ON lodging.outing_id = o.outing_id
WHERE h.holiday_name = 'Thanksgiving';


-- =========================================================
-- 10. What are you packing for an overnight Memorial Day trip?
--
-- Quantity and bag/requirement are retained from each source so
-- values such as Clothing x2 are visible in the result.
-- =========================================================

SELECT
    pi.item_name AS PackingItem,
    packing.quantity AS Quantity,
    packing.bag_or_requirement AS BagOrRequirement,
    packing.rule_source AS RuleSource
FROM PackingItem pi
JOIN (
    -- Trip-type packing
    SELECT
        mtpi.item_id,
        mtpi.quantity,
        mtpi.bag_type AS bag_or_requirement,
        'Weekend Trip' AS rule_source
    FROM FamilyMember fm
    JOIN MemberTripPackingItem mtpi
        ON mtpi.member_id = fm.member_id
    JOIN TripType tt
        ON tt.trip_type_id = mtpi.trip_type_id
    JOIN Outing o
        ON o.trip_type_id = tt.trip_type_id
    JOIN Holiday h
        ON h.holiday_id = o.holiday_id
    WHERE fm.is_self = TRUE
      AND h.holiday_name = 'Memorial Day'
      AND o.end_date > o.start_date

    UNION ALL

    -- Travel-mode packing
    SELECT
        mvp.item_id,
        mvp.quantity,
        mvp.bag_type,
        'Car Travel'
    FROM FamilyMember fm
    JOIN MemberTravelPackingItem mvp
        ON mvp.member_id = fm.member_id
    JOIN TravelLeg tl
        ON tl.travel_mode_id = mvp.travel_mode_id
    JOIN Outing o
        ON o.outing_id = tl.outing_id
    JOIN Holiday h
        ON h.holiday_id = o.holiday_id
    WHERE fm.is_self = TRUE
      AND h.holiday_name = 'Memorial Day'
      AND o.end_date > o.start_date
    GROUP BY mvp.item_id, mvp.quantity, mvp.bag_type

    UNION ALL

    -- Activity-specific packing
    SELECT
        api.item_id,
        api.quantity,
        CONCAT('Activity ', api.requirement_level),
        'Scheduled Activity'
    FROM Outing o
    JOIN Holiday h
        ON h.holiday_id = o.holiday_id
    JOIN OutingActivity oa
        ON oa.outing_id = o.outing_id
    JOIN ActivityPackingItem api
        ON api.activity_id = oa.activity_id
    WHERE h.holiday_name = 'Memorial Day'
      AND o.end_date > o.start_date
) packing
    ON packing.item_id = pi.item_id
ORDER BY pi.item_name, packing.rule_source;
