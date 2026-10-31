param(
    [string]$Module,
    [string]$Title
)

$Root = Split-Path -Parent $PSScriptRoot
$DocsRoot = Join-Path $Root "Docs"
$Templates = Join-Path $Root "Templates\Docs"

while (-not $Module -or $Module -notmatch '^\d+$') {
    $Module = Read-Host "Module number (numbers only, example: 01)"

    if ($Module -notmatch '^\d+$') {
        Write-Host "Invalid module number. Use numbers only." -ForegroundColor Red
    }
}

if (-not $Title) {
    $Title = Read-Host "Module title"
}

$Module = $Module.PadLeft(2, '0')

$TextInfo = (Get-Culture).TextInfo
$CleanTitle = $Title.Trim() -replace '[^\w\s-]', ''
$CleanTitle = $TextInfo.ToTitleCase($CleanTitle.ToLower())

$Slug = $CleanTitle `
    -replace '\s+', '_' `
    -replace '_+', '_'

$ModuleFolder = "Module${Module}_${Slug}"

$Paths = @{
    Slides         = Join-Path $DocsRoot "Slides\$ModuleFolder"
    Summaries      = Join-Path $DocsRoot "Slide_Summaries\$ModuleFolder"
    LectureNotes   = Join-Path $DocsRoot "Lecture_Notes\$ModuleFolder"
    StudyGuides    = Join-Path $DocsRoot "Study_Guides\$ModuleFolder"
    References     = Join-Path $DocsRoot "References\$ModuleFolder"
    Professor      = Join-Path $DocsRoot "Professor\$ModuleFolder"
}

foreach ($Path in $Paths.Values) {
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
}

Copy-Item `
    (Join-Path $Templates "slide_summary.md") `
    (Join-Path $Paths.Summaries "summary.md")

Copy-Item `
    (Join-Path $Templates "lecture_notes.md") `
    (Join-Path $Paths.LectureNotes "lecture_notes.md")

Copy-Item `
    (Join-Path $Templates "study_guide.md") `
    (Join-Path $Paths.StudyGuides "study_guide.md")

Write-Host ""
Write-Host "CSC6302 module workspace created." -ForegroundColor Green
Write-Host ""
Write-Host "Module: $Module"
Write-Host "Title:  $Title"
Write-Host ""
Write-Host "Professor slides:"
Write-Host "  $($Paths.Slides)"
Write-Host ""
Write-Host "Slide summary:"
Write-Host "  $($Paths.Summaries)"
Write-Host ""
Write-Host "Lecture notes:"
Write-Host "  $($Paths.LectureNotes)"
Write-Host ""
Write-Host "Study guide:"
Write-Host "  $($Paths.StudyGuides)"
