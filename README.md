# Universal Intel Chipset Updater 🚀

[![GitHub release](https://img.shields.io/github/v/release/FirstEver-eu/Intel-Chipset-Driver-Updater)](https://github.com/FirstEver-eu/Intel-Chipset-Driver-Updater/releases)
[![GitHub license](https://img.shields.io/github/license/FirstEver-eu/Intel-Chipset-Driver-Updater)](https://github.com/FirstEver-eu/Intel-Chipset-Driver-Updater/blob/main/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/FirstEver-eu/Intel-Chipset-Driver-Updater)](https://github.com/FirstEver-eu/Intel-Chipset-Driver-Updater/issues)
[![Windows](https://img.shields.io/badge/Windows-10%2B-blue)](https://www.microsoft.com/windows)

Automated tool to detect and update Intel chipset drivers to the latest versions. Supports all Intel platforms from Sandy Bridge (2nd Gen) to the latest Panther Lake (15th Gen).

## ✨ Features

- 🔍 **Automatic Hardware Detection** - Identifies your Intel chipset and finds matching drivers
- 📦 **Latest Drivers** - Always downloads the most recent official Intel chipset drivers
- 🛡️ **Safe Installation** - Uses official Intel installers with proper parameters
- 🔄 **Smart Updates** - Offers driver updates when newer versions are available and allows reinstallation of current version
- 💻 **Broad Compatibility** - Supports desktop, mobile, workstation, server, and embedded platforms
- ⚡ **Easy to Use** - Simple batch file execution with automatic administrator elevation

## 📋 Supported Platforms

| 🖥️ Mainstream Desktop | ⚡ Workstation/Enthusiast | 🔋 Atom/Embedded & Low-Power |
| :--- | :--- | :--- |
| **15th Gen**: Panther Lake<br>**14th Gen**: Arrow Lake, Raptor Lake Refresh<br>**13th Gen**: Raptor Lake<br>**12th Gen**: Alder Lake<br>**11th Gen**: Rocket Lake<br>**10th Gen**: Comet Lake, Cannon Lake<br>**9th/8th Gen**: Coffee Lake<br>**7th Gen**: Kaby Lake<br>**6th Gen**: Skylake<br>**5th Gen**: Broadwell<br>**4th Gen**: Haswell<br>**3rd Gen**: Ivy Bridge<br>**2nd Gen**: Sandy Bridge | **Xeon W-2400/W-3400**: Sapphire Rapids<br>**Xeon W-3300**: Ice Lake-X<br>**X299**: Cascade Lake-X, Skylake-X<br>**X99**: Broadwell-E, Haswell-E<br>**X79**: Ivy Bridge-E, Sandy Bridge-E | **Core Ultra 200V**: Lunar Lake<br>**N-series**: Alder Lake-N<br>**Atom**: Jasper Lake, Elkhart Lake, Gemini Lake, Apollo Lake<br>**Atom Server**: Denverton, Avoton<br>**Legacy Atom**: Bay Trail, Braswell, Valleyview |
| 💻 **Mainstream Mobile** | 🗄️ **Server Platforms** | 🕰️ **Legacy Chipsets** |
| **Core Ultra 200V**: Lunar Lake<br>**14th Gen**: Meteor Lake<br>**11th Gen**: Tiger Lake<br>**10th Gen**: Ice Lake, Comet Lake<br>**8th/9th Gen**: Coffee Lake<br>**7th Gen**: Kaby Lake<br>**6th Gen**: Skylake<br>**5th Gen**: Broadwell<br>**4th Gen**: Haswell, Crystal Well<br>**3rd Gen**: Ivy Bridge<br>**2nd Gen**: Sandy Bridge | **6th Gen Xeon**: Granite Rapids, Clearwater Forest<br>**5th Gen Xeon**: Emerald Rapids<br>**4th Gen Xeon**: Sapphire Rapids<br>**3rd Gen Xeon**: Ice Lake-SP<br>**2nd Gen Xeon**: Cascade Lake<br>**1st Gen Xeon**: Skylake-SP<br>**Older Xeon**: Broadwell-EP, Haswell-EP, Ivy Town, Sandy Bridge-EP | **100 Series**: Sunrise Point<br>**9 Series**: Wildcat Point<br>**8 Series**: Lynx Point<br>**7 Series**: Panther Point<br>**6 Series**: Cougar Point |

## 🚀 Quick Start

### Method 1: Automated Batch File (Recommended)
1. Download the latest release from the [Releases page](https://github.com/FirstEver-eu/Intel-Chipset-Driver-Updater/releases)
2. Extract the ZIP file to your desired location
3. Run `Update-Intel-Chipset.bat` as Administrator
4. Follow the on-screen instructions

### Method 2: Manual PowerShell
```powershell
# Run PowerShell as Administrator, then:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\Update-Intel-Chipset.ps1

