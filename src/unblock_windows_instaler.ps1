# ============================================================
# FUNCTION Unblock Windows Installer
# ============================================================
function Unblock-WindowsInstaller {
    Write-Host `n[MAINTENANCE] Unblocking Windows Installer... -ForegroundColor Yellow
    
    # Kill hanging msiexec processes
    Get-Process -Name msiexec -ErrorAction SilentlyContinue  Stop-Process -Force
    
    # Stop Windows Update service
    Stop-Service wuauserv -Force -ErrorAction SilentlyContinue
    
    # Reset Windows Installer
    msiexec unregister
    Start-Sleep -Seconds 2
    msiexec regserver
    
    Write-Host [MAINTENANCE] Windows Installer is now unblocked. -ForegroundColor Green
}

# ============================================================
# FUNCTION Restore Windows Update Service
# ============================================================
function Restore-WindowsUpdate {
    Write-Host `n[MAINTENANCE] Restoring Windows Update service... -ForegroundColor Yellow
    Start-Service wuauserv -ErrorAction SilentlyContinue
    Write-Host [MAINTENANCE] Windows Update service restored. -ForegroundColor Green
}

# ============================================================
# FUNCTION Install MSI Package
# ============================================================
function Install-MsiPackage {
    param(
        [string]$MsiPath,
        [switch]$Silent = $true
    )
    
    if (-not (Test-Path $MsiPath)) {
        Write-Host [INSTALL] ERROR MSI file not found $MsiPath -ForegroundColor Red
        return $false
    }
    
    Write-Host `n[INSTALL] Installing $MsiPath -ForegroundColor Yellow
    
    $arguments = i `$MsiPath`
    if ($Silent) {
        $arguments +=  quiet norestart
    }
    
    $process = Start-Process -FilePath msiexec.exe -ArgumentList $arguments -Wait -PassThru
    
    if ($process.ExitCode -eq 0 -or $process.ExitCode -eq 3010) {
        Write-Host [INSTALL] Installation successful. Exit code $($process.ExitCode) -ForegroundColor Green
        if ($process.ExitCode -eq 3010) {
            Write-Host   Note System restart is required. -ForegroundColor Yellow
        }
        return $true
    } else {
        Write-Host [INSTALL] Installation failed. Exit code $($process.ExitCode) -ForegroundColor Red
        return $false
    }
}

# ============================================================
# USAGE EXAMPLE
# ============================================================
# Unblock-WindowsInstaller
# Install-MsiPackage -MsiPath CSetupChipset.msi -Silent
# Restore-WindowsUpdate