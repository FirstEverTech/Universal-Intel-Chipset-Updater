# Changelog

All notable changes to the Universal Intel Chipset Updater project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [10.1-2025.11.5] - 2025-11-21

### Added
- **System Restore Point Creation**: Automatic Windows System Restore point creation before INF installation for enhanced safety
- **Advanced Cache Busting**: GUID-based cache prevention mechanism for GitHub RAW files to ensure fresh database downloads
- **Dual Extraction Methods**: Fallback COM-based extraction when System.IO.Compression fails for ZIP files
- **Enhanced Debug Mode**: More detailed troubleshooting information with comprehensive logging
- **Better Progress Indicators**: Improved status messages during download and verification phases
- **SFX Executable Option**: Self-extracting executable (`ChipsetUpdater-10.1-2025.11.5-Win10-Win11.exe`) for simplified deployment

### Changed
- **Hash Verification Messages**: Streamlined single-line error formatting with "Source/Actual" comparison (removed duplication)
- **Digital Signature Verification**: Enhanced Intel certificate validation with explicit SHA256 algorithm checking
- **Network Resilience**: Improved handling of intermittent connectivity issues with better retry logic
- **Error Messages**: Clearer, more actionable error messages throughout the entire update process

### Fixed
- **GitHub RAW Cache Issues**: Complete cache refresh implementation preventing stale database files
- **Duplicate Error Messages**: Resolved duplicate hash verification error displays
- **Temporary File Naming**: Corrected temporary file path display in error messages
- **Backup Source Handling**: Proper URL prefix fallback when primary download source fails

### Security
- **Multi-layer Verification**: Combined SHA-256 hash checks, digital signature validation, and certificate chain verification
- **Intel Corporation Signature**: Explicit validation of Intel Corporation signatures with SHA256 algorithm
- **Administrator Privilege Enforcement**: Mandatory elevation to prevent unauthorized system modifications
- **Secure Temporary File Handling**: Automatic cleanup of sensitive temporary files post-installation

---

## [10.1-2025.11.0] - 2025-11-16 - Initial Release

### Added
- **Automatic Hardware Detection**: System-wide scanning for Intel chipset components using PCI Vendor ID (8086)
- **Universal Platform Support**: Comprehensive coverage from Sandy Bridge to latest Intel generations
  - Mainstream Desktop/Mobile platforms
  - Workstation/Enthusiast systems (Core-X, HEDT)
  - Xeon/Server platforms
  - Atom/Low-Power devices
- **Extensive Driver Database**: Built from 90 official Intel `SetupChipset.exe` installers
  - Historical coverage: v10.0.13.0 (February 26, 2015) to v10.1.20314.8688 (August 14, 2025)
  - 86,783 driver version comparisons across all HW_IDs
  - Complete chipset family support
- **Direct Intel Sources**: Official driver downloads from Intel's download servers
- **Smart Version Management**: Automatic comparison between current and latest available drivers
- **Safe Installation Parameters**: Intel-approved installation flags with proper error handling
- **Dual-Script Architecture**: 
  - Batch file (`Universal-Intel-Chipset-Updater.bat`) for UAC elevation
  - PowerShell script (`Universal-Intel-Chipset-Updater.ps1`) for core functionality
- **Hardware ID Scanner**: Separate utility (`Get-Intel-HWIDs.bat/ps1`) for diagnostic purposes
- **Clean Temporary File Management**: Organized download and extraction in `C:\Windows\Temp\IntelChipset\`
- **Comprehensive Documentation**:
  - Detailed README with usage instructions
  - Security policy (SECURITY.md)
  - Known issues documentation (KNOWN_ISSUES.md)
  - Project background in English and Polish
- **Multi-language Support**: Documentation available in English and Polish

### Security
- **SHA-256 Hash Verification**: Every downloaded file validated against known-good hashes
- **Digital Signature Validation**: Verification of Intel Corporation digital signatures
- **Administrator Rights Required**: Mandatory elevation for system-level operations
- **Dual-Source Download**: Primary and backup download sources for reliability
- **Secure File Handling**: Temporary files stored in secure Windows system directories

---

## Release Notes Format

### Version Naming Convention
- **Major.Minor-YYYY.MM.Revision** format (e.g., `10.1-2025.11.5`)
- Major version tracks Intel chipset INF version lineage (10.1.x)
- Date component reflects release year and month
- Revision number increments with each update

### Categories Used
- **Added**: New features and capabilities
- **Changed**: Modifications to existing functionality
- **Fixed**: Bug fixes and issue resolutions
- **Security**: Security-related improvements and fixes
- **Deprecated**: Features marked for future removal (if applicable)
- **Removed**: Features removed in this version (if applicable)

---

## Links

- [Latest Release](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/latest)
- [All Releases](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases)
- [Issue Tracker](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/issues)
- [Security Policy](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/SECURITY.md)

---

## Support

If you encounter any issues or have questions about a specific release:
1. Check [Known Issues](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/KNOWN_ISSUES.md)
2. Search [existing issues](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/issues)
3. Create a [new issue](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/issues/new) with detailed information

---

**Note**: This project is independent and not affiliated with Intel Corporation. All driver packages are official Intel releases downloaded from Intel's servers.
