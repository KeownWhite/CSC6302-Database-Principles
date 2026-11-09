-- CSC6302 Database Principles
-- Programming Project 2
-- Holiday Planner: Ten Required Queries
--
-- Run after the final HolidayPlanner database and 01_revise_database.sql.

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
-- 2. How many possible Halloween outings exist
--    in your planning database?
-- =========================================================

SELECT
    COUNT(*) AS NumberOfHalloweenOutings
FROM Outing o
JOIN Holiday h
    ON h.holiday_id = o.holiday_id
WHERE h.holiday_name = 'Halloween';


-- =========================================================
-- 3. What holidays can your family fly to
--    for the Fourth of July?
-- =========================================================

SELECT DISTINCT
    o.outing_name AS FourthOfJulyHoliday,
    l.location_name AS Destination
FROM Outing o
JOIN Holiday h
    ON h.holiday_id = o.holiday_id
JOIN Location l
    ON l.location_id = o.primary_location_id
JOIN TravelLeg tl
    ON tl.outing_id = o.outing_id
JOIN TravelMode tm
    ON tm.travel_mode_id = tl.travel_mode_id
WHERE h.holiday_name = 'Fourth of July'
  AND tm.travel_mode_name = 'Plane'
ORDER BY o.outing_name;


-- =========================================================
-- 4. What will the youngest member of your family be
--    packing for an afternoon trip to an apple orchard?
-- =========================================================

SELECT DISTINCT
    fm.first_name AS YoungestFamilyMember,
    pi.item_name AS PackingItem
FROM FamilyMember fm
JOIN (
    SELECT mtpi.member_id, mtpi.item_id
    FROM MemberTripPackingItem mtpi
    JOIN TripType tt
        ON tt.trip_type_id = mtpi.trip_type_id
    WHERE tt.trip_type_name = 'Single Afternoon'

    UNION

    SELECT fm2.member_id, api.item_id
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
ORDER BY pi.item_name;


-- =========================================================
-- 5. What activities can you do on your upcoming
--    single day Beach Holiday?
-- =========================================================

SELECT
    a.activity_name AS BeachHolidayActivity,
    oa.start_time AS PlannedStartTime
FROM Outing o
JOIN Holiday h
    ON h.holiday_id = o.holiday_id
JOIN TripType tt
    ON tt.trip_type_id = o.trip_type_id
JOIN OutingActivity oa
    ON oa.outing_id = o.outing_id
JOIN Activity a
    ON a.activity_id = oa.activity_id
WHERE h.holiday_name = 'Beach Holiday'
  AND tt.min_days = 1
  AND tt.max_days = 1
  AND o.start_date = o.end_date
  AND o.start_date >= CURRENT_DATE
ORDER BY oa.activity_date, oa.sequence_number;


-- =========================================================
-- 6. What holiday outing is the furthest away?
--    Distance is calculated from all planned travel legs.
-- =========================================================

SELECT
    o.outing_name AS FurthestHolidayOuting,
    l.location_name AS Destination,
    ROUND(SUM(tl.estimated_distance_miles), 1) AS TotalPlannedDistanceMiles
FROM Outing o
JOIN Holiday h
    ON h.holiday_id = o.holiday_id
JOIN Location l
    ON l.location_id = o.primary_location_id
JOIN TravelLeg tl
    ON tl.outing_id = o.outing_id
GROUP BY
    o.outing_id,
    o.outing_name,
    l.location_name
ORDER BY TotalPlannedDistanceMiles DESC
LIMIT 1;


-- =========================================================
-- 7. What is the shortest outing preferred by your mother,
--    regardless of the actual holiday it is associated with?
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
ORDER BY DurationDays ASC, o.start_date ASC
LIMIT 1;


-- =========================================================
-- 8. What activities are sensible between
--    the months of October and February?
--
-- NULL/NULL season values represent year-round activities.
-- The target month relation also handles seasons that wrap
-- across December and January.
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
-- 10. What are you packing for an overnight
--     Memorial Day trip?
--
-- Combines reusable trip-type packing, mode-specific packing,
-- and requirements from activities scheduled on the outing.
-- =========================================================

SELECT DISTINCT
    pi.item_name AS PackingItem
FROM PackingItem pi
JOIN (
    -- Trip-type packing
    SELECT mtpi.item_id
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

    UNION

    -- Travel-mode packing
    SELECT mvp.item_id
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

    UNION

    -- Activity-specific packing
    SELECT api.item_id
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
ORDER BY pi.item_name;
