<#
.SYNOPSIS
    Unblocks Windows Installer by killing hanging msiexec processes and resetting the service.
.DESCRIPTION
    This script resolves Error 1618 and 1603 by:
    1. Killing all hanging msiexec.exe processes
    2. Resetting the Windows Installer service
    Run as Administrator before attempting any MSI installation.
#>

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  UNBLOCK WINDOWS INSTALLER" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[1/3] Checking for hanging msiexec processes..." -ForegroundColor Yellow

# Kill hanging msiexec processes
$msiexec = Get-Process -Name msiexec -ErrorAction SilentlyContinue
if ($msiexec) {
    Write-Host "      Found $($msiexec.Count) hanging process(es). Killing..." -ForegroundColor Red
    $msiexec | Stop-Process -Force
    Start-Sleep -Seconds 2
    Write-Host "      Processes killed." -ForegroundColor Green
} else {
    Write-Host "      No hanging processes found." -ForegroundColor Green
}

Write-Host ""
Write-Host "[2/3] Resetting Windows Installer service..." -ForegroundColor Yellow

# Reset Windows Installer service
Write-Host "      Unregistering Windows Installer..." -ForegroundColor Gray
msiexec /unregister
Start-Sleep -Seconds 2

Write-Host "      Registering Windows Installer..." -ForegroundColor Gray
msiexec /regserver

Write-Host "      Windows Installer reset complete." -ForegroundColor Green

Write-Host ""
Write-Host "[3/3] Verification..." -ForegroundColor Yellow

# Check if any msiexec processes are still running
$remaining = Get-Process -Name msiexec -ErrorAction SilentlyContinue
if ($remaining) {
    Write-Host "      WARNING: $($remaining.Count) msiexec process(es) still running." -ForegroundColor Yellow
    Write-Host "      You may need to restart your computer to fully unblock." -ForegroundColor Yellow
} else {
    Write-Host "      Windows Installer is now unblocked." -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Windows Installer is ready!" -ForegroundColor Green
Write-Host "  You can now run the Chipset Updater." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""