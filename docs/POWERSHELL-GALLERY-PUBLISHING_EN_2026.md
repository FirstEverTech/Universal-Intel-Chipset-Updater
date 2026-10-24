<p align="left">
  <a href="https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/POWERSHELL-GALLERY-PUBLISHING_EN_2026.md">🇬🇧 English</a> |
  <a href="https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/POWERSHELL-GALLERY-PUBLISHING_PL_2026.md">🇵🇱 Polski</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=de&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/POWERSHELL-GALLERY-PUBLISHING_EN_2026.md">🇩🇪 Deutsch</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=fr&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/POWERSHELL-GALLERY-PUBLISHING_EN_2026.md">🇫🇷 Français</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=es&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/POWERSHELL-GALLERY-PUBLISHING_EN_2026.md">🇪🇸 Español</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=pt&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/POWERSHELL-GALLERY-PUBLISHING_EN_2026.md">🇧🇷 Português</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=nl&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/POWERSHELL-GALLERY-PUBLISHING_EN_2026.md">🇳🇱 Nederlands</a>
  <br>
  <a href="POWERSHELL-GALLERY-PUBLISHING_CN_2026.md">🇨🇳 简体中文</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=ja&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/POWERSHELL-GALLERY-PUBLISHING_EN_2026.md">🇯🇵 日本語</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=ko&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/POWERSHELL-GALLERY-PUBLISHING_EN_2026.md">🇰🇷 한국어</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=it&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/POWERSHELL-GALLERY-PUBLISHING_EN_2026.md">🇮🇹 Italiano</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=tr&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/POWERSHELL-GALLERY-PUBLISHING_EN_2026.md">🇹🇷 Türkçe</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=ar&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/POWERSHELL-GALLERY-PUBLISHING_EN_2026.md">🇸🇦 العربية</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=hi&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/POWERSHELL-GALLERY-PUBLISHING_EN_2026.md">🇮🇳 हिन्दी</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=ru&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/POWERSHELL-GALLERY-PUBLISHING_EN_2026.md">🇷🇺 Русский</a>
</p>

# PowerShell Gallery — Publishing Tutorial

## 1. Create an Account

Go to **https://www.powershellgallery.com** and sign in with a Microsoft account (Outlook/Hotmail/Live).

---

## 2. Generate an API Key

- Click your username → **API Keys** → **Create**
- Fill in:
  - **Key Name** — any label e.g. `My Tool Name`
  - **Expires** — maximum 365 days (you must regenerate it every year)
  - **Scopes** → check **Push new packages and package versions**
  - **Packages** → enter the exact package name e.g. `my-tool-name`
- Click **Create** → **copy the key immediately** — it is only shown once

---

## 3. Generate a GUID

Run in PowerShell (no admin required):

```powershell
[guid]::NewGuid()
```

Save the result — this GUID identifies your package forever. It never changes between versions.

---

## 4. Add PSScriptInfo to Your PS1

Paste the block below as the **very first thing in the file** — before any code:

```powershell
<#PSScriptInfo
.VERSION 1.0.0
.GUID your-guid-here
.NAME your-package-name-on-gallery
.AUTHOR Your Name
.COMPANYNAME Your Company
.COPYRIGHT (c) 2026 Your Name. All rights reserved.
.TAGS tag1 tag2 tag3 Windows Automation
.LICENSEURI https://github.com/YourRepo/LICENSE
.PROJECTURI https://github.com/YourRepo
.ICONURI
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES
v1.0.0 - Initial release
#>
```

Immediately after PSScriptInfo, add a script description block:

```powershell
<#
.SYNOPSIS
    Short one-line description.

.DESCRIPTION
    Detailed description of the tool.
    What it does, what it requires, and anything worth noting for the Gallery moderator.

.PARAMETER ParamName
    Description of the parameter.

.EXAMPLE
    .\my-script.ps1
    Description of the example.

.NOTES
    Additional information.
#>
```

---

## 5. Validate Locally

```powershell
Test-ScriptFileInfo -Path ".\your-script.ps1"
```

Check that the **Name** and **Version** columns are correct. If you get an error — verify that PSScriptInfo is at the very top of the file.

---

## 6. Publish

```powershell
Publish-Script -Path ".\your-script.ps1" `
               -NuGetApiKey "your-api-key" `
               -Repository PSGallery
```

---

## 7. Updates (every new version)

In the PSScriptInfo block, change only:

```powershell
.VERSION 1.0.1
.RELEASENOTES
v1.0.1 - Description of changes
```

The GUID stays the same forever. Publish using the same command as in step 6.

---

## ⚠️ Important Rules

- Publish to Gallery **only after** publishing the release on GitHub
- The version number must always be higher than the previous one
- The API Key expires after one year — regenerate it before publishing
- `.NAME` in PSScriptInfo must exactly match the name in the **Packages** field of the API Key

---

Author: Marcin Grygiel aka FirstEver ([LinkedIn](https://www.linkedin.com/in/marcin-grygiel))
