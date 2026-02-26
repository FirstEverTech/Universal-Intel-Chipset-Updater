<#
.SYNOPSIS
    Uninstalls all versions of Intel Chipset Device Software (both old EXE-based and new MSI-based)
.DESCRIPTION
    This script searches the registry for installed versions of Intel Chipset Device Software
    (DisplayName containing "Intel(R) Chipset Device Software" or "SetupChipset") and uninstalls
    them silently. It supports both 32-bit and 64-bit installations.
    If the uninstaller executable is missing, the script removes the orphaned registry entry.
    A system restore point is created before any changes.
.NOTES
    Requires administrator privileges. The script will automatically elevate if not run as admin.
    Author: Based on concept by Marcin Grygiel / www.firstever.tech
    This script is not affiliated with Intel Corporation. Use at your own risk.
#>

#region Elevation
# Check if running as administrator, if not, restart with elevation
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Not running as administrator. Requesting elevation..." -ForegroundColor Yellow
    Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}
#endregion

#region Restore Point
# Create a system restore point before making changes
try {
    Checkpoint-Computer -Description "Before Intel Chipset Uninstall" -RestorePointType MODIFY_SETTINGS -ErrorAction Stop
    Write-Host "System restore point created successfully." -ForegroundColor Green
} catch {
    Write-Host "Could not create restore point. Ensure System Protection is enabled for your system drive." -ForegroundColor Yellow
}
#endregion

#region Configuration
$logFile = Join-Path $env:TEMP "Intel_Chipset_Uninstall.log"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
"[$timestamp] Starting uninstall script..." | Out-File -FilePath $logFile -Append

# Define display name patterns to match
$patterns = @(
    "Intel(R) Chipset Device Software",
    "SetupChipset"
)

# Registry paths to search (both 64-bit and 32-bit views)
$regPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
)
#endregion

#region Functions
function Remove-RegistryEntry {
    param(
        [string]$regPath
    )
    try {
        Remove-Item -Path $regPath -Recurse -Force -ErrorAction Stop
        Write-Host "Removed orphaned registry entry: $regPath" -ForegroundColor Gray
        "[$timestamp] Removed orphaned registry entry: $regPath" | Out-File -FilePath $logFile -Append
    } catch {
        Write-Warning "Failed to remove registry entry $regPath : $_"
    }
}

function Uninstall-Product {
    param(
        [string]$displayName,
        [string]$version,
        [string]$uninstallCmd,
        [string]$regPath
    )
    if (-not $uninstallCmd) {
        Write-Warning "No uninstall command found for $displayName at $regPath"
        return $false
    }

    # Extract the executable path and arguments
    if ($uninstallCmd -match '^"([^"]+)"(.*)$' -or $uninstallCmd -match "^([^ ]+) (.*)$") {
        $exe = $matches[1].Trim('"')
        $args = $matches[2].Trim()
    } else {
        $exe = $uninstallCmd
        $args = ""
    }

    # Check if the executable exists (or for MSI, check if it's a valid path)
    if ($exe -match 'MsiExec\.exe') {
        # For MsiExec, we don't need to check file existence; it's a system component
    } else {
        if (-not (Test-Path $exe)) {
            Write-Host "Uninstaller executable not found: $exe" -ForegroundColor Yellow
            Write-Host "Removing orphaned registry entry for $displayName" -ForegroundColor Gray
            Remove-RegistryEntry -regPath $regPath
            return $false
        }
    }

    Write-Host "Uninstalling: $displayName" -ForegroundColor Cyan
    if ($version) {
        Write-Host "Version: $version"
    }
    Write-Host "Command: $uninstallCmd"
    try {
        $process = Start-Process -FilePath $exe -ArgumentList $args -Wait -PassThru -NoNewWindow -ErrorAction Stop
        if ($process.ExitCode -eq 0) {
            Write-Host "Uninstall successful (exit code 0)." -ForegroundColor Green
            return $true
        } else {
            Write-Host "Uninstall completed with exit code $($process.ExitCode)." -ForegroundColor Yellow
            return $false
        }
    } catch {
        if ($_.Exception.Message -like "*The system cannot find the file specified*") {
            Write-Host "Uninstaller executable not found (exception): $exe" -ForegroundColor Yellow
            Remove-RegistryEntry -regPath $regPath
        } else {
            Write-Host "Error during uninstall: $_" -ForegroundColor Red
        }
        return $false
    }
}

function Get-UninstallCommand {
    param(
        [PSObject]$product
    )
    # Prefer QuietUninstallString if it exists
    if ($product.QuietUninstallString) {
        return $product.QuietUninstallString
    }
    # Otherwise use UninstallString and try to make it silent
    if ($product.UninstallString) {
        $cmd = $product.UninstallString
        # For MSI, ensure it's a silent removal
        if ($cmd -match 'MsiExec\.exe') {
            # Add /quiet if not already present
            if ($cmd -notmatch '/quiet|/qn') {
                $cmd = "$cmd /quiet"
            }
            # Add /norestart if not already present
            if ($cmd -notmatch '/norestart') {
                $cmd = "$cmd /norestart"
            }
            # Add REMOVE=ALL if not already present
            if ($cmd -notmatch 'REMOVE=ALL|REMOVE=All|remove=all') {
                $cmd = "$cmd REMOVE=ALL"
            }
        }
        # For EXE, we rely on QuietUninstallString, but if not present, we'll just run the string as is (may prompt)
        return $cmd
    }
    return $null
}
#endregion

#region Main script
Write-Host "===========================================================================" -ForegroundColor Magenta
Write-Host "                 Intel Chipset Device Software Uninstaller" -ForegroundColor Magenta
Write-Host "===========================================================================" -ForegroundColor Magenta
Write-Host "This script will remove all detected versions of Intel Chipset software."
Write-Host "Log file: $logFile"
Write-Host ""

$products = @()
foreach ($regPath in $regPaths) {
    if (Test-Path $regPath) {
        Get-ChildItem $regPath | ForEach-Object {
            $product = Get-ItemProperty $_.PSPath
            $displayName = $product.DisplayName
            if ($displayName) {
                foreach ($pattern in $patterns) {
                    if ($displayName -like "*$pattern*") {
                        $version = if ($product.DisplayVersion) { $product.DisplayVersion } else { "Unknown" }
                        $products += [PSCustomObject]@{
                            DisplayName = $displayName
                            Version     = $version
                            RegPath     = $_.PSPath
                            Product     = $product
                        }
                        break
                    }
                }
            }
        }
    }
}

if ($products.Count -eq 0) {
    Write-Host "No Intel Chipset Device Software installations found." -ForegroundColor Yellow
    "[$timestamp] No products found." | Out-File -FilePath $logFile -Append
} else {
    Write-Host "The following installations were found:" -ForegroundColor Yellow
    $products | ForEach-Object { 
        if ($_.Version -ne "Unknown") {
            Write-Host "  - $($_.DisplayName) [Version: $($_.Version)]"
        } else {
            Write-Host "  - $($_.DisplayName)"
        }
    }

    $confirmation = Read-Host "`nDo you want to uninstall ALL of them? (Y/N)"
    if ($confirmation -eq 'Y' -or $confirmation -eq 'y') {
        Write-Host ""
        Write-Host "Starting uninstall process..." -ForegroundColor Magenta
        $products | ForEach-Object {
            $cmd = Get-UninstallCommand -product $_.Product
            Uninstall-Product -displayName $_.DisplayName -version $_.Version -uninstallCmd $cmd -regPath $_.RegPath
        }
    } else {
        Write-Host "Uninstall cancelled by user." -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Uninstall process completed. See log at $logFile"
Write-Host "`nPress any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
#endregion