# CSC6302 Programming Project 2

This folder contains the final Project 2 work built on the Module 2 Holiday Planner database.

## Run order

### Holiday Planner

1. Run the final Module 2 `HolidayPlanner_Create.sql`.
2. Run the final Module 2 `HolidayPlanner_InsertData.sql`.
3. Run `HolidayPlanner/01_revise_database.sql`.
4. Run `Tests/holiday_query_verification.sql`.
5. Run `HolidayPlanner/02_holiday_queries.sql`.

The professor-facing build script combines the base database and Project 2 revision into one self-contained `HolidayPlanner_Project2_Revised.sql`.

### Video Game database

1. Run the professor's `VideoGameCreationScript.sql`.
2. Run `VideoGame/01_video_game_queries.sql`.

## Project 2 design revisions

Project 2 adds only the information exposed as necessary by the new query requirements:

- `FamilyMember.is_self`
- `OutingParticipant.is_preferred`
- `Location.distance_from_home_miles`
- `Activity.season_start_month`
- `Activity.season_end_month`

Distance is stored on `Location`, not `TravelLeg`, because the requested "furthest away" value is a one-way destination property relative to the family's home.

The Beach Holiday is an outing name rather than a row in the Holiday lookup table, and its sample destination was moved to a nearby state-park beach so its Single Afternoon classification is internally consistent.

## AI use

AI-assisted tools were used to help generate and refine sample data for this database project. The schema revisions, constraints, relationships, queries, testing, and final results were reviewed and verified by the student.

## Optional easter egg

The graded database no longer contains the easter egg as table metadata. A separate optional script is retained under `Extras/99_easter_egg.sql` for local use only and is intentionally excluded from the professor-facing submission build.
