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

:: ==========================================
:: PRE-LAUNCHER: System Checks
:: ==========================================
cls
echo ================================================
echo    Universal Intel Chipset Updater - Pre-Check
echo ================================================
echo.

:: Initialize warning counter
set "WARNINGS=0"

:: 1. Windows Version Check
echo [1] Checking Windows version...
for /f "tokens=4-5 delims=[.]" %%i in ('ver') do (
    set "WIN_BUILD=%%i"
    set "WIN_MINOR=%%j"
)

if defined WIN_BUILD (
    echo    Windows Build: !WIN_BUILD!
    if !WIN_BUILD! LSS 17763 (
        echo    [WARNING] Windows 10 LTSB 2015/2016 detected.
        echo            TLS 1.2 may not work properly.
        echo            Some features may be limited.
        set "WARNINGS=1"
    )
) else (
    echo    [INFO] Could not determine Windows build.
)
echo.

:: 2. .NET Framework Check (skip 2 lines to avoid headers)
echo [2] Checking .NET Framework...
set "NET_RELEASE="
set "NET_OK=0"

:: Skip first 2 lines (headers) and get only the Release value
for /f "skip=2 tokens=3" %%A in (
    'reg query "HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" /v Release 2^>nul'
) do (
    set "NET_RELEASE=%%A"
)

if defined NET_RELEASE (
    if !NET_RELEASE! GEQ 461808 (
        echo    .NET Framework 4.7.2 or newer: OK
        set "NET_OK=1"
    ) else (
        echo    [WARNING] .NET Framework older than 4.7.2
        set "WARNINGS=1"
    )
) else (
    echo    [WARNING] .NET Framework 4.7.2+ not found or couldn't be checked
    echo            This may affect GitHub connectivity.
    set "WARNINGS=1"
)
echo.

:: 3. GitHub Connectivity Test (quick, non-blocking)
echo [3] Testing GitHub connectivity...
powershell -NoLogo -NoProfile -Command "try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest 'https://raw.githubusercontent.com' -UseBasicParsing -TimeoutSec 5 | Out-Null; exit 0 } catch { exit 1 }"

if errorlevel 1 (
    echo    [WARNING] Cannot reach GitHub servers
    echo            Self-hash verification will be skipped.
    echo            You can still use offline INF detection.
    set "WARNINGS=1"
) else (
    echo    GitHub connection: OK
)
echo.

:: 4. Ask user to continue if warnings detected
if !WARNINGS! EQU 1 (
    echo ================================================
    echo [IMPORTANT] Some issues were detected.
    echo.
    echo If you experience problems:
    echo 1. For LTSB/LTSC users: Install .NET Framework 4.8
    echo 2. For GitHub issues: Check firewall/proxy settings
    echo.
    choice /c YN /M "Continue despite warnings? (Y/N)"
    if errorlevel 2 (
        echo Operation cancelled.
        pause
        exit /b 1
    )
    echo Continuing with limited functionality...
    timeout /t 2 /nobreak >nul
) else (
    echo ================================================
    echo All pre-checks passed. Starting updater...
    timeout /t 2 /nobreak >nul
)

:: ==========================================
:: MAIN LAUNCH
:: ==========================================
cls
echo Starting the tool...
echo.

:: Change to script directory to ensure proper file access
cd /d "!SCRIPT_DIR!"

:: Set TLS 1.2 for PowerShell and run the script
powershell -NoLogo -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; & '!SCRIPT_DIR!universal-intel-chipset-updater.ps1'"

set PS_EXIT_CODE=%errorlevel%

:: Check if new version was launched (exit code 100)
if %PS_EXIT_CODE% EQU 100 (
    echo New version launched successfully. Closing current window...
    exit /b 0
)

:: Remove the pause at the end since PS1 now handles pauses and credits
exit /b 0