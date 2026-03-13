# Changelog

All notable changes to **Universal Intel Chipset Device Updater** will be documented in this file.

The format is loosely based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

---

## [v2026.03.0012] - 2026-03

### Improvements
- Improved internal version handling and update detection logic
- Minor refinements in console output formatting
- General stability improvements

### Technical
- Internal script cleanup and code consistency improvements
- Minor optimizations in update workflow


---

## [v2026.03.0011] - 2026-03

### Improvements
- Improved platform detection reliability
- Refined execution status and progress messages

### Technical
- Code refactoring for improved maintainability
- Minor performance improvements in hardware detection routines


---

## [v2026.03.0010] - 2026-03

### Improvements
- Improved INF database processing reliability
- Better handling of edge cases during chipset platform detection

### Technical
- Script logic refinements for chipset platform mapping
- Minor logging improvements


---

## [v2026.02.0009] - 2026-02-17

### Highlights
- **Database Scanner Fix – 300 Series (Cannon Lake PCH)**  
  Fixed missing 300 Series Cannon Lake-H / Cannon Lake-LP chipsets in generated INF database.

### Improvements
- Improved console output alignment and readability
- Refined chipset platform status messages

### Technical Updates
- Intel Platform Scanner improvements
- Added missing platforms to **Xeon E5 v1 – Jaketown**
- Corrected key casing in internal platform definitions

### Notes
- No changes to the Intel INF packages themselves
- Update focuses on database generation and chipset detection logic


---

## [v10.1-2025.11.8] - 2025-11-27

### New Features
- Enhanced platform detection including support for **Windows 11 24H2 inbox drivers**
- Automatic detection for platforms where Intel chipset drivers are handled by Windows

### Improvements
- Clear informational messages when inbox chipset drivers are detected
- Smart exclusion of platforms with `Package = None` in the INF database
- Improved driver date handling based on `.cat` signature timestamps

### Technical Updates
- Improved detection logic for inbox-only platforms
- Enhanced debug logging for chipset platform identification
- Output formatting improvements


---

## [v10.1-2025.11.6] - 2025-11

### Improvements
- Stability improvements to chipset detection workflow
- Improved INF package verification logic

### Technical
- Minor code refactoring and reliability improvements


---

## [v10.1-2025.11.5] - 2025-11

### Improvements
- Improved INF package download reliability
- Enhanced update detection logic

### Technical
- Minor script optimizations
- Improved logging consistency


---

## Release Links

[v2026.03.0012]: https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/tag/v2026.03.0012  
[v2026.03.0011]: https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/tag/v2026.03.0011  
[v2026.03.0010]: https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/tag/v2026.03.0010  
[v2026.02.0009]: https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/tag/v2026.02.0009  
[v10.1-2025.11.8]: https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/tag/v10.1-2025.11.8  
[v10.1-2025.11.6]: https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/tag/v10.1-2025.11.6  
[v10.1-2025.11.5]: https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/tag/v10.1-2025.11.5
