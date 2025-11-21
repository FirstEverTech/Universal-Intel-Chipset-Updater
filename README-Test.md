# 🚀 Universal Intel Chipset Updater

![Version](https://img.shields.io/badge/Version-10.1--2025.11.5-red?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-0056b3?style=for-the-badge)
![Windows](https://img.shields.io/badge/Windows-10%2F11-blue?style=for-the-badge)
![PowerShell](https://img.shields.io/badge/PowerShell-5.0+-blueviolet?style=for-the-badge)

![Security Audit](https://img.shields.io/badge/Audit_Score-9.1%2F10-0a8f08?style=for-the-badge)
![Reliability](https://img.shields.io/badge/Reliability-Excellent-0a8f08?style=for-the-badge)
![Issues](https://img.shields.io/github/issues/FirstEverTech/Universal-Intel-Chipset-Updater?color=blue&style=for-the-badge)
![VirusTotal](https://img.shields.io/badge/VirusTotal-0%2F98-008631?style=for-the-badge)

## 🔧 Automate Your Intel Chipset Updates

**Universal Intel Chipset Updater** is an advanced, security-focused tool that automatically detects your Intel hardware and installs the latest official chipset **INF files** with enterprise-grade safety measures.

## 🔍 Independent Security Audits

This project has undergone comprehensive analysis by multiple AI security experts to ensure code quality and reliability. The tool achieved an **average security score of 9.1/10** across all independent assessments.

| Auditor | Score | Key Assessment |
|---------|-------|----------------|
| **Grok** | 9.7/10 | *"Highest score ever given to a community driver utility"* |
| **ChatGPT** | 9.4/10 | *"Safest, most stable, and most professionally engineered version"* |
| **Gemini** | 9.0/10 | *"Exceeds standards expected of community-developed tools"* |
| **Copilot** | 8.6/10 | *"Strong project with excellent transparency"* |
| **DeepSeek** | 8.5/10 | *"Automated tool with verification mechanisms"* |
| **Claude** | 8.3/10 | *"Best open-source tool in its category"* |

*For detailed audit reports and methodology, see [SECURITY-AUDITS.md](SECURITY-AUDITS.md).*

## 🖼️ Application Overview

| Detection Phase | Update Process | Security Verification |
|:---------------:|:--------------:|:-------------------:|
| ![Hardware Detection](Assets/Screenshot_Detection.png) | ![Update Process](Assets/Screenshot_Update.png) | ![Security Check](Assets/Screenshot_Security.png) |
| *Automatic hardware scanning* | *Update confirmation dialog* | *Hash verification in action* |

## ✨ Key Features

### 🔍 **Smart Hardware Detection**
- Automatically scans for Intel chipset components
- Identifies specific Hardware IDs (HWIDs)
- Supports chipsets from Sandy Bridge to latest generations
- Detects both Consumer and Server platforms

### 🛡 **Multi-Layer Security**
- **SHA-256 Hash Verification** for all downloads
- **Digital Signature Validation** (Intel Corporation certificates)
- **Automated System Restore Points** before installation
- **Dual-Source Download** with backup fallback
- **Administrator Privilege Enforcement**

### ⚡ **Seamless Operation**
- No installation required - fully portable
- Automatic version checking and updates
- Clean, intuitive user interface
- Detailed logging and debug mode
- Save to Downloads folder option

### 🔄 **Comprehensive Coverage**
- Mainstream Desktop/Mobile platforms
- Workstation/Enthusiast systems
- Xeon/Server platforms
- Atom/Low-Power devices

## 📋 System Requirements

| Requirement | Specification |
|-------------|---------------|
| **OS** | Windows 10/11 (x64) |
| **PowerShell** | Version 5.0 or newer |
| **Privileges** | Administrator rights |
| **Storage** | ~500MB temporary space |
| **Internet** | Required for database updates |

## 🚦 Quick Start

### Method 1: One-Click Execution
```batch
# Download and run as Administrator
Universal-Intel-Chipset-Updater.bat
```

### Method 2: PowerShell Direct
```powershell
# Run PowerShell as Administrator, then:
.\Universal-Intel-Chipset-Updater.ps1
```

### Method 3: Hardware ID Scanner Only
```batch
# For diagnostic purposes
Get-Intel-HWIDs.bat
```

## 🔧 How It Works

### 1. Hardware Detection
- Scans PCI devices for Intel Vendor ID (8086)
- Identifies chipset-related components
- Extracts Hardware IDs and current driver versions

### 2. Database Query
- Downloads latest INF database from GitHub
- Matches detected HWIDs with compatible packages
- Compares current vs latest versions

### 3. Security Verification
- Creates system restore point
- Downloads from primary/backup sources
- Verifies SHA-256 hashes
- Validates Intel digital signatures

### 4. Installation
- Executes official Intel setup with safe parameters
- Handles both ZIP and EXE package formats
- Provides real-time progress feedback

## 🛡 Security First Approach

### 🔒 Verified Security Layers
```text
1. File Integrity → SHA-256 Hash Verification
2. Authenticity → Intel Digital Signatures
3. System Safety → Automated Restore Points
4. Source Reliability → Dual Download Sources
5. Privilege Control → Admin Rights Enforcement
```

### 📊 Independent Audit Results

This project has been thoroughly audited by 6 independent AI security experts, achieving an average score of 9.1/10. Multiple auditors confirmed it's the safest and most stable version ever released, suitable for daily use, corporate deployment, and technician toolkits.

[View Full Audit Report](SECURITY-AUDITS.md) • [Security Policy](SECURITY.md)

For current limitations and workarounds, please see: [KNOWN_ISSUES.md](KNOWN_ISSUES.md)

## 📁 Project Structure

**Key Files:**

`Executables/`
- [Universal-Intel-Chipset-Updater.bat](Universal-Intel-Chipset-Updater.bat) - Main batch script
- [Universal-Intel-Chipset-Updater.ps1](Universal-Intel-Chipset-Updater.ps1) - Main PowerShell script  
- [Get-Intel-HWIDs.bat](Get-Intel-HWIDs.bat) - Hardware ID scanner batch script
- [Get-Intel-HWIDs.ps1](Get-Intel-HWIDs.ps1) - Hardware ID scanner PowerShell script

`Security/`
- [SECURITY.md](SECURITY.md) - Security policy
- [SECURITY-AUDITS.md](SECURITY-AUDITS.md) - Comprehensive security audits summary
- [docs/audit-reports/](Docs/Audit-Reports/) - Detailed audit reports

`Documentation/`
- [Intel_Chipset_INFs_Latest.md](Intel_Chipset_INFs_Latest.md) - Latest INF database
- [Intel_Chipset_INFs_Download.txt](Intel_Chipset_INFs_Download.txt) - Download links
- [KNOWN_ISSUES.md](KNOWN_ISSUES.md) - Known issues and workarounds
- [Behind-the-Project_EN.md](docs/Behind-the-Project_EN.md) - Project background (English)
- [Behind-the-Project_PL.md](docs/Behind-the-Project_PL.md) - Project background (Polish)

`Assets/`
- [Screenshots/](Assets/) - Tool screenshots

`Legal/`
- [LICENSE](LICENSE) - MIT License

## ❓ Frequently Asked Questions

### 🤔 Is this tool safe to use?
Yes! This tool has undergone comprehensive independent security audits by 6 different AI experts with an average score of 9.1/10. Multiple auditors confirmed it's the safest and most stable version ever released, suitable for daily use, corporate deployment, and technician toolkits.

Security measures include:

- Hash verification of all downloads
- Automatic system restore points before installation
- Official Intel drivers only from trusted sources
- Comprehensive pre-installation checks

Version 10.1-2025.11.5 is strongly recommended by security auditors for optimal safety and performance.

### 🔄 Will this update all my Intel drivers?
This tool specifically updates chipset INF files. It does not update GPU, network, or other device drivers.

### ⚠️ What are the risks?
As with any system modification, there's a small risk of temporary system instability. The automated restore point minimizes this risk significantly.

### 💾 Where are files downloaded?
Files are temporarily stored in `C:\Windows\Temp\IntelChipset\` and automatically cleaned up after installation.

### 🔧 What if something goes wrong?
The tool creates a system restore point before making changes. You can also check detailed logs in the temp directory.

## 🐛 Known Issues

For current limitations and workarounds, please see: [KNOWN_ISSUES.md](KNOWN_ISSUES.md)

## 🤝 Contributing

We welcome contributions! Please feel free to submit pull requests, report bugs, or suggest new features.

**Areas for Contribution:**
- Additional hardware platform support
- Translation improvements
- Documentation enhancements
- Testing on various Windows versions

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Intel Corporation for providing official driver packages
- Security researchers for independent audits
- Open source community for continuous improvement
- Beta testers for real-world validation

## 🔗 Important Links

- [Releases](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases) - Download latest version
- [Security Audits](SECURITY-AUDITS.md) - Full audit history  
- [Behind the Project](Docs/Behind-the-Project_EN.md) - Project background
- [Issue Tracker](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/issues) - Report problems

---
## 🧑‍💻 Author/Maintainer

**Marcin Grygiel** aka FirstEver
- 🌐 **Website**: [www.firstever.tech](https://www.firstever.tech)
- 💼 **LinkedIn**: [Marcin Grygiel](https://www.linkedin.com/in/marcin-grygiel/)
- 🔧 **GitHub**: [FirstEverTech](https://github.com/FirstEverTech)
- 💖 **Support**: [PayPal](https://www.paypal.com/donate/?hosted_button_id=48VGDSCNJAPTJ) | [Buy Me a Coffee](https://buymeacoffee.com/firstevertech)

Your support helps maintain and improve this project for everyone!  
If this project helped you, please consider giving it a star! ⭐

---

**Note**: This tool is provided as-is for educational and convenience purposes. While we strive for accuracy, always verify critical INF updates through official channels. The complete HWID database is available for transparency and community contributions.
