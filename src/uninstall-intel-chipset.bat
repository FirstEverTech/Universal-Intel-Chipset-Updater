@echo off
setlocal enabledelayedexpansion

:: Intel Chipset Device Software Uninstaller
:: This batch file launches the PowerShell uninstall script with administrator privileges.

:: Set console window size
mode con: cols=75 lines=45

echo /**************************************************************************
echo **              INTEL CHIPSET DEVICE SOFTWARE UNINSTALLER                **
echo ** --------------------------------------------------------------------- **
echo **                                                                       **
echo **         Removes all installed versions of Intel Chipset software      **
echo **         including old EXE-based and new MSI-based packages.           **
echo **         Note: This tool does not remove installed INF files.          **
echo **                                                                       **
echo **              Author: Marcin Grygiel / www.firstever.tech              **
echo **                                                                       **
echo ** --------------------------------------------------------------------- **
echo **         This tool is not affiliated with Intel Corporation.           **
echo **         Use at your own risk.                                         **
echo ** --------------------------------------------------------------------- **
echo **                                                                       **
echo **    Visit: github.com/FirstEverTech/Universal-Intel-Chipset-Updater    **
echo **                                                                       **
echo *************************************************************************/
echo.

:: Get the directory where this batch file is located
set "SCRIPT_DIR=%~dp0"

:: Check if PowerShell script exists in the same directory
if not exist "!SCRIPT_DIR!uninstall-intel-chipset.ps1" (
    echo Error: uninstall-intel-chipset.ps1 not found in current directory!
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

echo Running Intel Chipset uninstaller...
echo.

:: Change to script directory to ensure proper file access
cd /d "!SCRIPT_DIR!"

:: Run PowerShell script with execution policy bypass
powershell -ExecutionPolicy Bypass -File "uninstall-intel-chipset.ps1"