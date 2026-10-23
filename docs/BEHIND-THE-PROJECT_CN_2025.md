<p align="left">
  <a href="https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/BEHIND-THE-PROJECT_EN_2025.md">🇬🇧 English</a> |
  <a href="https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/BEHIND-THE-PROJECT_PL_2025.md">🇵🇱 Polski</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=de&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/BEHIND-THE-PROJECT_EN_2025.md">🇩🇪 Deutsch</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=fr&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/BEHIND-THE-PROJECT_EN_2025.md">🇫🇷 Français</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=es&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/BEHIND-THE-PROJECT_EN_2025.md">🇪🇸 Español</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=pt&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/BEHIND-THE-PROJECT_EN_2025.md">🇧🇷 Português</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=nl&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/BEHIND-THE-PROJECT_EN_2025.md">🇳🇱 Nederlands</a>
  <br>
  <a href="BEHIND-THE-PROJECT_CN_2025.md">🇨🇳 简体中文</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=ja&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/BEHIND-THE-PROJECT_EN_2025.md">🇯🇵 日本語</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=ko&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/BEHIND-THE-PROJECT_EN_2025.md">🇰🇷 한국어</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=it&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/BEHIND-THE-PROJECT_EN_2025.md">🇮🇹 Italiano</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=tr&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/BEHIND-THE-PROJECT_EN_2025.md">🇹🇷 Türkçe</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=ar&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/BEHIND-THE-PROJECT_EN_2025.md">🇸🇦 العربية</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=hi&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/BEHIND-THE-PROJECT_EN_2025.md">🇮🇳 हिन्दी</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=ru&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/BEHIND-THE-PROJECT_EN_2025.md">🇷🇺 Русский</a>
</p>

# 🛠️ 通用 Intel 芯片组驱动更新器 —— 诞生记

## 一个人的执念如何变成史上最完整的 Intel INF 数据库

多年来，Intel 的芯片组设备软件（原名：Intel Chipset INF Utility）一直是大型硬件厂商发布过的最令人困惑的软件包之一。

我并没有计划成为 Intel INF 文件的考古学家——但我挖得越深，故事就越离奇。最终，这份好奇心变成了一个大规模项目：一个自动更新器，能够为每一代 Intel 芯片组——从 Sandy Bridge（2011 年）到今天——定位并安装最新且正确的 INF 文件。

本文是该项目如何诞生、为什么存在，以及一路上需要解决哪些技术噩梦的幕后故事。

---

## 🌀 1. 一切的起点：X79 / C600 灾难案例

我的个人电脑基于近乎史前时代的 X79（C600）芯片组——没错，2026 年我仍然每天都在用它，包括进行 GPU 基准测试，比如我的 [NVIDIA Smooth Motion](https://www.youtube.com/watch?v=TXstp8kN7j4) 演示。

更新 Intel 芯片组 INF 文件本应是件小事。
但到了 X79 这里，它变成了一场持续数天的取证调查。

Intel 的公开软件包列出的版本如下：

| 年份 | 安装程序        | INF 版本   | X79 支持   | 备注                      |
| :--- | :-------------- | :--------- | :--------- | :------------------------ |
| 2011 | 9.2.3.1020      | 9.2.3.1013 | ✅ 完整    | X79/C600 的首个 INF 版本  |     |
| 2013 | 9.4.4.1006      | 9.2.3.1032 | ✅ 完整    | 最后的 INF 版本 9.4.xxxx  |
| 2015 | 10.0.27         | 10.0.27    | ✅ 完整    | 最后的 INF 版本 10.0.xx   |
| 2015 | 10.1.1.45       | 10.1.1.45  | ✅ 完整    | 最后的 INF 版本 10.1.1.xx |
| 2017 | 10.1.2.86       | 10.1.2.86  | ✅ 完整    | 最后的 INF 版本 10.1.2.xx |
| 2021 | 10.1.18981.6008 | 10.1.3.2   | ✅ 完整    | 最后的 INF 版本 10.1.xxxx |
| 2025 | 10.1.20266.8668 | 无         | ❌ 无 HWID | 缺少 1Dxx/1Exx 条目       |
| 2026 | 10.1.20404.8794 | 无         | ❌ 无 HWID | 缺少 1Dxx/1Exx 条目       |

……但这些安装程序版本号无法告诉你实际会安装什么。
- 有些"较新"的软件包包含的是更旧的 INF 文件。
- 有些"稳定"的软件包包含 OEM 修改过的内容。
- 有些版本存在五种不同的变体，全部由 Intel 数字签名——但内容各不相同。

这一刻我意识到：
Intel 芯片组设备软件不是一个驱动包。
它是一个塞进 ZIP 压缩包里的历史博物馆。

---

## 📜 2. 追踪 14 年的 INF 文件

为了弄清 Intel 到底发布过什么，我下载了 93 个不同的 Intel 芯片组安装程序，从 10.0.13.0 一直到 10.1.20404.8794，包括：
- Intel 公开下载
- OEM 捆绑包（华硕/微星/技嘉/戴尔/EVGA）
- Windows Update CAB 压缩包
- 遗留镜像和被保存下来的 FTP 服务器

解压所有软件包后，我得到了：
- 5,333 个 INF 文件
- 2,996 个唯一的硬件 ID
- 87 个 Intel 平台
- 102,435 条版本关系

基于这个数据集，我生成了史上首个完整的 Intel 芯片组 INF 版本矩阵，现在可以在这里查看：
👉 [Intel 芯片组 INF 文件列表](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/data/intel-chipset-infs-latest.md)

这个数据库是更新器工具的基础。

---

## 🔧 3. 为什么需要更新器

Intel 官方安装程序本质上是：
- 一个通用包装器
- 包含数百个 INF 文件
- 只安装其中一小部分
- 其余的全部静默忽略，尤其是在较老的平台上（X79、C600、QM77、HM65 等）

更糟的是：
- 软件包版本 ≠ INF 版本
- 较新的软件包可能完全不支持较老的芯片组
- Windows 往往偏爱过时的系统内置 INF 文件
- OEM 软件包有时包含比 Intel 自己的最新软件包更新的版本

换句话说：
要找到"最新的 Intel 芯片组 INF 文件"，你必须搜索 14 年的软件包并交叉比对数千个文件。

所以我把它自动化了。

<img width="979" height="512" alt="image" src="https://github.com/user-attachments/assets/c44dd544-881a-439d-80ed-84bee88cda79" />

---

## 🚀 4. 通用 Intel 芯片组驱动更新器 —— 解决方案

我的工具会将你已安装的 INF 版本与全球数据库进行比对，并为你的确切硬件 ID 安装最新且有效的版本。

它支持：
- Windows 10 和 11（x64）
- Sandy Bridge → 最新的 Intel 各代平台
- 所有主流芯片组家族（台式机、移动端、工作站、服务器）

它使用多阶段验证流水线：
- 硬件 ID 检测
- 从数据集映射 INF
- 双镜像安全下载
- SHA256 哈希校验
- 数字签名验证
- 证书链验证
- 安全安装
- 可选系统重启

而在新版本中，安全性实现了巨大飞跃。

---

## 🛡️ 5. 安全突破性版本

最新更新（v10.1-2025.11.5）是这款工具迄今最大的一次进化。
以下是变化内容。

### 🔒 重大安全增强

- 安装 INF 前自动创建 Windows 还原点
- 所有下载的完整 SHA256 校验
- 数字签名验证（Intel 根证书 + 证书链）
- 独立验证的双源回退下载
- 安全的临时文件处理与自动清理

### ⚙ 技术改进

- 基于 GUID 的 GitHub RAW 缓存破坏
- 多方法 ZIP 解压（System.IO + COM 回退）
- 对不稳定网络有更好的韧性
- 更清晰的进度与错误消息
- 更详细的调试模式

### 🎯 用户体验改进

- 零重复消息
- 清晰的"预期 vs 实际"哈希格式
- 分步进度指示器
- 支持一键运行的 SFX EXE

---

## 🔍 6. 安全审查

该版本（v10.1-2025.11.5）由多个 AI 系统独立审查，每个系统都应用了结构化的安全分析标准：

### 主要正面评价

- 一流的层层验证
- 通过还原点实现安全回滚
- 所有资产公开哈希
- 出色的透明度和日志记录
- 强大的回退机制

### 次要残留风险

- 需要管理员权限
- 需要联网
- 仍然不是固件更新器（仅 INF）

**最终结论：**
这是该工具迄今最安全、最稳定、最专业的版本。
完整审计报告供参考。

---

## 🧬 7. "版本悖论" —— Intel 的 INF 混乱解析

最令人惊讶的发现之一是 Intel 软件包内部的版本不一致。

**示例：**
- 10.1.2.86（2017）更旧
- 10.1.18981.6008（2021）更新

两者在不同软件包中共享完全相同的版本号。
OEM 版本在大小、INF 数量和内容上各不相同。
Windows Update CAB 往往使用不同的时间戳。
Intel 最新的公开软件包（10.1.20266.8668）在 X79 上什么都不安装。

为什么？
因为最新的 Intel 软件包面向 C620（Lewisburg）平台。
它们只为较老的芯片组包含兼容性占位——没有真正的 INF 更新。

这正是这个项目存在的原因：为混乱恢复秩序。

---

## 🧩 8. Intel 本应该怎么做

一种现代、清晰、平台特定的做法：

| 文件名                                | 版本   | 日期       |
| ------------------------------------- | ------ | ---------- |
| IntelChipset-Patsburg-21.4.0.exe      | 21.4.0 | 24/04/2021 |
| IntelChipset-LunarLake-25.8.1.exe     | 25.8.1 | 15/08/2025 |
| IntelChipset-GraniteRapids-24.9.0.exe | 24.9.0 | 30/09/2024 |

但 Intel 选择的是：
- 一个包装下所有东西的巨大软件包
- 不可预测的内部版本号
- 名称相同的 OEM 变体
- 对旧平台静默无操作

这个更新器修正了这一切。

---

## 📦 9. 使用指南（EXE、BAT 或 PowerShell）

### 选项 1：SFX EXE（推荐）

1. 下载：
   `ChipsetUpdater-10.1-2025.11.8-Win10-Win11.exe`
2. 以管理员身份运行
3. 按提示操作

### 选项 2：批处理文件

1. 下载 `Universal-Intel-Chipset-Updater.bat + .ps1`
2. 放在同一个文件夹中
3. 以管理员身份运行 `.bat`

### 选项 3：PowerShell

powershell -ExecutionPolicy Bypass -File Universal-Intel-Chipset-Updater.ps1

日志：
`C:\Windows\Temp\IntelChipset\chipset_update.log`

---

## 🧠 10. 结语：这个项目为什么存在

Intel 的芯片组 INF 生态系统已经演进了近 25 年——拥有数千个文件、持续的硬件更迭，并且对较老平台没有权威的"最终"版本清单。

所以我构建了一个。

这个项目试图为 Windows 生态中被忽视十多年的一角带来：
- 清晰
- 一致
- 自动化
- 安全
- 以及历史准确性

如果你发现数据库中有不一致之处，我很乐意更新它。
社区的贡献已经帮助完善了数百条条目。

作者：Marcin Grygiel，笔名 FirstEver（[LinkedIn](https://www.linkedin.com/in/marcin-grygiel)）

---

## 📘 有用链接

- [Intel 芯片组 INF 文件列表](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/Intel_Chipset_INFs_Latest.md)
- [Intel 芯片组设备软件下载链接](https://www.intel.com/content/www/us/en/download/19347/chipset-inf-utility.html)
- [Intel 芯片组 INF 工具搜索](https://www.intel.com/content/www/us/en/search.html#q=Chipset%20INF%20Utility)
- [问题追踪器](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/issues)
