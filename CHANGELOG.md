# Changelog

All notable changes to **Universal Intel Chipset Device Updater** will be documented in this file.

The format is loosely based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

---

## [v2026.03.0012] - 11-03-2026

### Improvements
- Improved internal version handling and update detection logic
- Minor refinements in console output formatting
- General stability improvements

### Technical
- Internal script cleanup
- Minor workflow optimizations


---

## [v2026.03.0011] - 11-03-2026

### Improvements
- Improved platform detection reliability
- Refined progress and status messages

### Technical
- Code refactoring for maintainability
- Minor performance improvements in detection routines


---

## [v2026.03.0010] - 10-03-2026

### Improvements
- Improved INF database processing reliability
- Better handling of edge cases during chipset platform detection

### Technical
- Script logic refinements for chipset platform mapping
- Minor logging improvements


---

## [v2026.02.0009] - 17-02-2026

### Highlights
- **Database Scanner Fix – 300 Series (Cannon Lake PCH)**
- Fixed missing Cannon Lake-H / Cannon Lake-LP chipsets in generated INF database

### Improvements
- Improved console output alignment
- Refined chipset platform status messages

### Technical
- Intel Platform Scanner improvements
- Added missing platforms for **Xeon E5 v1 – Jaketown**
- Corrected key casing in internal platform definitions

### Notes
- No changes to Intel INF packages
- Update focuses on database generation and detection logic


---

## [v2026.02.0008] - 10-02-2026

### Improvements
- Improved chipset detection reliability
- Minor refinements in update workflow

### Technical
- Script cleanup and internal optimizations


---

## [v10.1-2026.02.2] - 05-02-2026

### Improvements
- Improved chipset detection stability
- Minor logging improvements

### Technical
- Internal script optimizations


---

## [v10.1-2026.02.1] - 01-02-2026

### Improvements
- Improved hardware detection reliability
- Minor stability improvements

### Technical
- Detection logic refinements


---

## [v10.1-2025.11.8] - 27-11-2025

### New Features
- Enhanced platform detection including support for **Windows 11 24H2 inbox drivers**
- Automatic detection for platforms using Windows inbox chipset drivers

### Improvements
- Clear informational messages for inbox drivers
- Smart exclusion of platforms with `Package = None`
- Improved driver date handling using `.cat` signature timestamps

### Technical
- Updated parsing logic for platform detection
- Enhanced debug logging
- Improved console output structure

### Bug Fixes
- Fixed potential false positives for unsupported platforms
- Improved handling of platforms without separate chipset packages


---

## [v10.1-2025.11.7] - 25-11-2025

### Improvements
- Improved chipset detection workflow
- Minor stability improvements


---

## [v10.1-2025.11.6] - 24-11-2025

### Improvements
- Stability improvements to chipset detection workflow
- Improved INF package verification logic

### Technical
- Minor code refactoring


---

## [v10.1-2025.11.5] - 21-11-2025

### Improvements
- Improved INF package download reliability
- Enhanced update detection logic

### Technical
- Script optimizations
- Improved logging consistency


---

## [v10.1-2025.11.0] - 14-11-2025

### Initial Public Release
- First public version of **Universal Intel Chipset Device Updater**
- Automatic Intel chipset hardware detection
- Secure download and installation of latest Intel chipset INF packages
- Multi-layer security verification
- Automatic system restore point creation
- SHA256 hash verification
- Intel digital signature validation

### Features
- Support for Intel consumer and server platforms
- Portable architecture (no installation required)
- Automatic update detection
- Detailed logging and debug mode


---

# Release Links

[v2026.03.0012]: https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/tag/v2026.03.0012  
[v2026.03.0011]: https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/tag/v2026.03.0011  
[v2026.03.0010]: https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/tag/v2026.03.0010  
[v2026.02.0009]: https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/tag/v2026.02.0009  
[v2026.02.0008]: https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/tag/v2026.02.0008  

[v10.1-2026.02.2]: https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/tag/v10.1-2026.02.2  
[v10.1-2026.02.1]: https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/tag/v10.1-2026.02.1  

[v10.1-2025.11.8]: https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/tag/v10.1-2025.11.8  
[v10.1-2025.11.7]: https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/tag/v10.1-2025.11.7  
[v10.1-2025.11.6]: https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/tag/v10.1-2025.11.6  
[v10.1-2025.11.5]: https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/tag/v10.1-2025.11.5  
[v10.1-2025.11.0]: https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/tag/v10.1-2025.11.0
