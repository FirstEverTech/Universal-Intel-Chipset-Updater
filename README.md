# Universal Intel Chipset Updater 🚀

[![GitHub release](https://img.shields.io/github/v/release/FirstEverTech/Universal-Intel-Chipset-Updater)](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases)
[![GitHub license](https://img.shields.io/github/license/FirstEverTech/Universal-Intel-Chipset-Updater)](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/FirstEverTech/Universal-Intel-Chipset-Updater)](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/issues)
[![Windows](https://img.shields.io/badge/Windows-10%2B-blue)](https://www.microsoft.com/windows)

Automated tool to detect and update Intel chipset drivers to the latest versions. Supports all Intel platforms from Sandy Bridge (2nd Gen) to the latest Panther Lake (15th Gen).

## ✨ Features

- 🔍 **Automatic Hardware Detection** - Identifies your Intel chipset and finds matching drivers
- 📦 **Latest Drivers** - Always downloads the most recent official Intel chipset drivers
- 🛡️ **Safe Installation** - Uses official Intel installers with proper parameters
- 🔄 **Smart Updates** - Offers driver updates when newer versions are available and allows reinstallation of current version
- 💻 **Broad Compatibility** - Supports desktop, mobile, workstation, server, and embedded platforms
- ⚡ **Easy to Use** - Simple batch file execution with automatic administrator elevation
- 📊 **Comprehensive Database** - Based on analysis of 88 official Intel installer versions with 82,663 driver version comparisons

## 📋 Supported Platforms

| 🖥️ Mainstream Desktop | ⚡ Workstation/Enthusiast | 🔋 Atom/Embedded & Low-Power |
| :--- | :--- | :--- |
| **15th Gen**: Panther Lake<br>**14th Gen**: Arrow Lake, Raptor Lake Refresh<br>**13th Gen**: Raptor Lake<br>**12th Gen**: Alder Lake<br>**11th Gen**: Rocket Lake<br>**10th Gen**: Comet Lake, Cannon Lake<br>**9th/8th Gen**: Coffee Lake<br>**7th Gen**: Kaby Lake<br>**6th Gen**: Skylake<br>**5th Gen**: Broadwell<br>**4th Gen**: Haswell<br>**3rd Gen**: Ivy Bridge<br>**2nd Gen**: Sandy Bridge | **Xeon W-2400/W-3400**: Sapphire Rapids<br>**Xeon W-3300**: Ice Lake-X<br>**X299**: Cascade Lake-X, Skylake-X<br>**X99**: Broadwell-E, Haswell-E<br>**X79**: Ivy Bridge-E, Sandy Bridge-E | **Core Ultra 200V**: Lunar Lake<br>**N-series**: Alder Lake-N<br>**Atom**: Jasper Lake, Elkhart Lake, Gemini Lake, Apollo Lake<br>**Atom Server**: Denverton, Avoton<br>**Legacy Atom**: Bay Trail, Braswell, Valleyview |
| 💻 **Mainstream Mobile** | 🗄️ **Server Platforms** | 🕰️ **Legacy Chipsets** |
| **Core Ultra 200V**: Lunar Lake<br>**14th Gen**: Meteor Lake<br>**11th Gen**: Tiger Lake<br>**10th Gen**: Ice Lake, Comet Lake<br>**8th/9th Gen**: Coffee Lake<br>**7th Gen**: Kaby Lake<br>**6th Gen**: Skylake<br>**5th Gen**: Broadwell<br>**4th Gen**: Haswell, Crystal Well<br>**3rd Gen**: Ivy Bridge<br>**2nd Gen**: Sandy Bridge | **6th Gen Xeon**: Granite Rapids, Clearwater Forest<br>**5th Gen Xeon**: Emerald Rapids<br>**4th Gen Xeon**: Sapphire Rapids<br>**3rd Gen Xeon**: Ice Lake-SP<br>**2nd Gen Xeon**: Cascade Lake<br>**1st Gen Xeon**: Skylake-SP<br>**Older Xeon**: Broadwell-EP, Haswell-EP, Ivy Town, Sandy Bridge-EP | **100 Series**: Sunrise Point<br>**9 Series**: Wildcat Point<br>**8 Series**: Lynx Point<br>**7 Series**: Panther Point<br>**6 Series**: Cougar Point |

## 🛠️ Usage

### Option 1: SFX EXE (Recommended)
1. Download the self-extracting executable:  
   `ChipsetUpdater-10.1-2025.11-Driver64-Win10-Win11.exe` from the repository
2. Run the EXE as Administrator
3. Follow the on-screen prompts to scan and update your drivers

### Option 2: Simple Batch File
1. Download both `Universal-Intel-Chipset-Updater.bat` and `Universal-Intel-Chipset-Updater.ps1`
2. Place both files in the same directory
3. Run `Universal-Intel-Chipset-Updater.bat` as Administrator
4. Follow the on-screen prompts to scan and update your drivers

### Option 3: Direct PowerShell
1. Download `Universal-Intel-Chipset-Updater.ps1`
2. Open PowerShell as Administrator
3. Run: `powershell -ExecutionPolicy Bypass -File "Universal-Intel-Chipset-Updater.ps1"`

## 🗃️ Driver Database

This tool uses an extensive database built from analyzing **88 official Intel SetupChipset.exe installers**, spanning:

- **Historical Coverage**: From version 10.0.13.0 (February 26, 2015) to 10.1.20314.8688 (August 14, 2025)
- **Complete Hardware Support**: **82,663 driver version comparisons** across all HW_IDs used in Intel chipset drivers
- **Multi-Platform**: Supports Consumer, Server, Workstation, and Mobile platforms

## ⚠️ Important Notes

- **Administrator Rights Required**: The script must be run as Administrator for proper functionality
- **Restart Required**: A system restart is often necessary after driver installation
- **Temporary Black Screen**: During PCIe bus driver updates, the screen may temporarily go black
- **Device Reconnection**: Some devices may temporarily disconnect during installation
- **Internet Connection Required**: Needed to download the latest driver information and packages

## 🔧 Troubleshooting

### Common Issues

1. **"Script cannot run"** - Ensure you're running as Administrator and both files are in the same directory
2. **"No Intel chipset found"** - Verify your system uses an Intel chipset (Sandy Bridge or newer)
3. **Installation failures** - Check internet connection and temporary directory permissions

### Debug Mode

For detailed logging and troubleshooting, you can:
1. Examine the script output for specific error messages
2. Check Windows Device Manager for any devices with warning icons
3. Verify the temporary directory `C:\Windows\Temp\IntelChipset` is accessible

## 🤝 Contributing

We welcome contributions! If you have:

- New driver versions or platform information
- Improvements to the detection logic
- Bug fixes or feature enhancements

Please feel free to submit a Pull Request or open an Issue.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

This tool is not affiliated with Intel Corporation. Drivers are sourced from official Intel servers. Use at your own risk. Always backup your system before updating drivers.

## 📞 Support

- **Repository**: [https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater)
- **Issues**: [GitHub Issues](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/issues)
## 🧑‍💻 Author/Maintainer

**Marcin Grygiel**
- 🌐 **Website**: [www.firstever.tech](https://www.firstever.tech)
- 💼 **LinkedIn**: [Marcin Grygiel](https://www.linkedin.com/in/marcin-grygiel/)
- 🔧 **GitHub**: [FirstEverTech](https://github.com/FirstEverTech)
- 💖 **Support**: [PayPal](https://paypal.me/YourPayPalLink) | [Buy Me a Coffee](https://buymeacoffee.com/firstevertech)

Your support helps maintain and improve this project for everyone!

---

**Note**: This tool is provided as-is for educational and convenience purposes. While we strive for accuracy, always verify critical driver updates through official channels.
