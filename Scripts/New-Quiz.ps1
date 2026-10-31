param(
    [string]$Module,
    [string]$Quiz,
    [string]$Title
)

$Root = Split-Path -Parent $PSScriptRoot
$Template = Join-Path $Root "Templates\Quiz"
$QuizRoot = Join-Path $Root "Quizzes"

while (-not $Module -or $Module -notmatch '^\d+$') {
    $Module = Read-Host "Module number (numbers only, example: 01)"

    if ($Module -notmatch '^\d+$') {
        Write-Host "Invalid module number. Use numbers only." -ForegroundColor Red
    }
}

while (-not $Quiz -or $Quiz -notmatch '^\d+$') {
    $Quiz = Read-Host "Quiz number (numbers only, example: 01)"

    if ($Quiz -notmatch '^\d+$') {
        Write-Host "Invalid quiz number. Use numbers only." -ForegroundColor Red
    }
}

if (-not $Title) {
    $Title = Read-Host "Quiz title"
}

$Module = $Module.PadLeft(2, '0')
$Quiz = $Quiz.PadLeft(2, '0')

$TextInfo = (Get-Culture).TextInfo
$CleanTitle = $Title.Trim() -replace '[^\w\s-]', ''
$CleanTitle = $TextInfo.ToTitleCase($CleanTitle.ToLower())

$Slug = $CleanTitle `
    -replace '\s+', '_' `
    -replace '_+', '_'

$FolderName = "M${Module}Q${Quiz}_${Slug}"
$Destination = Join-Path $QuizRoot $FolderName

if (Test-Path $Destination) {
    Write-Host ""
    Write-Host "Quiz already exists:" -ForegroundColor Yellow
    Write-Host $Destination
    exit 1
}

New-Item -ItemType Directory -Path $QuizRoot -Force | Out-Null
Copy-Item -Path $Template -Destination $Destination -Recurse

$Header = @"
# CSC6302 Database Principles

- Module: $Module
- Quiz: $Quiz
- Title: $Title

"@

foreach ($File in @("questions.md", "answers.md", "notes.md", "review.md")) {
    $Path = Join-Path $Destination $File
    $Content = Get-Content $Path -Raw
    Set-Content $Path ($Header + $Content)
}

Write-Host ""
Write-Host "CSC6302 quiz created successfully." -ForegroundColor Green
Write-Host ""
Write-Host "Folder:"
Write-Host "  $Destination"
Write-Host ""
Write-Host "Files:"
Write-Host "  questions.md"
Write-Host "  answers.md"
Write-Host "  notes.md"
Write-Host "  review.md"
Write-Host ""
Write-Host "Final:"
Write-Host "  submitted\"
