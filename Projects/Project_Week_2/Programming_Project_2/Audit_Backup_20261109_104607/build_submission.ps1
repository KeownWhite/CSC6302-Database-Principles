# CSC6302 Programming Project 2
# Build the professor-facing submission files.
# Run from:
# E:\Documents\School\MS\Year 2\Fall 2\CSC6302\MySQL

$Project2 = ".\Projects\Project_Week_2\Programming_Project_2"
$Module2Submission = ".\Exercises\Week_2\Holiday_Planner\Submission"
$Submission = "$Project2\Submission"

New-Item -ItemType Directory -Force -Path $Submission | Out-Null

$Create = "$Module2Submission\HolidayPlanner_Create.sql"
$Insert = "$Module2Submission\HolidayPlanner_InsertData.sql"
$Revision = "$Project2\HolidayPlanner\01_revise_database.sql"

foreach ($RequiredFile in @($Create, $Insert, $Revision)) {
    if (-not (Test-Path $RequiredFile)) {
        throw "Missing required file: $RequiredFile"
    }
}

$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$Combined = @(
    "-- CSC6302 Database Principles"
    "-- Programming Project 2"
    "-- Revised Holiday Planning Database"
    "-- Self-contained rebuild: base schema + base data + Project 2 revisions"
    ""
    Get-Content $Create -Raw -Encoding UTF8
    ""
    Get-Content $Insert -Raw -Encoding UTF8
    ""
    Get-Content $Revision -Raw -Encoding UTF8
) -join "`r`n"

[System.IO.File]::WriteAllText(
    [System.IO.Path]::GetFullPath("$Submission\HolidayPlanner_Project2_Revised.sql"),
    $Combined,
    $Utf8NoBom
)

Copy-Item `
    "$Project2\HolidayPlanner\02_holiday_queries.sql" `
    "$Submission\HolidayPlanner_Project2_Queries.sql" `
    -Force

Copy-Item `
    "$Project2\VideoGame\01_video_game_queries.sql" `
    "$Submission\VideoGame_Project2_Queries.sql" `
    -Force

Write-Host ""
Write-Host "Created professor-facing SQL files:"
Get-ChildItem $Submission -File | Select-Object Name, Length
Write-Host ""
Write-Host "After exporting the revised ERD PDF, copy it into this folder."
