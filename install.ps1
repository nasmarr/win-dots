# Simple install script for win-dots
# Run with: powershell -ExecutionPolicy Bypass -File install.ps1

Write-Host "nasmarr win-dots installer" -ForegroundColor Cyan
Write-Host ""

$userPath = "$env:USERPROFILE"

# Install GlazeWM
Write-Host "Installing GlazeWM..." -ForegroundColor Green
winget install --id=glzr-io.glazewm -e --accept-source-agreements --accept-package-agreements

# TODO: Install VSCode

# TODO: Install Brave Browser

# TODO: Install Steam

# TODO: Install Discord

# Create symlinks
Write-Host ""
Write-Host "Creating symlinks..." -ForegroundColor Green

# Add your symlinks here
# Example:
# New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.glzr" -Target "$repoPath\.glzr" -Force

# Symlink GlazeWM config
$glzrPath = "$userPath\.glzr"
if (Test-Path $glzrPath) {
    Write-Host "Removing existing .glzr directory..." -ForegroundColor Yellow
    Remove-Item -Path $glzrPath -Recurse -Force
}
New-Item -ItemType SymbolicLink -Path $glzrPath -Target "$repoPath\.glzr" -Force

Write-Host ""
Write-Host "Done!" -ForegroundColor Green