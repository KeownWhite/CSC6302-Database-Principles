# CSC6302 Programming Project 2
# Build professor-facing submission files.
# Run from the CSC6302\MySQL repository root.

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

$CreateRaw = Get-Content $Create -Raw -Encoding UTF8
$InsertRaw = Get-Content $Insert -Raw -Encoding UTF8
$RevisionRaw = Get-Content $Revision -Raw -Encoding UTF8

# Remove stale standalone run-order comments from the self-contained build.
$InsertRaw = [regex]::Replace(
    $InsertRaw,
    '(?im)^--\s*Run\s+after\s+.*(?:\r?\n)?',
    ''
)

$RevisionRaw = [regex]::Replace(
    $RevisionRaw,
    '(?im)^--\s*Run\s+after\s+.*(?:\r?\n)?',
    ''
)

$Combined = @(
    "-- CSC6302 Database Principles"
    "-- Programming Project 2"
    "-- Revised Holiday Planning Database"
    "-- Self-contained rebuild: base schema + base data + Project 2 revisions"
    ""
    "-- ========================================================="
    "-- BASE DATABASE SCHEMA"
    "-- ========================================================="
    $CreateRaw
    ""
    "-- ========================================================="
    "-- BASE SAMPLE DATA"
    "-- ========================================================="
    $InsertRaw
    ""
    "-- ========================================================="
    "-- PROGRAMMING PROJECT 2 REVISIONS"
    "-- ========================================================="
    $RevisionRaw
) -join "`r`n"

[System.IO.File]::WriteAllText(
    (Join-Path (Resolve-Path $Submission).Path "HolidayPlanner_Project2_Revised.sql"),
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
Write-Host "Professor-facing SQL files created:"
Get-ChildItem $Submission -File | Select-Object Name, Length
Write-Host ""
Write-Host "Export the revised Workbench ERD as HolidayPlanner_Project2_ERD.pdf into this folder."
