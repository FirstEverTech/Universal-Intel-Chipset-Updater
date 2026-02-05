@echo off
setlocal enabledelayedexpansion

mode con: cols=75 lines=58

set "SCRIPT_DIR=%~dp0"

if not exist "!SCRIPT_DIR!universal-intel-chipset-updater.ps1" (
    echo Error: universal-intel-chipset-updater.ps1 not found in current directory!
    echo.
    echo Please ensure the PowerShell script is in the same folder as this BAT file.
    pause
    exit /b 1
)

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script requires administrator privileges.
    echo Requesting elevation...
    echo.
    
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs -WorkingDirectory '!SCRIPT_DIR!'"
    exit /b
)

cd /d "!SCRIPT_DIR!"

powershell -ExecutionPolicy Bypass -File "universal-intel-chipset-updater.ps1"
if %errorlevel% EQU 100 exit /b 0
exit /b 0