## INF Selection and SetupAPI Driver Ranking Model

### Terminology

- **INF**: declarative driver installation file
- **Driver package**: INF + binaries + catalog
- **Driver selection**: SetupAPI-based ranking process

---

## Overview

Windows driver selection is performed by SetupAPI using a multi-factor ranking model.

INF version is not part of the ranking logic.

---

## Confirmed SetupAPI ranking components

### 1. Signature score (primary)
- WHQL / Microsoft / OEM trust level
- determines baseline eligibility and trust class

---

### 2. Feature-related scoring (INF-level attribute, partially specified)

Some INF files may define a FeatureScore-like parameter within the INF metadata.

However:

- exact placement and enforcement details are not fully documented publicly
- behavior is implementation-dependent within SetupAPI

It is treated as a priority hint within the driver selection process.

---

### 3. Identifier score
- Hardware ID (HWID)
- Compatible ID (CompatID)
- match strength evaluation (exact > compatible > generic)

---

### 4. DriverVer tie-breaker
- DriverVer date
- then version number
- used only when all higher ranking factors are equal

---

## INF version vs ranking logic

INF version:

- is metadata only
- is not part of SetupAPI ranking
- does not affect hardware matching decisions

DriverVer is the only version-related element used in tie-break scenarios.

---

## Functional equivalence (engineering construct)

"Functional equivalence" is an engineering abstraction meaning:

- identical HWID/CompatID coverage
- identical driver binding outcome
- identical system state after installation

It is not an official Windows Driver Framework term.

---

## Runtime vs OS upgrade behavior

### Windows Update (runtime)
- uses SetupAPI ranking model
- applies multi-factor scoring
- DriverVer used only as tie-breaker

### Windows Setup (OS upgrade / migration)
- may replace drivers due to:
  - inbox baseline policy
  - migration rules
  - compatibility fallback logic

---

## Conclusion

Windows driver selection is based on SetupAPI multi-factor ranking:

1. Signature score
2. Identifier score (HWID/CompatID)
3. Feature-related INF scoring (implementation-dependent)
4. DriverVer (tie-break)

INF version is not part of the ranking system.

Some INF-level feature scoring behavior is not fully publicly specified and should be treated as implementation-dependent.
Author: Marcin Grygiel aka FirstEver ([LinkedIn](https://www.linkedin.com/in/marcin-grygiel))

---

## 📘 Useful Links


- [Intel Chipset INF Files List](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/Intel_Chipset_INFs_Latest.md)
- [Intel Chipset Device Software Link](https://www.intel.com/content/www/us/en/download/19347/chipset-inf-utility.html)
- [Intel Chipset INF Utility Search](https://www.intel.com/content/www/us/en/search.html#q=Chipset%20INF%20Utility)
- [Issue Tracker](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/issues)
