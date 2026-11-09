# CSC6302 Programming Project 2

This folder contains the Project 2 work built on the Module 2 Holiday Planner database.

## Run order

### Holiday Planner

1. Run the final Module 2 `HolidayPlanner_Create.sql`.
2. Run the final Module 2 `HolidayPlanner_InsertData.sql`.
3. Run `HolidayPlanner/01_revise_database.sql`.
4. Run `Tests/holiday_query_verification.sql`.
5. Run `HolidayPlanner/02_holiday_queries.sql`.

### Video Game database

1. Run the professor's `VideoGameCreationScript.sql`.
2. Run `VideoGame/01_video_game_queries.sql`.

## Submission files

After all tests pass, run `build_submission.ps1` from the CSC6302 `MySQL` repository root. It combines the final Module 2 Holiday Planner create/data scripts with the Project 2 revision to produce a self-contained `HolidayPlanner_Project2_Revised.sql`.

The professor-facing submission folder will then contain:

- `HolidayPlanner_Project2_Revised.sql`
- `HolidayPlanner_Project2_Queries.sql`
- `VideoGame_Project2_Queries.sql`
- the revised ER diagram PDF after it is exported from MySQL Workbench

A revised ER diagram is required because Project 2 adds attributes to existing Holiday Planner relations.

## AI use

AI-assisted tools were used to help generate and refine sample data for this database project. The schema revisions, constraints, relationships, queries, testing, and final results were reviewed and verified by the student.

## Easter Egg

There is a small piece of undocumented family database history hidden in the Holiday Planner schema metadata.

If you want to find it, run:

```sql
SELECT TABLE_COMMENT
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'HolidayPlanner'
  AND LOCATE('Keown White', TABLE_COMMENT) > 0;
```
