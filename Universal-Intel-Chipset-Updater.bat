@echo off
setlocal enabledelayedexpansion

:: Intel Chipset Driver Update Tool
:: Requires administrator privileges

:: Set console window size to 75 columns and 64 lines
mode con: cols=75 lines=64

echo /*************************************************************************
echo **                    UNIVERSAL INTEL CHIPSET UPDATER                    **
echo ** --------------------------------------------------------------------- **
echo **                                                                       **
echo **                    Drivers Version: 10.1 (2025.11)                    **
echo **                                                                       **
echo **              Author: Marcin Grygiel / www.firstever.tech              **
echo **                                                                       **
echo ** --------------------------------------------------------------------- **
echo **         This tool is not affiliated with Intel Corporation.           **
echo **         Drivers are sourced from official Intel servers.              **
echo **         Use at your own risk.                                         **
echo ** --------------------------------------------------------------------- **
echo **                                                                       **
echo **         GitHub.com/FirstEverTech/Intel-Chipset-Driver-Updater         **
echo **                                                                       **
echo *************************************************************************/
echo.

:: Get the directory where this batch file is located
set "SCRIPT_DIR=%~dp0"

:: Check if PowerShell script exists in the same directory
if not exist "!SCRIPT_DIR!Universal-Intel-Chipset-Updater.ps1" (
    echo Error: Universal-Intel-Chipset-Updater.ps1 not found in current directory!
    echo.
    echo Please ensure the PowerShell script is in the same folder as this BAT file.
    pause
    exit /b 1
)

:: Check for administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script requires administrator privileges.
    echo Requesting elevation...
    echo.
    
    :: Re-launch as administrator with the correct directory
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs -WorkingDirectory '!SCRIPT_DIR!'"
    exit /b
)

echo Running Universal Intel Chipset Updater...
echo.

:: Change to script directory to ensure proper file access
cd /d "!SCRIPT_DIR!"

:: Run PowerShell script with execution policy bypass
powershell -ExecutionPolicy Bypass -File "Universal-Intel-Chipset-Updater.ps1"

echo.
pause