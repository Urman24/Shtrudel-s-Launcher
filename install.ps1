# Shtrudel's Launcher Installer for Windows
# Usage: irm https://raw.githubusercontent.com/Urman24/Shtrudel-s-Launcher/main/install.ps1 | iex

Write-Host "╔═══════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   Shtrudel's Launcher Installer       ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

Write-Host "Fetching latest release..." -ForegroundColor Yellow

try {
    $apiUrl = "https://api.github.com/repos/Urman24/Shtrudel-s-Launcher/releases/latest"
    $release = Invoke-RestMethod -Uri $apiUrl
    
    $downloadUrl = $null
    foreach ($asset in $release.assets) {
        if ($asset.name -like "*setup*" -or $asset.name -like "*.exe") {
            $downloadUrl = $asset.browser_download_url
            break
        }
    }
    
    if (-not $downloadUrl) {
        Write-Host "Error: No download URL found" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "Latest version: $($release.tag_name)" -ForegroundColor Green
    
    $tempDir = Join-Path $env:TEMP "ShtrudelInstaller"
    New-Item -ItemType Directory -Force -Path $tempDir | Out-Null
    
    $fileName = [System.IO.Path]::GetFileName($downloadUrl)
    $outputFile = Join-Path $tempDir $fileName
    
    Write-Host "Downloading $fileName..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $downloadUrl -OutFile $outputFile
    
    Write-Host "✓ Download complete!" -ForegroundColor Green
    Write-Host "Starting installer..." -ForegroundColor Yellow
    
    Start-Process -FilePath $outputFile -Wait
    
    Write-Host "✓ Installation complete!" -ForegroundColor Green
    
    # Cleanup
    Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
    exit 1
}
