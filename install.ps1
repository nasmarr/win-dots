# Simple install script for win-dots
# Run with: powershell -ExecutionPolicy Bypass -File install.ps1

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "Error: This script must be run as Administrator" -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as Administrator', then run the script again." -ForegroundColor Yellow
    exit 1
}

Write-Host "nasmarr win-dots installer" -ForegroundColor Cyan
Write-Host ""

$userPath = "$env:USERPROFILE"
$repoPath = $PSScriptRoot
$gitEmail = ""
$gitUsername = ""

# Prompt for GitHub SSH setup
Write-Host "Do you want to set up GitHub SSH? (y/n)" -ForegroundColor Cyan
$setupSSH = Read-Host
$gitEmail = ""
$gitUsername = ""

if ($setupSSH -eq "y") {
    $gitEmail = Read-Host "Enter your GitHub email"
    $gitUsername = Read-Host "Enter your GitHub username"
}
Write-Host ""


# Install CaskaydiaMono Nerd Font
Write-Host "Installing CaskaydiaMono Nerd Font..." -ForegroundColor Green
$fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaMono.zip"
$tempPath = "$env:TEMP\CascadiaMono.zip"
$extractPath = "$env:TEMP\CascadiaMono"

# Download font
Invoke-WebRequest -Uri $fontUrl -OutFile $tempPath
Expand-Archive -Path $tempPath -DestinationPath $extractPath -Force

# Install fonts
$fontsFolder = (New-Object -ComObject Shell.Application).Namespace(0x14)
Get-ChildItem -Path $extractPath -Filter "*.ttf" | ForEach-Object {
    $fontsFolder.CopyHere($_.FullName)
}

# Cleanup
Remove-Item -Path $tempPath -Force
Remove-Item -Path $extractPath -Recurse -Force

# TODO: Create custom OhMyPosh theme based on Catppuccin

#####################
# APP INSTALLATIONS #
#####################

# Install OhMyPosh
Write-Host "Installing OhMyPosh..." -ForegroundColor Green
winget install JanDeDobbeleer.OhMyPosh --source winget

# Install GlazeWM
Write-Host "Installing GlazeWM..." -ForegroundColor Green
winget install --id=glzr-io.glazewm -e --accept-source-agreements --accept-package-agreements

# Add GlazeWM to startup
$startupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$glazewmPath = "C:\Program Files\GlazeWM\glazewm.exe"
$shortcutPath = "$startupPath\GlazeWM.lnk"

$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($shortcutPath)
$Shortcut.TargetPath = $glazewmPath
$Shortcut.Save()

# Install 7zip
Write-Host "Installing 7zip..." -ForegroundColor Green
winget install --id=7zip.7zip -e --accept-source-agreements --accept-package-agreements

# Install VSCode
Write-Host "Installing Visual Studio Code..." -ForegroundColor Green
winget install --id=Microsoft.VisualStudioCode -e --accept-source-agreements --accept-package-agreements

# Refresh PATH
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Install VSCode extensions
Write-Host "Installing Visual Studio Code extensions" -ForegroundColor Green
Get-Content "$repoPath\.vscode\extensions.txt" | ForEach-Object { code --install-extension $_ }

# Install Brave Browser
Write-Host "Installing Brave Browser ..." -ForegroundColor Green
winget install --id=Brave.Brave -e --accept-source-agreements --accept-package-agreements

# Install iMazing
Write-Host "Installing iMazing..." -ForegroundColor Green
winget install --id=DigiDNA.iMazing -e --accept-source-agreements --accept-package-agreements

# Install UGGREEN NAS
Write-Host "Installing UGREEN NAS..." -ForegroundColor Green
winget install --id=UGREEN.UGREENNAS -e --accept-source-agreements --accept-package-agreements

# Install Steam
Write-Host "Installing Steam..." -ForegroundColor Green
winget install --id=Valve.Steam -e --accept-source-agreements --accept-package-agreements

# Install Discord
Write-Host "Installing Discord..." -ForegroundColor Green
winget install --id=Discord.Discord -e --accept-source-agreements --accept-package-agreements

# Install League Of Legends
Write-Host "Installing League Of Legends..." -ForegroundColor Green
winget install --id=RiotGames.LeagueOfLegends.NA -e --accept-source-agreements --accept-package-agreements

###################
# SYMLINK SECTION #
###################

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

# Symlink VSCode settings.json
$vsCodePath = "$env:APPDATA\Code\User\settings.json."
if (Test-Path $vsCodePath) {
    Write-Host "Removing existing VSCode .settings file..." -ForegroundColor Yellow
    Remove-Item -Path $vsCodePath -Recurse -Force
}
New-Item -ItemType SymbolicLink -Path $vsCodePath -Target "$repoPath\.vscode\settings.json" -Force

# Symlink Terminal settings
$terminalSettingsPath = "$userPath\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (Test-Path $PROFILE) {
    Write-Host "Removing existing terminal settings..." -ForegroundColor Yellow
    Remove-Item -Path $terminalSettingsPath -Force
}
New-Item -ItemType SymbolicLink -Path $terminalSettingsPath -Target "$repoPath\.terminal\settings.json" -Force

# Symlink PowerShell Profile
if (Test-Path $PROFILE) {
    Write-Host "Removing existing powershell profile..." -ForegroundColor Yellow
    Remove-Item -Path $PROFILE -Recurse -Force
}
New-Item -ItemType SymbolicLink -Path $PROFILE -Target "$repoPath\.terminal\Microsoft.PowerShell_profile.ps1" -Force

# Symlink Brave Browser Bookmarks and Preferences 
$bravePath = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default"
if (Test-Path $bravePath) {
    Write-Host "Removing existing Brave Bookmarks and Preferences..." -ForegroundColor Yellow
    Remove-Item -Path "$bravePath\Bookmarks" -Force
    Remove-Item -Path "$bravePath\Preferences" -Force
}
New-Item -ItemType SymbolicLink -Path "$bravePath\Bookmarks" -Target "$repoPath\.brave\Bookmarks" -Force
New-Item -ItemType SymbolicLink -Path "$bravePath\Preferences" -Target "$repoPath\.brave\Preferences" -Force

###############
# OTHER STUFF #
###############

if ($setupSSH -eq "y") {
    Write-Host "Setting up GitHub SSH..." -ForegroundColor Green
    
    # Generate SSH key
    ssh-keygen -t ed25519 -C "$gitEmail" -f "$env:USERPROFILE\.ssh\id_ed25519" -N ""
    
    # Configure git
    git config --global user.email "$gitEmail"
    git config --global user.name "$gitUsername"
    
    # Start ssh-agent and add key
    Get-Service -Name ssh-agent | Set-Service -StartupType Manual
    Start-Service ssh-agents

    ssh-add "$env:USERPROFILE\.ssh\id_ed25519"
    
    Write-Host "SSH public key (add this to GitHub):" -ForegroundColor Yellow
    Get-Content "$env:USERPROFILE\.ssh\id_ed25519.pub"
}

Write-Host ""
Write-Host "Done!" -ForegroundColor Green