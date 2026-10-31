param(
    [string]$Project,
    [string]$Title
)

$Root = Split-Path -Parent $PSScriptRoot
$Template = Join-Path $Root "Templates\Project"
$ProjectsRoot = Join-Path $Root "Projects"

while (-not $Project -or $Project -notmatch '^\d+$') {
    $Project = Read-Host "Project number (numbers only, example: 01)"

    if ($Project -notmatch '^\d+$') {
        Write-Host "Invalid project number. Use numbers only." -ForegroundColor Red
    }
}

if (-not $Title) {
    $Title = Read-Host "Project title"
}

$Project = $Project.PadLeft(2, '0')

$TextInfo = (Get-Culture).TextInfo
$CleanTitle = $Title.Trim() -replace '[^\w\s-]', ''
$CleanTitle = $TextInfo.ToTitleCase($CleanTitle.ToLower())

$Slug = $CleanTitle `
    -replace '\s+', '_' `
    -replace '_+', '_'

$FolderName = "Project${Project}_${Slug}"
$Destination = Join-Path $ProjectsRoot $FolderName

if (Test-Path $Destination) {
    Write-Host ""
    Write-Host "Project already exists:" -ForegroundColor Yellow
    Write-Host $Destination
    exit 1
}

New-Item -ItemType Directory -Path $ProjectsRoot -Force | Out-Null
Copy-Item -Path $Template -Destination $Destination -Recurse

$Header = @"
# CSC6302 Database Principles

- Project: $Project
- Title: $Title

"@

foreach ($File in @(
    "prompt.md",
    "requirements.md",
    "notes.md",
    "sources.md",
    "README.md"
)) {
    $Path = Join-Path $Destination $File
    $Content = Get-Content $Path -Raw
    Set-Content $Path ($Header + $Content)
}

Write-Host ""
Write-Host "CSC6302 project created successfully." -ForegroundColor Green
Write-Host ""
Write-Host "Folder:"
Write-Host "  $Destination"
Write-Host ""
Write-Host "Core:"
Write-Host "  prompt.md"
Write-Host "  requirements.md"
Write-Host "  notes.md"
Write-Host "  sources.md"
Write-Host "  README.md"
Write-Host ""
Write-Host "Development:"
Write-Host "  database\"
Write-Host "  java\"
Write-Host "  frontend\"
Write-Host "  diagrams\"
Write-Host "  docs\"
Write-Host ""
Write-Host "Optional:"
Write-Host "  extension\"
Write-Host ""
Write-Host "Final:"
Write-Host "  submitted\"
