<p align="left">
  <a href="https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/INF-SELECTION-SETUPAPI-RANKING-MODEL_EN_2026.md">🇬🇧 English</a> |
  <a href="https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/INF-SELECTION-SETUPAPI-RANKING-MODEL_PL_2026.md">🇵🇱 Polski</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=de&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/INF-SELECTION-SETUPAPI-RANKING-MODEL_EN_2026.md">🇩🇪 Deutsch</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=fr&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/INF-SELECTION-SETUPAPI-RANKING-MODEL_EN_2026.md">🇫🇷 Français</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=es&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/INF-SELECTION-SETUPAPI-RANKING-MODEL_EN_2026.md">🇪🇸 Español</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=pt&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/INF-SELECTION-SETUPAPI-RANKING-MODEL_EN_2026.md">🇧🇷 Português</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=nl&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/INF-SELECTION-SETUPAPI-RANKING-MODEL_EN_2026.md">🇳🇱 Nederlands</a>
  <br>
  <a href="INF-SELECTION-SETUPAPI-RANKING-MODEL_CN_2026.md">🇨🇳 简体中文</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=ja&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/INF-SELECTION-SETUPAPI-RANKING-MODEL_EN_2026.md">🇯🇵 日本語</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=ko&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/INF-SELECTION-SETUPAPI-RANKING-MODEL_EN_2026.md">🇰🇷 한국어</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=it&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/INF-SELECTION-SETUPAPI-RANKING-MODEL_EN_2026.md">🇮🇹 Italiano</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=tr&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/INF-SELECTION-SETUPAPI-RANKING-MODEL_EN_2026.md">🇹🇷 Türkçe</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=ar&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/INF-SELECTION-SETUPAPI-RANKING-MODEL_EN_2026.md">🇸🇦 العربية</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=hi&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/INF-SELECTION-SETUPAPI-RANKING-MODEL_EN_2026.md">🇮🇳 हिन्दी</a> |
  <a href="https://translate.google.com/translate?sl=en&tl=ru&u=https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/docs/INF-SELECTION-SETUPAPI-RANKING-MODEL_EN_2026.md">🇷🇺 Русский</a>
</p>

## INF 选择与 SetupAPI 驱动排名模型

### 术语

- **INF**：声明式的驱动安装文件
- **驱动包**：INF + 二进制文件 + 目录（catalog）文件
- **驱动选择**：基于 SetupAPI 的排名过程

---

## 概述

Windows 驱动选择由 SetupAPI 使用多因素排名模型执行。

INF 版本不属于排名逻辑的一部分。

---

## 已确认的 SetupAPI 排名要素

### 1. 签名分数（首要）

- WHQL / Microsoft / OEM 信任级别
- 决定基线资格与信任等级

---

### 2. 功能相关评分（INF 级属性，部分未公开定义）

某些 INF 文件可能在 INF 元数据中定义一个类似 FeatureScore 的参数。

但是：
- 确切的放置位置与执行细节未在公开文档中完整说明
- 该行为在 SetupAPI 内部依赖具体实现

它被视为驱动选择过程中的一个优先级提示。

---

### 3. 标识符分数

- 硬件 ID（HWID）
- 兼容 ID（CompatID）
- 匹配强度评估（精确 > 兼容 > 通用）

---

### 4. DriverVer 决胜条件

- DriverVer 日期
- 然后是版本号
- 仅当所有更高级别的排名要素都相同时才使用

---

## INF 版本与排名逻辑

INF 版本：
- 仅作为元数据
- 不属于 SetupAPI 排名的一部分
- 不影响硬件匹配决策

DriverVer 是决胜场景中唯一与版本相关的要素。

---

## 功能等价（工程概念）

"功能等价"是一种工程抽象，含义是：
- 相同的 HWID/CompatID 覆盖范围
- 相同的驱动绑定结果
- 安装后相同的系统状态

它不是 Windows 驱动框架（Windows Driver Framework）的官方术语。

---

## 运行时行为与操作系统升级行为

### Windows 更新（运行时）

- 使用 SetupAPI 排名模型
- 应用多因素评分
- DriverVer 仅用作决胜条件

### Windows 安装程序（操作系统升级 / 迁移）

- 可能因以下原因替换驱动：
  - 系统内置基线策略
  - 迁移规则
  - 兼容性回退逻辑

---

## 结论

Windows 驱动选择基于 SetupAPI 多因素排名：
1. 签名分数
2. 标识符分数（HWID/CompatID）
3. 功能相关的 INF 评分（依赖具体实现）
4. DriverVer（决胜）

INF 版本不属于排名系统的一部分。

部分 INF 级功能评分行为并未完全公开定义，应视为依赖具体实现。
作者：Marcin Grygiel，笔名 FirstEver（[LinkedIn](https://www.linkedin.com/in/marcin-grygiel)）

---

## 📘 有用链接

- [Intel 芯片组 INF 文件列表](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/Intel_Chipset_INFs_Latest.md)
- [Intel 芯片组设备软件下载链接](https://www.intel.com/content/www/us/en/download/19347/chipset-inf-utility.html)
- [Intel 芯片组 INF 工具搜索](https://www.intel.com/content/www/us/en/search.html#q=Chipset%20INF%20Utility)
- [问题追踪器](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/issues)
