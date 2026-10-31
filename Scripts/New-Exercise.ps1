param(
    [string]$Module,
    [string]$Exercise,
    [string]$Title
)

$Root = Split-Path -Parent $PSScriptRoot
$Template = Join-Path $Root "Templates\Exercise"
$ExercisesRoot = Join-Path $Root "Exercises"

if (-not $Module) {
    $Module = Read-Host "Module number (example: 01)"
}

if (-not $Exercise) {
    $Exercise = Read-Host "Exercise number (example: 01)"
}

if (-not $Title) {
    $Title = Read-Host "Exercise title"
}

$Module = $Module.PadLeft(2, '0')
$Exercise = $Exercise.PadLeft(2, '0')

$TextInfo = (Get-Culture).TextInfo
$CleanTitle = $Title.Trim() -replace '[^\w\s-]', ''
$CleanTitle = $TextInfo.ToTitleCase($CleanTitle.ToLower())

$Slug = $CleanTitle `
    -replace '\s+', '_' `
    -replace '_+', '_'

$FolderName = "M${Module}E${Exercise}_${Slug}"
$Destination = Join-Path $ExercisesRoot $FolderName

if (Test-Path $Destination) {
    Write-Host ""
    Write-Host "Exercise already exists:" -ForegroundColor Yellow
    Write-Host $Destination
    exit 1
}

New-Item -ItemType Directory -Path $ExercisesRoot -Force | Out-Null
Copy-Item -Path $Template -Destination $Destination -Recurse

$PromptFile = Join-Path $Destination "prompt.md"
$NotesFile = Join-Path $Destination "notes.md"
$SubmissionFile = Join-Path $Destination "submission.md"

$Header = @"
# CSC6302 Database Principles

- Module: $Module
- Exercise: $Exercise
- Title: $Title

"@

$PromptContent = Get-Content $PromptFile -Raw
Set-Content $PromptFile ($Header + $PromptContent)

$NotesContent = Get-Content $NotesFile -Raw
Set-Content $NotesFile ($Header + $NotesContent)

$SubmissionContent = Get-Content $SubmissionFile -Raw
Set-Content $SubmissionFile ($Header + $SubmissionContent)

Write-Host ""
Write-Host "CSC6302 exercise created successfully." -ForegroundColor Green
Write-Host ""
Write-Host "Folder:"
Write-Host "  $Destination"
Write-Host ""
Write-Host "Working files:"
Write-Host "  prompt.md"
Write-Host "  notes.md"
Write-Host "  sources.md"
Write-Host "  submission.md"
Write-Host ""
Write-Host "Database:"
Write-Host "  database\schema.sql"
Write-Host "  database\seed.sql"
Write-Host "  database\queries.sql"
Write-Host "  database\tests.sql"
Write-Host ""
Write-Host "Optional:"
Write-Host "  frontend\"
Write-Host "  extension\"
Write-Host ""
Write-Host "Final:"
Write-Host "  submitted\"
