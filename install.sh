# Shtrudel's Launcher Installer for Windows
# This script downloads and runs the latest installer from GitHub

Write-Host "=== Shtrudel's Launcher Installer ===" -ForegroundColor Green
Write-Host "Fetching latest release information..." -ForegroundColor White

# GitHub API URL for latest release
$apiUrl = "https://api.github.com/repos/Urman24/Shtrudel-s-Launcher/releases/latest"

try {
    # Fetch latest release info
    $releaseInfo = Invoke-RestMethod -Uri $apiUrl -ErrorAction Stop
    
    # Get download URL for setup file
    $downloadUrl = $null
    foreach ($asset in $releaseInfo.assets) {
        if ($asset.name -like "*setup*" -or $asset.name -like "*.exe") {
            $downloadUrl = $asset.browser_download_url
            break
        }
    }
    
    if (-not $downloadUrl) {
        Write-Host "Error: Could not find download file" -ForegroundColor Red
        Write-Host "Please check the repository manually: https://github.com/Urman24/Shtrudel-s-Launcher/releases/latest" -ForegroundColor Yellow
        exit 1
    }
    
    # Display release info
    $tagName = $releaseInfo.tag_name
    Write-Host "Found release: $tagName" -ForegroundColor Yellow
    
    # Set download path
    $downloadsPath = [Environment]::GetFolderPath("UserProfile") + "\Downloads"
    $fileName = [System.IO.Path]::GetFileName($downloadUrl)
    $outputFile = Join-Path $downloadsPath $fileName
    
    Write-Host "Downloading $fileName..." -ForegroundColor White
    Write-Host "URL: $downloadUrl" -ForegroundColor Gray
    
    # Download the file
    Invoke-WebRequest -Uri $downloadUrl -OutFile $outputFile -ErrorAction Stop
    
    Write-Host "✓ File downloaded successfully: $outputFile" -ForegroundColor Green
    Write-Host ""
    Write-Host "Launching installer..." -ForegroundColor Yellow
    
    # Run the installer
    Start-Process -FilePath $outputFile -Wait
    
    Write-Host "Installation completed!" -ForegroundColor Green
    
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
    exit 1
}
