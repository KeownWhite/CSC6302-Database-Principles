# Run from the CSC6302\MySQL repository root.
$Source = Split-Path -Parent $MyInvocation.MyCommand.Path
$Destination = ".\Projects\Project_Week_2\Programming_Project_2"

New-Item -ItemType Directory -Force -Path $Destination | Out-Null
Copy-Item "$Source\Requirements" $Destination -Recurse -Force
Copy-Item "$Source\HolidayPlanner" $Destination -Recurse -Force
Copy-Item "$Source\VideoGame" $Destination -Recurse -Force
Copy-Item "$Source\Tests" $Destination -Recurse -Force
Copy-Item "$Source\README.md" "$Destination\README.md" -Force

Write-Host ""
Write-Host "Programming Project 2 files installed to:"
Write-Host (Resolve-Path $Destination)
Write-Host ""
tree $Destination /F
