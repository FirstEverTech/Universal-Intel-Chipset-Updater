# Intel Chipset Device Update Script
# Based on Intel Chipset Device Latest database
# Downloads latest INF files from GitHub and updates if newer versions available
# By Marcin Grygiel / www.firstever.tech

# =============================================
# SCRIPT VERSION - MUST BE UPDATED WITH EACH RELEASE
# =============================================
$ScriptVersion = "2026.02.0009"
# =============================================

# Convert version format for display
if ($ScriptVersion -match '^(\d+\.\d+)-(\d{4}\.\d{2}\.\d+)$') {
    # Old format: 10.1-2026.02.2 → 10.1 (2026.02.2)
    $DisplayVersion = "$($matches[1]) ($($matches[2]))"
} else {
    # New format: 2026.02.0009 → 2026.02.0009
    $DisplayVersion = $ScriptVersion
}

# =============================================
# CONFIGURATION - Set to 1 to enable debug mode
# =============================================
$DebugMode = 0  # 0 = Disabled, 1 = Enabled
$SkipSelfHashVerification = 0  # 1 = Enabled (normal operation), 1 = Disabled (for testing)
# =============================================

# GitHub repository URLs
$githubBaseUrl = "https://raw.githubusercontent.com/FirstEverTech/Universal-Intel-Chipset-Updater/main/data/"
$githubArchiveUrl = "https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/download/archive/"
$chipsetINFsUrl = $githubBaseUrl + "intel-chipset-infs-latest.md"
$downloadListUrl = $githubBaseUrl + "intel-chipset-infs-download.txt"

# Temporary directory for downloads
$tempDir = "C:\Windows\Temp\IntelChipset"

# =============================================
# ENHANCED ERROR HANDLING (BACKGROUND)
# =============================================

$global:InstallationErrors = @()
$global:ScriptStartTime = Get-Date
$global:NewVersionLaunched = $false  # Flag to signal new version launch
$global:NewerWindowsInboxVersion = $false  # Flag for newer Windows Inbox INF detection
# CHANGED: Log file now in ProgramData to prevent deletion during cleanup
$logFile = "C:\ProgramData\chipset_update.log"

# =============================================
# VERSION MANAGEMENT FUNCTIONS
# =============================================

function Get-VersionNumber {
    param([string]$Version)
    
    $oldVersionTable = @{
        "10.1-2025.11.0" = "2025.11.0001"
        "10.1-2025.11.5" = "2025.11.0002"
        "10.1-2025.11.6" = "2025.11.0003"
        "10.1-2025.11.7" = "2025.11.0004"
        "10.1-2025.11.8" = "2025.11.0005"
        "10.1-2026.02.1" = "2026.02.0006"
        "10.1-2026.02.2" = "2026.02.0007"
    }
    
    if ($oldVersionTable.ContainsKey($Version)) {
        $Version = $oldVersionTable[$Version]
    }
    
    if ($Version -match '^10\.1-(\d{4}\.\d{2}\.\d+)$') {
        $Version = $matches[1]
    }
    
    if ($Version -match '^(\d{4})\.(\d{2})\.(\d+)$') {
        return [int]$matches[3]
    }
    
    throw "Cannot parse version: $Version"
}

function Compare-Versions {
    param([string]$Version1, [string]$Version2)
    
    $ver1Num = Get-VersionNumber -Version $Version1
    $ver2Num = Get-VersionNumber -Version $Version2
    
    if ($ver1Num -eq $ver2Num) { return 0 }
    if ($ver1Num -lt $ver2Num) { return -1 }
    return 1
}

function Get-VersionForFileName {
    param([string]$Version)
    
    if ($Version -match '^10\.1-(\d{4}\.\d{2}\.\d+)$') {
        return $matches[1]
    }
    
    return $Version
}

function Get-VersionForGitHubTag {
    param([string]$Version)
    
    if ($Version -match '^10\.1-') {
        return $Version
    }
    
    return $Version
}

# =============================================
# LOGGING FUNCTIONS
# =============================================

function Write-Log {
    param([string]$Message, [string]$Type = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Type] $Message"
    try {
        Add-Content -Path $logFile -Value $logEntry -ErrorAction SilentlyContinue
    } catch {
        # Silent fallback
    }
    
    # Only show errors to user, everything else goes to log only
    if ($Type -eq "ERROR") {
        $global:InstallationErrors += $Message
        Write-Host " ERROR: $Message" -ForegroundColor Red
    }
}

function Write-DebugMessage {
    param([string]$Message, [string]$Color = "Gray")
    Write-Log -Message $Message -Type "DEBUG"
    if ($DebugMode -eq 1) {
        Write-Host " DEBUG: $Message" -ForegroundColor $Color
    }
}

function Show-FinalSummary {
    $duration = (Get-Date) - $global:ScriptStartTime
    if ($global:InstallationErrors.Count -gt 0) {
        Write-Host "`n Completed with $($global:InstallationErrors.Count) error(s)." -ForegroundColor Red
        Write-Host " See $logFile for details." -ForegroundColor Red
    } else {
        Write-Host "`n Operation completed successfully." -ForegroundColor Green
    }
    Write-Log "Script execution completed in $([math]::Round($duration.TotalMinutes, 2)) minutes with $($global:InstallationErrors.Count) errors"
}

# =============================================
# HEADER DISPLAY FUNCTION
# =============================================
function Show-Header {
    Clear-Host
    # ENTIRE HEADER on DarkBlue
    Write-Host "/*************************************************************************" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "                UNIVERSAL INTEL CHIPSET DEVICE UPDATER                 " -NoNewline -ForegroundColor White -BackgroundColor DarkBlue
    Write-Host "**" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "** --------------------------------------------------------------------- **" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**                                                                       **" -ForegroundColor Gray -BackgroundColor DarkBlue
    
    $paddedVersion = $DisplayVersion.PadRight(14)
    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "                       Tool Version: $paddedVersion                    " -NoNewline -ForegroundColor Yellow -BackgroundColor DarkBlue
    Write-Host "**" -ForegroundColor Gray -BackgroundColor DarkBlue
    
    Write-Host "**                                                                       **" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "              Author: Marcin Grygiel / www.firstever.tech              " -NoNewline -ForegroundColor Green -BackgroundColor DarkBlue
    Write-Host "**" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**                                                                       **" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "** --------------------------------------------------------------------- **" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "         This tool is not affiliated with Intel Corporation.           " -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "         INF files are sourced from official Intel servers.            " -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "         Use at your own risk.                                         " -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "** --------------------------------------------------------------------- **" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**                                                                       **" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "    Visit: GitHub.com/FirstEverTech/Universal-Intel-Chipset-Updater    " -NoNewline -ForegroundColor White -BackgroundColor DarkBlue
    Write-Host "**" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**                                                                       **" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "*************************************************************************/" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host ""
}

# =============================================
# SCREEN MANAGEMENT FUNCTIONS
# =============================================

function Show-Screen1 {
    Show-Header
    Write-Host " [SCREEN 1/4] INITIALIZATION AND SECURITY CHECKS" -ForegroundColor Cyan
    Write-Host " ===============================================" -ForegroundColor Cyan
    
    # Show configuration status
    if ($DebugMode -eq 1) {
        Write-Host " DEBUG MODE: ENABLED" -ForegroundColor Magenta
    }
    if ($SkipSelfHashVerification -eq 1) {
        Write-Host "`n SELF-HASH VERIFICATION: DISABLED (Testing Mode)" -ForegroundColor Yellow
    }
    
    Write-Host ""
    
    # Windows Version Check
    Write-Host " Checking Windows system requirements..." -ForegroundColor Yellow
    try {
        $os = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop
        $build = [int]$os.BuildNumber
        
        if ($build -lt 17763) {
            Write-Host " [WARNING] Windows 10 LTSB 2015/2016 detected." -ForegroundColor Red
            Write-Host " TLS 1.2 may not work properly." -ForegroundColor Gray
            Write-Host " Some features may be limited." -ForegroundColor Gray
        } else {
            Write-Host " Windows Build: $build" -ForegroundColor Gray
            Write-Host " Operating system compatibility: PASSED" -ForegroundColor Green
        }
    } catch {
        Write-Host " [INFO] Could not determine Windows build." -ForegroundColor Gray
    }
    Write-Host ""
    
    # .NET Framework Check
    Write-Host " Checking .NET Framework prerequisites..." -ForegroundColor Yellow
    try {
        $netRelease = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" -Name "Release" -ErrorAction Stop
        if ($netRelease -ge 461808) {
            Write-Host " .NET Framework 4.7.2 or newer detected: PASSED" -ForegroundColor Green
        } else {
            Write-Host " [WARNING] .NET Framework older than 4.7.2" -ForegroundColor Red
        }
    } catch {
        Write-Host " [WARNING] .NET Framework 4.7.2+ not found or couldn't be checked" -ForegroundColor Red
        Write-Host " This may affect GitHub connectivity." -ForegroundColor Gray
    }
    Write-Host ""
    
    # GitHub Connectivity Test
    Write-Host " Testing GitHub connectivity..." -ForegroundColor Yellow
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $null = Invoke-WebRequest -Uri "https://raw.githubusercontent.com" -UseBasicParsing -TimeoutSec 5 -ErrorAction Stop
        Write-Host " Repository access verification: PASSED" -ForegroundColor Green
    } catch {
        Write-Host " [WARNING] Cannot reach GitHub servers" -ForegroundColor Red
        Write-Host " Self-hash verification will be skipped." -ForegroundColor Gray
        Write-Host " You can still use offline INF detection." -ForegroundColor Gray
    }
    Write-Host ""
    
    # Ask user to continue if warnings were found
    Write-Host " Pre-check summary..." -ForegroundColor Yellow
    $continue = $true
    
    if ($build -lt 17763 -or !$netRelease -or $netRelease -lt 461808) {
        Write-Host " [IMPORTANT] Some issues were detected." -ForegroundColor Yellow
        Write-Host ""
        Write-Host " If you experience problems:" -ForegroundColor Gray
        Write-Host " 1. For LTSB/LTSC users: Install .NET Framework 4.8" -ForegroundColor Gray
        Write-Host " 2. For GitHub issues: Check firewall/proxy settings" -ForegroundColor Gray
        Write-Host ""
        
        do {
            $choice = Read-Host " Continue despite warnings? (Y/N)"
            $choice = $choice.Trim().ToUpper()
            
            if ($choice -ne 'Y' -and $choice -ne 'N') {
                Write-Host " Invalid input. Please enter Y or N." -ForegroundColor Red
            }
        } while ($choice -ne 'Y' -and $choice -ne 'N')
        
        if ($choice -eq 'N') {
            Write-Host " Operation cancelled." -ForegroundColor Red
            Write-Host " Press any key to exit..."
            $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
            exit 0
        }
        
        Write-Host " Continuing with limited functionality..." -ForegroundColor Yellow
        Write-Host ""
    } else {
        Write-Host " All system requirements verified successfully." -ForegroundColor Green
    }
}

function Show-Screen2 {
    Show-Header
    Write-Host " [SCREEN 2/4] HARDWARE DETECTION AND VERSION ANALYSIS" -ForegroundColor Cyan
    Write-Host " ====================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Show-Screen3 {
    Show-Header
    Write-Host " [SCREEN 3/4] UPDATE CONFIRMATION AND SYSTEM PREPARATION" -ForegroundColor Cyan
    Write-Host " =======================================================" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host " IMPORTANT NOTICE:" -ForegroundColor Yellow
    Write-Host " The INF files update process may take several minutes to complete." -ForegroundColor Yellow
    Write-Host " During installation, the screen may temporarily go black and some" -ForegroundColor Yellow
    Write-Host " devices may temporarily disconnect as PCIe bus INF files are being" -ForegroundColor Yellow
    Write-Host " updated. This is normal behavior and the system will return to" -ForegroundColor Yellow
    Write-Host " normal operation once the installation is complete." -ForegroundColor Yellow
    Write-Host ""
    $response = Read-Host " Do you want to proceed with INF files update? (Y/N)"
    
    return $response
}

function Show-Screen4 {
    Show-Header
    Write-Host " [SCREEN 4/4] DOWNLOAD AND INSTALLATION PROGRESS" -ForegroundColor Cyan
    Write-Host " ===============================================" -ForegroundColor Cyan
    Write-Host ""
}

# =============================================
# SELF-HASH VERIFICATION FUNCTION
# =============================================

function Verify-ScriptHash {
    # Skip verification if disabled in configuration
    if ($SkipSelfHashVerification -eq 1) {
        Write-Host " SKIPPED: Self-hash verification disabled (Testing Mode)." -ForegroundColor Yellow
        Write-Host ""
        return $true
    }
    
    try {
        Write-Host " Verifying Updater source file integrity..." -ForegroundColor Yellow
        
        # Get current script path using multiple methods for reliability
        $scriptPath = $null
        if ($PSCommandPath) {
            $scriptPath = $PSCommandPath
        } elseif ($MyInvocation.MyCommand.Path) {
            $scriptPath = $MyInvocation.MyCommand.Path
        } else {
            # Fallback: try to find the script in current directory
            $potentialPath = Join-Path (Get-Location) "universal-intel-chipset-updater.ps1"
            if (Test-Path $potentialPath) {
                $scriptPath = $potentialPath
            }
        }
        
        if (-not $scriptPath -or -not (Test-Path $scriptPath)) {
            Write-Host " FAIL: Cannot locate script file for hash verification." -ForegroundColor Red
            return $false
        }
        
        Write-DebugMessage "Script path: $scriptPath"
        
        # Calculate current script hash with retry logic
        $currentHash = $null
        $retryCount = 0
        $maxRetries = 3
        
        while ($retryCount -lt $maxRetries -and -not $currentHash) {
            try {
                $hashResult = Get-FileHash -Path $scriptPath -Algorithm SHA256
                $currentHash = $hashResult.Hash.ToUpper()
                Write-DebugMessage "Successfully calculated script hash (attempt $($retryCount + 1)): $currentHash"
            } catch {
                $retryCount++
                if ($retryCount -eq $maxRetries) {
                    Write-Host " FAIL: Could not calculate script hash after $maxRetries attempts." -ForegroundColor Red
                    Write-Host " Error: $($_.Exception.Message)" -ForegroundColor Red
                    return $false
                }
                Start-Sleep -Milliseconds 500
            }
        }
        
        if (-not $currentHash) {
            Write-Host " FAIL: Could not calculate script hash." -ForegroundColor Red
            return $false
        }
        
        # Construct URL for hash verification file
        $hashVersion = Get-VersionForFileName -Version $ScriptVersion
        $hashFileUrl = "https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/download/v$hashVersion/universal-intel-chipset-updater-$hashVersion-ps1.sha256"
        
        Write-DebugMessage "Downloading hash from: $hashFileUrl"
        
        # Download expected hash file
        try {
            $expectedHashResponse = Invoke-WebRequest -Uri $hashFileUrl -UseBasicParsing -ErrorAction Stop
            
            # Convert content to string properly
            $expectedHashLine = ""
            if ($expectedHashResponse.Content -is [byte[]]) {
                $expectedHashLine = [System.Text.Encoding]::UTF8.GetString($expectedHashResponse.Content).Trim()
            } else {
                $expectedHashLine = $expectedHashResponse.Content.ToString().Trim()
            }
            
            Write-DebugMessage "Raw hash file content: '$expectedHashLine'"
            
            # Parse hash from the file - handle multiple formats
            $expectedHash = $null
            $expectedFileName = $null
            
            # Try different parsing patterns
            if ($expectedHashLine -match '^([A-Fa-f0-9]{64})\s+(\S+)$') {
                # Format: HASH FILENAME
                $expectedHash = $matches[1].ToUpper()
                $expectedFileName = $matches[2]
                Write-DebugMessage "Parsed format: HASH FILENAME"
            } elseif ($expectedHashLine -match '^([A-Fa-f0-9]{64})$') {
                # Format: HASH only
                $expectedHash = $expectedHashLine.ToUpper()
                $expectedFileName = "universal-intel-chipset-updater.ps1"
                Write-DebugMessage "Parsed format: HASH only"
            } elseif ($expectedHashLine -match '^([A-Fa-f0-9]{64})\s*\*?\s*(\S+)$') {
                # Format: HASH * FILENAME (some hash tools use this)
                $expectedHash = $matches[1].ToUpper()
                $expectedFileName = $matches[2]
                Write-DebugMessage "Parsed format: HASH * FILENAME"
            }
            
            if (-not $expectedHash) {
                Write-Host " FAIL: Could not parse hash from file. Content: $expectedHashLine" -ForegroundColor Red
                return $false
            }
            
            Write-DebugMessage "Expected hash: $expectedHash"
            Write-DebugMessage "Current hash: $currentHash"
            Write-DebugMessage "Expected file: $expectedFileName"
            
            # Compare hashes
            if ($currentHash -eq $expectedHash) {
                Write-Host " Updater hash verification: PASSED" -ForegroundColor Green
                Write-Host ""
                Write-DebugMessage "Hash verification successful"
                return $true
            } else {
                Write-Host " FAIL: Updater hash verification failed. Hash doesn't match." -ForegroundColor Red
                Write-Host "`n WARNING: The updater file may have been modified or corrupted!" -ForegroundColor Red
                Write-Host " Please download the Updater from the official source:" -ForegroundColor Red
                Write-Host " https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases" -ForegroundColor Cyan
                Write-Host ""
                Write-Host " Hash verification failed: $($expectedFileName)" -ForegroundColor Yellow
                Write-Host " Source: $expectedHash" -ForegroundColor Green
                Write-Host " Actual: $currentHash" -ForegroundColor Red
                return $false
            }
        }
        catch {
            Write-Host " ERROR: Could not download or parse hash file." -ForegroundColor Red
            Write-Host " Please download the Updater from the official source and try again:" -ForegroundColor Red
            Write-Host " https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases" -ForegroundColor Red
            
            Write-Host ""
            Write-Host " Hash verification failed: universal-intel-chipset-updater.ps1" -ForegroundColor Yellow
            Write-Host " Source: I can't read the source HASH from the GitHub repository." -ForegroundColor Red
            Write-Host " Actual: $currentHash" -ForegroundColor Red
            Write-Host ""
            
            return $false
        }
    }
    catch {
        Write-Host " ERROR: Could not verify script hash." -ForegroundColor Red
        Write-Host " Error: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "`n Please download the Updater from the official source and try again:" -ForegroundColor Red
        Write-Host " https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases" -ForegroundColor Red
        
        return $false
    }
}

# =============================================
# UPDATE CHECK FUNCTION
# =============================================

function Get-DownloadsFolder {
    try {
        # Try to get Downloads folder from registry
        $registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"
        $downloadsGuid = "{374DE290-123F-4565-9164-39C4925E467B}"
        
        if (Test-Path $registryPath) {
            $downloadsValue = Get-ItemProperty -Path $registryPath -Name $downloadsGuid -ErrorAction SilentlyContinue
            if ($downloadsValue -and $downloadsValue.$downloadsGuid) {
                $downloadsPath = [Environment]::ExpandEnvironmentVariables($downloadsValue.$downloadsGuid)
                Write-DebugMessage "Found Downloads folder in registry: $downloadsPath"
                return $downloadsPath
            }
        }
        
        # Fallback to default Downloads folder
        $defaultDownloads = [Environment]::GetFolderPath("UserProfile") + "\Downloads"
        Write-DebugMessage "Using default Downloads folder: $defaultDownloads"
        return $defaultDownloads
    }
    catch {
        Write-DebugMessage "Error getting Downloads folder: $($_.Exception.Message)"
        return [Environment]::GetFolderPath("UserProfile") + "\Downloads"
    }
}

function Check-ForUpdaterUpdates {
    try {
        Write-Host " Checking for newer updater version..." -ForegroundColor Yellow
        
        # Download version file from GitHub
        $versionFileUrl = "https://raw.githubusercontent.com/FirstEverTech/Universal-Intel-Chipset-Updater/main/src/universal-intel-chipset-updater.ver"
        $latestVersionContent = Invoke-WebRequest -Uri $versionFileUrl -UseBasicParsing -ErrorAction Stop
        $latestVersion = $latestVersionContent.Content.Trim()
        
        # Compare versions using new comparison function
        $comparisonResult = Compare-Versions -Version1 $ScriptVersion -Version2 $latestVersion
        
        Write-DebugMessage "Current version: $ScriptVersion"
        Write-DebugMessage "Latest version: $latestVersion"
        Write-DebugMessage "Comparison result: $comparisonResult"
        
        if ($comparisonResult -eq 0) {
            Write-Host " Status: Already on latest version." -ForegroundColor Green
            Write-Host ""
            Write-Host " Starting hardware detection..." -ForegroundColor Gray
            Write-Host ""
            Start-Sleep -Seconds 3
            return $true
        } elseif ($comparisonResult -lt 0) {
            Write-Host " A new version $latestVersion is available (current: $ScriptVersion)." -ForegroundColor Yellow
            
            # Get valid user input
            do {
                Write-Host ""
                $continueChoice = Read-Host " Do you want to continue with the current version? (Y/N)"
                Write-Host ""
                $continueChoice = $continueChoice.Trim().ToUpper()
                
                if ($continueChoice -ne 'Y' -and $continueChoice -ne 'N') {
                    Write-Host " Invalid input. Please enter Y or N." -ForegroundColor Red
                }
            } while ($continueChoice -ne 'Y' -and $continueChoice -ne 'N')
            
            if ($continueChoice -eq 'Y') {
                return $true
            } else {
                # User chose not to continue with current version
                do {
                    $downloadChoice = Read-Host " Do you want to download the latest version? (Y/N)"
                    $downloadChoice = $downloadChoice.Trim().ToUpper()
                    
                    if ($downloadChoice -ne 'Y' -and $downloadChoice -ne 'N') {
                        Write-Host " Invalid input. Please enter Y or N." -ForegroundColor Red
                    }
                } while ($downloadChoice -ne 'Y' -and $downloadChoice -ne 'N')
                
                if ($downloadChoice -eq 'Y') {
                    # For download, use the appropriate versions for GitHub tag and file name
                    $tagVersion = Get-VersionForGitHubTag -Version $latestVersion
                    $fileVersion = Get-VersionForFileName -Version $latestVersion
                    
                    $downloadUrl = "https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/download/v$tagVersion/ChipsetUpdater-$fileVersion-Win10-Win11.exe"
                    $downloadsFolder = Get-DownloadsFolder
                    $outputPath = Join-Path $downloadsFolder "ChipsetUpdater-$fileVersion-Win10-Win11.exe"
                    
                    Write-Host " Downloading new version to:" -ForegroundColor Yellow
                    Write-Host " $outputPath" -ForegroundColor Yellow
                    Write-Host ""
                    
                    # Add retry logic and better error handling for download
                    $maxRetries = 3
                    $retryCount = 0
                    $downloadSuccess = $false
                    
                    while ($retryCount -lt $maxRetries -and -not $downloadSuccess) {
                        try {
                            Write-Host " Attempt $($retryCount + 1) of $maxRetries..." -ForegroundColor Yellow
                            Invoke-WebRequest -Uri $downloadUrl -OutFile $outputPath -UseBasicParsing -ErrorAction Stop
                            $downloadSuccess = $true
                            Write-Host " SUCCESS: New version downloaded successfully." -ForegroundColor Green
                            Write-Host "`n File saved to:" -ForegroundColor Yellow
                            Write-Host " $outputPath" -ForegroundColor Yellow
                        }
                        catch {
                            $retryCount++
                            if ($retryCount -eq $maxRetries) {
                                Write-Host " ERROR: Failed to download new version after $maxRetries attempts - $($_.Exception.Message)" -ForegroundColor Red
                                Write-Host " Please download manually from: https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases" -ForegroundColor Red
                            } else {
                                Write-Host " Download attempt $retryCount failed, retrying..." -ForegroundColor Yellow
                                Start-Sleep -Seconds 2
                            }
                        }
                    }
                    
                    if ($downloadSuccess) {
                        do {
                            $exitChoice = Read-Host "`n Do you want to exit now to run the new version? (Y/N)"
                            $exitChoice = $exitChoice.Trim().ToUpper()
                            
                            if ($exitChoice -ne 'Y' -and $exitChoice -ne 'N') {
                                Write-Host " Invalid input. Please enter Y or N." -ForegroundColor Red
                            }
                        } while ($exitChoice -ne 'Y' -and $exitChoice -ne 'N')
                        
                        if ($exitChoice -eq 'Y') {
                            Write-Host " Starting the new version and closing current updater..." -ForegroundColor Green
                            Write-Host ""
                            
                            # Start the new version WITHOUT cleaning temp files
                            Start-Process -FilePath $outputPath
                            
                            # Exit with code 100 to signal BAT to close
                            exit 100
                        } else {
                            Write-Host " Update cancelled by user." -ForegroundColor Yellow
                            Cleanup
                            Write-Host " Press any key..."
                            $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
                            Show-FinalCredits
                            exit 0
                        }
                    } else {
                        Write-Host " Update process cancelled due to download failure." -ForegroundColor Red
                        Cleanup
                        Write-Host " Press any key..."
                        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
                        Show-FinalCredits
                        exit 1
                    }
                } else {
                    # User chose not to download new version
                    Write-Host " Update cancelled by user." -ForegroundColor Yellow
                    Cleanup
                    Write-Host " Press any key..."
                    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
                    Show-FinalCredits
                    exit 0
                }
            }
        } else {
            # Current version > Latest version (shouldn't happen normally)
            Write-Host " Status: Current version appears newer than latest." -ForegroundColor Cyan
            Write-Host ""
            Write-Host " Starting hardware detection..." -ForegroundColor Gray
            Start-Sleep -Seconds 3
            return $true
        }
    }
    catch {
        Write-Host " WARNING: Could not check for updates." -ForegroundColor Yellow
        Write-Host " Error: $($_.Exception.Message)" -ForegroundColor Yellow
        Write-Host " Continuing with current version in 3 seconds..." -ForegroundColor Yellow
        Start-Sleep -Seconds 3
        return $true
    }
}

# =============================================
# FILE INTEGRITY VERIFICATION FUNCTIONS
# =============================================

function Get-FileHash256 {
    param([string]$FilePath)
    
    try {
        if (Test-Path $FilePath) {
            $hash = Get-FileHash -Path $FilePath -Algorithm SHA256
            Write-DebugMessage "Calculated SHA256 for $FilePath : $($hash.Hash)"
            return $hash.Hash
        } else {
            Write-Log "File not found for hash calculation: $FilePath" -Type "ERROR"
            return $null
        }
    } catch {
        Write-Log "Error calculating hash for $FilePath : $($_.Exception.Message)" -Type "ERROR"
        return $null
    }
}

function Verify-FileHash {
    param(
        [string]$FilePath, 
        [string]$ExpectedHash,
        [string]$HashType = "Primary",
        [string]$OriginalFileName = $null
    )

    if (-not $ExpectedHash) {
        Write-DebugMessage "No expected $HashType hash provided, skipping verification."
        return $true
    }

    $actualHash = Get-FileHash256 -FilePath $FilePath
    if (-not $actualHash) {
        Write-Log "Failed to calculate hash for $FilePath" -Type "ERROR"
        return $false
    }

    if ($actualHash -eq $ExpectedHash) {
        Write-DebugMessage "$HashType hash verification passed for $FilePath"
        Write-Host " PASS: $HashType hash verification passed." -ForegroundColor Green
        return $true
    } else {
        $displayName = if ($OriginalFileName) { $OriginalFileName } else { Split-Path $FilePath -Leaf }
        
        $errorMessage = "$HashType hash verification failed for $displayName. Source: $ExpectedHash, Actual: $actualHash"
        
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $logEntry = "[$timestamp] [ERROR] $errorMessage"
        try {
            Add-Content -Path $logFile -Value $logEntry -ErrorAction SilentlyContinue
        } catch {
            # Silent fallback
        }
        $global:InstallationErrors += $errorMessage

        Write-Host ""
        Write-Host " $HashType hash verification failed: $displayName" -ForegroundColor Red
        Write-Host " Source: $ExpectedHash" -ForegroundColor Red
        Write-Host " Actual: $actualHash" -ForegroundColor Red
        Write-Host ""
        return $false
    }
}

# =============================================
# DIGITAL SIGNATURE VERIFICATION FUNCTIONS
# =============================================

function Verify-FileSignature {
    param([string]$FilePath)

    try {
        Write-DebugMessage "Verifying digital signature for: $FilePath"
        
        $signature = Get-AuthenticodeSignature -FilePath $FilePath
        Write-DebugMessage "Signature status: $($signature.Status)"
        Write-DebugMessage "Signer: $($signature.SignerCertificate.Subject)"
        Write-DebugMessage "Signature Algorithm: $($signature.SignerCertificate.SignatureAlgorithm.FriendlyName)"

        if ($signature.Status -ne 'Valid') {
            Write-Log "Digital signature is not valid. Status: $($signature.Status)" -Type "ERROR"
            Write-Host " FAIL: Digital signature verification - Status: $($signature.Status)" -ForegroundColor Red
            return $false
        }

        if ($signature.SignerCertificate.Subject -notmatch 'CN=Intel Corporation') {
            Write-Log "File not signed by Intel Corporation. Signer: $($signature.SignerCertificate.Subject)" -Type "ERROR"
            Write-Host " FAIL: Digital signature verification - Not signed by Intel Corporation." -ForegroundColor Red
            return $false
        }

        if ($signature.SignerCertificate.SignatureAlgorithm.FriendlyName -notmatch 'sha256') {
            Write-Log "Signature not using SHA256 algorithm. Algorithm: $($signature.SignerCertificate.SignatureAlgorithm.FriendlyName)" -Type "ERROR"
            Write-Host " FAIL: Digital signature verification - Not using SHA256 algorithm" -ForegroundColor Red
            return $false
        }

        Write-Host " PASS: Digitally signed by Intel Corporation." -ForegroundColor Green
        Write-DebugMessage "Digital signature verification passed for $FilePath"
        return $true
    }
    catch {
        Write-Log "Error verifying digital signature: $($_.Exception.Message)" -Type "ERROR"
        Write-Host " FAIL: Digital signature verification - Error: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

function Verify-InstallerSignature {
    param([string]$INFPath, [string]$Prefix)

    try {
        if ($Prefix) {
            $setupPath = Join-Path $INFPath ($Prefix.TrimStart('\'))
        } else {
            $setupPath = Join-Path $INFPath "SetupChipset.exe"
        }

        Write-DebugMessage "Checking installer signature at: $setupPath"

        if (-not (Test-Path $setupPath)) {
            Write-Log "Installer not found for signature verification: $setupPath" -Type "ERROR"
            return $false
        }

        return Verify-FileSignature -FilePath $setupPath
    }
    catch {
        Write-Log "Error in installer signature verification: $($_.Exception.Message)" -Type "ERROR"
        return $false
    }
}

# =============================================
# UPDATED PARSER FOR EXTENDED FORMAT
# =============================================

function Parse-DownloadList {
    param([string]$DownloadListContent)

    Write-DebugMessage "Starting download list parsing."
    $downloadData = @{}
    
    try {
        $blocks = $DownloadListContent -split "`n`n" | Where-Object { $_.Trim() }

        Write-DebugMessage "Found $($blocks.Count) blocks in download list."

        foreach ($block in $blocks) {
            $name = $null
            $infVer = $null
            $link = $null
            $prefix = $null
            $variant = "Consumer"
            $sha256 = $null
            $backup = $null
            $sha256_b = $null
            $prefix_b = $null

            $lines = $block -split "`n" | ForEach-Object { $_.Trim() }
            foreach ($line in $lines) {
                if ($line -match '^Name\s*=\s*(.+)') {
                    $name = $matches[1]
                } elseif ($line -match '^INFVer\s*=\s*[^,]+,([0-9.]+)') {
                    $infVer = $matches[1]
                } elseif ($line -match '^Link\s*=\s*(.+)') {
                    $link = $matches[1]
                } elseif ($line -match '^Prefix\s*=\s*(.+)') {
                    $prefix = $matches[1]
                } elseif ($line -match '^Variant\s*=\s*(.+)') {
                    $variant = $matches[1]
                } elseif ($line -match '^SHA256\s*=\s*([A-F0-9]+)') {
                    $sha256 = $matches[1]
                } elseif ($line -match '^Backup\s*=\s*(.+)') {
                    $backup = $matches[1]
                } elseif ($line -match '^SHA256_B\s*=\s*([A-F0-9]+)') {
                    $sha256_b = $matches[1]
                } elseif ($line -match '^Prefix_B\s*=\s*(.+)') {
                    $prefix_b = $matches[1]
                }
            }

            if ($infVer -and $link) {
                $key = "$infVer-$variant"
                $downloadData[$key] = @{
                    Name = $name
                    INFVer = $infVer
                    Link = $link
                    Prefix = $prefix
                    Variant = $variant
                    SHA256 = $sha256
                    Backup = $backup
                    SHA256_B = $sha256_b
                    Prefix_B = $prefix_b
                }
                Write-DebugMessage "Added download entry: $key -> $name"
            } else {
                Write-DebugMessage "Skipping incomplete block - missing INFVer or Link."
            }
        }

        Write-DebugMessage "Download list parsing completed. Found $($downloadData.Count) entries."
        return $downloadData
    }
    catch {
        Write-Log "Download list parsing failed: $($_.Exception.Message)" -Type "ERROR"
        return @{}
    }
}

# =============================================
# ENHANCED DOWNLOAD FUNCTION
# =============================================

function Download-Extract-File {
    param(
        [string]$Url, 
        [string]$OutputPath, 
        [string]$Prefix, 
        [string]$ExpectedHash,
        [string]$SourceName = "Primary"
    )

    try {
        $tempFile = "$tempDir\temp_$(Get-Random).$([System.IO.Path]::GetExtension($Url).TrimStart('.'))"

        Write-DebugMessage "Downloading from $SourceName source: $Url to $tempFile"
        Write-Host " Downloading from $SourceName source..." -ForegroundColor Yellow
        
        $downloadSuccess = $true
        $downloadError = $null
        
        try {
            Invoke-WebRequest -Uri $Url -OutFile $tempFile -UseBasicParsing -ErrorAction Stop
        } catch {
            $downloadSuccess = $false
            $downloadError = $_.Exception.Message
        }

        if (-not $downloadSuccess) {
            Write-Log "Download failed for $SourceName source $Url : $downloadError" -Type "ERROR"
            return @{ Success = $false; ErrorType = "DownloadFailed"; Message = "Download failed: $downloadError" }
        }

        if (-not (Test-Path $tempFile)) {
            return @{ Success = $false; ErrorType = "DownloadFailed"; Message = "File not found after download" }
        }

        if ($ExpectedHash) {
            Write-Host " Verifying $SourceName source file integrity..." -ForegroundColor Yellow
            $originalFileName = [System.IO.Path]::GetFileName($Url)
            if (-not (Verify-FileHash -FilePath $tempFile -ExpectedHash $ExpectedHash -HashType $SourceName -OriginalFileName $originalFileName)) {
                Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
                return @{ Success = $false; ErrorType = "HashMismatch"; Message = "Hash verification failed." }
            }
        }

        $fileExtension = [System.IO.Path]::GetExtension($Url).ToLower()
        
        if ($fileExtension -eq '.zip') {
            try {
                Add-Type -AssemblyName System.IO.Compression.FileSystem
                [System.IO.Compression.ZipFile]::ExtractToDirectory($tempFile, $OutputPath)
                Write-Host " ZIP file extracted successfully." -ForegroundColor Green
                Write-DebugMessage "ZIP extraction successful to: $OutputPath"
            } catch {
                try {
                    Write-Host " Using COM object for ZIP extraction..." -ForegroundColor Yellow
                    $shell = New-Object -ComObject Shell.Application
                    $zipFolder = $shell.NameSpace($tempFile)
                    $destFolder = $shell.NameSpace($OutputPath)
                    $destFolder.CopyHere($zipFolder.Items(), 0x14)
                    Write-Host " ZIP file extracted successfully using COM." -ForegroundColor Green
                } catch {
                    Write-Log "Error extracting ZIP file: $_" -Type "ERROR"
                    return @{ Success = $false; ErrorType = "ExtractionFailed"; Message = "ZIP extraction failed.: $_" }
                }
            }
        } elseif ($fileExtension -eq '.exe') {
            New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null

            if ($Prefix -and $Prefix -ne '\SetupChipset.exe') {
                $subDir = Split-Path $Prefix.TrimStart('\') -Parent
                if ($subDir) {
                    $fullOutputPath = Join-Path $OutputPath $subDir
                    New-Item -ItemType Directory -Path $fullOutputPath -Force | Out-Null
                    Write-DebugMessage "Created subdirectory: $fullOutputPath"
                }

                $outputFile = Join-Path $OutputPath ($Prefix.TrimStart('\'))
                Copy-Item $tempFile $outputFile -Force
                Write-Host " EXE file copied to: $outputFile" -ForegroundColor Green
            } else {
                Copy-Item $tempFile "$OutputPath\SetupChipset.exe" -Force
                Write-Host " EXE file copied to: $OutputPath\SetupChipset.exe" -ForegroundColor Green
            }
        } else {
            Write-Log "Unknown file type: $fileExtension" -Type "ERROR"
            return @{ Success = $false; ErrorType = "UnknownFileType"; Message = "Unknown file type: $fileExtension" }
        }

        Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
        Write-DebugMessage "Removed temporary file: $tempFile"
        return @{ Success = $true; ErrorType = "None"; Message = "Success" }
    }
    catch {
        Write-Log "Error in Download-Extract-File: $_" -Type "ERROR"
        return @{ Success = $false; ErrorType = "UnknownError"; Message = "Unexpected error: $_" }
    }
}

# =============================================
# HARDWARE DETECTION FUNCTIONS
# =============================================

function Get-IntelChipsetHWIDs {
    $intelChipsets = @()
    $chipsetCount = 0
    $nonChipsetCount = 0

    try {
        $pciDevices = Get-PnpDevice -Class 'System' -ErrorAction SilentlyContinue | 
                      Where-Object { $_.HardwareID -like '*PCI\VEN_8086*' -and $_.Status -eq 'OK' }

        foreach ($device in $pciDevices) {
            foreach ($hwid in $device.HardwareID) {
                if ($hwid -match 'PCI\\VEN_8086&DEV_([A-F0-9]{4})') {
                    $deviceId = $matches[1]
                    $description = $device.FriendlyName

                    if ($description -match 'Chipset|LPC|PCI Express Root Port|PCI-to-PCI bridge|Motherboard Resources') {
                        $intelChipsets += [PSCustomObject]@{
                            HWID = $deviceId
                            Description = $description
                            HardwareID = $hwid
                            InstanceId = $device.InstanceId
                            IsChipset = $true
                        }
                        $chipsetCount++
                    } else {
                        $nonChipsetCount++
                    }
                }
            }
        }

        if ($intelChipsets.Count -eq 0) {
            foreach ($device in $pciDevices) {
                foreach ($hwid in $device.HardwareID) {
                    if ($hwid -match 'PCI\\VEN_8086&DEV_([A-F0-9]{4})') {
                        $deviceId = $matches[1]
                        $description = $device.FriendlyName

                        $intelChipsets += [PSCustomObject]@{
                            HWID = $deviceId
                            Description = $description
                            HardwareID = $hwid
                            InstanceId = $device.InstanceId
                            IsChipset = $false
                        }
                        $chipsetCount++

                        if ($intelChipsets.Count -ge 5) { break }
                    }
                }
                if ($intelChipsets.Count -ge 5) { break }
            }
        }

        Write-DebugMessage "Scanning completed: found $chipsetCount potential chipset devices and $nonChipsetCount non-chipset devices"
        return $intelChipsets | Sort-Object HWID -Unique
    }
    catch {
        Write-Log "Hardware detection failed: $($_.Exception.Message)" -Type "ERROR"
        return @{}
    }
}

function Get-CurrentINFVersion {
    param([string]$DeviceInstanceId)

    try {
        $device = Get-PnpDevice | Where-Object {$_.InstanceId -eq $DeviceInstanceId}
        if ($device) {
            $versionProperty = $device | Get-PnpDeviceProperty -KeyName "DEVPKEY_Device_DriverVersion" -ErrorAction SilentlyContinue
            if ($versionProperty -and $versionProperty.Data) {
                Write-DebugMessage "Got version from DEVPKEY_Device_DriverVersion: $($versionProperty.Data)"
                return $versionProperty.Data
            }
            
            $infVersionProperty = $device | Get-PnpDeviceProperty -KeyName "DEVPKEY_Device_INFVersion" -ErrorAction SilentlyContinue
            if ($infVersionProperty -and $infVersionProperty.Data) {
                Write-DebugMessage "Got version from DEVPKEY_Device_INFVersion: $($infVersionProperty.Data)"
                return $infVersionProperty.Data
            }
        }

        $driverInfo = Get-CimInstance -ClassName Win32_PnPSignedDriver | Where-Object { 
            $_.DeviceID -eq $DeviceInstanceId -and $_.DriverVersion
        } | Select-Object -First 1

        if ($driverInfo) {
            Write-DebugMessage "Got version from WMI: $($driverInfo.DriverVersion)"
            return $driverInfo.DriverVersion
        }

        Write-DebugMessage "Could not determine version for device: $DeviceInstanceId"
        return $null
    }
    catch {
        Write-DebugMessage "Error getting INF version: $_"
        return $null
    }
}

# =============================================
# TEMP DIRECTORY CLEANUP FUNCTION
# =============================================

function Clear-TempINFFolders {
    try {
        if (Test-Path $tempDir) {
            Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
            Write-DebugMessage "Cleaned up temporary directory: $tempDir"
        }
    }
    catch {
        Write-DebugMessage "Error during cleanup: $_"
    }
}

# =============================================
# DATA DOWNLOAD AND PARSING FUNCTIONS
# =============================================

function Get-LatestINFInfo {
    param([string]$Url)

    try {
        $cacheBuster = "t=" + (Get-Date -Format 'yyyyMMddHHmmss')
        if ($Url.Contains('?')) {
            $finalUrl = $Url + "&" + $cacheBuster
        } else {
            $finalUrl = $Url + "?" + $cacheBuster
        }
        
        Write-DebugMessage "Downloading from: $finalUrl (with cache-buster)"
        $content = Invoke-WebRequest -Uri $finalUrl -UseBasicParsing -ErrorAction Stop
        Write-DebugMessage "Successfully downloaded content from $finalUrl"
        return $content.Content
    }
    catch {
        Write-Log "Error downloading from GitHub: `n $($_.Exception.Message)" -Type "ERROR"
        return $null
    }
}

function Parse-ChipsetINFsFromMarkdown {
    param([string]$MarkdownContent)

    Write-DebugMessage "Starting Markdown parsing."
    $chipsetData = @{}
    
    try {
        $lines = $MarkdownContent -split "`n"
        $currentPlatform = $null
        $currentGeneration = $null
        $inMainstreamSection = $false
        $inWorkstationSection = $false
        $inXeonSection = $false
        $inAtomSection = $false

        for ($i = 0; $i -lt $lines.Count; $i++) {
            $line = $lines[$i].Trim()

            if ($line -match '^### Mainstream Desktop/Mobile') {
                $inMainstreamSection = $true
                $inWorkstationSection = $false
                $inXeonSection = $false
                $inAtomSection = $false
                Write-DebugMessage "Entered Mainstream Desktop/Mobile section."
                continue
            }
            elseif ($line -match '^### Workstation/Enthusiast') {
                $inMainstreamSection = $false
                $inWorkstationSection = $true
                $inXeonSection = $false
                $inAtomSection = $false
                Write-DebugMessage "Entered Workstation/Enthusiast section."
                continue
            }
            elseif ($line -match '^### Xeon/Server Platforms') {
                $inMainstreamSection = $false
                $inWorkstationSection = $false
                $inXeonSection = $true
                $inAtomSection = $false
                Write-DebugMessage "Entered Xeon/Server Platforms section."
                continue
            }
            elseif ($line -match '^### Atom/Low-Power Platforms') {
                $inMainstreamSection = $false
                $inWorkstationSection = $false
                $inXeonSection = $false
                $inAtomSection = $true
                Write-DebugMessage "Entered Atom/Low-Power Platforms section."
                continue
            }

            if ($line -match '^####\s+(.+)') {
                $currentPlatform = $matches[1]
                
                if ($inMainstreamSection) {
                    $sectionName = "Mainstream Desktop/Mobile"
                } elseif ($inWorkstationSection) {
                    $sectionName = "Workstation/Enthusiast"
                } elseif ($inXeonSection) {
                    $sectionName = "Xeon/Server Platforms"
                } elseif ($inAtomSection) {
                    $sectionName = "Atom/Low-Power Platforms"
                } else {
                    $sectionName = "Unknown"
                }
                
                Write-DebugMessage "Processing platform: $currentPlatform ($sectionName)"
                continue
            }

            if ($line -match '\*\*Generation:\*\*\s*(.+)') {
                $currentGeneration = $matches[1]
                Write-DebugMessage "Generation: $currentGeneration"
                continue
            }

            if ($line -match '^\|.*INF.*\|.*Package.*\|.*Version.*\|.*Date.*\|.*HWIDs.*\|$' -and $currentPlatform) {
                Write-DebugMessage "Found table for platform: $currentPlatform"
                $i++

                while ($i -lt $lines.Count -and $lines[$i].Trim() -match '^\|.*\|.*\|.*\|.*\|.*\|$') {
                    $dataLine = $lines[$i].Trim()
                    $i++

                    if ($dataLine -match '^\|\s*:---') { continue }

                    $columns = $dataLine.Split('|', [System.StringSplitOptions]::RemoveEmptyEntries) | ForEach-Object { $_.Trim() }
                    if ($columns.Count -ge 5) {
                        $inf = $columns[0]
                        $package = $columns[1]
                        $version = $columns[2]
                        $date = $columns[3] -replace '\\', ''
                        $hwIds = $columns[4] -split ',' | ForEach-Object { $_.Trim() }

                        Write-DebugMessage "Parsed row: INF=$inf, Package=$package, Version=$version, HWIDs=$($hwIds -join ',')"

                        foreach ($hwId in $hwIds) {
                            if ($hwId -match '^[A-F0-9]{4}$') {
                                $chipsetData[$hwId] = @{
                                    Platform = $currentPlatform
                                    Section = $sectionName
                                    Generation = $currentGeneration
                                    INF = $inf
                                    Package = $package
                                    Version = $version
                                    Date = $date
                                    HasAsterisk = $date -match '\*$'
                                    IsWindowsInbox = ($package -eq "None")
                                }
                                Write-DebugMessage "Added HWID: $hwId for platform $currentPlatform (Package: $package, IsWindowsInbox: $($package -eq 'None'))"
                            } else {
                                Write-DebugMessage "Skipping invalid HWID: $hwId"
                            }
                        }
                    }
                }
            }
        }

        Write-DebugMessage "Markdown parsing completed. Found $($chipsetData.Count) HWID entries."
        return $chipsetData
    }
    catch {
        Write-Log "Markdown parsing failed: $($_.Exception.Message)" -Type "ERROR"
        return @{}
    }
}

# =============================================
# INSTALLATION FUNCTION
# =============================================

function Install-ChipsetINF {
    param([string]$INFPath, [string]$Prefix)

    try {
        if ($Prefix) {
            $setupPath = Join-Path $INFPath ($Prefix.TrimStart('\'))
        } else {
            $setupPath = Join-Path $INFPath "SetupChipset.exe"
        }

        Write-DebugMessage "Installing from path: $setupPath"

        if (Test-Path $setupPath) {
            # Determine if this is MSI or EXE installer
            $isMSI = $setupPath -match '\.msi$'
            
            if ($isMSI) {
                # MSI installer - verify hash instead of digital signature
                Write-Host " Verifying MSI installer integrity..." -ForegroundColor Yellow
                
                # Extract version from path to download hash file
                if ($INFPath -match '(\d+\.\d+\.\d+\.\d+)') {
                    $version = $matches[1]
                    Write-DebugMessage "Extracted version for MSI verification: $version"
                    
                    try {
                        $hashUrl = $githubArchiveUrl + "intel_chipset_$version.msi.sha256"
                        Write-DebugMessage "Downloading MSI hash from: $hashUrl"
                        
                        $hashResponse = Invoke-WebRequest -Uri $hashUrl -UseBasicParsing -ErrorAction Stop
                        $hashContent = $hashResponse.Content
                        if ($hashContent -is [byte[]]) {
                            $hashContent = [System.Text.Encoding]::UTF8.GetString($hashContent)
                        } else {
                            $hashContent = $hashContent.ToString()
                        }
                        
                        # Remove BOM if present and trim whitespace
                        $hashContent = $hashContent.Trim()
                        # Remove UTF-8 BOM character (U+FEFF)
                        if ($hashContent.Length -gt 0 -and [int][char]$hashContent[0] -eq 0xFEFF) {
                            $hashContent = $hashContent.Substring(1).Trim()
                        }
                        # Also try to remove common BOM byte sequences
                        $hashContent = $hashContent.TrimStart([char]0xEF, [char]0xBB, [char]0xBF).Trim()
                        
                        Write-DebugMessage "Hash file content: $hashContent"
                        
                        if ($hashContent -match '^([A-F0-9]{64})\s+') {
                            $expectedHash = $matches[1]
                            Write-DebugMessage "Expected MSI hash: $expectedHash"
                            
                            $actualHash = (Get-FileHash -Path $setupPath -Algorithm SHA256).Hash
                            Write-DebugMessage "Actual MSI hash: $actualHash"
                            
                            if ($actualHash -eq $expectedHash) {
                                Write-Host " MSI integrity verification: PASSED" -ForegroundColor Green
                                Write-DebugMessage "MSI hash verification successful"
                            } else {
                                Write-Log "MSI hash mismatch for $setupPath" -Type "ERROR"
                                Write-Host " ERROR: MSI integrity verification failed. Hash mismatch." -ForegroundColor Red
                                Write-Host " Expected: $expectedHash" -ForegroundColor Yellow
                                Write-Host " Actual:   $actualHash" -ForegroundColor Yellow
                                return $false
                            }
                        } else {
                            Write-Log "Invalid hash file format from $hashUrl" -Type "ERROR"
                            Write-Host " WARNING: Could not parse hash file. Proceeding with caution..." -ForegroundColor Yellow
                        }
                    }
                    catch {
                        Write-DebugMessage "Could not verify MSI hash: $($_.Exception.Message)"
                        Write-Host " WARNING: Could not verify MSI hash (file may not be available yet)." -ForegroundColor Yellow
                        Write-Host " ZIP archive was already verified. Proceeding with installation..." -ForegroundColor Yellow
                    }
                } else {
                    Write-Host " WARNING: Could not extract version for MSI verification." -ForegroundColor Yellow
                }
            } else {
                # EXE installer - verify digital signature (original behavior)
                Write-Host " Verifying installer digital signature..." -ForegroundColor Yellow
                if (-not (Verify-FileSignature -FilePath $setupPath)) {
                    Write-Log "Installer digital signature verification failed. Aborting installation." -Type "ERROR"
                    Write-Host " ERROR: Installer digital signature verification failed. Installation aborted." -ForegroundColor Red
                    return $false
                }
            }

            Write-Host ""
            Write-Host " IMPORTANT NOTICE:" -ForegroundColor Yellow
            Write-Host " The INF files updater is now running." -ForegroundColor Yellow
            Write-Host " Please DO NOT close this window or interrupt the process." -ForegroundColor Yellow
            Write-Host " The system may appear unresponsive during installation - this is normal." -ForegroundColor Yellow
            Write-Host ""

            if ($isMSI) {
                # MSI installation
                Write-Host " Running installer: SetupChipset.msi" -ForegroundColor Cyan
                Write-DebugMessage "Starting MSI installer with msiexec: /i /quiet /norestart"
                
                $process = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$setupPath`" /quiet /norestart" -Wait -PassThru -NoNewWindow
                
                # MSI exit codes: 0 = success, 3010 = success with reboot required
                if ($process.ExitCode -eq 0 -or $process.ExitCode -eq 3010) {
                    Write-Host " INF files installed successfully." -ForegroundColor Green
                    if ($process.ExitCode -eq 3010) {
                        Write-Host " (Reboot required to complete installation)" -ForegroundColor Yellow
                    }
                    Write-DebugMessage "MSI installer completed successfully with exit code: $($process.ExitCode)"
                    return $true
                } else {
                    Write-Log "MSI installer failed with exit code: $($process.ExitCode)" -Type "ERROR"
                    Write-Host " ERROR: MSI installation failed with exit code: $($process.ExitCode)" -ForegroundColor Red
                    return $false
                }
            } else {
                # EXE installation (original behavior)
                Write-Host " Running installer: SetupChipset.exe" -ForegroundColor Cyan
                Write-DebugMessage "Starting installer with arguments: -S -OVERALL -downgrade -norestart"

                $process = Start-Process -FilePath $setupPath -ArgumentList "-S -OVERALL -downgrade -norestart" -Wait -PassThru

                if ($process.ExitCode -eq 0 -or $process.ExitCode -eq 3010) {
                    Write-Host " INF files installed successfully." -ForegroundColor Green
                    Write-DebugMessage "Installer completed successfully with exit code: $($process.ExitCode)"
                    return $true
                } else {
                    Write-Log "Installer failed with exit code: $($process.ExitCode)" -Type "ERROR"
                    return $false
                }
            }
        } else {
            Write-Log "Installer not found at: $setupPath" -Type "ERROR"
            
            # Try to find alternative installers (both EXE and MSI)
            $installers = Get-ChildItem -Path $INFPath -Filter "*.exe" -Recurse | Where-Object {
                $_.Name -like "*Setup*" -or $_.Name -like "*Install*"
            }
            
            if (-not $installers) {
                $installers = Get-ChildItem -Path $INFPath -Filter "*.msi" -Recurse | Where-Object {
                    $_.Name -like "*Setup*" -or $_.Name -like "*Install*"
                }
            }
            
            if ($installers) {
                Write-Host " Found alternative installer: $($installers[0].FullName)" -ForegroundColor Yellow
                
                $altIsMSI = $installers[0].Name -match '\.msi$'
                if (-not $altIsMSI) {
                    Write-Host " Verifying alternative installer digital signature..." -ForegroundColor Yellow
                    if (-not (Verify-FileSignature -FilePath $installers[0].FullName)) {
                        Write-Log "Alternative installer digital signature verification failed." -Type "ERROR"
                        return $false
                    }
                }
                
                return Install-ChipsetINF -INFPath $INFPath -Prefix "\$($installers[0].Name)"
            }
            return $false
        }
    }
    catch {
        Write-Log "Error running installer: $_" -Type "ERROR"
        return $false
    }
}

# =============================================
# CUSTOM PAUSE FUNCTION WITH SPACES
# =============================================

function Invoke-PauseSpaced {
    Write-Host " Press any key to continue..." -NoNewline
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    Write-Host ""
}

# =============================================
# SUPPORT MESSAGE FUNCTION
# =============================================

function Show-SupportMessage {
    Write-Host ""
    Write-Host " SUPPORT THIS PROJECT" -ForegroundColor Magenta
    Write-Host " ====================" -ForegroundColor Magenta
    Write-Host ""
    Write-Host " This project is maintained in my free time."
    Write-Host " Your support ensures regular updates and compatibility."
    Write-Host ""
    Write-Host " Support options:"
    Write-Host ""
    Write-Host " - PayPal Donation: tinyurl.com/fet-paypal" -ForegroundColor Green
    Write-Host " - Buy Me a Coffee: tinyurl.com/fet-coffee" -ForegroundColor Green
    Write-Host " - GitHub Sponsors: tinyurl.com/fet-github" -ForegroundColor Green
    Write-Host ""
    Write-Host " If this project helped you, please consider:"
    Write-Host ""
    Write-Host " - Giving it a STAR on GitHub"
    Write-Host " - Sharing with friends and colleagues"
    Write-Host " - Reporting issues or suggesting features"
    Write-Host " - Supporting development financially"
    Write-Host ""
    Write-Host ""
    Write-Host " CAREER OPPORTUNITY" -ForegroundColor Magenta
    Write-Host " ==================" -ForegroundColor Magenta
    Write-Host ""
    Write-Host " I'm currently seeking new challenges where I can apply my expertise" -ForegroundColor Yellow
    Write-Host " in solving complex IT infrastructure problems. If your organization" -ForegroundColor Yellow
    Write-Host " struggles with system compatibility, automation, or tooling gaps," -ForegroundColor Yellow
    Write-Host " let's discuss how I can help." -ForegroundColor Yellow
    Write-Host ""
    Write-Host " Connect with me: https://linkedin.com/in/marcin-grygiel" -ForegroundColor White -BackgroundColor DarkBlue
}

# =============================================
# FINAL CREDITS FUNCTION
# =============================================

function Show-FinalCredits {
    Clear-Host
    Write-Host "/*************************************************************************" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "                UNIVERSAL INTEL CHIPSET DEVICE UPDATER                 " -NoNewline -ForegroundColor White -BackgroundColor DarkBlue
    Write-Host "**" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "** --------------------------------------------------------------------- **" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**                                                                       **" -ForegroundColor Gray -BackgroundColor DarkBlue
    
    $paddedVersion = $DisplayVersion.PadRight(14)
    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "                       Tool Version: $paddedVersion                    " -NoNewline -ForegroundColor Yellow -BackgroundColor DarkBlue
    Write-Host "**" -ForegroundColor Gray -BackgroundColor DarkBlue
    
    Write-Host "**                                                                       **" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "              Author: Marcin Grygiel / www.firstever.tech              " -NoNewline -ForegroundColor Green -BackgroundColor DarkBlue
    Write-Host "**" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**                                                                       **" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "** --------------------------------------------------------------------- **" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "         This tool is not affiliated with Intel Corporation.           " -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "         INF files are sourced from official Intel servers.            " -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "         Use at your own risk.                                         " -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "** --------------------------------------------------------------------- **" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**                                                                       **" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "         GitHub: FirstEverTech/Universal-Intel-Chipset-Updater         " -NoNewline -ForegroundColor White -BackgroundColor DarkBlue
    Write-Host "**" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**                                                                       **" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "*************************************************************************/" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host ""
    
    Write-Host " THANK YOU FOR USING UNIVERSAL INTEL CHIPSET DEVICE UPDATER" -ForegroundColor Cyan
    Write-Host " ==========================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host " I hope this tool has been helpful in updating your system." -ForegroundColor Yellow
    Write-Host ""
    
    # Display support message
    Show-SupportMessage    
    Write-Host "`n Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
}

# =============================================
# CLEANUP FUNCTION
# =============================================

function Cleanup {
    Write-Host "`n Cleaning up temporary files..." -ForegroundColor Yellow
    if (Test-Path $tempDir) {
        try {
            Remove-Item -Path $tempDir -Recurse -Force -ErrorAction Stop
            Write-Host " Temporary files cleaned successfully." -ForegroundColor Green
        }
        catch {
            Write-Host " Warning: Could not clean all temporary files." -ForegroundColor Yellow
        }
    }
}

# =============================================
# MAIN SCRIPT EXECUTION
# =============================================

try {
    # SCREEN 1: Initialization and Security Checks (includes pre-checks)
    Show-Screen1
    
    # Run self-hash verification (can be skipped with configuration)
    Write-Host ""
    if (-not (Verify-ScriptHash)) {
        Write-Host " Update process aborted for security reasons." -ForegroundColor Red
        Cleanup
        Write-Host "`n Press any key..."
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        Show-FinalCredits
        exit 1
    }

    # Check for updater updates
    $updateCheckResult = Check-ForUpdaterUpdates
    if (-not $updateCheckResult) {
        exit 100
    }

    # Create temporary directory
    Clear-TempINFFolders
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
    Write-DebugMessage "Created temporary directory: $tempDir"

    # SCREEN 2: Hardware Detection and Version Analysis
    Show-Screen2

    # Detect Intel Chipset HWIDs
    $detectedIntelChipsets = Get-IntelChipsetHWIDs

    if ($detectedIntelChipsets.Count -eq 0) {
        Write-Host " No Intel chipset devices found." -ForegroundColor Yellow
        Write-Host " If you have an Intel platform, make sure you have at least" -ForegroundColor Yellow
        Write-Host " SandyBridge or newer platform." -ForegroundColor Yellow
        Cleanup
        Write-Host "`n Press any key..."
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        Show-FinalCredits
        exit
    }

    Write-Host " Found $($detectedIntelChipsets.Count) Intel chipset device(s)" -ForegroundColor Green

    # Debug information
    if ($DebugMode -eq 1) {
        Write-Host "`n === DEBUG INFORMATION ===" -ForegroundColor Cyan
        Write-Host " Checking versions for detected devices:" -ForegroundColor Gray
        foreach ($device in $detectedIntelChipsets) {
            $currentVersion = Get-CurrentINFVersion -DeviceInstanceId $device.InstanceId
            Write-Host " Device: $($device.Description)" -ForegroundColor Gray
            Write-Host "   HWID: $($device.HWID) | Version: $currentVersion" -ForegroundColor Gray
        }
        Write-Host " === END DEBUG ===`n" -ForegroundColor Cyan
    }

    # Download latest INF information
    Write-Host " Downloading latest INF information..." -ForegroundColor Yellow
    $chipsetInfo = Get-LatestINFInfo -Url $chipsetINFsUrl
    $downloadListInfo = Get-LatestINFInfo -Url $downloadListUrl

    if (-not $chipsetInfo -or -not $downloadListInfo) {
        Write-Host " Failed to download INF information. Exiting." -ForegroundColor Red
        Cleanup
        Write-Host "`n Press any key..."
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        Show-FinalCredits
        exit
    }

    # Parse INF information
    Write-Host " Parsing INF information..." -ForegroundColor Green
    $chipsetData = Parse-ChipsetINFsFromMarkdown -MarkdownContent $chipsetInfo
    $downloadData = Parse-DownloadList -DownloadListContent $downloadListInfo

    if ($chipsetData.Count -eq 0 -or $downloadData.Count -eq 0) {
        Write-Host " Error: Could not parse INF information." -ForegroundColor Red
        Write-Host " Please check the format of markdown and download list files." -ForegroundColor Yellow
        Cleanup
        Write-Host "`n Press any key..."
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        Show-FinalCredits
        exit
    }

    # Find matching chipset platforms
    $matchingChipsets = @()
    $chipsetUpdateAvailable = $false
    $windowsInboxPlatformsFound = @()

    foreach ($device in $detectedIntelChipsets) {
        $hwId = $device.HWID
        
        if ($chipsetData.ContainsKey($hwId)) {
            $chipsetInfo = $chipsetData[$hwId]

            # Check if this platform uses Windows inbox drivers (Package = None)
            if ($chipsetInfo.IsWindowsInbox) {
                $windowsInboxPlatformsFound += @{
                    HWID = $hwId
                    Description = $device.Description
                    Platform = $chipsetInfo.Platform
                    Generation = $chipsetInfo.Generation
                    Version = $chipsetInfo.Version
                }
                Write-Host " WINDOWS INBOX DRIVERS: $($chipsetInfo.Platform) (HWID: $hwId)" -ForegroundColor Cyan
                Write-Host " This platform uses Windows 11 24H2 inbox drivers - no separate INF installation required." -ForegroundColor Cyan
                Write-Host " Intel no longer includes these PCH IDs in Chipset Device Software packages." -ForegroundColor Cyan
                continue
            }

            $currentVersion = Get-CurrentINFVersion -DeviceInstanceId $device.InstanceId

            $matchingChipsets += @{
                Device = $device
                ChipsetInfo = $chipsetInfo
                CurrentVersion = $currentVersion
                HardwareID = $device.HardwareID
                InstanceId = $device.InstanceId
            }

            Write-Host " Found compatible platform: $($chipsetInfo.Platform) (HWID: $hwId)" -ForegroundColor Green
            Write-DebugMessage "Platform match: $($chipsetInfo.Platform) - Current: $currentVersion, Latest: $($chipsetInfo.Version)"
        }
    }

    # Display information about Windows inbox platforms
    if ($windowsInboxPlatformsFound.Count -gt 0) {
        Write-Host "`n === WINDOWS INBOX DRIVERS DETECTED ===" -ForegroundColor Cyan
        Write-Host " The following platforms use Windows 11 24H2 inbox drivers:" -ForegroundColor Cyan
        Write-Host ""
        foreach ($inboxPlatform in $windowsInboxPlatformsFound) {
            Write-Host " $($inboxPlatform.Platform)" -ForegroundColor White
            if ($inboxPlatform.Generation) {
                Write-Host "   Generation: $($inboxPlatform.Generation)" -ForegroundColor Gray
            }
            Write-Host "   HWID: $($inboxPlatform.HWID)" -ForegroundColor Gray
            Write-Host "   Version: $($inboxPlatform.Version)" -ForegroundColor Gray
            Write-Host "   Status: Using Windows inbox drivers" -ForegroundColor Green
            Write-Host ""
        }
        Write-Host "`n These platforms do not require separate INF installation." -ForegroundColor Cyan
        Write-Host " Intel provides these drivers directly through Windows Update." -ForegroundColor Cyan
        Write-Host ""
    }

    if ($matchingChipsets.Count -eq 0) {
        if ($windowsInboxPlatformsFound.Count -gt 0) {
            Write-Host "`n No additional Intel chipset platforms requiring updates found." -ForegroundColor Yellow
            Write-Host " Your system uses Windows inbox drivers for the detected Intel platforms." -ForegroundColor Green
        } else {
            Write-Host "`n No compatible Intel chipset platform detected." -ForegroundColor Yellow
            Write-Host " If you use an Intel system, ensure it is Sandy Bridge or newer." -ForegroundColor Yellow
            Write-Host "`n Note: Very recent platforms (Arrow Lake-S / Z890 and newer) use Windows" -ForegroundColor Yellow
            Write-Host "       inbox drivers and therefore may not be included in Intel packages." -ForegroundColor Yellow
        }
        Cleanup
        Write-Host "`n Press any key..."
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        Show-FinalCredits
        exit
    }

    # Group by platform
    $uniquePlatforms = @{}
    foreach ($match in $matchingChipsets) {
        $platform = $match.ChipsetInfo.Platform
        $package = $match.ChipsetInfo.Package

        if (-not $uniquePlatforms.ContainsKey($platform)) {
            $uniquePlatforms[$platform] = @{
                ChipsetInfo = $match.ChipsetInfo
                Devices = @($match.Device)
                CurrentVersions = @()
            }
        }

        if ($match.CurrentVersion) {
            $uniquePlatforms[$platform].CurrentVersions += $match.CurrentVersion
        }
    }

    Write-DebugMessage "About to display platform information. uniquePlatforms count: $($uniquePlatforms.Count)"
    Write-DebugMessage "matchingChipsets count: $($matchingChipsets.Count)"
    
    # Longer delay to ensure visibility
    Start-Sleep -Seconds 2
    
    Write-DebugMessage "After 2 second delay, now displaying platform information..."

    # Display platform information
    Write-Host "`n =============== Platform Information ===============" -ForegroundColor Cyan

    $hasAnyAsterisk = $false
    $hasNewerWindowsInbox = $false
    
    Write-DebugMessage "Starting platform display loop. Platform count: $($uniquePlatforms.Count)"

    foreach ($platformName in $uniquePlatforms.Keys) {
        Write-DebugMessage "Displaying platform: $platformName"
        
        $platformData = $uniquePlatforms[$platformName]
        $chipsetInfo = $platformData.ChipsetInfo
        $devices = $platformData.Devices
        $currentVersions = $platformData.CurrentVersions | Sort-Object -Unique

        Write-Host " Platform: $platformName" -ForegroundColor White
        if ($chipsetInfo.Generation) {
            Write-Host " Generation: $($chipsetInfo.Generation)" -ForegroundColor Gray
        }

        if ($currentVersions.Count -gt 0) {
            Write-Host " Current Version: $(($currentVersions -join ', ')) ---> Latest Version: $($chipsetInfo.Version)" -ForegroundColor Gray
        } else {
            Write-Host " Current Version: Unable to determine --->  Latest Version: $($chipsetInfo.Version)" -ForegroundColor Gray
        }

        $installerVersionDisplay = "$($chipsetInfo.Package) ($($chipsetInfo.Date))"
        Write-Host " Installer Version: $installerVersionDisplay" -ForegroundColor Yellow

        $needsUpdate = $false
        $newerVersionDetected = $false
        
        if ($currentVersions.Count -gt 0) {
            foreach ($currentVersion in $currentVersions) {
                # Convert to Version objects for proper comparison
                try {
                    $currentVer = [version]$currentVersion
                    $latestVer = [version]$chipsetInfo.Version
                    
                    if ($currentVer -gt $latestVer) {
                        $newerVersionDetected = $true
                        break
                    }
                    elseif ($currentVer -ne $latestVer) {
                        $needsUpdate = $true
                        break
                    }
                }
                catch {
                    # Fallback to string comparison if version parsing fails
                    Write-DebugMessage "Version parsing failed for comparison: Current=$currentVersion, Latest=$($chipsetInfo.Version)"
                    if ($currentVersion -ne $chipsetInfo.Version) {
                        $needsUpdate = $true
                        break
                    }
                }
            }

            if ($newerVersionDetected) {
                Write-Host " Status: Newer INF version detected (Windows Inbox)." -ForegroundColor Cyan
                $hasNewerWindowsInbox = $true
            }
            elseif (-not $needsUpdate) {
                Write-Host " Status: Already on latest version." -ForegroundColor Green
            }
            else {
                $currentVersionsText = $currentVersions -join ', '
                Write-Host " Status: Update available - current: $currentVersionsText, latest: $($chipsetInfo.Version)" -ForegroundColor Yellow
                $chipsetUpdateAvailable = $true
            }
        }
        else {
            Write-Host " Status: INF files will be installed" -ForegroundColor Yellow
            $chipsetUpdateAvailable = $true
        }

        if ($chipsetInfo.HasAsterisk) {
            $hasAnyAsterisk = $true
        }

        Write-Host ""
        Write-DebugMessage "Finished displaying platform: $platformName"
    }
    
    Write-DebugMessage "Finished all platform displays. hasAnyAsterisk: $hasAnyAsterisk, hasNewerWindowsInbox: $hasNewerWindowsInbox"

    # Display asterisk note only once if any platform has it
    if ($hasAnyAsterisk) {
        Write-Host " Note: INF files marked with (*) do not have embedded dates" -ForegroundColor Yellow
        Write-Host "       and will show as 07/18/1968 in system. The actual" -ForegroundColor Yellow
        Write-Host "       INF files release corresponds to the installer date." -ForegroundColor Yellow
        Write-Host ""
    }
    
    # Display Windows Inbox note only once if any platform has it
    if ($hasNewerWindowsInbox) {
        Write-Host " Note: This INF file was installed via Windows Update" -ForegroundColor Yellow
        Write-Host "       and is not yet included in any Intel package." -ForegroundColor Yellow
        Write-Host "       Installing an older INF version is not recommended." -ForegroundColor Yellow
        Write-Host ""
    }

    if ($chipsetUpdateAvailable) {
        Write-Host " A newer version of the INF files is available." -ForegroundColor Green
        $response = Read-Host " Do you want to install the latest INF files? (Y/N)"
        if ($response -ne "Y" -and $response -ne "y") {
            Write-Host "`n Installation cancelled." -ForegroundColor Yellow
            Cleanup
            Write-Host "`n Press any key..."
            $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
            Show-FinalCredits
            exit
        }
    }
    else {
        if ($uniquePlatforms.Count -gt 0) {
            if ($hasNewerWindowsInbox) {
                Write-Host " Some platforms have newer INF versions (Windows Inbox) than available" -ForegroundColor Cyan
                Write-Host " in Intel packages. Installing an older INF version is not recommended." -ForegroundColor Cyan
                Write-Host ""
            }
            else {
                Write-Host " All platforms are up to date." -ForegroundColor Green
                Write-Host ""
            }
            
            $response = Read-Host " Do you want to force reinstall this INF files anyway? (Y/N)"
            if ($response -eq "Y" -or $response -eq "y") {
                $chipsetUpdateAvailable = $true
            }
            else {
                Write-Host "`n Installation cancelled." -ForegroundColor Yellow
                Cleanup
                Write-Host "`n Press any key..."
                $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
                Show-FinalCredits
                exit
            }
        }
    }

    # SCREEN 3: Update Confirmation and System Preparation
    $response = Show-Screen3

    if ($chipsetUpdateAvailable -and ($response -eq "Y" -or $response -eq "y")) {
        Write-Host "`n Starting INF files update process..." -ForegroundColor Green

        # CREATE SYSTEM RESTORE POINT
        Write-Host " Creating system restore point..." -ForegroundColor Yellow
        
        $restorePointCreated = $false
        $restorePointDescription = "Before Intel Chipset INF Update - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        
        try {
            try {
                $null = Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue
            } catch {
                Write-DebugMessage "System restore might already be enabled or not available: $($_.Exception.Message)"
            }
            
            $warningMessages = @()
            Checkpoint-Computer -Description $restorePointDescription -RestorePointType "MODIFY_SETTINGS" -WarningVariable warningMessages -WarningAction SilentlyContinue -ErrorAction Stop
            
            if ($warningMessages.Count -gt 0) {
                $warningText = $warningMessages -join " "
                if ($warningText -match "1440 minutes" -or $warningText -match "past.*minutes") {
                    throw "RestorePointFrequencyLimit"
                }
            }
            
            $restorePointCreated = $true
            Write-Host " System restore point created successfully: " -ForegroundColor Green
            Write-Host " '$restorePointDescription'" -ForegroundColor Green
            Write-DebugMessage "System restore point created: $restorePointDescription"
            
            # 5 seconds delay after success
            Write-Host "`n Preparing for installation..." -ForegroundColor Yellow
            Start-Sleep -Seconds 5
        }
        catch {
            $errorMessage = $_.Exception.Message
            
            if ($errorMessage -match "RestorePointFrequencyLimit" -or $errorMessage -match "1440 minutes" -or $errorMessage -match "past.*minutes") {
                Write-Log "Failed to create system restore point." -Type "ERROR"
                Write-Host "`n IMPORTANT NOTICE:" -ForegroundColor Yellow
                Write-Host " Another restore point was created within the last 24 hours." -ForegroundColor Yellow
                Write-Host " Windows currently cannot create more restore points." -ForegroundColor Yellow
                Write-Host " You can delete existing restore points or retry the installation later." -ForegroundColor Yellow
                Write-Host ""
                $continueResponse = Read-Host " Do you want to continue without creating a restore point? (Y/N)"
                if ($continueResponse -ne "Y" -and $continueResponse -ne "y") {
                    Write-Host "`n Installation cancelled." -ForegroundColor Yellow
                    Cleanup
                    Write-Host "`n Press any key..."
                    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
                    Show-FinalCredits
                    exit
                }
            } else {
                Write-Log "Failed to create system restore point." -Type "ERROR"
                Write-Host " WARNING: Could not create system restore point. Continuing anyway..." -ForegroundColor Yellow
                Write-Host " If the update causes issues, you may not be able to easily revert the changes." -ForegroundColor Yellow
            }
            
            # 5 seconds delay after error
            Write-Host "`n Preparing for installation..." -ForegroundColor Gray
            Start-Sleep -Seconds 5
        }

        # SCREEN 4: Download and Installation Progress
        Show-Screen4

        $packageGroups = @{}
        foreach ($platformName in $uniquePlatforms.Keys) {
            $platformData = $uniquePlatforms[$platformName]
            $packageVersion = $platformData.ChipsetInfo.Package
            
            if (-not $packageGroups.ContainsKey($packageVersion)) {
                $packageGroups[$packageVersion] = @()
            }
            $packageGroups[$packageVersion] += $platformName
        }

        $sortedPackages = $packageGroups.Keys | Sort-Object { [version]($_ -replace '\s*\(S\)\s*', '') } -Descending
        Write-DebugMessage "Package groups: $($packageGroups.Count) unique packages"

        $successCount = 0
        $processedPackages = @{}

        foreach ($packageVersion in $sortedPackages) {
            $platforms = $packageGroups[$packageVersion]
            Write-Host " Package $packageVersion for platforms:" -ForegroundColor Cyan
            Write-Host " " -NoNewline
            Write-Host "$($platforms -join ', ')"
    
            Write-DebugMessage "Processing package: $packageVersion for platforms: $($platforms -join ', ')"

            $variant = "Consumer"
            if ($packageVersion -match '\(S\)$') {
                $variant = "Server"
            }
            Write-DebugMessage "Determined variant: $variant"

            $cleanPackageVersion = $packageVersion -replace '\s*\(S\)\s*', ''
            $downloadKey = "$cleanPackageVersion-$variant"
            Write-DebugMessage "Looking for download key: $downloadKey"

            if ($downloadData.ContainsKey($downloadKey)) {
                $downloadInfo = $downloadData[$downloadKey]
                $driverPath = "$tempDir\$cleanPackageVersion-$variant"

                $downloadSuccess = $false
                $usedBackup = $false
                $errorPhase = $null

                Write-Host "`n Attempting download from primary source..." -ForegroundColor Yellow
                $primaryResult = Download-Extract-File -Url $downloadInfo.Link -OutputPath $driverPath -Prefix $downloadInfo.Prefix -ExpectedHash $downloadInfo.SHA256 -SourceName "Primary"

                if ($primaryResult.Success) {
                    $downloadSuccess = $true
                    Write-Host " SUCCESS: Primary source - download and hash verification successful." -ForegroundColor Green
                } else {
                    if ($primaryResult.ErrorType -eq "DownloadFailed") {
                        Write-Host " FAILED: Primary source - download failed." -ForegroundColor Red
                        $errorPhase = "1a"
                    } elseif ($primaryResult.ErrorType -eq "HashMismatch") {
                        $errorPhase = "1b"
                    } else {
                        Write-Host " FAILED: Primary source - unexpected error." -ForegroundColor Red
                        $errorPhase = "1x"
                    }

                    if ($downloadInfo.Backup) {
                        Write-Host " Attempting download from backup source..." -ForegroundColor Yellow
                        # Backup uses same Prefix and SHA256 as primary (same file)
                        $backupPrefix = $downloadInfo.Prefix
                        $backupHash = $downloadInfo.SHA256
                        
                        $backupResult = Download-Extract-File -Url $downloadInfo.Backup -OutputPath $driverPath -Prefix $backupPrefix -ExpectedHash $backupHash -SourceName "Backup"
                        
                        if ($backupResult.Success) {
                            $downloadSuccess = $true
                            $usedBackup = $true
                            Write-Host " SUCCESS: Backup source - download and hash verification successful." -ForegroundColor Green
                        } else {
                            if ($backupResult.ErrorType -eq "DownloadFailed") {
                                Write-Host " FAILED: Backup source - download failed." -ForegroundColor Red
                                $errorPhase = "2a"
                            } elseif ($backupResult.ErrorType -eq "HashMismatch") {
                                $errorPhase = "2b"
                            } else {
                                Write-Host " FAILED: Backup source - unexpected error." -ForegroundColor Red
                                $errorPhase = "2x"
                            }
                        }
                    } else {
                        Write-Host " No backup source available" -ForegroundColor Red
                    }
                }

                if (-not $downloadSuccess) {
                    switch ($errorPhase) {
                        "1a" { 
                            Write-Host "`n ERROR: Primary source download failed and no backup available." -ForegroundColor Red
                            Write-Host " Check your internet connection or the primary URL." -ForegroundColor Yellow
                        }
                        "1b" { 
                            Write-Host "`n ERROR: Primary source file corrupted (hash mismatch) and no backup available" -ForegroundColor Red
                            Write-Host " The downloaded file may be tampered or incomplete." -ForegroundColor Yellow
                        }
                        "2a" { 
                            Write-Host "`n ERROR: Both primary and backup sources download failed." -ForegroundColor Red
                            Write-Host " Check your internet connection and URL availability." -ForegroundColor Yellow
                        }
                        "2b" { 
                            Write-Host "`n ERROR: Both primary and backup sources have hash mismatches" -ForegroundColor Red
                            Write-Host " Files may be corrupted on both servers." -ForegroundColor Yellow
                        }
                        default {
                            Write-Host "`n ERROR: Unknown download error" -ForegroundColor Red
                        }
                    }
                    continue
                }

                if (Install-ChipsetINF -INFPath $driverPath -Prefix $downloadInfo.Prefix) {
                    $successCount++
                    $processedPackages[$cleanPackageVersion] = $true
                    Write-Host " Successfully installed package $cleanPackageVersion for $($platforms.Count) platform(s)." -ForegroundColor Green
                    Write-DebugMessage "Installation successful for package: $cleanPackageVersion"
                } else {
                    Write-Host " Failed to install INF files." -ForegroundColor Red
                    Write-DebugMessage "Installation failed for package: $cleanPackageVersion"
                }
            } else {
                Write-Host " Error: Download information not found for package version $cleanPackageVersion (variant: $variant)" -ForegroundColor Red
                Write-Host " Please check intel_chipset_infs_download.txt for missing entries." -ForegroundColor Yellow
                Write-DebugMessage "Download key not found: $downloadKey"
            }
        }

        if ($successCount -gt 0) {
            Write-Host "`n IMPORTANT NOTICE:" -ForegroundColor Yellow
            Write-Host " Computer restart is required to complete INF installation!" -ForegroundColor Yellow
            
            Write-Host "`n Summary: Installed $successCount unique package(s) for all detected platforms." -ForegroundColor Green
            Write-DebugMessage "Installation summary: $successCount successful packages."
        } else {
            Write-Host "`n No INF files were successfully installed." -ForegroundColor Red
            Write-DebugMessage "No packages were successfully installed."
        }
    } else {
        Write-Host "`n Update cancelled." -ForegroundColor Yellow
        Write-DebugMessage "User cancelled the update."
    }

    # Clean up
    Cleanup

    # Show final summary
    Show-FinalSummary

    Write-Host "`n INF files update process completed." -ForegroundColor Cyan
    Write-Host " If you have any issues with this tool, please report them at:"
    Write-Host " https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater" -ForegroundColor Cyan

    if ($DebugMode -eq 1) {
        Write-Host "`n [DEBUG MODE ENABLED - All debug messages were shown]" -ForegroundColor Magenta
    }

    Write-Host "`n Press any key..."
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')

    # Show final credits
    Show-FinalCredits
    exit 0
}
catch {
    Write-Log "Unhandled error in main execution: $($_.Exception.Message)" -Type "ERROR"
    Write-Host " An unexpected error occurred. Please check the log file at $logFile for details." -ForegroundColor Red
    Cleanup
    Write-Host "`n Press any key..."
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    Show-FinalCredits
    exit 1
}