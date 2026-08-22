param(
    [string]$InstallerPath,
    [switch]$Help,
    [switch]$Debug
)

# universal-intel-inf-extractor.ps1
# Universal Intel Chipset INF Extractor
# Extracts Intel Chipset Device Software packages (SetupChipset.exe)
#
# Supports:
#   - Single file mode: extract specific SetupChipset.exe
#   - Directory mode: scan for all Intel Chipset installers in folder (and subfolders)
#   - 10.0.x.x                              -> legacy /s /extract, output to Legacy subfolder with full version
#   - 10.1.x.x (below 10.1.20378.8757)      -> legacy /s /extract
#   - 10.2.x.x (any)                        -> legacy /s /extract
#   - 10.1.x.x from 10.1.20378.8757 upward  -> NanaZip 3-stage extraction
#
# Uses open-source components from NanaZip: https://github.com/M2Team/NanaZip

# =============================================
# SCRIPT VERSION
# =============================================
$ScriptVersion = "2026.08.0001"
$ScriptName = "Universal Intel Chipset INF Extractor"

# =============================================
# COMMAND-LINE PARAMETERS
# =============================================
if ($Help) {
    Clear-Host
    Write-Host ""
    Write-Host " Universal Intel Chipset INF Extractor v$ScriptVersion" -ForegroundColor Cyan
    Write-Host ""
    Write-Host " Usage: .\universal-intel-inf-extractor.ps1 [options] [path-to-SetupChipset.exe]"
    Write-Host ""
    Write-Host " Options:"
    Write-Host "  -Help           Show this help message"
    Write-Host "  -Debug          Enable debug output"
    Write-Host ""
    Write-Host " If no path is provided, the script will search for SetupChipset*.exe"
    Write-Host " in the current directory."
    Write-Host ""
    Write-Host " Example: .\universal-intel-inf-extractor.ps1 C:\Download\SetupChipset.exe"
    Write-Host " Example: .\universal-intel-inf-extractor.ps1 C:\Intel_Installers\"
    Write-Host ""
    exit 0
}

# =============================================
# CONSOLE SETTINGS
# =============================================
$Host.UI.RawUI.BackgroundColor = "Black"

try {
    [console]::WindowWidth = 75
    [console]::WindowHeight = 58
    [console]::BufferWidth = [console]::WindowWidth
} catch {
    # Silent fallback if console settings fail
}

# =============================================
# COLOR HELPERS
# =============================================
function Write-ColorLine {
    param([string]$Line)

    $validColors = [Enum]::GetNames([ConsoleColor])
    $currentFg = $Host.UI.RawUI.ForegroundColor
    $currentBg = $Host.UI.RawUI.BackgroundColor

    $segments = @()
    $position = 0
    $length = $Line.Length

    while ($position -lt $length) {
        $openBracket = $Line.IndexOf('[', $position)
        if ($openBracket -eq -1) {
            $text = $Line.Substring($position)
            if ($text) {
                $segments += [PSCustomObject]@{
                    Text       = $text
                    Foreground = $currentFg
                    Background = $currentBg
                }
            }
            break
        }

        if ($openBracket -gt $position) {
            $text = $Line.Substring($position, $openBracket - $position)
            $segments += [PSCustomObject]@{
                Text       = $text
                Foreground = $currentFg
                Background = $currentBg
            }
        }

        $closeBracket = $Line.IndexOf(']', $openBracket)
        if ($closeBracket -eq -1) {
            $text = $Line.Substring($openBracket)
            $segments += [PSCustomObject]@{
                Text       = $text
                Foreground = $currentFg
                Background = $currentBg
            }
            break
        }

        $tagContent = $Line.Substring($openBracket + 1, $closeBracket - $openBracket - 1)

        if ($tagContent -match ',') {
            $colors = $tagContent -split ',' | ForEach-Object { $_.Trim() }
            if ($colors.Count -eq 2 -and ($validColors -contains $colors[0]) -and ($validColors -contains $colors[1])) {
                $currentFg = [ConsoleColor]$colors[0]
                $currentBg = [ConsoleColor]$colors[1]
                $position = $closeBracket + 1
                continue
            }
        }

        if ($validColors -contains $tagContent) {
            $currentFg = [ConsoleColor]$tagContent
            $position = $closeBracket + 1
            continue
        }

        $text = $Line.Substring($openBracket, $closeBracket - $openBracket + 1)
        $segments += [PSCustomObject]@{
            Text       = $text
            Foreground = $currentFg
            Background = $currentBg
        }
        $position = $closeBracket + 1
    }

    foreach ($seg in $segments) {
        Write-Host $seg.Text -NoNewline -ForegroundColor $seg.Foreground -BackgroundColor $seg.Background
    }
    Write-Host ""
}

# =============================================
# HEADER DISPLAY
# =============================================
function Show-Header {
    Clear-Host
    Write-Host "/*************************************************************************" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "                 UNIVERSAL INTEL CHIPSET INF EXTRACTOR                 " -NoNewline -ForegroundColor White -BackgroundColor DarkBlue
    Write-Host "**" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "** --------------------------------------------------------------------- **" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**                                                                       **" -ForegroundColor Gray -BackgroundColor DarkBlue

    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "                      Tool Version: $ScriptVersion                       " -NoNewline -ForegroundColor Yellow -BackgroundColor DarkBlue
    Write-Host "**" -ForegroundColor Gray -BackgroundColor DarkBlue

    Write-Host "**                                                                       **" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "          Author: Marcin Grygiel / GitHub.com/FirstEverTech            " -NoNewline -ForegroundColor Green -BackgroundColor DarkBlue
    Write-Host "**" -ForegroundColor Gray -BackgroundColor DarkBlue

    Write-Host "**                                                                       **" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "          This tool is not affiliated with Intel Corporation.          " -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "          INF files are sourced from official Intel servers.           " -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "          Use at your own risk.                                        " -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**                                                                       **" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "*************************************************************************/" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host ""
}

function Show-Screen1 {
    Show-Header
    Write-Host " [SCREEN 1/4] INITIALIZATION" -ForegroundColor Cyan
    Write-Host " ============================" -ForegroundColor Cyan
    Write-Host ""
}

function Show-Screen2 {
    Show-Header
    Write-Host " [SCREEN 2/4] VERSION DETECTION" -ForegroundColor Cyan
    Write-Host " ==============================" -ForegroundColor Cyan
    Write-Host ""
}

function Show-Screen3 {
    Show-Header
    Write-Host " [SCREEN 3/4] EXTRACTION PROGRESS" -ForegroundColor Cyan
    Write-Host " ================================" -ForegroundColor Cyan
    Write-Host ""
}

function Show-Screen4 {
    param(
        [string]$ExtractionMethod,
        [string]$OutputFolder,
        [string]$VersionString,
        [int]$FileCount,
        [int]$DirCount
    )
    
    Show-Header
    Write-Host " [SCREEN 4/4] EXTRACTION COMPLETED" -ForegroundColor Cyan
    Write-Host " =================================" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host " Extraction method: $ExtractionMethod" -ForegroundColor Yellow
    Write-Host " Version: $VersionString" -ForegroundColor Yellow
    Write-Host ""
    Write-Host " Output folder: $OutputFolder" -ForegroundColor Green
    Write-Host ""
    
    Write-Host " Files extracted: $FileCount" -ForegroundColor Green
    Write-Host " Folders created: $DirCount" -ForegroundColor Green
    Write-Host ""
    
    Write-Host " This tool uses open-source components from NanaZip." -ForegroundColor Gray
    Write-Host " GitHub: https://github.com/M2Team/NanaZip" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host " Extraction SUCCESSFUL." -ForegroundColor Green
    Write-Host ""
}

# =============================================
# FINAL CREDITS - czyści ekran i zastępuje 4/4
# =============================================
function Show-FinalCredits {
    Clear-Host
    Write-Host "/*************************************************************************" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "                 UNIVERSAL INTEL CHIPSET INF EXTRACTOR                 " -NoNewline -ForegroundColor White -BackgroundColor DarkBlue
    Write-Host "**" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "** --------------------------------------------------------------------- **" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**                                                                       **" -ForegroundColor Gray -BackgroundColor DarkBlue

    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "                      Tool Version: $ScriptVersion                       " -NoNewline -ForegroundColor Yellow -BackgroundColor DarkBlue
    Write-Host "**" -ForegroundColor Gray -BackgroundColor DarkBlue

    Write-Host "**                                                                       **" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "          Author: Marcin Grygiel / GitHub.com/FirstEverTech            " -NoNewline -ForegroundColor Green -BackgroundColor DarkBlue
    Write-Host "**" -ForegroundColor Gray -BackgroundColor DarkBlue

    Write-Host "**                                                                       **" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "          This tool is not affiliated with Intel Corporation.          " -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "          INF files are sourced from official Intel servers.           " -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "          Use at your own risk.                                        " -NoNewline -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "**                                                                       **" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host "*************************************************************************/" -ForegroundColor Gray -BackgroundColor DarkBlue
    Write-Host ""

    Write-Host " THANK YOU FOR USING UNIVERSAL INTEL CHIPSET INF EXTRACTOR" -ForegroundColor Cyan
    Write-Host " =========================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host " If this tool helped you, please consider:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host " - Giving it a STAR on GitHub" -ForegroundColor Green
    Write-Host " - Reporting issues or suggesting features" -ForegroundColor Green
    Write-Host " - Supporting development" -ForegroundColor Green
    Write-Host ""
    Write-Host " GitHub: https://github.com/FirstEverTech" -ForegroundColor Gray
    Write-Host ""

    Write-Host " Press any key to exit..." -ForegroundColor Gray
    Write-Host ""
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
}

# =============================================
# LOGGING
# =============================================
$ScriptDirectory = $PSScriptRoot
$LogFile = Join-Path $ScriptDirectory "INF_Extractor.log"

$TempRoot   = Join-Path $env:TEMP "INF_Extractor"
$NanaZipDir = Join-Path $TempRoot "NanoZip"
$FinalRoot  = Join-Path $ScriptDirectory "INF_Extractor"

$NanaZipExe = Join-Path $NanaZipDir "NanaZip.Universal.Console.exe"
$RequiredNanaZipFiles = @("K7Base.dll", "NanaZip.Codecs.dll", "NanaZip.Core.dll", "NanaZip.Universal.Console.exe")

$IssueTracker = "https://github.com/FirstEverTech"
$NewFormatFloor = [version]"10.1.20378.8757"

# =============================================
# SCRIPT INTEGRITY / SHA256 VERIFICATION
# =============================================
# Pliki .ps1 i .sha256 trzymane razem w repo Updatera, branch main, folder /src
# (nie jako GitHub Release - stąd raw.githubusercontent.com zamiast releases/download).
$GitHubRawBaseUrl   = "https://raw.githubusercontent.com/FirstEverTech/Universal-Intel-Chipset-Updater/main/src"
$ScriptFileBaseName = "universal-intel-chipset-inf-extractor"

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$time] [$Level] $Message"
    $logDir = Split-Path -Parent $LogFile
    if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force | Out-Null }
    Add-Content -Path $LogFile -Value $logEntry -Encoding UTF8
}

function Write-Debug {
    param([string]$Message)
    if ($Debug) {
        Write-Host " [DEBUG] $Message" -ForegroundColor Gray
    }
    Write-Log $Message -Level "DEBUG"
}

function Exit-WithFailure {
    param(
        [string]$Reason,
        [string]$FailedInstaller = $null,
        [string]$FailedVersion = $null
    )
    Write-Log "FAILED: $Reason" "ERROR"

    if ($FailedInstaller) {
        Write-FailedReport -FailedItems @(
            @{
                FileName = Split-Path $FailedInstaller -Leaf
                Path     = $FailedInstaller
                Version  = $FailedVersion
                Reason   = $Reason
            }
        )
    }

    Write-Host ""
    Write-Host " Extraction FAILED." -ForegroundColor Red
    Write-Host " Reason: $Reason" -ForegroundColor Red
    Write-Host ""
    Write-Host " Full log: $LogFile" -ForegroundColor Red
    Write-Host " Please report this issue at: $IssueTracker" -ForegroundColor Red
    Write-Host ""
    Write-Host " Press any key to exit..." -ForegroundColor Gray
    Write-Host ""
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    exit 1
}

# =============================================
# FAILED EXTRACTIONS REPORT
# =============================================
function Write-FailedReport {
    param([array]$FailedItems)

    if (-not $FailedItems -or $FailedItems.Count -eq 0) { return }

    $reportPath = Join-Path $ScriptDirectory "INF_Extractor_Failed.txt"
    $lines = @()
    $lines += "Universal Intel Chipset INF Extractor - Failed Extractions Report"
    $lines += "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    $lines += "Tool version: $ScriptVersion"
    $lines += "======================================================================"
    $lines += ""

    foreach ($f in $FailedItems) {
        $lines += "File:    $($f.FileName)"
        $lines += "Path:    $($f.Path)"
        if ($f.Version) { $lines += "Version: $($f.Version)" }
        $lines += "Reason:  $($f.Reason)"
        $lines += "----------------------------------------------------------------------"
    }

    try {
        Set-Content -Path $reportPath -Value $lines -Encoding UTF8 -ErrorAction Stop
        Write-Log "Failed extraction report written to: $reportPath ($($FailedItems.Count) item(s))" "INFO"
        Write-Host " Failed extraction report saved to: $reportPath" -ForegroundColor Yellow
        Write-Host ""
    } catch {
        Write-Log "Could not write failed report to '$reportPath': $($_.Exception.Message)" "ERROR"
    }
}

# =============================================
# SCRIPT INTEGRITY VERIFICATION (SHA256)
# =============================================
function Test-ScriptAuthenticity {
    # Zwraca "OK", "MISMATCH", "NO_CONNECTIVITY" lub "FETCH_FAILED".
    # Ustawia $script:ActualHash / $script:ExpectedHash do wyświetlenia w Main.

    $scriptPath = $null
    if ($PSCommandPath) {
        $scriptPath = $PSCommandPath
    } elseif ($MyInvocation.MyCommand.Path) {
        $scriptPath = $MyInvocation.MyCommand.Path
    } else {
        $potentialPath = Join-Path $ScriptDirectory "$ScriptFileBaseName.ps1"
        if (Test-Path $potentialPath) { $scriptPath = $potentialPath }
    }

    if (-not $scriptPath -or -not (Test-Path $scriptPath)) {
        Write-Log "Hash verification: could not locate script file on disk" "WARNING"
        return "FETCH_FAILED"
    }

    $currentHash = $null
    try {
        $currentHash = (Get-FileHash -Path $scriptPath -Algorithm SHA256).Hash.ToUpper()
    } catch {
        Write-Log "Hash verification: could not calculate local hash - $($_.Exception.Message)" "WARNING"
        return "FETCH_FAILED"
    }
    $script:ActualHash = $currentHash

    if (-not (Test-GitHubConnectivity)) {
        Write-Log "Hash verification: GitHub is not reachable" "WARNING"
        return "NO_CONNECTIVITY"
    }

    $hashFileUrl = "$GitHubRawBaseUrl/$ScriptFileBaseName-$ScriptVersion-ps1.sha256"
    Write-Log "Hash verification: downloading expected hash from $hashFileUrl" "INFO"

    try {
        $response = Invoke-WebRequest -Uri $hashFileUrl -UseBasicParsing -ErrorAction Stop -TimeoutSec 10

        $content = $null
        if ($response.Content -is [byte[]]) {
            $content = [System.Text.Encoding]::UTF8.GetString($response.Content).Trim()
        } else {
            $content = $response.Content.ToString().Trim()
        }

        $expectedHash = $null
        if ($content -match '^([A-Fa-f0-9]{64})') {
            $expectedHash = $matches[1].ToUpper()
        }

        if (-not $expectedHash) {
            Write-Log "Hash verification: could not parse hash from downloaded file (HTTP $($response.StatusCode))" "WARNING"
            return "FETCH_FAILED"
        }
        $script:ExpectedHash = $expectedHash

        if ($currentHash -eq $expectedHash) {
            Write-Log "Hash verification: PASSED" "INFO"
            return "OK"
        } else {
            Write-Log "Hash verification: MISMATCH (expected $expectedHash, actual $currentHash)" "ERROR"
            return "MISMATCH"
        }
    } catch {
        Write-Log "Hash verification: could not download/parse expected hash - $($_.Exception.Message)" "WARNING"
        return "FETCH_FAILED"
    }
}

# =============================================
# GITHUB CONNECTIVITY TEST
# =============================================
function Test-GitHubConnectivity {
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $null = Invoke-WebRequest -Uri "https://raw.githubusercontent.com" -UseBasicParsing -TimeoutSec 5 -ErrorAction Stop
        Write-Log "GitHub connectivity test: PASSED" "INFO"
        return $true
    } catch {
        Write-Log "GitHub connectivity test: FAILED - $($_.Exception.Message)" "WARNING"
        return $false
    }
}

function Confirm-ContinueDespiteRisk {
    while ($true) {
        Write-Host " Do you want to continue anyway? (Y/N): " -ForegroundColor DarkGray -NoNewline
        $answer = Read-Host
        if ($answer -match '^(?i:y(es)?)$') { return $true }
        if ($answer -match '^(?i:n(o)?)$') { return $false }
        Write-Host " Please answer Y or N." -ForegroundColor Red
    }
}

# =============================================
# NANAZIP DOWNLOAD AND SETUP
# =============================================
function Setup-NanaZip {
    Write-Host " Setting up NanaZip..." -ForegroundColor Yellow

    # Create NanaZip directory
    if (-not (Test-Path $NanaZipDir)) {
        New-Item -ItemType Directory -Path $NanaZipDir -Force | Out-Null
    }

    # Check if NanaZip files already exist
    $allExist = $true
    foreach ($f in $RequiredNanaZipFiles) {
        $p = Join-Path $NanaZipDir $f
        if (-not (Test-Path $p)) {
            $allExist = $false
            break
        }
    }

    if ($allExist) {
        Write-Host " NanaZip files already present." -ForegroundColor Green
        Write-Host ""
        return $true
    }

    Write-Host " Downloading NanaZip binaries..." -ForegroundColor Yellow

    $zipUrl = "https://github.com/M2Team/NanaZip/releases/download/6.5.1800.0/NanaZip_6.5.1800.0_Binaries.zip"
    $zipPath = Join-Path $TempRoot "NanaZip_6.5.1800.0_Binaries.zip"

    try {
        Write-Host " Downloading from: $zipUrl" -ForegroundColor Gray
        Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath -UseBasicParsing -ErrorAction Stop
        Write-Host " Download completed." -ForegroundColor Green
    } catch {
        throw "Failed to download NanaZip: $($_.Exception.Message)"
    }

    Write-Host " Extracting NanaZip..." -ForegroundColor Yellow

    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $TempRoot)
        Write-Host " ZIP extraction completed." -ForegroundColor Green
    } catch {
        try {
            Write-Host " Using COM object for ZIP extraction..." -ForegroundColor Yellow
            $shell = New-Object -ComObject Shell.Application
            $zipFolder = $shell.NameSpace($zipPath)
            $destFolder = $shell.NameSpace($TempRoot)
            $destFolder.CopyHere($zipFolder.Items(), 0x14)
            Write-Host " ZIP extraction completed using COM." -ForegroundColor Green
        } catch {
            throw "Failed to extract NanaZip ZIP: $($_.Exception.Message)"
        }
    }

    # Move files from x64 subdirectory to NanaZipDir
    $x64Source = Join-Path $TempRoot "x64"
    if (Test-Path $x64Source) {
        Write-Host " Moving NanaZip files from x64 subdirectory..." -ForegroundColor Yellow
        foreach ($f in $RequiredNanaZipFiles) {
            $source = Join-Path $x64Source $f
            $dest = Join-Path $NanaZipDir $f
            if (Test-Path $source) {
                Move-Item -Path $source -Destination $dest -Force
                Write-Debug "Moved: $f"
            } else {
                Write-Debug "File not found in x64: $f"
            }
        }
        # Remove x64 directory with -Recurse to avoid confirmation prompt
        Remove-Item -Path $x64Source -Recurse -Force -ErrorAction SilentlyContinue
    } else {
        throw "x64 directory not found in NanaZip archive"
    }

    # Remove zip file
    Remove-Item -Path $zipPath -Force -ErrorAction SilentlyContinue

    # Verify all files are present
    foreach ($f in $RequiredNanaZipFiles) {
        $p = Join-Path $NanaZipDir $f
        if (-not (Test-Path $p)) {
            throw "Required NanaZip file missing after extraction: $f"
        }
    }

    Write-Host " NanaZip setup completed successfully." -ForegroundColor Green
    Write-Host ""
    return $true
}

# =============================================
# IS INSTALLER - sprawdza czy plik to instalator Intel Chipset
# =============================================
function Test-IsIntelInstaller {
    param([string]$FilePath)
    
    try {
        $versionInfo = (Get-Item $FilePath).VersionInfo
        
        # Sprawdź FileDescription
        $fileDesc = $versionInfo.FileDescription
        if ($fileDesc) {
            $fileDesc = $fileDesc.Trim()
            # Wzorce do wykrycia instalatora Intel Chipset
            if ($fileDesc -match 'Intel\(R\) Chipset INF \d+\.\d+\.x\.x' -or
                $fileDesc -match 'Intel\(R\) Chipset Device Software \d+\.\d+\.\d+\.\d+' -or
                $fileDesc -match 'SetupChipset Installer' -or
                $fileDesc -match 'Intel Chipset Device Software' -or
                $fileDesc -match 'Intel® Chipset Device Software' -or
                $fileDesc -match 'Intel® Chipset INF') {
                Write-Debug "Found by FileDescription: '$fileDesc'"
                return $true
            }
        }
        
        # Sprawdź FileVersion - stare wersje mogą mieć opis w wersji
        $fileVersion = $versionInfo.FileVersion
        if ($fileVersion) {
            $fileVersion = $fileVersion.Trim()
            # Stare wersje 10.0.x.x mają FileVersion w formacie 10.0.xx
            if ($fileVersion -match '^10\.0\.\d+\.\d+$' -or
                $fileVersion -match '^10\.1\.\d+\.\d+$' -or
                $fileVersion -match '^10\.2\.\d+\.\d+$') {
                # Dodatkowo sprawdź czy to nie jest przypadkiem inny plik Intel
                # Sprawdź czy w nazwie pliku lub opisie jest coś związanego z chipset
                $fileName = Split-Path $FilePath -Leaf
                if ($fileName -match 'chipset|inf|setup' -or 
                    ($fileDesc -and $fileDesc -match 'intel|chipset|inf')) {
                    Write-Debug "Found by FileVersion: '$fileVersion'"
                    return $true
                }
            }
        }
        
        # Sprawdź ProductName
        $productName = $versionInfo.ProductName
        if ($productName) {
            $productName = $productName.Trim()
            if ($productName -match 'Intel\(R\) Chipset Device Software' -or
                $productName -match 'Intel® Chipset Device Software' -or
                $productName -match 'Intel Chipset INF') {
                Write-Debug "Found by ProductName: '$productName'"
                return $true
            }
        }
        
        # Sprawdź OriginalFilename
        $origFileName = $versionInfo.OriginalFilename
        if ($origFileName) {
            $origFileName = $origFileName.Trim()
            if ($origFileName -match 'SetupChipset\.exe' -or
                $origFileName -match 'ChipsetInstaller\.exe') {
                Write-Debug "Found by OriginalFilename: '$origFileName'"
                return $true
            }
        }
        
    } catch {
        Write-Debug "Error reading version info for: $FilePath"
    }
    return $false
}

# =============================================
# FIND INSTALLERS - szuka wszystkich instalatorów
# =============================================
function Find-Installers {
    param([string]$Path)
    
    $installers = @()
    
    # Jeśli podano ścieżkę do pliku
    if ($Path -and (Test-Path $Path) -and (Get-Item $Path).PSIsContainer -eq $false) {
        $fullPath = (Get-Item $Path).FullName
        if (Test-IsIntelInstaller -FilePath $fullPath) {
            $installers += $fullPath
        }
        return ,$installers
    }
    
    # Jeśli podano ścieżkę do katalogu lub nie podano nic
    $searchPath = $Path
    if (-not $searchPath) {
        $searchPath = $ScriptDirectory
    }
    
    if (-not (Test-Path $searchPath)) {
        return ,$installers
    }
    
    # Sprawdź czy to katalog
    if ((Get-Item $searchPath).PSIsContainer) {
        Write-Debug "Searching for installers in: $searchPath"
        # Szukaj wszystkich EXE w katalogu i podkatalogach
        $allExeFiles = Get-ChildItem -Path $searchPath -Filter "*.exe" -Recurse -File -ErrorAction SilentlyContinue
        
        foreach ($file in $allExeFiles) {
            if (Test-IsIntelInstaller -FilePath $file.FullName) {
                Write-Debug "Found installer: $($file.FullName)"
                $installers += $file.FullName
            }
        }
    }
    
    return ,$installers
}

# =============================================
# VERSION DETECTION
# =============================================
function Get-InstallerVersion {
    param([string]$Path)

    try {
        $versionInfo = (Get-Item $Path).VersionInfo
        $versionString = $versionInfo.FileVersion
        if (-not $versionString) { $versionString = $versionInfo.ProductVersion }
        if (-not $versionString) { 
            throw "Could not read version info from '$Path'. FileVersion and ProductVersion are both empty."
        }
        $versionString = $versionString.Trim()
        return [version]$versionString, $versionString
    } catch {
        throw "Could not read version info from '$Path': $($_.Exception.Message)"
    }
}

# =============================================
# EXTRACTION FUNCTIONS
# =============================================
function Invoke-LegacyExtraction {
    param(
        [string]$InstallerPath,
        [string]$VersionString,
        [string]$OutputFolder,
        [ref]$FileCountRef,
        [ref]$DirCountRef
    )

    if (-not (Test-Path $OutputFolder)) {
        New-Item -ItemType Directory -Path $OutputFolder -Force | Out-Null
    }

    Write-Log "Running: `"$InstallerPath`" /s /extract `"$OutputFolder`"" "INFO"
    Write-Host " Running legacy extraction..." -ForegroundColor Yellow

    $proc = Start-Process -FilePath $InstallerPath -ArgumentList "/s", "/extract", "`"$OutputFolder`"" -Wait -PassThru -NoNewWindow

    if ($proc.ExitCode -ne 0) {
        throw "SetupChipset.exe /s /extract returned exit code $($proc.ExitCode)"
    }

    $extracted = Get-ChildItem -Path $OutputFolder -Recurse -File -ErrorAction SilentlyContinue
    if (-not $extracted -or $extracted.Count -eq 0) {
        throw "/s /extract reported success but '$OutputFolder' is empty"
    }

    # Count files and folders
    $FileCountRef.Value = (Get-ChildItem -Path $OutputFolder -Recurse -File -ErrorAction SilentlyContinue).Count
    $DirCountRef.Value = (Get-ChildItem -Path $OutputFolder -Recurse -Directory -ErrorAction SilentlyContinue).Count

    Write-Host " Legacy extraction completed." -ForegroundColor Green
    return $OutputFolder
}

function Invoke-NanaZipExtraction {
    param(
        [string]$InstallerPath,
        [string]$VersionString,
        [string]$OutputFolder,
        [ref]$FileCountRef,
        [ref]$DirCountRef
    )

    # Ensure NanaZip is set up
    $null = Setup-NanaZip

    # Clean temp (keep NanaZip)
    if (Test-Path $TempRoot) {
        Get-ChildItem -Path $TempRoot -Exclude "NanoZip" | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    }

    $stage1 = Join-Path $TempRoot "Stage_1"
    $stage2 = Join-Path $TempRoot "Stage_2"
    New-Item -ItemType Directory -Path $stage1 -Force | Out-Null
    New-Item -ItemType Directory -Path $stage2 -Force | Out-Null

    # --- Stage 1: extract SetupChipset.exe ---
    Write-Log "Stage 1: extracting PE overlay from installer" "INFO"
    Write-Host " Stage 1: Extracting installer overlay..." -ForegroundColor Yellow
    & $NanaZipExe x -t# "$InstallerPath" -o"$stage1" -y | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "NanaZip Stage 1 (PE overlay extraction) failed with exit code $LASTEXITCODE"
    }

    $chipsetInstaller = Get-ChildItem -Path $stage1 -Recurse -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -match '^\d+\.ChipsetInstaller\.exe$' } | Select-Object -First 1

    if (-not $chipsetInstaller) {
        throw "Stage 1 completed but no file matching '<number>.ChipsetInstaller.exe' was found in $stage1"
    }
    Write-Debug "Stage 1: found $($chipsetInstaller.Name)"

    # --- Stage 2: extract ChipsetInstaller.exe ---
    Write-Log "Stage 2: extracting PE overlay from $($chipsetInstaller.Name)" "INFO"
    Write-Host " Stage 2: Extracting ChipsetInstaller overlay..." -ForegroundColor Yellow
    & $NanaZipExe x -t# "$($chipsetInstaller.FullName)" -o"$stage2" -y | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "NanaZip Stage 2 (ChipsetInstaller overlay extraction) failed with exit code $LASTEXITCODE"
    }

    $innerZip = Get-ChildItem -Path $stage2 -Recurse -File -Filter "*.zip" -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -match '^\d+\.zip$' } | Select-Object -First 1

    if (-not $innerZip) {
        Write-Log "No file matching '<number>.zip' found, falling back to any .zip in Stage 2" "WARNING"
        $innerZip = Get-ChildItem -Path $stage2 -Recurse -File -Filter "*.zip" -ErrorAction SilentlyContinue | Select-Object -First 1
    }

    if (-not $innerZip) {
        throw "Stage 2 completed but no .zip file was found in $stage2"
    }
    Write-Debug "Stage 2: found $($innerZip.Name)"

    # --- Stage 3: extract final zip to a temporary location ---
    Write-Log "Stage 3: extracting $($innerZip.Name) to final output" "INFO"
    Write-Host " Stage 3: Extracting final INF package..." -ForegroundColor Yellow
    
    # Create output folder
    if (-not (Test-Path $OutputFolder)) {
        New-Item -ItemType Directory -Path $OutputFolder -Force | Out-Null
    }
    
    # Extract to a temp folder first
    $tempExtract = Join-Path $TempRoot "Stage_3_Extract"
    New-Item -ItemType Directory -Path $tempExtract -Force | Out-Null
    
    & $NanaZipExe x "$($innerZip.FullName)" -o"$tempExtract" -y | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "NanaZip Stage 3 (final zip extraction) failed with exit code $LASTEXITCODE"
    }
    
    # Check if there's a Drivers subfolder and move contents
    $driversFolder = Join-Path $tempExtract "Drivers"
    if (Test-Path $driversFolder) {
        Write-Host " Moving files from Drivers subfolder to output folder..." -ForegroundColor Yellow
        # Move all contents from Drivers to OutputFolder
        Get-ChildItem -Path $driversFolder -Recurse | Move-Item -Destination $OutputFolder -Force -ErrorAction SilentlyContinue
        # Remove empty Drivers folder with -Recurse
        Remove-Item -Path $driversFolder -Recurse -Force -ErrorAction SilentlyContinue
    } else {
        # If no Drivers folder, move everything from temp to output
        Write-Host " Moving extracted files to output folder..." -ForegroundColor Yellow
        Get-ChildItem -Path $tempExtract -Recurse | Move-Item -Destination $OutputFolder -Force -ErrorAction SilentlyContinue
    }
    
    # Clean up temp extract folder
    Remove-Item -Path $tempExtract -Recurse -Force -ErrorAction SilentlyContinue

    # Verify extraction - count files
    $finalFiles = Get-ChildItem -Path $OutputFolder -Recurse -File -ErrorAction SilentlyContinue
    if (-not $finalFiles -or $finalFiles.Count -eq 0) {
        throw "Stage 3 completed but '$OutputFolder' is empty"
    }
    
    # Count files and folders for summary
    $FileCountRef.Value = $finalFiles.Count
    $DirCountRef.Value = (Get-ChildItem -Path $OutputFolder -Recurse -Directory -ErrorAction SilentlyContinue).Count
    Write-Host " Files extracted: $($FileCountRef.Value)" -ForegroundColor Green
    Write-Host " Folders created: $($DirCountRef.Value)" -ForegroundColor Green
    Write-Host ""

    # --- Cleanup temp (keep NanaZip) ---
    Write-Log "Cleaning up temp (keeping NanaZip)" "INFO"
    Get-ChildItem -Path $TempRoot -Exclude "NanoZip" | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host " NanaZip extraction completed." -ForegroundColor Green
    
    return $OutputFolder
}

# =============================================
# PROCESS SINGLE INSTALLER - przetwarza pojedynczy instalator (dla trybu pojedynczego pliku)
# =============================================
function Process-SingleInstaller {
    param(
        [string]$InstallerPath,
        [string]$VersionString,
        [string]$OutputFolder,
        [ref]$FileCountRef,
        [ref]$DirCountRef,
        [string]$ExtractionMethod
    )
    
    Write-Host " Processing: $(Split-Path $InstallerPath -Leaf)" -ForegroundColor Cyan
    Write-Host " Path: $InstallerPath" -ForegroundColor Gray
    Write-Host ""
    Write-Host " Detected version: $VersionString" -ForegroundColor Cyan
    Write-Host " Method: $ExtractionMethod" -ForegroundColor Yellow
    Write-Host " Output folder: $OutputFolder" -ForegroundColor Gray
    Write-Host ""
    
    # Extract
    if ($ExtractionMethod -eq "NanaZip 3-stage") {
        Write-Log "Using NanaZip 3-stage extraction (modern installer)" "INFO"
        $finalOutput = Invoke-NanaZipExtraction -InstallerPath $InstallerPath -VersionString $VersionString -OutputFolder $OutputFolder -FileCountRef $FileCountRef -DirCountRef $DirCountRef
    } else {
        Write-Log "Using legacy /s /extract" "INFO"
        $finalOutput = Invoke-LegacyExtraction -InstallerPath $InstallerPath -VersionString $VersionString -OutputFolder $OutputFolder -FileCountRef $FileCountRef -DirCountRef $DirCountRef
    }
    
    Write-Host " SUCCESS: $($FileCountRef.Value) files extracted to $finalOutput" -ForegroundColor Green
    Write-Host ""
    
    return $finalOutput
}

# =============================================
# PROCESS MULTIPLE INSTALLERS - przetwarza wiele instalatorów
# =============================================
function Process-MultipleInstallers {
    param(
        [array]$Installers
    )
    
    $results = @()
    $successCount = 0
    $failCount = 0
    $totalCount = $Installers.Count
    
    for ($i = 0; $i -lt $totalCount; $i++) {
        $installerPath = $Installers[$i]
        
        if ($i -gt 0) {
            Write-Host " --------------------------------" -ForegroundColor DarkGray
            Write-Host ""
        }
        Write-Host " [$($i+1)/$totalCount] Processing: $(Split-Path $installerPath -Leaf)" -ForegroundColor Cyan
        Write-Host " Path: $installerPath" -ForegroundColor Gray
        Write-Host ""

        $versionString = $null
        try {
            # Get version
            $ver, $versionString = Get-InstallerVersion -Path $installerPath
            Write-Host " Detected version: $versionString" -ForegroundColor Cyan

            # Determine category and output folder
            $category = $null
            $subfolder = $null
            $extractionMethod = $null

            if ($ver.Major -eq 10 -and $ver.Minor -eq 0) {
                $category = "Legacy10_0"
                $subfolder = "$($ver.ToString())\Legacy"
                $extractionMethod = "Legacy /s /extract"
            } elseif ($ver.Major -eq 10 -and $ver.Minor -eq 1 -and $ver -ge $NewFormatFloor) {
                $category = "NanaZipModern"
                $subfolder = $versionString
                $extractionMethod = "NanaZip 3-stage"
            } elseif ($ver.Major -eq 10 -and ($ver.Minor -eq 1 -or $ver.Minor -eq 2)) {
                $category = "OldCommand"
                $subfolder = $versionString
                $extractionMethod = "Legacy /s /extract"
            } else {
                throw "Version $versionString is not a recognized Intel Chipset Device Software version (expected 10.0.x.x, 10.1.x.x, or 10.2.x.x)"
            }

            $OutputFolder = Join-Path $FinalRoot $subfolder
            Write-Host " Method: $extractionMethod" -ForegroundColor Yellow
            Write-Host " Output folder: $OutputFolder" -ForegroundColor Gray
            Write-Host ""

            # Initialize counters
            $fileCount = 0
            $dirCount = 0
            $fileCountRef = [ref]$fileCount
            $dirCountRef = [ref]$dirCount

            # Extract
            if ($category -eq "NanaZipModern") {
                Write-Log "Using NanaZip 3-stage extraction (modern installer)" "INFO"
                $finalOutput = Invoke-NanaZipExtraction -InstallerPath $installerPath -VersionString $versionString -OutputFolder $OutputFolder -FileCountRef $fileCountRef -DirCountRef $dirCountRef
            } else {
                Write-Log "Using legacy /s /extract" "INFO"
                $finalOutput = Invoke-LegacyExtraction -InstallerPath $installerPath -VersionString $versionString -OutputFolder $OutputFolder -FileCountRef $fileCountRef -DirCountRef $dirCountRef
            }

            Write-Host " SUCCESS: $($fileCountRef.Value) files extracted to $finalOutput" -ForegroundColor Green
            Write-Host ""

            $results += @{
                Success   = $true
                Path      = $finalOutput
                Version   = $versionString
                Method    = $extractionMethod
                FileCount = $fileCountRef.Value
                DirCount  = $dirCountRef.Value
                Error     = $null
            }
            $successCount++

        } catch {
            $errorMessage = $_.Exception.Message
            Write-Log "FAILED: $(Split-Path $installerPath -Leaf) -- $errorMessage" "ERROR"
            Write-Host " FAILED: $errorMessage" -ForegroundColor Red
            Write-Host " Skipping this installer, continuing with the next one..." -ForegroundColor Yellow
            Write-Host ""

            $results += @{
                Success   = $false
                Path      = $installerPath
                Version   = if ($versionString) { $versionString } else { "Unknown" }
                Method    = "N/A"
                FileCount = 0
                DirCount  = 0
                Error     = $errorMessage
            }
            $failCount++
        }
    }
    
    return @{
        Results      = $results
        SuccessCount = $successCount
        FailCount    = $failCount
        TotalCount   = $totalCount
    }
}

# =============================================
# MAIN EXECUTION
# =============================================
try {
    Show-Screen1

    # --- SCRIPT INTEGRITY VERIFICATION ---
    Write-Host " Verifying extractor authenticity..." -ForegroundColor Yellow
    Write-Host ""
    Write-Host " Testing GitHub connectivity..." -ForegroundColor Yellow
    $hashStatus = Test-ScriptAuthenticity

    switch ($hashStatus) {
        "OK" {
            Write-Host " GitHub connectivity: PASSED" -ForegroundColor Green
            Write-Host " Integrity check: PASSED (matches official GitHub source)" -ForegroundColor Green
            Write-Host ""
        }
        "MISMATCH" {
            Write-Host " GitHub connectivity: PASSED" -ForegroundColor Green
            Write-Host ""
            Write-Host " WARNING: This Extractor may have been modified." -ForegroundColor Red
            Write-Host " It is NOT the official version published on GitHub." -ForegroundColor Red
            Write-Host ""
            Write-Host " Expected: $script:ExpectedHash" -ForegroundColor Gray
            Write-Host " Actual:   $script:ActualHash" -ForegroundColor Gray
            Write-Host ""
            Write-Host " Official source: $GitHubRawBaseUrl" -ForegroundColor Cyan
            Write-Host ""
            if (-not (Confirm-ContinueDespiteRisk)) {
                Write-Log "User aborted after hash mismatch" "WARNING"
                Show-FinalCredits
                exit 1
            }
            Write-Host ""
        }
        "NO_CONNECTIVITY" {
            Write-Host " GitHub connectivity: FAILED" -ForegroundColor Red
            Write-Host ""
            Write-Host " WARNING: Could not verify HASH from GitHub." -ForegroundColor Yellow
            Write-Host ""
            Write-Host " The integrity cannot be confirmed right now." -ForegroundColor Yellow
            Write-Host " Please check your internet connection." -ForegroundColor Yellow
            Write-Host ""
            if (-not (Confirm-ContinueDespiteRisk)) {
                Write-Log "User aborted after GitHub connectivity failure" "WARNING"
                Show-FinalCredits
                exit 1
            }
            Write-Host ""
        }
        "FETCH_FAILED" {
            Write-Host " GitHub connectivity: PASSED" -ForegroundColor Green
            Write-Host ""
            Write-Host " WARNING: Could not verify HASH from GitHub." -ForegroundColor Yellow
            Write-Host ""
            Write-Host " GitHub is reachable, but the expected hash file could not be" -ForegroundColor Yellow
            Write-Host " downloaded or parsed (wrong path, or file not published yet)." -ForegroundColor Yellow
            Write-Host " The integrity cannot be confirmed right now." -ForegroundColor Yellow
            Write-Host ""
            if (-not (Confirm-ContinueDespiteRisk)) {
                Write-Log "User aborted after hash fetch failure" "WARNING"
                Show-FinalCredits
                exit 1
            }
            Write-Host ""
        }
    }

    # Determine search path
    $searchPath = $InstallerPath
    $searchMode = "none"
    if ($searchPath -and (Test-Path $searchPath) -and ((Get-Item $searchPath).PSIsContainer)) {
        # User provided a directory
        $searchMode = "directory"
        Write-Host " Searching for Intel Chipset installers in: $searchPath" -ForegroundColor Yellow
        Write-Host " (including subdirectories)" -ForegroundColor Gray
        Write-Host ""
    } elseif ($searchPath) {
        # User provided a file path (may or may not exist)
        $searchMode = "file"
        Write-Host " Checking specified file: $searchPath" -ForegroundColor Yellow
        Write-Host ""
    } else {
        Write-Host " Searching for Intel Chipset installers in current directory..." -ForegroundColor Yellow
        Write-Host ""
    }

    # Find all installers
    $installers = Find-Installers -Path $searchPath

    if ($installers.Count -eq 0) {
        if ($searchMode -eq "file" -and (Test-Path $searchPath)) {
            Write-Host " The specified file is not a recognized Intel Chipset Device Software." -ForegroundColor Red
            Write-Host ""
            Write-Host " This tool only extracts Intel Chipset Device Software." -ForegroundColor Yellow
            Write-Host " You need the SetupChipset.exe and similar Intel Chipset INF installers." -ForegroundColor Yellow
            Write-Host " Verify this is the correct file." -ForegroundColor Yellow
        } elseif ($searchMode -eq "file") {
            Write-Host " The specified path does not exist:" -ForegroundColor Red
            Write-Host " $searchPath" -ForegroundColor Red
        } elseif ($searchMode -eq "directory") {
            Write-Host " No Intel Chipset Device Software installers found in:" -ForegroundColor Red
            Write-Host " $searchPath (including subdirectories)" -ForegroundColor Red
        } else {
            Write-Host " No Intel Chipset Device Software installers found." -ForegroundColor Red
            Write-Host ""
            Write-Host " 1. Place SetupChipset.exe file in the folder the extractor is run from." -ForegroundColor Yellow
            Write-Host " 2. Run the extractor with a path to a specific file or directory." -ForegroundColor Yellow
        }
        Write-Host ""
        Write-Host " Example: PS .\universal-intel-inf-extractor.ps1 D:\Sample\Install.exe" -ForegroundColor Gray
        Write-Host " Example: PS .\universal-intel-inf-extractor.ps1 D:\Intel_Installers\" -ForegroundColor Gray
        Write-Host ""
        Write-Host " Press any key to exit..." -ForegroundColor Gray
        Write-Host ""
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        Show-FinalCredits
        exit 1
    }

    Write-Log "Found $($installers.Count) Intel installer(s)" "INFO"
    
    # Show found installers
    if ($installers.Count -eq 1) {
        Write-Host " Found 1 Intel Chipset installer:" -ForegroundColor Green
        try {
            $verInfo = (Get-Item $installers[0]).VersionInfo
            $ver = $verInfo.FileVersion
            if (-not $ver) { $ver = $verInfo.ProductVersion }
            Write-Host " - $(Split-Path $installers[0] -Leaf) (v$ver)" -ForegroundColor Gray
        } catch {
            Write-Host " - $(Split-Path $installers[0] -Leaf)" -ForegroundColor Gray
        }
        Write-Host ""
    } else {
        Write-Host " Found $($installers.Count) Intel Chipset installers:" -ForegroundColor Green
        foreach ($inst in $installers) {
            try {
                $verInfo = (Get-Item $inst).VersionInfo
                $ver = $verInfo.FileVersion
                if (-not $ver) { $ver = $verInfo.ProductVersion }
                Write-Host " - $(Split-Path $inst -Leaf) (v$ver)" -ForegroundColor Gray
            } catch {
                Write-Host " - $(Split-Path $inst -Leaf)" -ForegroundColor Gray
            }
        }
        Write-Host ""
    }
    Start-Sleep -Seconds 2

    # --- SINGLE INSTALLER MODE ---
    if ($installers.Count -eq 1) {
        $foundInstaller = $installers[0]
        
        Write-Log "Installer detected: $foundInstaller" "INFO"
        Write-Host " Installer found: $foundInstaller" -ForegroundColor Green
        Write-Host ""
        Start-Sleep -Seconds 2

        Show-Screen2

        Write-Host " Reading installer version..." -ForegroundColor Yellow
        Write-Host ""

        try {
            $ver, $versionString = Get-InstallerVersion -Path $foundInstaller
        } catch {
            Exit-WithFailure -Reason "Version detection failed for '$foundInstaller': $($_.Exception.Message)" -FailedInstaller $foundInstaller
        }

        Write-Log "Detected Intel installer version: $versionString" "INFO"
        Write-Host " Detected Intel Chipset Device Software version: $versionString" -ForegroundColor Cyan
        Write-Host ""
        Start-Sleep -Seconds 2

        # --- Determine category and output folder ---
        $category = $null
        $subfolder = $null
        $extractionMethod = $null

        if ($ver.Major -eq 10 -and $ver.Minor -eq 0) {
            $category = "Legacy10_0"
            $subfolder = "$($ver.ToString())\Legacy"
            $extractionMethod = "Legacy /s /extract"
        } elseif ($ver.Major -eq 10 -and $ver.Minor -eq 1 -and $ver -ge $NewFormatFloor) {
            $category = "NanaZipModern"
            $subfolder = $versionString
            $extractionMethod = "NanaZip 3-stage"
        } elseif ($ver.Major -eq 10 -and ($ver.Minor -eq 1 -or $ver.Minor -eq 2)) {
            $category = "OldCommand"
            $subfolder = $versionString
            $extractionMethod = "Legacy /s /extract"
        } else {
            Exit-WithFailure -Reason "Version $versionString is not a recognized Intel Chipset Device Software version (expected 10.0.x.x, 10.1.x.x, or 10.2.x.x)" -FailedInstaller $foundInstaller -FailedVersion $versionString
        }

        Write-Debug "Version category: $category"
        Write-Debug "Output subfolder: $subfolder"

        # --- Set output folder ---
        $OutputFolder = Join-Path $FinalRoot $subfolder

        Write-Host " Output folder: $OutputFolder" -ForegroundColor Gray
        Write-Host ""

        Show-Screen3

        # --- Initialize counters ---
        $fileCount = 0
        $dirCount = 0
        $fileCountRef = [ref]$fileCount
        $dirCountRef = [ref]$dirCount

        # --- Process single installer ---
        try {
            $finalOutput = Process-SingleInstaller -InstallerPath $foundInstaller -VersionString $versionString -OutputFolder $OutputFolder -FileCountRef $fileCountRef -DirCountRef $dirCountRef -ExtractionMethod $extractionMethod
        } catch {
            Exit-WithFailure -Reason "Extraction failed for '$foundInstaller': $($_.Exception.Message)" -FailedInstaller $foundInstaller -FailedVersion $versionString
        }

        # Get counts from refs
        $fileCount = $fileCountRef.Value
        $dirCount = $dirCountRef.Value

        # --- Show Screen 4 with full summary ---
        Show-Screen4 -ExtractionMethod $extractionMethod -OutputFolder $finalOutput -VersionString $versionString -FileCount $fileCount -DirCount $dirCount

    # --- MULTIPLE INSTALLERS MODE ---
    } else {
        Show-Screen2
        
        Write-Host " Processing $($installers.Count) installers..." -ForegroundColor Yellow
        Write-Host ""
        Start-Sleep -Seconds 2
        
        Show-Screen3
        
        # Process all installers
        $result = Process-MultipleInstallers -Installers $installers
        
        # Show summary
        if ($result.SuccessCount -gt 0 -or $result.FailCount -gt 0) {
            # Dla wielu instalatorów pokazujemy podsumowanie zbiorcze
            Show-Screen4 -ExtractionMethod "Multiple ($($result.SuccessCount)/$($result.TotalCount))" -OutputFolder $FinalRoot -VersionString "Various" -FileCount $result.SuccessCount -DirCount 0

            # Show detailed summary
            Write-Host ""
            Write-Host " Summary of extracted packages:" -ForegroundColor Cyan
            Write-Host " ==============================" -ForegroundColor Cyan
            Write-Host ""
            foreach ($r in $result.Results) {
                if ($r.Success) {
                    Write-Host " Version: $($r.Version)" -ForegroundColor Yellow
                    Write-Host "   Status: SUCCESS" -ForegroundColor Green
                    Write-Host "   Method: $($r.Method)" -ForegroundColor Gray
                    Write-Host "   Location: $($r.Path)" -ForegroundColor Gray
                    Write-Host "   Files: $($r.FileCount), Folders: $($r.DirCount)" -ForegroundColor Gray
                } else {
                    Write-Host " File: $(Split-Path $r.Path -Leaf)" -ForegroundColor Yellow
                    Write-Host "   Status: FAILED" -ForegroundColor Red
                    Write-Host "   Reason: $($r.Error)" -ForegroundColor Gray
                }
                Write-Host ""
            }

            if ($result.FailCount -gt 0) {
                Write-Host " Successfully extracted $($result.SuccessCount) of $($result.TotalCount) package(s), $($result.FailCount) failed." -ForegroundColor Yellow
                Write-Host " See details above (and the log file) for failure reasons." -ForegroundColor Gray
                Write-Host ""

                $failedItems = @()
                foreach ($r in $result.Results) {
                    if (-not $r.Success) {
                        $failedItems += @{
                            FileName = Split-Path $r.Path -Leaf
                            Path     = $r.Path
                            Version  = $r.Version
                            Reason   = $r.Error
                        }
                    }
                }
                Write-FailedReport -FailedItems $failedItems
            } else {
                Write-Host " Successfully extracted $($result.SuccessCount) of $($result.TotalCount) package(s)." -ForegroundColor Green
                Write-Host ""
            }
        } else {
            Show-Screen4 -ExtractionMethod "None" -OutputFolder $FinalRoot -VersionString "Failed" -FileCount 0 -DirCount 0
            Write-Host ""
            Write-Host " No packages were successfully extracted." -ForegroundColor Red
            Write-Host ""
        }
    }

    # --- PAUZA - czekamy na ENTER ---
    Write-Host " Press ENTER to continue..." -ForegroundColor Gray
    Write-Host ""
    Read-Host

    # --- THANK YOU - zastępuje ekran 4/4 ---
    Show-FinalCredits
    
    exit 0

} catch {
    Write-Log "Unhandled error: $($_.Exception.Message)" "ERROR"
    Write-Host ""
    Write-Host " An unexpected error occurred." -ForegroundColor Red
    Write-Host " Please check the log file at: $LogFile" -ForegroundColor Yellow
    Write-Host ""
    Write-Host " Press any key to exit..." -ForegroundColor Gray
    Write-Host ""
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    Show-FinalCredits
    exit 1
}
