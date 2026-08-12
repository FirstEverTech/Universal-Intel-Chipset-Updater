# Changelog

All notable changes to **Universal Intel Chipset Device Updater** will be documented in this file.

The format is loosely based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

---

## [v2026.08.0018] - 2026-08-10

### 🛡️ Safety Improvement
- **Added: warning and safeguards for Intel SST/cAVS audio INF conflicts** — Some chipset packages (particularly EOL/mobile PCH packages) include `*SystemcAVS.inf` files for Intel Smart Sound Technology (SST) device identification. On systems where the motherboard/laptop vendor uses a non-Intel audio codec (Realtek, Creative Sound Blaster, etc.), Windows Plug and Play can reassign the audio controller from the generic "High Definition Audio Controller" to an Intel SST device after these INFs are applied, preventing the correct audio driver from attaching and disabling sound output. Reported independently on two systems — a Gigabyte Skylake desktop (Realtek audio disabled, required System Restore) and an EVGA X299 Dark (Creative Sound Blaster Recon3Di broken by the `KabyLakePCH-H` EOL package, HWID `A2F0`). See [Issue #31](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/issues/31).
- The chipset INF package itself does **not** install audio drivers — it only provides device identification — but the resulting PnP re-enumeration is enough to break third-party audio driver binding on affected systems.

### 🔧 Technical Improvements
- **Detection**: before installation, the updater now scans the INF file list of every matched platform for `cAVS`. If found, the platform(s) are flagged and the installation flow branches into the new warning/safeguard logic below.
- **Interactive mode**: if a cAVS-containing package is detected, the updater displays an explicit warning (affected platform name(s), explanation of the risk, link to Issue #31) immediately after the user confirms they want to update, but *before* the System Restore point is created or any file is touched. Declining (`N`) cancels the run with no changes made to the system. If the user proceeds but the automatic System Restore point subsequently fails to be created or verified, a second, stronger warning is shown and requires an explicit confirmation before installation continues.
- **Unattended mode (`-auto` / `-quiet`)**: since there is no user available to acknowledge the risk, detecting a cAVS package now **aborts the run before any system changes** — no restore point is created and no INF files are installed. The process exits with code `3` (distinct from the generic error code `1` used elsewhere in the script) so scheduled tasks / deployment tooling can identify this specific "held back for a manual decision" outcome separately from a failed run.
- **Post-install reminder**: if a cAVS package was installed (interactive mode, user opted to proceed), the final summary now includes a reminder to check Device Manager → Sound, video and game controllers after reboot, and to use System Restore if the audio device is missing, disabled, or shows an error code.

### 🆕 New Feature: EOL Package Handling
- **Added: explicit choice for installing legacy (EOL) INF packages** — Some detected HWIDs are only covered by an older, End-of-Life (EOL) chipset INF package because the "latest" package for that platform no longer lists them (Intel moved or dropped the HWID — in some cases into a completely separate installer, such as the Intel Serial IO Drivers package). Previously, any matched EOL package was installed automatically alongside the main package with no way to opt out. The updater now detects this and, in interactive mode, asks the user to choose: (1) install everything, including the EOL package(s), then the rest, or (2) skip the EOL package(s) and install all other INF files. In unattended mode (`-auto` / `-quiet`), EOL packages are now skipped by default, since there is no user available to make an informed choice. Reported via [Station-Drivers forum feedback](https://www.station-drivers.com/index.php/en/forum/intel-chipsets-drivers/887-universal-intel-chipset-drivers-updater?start=80#6718).
- **Added: automatic block for EOL packages that would downgrade an already-installed newer driver** — If the currently installed INF version for a device covered by an EOL package is already *newer* than the EOL package itself (status `Inbox / newer detected`), this almost always means a separate, newer Intel package — most commonly Intel Serial IO Drivers — already owns that HWID. Installing the EOL package in that case would downgrade the driver. Such EOL packages are now excluded from installation unconditionally, in both interactive and unattended mode, with no prompt — the updater reports which platform(s) were affected and the version comparison that triggered the block.

### 🔧 Technical Improvements (EOL handling)
- **Detection**: platform+package status (`Latest version` / `Update available` / `Inbox / newer detected`) is now persisted per matched platform entry, so the new EOL-handling step can act on it instead of it being discarded right after the on-screen status line is printed.
- **Choice / skip logic**: EOL entries whose status is `Update available` go through the new 1/2 prompt (interactive) or are skipped by default (`-auto` / `-quiet`); EOL entries whose status is `Inbox / newer detected` are removed from the install set unconditionally, before the prompt is even shown.
- If, after skipping or blocking, no packages remain to install, the updater now exits cleanly with an explanatory message instead of proceeding to create a restore point for nothing.

### Notes
- No changes to non-cAVS platforms or packages — cAVS detection, warning, and abort logic only trigger when a matched package's INF list contains a `cAVS` file.
- No database format changes in this release for either the cAVS safeguard or the EOL package handling — both are install-flow logic based on data already parsed from the existing database.
- EOL package handling applies only to platforms that had at least one EOL-package match; platforms with only a main-package match are unaffected.
- Root cause of the cAVS conflict is still under investigation upstream (Intel packaging classification of the affected EOL/mobile PCH packages); this release adds a safety net in the updater, it does not fix the underlying INF conflict. Follow-up (excluding/relabeling the affected EOL packages, or targeted skip logic based on detected audio codec) is tracked in Issue #31.

---

## [v2026.08.0017] - 2026-08-01

### 🩹 Bugfix
- **Fixed: FriendlyName keyword filter silently dropped legitimate Intel devices** — `Get-IntelChipsetHWIDs` pre-filtered candidate devices by matching `$device.FriendlyName` against a fixed keyword list (`Chipset|LPC|PCI Express Root Port|PCI-to-PCI bridge|Motherboard Resources`) before they were even checked against the HWID database. Any Intel System-class device whose FriendlyName didn't contain one of those words was silently excluded from detection — regardless of whether it was a real, live, `Status -eq 'OK'` device. Reported via a Station-Drivers user whose system had three live Skylake-family System Agent devices (`1901` – PCIe Controller (x16), `1911` – Gaussian Mixture Model, `191F` – Host Bridge/DRAM Registers) that were never detected or reported, while a third-party scanner (Driver Genius Free Edition) flagged all three as outdated. Live PnP enumeration confirmed all three devices were present with `Status: OK` — the updater's own filter was excluding them, not a database or matching gap. See [Issue #26](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/issues/26).

### 🔧 Technical Improvements
- **Detection**: `Get-IntelChipsetHWIDs` no longer pre-filters candidate devices by FriendlyName keyword matching. Every `VEN_8086` System-class device with `Status -eq 'OK'` is now collected unconditionally; the authoritative filter is the existing downstream lookup against the full INF/HWID database (`$chipsetData.ContainsKey($hwId)`). This removes an entire class of false negatives — the same keyword-filter gap also affected other device categories that don't use the recognized keywords in their FriendlyName across multiple platforms/generations (e.g. `*SystemGMM.inf`, `*SystemThermal.inf`, `*SystemNorthpeak.inf`, `*SystemLPSS.inf`, `*DmaSecExtension.inf` families), not only the originally reported Skylake devices.
- Removed the now-obsolete `IsChipset` field and the "fallback to first 5 non-chipset devices" branch in `Get-IntelChipsetHWIDs`, both made unnecessary by the fix above.
- **Performance**: `Get-CurrentINFVersion` previously re-enumerated *every* PnP device on the system (`Get-PnpDevice | Where-Object {InstanceId -eq ...}`) once per detected Intel device to resolve its installed driver version — an O(n²) cost that scales with the number of detected devices. It now accepts the PnpDevice object already held from the initial enumeration via a new `-Device` parameter, looking up properties directly without a full system re-scan. The previous `-DeviceInstanceId` parameter is retained as a fallback for callers that only have an instance ID string.
- **Display**: `Found compatible platform(s):` list now wraps HWIDs at 12 per line (3-space indent) instead of a single unwrapped line — on systems with a large number of detected devices per platform (e.g. 47 HWIDs under one IvyTown platform), the old single-line format made console output unreadable. Platform name lines now use yellow instead of white for better scannability.
- Merged the separate `Downloading latest INF information...` and `Parsing INF information - it may take up to 30 seconds!` messages into a single, more accurate status line, since the time estimate always covered the whole download+parse+match block rather than parsing alone.
- Renamed `Found N Intel chipset device(s)` → `Found N Intel device(s)` and `No Intel chipset devices found.` → `No Intel devices found.`, since this count is now taken before database matching and is no longer pre-filtered down to devices that merely *look* like chipset devices by name.

### 📊 Real-World Validation
- On a triple-platform Intel X79 (IvyTown / Patsburg PCH / IvyTown CPU Root) test system, detected device count rose from 12 to 59 after this fix — confirming the FriendlyName filter gap was systemic across platforms and generations, not specific to the originally reported Skylake case.

### Notes
- **Impact scope:** on systems where all detected platforms map to the same Intel installer package, this bug did not prevent installation — `SetupChipset.exe -OVERALL` performs its own independent hardware matching regardless of what the updater detected or reported, so previously-affected devices were likely still serviced correctly by the installer even though the updater's own report incorrectly showed them as absent. The bug's practical impact was primarily incorrect/incomplete reporting; on systems where a missed platform would have required a *different* installer package than the one otherwise selected, actual installation could have been affected.
- No database format changes in this release.

---

## [v2026.07.0016] - 2026-07-12

### 🩹 Hotfix
- **Fixed: Legitimate expired-certificate installers rejected** — v2026.07.0015 introduced a certificate expiration check (`SignerCertificate.NotAfter -lt Get-Date`) in `Verify-FileSignature` that rejected older Intel installers whose signing certificate has since expired, even when the Authenticode signature itself remains valid via RFC3161 timestamping. `Get-AuthenticodeSignature`'s own `Status` field already correctly accounts for timestamped signatures, making the extra check both redundant and harmful — it broke installation of older, still-authentic chipset installers that worked fine in v2026.05.0014.

### 🔧 Technical Improvements
- Removed manual `SignerCertificate.NotAfter -lt Get-Date` expiration check from `Verify-FileSignature`
- Signature authenticity now validated solely via signer identity match (3 recognized Intel certificate patterns + FirstEver.tech exception), timestamp-aware `Get-AuthenticodeSignature` status, and algorithm check (SHA256 preferred, SHA1 accepted — warning only)
- No other changes — EOL device handling, multi-signer support, credits/ads screen, and parser improvements from v2026.07.0015 are unchanged

### Notes
- Recommended for everyone on v2026.07.0015 who saw `FAIL: Digital signature verification - Certificate expired.` for installers that previously worked in v2026.05.0014
- No database changes in this release

---

## [v2026.07.0015] - 2026-07-01

### 🆕 Highlights
- **EOL Device Support** — Enhanced database parser now correctly detects End-of-Life (EOL) platforms from the new `#### Platform EOL` section headers. EOL packages are installed first (oldest versions), followed by the latest packages, preventing newer INF files from being overwritten by older ones. Legacy HWIDs that were removed from the latest packages are now properly handled.

- **Multi-Signature Verification** — Updated digital signature validation to recognize all Intel certificate variants used over the years:
  - `Intel Corporation` (latest)
  - `Intel(R) Software and Firmware Products` (newer)
  - `Intel Corporation - Software and Firmware Products` (oldest)
  
  This ensures backward compatibility with older installer packages while maintaining strict security standards.

- **Configurable Credits Screen** — The credits screen is now fully dynamic and loaded from external `intel-chipset-infs-credits.txt` and `intel-chipset-infs-ads.txt` files. This allows easy customization of support links, career opportunities, and promotional content without modifying the core script. The screen supports interactive key shortcuts (1-5, A-E, L) that open configured URLs or exit the application.

- **Improved Database Parsing** — Fixed EOL detection logic to work with the new database format where EOL indicators are in section headers (`#### RaptorLake EOL`) rather than in the Package column. Platform names are now normalized (e.g., `RaptorLake` instead of `RaptorLake EOL`) for cleaner display.

### 🔧 Technical Improvements
- **EOL Detection**: Dual-mode parsing supports both old format (`(EOL)` in Package column) and new format (`#### Platform EOL` headers)
- **Signature Validation**: Enhanced with 3 Intel certificate patterns + expiration check + algorithm validation (SHA256/SHA1)
- **Credits Screen**: External configuration via `intel-chipset-infs-credits.txt` and `intel-chipset-infs-ads.txt`
- **Parser Robustness**: Fixed table separator detection (`---` now works alongside `:---`)
- **Backward Compatibility**: All changes maintain compatibility with existing database formats

### 📦 Database Updates
- Added EOL sections for 16 platforms (RaptorLake, AlderLake, CoffeeLake, TigerLakePCH-H, etc.)
- EOL packages contain legacy HWIDs that were removed from the latest Intel Chipset Device Software packages
- Installation order: EOL (oldest) → Main (latest) ensures all detected HWIDs receive the correct driver

---

## [v2026.05.0014] - 2026-05-15

### Highlights
- **Intel Platform Scanner 7.1** – major database generation improvements:
  - Fixed ArrowLake generation (`15th Gen Core/Core Ultra 200` instead of `14th Gen`)
  - Added missing generic platform entries (`ArrowLake`, `RaptorLake`, `AlderLake`, `TigerLake`, `CometLake`, `IceLake`, `Lakefield`, `CoffeeLake`, `KabyLake`, `Skylake`, `Crystalwell`) with correct `Order` values
  - Reordered `PCH Family` (oldest-to-newest) and fixed sorting for `LynxPoint`, `PantherPoint`, `CougarPoint`, `Wellsburg`, `Patsburg`, `Lewisburg`, `Emmitsburg`
  - Moved `MeteorLake PCH-N/H/S` from `CLIENT - Core` to `PCH Family`
  - Moved six `*_Extension-Dmasec` entries to `PCH Family` with proper generation names
  - Moved `IceLakeX` from `XEON / SERVER` to `WORKSTATION / HEDT`
  - Added asterisk `*` to legend for platforms without dedicated INF (e.g., `Emerald Rapids`, `Ice Lake-SP`, `Cascade Lake-X`) with explanatory footer note
  - Fixed duplicate `- Desktop/Mobile` suffix in `Generation` field
  - Added notes in MD footer about Wildcat Lake (shares HWIDs with Panther Lake), Panther Lake H/U (merged into single INF), and 16th generation (Lunar Lake classified under `ATOM / LOW POWER`)

- **Universal Intel Chipset Device Updater – Display Improvements**:
  - **Grouped HWID display** – platforms shown with HWID list instead of one line per device
  - **Compact platform information** – each platform uses 3 lines (platform name, generation, installer version, status) – removed redundant `Generation:` label to prevent line wrapping
  - **Parsing hint** – `Parsing INF information - it may take up to 30 seconds!`
  - **Simplified header banner** – removed redundant separator and `Visit:` row; author line now includes GitHub link
  - **Better Windows Inbox handling** – inbox platforms shown in compact grouped list, not mixed with regular updates
  - **Removed extra blank lines** – no double empty lines before platform information section

### Improvements
- **Scanner performance**: better sorting and chronological order in all sections (Client, Workstation, Xeon, Atom, PCH Family)
- **Updater UI**: cleaner, more readable output in `[SCREEN 2/4]` without information loss

### Technical
- Updated `Intel-Platform-Scanner.ps1` to v7.1
- Updated `universal-intel-chipset-device-updater.ps1` to v2026.05.0014
- Updated `README.md` platform support table up to 17th Gen
- Updated `CHANGELOG.md` for this release

### Notes
- No changes to core detection/installation logic – the INF update process, Windows Inbox detection, and safety measures remain identical to previous versions

---

## [v2026.03.0013] - 2026-03-13

### Improvements
- Added multi-database support with `-beta` and `-developer` flags for early testing of new Intel hardware platforms
- Implemented automatic script update via PowerShell Gallery when new version is detected
- Improved console exit behavior: screen clears after credits, showing clean thank you message before returning to prompt
- Removed unnecessary 5-second wait at the end of `-auto` / `-quiet` runs for faster execution

### Technical
- Added warning banner when running in non-default database modes
- Updated update detection logic to leverage native PowerShell Gallery commands
- Console output refinements for better user experience in different launch modes
- Internal cleanup of auto-mode exit routine

---

## [v2026.03.0012] - 2026-03-12

### Improvements
- Improved internal version handling and update detection logic
- Minor refinements in console output formatting
- General stability improvements

### Technical
- Internal script cleanup
- Minor workflow optimizations

---

## [v2026.03.0011] - 2026-03-11

### Improvements
- Improved platform detection reliability
- Refined progress and status messages

### Technical
- Code refactoring for maintainability
- Minor performance improvements in detection routines

---

## [v2026.03.0010] - 2026-03-10

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

## [v2026.02.0008] - 2026-02-10

### Improvements
- Improved chipset detection reliability
- Minor refinements in update workflow

### Technical
- Script cleanup and internal optimizations

---

## [v10.1-2026.02.2] - 2026-02-05

### Improvements
- Improved chipset detection stability
- Minor logging improvements

### Technical
- Internal script optimizations

---

## [v10.1-2026.02.1] - 2026-02-01

### Improvements
- Improved hardware detection reliability
- Minor stability improvements

### Technical
- Detection logic refinements

---

## [v10.1-2025.11.8] - 2025-11-27

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

## [v10.1-2025.11.7] - 2025-11-25

### Improvements
- Improved chipset detection workflow
- Minor stability improvements

---

## [v10.1-2025.11.6] - 2025-11-24

### Improvements
- Stability improvements to chipset detection workflow
- Improved INF package verification logic

### Technical
- Minor code refactoring

---

## [v10.1-2025.11.5] - 2025-11-21

### Improvements
- Improved INF package download reliability
- Enhanced update detection logic

### Technical
- Script optimizations
- Improved logging consistency

---

## [v10.1-2025.11.0] - 2025-11-14

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

[v2026.08.0018]: https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/tag/v2026.08.0018
[v2026.08.0017]: https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/tag/v2026.08.0017
[v2026.07.0016]: https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/tag/v2026.07.0016
[v2026.07.0015]: https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/tag/v2026.07.0015
[v2026.05.0014]: https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/tag/v2026.05.0014
[v2026.03.0013]: https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases/tag/v2026.03.0013  
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
