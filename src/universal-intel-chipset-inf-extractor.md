# Universal Intel Chipset INF Extractor

Extracts INF/CAT driver files from Intel Chipset Device Software installers (`SetupChipset.exe`), for both old and new installer formats.

Not affiliated with Intel Corporation. Uses open-source components from [NanaZip](https://github.com/M2Team/NanaZip).

## Requirements

- Windows PowerShell 5.1 or later
- Internet connection (used for script authenticity check and, if needed, one-time NanaZip download)
- Windows account with permission to write to `C:\INF_Extractor`, `C:\Windows\Temp\INF_Extractor`, and `C:\ProgramData`

No manual setup is required. NanaZip binaries are downloaded automatically on first run if needed.

## Usage

### No arguments — scan current directory

```powershell
.\universal-intel-chipset-inf-extractor.ps1
```

Scans the folder the script is run from for Intel Chipset installer(s). If none are found, an error message with usage examples is shown.

### Single file

```powershell
.\universal-intel-chipset-inf-extractor.ps1 C:\Download\SetupChipset.exe
```

Extracts only the specified installer. Works with relative or absolute paths.

### Directory (recursive)

```powershell
.\universal-intel-chipset-inf-extractor.ps1 C:\Intel_Installers\
```

Recursively scans the given folder and all subfolders for Intel Chipset installers, and extracts each one found. If one installer fails, the rest are still processed.

### Help

```powershell
.\universal-intel-chipset-inf-extractor.ps1 -Help
```

### Debug output

```powershell
.\universal-intel-chipset-inf-extractor.ps1 -Debug
```

Prints additional diagnostic messages to the console (in addition to what is always written to the log file).

## How installer detection works

A file is recognized as an Intel Chipset installer if its `FileDescription`, `ProductName`, or `OriginalFilename` matches known Intel Chipset Device Software patterns (e.g. `Intel(R) Chipset Device Software`, `SetupChipset.exe`, `ChipsetInstaller.exe`). The filename itself does not need to be `SetupChipset.exe` — any renamed copy is still detected correctly.

## Extraction method (chosen automatically by version)

| Version range | Method | Output |
|---|---|---|
| `10.0.x.x` | Legacy `/s /extract` | `C:\INF_Extractor\<version>\Legacy\` |
| `10.1.x.x` below `10.1.20378.8757` | Legacy `/s /extract` | `C:\INF_Extractor\<version>\` |
| `10.2.x.x` (any) | Legacy `/s /extract` | `C:\INF_Extractor\<version>\` |
| `10.1.x.x` from `10.1.20378.8757` up | NanaZip 3-stage extraction | `C:\INF_Extractor\<version>\` |

Newer installers no longer support a built-in `/extract` switch, so the tool unpacks them as a PE archive using NanaZip instead.

## Script integrity check (SHA256)

On every run, before doing anything else, the tool:

1. Tests connectivity to GitHub.
2. If reachable, downloads the official SHA256 hash for this exact script version and compares it against the file on disk.

Possible outcomes:

- **Match** — proceeds normally.
- **Mismatch** — the file differs from the official version on GitHub. It may have been modified. You are shown the expected vs. actual hash and asked `(Y/N)` whether to continue anyway.
- **No connectivity** — GitHub could not be reached at all. Authenticity cannot be confirmed. You are asked `(Y/N)` whether to continue anyway.
- **Fetch failed** — GitHub is reachable, but the specific hash file could not be downloaded or parsed. You are asked `(Y/N)` whether to continue anyway.

Answering **N** to any of these prompts safely exits without extracting anything.

## Output locations

| What | Where |
|---|---|
| Extracted INF/CAT files | `C:\INF_Extractor\<version>\...` |
| Activity log (every run) | `C:\ProgramData\INF_Extractor.log` |
| Failed extractions report | `INF_Extractor_Failed.txt`, in the folder the script was run from |
| Temporary/staging files | `C:\Windows\Temp\INF_Extractor\` (cleaned up automatically after each run) |

The failed-extractions report is only created if at least one installer fails (single-file or batch mode). It is overwritten on each run and lists only the failed item(s): file name, path, detected version (if known), and the reason for failure. Successful items are not included there — check `INF_Extractor.log` for the full run history.

## Batch mode behavior

When multiple installers are found, a failure on one installer does **not** stop the rest of the batch. Each installer is processed independently; the final summary screen lists every installer with its status (`SUCCESS` or `FAILED`) and, for failures, the specific reason.

## Troubleshooting

- **"This specified file is not a recognized Intel Chipset Device Software."** — the file exists but its version metadata doesn't match known Intel Chipset installer patterns. Confirm it's the correct file.
- **"WARNING: Could not verify HASH from GitHub."** — check your internet connection, or your firewall/proxy may be blocking `raw.githubusercontent.com`.
- Full details for any run are always available in `C:\ProgramData\INF_Extractor.log`, regardless of what's shown on screen.

## Disclaimer

This tool is provided as-is, with no warranty. INF/CAT files it extracts come from the Intel installer you provide — always source that installer from Intel or another source you trust. Use at your own risk.
