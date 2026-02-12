# Changelog

All notable changes to the Universal Intel Chipset Updater project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [2026.02.0008] - 2026-02-08

### Added
- **Enhanced Windows Inbox INF Detection**: Detects newer INF versions from Windows Update to prevent downgrades
- **Improved Version Comparison**: Uses Version objects for accurate parsing and comparison
- **Clear User Guidance**: Status messages for scenarios like "Newer INF version detected (Windows Inbox)", "Already on latest version", or "Update available"

### Changed
- **Improved Status Messages**: Better formatting for multi-line messages and warnings about Windows Inbox drivers
- **Version Format**: Tool version now follows YYYY.MM.REVISION format

### Technical Improvements
- **Version Comparison Logic**: Updated parsing to handle all formats with enhanced error handling
- **Status Display Functions**: Improved platform information display in Show-Screen2

### Bug Fixes
- Fixed incorrect status display when current version exceeds latest version
- Improved message formatting and alignment
- Enhanced error handling in version comparison logic

---

## [10.1-2026.02.2] - 2026-02-02

### Added
- **Enhanced Pre-Launch System Checks**: Moved to PowerShell for reliability, including Windows build validation (min. Windows 10 LTSC 2019), .NET Framework verification (4.7.2+ required), GitHub connectivity test, and user prompts on warnings

### Changed
- **Simplified Batch Launcher**: Reduced complexity to focus on elevation and launching PowerShell, with better working directory and exit handling
- **Architecture Change**: Moved all pre-checks to PowerShell for consistent warnings, better maintenance, and improved compatibility with older Windows builds

### Fixed
- Hash verification failures on older Windows 10 LTSB/LTSC builds
- Pre-check warnings not clearly informing about TLS/.NET requirements
- Working directory issues in BAT during elevation
- Exit handling when auto-update launches new version
- User experience for systems with limited connectivity

### Technical Improvements
- **Batch Launcher Updates**: Removed duplicate pre-checks, simplified code
- **PowerShell Script Enhancements**: Comprehensive system validation in Show-Screen1, improved error handling and logging

---

## [10.1-2026.02.1] - 2026-02-01

### Added
- **Hardware-Accurate Platform Separation**: New Generate-HardwareAccurateMD.ps1 script to correct Intel's platform grouping errors, with proper separation for Meteor Lake (SoC, PCH-N, PCH-H, PCH-S), X79 (IvyTown CPU Root from Patsburg PCH), and X99 (HaswellE/BroadwellE CPU Root from Wellsburg PCH)
- **Extended Installer Support**: Full support for MSI installers alongside EXE, with MSI integrity verification via hash from GitHub Archive
- **Installer Enhancements**: Dual support for EXE/MSI detection, MSI verification, improved error handling, and fallback to Intel’s official installer
- **New Scripts**: Generate-HardwareAccurateMD.ps1 for hardware-correct database (generates intel-chipset-infs-latest-v2.md and installer-list.csv)
- **Database Improvements**: Accurate separation of hardware components for better detection and understanding

### Changed
- **Log File Location**: Moved chipset_update.log to C:\ProgramData\ to persist after cleanup
- **Pause Management**: Added keyboard buffer flush to prevent screen "skipping"
- **Version Display**: Added $DisplayVersion with regex for proper UI formatting
- **Source Code Variables**: Added $DisplayVersion and $githubArchiveUrl for archival MSI hash files
- **Updated Functions**: Rewritten Install-ChipsetINF for EXE/MSI support, fixed regex in Show-Header and Show-FinalCredits, changed log location in Write-Log

### Fixed
- MSI installation for newer Intel packages
- Log persistence during temporary directory cleanup
- Screen "skipping" due to buffered keys
- Incorrect version display in header

### Technical Improvements
- **Improved Parsing and Debugging**: Fixed regex, added debug messages for tracking
- **Backward Compatibility**: No changes needed for updater; works with existing database formats

---

## [10.1-2025.11.8] - 2025-11-27

### New Features
- **Enhanced platform detection**: Added automatic detection for Intel platforms that use Windows 11 24H2 inbox drivers (e.g., Meteor Lake)
- **Improved user communication**: Clear informational messages when Windows inbox drivers are detected
- **Smart exclusion system**: Platforms with `Package = None` in the database are automatically excluded from updates
- **Better date handling**: Windows inbox driver dates now use digital signature dates from corresponding .cat files

### Technical Improvements
- **Updated parsing logic**: Script now identifies Windows inbox-only platforms during hardware detection
- **Enhanced error handling**: Improved debug messages and logging for platform detection
- **Streamlined user experience**: Separate section for Windows inbox platforms in the output

### Bug Fixes
- Fixed potential false positives for unsupported platforms
- Improved handling of platforms without separate Intel Chipset Device Software packages

---

## [10.1-2025.11.7] - 2025-11-25

### Added
- **Final Credits Screen**: New thank you screen with project information and support message, displayed for 5 seconds before automatic closure
- **Enhanced Cleanup Function**: Consolidated temporary file cleanup with improved messaging and error handling
- **Streamlined Exit Flow**: Unified exit process with consistent pause and credits screen across all termination paths

### Changed
- **Removed Duplicate Pauses**: Eliminated redundant pause in BAT file, now handled entirely by PowerShell script
- **Improved User Experience**: Consistent flow: operation summary → pause → credits → auto-close
- **Cleanup Messaging**: Standardized temporary file cleanup messages with yellow color for visibility

### Fixed
- **Duplicate Cleanup Messages**: Resolved issue where cleanup messages appeared multiple times
- **Exit Code Handling**: Proper exit codes for success (0) and errors (1) with credits screen
- **Temporary File Cleanup**: Ensured cleanup occurs in all scenarios (success, error, cancellation)

### Security
- **Maintained Integrity Checks**: Self-hash verification and digital signature validation remain intact
- **Secure Temporary File Handling**: Continued automatic cleanup of sensitive temporary files

---

## [10.1-2025.11.6] - 2025-11-25

### Added
- **Self-Hash Verification**: Script now validates its own integrity against GitHub release hashes before execution
- **Automatic Update Detection**: Seamless update checking with download to user's Downloads folder
- **Digital Signature**: SFX EXE signed with FirstEver.tech certificate (included for verification)
- **Phased Execution Windows**: Clear separation of verification, detection, download, and installation phases
- **Enhanced Version Comparison**: Smart date-based version comparison to prevent false update prompts
- **Downloads Folder Detection**: Automatic detection of user's Downloads folder for update storage

### Changed
- **Streamlined User Interface**: Improved visual flow with distinct operational phases
- **Enhanced Error Management**: More granular error handling throughout all execution phases
- **Better Update Prompts**: Clearer update decision flow with proper version comparison
- **Reduced Wait Times**: Optimized delays between phases for better user experience

### Fixed
- **Version Comparison Logic**: Fixed bug where outdated version files would offer "updates" to older versions
- **Hash Verification Flow**: Improved self-hash verification with better error reporting
- **Update Detection**: Proper handling of version file mismatches and network issues
- **Temporary File Cleanup**: Enhanced cleanup routines across all execution paths

### Security
- **Multi-Layer Integrity Verification**: Self-hash validation + digital signature + certificate chain
- **Automatic System Restore**: Enhanced restore point creation before system modifications
- **Secure Update Process**: Verified downloads with hash validation for new versions
- **Improved Certificate Validation**: Enhanced digital signature verification throughout

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
- **Extensive INF Database**: Built from 90 official Intel `SetupChipset.exe` installers
  - Historical coverage: v10.0.13.0 (February 26, 2015) to v10.1.20314.8688 (August 14, 2025)
  - 86,783 INF version comparisons across all HW_IDs
  - Complete chipset family support
- **Direct Intel Sources**: Official INF downloads from Intel's download servers
- **Smart Version Management**: Automatic comparison between current and latest available INFs
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
- **Major.Minor-YYYY.MM.Revision** format (e.g., `10.1-2025.11.6`)
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
2. Search [Existing Issues](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/issues)
3. Create a [New Issue](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/issues/new) with detailed information

---

**Note**: This project is independent and not affiliated with Intel Corporation. All INF packages are official Intel releases downloaded from Intel's servers.
```
