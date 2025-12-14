<#
.SYNOPSIS
    Project Setup Script for Windows.
.DESCRIPTION
    Renames placeholder "MyProject" to your project name throughout the codebase.
.PARAMETER Name
    Your project name (e.g., "AwesomeApp")
.PARAMETER Author
    Author name for documentation (optional)
.PARAMETER ShowDetails
    Show detailed progress
.EXAMPLE
    .\setup.ps1 -Name "MyCoolProject"
.EXAMPLE
    .\setup.ps1 -Name "DataProcessor" -Author "Jane Doe" -ShowDetails
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Name,

    [string]$Author = "",

    [switch]$ShowDetails
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Derive variants
$ProjectUpper = $Name.ToUpper()
$ProjectLower = $Name.ToLower()

Write-Host "Setting up project: $Name"
Write-Host "  Uppercase: $ProjectUpper"
Write-Host "  Lowercase: $ProjectLower"
if ($Author) { Write-Host "  Author: $Author" }
Write-Host ""

# Get all text files, excluding .git, build, and setup scripts
$files = Get-ChildItem -Path $ScriptDir -Recurse -File |
    Where-Object {
        $_.FullName -notmatch "\\.git\\" -and
        $_.FullName -notmatch "\\build\\" -and
        $_.Name -ne "setup.sh" -and
        $_.Name -ne "setup.ps1"
    }

$count = 0

foreach ($file in $files) {
    try {
        $content = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }
        
        $modified = $false
        $newContent = $content
        
        # Replace MyProject -> ProjectName
        if ($newContent -match "MyProject") {
            $newContent = $newContent -replace "MyProject", $Name
            $modified = $true
        }
        
        # Replace MYPROJECT -> PROJECTNAME
        if ($newContent -match "MYPROJECT") {
            $newContent = $newContent -replace "MYPROJECT", $ProjectUpper
            $modified = $true
        }
        
        # Replace myproject -> projectname
        if ($newContent -match "myproject") {
            $newContent = $newContent -replace "myproject", $ProjectLower
            $modified = $true
        }
        
        # Update author if provided
        if ($Author -and ($newContent -match "Your Name")) {
            $newContent = $newContent -replace "Your Name", $Author
            $modified = $true
        }
        
        if ($modified) {
            Set-Content -Path $file.FullName -Value $newContent -NoNewline
            $count++
            if ($ShowDetails) {
                $relativePath = $file.FullName.Substring($ScriptDir.Length + 1)
                Write-Host "  Updated: $relativePath"
            }
        }
    }
    catch {
        # Skip files that can't be read as text
    }
}

Write-Host ""
Write-Host "Updated $count files."

# Clean up setup scripts
Write-Host "Removing setup scripts..."
$setupSh = Join-Path $ScriptDir "setup.sh"
$setupPs1 = Join-Path $ScriptDir "setup.ps1"
if (Test-Path $setupSh) { Remove-Item $setupSh -Force }
if (Test-Path $setupPs1) { Remove-Item $setupPs1 -Force }

Write-Host ""
Write-Host "Setup complete! Your project '$Name' is ready." -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Review the changes: git diff"
Write-Host "  2. Build the project: cmake --preset win-debug; cmake --build --preset win-debug"
Write-Host "  3. Run tests: ctest --preset win-debug"
Write-Host "  4. Commit: git add -A; git commit -m 'Initial project setup'"
