# CSC6302 Programming Project 2 — Requirements Matrix (Final Hardening)

| # | Requirement | Final implementation |
|---|---|
| 1 | Overnight Christmas possibilities | Holiday + Outing + Location; filters overnight Christmas outings. |
| 2 | Count Halloween outings | Uses the unit's Cartesian-product `FROM` form with the relationship predicate in `WHERE`. |
| 3 | Fourth of July trips reachable by plane | Fourth of July outing + Plane travel legs; second Cartesian-product example. |
| 4 | Youngest member's apple-orchard afternoon packing | Combines Single Afternoon, Car, and Apple Picking rules; returns quantity and bag/requirement; uses `CONCAT`. |
| 5 | Upcoming single-day Beach Holiday activities | Beach Holiday is an outing name with `holiday_id = NULL`; nearby Grafton Lakes data keeps Single Afternoon realistic. |
| 6 | Furthest outing | One-way `distance_from_home_miles` stored once on Location; no return-trip double count and no Holiday join. |
| 7 | Mother's shortest preferred outing | `MIN()` subquery returns all tied shortest preferred outings. |
| 8 | Oct-Feb sensible activities | Explicitly documents that any seasonal overlap with Oct-Feb qualifies; wraparound seasons supported. |
| 9 | Average Thanksgiving price | Average of per-outing travel + lodging totals. |
| 10 | Personal Memorial Day packing | Returns quantity and bag/requirement from trip, travel, and activity rules. |
| VG1 | Games on first console | Play Station 2. |
| VG2 | Update four NumPlayers values | Names games for readability while key-based outer predicate remains Safe-Updates compatible. |
| VG3 | Games on consoles released before 2000 | Game → Console join, filter Console.ReleaseDate. |
| VG4 | Count games on PlayStation consoles | Uses supplied Console names beginning `Play Station`, including Portable. |
| VG5 | Online games with console and series | LEFT JOIN Series; `IsOnline = TRUE`. |
