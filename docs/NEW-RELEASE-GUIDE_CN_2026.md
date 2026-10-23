<p align="left">
  <a href="https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/NEW-RELEASE-GUIDE_EN_2026.md">🇬🇧 English</a> |
  <a href="https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/NEW-RELEASE-GUIDE_PL_2026.md">🇵🇱 Polski</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=de&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/NEW-RELEASE-GUIDE_EN_2026.md">🇩🇪 Deutsch</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=fr&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/NEW-RELEASE-GUIDE_EN_2026.md">🇫🇷 Français</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=es&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/NEW-RELEASE-GUIDE_EN_2026.md">🇪🇸 Español</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=pt&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/NEW-RELEASE-GUIDE_EN_2026.md">🇧🇷 Português</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=nl&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/NEW-RELEASE-GUIDE_EN_2026.md">🇳🇱 Nederlands</a>
  <br>
  <a href="NEW-RELEASE-GUIDE_CN_2026.md">🇨🇳 简体中文</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=ja&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/NEW-RELEASE-GUIDE_EN_2026.md">🇯🇵 日本語</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=ko&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/NEW-RELEASE-GUIDE_EN_2026.md">🇰🇷 한국어</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=it&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/NEW-RELEASE-GUIDE_EN_2026.md">🇮🇹 Italiano</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=tr&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/NEW-RELEASE-GUIDE_EN_2026.md">🇹🇷 Türkçe</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=ar&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/NEW-RELEASE-GUIDE_EN_2026.md">🇸🇦 العربية</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=hi&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/NEW-RELEASE-GUIDE_EN_2026.md">🇮🇳 हिन्दी</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=ru&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/NEW-RELEASE-GUIDE_EN_2026.md">🇷🇺 Русский</a>
</p>

# 新版本发布指南

---

## 1. 准备文件

更新版本和以下内容：
- `universal-intel-chipset-device-updater.ps1` —— 修改 PSScriptInfo 代码块中的 `.VERSION` 以及代码中的 `$ScriptVersion`

---

## 2. 生成 SHA256 文件

运行 `Generate_Hash.bat` —— 它会为 PS1 生成哈希文件：

```
universal-intel-chipset-device-updater-2026.xx.xxxx-ps1.sha256
```

---

## 3. 在 WinRAR 中创建 SFX 压缩包

将以下文件添加到压缩包：
```
universal-intel-chipset-device-updater.ps1
```

### 常规选项卡

| 选项                          | 值                                            |
| ----------------------------- | --------------------------------------------- |
| 压缩文件名                    | `ChipsetUpdater-2026.xx.xxxx-Win10-Win11.exe` |
| 压缩文件格式                  | `RAR`                                         |
| 压缩方式                      | `最好`（Best）                                |
| 创建自解压格式压缩文件（SFX） | `是`                                          |
| 创建固实压缩文件              | `是`                                          |
| 添加恢复记录                  | `是`                                          |
| 锁定压缩文件                  | `是`                                          |

### 高级 → SFX 选项 → 常规

| 选项     | 值                                                         |
| -------- | ---------------------------------------------------------- |
| 解压路径 | `%SystemRoot%\Temp\universal-intel-chipset-device-updater` |

### 高级 → SFX 选项 → 设置

| 选项       | 值                                                                                                                                                                                  |
| ---------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 解压后运行 | `powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Normal -File "%SystemRoot%\Temp\universal-intel-chipset-device-updater\universal-intel-chipset-device-updater.ps1"` |

### 高级 → SFX 选项 → 模式

| 选项     | 值   |
| -------- | ---- |
| 全部隐藏 | `是` |

### 高级 → SFX 选项 → 高级

| 选项           | 值   |
| -------------- | ---- |
| 请求管理员权限 | `是` |

### 高级 → SFX 选项 → 更新

| 选项         | 值   |
| ------------ | ---- |
| 覆盖所有文件 | `是` |

### 高级 → SFX 选项 → 徽标和图标

| 选项          | 值                  |
| ------------- | ------------------- |
| 加载 SFX 图标 | `FirstEverTech.ico` |

---

## 4. 对 SFX 文件进行数字签名

使用你的证书对生成的 EXE 签名：

```
ChipsetUpdater-2026.xx.xxxx-Win10-Win11.exe
```

---

## 5. 在 GitHub 上发布 Release

创建新 release 并附加以下文件：

```
ChipsetUpdater-2026.xx.xxxx-Win10-Win11.exe
universal-intel-chipset-device-updater-2026.xx.xxxx-ps1.sha256
```

---

## 6. 在 GitHub 上更新版本文件

更新以下内容：
```
/src/universal-intel-chipset-device-updater.ver
```

**（可选）** 为了兼容旧版本，也请更新：
```
/src/universal-intel-chipset-updater.ver
```

---

## 7. 发布到 PowerShell Gallery

**只有**在 GitHub release 上线**之后**才能发布 —— 脚本会校验一个必须已经存在于仓库中的哈希。
> 你的 API 密钥可以从你的（[PowerShell Gallery](https://www.powershellgallery.com/account/apikeys)）账号中复制。

```powershell
Publish-Script -Path ".\universal-intel-chipset-device-updater.ps1" `
               -NuGetApiKey "your-api-key" `
               -Repository PSGallery
```

---

作者：Marcin Grygiel，笔名 FirstEver（[LinkedIn](https://www.linkedin.com/in/marcin-grygiel)）
