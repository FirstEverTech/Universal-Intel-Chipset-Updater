# Intel Chipset Device Update Script
# Based on Intel Chipset Device Latest database
# Downloads latest INF files from GitHub and updates if newer versions available
# By Marcin Grygiel / www.firstever.tech

# =============================================
# SCRIPT VERSION - MUST BE UPDATED WITH EACH RELEASE
# =============================================
$ScriptVersion = "10.1-2025.11.8"
# =============================================

# =============================================
# CONFIGURATION - Set to 1 to enable debug mode
# =============================================
$DebugMode = 0  # 0 = Disabled, 1 = Enabled
$SkipSelfHashVerification = 0  # 0 = Enabled (normal operation), 1 = Disabled (for testing)
# =============================================

# GitHub repository URLs
$githubBaseUrl = "https://raw.githubusercontent.com/FirstEverTech/Universal-Intel-Chipset-Updater/main/data/"
$chipsetINFsUrl = $githubBaseUrl + "intel-chipset-infs-latest.md"
$downloadListUrl = $githubBaseUrl + "intel-chipset-infs-download.txt"

# Temporary directory for downloads
$tempDir = "C:\Windows\Temp\IntelChipset"

# =============================================
# ENHANCED ERROR HANDLING (BACKGROUND)
# =============================================

$global:InstallationErrors = @()
$global:ScriptStartTime = Get-Date
$logFile = "$tempDir\chipset_update.log"

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
    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "                     INFs Version: 10.1 (2025.11.8)                    " -NoNewline -ForegroundColor Yellow -BackgroundColor DarkBlue
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
        $hashFileUrl = "https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/download/v$ScriptVersion/universal-intel-chipset-updater-$ScriptVersion-ps1.sha256"
        
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
                Write-Host " PASS: Updater hash verification passed." -ForegroundColor Green
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
            Write-Host "`n Please download the Updater from the official source and try again:" -ForegroundColor Red
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
        Write-Host "`n Checking for newer updater version..." -ForegroundColor Yellow
        
        # Download version file from GitHub
        $versionFileUrl = "https://raw.githubusercontent.com/FirstEverTech/Universal-Intel-Chipset-Updater/main/src/universal-intel-chipset-updater.ver"
        $latestVersionContent = Invoke-WebRequest -Uri $versionFileUrl -UseBasicParsing -ErrorAction Stop
        $latestVersion = $latestVersionContent.Content.Trim()
        
        Write-DebugMessage "Current version: $ScriptVersion, Latest version: $latestVersion"
        
        # Direct comparison - no normalization needed
        if ($ScriptVersion -eq $latestVersion) {
            Write-Host " Status: Already on latest version." -ForegroundColor Green
            Write-Host ""
            Write-Host " Starting the updater..." -ForegroundColor Gray
            Write-Host ""
            Start-Sleep -Seconds 3
            return $true
        } else {
            Write-Host " A new version $latestVersion is available (current: $ScriptVersion)." -ForegroundColor Yellow
            
            # Get valid user input
            do {
                $continueChoice = Read-Host "`n Do you want to continue with the current version? (Y/N)"
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
                    # For download, use the exact version from GitHub
                    $downloadUrl = "https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/download/v$latestVersion/ChipsetUpdater-$latestVersion-Win10-Win11.exe"
                    $downloadsFolder = Get-DownloadsFolder
                    $outputPath = Join-Path $downloadsFolder "ChipsetUpdater-$latestVersion-Win10-Win11.exe"
                    
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
                            Write-Host "`n SUCCESS: New version downloaded successfully." -ForegroundColor Green
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
                            
                            # Start the new version WITHOUT cleaning temp files
                            Start-Process -FilePath $outputPath
                            
                            # Exit immediately without any user interaction
                            # Use exit code 0 to indicate successful launch of new version
                            exit 0
                        } else {
                            Write-Host "`n Update cancelled by user." -ForegroundColor Yellow
                            Cleanup
                            Write-Host "`n Press any key..." -ForegroundColor Yellow
                            $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
                            Show-FinalCredits
                            exit 0
                        }
                    } else {
                        Write-Host "`n Update process cancelled due to download failure." -ForegroundColor Red
                        Cleanup
                        Write-Host "`n Press any key..." -ForegroundColor Yellow
                        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
                        Show-FinalCredits
                        exit 1
                    }
                } else {
                    # User chose not to download new version
                    Write-Host "`n Update cancelled by user." -ForegroundColor Yellow
                    Cleanup
                    Write-Host "`n Press any key..." -ForegroundColor Yellow
                    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
                    Show-FinalCredits
                    exit 0
                }
            }
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
        Write-Log "Error downloading from GitHub: $($_.Exception.Message)" -Type "ERROR"
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
            Write-Host " Verifying installer digital signature..." -ForegroundColor Yellow
            if (-not (Verify-FileSignature -FilePath $setupPath)) {
                Write-Log "Installer digital signature verification failed. Aborting installation." -Type "ERROR"
                Write-Host " ERROR: Installer digital signature verification failed. Installation aborted." -ForegroundColor Red
                return $false
            }

            Write-Host ""
            Write-Host " IMPORTANT NOTICE:" -ForegroundColor Yellow
            Write-Host " The INF files updater is now running." -ForegroundColor Yellow
            Write-Host " Please DO NOT close this window or interrupt the process." -ForegroundColor Yellow
            Write-Host " The system may appear unresponsive during installation - this is normal." -ForegroundColor Yellow
            Write-Host ""

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
        } else {
            Write-Log "Installer not found at: $setupPath" -Type "ERROR"
            $exeFiles = Get-ChildItem -Path $INFPath -Filter "*.exe" -Recurse | Where-Object {
                $_.Name -like "*Setup*" -or $_.Name -like "*Install*"
            }
            if ($exeFiles) {
                Write-Host " Found alternative installer: $($exeFiles[0].FullName)" -ForegroundColor Yellow
                Write-Host " Verifying alternative installer digital signature..." -ForegroundColor Yellow
                if (-not (Verify-FileSignature -FilePath $exeFiles[0].FullName)) {
                    Write-Log "Alternative installer digital signature verification failed." -Type "ERROR"
                    return $false
                }
                return Install-ChipsetINF -INFPath $INFPath -Prefix "\$($exeFiles[0].Name)"
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
    Write-Host " - PayPal Donation: tinyurl.com/fet-paypal" -ForegroundColor Yellow
    Write-Host " - Buy Me a Coffee: tinyurl.com/fet-coffee" -ForegroundColor Yellow
    Write-Host " - GitHub Sponsors: tinyurl.com/fet-github" -ForegroundColor Yellow
    Write-Host ""
    Write-Host " If this project helped you, please consider:"
    Write-Host ""
    Write-Host " - Giving it a STAR on GitHub"
    Write-Host " - Sharing with friends and colleagues"
    Write-Host " - Reporting issues or suggesting features"
    Write-Host " - Supporting development financially"
    Write-Host ""
    Write-Host " Thank you for using Universal Intel Chipset Device Updater!"
}

# =============================================
# FINAL CREDITS FUNCTION
# =============================================

function Show-FinalCredits {
    Clear-Host
    # USING YOUR ORIGINAL BANNER - NOT CHANGING IT!
    Write-Host "/*************************************************************************" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "                UNIVERSAL INTEL CHIPSET DEVICE UPDATER                 " -NoNewline -ForegroundColor White -BackgroundColor DarkBlue
    Write-Host "**" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "** --------------------------------------------------------------------- **" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**                                                                       **" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "                     INFs Version: 10.1 (2025.11.7)                    " -NoNewline -ForegroundColor Yellow -BackgroundColor DarkBlue
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
    Write-Host " We hope this tool has been helpful in updating your system." -ForegroundColor Yellow
    Write-Host ""
    
    # Display support message
    Show-SupportMessage
    
    Write-Host ""
    Write-Host " This tool will close automatically in 10 seconds..." -ForegroundColor Green
    Start-Sleep -Seconds 10
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
    # SCREEN 1: Initialization and Security Checks
    Show-Screen1
    
    # Run self-hash verification (can be skipped with configuration)
    if (-not (Verify-ScriptHash)) {
        Write-Host "`n Update process aborted for security reasons." -ForegroundColor Red
        Cleanup
        Write-Host "`n Press any key..." -ForegroundColor Yellow
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        Show-FinalCredits
        exit 1
    }

    # Check for updater updates
    $updateCheckResult = Check-ForUpdaterUpdates
    if (-not $updateCheckResult) {
        Write-Host "`n Update process cancelled or failed." -ForegroundColor Yellow
        Cleanup
        Write-Host "`n Press any key..." -ForegroundColor Yellow
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        Show-FinalCredits
        exit 1
    }

    Write-Host " Scanning for Intel Chipset..." -ForegroundColor Green
    Write-Host ""

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
        Write-Host " If you have an Intel platform, make sure you have at least SandyBridge or newer platform." -ForegroundColor Yellow
        Cleanup
        Write-Host "`n Press any key..." -ForegroundColor Yellow
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
    Write-Host " Downloading latest INF information..." -ForegroundColor Green
    $chipsetInfo = Get-LatestINFInfo -Url $chipsetINFsUrl
    $downloadListInfo = Get-LatestINFInfo -Url $downloadListUrl

    if (-not $chipsetInfo -or -not $downloadListInfo) {
        Write-Host " Failed to download INF information. Exiting." -ForegroundColor Red
        Cleanup
        Write-Host "`n Press any key..." -ForegroundColor Yellow
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
        Write-Host "`n Press any key..." -ForegroundColor Yellow
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
        Write-Host " These platforms do not require separate INF installation." -ForegroundColor Cyan
        Write-Host " Intel provides these drivers directly through Windows Update." -ForegroundColor Cyan
        Write-Host ""
    }

    if ($matchingChipsets.Count -eq 0) {
        if ($windowsInboxPlatformsFound.Count -gt 0) {
            Write-Host " No additional Intel chipset platforms requiring updates found." -ForegroundColor Yellow
            Write-Host " Your system uses Windows inbox drivers for the detected Intel platforms." -ForegroundColor Green
        } else {
            Write-Host " No compatible Intel chipset platforms found." -ForegroundColor Yellow
            Write-Host " If you have an Intel platform, make sure you have at least SandyBridge or newer platform." -ForegroundColor Yellow
            Write-Host " Note: Very new platforms (Arrow Lake-S/Z890 and newer) use Windows inbox drivers" -ForegroundColor Yellow
            Write-Host " and are not included in Intel Chipset Device Software packages." -ForegroundColor Yellow
        }
        Cleanup
        Write-Host "`n Press any key..." -ForegroundColor Yellow
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

    # Display platform information
    Write-Host "`n === Platform Information ===" -ForegroundColor Cyan

    $hasAnyAsterisk = $false

    foreach ($platformName in $uniquePlatforms.Keys) {
        $platformData = $uniquePlatforms[$platformName]
        $chipsetInfo = $platformData.ChipsetInfo
        $devices = $platformData.Devices
        $currentVersions = $platformData.CurrentVersions | Sort-Object -Unique

        Write-Host " Platform: $platformName" -ForegroundColor White
        if ($chipsetInfo.Generation) {
            Write-Host " Generation: $($chipsetInfo.Generation)" -ForegroundColor Gray
        }

        if ($currentVersions.Count -gt 0) {
            Write-Host " Current Version: $(($currentVersions -join ', '))" -ForegroundColor Gray
        } else {
            Write-Host " Current Version: Unable to determine" -ForegroundColor Gray
        }

        Write-Host " Latest Version: $($chipsetInfo.Version)" -ForegroundColor Gray

        $installerVersionDisplay = "$($chipsetInfo.Package) ($($chipsetInfo.Date))"
        Write-Host " Installer Version: $installerVersionDisplay" -ForegroundColor Yellow

        $needsUpdate = $false
        if ($currentVersions.Count -gt 0) {
            foreach ($currentVersion in $currentVersions) {
                if ($currentVersion -ne $chipsetInfo.Version) {
                    $needsUpdate = $true
                    break
                }
            }

            if (-not $needsUpdate) {
                Write-Host " Status: Already on latest version." -ForegroundColor Green
            } else {
                $currentVersionsText = $currentVersions -join ', '
                Write-Host " Status: Update available - current: $currentVersionsText, latest: $($chipsetInfo.Version)" -ForegroundColor Yellow
                $chipsetUpdateAvailable = $true
            }
        } else {
            Write-Host " Status: INF files will be installed" -ForegroundColor Yellow
            $chipsetUpdateAvailable = $true
        }

        if ($chipsetInfo.HasAsterisk) {
            $hasAnyAsterisk = $true
        }

        Write-Host ""
    }

    if ($hasAnyAsterisk) {
        Write-Host " Note: INF files marked with (*) do not have embedded dates" -ForegroundColor Yellow
        Write-Host "       and will show as 07/18/1968 in system. The actual" -ForegroundColor Yellow
        Write-Host "       INF files release corresponds to the installer date." -ForegroundColor Yellow
        Write-Host ""
    }

    if ((-not $chipsetUpdateAvailable) -and ($uniquePlatforms.Count -gt 0)) {
        Write-Host " All platforms are up to date." -ForegroundColor Green
        $response = Read-Host " Do you want to force reinstall this INF files anyway? (Y/N)"
        if ($response -eq "Y" -or $response -eq "y") {
            $chipsetUpdateAvailable = $true
        } else {
            Write-Host "`n Installation cancelled." -ForegroundColor Yellow
            Cleanup
            Write-Host "`n Press any key..." -ForegroundColor Yellow
            $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
            Show-FinalCredits
            exit
        }
    }

    # SCREEN 3: Update Confirmation and System Preparation
    Show-Screen3

    if ($chipsetUpdateAvailable) {
        Write-Host " IMPORTANT NOTICE:" -ForegroundColor Yellow
        Write-Host " The INF files update process may take several minutes to complete." -ForegroundColor Yellow
        Write-Host " During installation, the screen may temporarily go black and some" -ForegroundColor Yellow
        Write-Host " devices may temporarily disconnect as PCIe bus INF files are being" -ForegroundColor Yellow
        Write-Host " updated. This is normal behavior and the system will return to" -ForegroundColor Yellow
        Write-Host " normal operation once the installation is complete." -ForegroundColor Yellow
        Write-Host ""
        $response = Read-Host " Do you want to proceed with INF files update? (Y/N)"
    } else {
        $response = "N"
    }

    if ($response -eq "Y" -or $response -eq "y") {
        Write-Host "`n Starting INF files update process..." -ForegroundColor Green

        # CREATE SYSTEM RESTORE POINT
        Write-Host " Creating system restore point..." -ForegroundColor Yellow
        try {
            $restorePointDescription = "Before Intel Chipset INF Update - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
            
            try {
                $null = Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue
            } catch {
                Write-DebugMessage "System restore might already be enabled or not available: $($_.Exception.Message)"
            }
            
            Checkpoint-Computer -Description $restorePointDescription -RestorePointType "MODIFY_SETTINGS"
            Write-Host " System restore point created successfully: " -ForegroundColor Green
            Write-Host " '$restorePointDescription'" -ForegroundColor Green
            Write-DebugMessage "System restore point created: $restorePointDescription"
            
            # 5 seconds delay after success
            Write-Host "`n Preparing for installation..." -ForegroundColor Yellow
            Start-Sleep -Seconds 5
        }
        catch {
            Write-Log "Failed to create system restore point: $($_.Exception.Message)" -Type "ERROR"
            Write-Host " WARNING: Could not create system restore point. Continuing anyway..." -ForegroundColor Yellow
            Write-Host " If the update causes issues, you may not be able to easily revert the changes." -ForegroundColor Yellow
            
            # 5 seconds delay after error
            Write-Host "`n Preparing for installation..." -ForegroundColor Yellow
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
            
            Write-Host " Package $packageVersion for platforms: $($platforms -join ', ')" -ForegroundColor Cyan
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
                        $backupPrefix = if ($downloadInfo.Prefix_B) { $downloadInfo.Prefix_B } else { $downloadInfo.Prefix }
                        
                        $backupResult = Download-Extract-File -Url $downloadInfo.Backup -OutputPath $driverPath -Prefix $backupPrefix -ExpectedHash $downloadInfo.SHA256_B -SourceName "Backup"
                        
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

                if (Install-ChipsetINF -INFPath $driverPath -Prefix $(if ($usedBackup -and $downloadInfo.Prefix_B) { $downloadInfo.Prefix_B } else { $downloadInfo.Prefix })) {
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

    Write-Host "`n Press any key..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')

    # Show final credits
    Show-FinalCredits
    exit 0
}
catch {
    Write-Log "Unhandled error in main execution: $($_.Exception.Message)" -Type "ERROR"
    Write-Host " An unexpected error occurred. Please check the log file at $logFile for details." -ForegroundColor Red
    Cleanup
    Write-Host "`n Press any key..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    Show-FinalCredits
    exit 1
}