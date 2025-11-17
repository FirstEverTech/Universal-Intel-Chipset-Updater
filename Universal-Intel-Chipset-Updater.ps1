# Intel Chipset Drivers Update Script
# Based on Intel Chipset Drivers Latest database
# Downloads latest drivers from GitHub and updates if newer versions available
# By Marcin Grygiel / www.firstever.tech

# Check if running as administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script requires administrator privileges. Please run PowerShell as Administrator." -ForegroundColor Red
    exit
}

# GitHub repository URLs
$githubBaseUrl = "https://raw.githubusercontent.com/FirstEverTech/Universal-Intel-Chipset-Updater/main/"
$chipsetDriversUrl = $githubBaseUrl + "Intel_Chipset_Drivers_Latest.md"
$downloadListUrl = $githubBaseUrl + "Intel_Chipset_Drivers_Download.txt"

# Temporary directory for downloads
$tempDir = "C:\Windows\Temp\IntelChipset"

# Function to detect Intel Chipset HW_IDs from the local system (MAIN CHIPSET ONLY)
function Get-IntelChipsetHWIDs {
    $intelChipsets = @()
    $chipsetCount = 0
    $nonChipsetCount = 0

    # Get all PCI devices from computer
    $pciDevices = Get-PnpDevice -Class 'System' -ErrorAction SilentlyContinue | 
                  Where-Object { $_.HardwareID -like '*PCI\VEN_8086*' -and $_.Status -eq 'OK' }

    foreach ($device in $pciDevices) {
        foreach ($hwid in $device.HardwareID) {
            if ($hwid -match 'PCI\\VEN_8086&DEV_([A-F0-9]{4})') {
                $deviceId = $matches[1]
                $description = $device.FriendlyName

                # Focus on main chipset components only - ignore CPU-related devices
                # Main chipsets typically have descriptions containing "Chipset", "LPC", "PCI Express Root Port", etc.
                if ($description -match 'Chipset|LPC|PCI Express Root Port|PCI-to-PCI bridge|Motherboard Resources') {
                    $intelChipsets += [PSCustomObject]@{
                        HW_ID = $deviceId
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

    # If no specific chipset devices found, fall back to the original detection but take only first few
    if ($intelChipsets.Count -eq 0) {
        foreach ($device in $pciDevices) {
            foreach ($hwid in $device.HardwareID) {
                if ($hwid -match 'PCI\\VEN_8086&DEV_([A-F0-9]{4})') {
                    $deviceId = $matches[1]
                    $description = $device.FriendlyName

                    $intelChipsets += [PSCustomObject]@{
                        HW_ID = $deviceId
                        Description = $description
                        HardwareID = $hwid
                        InstanceId = $device.InstanceId
                        IsChipset = $false
                    }
                    $chipsetCount++

                    # Limit to 5 devices to avoid CPU components
                    if ($intelChipsets.Count -ge 5) { break }
                }
            }
            if ($intelChipsets.Count -ge 5) { break }
        }
    }

    Write-Host "Scanning completed: found $chipsetCount potential chipset devices" -ForegroundColor Green
    return $intelChipsets | Sort-Object HW_ID -Unique
}

# Function to get current driver version for a device
function Get-CurrentDriverVersion {
    param([string]$DeviceInstanceId)

    try {
        $device = Get-PnpDevice | Where-Object {$_.InstanceId -eq $deviceInstanceId}
        if ($device) {
            $versionProperty = $device | Get-PnpDeviceProperty -KeyName "DEVPKEY_Device_DriverVersion" -ErrorAction SilentlyContinue
            if ($versionProperty -and $versionProperty.Data) {
                return $versionProperty.Data
            }
        }
    } catch {
        # Fallback to WMI if the above fails
        try {
            $driverInfo = Get-CimInstance -ClassName Win32_PnPSignedDriver | Where-Object { 
                $_.DeviceID -eq $deviceInstanceId -and $_.DriverVersion
            } | Select-Object -First 1

            if ($driverInfo) {
                return $driverInfo.DriverVersion
            }
        } catch {
            # Ignore errors
        }
    }
    return $null
}

# Function to clean up temporary driver folders
function Clear-TempDriverFolders {
    try {
        if (Test-Path $tempDir) {
            Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    } catch {
        # Ignore cleanup errors
    }
}

# Function to download and parse driver information from GitHub
function Get-LatestDriverInfo {
    param([string]$Url)

    try {
        $content = Invoke-WebRequest -Uri $Url -UseBasicParsing -ErrorAction Stop
        return $content.Content
    } catch {
        Write-Host "Error downloading driver information from GitHub." -ForegroundColor Red
        Write-Host "Please check your internet connection and try again." -ForegroundColor Yellow
        return $null
    }
}

# Function to parse chipset drivers information from Markdown
function Parse-ChipsetDriversFromMarkdown {
    param([string]$MarkdownContent)

    $chipsetData = @{}
    $lines = $MarkdownContent -split "`n"
    $currentPlatform = $null
    $currentGeneration = $null
    $inMainstreamSection = $false
    $inWorkstationSection = $false
    $inXeonSection = $false
    $inAtomSection = $false

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i].Trim()

        # Detect section headers (like ### Mainstream Desktop/Mobile)
        if ($line -match '^### Mainstream Desktop/Mobile') {
            $inMainstreamSection = $true
            $inWorkstationSection = $false
            $inXeonSection = $false
            $inAtomSection = $false
            continue
        }
        elseif ($line -match '^### Workstation/Enthusiast') {
            $inMainstreamSection = $false
            $inWorkstationSection = $true
            $inXeonSection = $false
            $inAtomSection = $false
            continue
        }
        elseif ($line -match '^### Xeon/Server Platforms') {
            $inMainstreamSection = $false
            $inWorkstationSection = $false
            $inXeonSection = $true
            $inAtomSection = $false
            continue
        }
        elseif ($line -match '^### Atom/Low-Power Platforms') {
            $inMainstreamSection = $false
            $inWorkstationSection = $false
            $inXeonSection = $false
            $inAtomSection = $true
            continue
        }

        # Detect platform headers (like #### Panther Lake)
        if ($line -match '^####\s+(.+)') {
            $currentPlatform = $matches[1]
            
            # Determine section for platform display
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
            
            continue
        }

        # Detect generation headers (like **Generation:** 7 Series – Desktop/Mobile)
        if ($line -match '\*\*Generation:\*\*\s*(.+)') {
            $currentGeneration = $matches[1]
            continue
        }

        # Detect table headers and data rows
        if ($line -match '^\|.*Driver.*\|.*Package.*\|.*Version.*\|.*Date.*\|.*HW_IDs.*\|$' -and $currentPlatform) {
            # Skip separator line
            $i++

            # Process data rows until we hit a non-table line
            while ($i -lt $lines.Count -and $lines[$i] -match '^\|.*\|.*\|.*\|.*\|.*\|$') {
                $dataLine = $lines[$i].Trim()
                $i++

                # Skip separator lines
                if ($dataLine -match '^\|\s*:---') { continue }

                # Parse table row
                $columns = ($dataLine -split '\|' | ForEach-Object { $_.Trim() }) | Where-Object { $_ }
                if ($columns.Count -ge 5) {
                    $driver = $columns[0]
                    $package = $columns[1]
                    $version = $columns[2]
                    $date = $columns[3] -replace '\\', ''  # Remove backslash if present
                    $hwIds = $columns[4] -split ',' | ForEach-Object { $_.Trim() }

                    foreach ($hwId in $hwIds) {
                        if ($hwId -match '^[A-F0-9]{4}$') {
                            $chipsetData[$hwId] = @{
                                Platform = $currentPlatform
                                Section = $sectionName
                                Generation = $currentGeneration
                                Driver = $driver
                                Package = $package
                                Version = $version
                                Date = $date
                                HasAsterisk = $date -match '\*$'
                            }
                        }
                    }
                }
            }
        }
    }

    return $chipsetData
}

# Function to parse download list
function Parse-DownloadList {
    param([string]$DownloadListContent)

    $downloadData = @{}
    $blocks = $DownloadListContent -split "`n`n" | Where-Object { $_.Trim() }

    foreach ($block in $blocks) {
        $name = $null
        $driverVer = $null
        $link = $null
        $prefix = $null
        $variant = "Consumer" # Default value

        $lines = $block -split "`n" | ForEach-Object { $_.Trim() }
        foreach ($line in $lines) {
            if ($line -match '^Name\s*=\s*(.+)') {
                $name = $matches[1]
            } elseif ($line -match '^DriverVer\s*=\s*[^,]+,([0-9.]+)') {
                $driverVer = $matches[1]
            } elseif ($line -match '^Link\s*=\s*(.+)') {
                $link = $matches[1]
            } elseif ($line -match '^Prefix\s*=\s*(.+)') {
                $prefix = $matches[1]
            } elseif ($line -match '^Variant\s*=\s*(.+)') {
                $variant = $matches[1]
            }
        }

        if ($driverVer -and $link) {
            $key = "$driverVer-$variant"
            $downloadData[$key] = @{
                Name = $name
                DriverVer = $driverVer
                Link = $link
                Prefix = $prefix
                Variant = $variant
            }
        }
    }

    return $downloadData
}

# Function to download and extract file
function Download-Extract-File {
    param([string]$Url, [string]$OutputPath, [string]$Prefix)

    try {
        $tempFile = "$tempDir\temp_$(Get-Random).$([System.IO.Path]::GetExtension($Url).TrimStart('.'))"

        # Download file
#        Write-Host "Downloading from: $Url" -ForegroundColor Gray
        Invoke-WebRequest -Uri $Url -OutFile $tempFile -UseBasicParsing

        if (Test-Path $tempFile) {
            # Determine file type and extract/copy accordingly
            $fileExtension = [System.IO.Path]::GetExtension($Url).ToLower()
            
            if ($fileExtension -eq '.zip') {
                # Extract ZIP file
                try {
                    Add-Type -AssemblyName System.IO.Compression.FileSystem
                    [System.IO.Compression.ZipFile]::ExtractToDirectory($tempFile, $OutputPath)
                    $success = $true
                    Write-Host "ZIP file extracted successfully." -ForegroundColor Green
                } catch {
                    # Fallback to COM object
                    try {
                        Write-Host "Using COM object for ZIP extraction..." -ForegroundColor Yellow
                        $shell = New-Object -ComObject Shell.Application
                        $zipFolder = $shell.NameSpace($tempFile)
                        $destFolder = $shell.NameSpace($OutputPath)
                        $destFolder.CopyHere($zipFolder.Items(), 0x14) # 0x14 = No UI + Overwrite
                        $success = $true
                        Write-Host "ZIP file extracted successfully using COM." -ForegroundColor Green
                    } catch {
                        Write-Host "Error extracting ZIP file: $_" -ForegroundColor Red
                        $success = $false
                    }
                }
            } elseif ($fileExtension -eq '.exe') {
                # For EXE, copy to output path with proper structure
                New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null

                if ($Prefix -and $Prefix -ne '\SetupChipset.exe') {
                    # Create subdirectory structure
                    $subDir = Split-Path $Prefix.TrimStart('\') -Parent
                    if ($subDir) {
                        $fullOutputPath = Join-Path $OutputPath $subDir
                        New-Item -ItemType Directory -Path $fullOutputPath -Force | Out-Null
                    }

                    $outputFile = Join-Path $OutputPath ($Prefix.TrimStart('\'))
                    Copy-Item $tempFile $outputFile -Force
                    Write-Host "EXE file copied to: $outputFile" -ForegroundColor Green
                } else {
                    # Default case
                    Copy-Item $tempFile "$OutputPath\SetupChipset.exe" -Force
                    Write-Host "EXE file copied to: $OutputPath\SetupChipset.exe" -ForegroundColor Green
                }
                $success = $true
            } else {
                # Unknown file type
                Write-Host "Unknown file type: $fileExtension" -ForegroundColor Red
                $success = $false
            }

            Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
            return $success
        }
    } catch {
        Write-Host "Error downloading or extracting driver package: $_" -ForegroundColor Red
    }
    return $false
}

# Function to install chipset driver
function Install-ChipsetDriver {
    param([string]$DriverPath, [string]$Prefix)

    # Determine setup path based on prefix
    if ($Prefix) {
        $setupPath = Join-Path $DriverPath ($Prefix.TrimStart('\'))
    } else {
        $setupPath = Join-Path $DriverPath "SetupChipset.exe"
    }

    if (Test-Path $setupPath) {

Write-Host ""
Write-Host "IMPORTANT NOTICE:" -ForegroundColor Yellow
Write-Host "The driver updater is now running." -ForegroundColor Yellow
Write-Host "Please DO NOT close this window or interrupt the process." -ForegroundColor Yellow
Write-Host "The system may appear unresponsive during installation - this is normal." -ForegroundColor Yellow
Write-Host ""

        Write-Host "Running installer: SetupChipset.exe" -ForegroundColor Cyan
        # Write-Host "Running installer: $setupPath" -ForegroundColor Cyan

        try {
            # Run installer with parameters -S -OVERALL -downgrade -norestart
            $process = Start-Process -FilePath $setupPath -ArgumentList "-S -OVERALL -downgrade -norestart" -Wait -PassThru

            # Code 3010 = SUCCESS - RESTART REQUIRED (this is not an error!)
            if ($process.ExitCode -eq 0 -or $process.ExitCode -eq 3010) {
                Write-Host "Driver installed successfully." -ForegroundColor Green
                return $true
            } else {
                Write-Host "Installer finished with exit code: $($process.ExitCode)" -ForegroundColor Red
                return $false
            }

        } catch {
            Write-Host "Error running installer: $_" -ForegroundColor Red
            return $false
        }
    } else {
        Write-Host "Error: Installer not found at $setupPath" -ForegroundColor Red
        # Try to find any setup executable
        $exeFiles = Get-ChildItem -Path $DriverPath -Filter "*.exe" -Recurse | Where-Object {
            $_.Name -like "*Setup*" -or $_.Name -like "*Install*"
        }
        if ($exeFiles) {
            Write-Host "Found alternative installer: $($exeFiles[0].FullName)" -ForegroundColor Yellow
            return Install-ChipsetDriver -DriverPath $DriverPath -Prefix "\$($exeFiles[0].Name)"
        }
        return $false
    }
}

# Main script execution
Write-Host "=== Intel Chipset Drivers Update ===" -ForegroundColor Cyan
Write-Host "Scanning for Intel Chipset..." -ForegroundColor Green

# Create temporary directory
Clear-TempDriverFolders
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

# Detect Intel Chipset HW_IDs on local system (MAIN CHIPSET ONLY)
$detectedIntelChipsets = Get-IntelChipsetHWIDs

if ($detectedIntelChipsets.Count -eq 0) {
    Write-Host "No Intel chipset devices found." -ForegroundColor Yellow
    Write-Host "If you have an Intel platform, make sure you have at least SandyBridge or newer platform." -ForegroundColor Yellow
    Clear-TempDriverFolders
    exit
}

Write-Host "Found $($detectedIntelChipsets.Count) Intel chipset device(s)" -ForegroundColor Green

# Download latest driver information
Write-Host "Downloading latest driver information..." -ForegroundColor Green
$chipsetInfo = Get-LatestDriverInfo -Url $chipsetDriversUrl
$downloadListInfo = Get-LatestDriverInfo -Url $downloadListUrl

if (-not $chipsetInfo -or -not $downloadListInfo) {
    Write-Host "Failed to download driver information. Exiting." -ForegroundColor Red
    Clear-TempDriverFolders
    exit
}

# Parse driver information
Write-Host "Parsing driver information..." -ForegroundColor Green
$chipsetData = Parse-ChipsetDriversFromMarkdown -MarkdownContent $chipsetInfo
$downloadData = Parse-DownloadList -DownloadListContent $downloadListInfo

if ($chipsetData.Count -eq 0 -or $downloadData.Count -eq 0) {
    Write-Host "Error: Could not parse driver information." -ForegroundColor Red
    Clear-TempDriverFolders
    exit
}

# Find matching chipset platforms
$matchingChipsets = @()
$chipsetUpdateAvailable = $false

foreach ($device in $detectedIntelChipsets) {
    $hwId = $device.HW_ID
    if ($chipsetData.ContainsKey($hwId)) {
        $chipsetInfo = $chipsetData[$hwId]
        # Using InstanceId to get driver version
        $currentVersion = Get-CurrentDriverVersion -DeviceInstanceId $device.InstanceId

        $matchingChipsets += @{
            Device = $device
            ChipsetInfo = $chipsetInfo
            CurrentVersion = $currentVersion
            HardwareID = $device.HardwareID
            InstanceId = $device.InstanceId
        }

        Write-Host "Found compatible platform: $($chipsetInfo.Platform) (HW_ID: $hwId)" -ForegroundColor Green
    }
}

if ($matchingChipsets.Count -eq 0) {
    Write-Host "No compatible Intel chipset platforms found." -ForegroundColor Yellow
    Write-Host "If you have an Intel platform, make sure you have at least SandyBridge or newer platform." -ForegroundColor Yellow
    Clear-TempDriverFolders
    exit
}

# Group by platform to avoid duplicate installations of the same driver
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
Write-Host "`n=== Platform Information ===" -ForegroundColor Cyan

foreach ($platformName in $uniquePlatforms.Keys) {
    $platformData = $uniquePlatforms[$platformName]
    $chipsetInfo = $platformData.ChipsetInfo
    $devices = $platformData.Devices
    $currentVersions = $platformData.CurrentVersions | Sort-Object -Unique

    Write-Host "Platform: $platformName" -ForegroundColor White
    if ($chipsetInfo.Generation) {
        Write-Host "Generation: $($chipsetInfo.Generation)" -ForegroundColor Gray
    }

    if ($currentVersions.Count -gt 0) {
        Write-Host "Current Version: $(($currentVersions -join ', '))" -ForegroundColor Gray
    } else {
        Write-Host "Current Version: Unable to determine" -ForegroundColor Gray
    }

    # Latest Version without date
    Write-Host "Latest Version: $($chipsetInfo.Version)" -ForegroundColor Gray

    # Installer Version with date in yellow
    $installerVersionDisplay = "$($chipsetInfo.Package) ($($chipsetInfo.Date))"
    Write-Host "Installer Version: $installerVersionDisplay" -ForegroundColor Yellow

    # Check if update is available
    $needsUpdate = $false
    if ($currentVersions.Count -gt 0) {
        foreach ($currentVersion in $currentVersions) {
            if ($currentVersion -ne $chipsetInfo.Version) {
                $needsUpdate = $true
                break
            }
        }

        if (-not $needsUpdate) {
            Write-Host "Status: Already on latest version" -ForegroundColor Green
        } else {
            Write-Host "Status: New version available! ($(($currentVersions -join ', ')) -> $($chipsetInfo.Version))" -ForegroundColor Yellow
            $chipsetUpdateAvailable = $true
        }
    } else {
        Write-Host "Status: Driver will be installed" -ForegroundColor Yellow
        $chipsetUpdateAvailable = $true
    }

    # Show asterisk warning if needed
    if ($chipsetInfo.HasAsterisk) {
        Write-Host "" -ForegroundColor Yellow
        Write-Host "Note: Drivers marked with (*) do not have embedded dates" -ForegroundColor Yellow
        Write-Host "      and will show as 07/18/1968 in system. The actual" -ForegroundColor Yellow
        Write-Host "      driver release corresponds to the installer date." -ForegroundColor Yellow
    }

    Write-Host ""
}

# If all devices are up to date, ask if user wants to reinstall anyway
if ((-not $chipsetUpdateAvailable) -and ($uniquePlatforms.Count -gt 0)) {
    Write-Host "All platforms are up to date." -ForegroundColor Green
    $response = Read-Host "Do you want to force reinstall this drivers anyway? (Y/N)"
    if ($response -eq "Y" -or $response -eq "y") {
        $chipsetUpdateAvailable = $true
    } else {
        Write-Host "Installation cancelled." -ForegroundColor Yellow
        Clear-TempDriverFolders
        exit
    }
}

# Ask for update confirmation with important notice
if ($chipsetUpdateAvailable) {
    Write-Host ""
    Write-Host "IMPORTANT NOTICE:" -ForegroundColor Yellow
    Write-Host "The driver update process may take several minutes to complete." -ForegroundColor Yellow
    Write-Host "During installation, the screen may temporarily go black and some" -ForegroundColor Yellow
    Write-Host "devices may temporarily disconnect as PCIe bus drivers are being" -ForegroundColor Yellow
    Write-Host "updated. This is normal behavior and the system will return to" -ForegroundColor Yellow
    Write-Host "normal operation once the installation is complete." -ForegroundColor Yellow
    Write-Host ""
    $response = Read-Host "Do you want to proceed with driver update? (Y/N)"
} else {
    $response = "N"
}

if ($response -eq "Y" -or $response -eq "y") {
    Write-Host "`nStarting driver update process..." -ForegroundColor Green

    # INTELLIGENT PACKAGE MANAGEMENT: Group by package version and install only unique packages
    $packageGroups = @{}
    foreach ($platformName in $uniquePlatforms.Keys) {
        $platformData = $uniquePlatforms[$platformName]
        $packageVersion = $platformData.ChipsetInfo.Package
        
        if (-not $packageGroups.ContainsKey($packageVersion)) {
            $packageGroups[$packageVersion] = @()
        }
        $packageGroups[$packageVersion] += $platformName
    }

    # Sort packages by version (newest first) to ensure we install the latest versions
    $sortedPackages = $packageGroups.Keys | Sort-Object { [version]($_ -replace '\s*\(S\)\s*', '') } -Descending

    $successCount = 0
    $processedPackages = @{}

    foreach ($packageVersion in $sortedPackages) {
        $platforms = $packageGroups[$packageVersion]
        
        Write-Host "`nPackage $packageVersion for platforms: $($platforms -join ', ')" -ForegroundColor Cyan

        # Determine variant based on actual package version suffix from Markdown
        $variant = "Consumer"
        # Check if package has (S) suffix indicating Server variant
        if ($packageVersion -match '\(S\)$') {
            $variant = "Server"
        }

        # Get download information for this package version and variant
        $cleanPackageVersion = $packageVersion -replace '\s*\(S\)\s*', ''  # Remove (S) suffix if present
        $downloadKey = "$cleanPackageVersion-$variant"

        if ($downloadData.ContainsKey($downloadKey)) {
            $downloadInfo = $downloadData[$downloadKey]
            $driverPath = "$tempDir\$cleanPackageVersion-$variant"

            Write-Host "Downloading Intel Chipset Device Software $cleanPackageVersion ($variant)..." -ForegroundColor Green
            if (Download-Extract-File -Url $downloadInfo.Link -OutputPath $driverPath -Prefix $downloadInfo.Prefix) {
                Write-Host "Driver downloaded and extracted successfully." -ForegroundColor Green
                
                if (Install-ChipsetDriver -DriverPath $driverPath -Prefix $downloadInfo.Prefix) {
                    $successCount++
                    $processedPackages[$cleanPackageVersion] = $true
                    Write-Host "Successfully installed package $cleanPackageVersion for $($platforms.Count) platform(s)" -ForegroundColor Green
                } else {
                    Write-Host "Failed to install driver." -ForegroundColor Red
                }
            } else {
                Write-Host "Failed to download or extract driver." -ForegroundColor Red
            }
        } else {
            Write-Host "Error: Download information not found for package version $cleanPackageVersion (variant: $variant)" -ForegroundColor Red
            Write-Host "Please check Intel_Chipset_Drivers_Download.txt for missing entries" -ForegroundColor Yellow
        }
    }

    if ($successCount -gt 0) {
        Write-Host "`nIMPORTANT NOTICE:" -ForegroundColor Yellow
        Write-Host "Computer restart is required to complete driver installation!" -ForegroundColor Yellow
        
        Write-Host "`nSummary: Installed $successCount unique package(s) for all detected platforms" -ForegroundColor Green
    } else {
        Write-Host "`nNo drivers were successfully installed." -ForegroundColor Red
    }
} else {
    Write-Host "Update cancelled." -ForegroundColor Yellow
}

# Clean up
Write-Host "`nCleaning up temporary files..." -ForegroundColor Gray
Clear-TempDriverFolders

Write-Host "`nDriver update process completed." -ForegroundColor Cyan
Write-Host "If you have any issues with this tool, please report them at:"
Write-Host "https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater" -ForegroundColor Cyan