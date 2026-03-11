# New Release Guide

---

## 1. Prepare the Files

Update the version and contents of:

- `universal-intel-chipset-device-updater.ps1` — change `.VERSION` in the PSScriptInfo block and `$ScriptVersion` in the code

---

## 2. Generate the SHA256 File

Run `Generate_Hash.bat` — it will generate a hash file for the PS1:

```
universal-intel-chipset-device-updater-2026.xx.xxxx-ps1.sha256
```

---

## 3. Create the SFX Archive in WinRAR

Add the following file to the archive:
```
universal-intel-chipset-device-updater.ps1
```

### General tab

| Option | Value |
|--------|-------|
| Archive name | `ChipsetUpdater-2026.xx.xxxx-Win10-Win11.exe` |
| Archive format | `RAR` |
| Compression method | `Best` |
| Create SFX archive | `Yes` |
| Create solid archive | `Yes` |
| Add recovery record | `Yes` |
| Lock archive | `Yes` |

### Advanced → SFX options → General

| Option | Value |
|--------|-------|
| Path to extract | `%SystemRoot%\Temp\universal-intel-chipset-device-updater` |

### Advanced → SFX options → Setup

| Option | Value |
|--------|-------|
| Run after extraction | `powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Normal -File "%SystemRoot%\Temp\universal-intel-chipset-device-updater\universal-intel-chipset-device-updater.ps1"` |

### Advanced → SFX options → Modes

| Option | Value |
|--------|-------|
| Hide all | `Yes` |

### Advanced → SFX options → Advanced

| Option | Value |
|--------|-------|
| Request administrative access | `Yes` |

### Advanced → SFX options → Update

| Option | Value |
|--------|-------|
| Overwrite all files | `Yes` |

### Advanced → SFX options → Logo and icon

| Option | Value |
|--------|-------|
| Load SFX icon | `FirstEverTech.ico` |

---

## 4. Digitally Sign the SFX File

Sign the generated EXE with your certificate:

```
ChipsetUpdater-2026.xx.xxxx-Win10-Win11.exe
```

---

## 5. Publish the Release on GitHub

Create a new release and attach the following files:

```
ChipsetUpdater-2026.xx.xxxx-Win10-Win11.exe
universal-intel-chipset-device-updater-2026.xx.xxxx-ps1.sha256
```

---

## 6. Update the Version File on GitHub

Update the contents of:
```
/src/universal-intel-chipset-device-updater.ver
```

**[Optional]** For backwards compatibility with older versions, also update:
```
/src/universal-intel-chipset-updater.ver
```

---

## 7. Publish to PowerShell Gallery

Publish **only after** the GitHub release is live — the script verifies a hash that must already be available in the repo.
> Your API Key can be copied from your ([PowerShell Gallery](https://www.powershellgallery.com/account/apikeys)) account.

```powershell
Publish-Script -Path ".\universal-intel-chipset-device-updater.ps1" `
               -NuGetApiKey "your-api-key" `
               -Repository PSGallery
```

---

Author: Marcin Grygiel aka FirstEver ([LinkedIn](https://www.linkedin.com/in/marcin-grygiel))
