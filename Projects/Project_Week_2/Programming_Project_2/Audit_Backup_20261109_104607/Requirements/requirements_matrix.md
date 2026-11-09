# CSC6302 Programming Project 2 — Requirements Matrix

| # | Requirement | Existing Support | Revision / Query Plan |
|---|---|---|---|
| 1 | Overnight Christmas possibilities | Holiday, Outing, Location | Filter Christmas outings where `end_date > start_date`. |
| 2 | Count Halloween outings | Holiday, Outing | `COUNT(*)` after joining Halloween. |
| 3 | Fourth of July trips reachable by plane | TravelMode/TravelLeg available, data missing | Add Fourth of July + Miami outing with Plane legs. |
| 4 | Youngest member's afternoon apple-orchard packing | Reusable packing model exists; youngest lacks Single Afternoon data | Add Riley Single Afternoon items and Apple Picking requirements; find youngest with `MAX(birth_date)`. |
| 5 | Upcoming single-day Beach Holiday activities | Activity scheduling exists; data missing | Add Beach Holiday, Jones Beach outing, and two activities. |
| 6 | Furthest holiday outing | Travel legs exist; distance missing | Add `estimated_distance_miles` to TravelLeg and sum by outing. |
| 7 | Shortest outing preferred by mother | Participation exists; mother/preference not explicit | Add `is_preferred`; represent Taylor as Mother; order preferred outings by duration. |
| 8 | Activities sensible October through February | Activity exists; season missing | Add `season_start_month` and `season_end_month`; NULL/NULL means year-round. |
| 9 | Average Thanksgiving trip price | Travel and lodging cost already modeled; Thanksgiving data missing | Add two Thanksgiving outings and average travel + lodging totals. |
| 10 | Personal packing for overnight Memorial Day | Packing model exists; "self" and Memorial Day data missing | Add `is_self`, Memorial Day overnight outing, then union trip, travel, and activity packing. |
| VG1 | Games on first console | Professor VideoGameSystems schema | Query `Game` for Play Station 2. |
| VG2 | Update four NumPlayers values | `Game.NumPlayers` exists | Update four Animal Crossing titles to 4. |
| VG3 | Games on consoles released before 2000 | Game → Console | Join and filter `Console.ReleaseDate`. |
| VG4 | Count games on all PlayStation consoles | `Game.ConsoleName` | `LIKE 'Play Station%'` + `COUNT(*)`. |
| VG5 | Online games with console and series | Game + Series | LEFT JOIN Series and filter `IsOnline = TRUE`. |

## Design rule

Project 2 revisions are intentionally limited to information required by the new queries. Existing Module 2 tables and constraints remain the foundation of the database.
