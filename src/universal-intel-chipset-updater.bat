@echo off
setlocal enabledelayedexpansion

:: Intel Chipset Device Update Tool
:: Requires administrator privileges

:: Set console window size to 75 columns and 58 lines
mode con: cols=75 lines=58

:: Get the directory where this batch file is located
set "SCRIPT_DIR=%~dp0"

:: Check if PowerShell script exists in the same directory
if not exist "!SCRIPT_DIR!universal-intel-chipset-updater.ps1" (
    echo Error: universal-intel-chipset-updater.ps1 not found in current directory!
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

echo Starting the tool...
echo.

:: Change to script directory to ensure proper file access
cd /d "!SCRIPT_DIR!"

:: Run PowerShell script with execution policy bypass
powershell -ExecutionPolicy Bypass -File "universal-intel-chipset-updater.ps1"
set PS_EXIT_CODE=%errorlevel%

:: Check if new version was launched (exit code 100)
if %PS_EXIT_CODE% EQU 100 (
    echo New version launched successfully. Closing current window...
    exit /b 0
)

:: Remove the pause at the end since PS1 now handles pauses and credits
exit /b 0