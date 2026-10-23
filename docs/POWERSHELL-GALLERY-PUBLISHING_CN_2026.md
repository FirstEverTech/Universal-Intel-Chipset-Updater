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

# PowerShell Gallery —— 发布教程

## 1. 创建账号

前往 **https://www.powershellgallery.com**，使用 Microsoft 账号（Outlook/Hotmail/Live）登录。

---

## 2. 生成 API 密钥

- 点击你的用户名 → **API Keys** → **Create**（创建）
- 填写：
  - **Key Name（密钥名称）** —— 任意标签，例如 `My Tool Name`
  - **Expires（过期时间）** —— 最长 365 天（每年必须重新生成）
  - **Scopes（权限范围）** → 勾选 **Push new packages and package versions**（推送新包和包版本）
  - **Packages（包名）** —— 输入确切的包名，例如 `my-tool-name`
- 点击 **Create**（创建）→ **立即复制密钥** —— 它只显示一次

---

## 3. 生成 GUID

在 PowerShell 中运行（无需管理员权限）：

```powershell
[guid]::NewGuid()
```

保存结果 —— 这个 GUID 将永久标识你的包。它在各版本之间永不改变。

---

## 4. 在 PS1 中添加 PSScriptInfo

将下面的代码块粘贴为**文件中的第一个内容** —— 位于任何代码之前：

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

紧接在 PSScriptInfo 之后，添加脚本描述块：

```powershell
<#
.SYNOPSIS
    简短的一行描述。

.DESCRIPTION
    工具的详细描述。
    它做什么、需要什么，以及任何值得向 Gallery 审核员说明的内容。

.PARAMETER ParamName
    参数描述。

.EXAMPLE
    .\my-script.ps1
    示例描述。

.NOTES
    附加信息。
#>
```

---

## 5. 本地验证

```powershell
Test-ScriptFileInfo -Path ".\your-script.ps1"
```

检查 **Name**（名称）和 **Version**（版本）列是否正确。如果出现错误 —— 请确认 PSScriptInfo 位于文件的最顶部。

---

## 6. 发布

```powershell
Publish-Script -Path ".\your-script.ps1" `
               -NuGetApiKey "your-api-key" `
               -Repository PSGallery
```

---

## 7. 更新（每个新版本）

在 PSScriptInfo 代码块中，只修改：

```powershell
.VERSION 1.0.1
.RELEASENOTES
v1.0.1 - Description of changes
```

GUID 永远保持不变。使用与第 6 步相同的命令发布。

---

## ⚠️ 重要规则

- 只有在 GitHub 上发布 release **之后**，才能发布到 Gallery
- 版本号必须始终高于上一个版本
- API 密钥一年后过期 —— 发布前必须重新生成
- PSScriptInfo 中的 `.NAME` 必须与 API 密钥的 **Packages** 字段中的名称完全一致

---

作者：Marcin Grygiel，笔名 FirstEver（[LinkedIn](https://www.linkedin.com/in/marcin-grygiel)）
