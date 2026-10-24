<p align="left">
  <a href="https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/MDM-DEPLOYMENT-GUIDE_EN_2026.md">🇬🇧 English</a> |
  <a href="https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/MDM-DEPLOYMENT-GUIDE_PL_2026.md">🇵🇱 Polski</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=de&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/MDM-DEPLOYMENT-GUIDE_EN_2026.md">🇩🇪 Deutsch</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=fr&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/MDM-DEPLOYMENT-GUIDE_EN_2026.md">🇫🇷 Français</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=es&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/MDM-DEPLOYMENT-GUIDE_EN_2026.md">🇪🇸 Español</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=pt&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/MDM-DEPLOYMENT-GUIDE_EN_2026.md">🇧🇷 Português</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=nl&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/MDM-DEPLOYMENT-GUIDE_EN_2026.md">🇳🇱 Nederlands</a>
  <br>
  <a href="MDM-DEPLOYMENT-GUIDE_CN_2026.md">🇨🇳 简体中文</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=ja&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/MDM-DEPLOYMENT-GUIDE_EN_2026.md">🇯🇵 日本語</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=ko&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/MDM-DEPLOYMENT-GUIDE_EN_2026.md">🇰🇷 한국어</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=it&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/MDM-DEPLOYMENT-GUIDE_EN_2026.md">🇮🇹 Italiano</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=tr&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/MDM-DEPLOYMENT-GUIDE_EN_2026.md">🇹🇷 Türkçe</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=ar&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/MDM-DEPLOYMENT-GUIDE_EN_2026.md">🇸🇦 العربية</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=hi&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/MDM-DEPLOYMENT-GUIDE_EN_2026.md">🇮🇳 हिन्दी</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=ru&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/MDM-DEPLOYMENT-GUIDE_EN_2026.md">🇷🇺 Русский</a>
</p>

## 通过 MDM 部署通用 Intel 芯片组设备更新器

管理整个机群的 Intel 芯片组 INF 更新过去意味着要么指望 Windows Update 最终跟上，要么手动接触每台设备。借助 v2026.03.0010 引入的 `-quiet` 和 `-auto` 参数，**通用 Intel 芯片组设备更新器**完全适合通过任何企业 MDM 平台进行静默、无人值守的部署。

本指南涵盖 **Microsoft Intune**、**Microsoft SCCM / Configuration Manager**、**VMware Workspace ONE** 和 **PDQ Deploy** 的部署——使用撰写本文时的最新版本。

---

### 前置条件（所有平台通用）

在通过任何 MDM 方案部署之前，请在目标机器上确认以下事项：
- **Windows 10 内部版本 17763（LTSC 2019）或更高版本** —— 开箱即用地完整支持 TLS 1.2 所需
- **.NET Framework 4.7.2 或更高版本** —— 连接 GitHub 与哈希校验所需
- **管理员权限** —— 脚本会自动提权，但部署上下文必须已经以 SYSTEM 或本地管理员账号运行
- **可访问 GitHub 的网络** —— 脚本从 `raw.githubusercontent.com` 和 GitHub release 资产下载 INF 包并校验哈希；请确保这些地址未被代理或防火墙拦截
- **PowerShell 执行策略** —— 启动命令中的 `-ExecutionPolicy Bypass` 参数已经处理；终端上无需修改策略

**所有 MDM 部署的推荐启动命令：**
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%SystemRoot%\Temp\IntelChipset\universal-intel-chipset-updater.ps1" -quiet
```

> **注意：** `-quiet` 隐含 `-auto`，并抑制所有控制台输出。无论是否静默模式，完整安装日志始终写入 `%ProgramData%\chipset_update.log` —— 用它来做部署验证。

---

### Microsoft Intune

Intune 支持两种实用的部署方式：**Win32 应用**（推荐）或 **PowerShell 脚本策略**。

#### 方式 A：Win32 应用（推荐）

这种方式提供完整的检测规则、分配过滤器和报告功能。

**1. 准备软件包**

从 [Releases 页面](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases) 下载最新的 SFX 可执行文件：
```
ChipsetUpdater-2026.03.0011-Win10-Win11.exe
```

创建一个静默运行 SFX 的包装脚本 `install.cmd` —— SFX 解压到 `%SystemRoot%\Temp\IntelChipset\` 并自动以 `-quiet` 启动 PS1：
```batch
ChipsetUpdater-2026.03.0011-Win10-Win11.exe
```

> SFX 软件包已预先配置为自动解压并启动 `universal-intel-chipset-updater.ps1 -quiet`。除非你需要自定义前后置操作，否则无需额外包装。

**2. 打包为 .intunewin**

使用 [Microsoft Win32 Content Prep Tool](https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool)：
```
IntuneWinAppUtil.exe -c "C:\Package" -s "ChipsetUpdater-2026.03.0011-Win10-Win11.exe" -o "C:\Output"
```

**3. 在 Intune 中创建 Win32 应用**
- 导航到 **Intune 管理中心** → **应用** → **Windows** → **添加** → **Windows 应用 (Win32)**
- 上传 `.intunewin` 文件
- 设置**安装命令**：

  ```
  ChipsetUpdater-2026.03.0011-Win10-Win11.exe
  ```
- 设置**卸载命令**（无需卸载——INF 文件是操作系统的一部分）：

  ```
  cmd.exe /c echo No uninstall required
  ```
- **安装行为**：`系统`（System）
- **设备重启行为**：`根据返回代码确定行为`
  - 添加返回代码 `3010` → `软重启`（Soft reboot）（以防 INF 安装后 Windows 标记待重启）

**4. 检测规则**

使用**注册表**检测规则来验证日志已写入（确认脚本已运行）：
- **项路径**：`HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion`
- **值名称**：_（留空——仅检测项是否存在）_

或者使用**文件**检测规则检查日志：
- **路径**：`C:\ProgramData`
- **文件**：`chipset_update.log`
- **检测方法**：文件或文件夹存在

**5. 分配并部署**

分配给设备组。试点时，先用**已分配**（Assigned）到一个测试组，然后通过**可用**（Available）或**必需**（Required）推广到更广的组。

---

#### 方式 B：PowerShell 脚本策略

更简单，但报告粒度较粗。适合快速推广。
- 导航到 **Intune 管理中心** → **设备** → **脚本和修正** → **平台脚本** → **添加** → **Windows 10 及更高版本**
- 直接上传 `universal-intel-chipset-updater.ps1`
- 设置：
  - **使用登录凭据运行此脚本**：`否`（以 SYSTEM 身份运行）
  - **强制脚本签名检查**：`否`
  - **在 64 位 PowerShell 主机中运行脚本**：`是`
- 分配给设备组

> **限制：** Intune PowerShell 脚本有默认超时。对于创建大型还原点或磁盘较慢的系统，总执行时间可能超过 10 分钟。如果发生超时，请改用方式 A（Win32 应用），其超时时间可配置。

---

### Microsoft SCCM / Configuration Manager

SCCM 在目标定位、调度和合规性报告方面提供最大的控制力。

#### 1. 创建软件包

- 在 **Configuration Manager 控制台**中，转到 **软件库** → **应用程序管理** → **软件包** → **创建软件包**
- **名称**：`Universal Intel Chipset Device Updater v2026.03.0011`
- **源文件夹**：指向包含 `ChipsetUpdater-2026.03.0011-Win10-Win11.exe` 的网络共享
- 创建一个**标准程序**，配置：
  - **命令行**：

    ```
    ChipsetUpdater-2026.03.0011-Win10-Win11.exe
    ```
  - **运行方式**：`隐藏`（Hidden）
  - **程序可运行**：`无论用户是否登录`
  - **以管理权限运行**：✅ 勾选

#### 2. 备选——直接部署 PS1

如果你更倾向于直接部署脚本而不用 SFX 包装：
- 将 `universal-intel-chipset-updater.ps1` 放到分发点
- 设置**命令行**为：

  ```
  powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "universal-intel-chipset-updater.ps1" -quiet
  ```
- **运行方式**：`隐藏`（Hidden）
- **程序可运行**：`无论用户是否登录`

#### 3. 分发与部署

- **分发内容** 到你的分发点
- **部署** 到设备集合
  - **目的**：强制推广用 `必需`（Required），自助服务用 `可用`（Available）
  - **计划**：如果想控制时间，设置维护时段（推荐——脚本会创建还原点，可能产生大量 I/O）
  - **用户体验** → **允许客户端独立于分配运行软件**：取决于你的策略
  - **返回代码**：如果尚未存在，添加 `3010` 为**软重启**（Soft Reboot）

#### 4. 合规性验证

创建一个**配置项**，检查 `%ProgramData%\chipset_update.log` 是否存在，或查询该文件的最后写入时间，以确认脚本在预期时间窗口内运行过。

---

### VMware Workspace ONE (UEM)

Workspace ONE 支持通过 **Freestyle Orchestrator** 或经典的**脚本**（Scripts）和**传感器**（Sensors）方式进行部署。

#### 方式 A：内部应用（SFX EXE）

- 在 **Workspace ONE UEM 控制台**中，转到 **Apps & Books** → **Applications** → **Native** → **Add Application** → **Upload**（上传）
- 上传 `ChipsetUpdater-2026.03.0011-Win10-Win11.exe`
- **部署选项**：
  - **安装命令**：_（保持默认——SFX 处理一切）_
  - **管理员权限**：`是`（Yes）
  - **安装上下文**：`设备`（Device）
- 在 **Files** 下，如果需要验证日志，添加一个**安装后脚本**（Post-Install Script）：

  ```powershell
  Test-Path "$env:ProgramData\chipset_update.log"
  ```

#### 方式 B：脚本（PowerShell）

- 导航到 **资源** → **脚本** → **添加** → **Windows**
- 上传或粘贴 `universal-intel-chipset-updater.ps1`
- **执行上下文**：`系统`（System）
- **执行架构**：`64 位`
- **超时**：设置为 `900` 秒（15 分钟），以应对较慢系统上的还原点创建
- 在 **分配**（Assignment）下，定位到合适的智能组（Smart Group）

#### 用于合规性报告的传感器

创建一个**传感器**来回报更新是否成功运行：

```powershell
# 返回包含完成状态的日志最后一行
if (Test-Path "$env:ProgramData\chipset_update.log") {
    $last = Get-Content "$env:ProgramData\chipset_update.log" | Select-Object -Last 5
    return ($last -join " ")
} else {
    return "Log not found"
}
```

- **评估类型**：`字符串`（String）
- 分配给与部署相同的智能组

---

### PDQ Deploy

PDQ Deploy 是本地环境和临时推广的最快选项。

#### 1. 创建新软件包

- 打开 **PDQ Deploy** → **新建软件包**（New Package）
- **名称**：`Universal Intel Chipset Device Updater v2026.03.0011`

#### 2. 添加步骤——安装（SFX）

- **步骤类型**：`安装`（Install）
- **安装文件**：浏览选择 `ChipsetUpdater-2026.03.0011-Win10-Win11.exe`
- **运行身份**：`Deploy User (PDQ)` 或 `Local System` —— 两者皆可，因为脚本会自动提权
- **成功代码**：添加 `0`、`3010`

#### 3. 备选——PowerShell 步骤

如果直接部署 PS1（例如从文件共享）：
- **步骤类型**：`PowerShell`
- **脚本**：

  ```powershell
  $dest = "$env:SystemRoot\Temp\IntelChipset"
  New-Item -ItemType Directory -Path $dest -Force | Out-Null
  Copy-Item "\\your-share\scripts\universal-intel-chipset-updater.ps1" "$dest\universal-intel-chipset-updater.ps1" -Force
  & powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "$dest\universal-intel-chipset-updater.ps1" -quiet
  ```
- **运行身份**：`Local System`
- **超时**：`900` 秒

#### 4. 计划部署或按需部署

- 使用**自动部署**（Auto Deployments）计划定期运行（例如每月、补丁星期二之后）
- 或从 PDQ Deploy 控制台**按需**（On Demand）部署到单个机器或组

#### 5. 验证结果

部署后，使用 **PDQ Inventory** 跨机器查询日志文件：
- **扫描器**（Scanner）→ **文件**（File）→ `C:\ProgramData\chipset_update.log` → 检查**最后修改**（Last Modified）日期

---

### 验证部署成功（所有平台通用）

无论使用哪种 MDM 平台，主要的验证方式都是日志文件：

```
%ProgramData%\chipset_update.log
```

一次成功的运行以类似这样的行结束：
```
[2026-03-11 14:32:07] [INFO] Script execution completed in 4.21 minutes with 0 errors
```

有问题的运行会包含 `[ERROR]` 条目——即使在 `-quiet` 模式下这些也会写入日志，因此日志始终是权威的事实来源。

**跨机群快速 PowerShell 检查（从你的管理工作站运行）：**
```powershell
$computers = Get-Content "C:\computers.txt"
foreach ($pc in $computers) {
    $log = "\\$pc\c$\ProgramData\chipset_update.log"
    if (Test-Path $log) {
        $last = Get-Content $log | Select-Object -Last 1
        [PSCustomObject]@{ Computer = $pc; Status = $last }
    } else {
        [PSCustomObject]@{ Computer = $pc; Status = "Log not found" }
    }
} | Format-Table -AutoSize
```

---

### 关于重启行为的说明

脚本安装的 INF 文件会在总线层面修改设备配置。Windows 通常不会强制立即重启，但需要**重启**才能完全应用更改。请相应规划你的部署窗口：
- 在 **Intune** 中：使用 `3010` 软重启返回代码，并配置维护时段或允许用户推迟
- 在 **SCCM** 中：配置部署的**用户体验** → **在截止时间或维护时段内提交更改**
- 在 **Workspace ONE** 中：使用设置为 `Defer`（推迟）的安装后重启策略
- 在 **PDQ Deploy** 中：在安装步骤后添加**重启**（Reboot）步骤，或通过你的标准补丁重启策略处理

---

过去，大规模部署芯片组 INF 更新需要从头编写自定义打包和脚本。`-quiet` 参数使这个工具成为任何 MDM 工作流的即插即用组件——困难的部分（检测正确的硬件、匹配软件包、校验哈希、创建还原点）都由工具自动处理。

👉 **[通用 Intel 芯片组设备更新器 —— GitHub](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater)**

---

作者：Marcin Grygiel，笔名 FirstEver（[LinkedIn](https://www.linkedin.com/in/marcin-grygiel)）
