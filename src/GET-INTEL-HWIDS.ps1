# Script to dump all Intel device identifiers
# Requires administrator privileges

# Check if running as administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script requires administrator privileges. Please run PowerShell as Administrator." -ForegroundColor Red
    exit
}

# Get script directory for output file
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$outputFile = Join-Path $scriptDir "Intel_HWIDs_Report.txt"

Write-Host "Collecting Intel device information..." -ForegroundColor Green

# All Intel devices (VEN_8086)
$intelDevices = Get-PnpDevice | Where-Object { $_.InstanceId -like "*VEN_8086*" }

# Save to file
"=== INTEL DEVICES REPORT ===" | Out-File -FilePath $outputFile -Encoding UTF8
"Created: $(Get-Date)" | Out-File -FilePath $outputFile -Encoding UTF8 -Append
" " | Out-File -FilePath $outputFile -Encoding UTF8 -Append

"INTEL DEVICES (VEN_8086):" | Out-File -FilePath $outputFile -Encoding UTF8 -Append
"=========================" | Out-File -FilePath $outputFile -Encoding UTF8 -Append

foreach ($device in $intelDevices) {
    " " | Out-File -FilePath $outputFile -Encoding UTF8 -Append
    "Name: $($device.FriendlyName)" | Out-File -FilePath $outputFile -Encoding UTF8 -Append
    "Instance ID: $($device.InstanceId)" | Out-File -FilePath $outputFile -Encoding UTF8 -Append
    "Class: $($device.Class)" | Out-File -FilePath $outputFile -Encoding UTF8 -Append
    "Status: $($device.Status)" | Out-File -FilePath $outputFile -Encoding UTF8 -Append
    
    # Get driver version if possible
    try {
        $versionProperty = $device | Get-PnpDeviceProperty -KeyName "DEVPKEY_Device_DriverVersion" -ErrorAction SilentlyContinue
        if ($versionProperty -and $versionProperty.Data) {
            "Driver Version: $($versionProperty.Data)" | Out-File -FilePath $outputFile -Encoding UTF8 -Append
        }
    } catch {
        # Ignore errors
    }
    
    # Extract DEV_XXXX
    if ($device.InstanceId -match 'DEV_([0-9A-F]{4})') {
        "DEV_ID: $($matches[1])" | Out-File -FilePath $outputFile -Encoding UTF8 -Append
    }
}

# Additional: Search for chipset-related devices
" " | Out-File -FilePath $outputFile -Encoding UTF8 -Append
" " | Out-File -FilePath $outputFile -Encoding UTF8 -Append
"CHIPSET/PCI BRIDGE/ROOT PORT DEVICES:" | Out-File -FilePath $outputFile -Encoding UTF8 -Append
"=====================================" | Out-File -FilePath $outputFile -Encoding UTF8 -Append

$chipsetRelated = $intelDevices | Where-Object {
    $_.Class -eq "System" -or 
    $_.FriendlyName -like "*chipset*" -or 
    $_.FriendlyName -like "*PCI*" -or
    $_.FriendlyName -like "*Root*" -or
    $_.FriendlyName -like "*Bridge*" -or
    $_.FriendlyName -like "*Controller*"
}

foreach ($device in $chipsetRelated) {
    " " | Out-File -FilePath $outputFile -Encoding UTF8 -Append
    "Name: $($device.FriendlyName)" | Out-File -FilePath $outputFile -Encoding UTF8 -Append
    "Instance ID: $($device.InstanceId)" | Out-File -FilePath $outputFile -Encoding UTF8 -Append
    "Class: $($device.Class)" | Out-File -FilePath $outputFile -Encoding UTF8 -Append
    
    # Extract DEV_XXXX
    if ($device.InstanceId -match 'DEV_([0-9A-F]{4})') {
        "DEV_ID: $($matches[1])" | Out-File -FilePath $outputFile -Encoding UTF8 -Append
    }
}

Write-Host "Report saved to: $outputFile" -ForegroundColor Green
Write-Host "Opening file..." -ForegroundColor Yellow

# Open file in Notepad
notepad $outputFile
