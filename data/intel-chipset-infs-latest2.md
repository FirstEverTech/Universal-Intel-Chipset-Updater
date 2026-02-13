# Intel Chipset INF Files List - Strict Architecture Mode

The Intel Chipset Device Software installs the Windows INF files. An INF is a text file that provides the operating system with information about a piece of hardware on the system. In the case of the current Intel Chipset Device Software, that information is primarily the product name for the piece of hardware. This allows the operating system to show the correct name for that piece of hardware in Device Manager.

This dataset organizes the historical naming of platforms, with a focus on technical rather than marketing aspects. It is based on:

- Detects 5,333 INF files
- Pulls 2,996 unique HWIDs
- Creates 102,435 entries

## Naming Legend - Microarchitecture / Segment

### CLIENT - Core
- Panther Lake - High Performance Mobile / Efficient Mobile
- Arrow Lake - Desktop / High Performance Mobile
- Meteor Lake - Tile-based Mobile SoC
- Raptor Lake - Desktop / Performance Mobile / Efficient Mobile
- Alder Lake - Desktop / Performance Mobile / Efficient Mobile
- Rocket Lake - Desktop
- Tiger Lake - Mobile SoC / High Performance Mobile
- Ice Lake - Mobile SoC
- Comet Lake - Desktop / Mobile
- Coffee Lake - Desktop / Mobile
- Kaby Lake - Desktop / Mobile
- Skylake - Desktop / Mobile
- Broadwell - Desktop/Mobile
- Haswell - Desktop/Mobile
- Ivy Bridge - Desktop/Mobile
- Sandy Bridge - Desktop/Mobile

### WORKSTATION / HEDT
- Ice Lake-X (Xeon W-3300)
- Cascade Lake-X (X299)
- Skylake-X (X299)
- Haswell-E / Broadwell-E (X99)
- Ivy Bridge-E (X79)
- Sandy Bridge-E (X79)
- Wellsburg PCH (X99/C610)
- Patsburg PCH (X79/C600)

### XEON / SERVER
- Granite Rapids (Xeon 6th Gen)
- Emerald Rapids (Xeon Scalable 5th Gen)
- Sapphire Rapids (Xeon Scalable 4th Gen)
- Ice Lake-SP (Xeon Scalable 3rd Gen)
- Cascade Lake-SP / Cooper Lake-SP (Xeon Scalable 2nd Gen)
- Skylake-SP (Xeon Scalable 1st Gen)
- Broadwell-DE (Xeon D-1500)
- Grantley / Brickland / Romley (Xeon E5)
- Lewisburg / Emmitsburg (Server Chipset)
- Knights Landing (Xeon Phi)
- Coleto Creek / Kaseyville (Communications)

### ATOM / LOW POWER / EMBEDDED
- Lunar Lake (Core Ultra 200V)
- Alder Lake-N (Atom)
- Jasper Lake (Atom)
- Elkhart Lake (Atom)
- Gemini Lake (Atom)
- Apollo Lake (Atom)
- Bay Trail (Atom)
- Braswell (Atom)
- Denverton / Avoton (Atom Server)
- Valleyview 2 / Cedar Fork (Embedded/IoT)

### PCH Family
- 700 Series - Raptor Lake PCH-S (Desktop)
- 600 Series - Alder Lake PCH (Desktop / Mobile)
- 500 Series - Tiger Lake PCH (Mobile)
- 400 Series - Comet Lake PCH (Mobile / Workstation)
- 200 Series - Kaby Lake PCH-H (Mobile)
- 100 Series - Sunrise Point (Desktop/Mobile PCH)
- 9 Series - Wildcat Point-LP (Mobile PCH)
- 8 Series - Lynx Point (Desktop/Mobile PCH)
- 7 Series - Panther Point (Desktop/Mobile PCH)
- 6 Series - Cougar Point (Desktop/Mobile PCH)
- C620 / C621A - Lewisburg / Emmitsburg (Server Chipset)

### OTHER / LEGACY
- 10.0.x Package

---

## Chipset INF Files List

### CLIENT - Core

#### MeteorLake SoC
**Generation:** Core Ultra 100 - Meteor Lake - Tile-based Mobile SoC - Mobile

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| MeteorLakeSystem.inf, MeteorLakeSystemNorthpeak.inf | 10.1.20404.8794 | 10.1.47.12 | 07/12/2025* | 7E22, 7E23, 7E24, 7E71, 7E7F |

#### MeteorLake PCH-N
**Generation:** Core Ultra 100 - Meteor Lake - Mobile PCH (Low Power) - Mobile PCH

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| MeteorLakeSystem.inf, MeteorLakeSystemNorthpeak.inf | 10.1.20404.8794 | 10.1.47.12 | 07/12/2025* | AE22, AE23, AE24 |

#### MeteorLake PCH-H
**Generation:** Core Ultra 100 - Meteor Lake - Mobile PCH (High Performance) - Mobile PCH

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| MeteorLakePCH-HSystem.inf | 10.1.19913.8607 | 10.1.55.3 | 09/07/2024* | 7E48, 7E49 |

#### MeteorLake PCH-S
**Generation:** Core Ultra 100 - Meteor Lake - Desktop PCH - Desktop PCH

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| MeteorLakePCH-SSystem.inf | 10.1.20404.8794 | 10.1.51.10 | 07/12/2025* | 7F00, 7F01, 7F02, 7F03, 7F04, 7F05, 7F06, 7F07, 7F08, 7F09, 7F0A, 7F0B, 7F0C, 7F0D, 7F0E, 7F0F, 7F10, 7F11, 7F12, 7F13, 7F14, 7F15, 7F16, 7F17, 7F18, 7F19, 7F1A, 7F1B, 7F1C, 7F1D, 7F1E, 7F1F, 7F20, 7F21, 7F23, 7F24, 7F2F, 7F58, 7F59, 7F69 |

#### RocketLake
**Generation:** 11th Gen Core - Rocket Lake - Desktop - Desktop

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| RocketLakeSystem.inf | 10.1.20404.8794 | 10.1.41.5 | 07/12/2025* | 4C01, 4C03, 4C05, 4C07, 4C09, 4C11, 4C19, 4C23, 4C33, 4C43, 4C53, 4C63 |

#### KabyLake-H
**Generation:** 7th Gen Core - Kaby Lake - High Performance Mobile - Mobile

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| KabyLake-HSystem.inf, KabyLake-HSystemcAVS.inf, KabyLake-HSystemISH.inf | 10.1.1.37 | 10.1.1.36 | 01/10/2016* | A2B0, A2B5, A2E4, A2E5 |

#### Broadwell
**Generation:** 5th Gen Core - Broadwell - Desktop/Mobile - Desktop/Mobile

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| BroadwellSystem.inf | 10.1.18981.6008 | 10.1.3.2 | 15/06/2021* | 1600, 1601, 1604, 1605, 1608, 1609 |

#### Haswell
**Generation:** 4th Gen Core - Haswell - Desktop/Mobile - Desktop/Mobile

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| HaswellSystem.inf | 10.1.18981.6008 | 10.1.3.2 | 15/06/2021* | 0C00, 0C01, 0C04, 0C05, 0C08, 0C09 |

#### IvyBridge
**Generation:** 3rd Gen Core - Ivy Bridge - Desktop/Mobile - Desktop/Mobile

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| IvyBridgeSystem.inf | 10.1.18981.6008 | 10.1.3.2 | 15/06/2021* | 0150, 0151, 0154, 0155, 0158, 0159, 015C, 015D |

#### SandyBridge
**Generation:** 2nd Gen Core - Sandy Bridge - Desktop/Mobile - Desktop/Mobile

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| SandyBridgeSystem.inf | 10.1.18981.6008 | 10.1.3.2 | 15/06/2021* | 0100, 0101, 0104, 0105, 0108, 0109, 010D |

#### LakeField
**Generation:** Core (Hybrid) - Lakefield - Mobile SoC - Desktop/Mobile

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| LakeFieldSystem.inf, LakeFieldSystemLPSS.inf, LakeFieldSystemNorthpeak.inf | 10.1.20266.8668 | 10.1.28.2 | 27/06/2025* | 9880, 9881, 9882, 9883, 9884, 9885, 9886, 9887, 9888, 9889, 988A, 988B, 988C, 988D, 988E, 988F, 9890, 9891, 9892, 9893, 9894, 9895, 9896, 9897, 9898, 9899, 989A, 989B, 989C, 989D, 989E, 989F, 98A0, 98A1, 98A4, 98A6, 98A8, 98A9, 98AA, 98AB, 98B8, 98B9, 98BA, 98BB, 98BC, 98C5, 98C6, 98C7, 98E8, 98E9, 98EA, 98EB, 98EF, 98FB |

#### Skylake
**Generation:** 6th Gen Core - Skylake - Desktop / Mobile - Desktop/Mobile

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| SkylakeSystem.inf, SkylakeSystemGMM.inf, SkylakeSystemThermal.inf | 10.1.20404.8794 | 10.1.7.4 | 07/12/2025* | 1900, 1901, 1903, 1905, 1909, 190F, 1910, 1911, 191F |

#### Crystalwell
**Generation:** 4th Gen Core (eDRAM) - Crystal Well - High-End Mobile/Desktop - Desktop/Mobile

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| CrystalwellSystem.inf | 10.1.18981.6008 | 10.1.3.2 | 15/06/2021* | 0D00, 0D01, 0D05, 0D09 |

#### KabyLake
**Generation:** 7th Gen Core - Kaby Lake - Desktop/Mobile - Desktop/Mobile

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| KabylakeSystem.inf, KabylakeSystemGMM.inf | 10.1.20404.8794 | 10.1.10.5 | 07/12/2025* | 5900, 5901, 5904, 5905, 5909, 590C, 590D, 590F, 5910, 5911, 5914, 5918, 591F |


### WORKSTATION / HEDT

#### HaswellE/BroadwellE CPU Root
**Generation:** X99 - Haswell-E / Broadwell-E (HEDT) - Enthusiast

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| HaswellESystem.inf | 10.1.18981.6008 | 10.1.3.2 | 15/06/2021* | 2F00, 2F01, 2F02, 2F03, 2F04, 2F05, 2F06, 2F07, 2F08, 2F09, 2F0A, 2F0B, 2F10, 2F11, 2F12, 2F13, 2F14, 2F15, 2F16, 2F17, 2F18, 2F19, 2F1A, 2F1B, 2F1C, 2F1D, 2F1E, 2F1F, 2F20, 2F21, 2F22, 2F23, 2F24, 2F25, 2F26, 2F27, 2F28, 2F29, 2F2A, 2F2C, 2F2E, 2F2F, 2F30, 2F32, 2F33, 2F34, 2F36, 2F37, 2F38, 2F39, 2F3A, 2F3E, 2F3F, 2F40, 2F41, 2F43, 2F45, 2F46, 2F47, 2F60, 2F68, 2F6A, 2F6B, 2F6C, 2F6D, 2F6E, 2F6F, 2F70, 2F71, 2F76, 2F78, 2F79, 2F7D, 2F7E, 2F80, 2F81, 2F83, 2F85, 2F86, 2F87, 2F88, 2F8A, 2F90, 2F93, 2F95, 2F96, 2F98, 2F99, 2F9A, 2FA0, 2FA8, 2FAA, 2FAB, 2FAC, 2FAD, 2FAE, 2FAF, 2FB0, 2FB1, 2FB2, 2FB3, 2FB4, 2FB5, 2FB6, 2FB7, 2FB8, 2FB9, 2FBA, 2FBB, 2FBC, 2FBD, 2FBE, 2FBF, 2FC0, 2FC1, 2FC2, 2FC3, 2FC4, 2FC5, 2FD0, 2FD1, 2FD2, 2FD3, 2FD4, 2FD5, 2FD6, 2FD7, 2FE0, 2FE1, 2FE2, 2FE3, 2FE4, 2FE5, 2FE6, 2FE7, 2FE8, 2FE9, 2FEA, 2FEB, 2FEC, 2FED, 2FEE, 2FEF, 2FF0, 2FF1, 2FF2, 2FF3, 2FF4, 2FF5, 2FF6, 2FF7, 2FF8, 2FF9, 2FFA, 2FFB, 2FFC, 2FFD, 2FFE |

#### IvyTown CPU Root
**Generation:** X79 - Ivy Bridge-E (Enthusiast) - Enthusiast

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| PatsburgSystem.inf, PatsburgUSB.inf | 10.1.18981.6008 | 10.1.3.2 | 15/06/2021* | 1D3E, 1D3F, 1D40, 1D41 |


### XEON / SERVER

#### GraniteRapids
**Generation:** Xeon 6th Gen - Granite Rapids - Server

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| GraniteRapidsSystem.inf | 10.1.20404.8794 | 10.1.52.14 | 07/12/2025* | 2714, 3256, 5794, 5796, 57C2 |

#### SapphireRapids
**Generation:** Xeon Scalable 4th Gen - Sapphire Rapids - Server

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| SapphireRapidsSystem.inf | 10.1.20404.8794 | 10.1.39.10 | 07/12/2025* | 0998, 0B23, 0B25, 0CFE, 2710, 3240, 3241, 3242, 3245, 3246, 3247, 324A, 324C, 324D, 3250, 3251, 3252, 3255, 3258, 3259, 325A, 325B, 325C, 325D, 325E, 325F |

#### Broadwell-DE
**Generation:** Xeon D-1500 - Broadwell-DE - Server

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| Broadwell-DESystem.inf | 10.1.18981.6008 | 10.1.3.2 | 15/06/2021* | 0C50, 0C51, 0C52, 0C53, 6F00, 6F01, 6F02, 6F03, 6F04, 6F05, 6F06, 6F07, 6F08, 6F09, 6F0A, 6F0B, 6F0D, 6F0E, 6F10, 6F11, 6F12, 6F13, 6F14, 6F15, 6F16, 6F17, 6F18, 6F19, 6F1A, 6F1B, 6F1C, 6F1D, 6F1E, 6F1F, 6F20, 6F21, 6F22, 6F23, 6F24, 6F25, 6F26, 6F27, 6F28, 6F29, 6F2A, 6F2C, 6F30, 6F32, 6F33, 6F34, 6F36, 6F37, 6F38, 6F39, 6F3A, 6F3E, 6F3F, 6F40, 6F41, 6F43, 6F45, 6F46, 6F47, 6F50, 6F51, 6F52, 6F53, 6F60, 6F68, 6F6A, 6F6B, 6F6C, 6F6D, 6F6E, 6F6F, 6F70, 6F71, 6F76, 6F78, 6F79, 6F7D, 6F7E, 6F80, 6F81, 6F83, 6F85, 6F86, 6F87, 6F88, 6F8A, 6F90, 6F93, 6F95, 6F96, 6F98, 6F99, 6F9A, 6F9C, 6FA0, 6FA8, 6FAA, 6FAB, 6FAC, 6FAD, 6FAE, 6FAF, 6FB0, 6FB1, 6FB2, 6FB3, 6FB4, 6FB5, 6FB6, 6FB7, 6FB8, 6FB9, 6FBA, 6FBB, 6FBC, 6FBD, 6FBE, 6FBF, 6FC0, 6FC1, 6FC2, 6FC3, 6FC4, 6FC5, 6FC6, 6FC7, 6FC8, 6FC9, 6FCA, 6FCB, 6FCC, 6FCD, 6FCE, 6FCF, 6FD0, 6FD1, 6FD2, 6FD3, 6FD4, 6FD5, 6FD6, 6FD7, 6FE0, 6FE1, 6FE2, 6FE3, 6FE4, 6FE5, 6FE6, 6FE7, 6FE8, 6FE9, 6FEA, 6FEB, 6FEC, 6FED, 6FEE, 6FEF, 6FF0, 6FF1, 6FF2, 6FF3, 6FF4, 6FF5, 6FF6, 6FF7, 6FF8, 6FF9, 6FFA, 6FFB, 6FFC, 6FFD, 6FFE |

#### IvyTown
**Generation:** Xeon E7 v2 - IvyTown - Server

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| IvyTownSystem.inf | 10.1.18981.6008 | 10.1.3.2 | 15/06/2021* | 0E00, 0E01, 0E02, 0E03, 0E04, 0E05, 0E06, 0E07, 0E08, 0E09, 0E0A, 0E0B, 0E10, 0E13, 0E17, 0E18, 0E1C, 0E1D, 0E1E, 0E1F, 0E20, 0E21, 0E22, 0E23, 0E24, 0E25, 0E26, 0E27, 0E28, 0E29, 0E2A, 0E2C, 0E2E, 0E2F, 0E30, 0E32, 0E33, 0E34, 0E36, 0E37, 0E38, 0E3A, 0E3E, 0E3F, 0E40, 0E41, 0E43, 0E44, 0E45, 0E47, 0E60, 0E68, 0E6A, 0E6B, 0E6C, 0E6D, 0E71, 0E74, 0E75, 0E77, 0E79, 0E7D, 0E7F, 0E80, 0E81, 0E83, 0E84, 0E85, 0E87, 0E90, 0E93, 0E94, 0E95, 0EA0, 0EA8, 0EAA, 0EAB, 0EAC, 0EAD, 0EAE, 0EAF, 0EB0, 0EB1, 0EB2, 0EB3, 0EB4, 0EB5, 0EB6, 0EB7, 0EBC, 0EBE, 0EBF, 0EC0, 0EC1, 0EC2, 0EC3, 0EC4, 0EC8, 0EC9, 0ECA, 0ED8, 0ED9, 0EDC, 0EDD, 0EDE, 0EDF, 0EE0, 0EE1, 0EE2, 0EE3, 0EE4, 0EE5, 0EE6, 0EE7, 0EE8, 0EE9, 0EEA, 0EEB, 0EEC, 0EED, 0EEE, 0EF0, 0EF1, 0EF2, 0EF3, 0EF4, 0EF5, 0EF6, 0EF7, 0EF8, 0EF9, 0EFA, 0EFB, 0EFC, 0EFD |

#### Jaketown
**Generation:** Xeon E5 - Jaketown - Server

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| JaketownSystem.inf | 10.1.18981.6008 | 10.1.3.2 | 15/06/2021* | 3C00, 3C01, 3C02, 3C03, 3C04, 3C05, 3C06, 3C07, 3C08, 3C09, 3C0A, 3C0B, 3C0D, 3C0E, 3C0F, 3C20, 3C21, 3C22, 3C23, 3C24, 3C25, 3C26, 3C27, 3C28, 3C2A, 3C2C, 3C2E, 3C2F, 3C40, 3C41, 3C42, 3C43, 3C44, 3C45, 3C46, 3C71, 3C80, 3C83, 3C84, 3C86, 3C90, 3C93, 3C94, 3C96, 3CA0, 3CA8, 3CAA, 3CAB, 3CAC, 3CAD, 3CAE, 3CB0, 3CB1, 3CB2, 3CB3, 3CB4, 3CB5, 3CB6, 3CB7, 3CB8, 3CC0, 3CC1, 3CC2, 3CD0, 3CE0, 3CE3, 3CE4, 3CE6, 3CE8, 3CE9, 3CEA, 3CEB, 3CEC, 3CED, 3CEE, 3CEF, 3CF4, 3CF5, 3CF6 |

#### KnightsLanding
**Generation:** Xeon Phi - Knights Landing - HPC

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| KnightsLandingSystem.inf | 10.1.18981.6008 | 10.1.3.2 | 15/06/2021* | 7801, 7808, 7809, 780A, 780B, 780C, 780D, 7810, 7812, 7813, 7814, 7816, 7817, 781A, 781B, 781C, 781F, 7820, 7821, 7822, 7823, 7824, 7825, 7826, 782A, 782B, 782C, 782D, 782E, 782F, 7830, 7831, 7832, 7833, 7834, 7835, 7836, 7837, 7838, 7839, 7840, 7841, 7842, 7843, 7844, 7845, 7846, 7847, 7848, 7849 |

#### ColetoCreek
**Generation:** Communications - Coleto Creek - Networking

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| ColetoCreekSystem.inf | 10.1.18981.6008 | 10.1.3.2 | 15/06/2021* | 23B1, 23E0 |


### ATOM / LOW POWER / EMBEDDED

#### LunarLake
**Generation:** Core Ultra 200V - Lunar Lake - Mobile

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| LunarLakeSystem.inf | 10.1.20404.8794 | 10.1.48.18 | 07/12/2025* | A822, A823, A848, A862, A863, A871 |

#### JasperLake
**Generation:** Atom - Jasper Lake - Embedded/IoT

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| JasperLake+System.inf, JasperLake+SystemNorthpeak.inf | 10.1.20404.8794 | 10.1.29.4 | 07/12/2025* | 4E00, 4E03, 4E10, 4E12, 4E14, 4E19, 4E20, 4E22, 4E24, 4E26, 4E28, 4E29, 4E30, 4E40, 4E41, 4E50, 4E51, 4E60, 4E70, 4E71 |

#### ElkhartLake
**Generation:** Atom - Elkhart Lake - Embedded/IoT

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| ElkhartLakeSystem.inf, ElkhartLakeSystemGMM.inf, ElkhartLakeSystemLPSS.inf | 10.1.20404.8794 | 10.1.25.6 | 07/12/2025* | 4511, 4B00, 4B01, 4B20, 4B21, 4B23, 4B24, 4B28, 4B29, 4B2A, 4B2B, 4B38, 4B39, 4B3A, 4B3B, 4B3C, 4B3D, 4B3E, 4B4A, 4B4B, 4B4C, 4B4D, 4B68, 4B69, 4B78, 4B79, 4B7A, 4B7B, 4B7F, 4B8F, 4B91 |

#### GeminiLake
**Generation:** Atom - Gemini Lake - Embedded/IoT

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| GeminilakeSystem.inf, GeminilakeSystemGMM.inf, GeminilakeSystemLPSS.inf, GeminilakeSystemNorthpeak.inf | 10.1.20404.8794 | 10.1.13.4 | 07/12/2025* | 318E, 3190, 3192, 31AC, 31AE, 31B0, 31B2, 31B4, 31B6, 31B8, 31BA, 31BC, 31BE, 31C0, 31C2, 31C4, 31C6, 31D4, 31D6, 31D7, 31D8, 31D9, 31DA, 31DB, 31E8, 31EE, 31F0 |

#### ApolloLake
**Generation:** Atom - Apollo Lake - Embedded/IoT

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| ApolloLakeSDHost.inf, ApolloLakeSystem.inf | 10.1.20404.8794 | 10.1.17.4 | 07/12/2025* | 5ACA, 5ACC, 5AD0, 5AD4, 5AD6, 5AD7, 5AD8, 5AD9, 5ADA, 5ADB, 5AE8, 5AF0 |

#### Baytrail-I
**Generation:** Atom - Bay Trail - Embedded/IoT

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| Baytrail-ISystem.inf | 10.1.18981.6008 | 10.1.3.2 | 15/06/2021* | 0F08, 0F09, 0F18 |

#### Braswell
**Generation:** Atom - Braswell - Embedded/IoT

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| BraswellSystem.inf | 10.1.18981.6008 | 10.1.3.2 | 15/06/2021* | 2292 |

#### Denverton
**Generation:** Atom Server - Denverton - Embedded/Networking

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| DenvertonPorts.inf, DenvertonSystem.inf | 10.1.19928.8615 | 10.1.19.2 | 24/07/2024* | 1980, 1981, 1982, 1983, 1984, 1985, 1986, 1987, 1988, 1989, 198A, 198B, 198C, 198D, 198E, 198F, 1990, 1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999, 199A, 199B, 199C, 199D, 199E, 199F, 19A2, 19A4, 19A5, 19A6, 19A7, 19A8, 19A9, 19AA, 19AB, 19AC, 19D1, 19D2, 19D8, 19DB, 19DC, 19DE, 19DF, 19E0, 19E1, 19E2 |

#### Avoton
**Generation:** Atom Server - Avoton - Embedded

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| AvotonSystem.inf, AvotonUSB.inf | 10.1.18981.6008 | 10.1.3.2 | 15/06/2021* | 1F00, 1F01, 1F02, 1F03, 1F04, 1F05, 1F06, 1F07, 1F08, 1F09, 1F0A, 1F0B, 1F0C, 1F0D, 1F0E, 1F0F, 1F10, 1F11, 1F12, 1F13, 1F14, 1F15, 1F16, 1F18, 1F19, 1F2C, 1F38, 1F39, 1F3A, 1F3B, 1F3C, 1F3D |

#### ValleyView2
**Generation:** Atom - Valleyview 2 - Embedded/IoT

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| ValleyView2System.inf, ValleyView2USB.inf | 10.1.18981.6008 | 10.1.3.2 | 15/06/2021* | 0F00, 0F12, 0F1C, 0F34, 0F48, 0F4A, 0F4C, 0F4E |

#### CedarFork
**Generation:** Embedded - Cedar Fork - IoT/Industrial

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| CedarForkPorts.inf, CedarForkSystem.inf | 10.1.19928.8615 | 10.1.21.10 | 24/07/2024* | 18A0, 18A2, 18A4, 18A5, 18A6, 18A7, 18A8, 18A9, 18AA, 18AB, 18AC, 18AD, 18AE, 18AF, 18D3, 18D4, 18D6, 18D8, 18D9, 18DC, 18DD, 18DE, 18DF, 18E0, 18E1, 18EC, 18EE |


### PCH Family

#### LynxPoint
**Generation:** 8 Series - Lynx Point (Desktop/Mobile PCH) - PCH

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| LynxPointSystem.inf | 10.1.18981.6008 | 10.1.3.2 | 15/06/2021* | 8C10, 8C11, 8C12, 8C13, 8C14, 8C15, 8C16, 8C17, 8C18, 8C19, 8C1A, 8C1B, 8C1C, 8C1D, 8C1E, 8C1F, 8C22, 8C23, 8C24, 8C40, 8C41, 8C42, 8C44, 8C46, 8C49, 8C4A, 8C4B, 8C4C, 8C4E, 8C4F, 8C50, 8C52, 8C54, 8C56, 8C58, 8C5C |

#### PantherPoint
**Generation:** 7 Series - Panther Point (Desktop/Mobile PCH) - PCH

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| PantherPointSystem.inf | 10.1.18981.6008 | 10.1.3.2 | 15/06/2021* | 1E10, 1E12, 1E14, 1E16, 1E18, 1E1A, 1E1C, 1E1E, 1E22, 1E24, 1E25, 1E31, 1E41, 1E42, 1E43, 1E44, 1E46, 1E47, 1E48, 1E49, 1E4A, 1E53, 1E55, 1E56, 1E57, 1E58, 1E59, 1E5B, 1E5D, 1E5E, 1E5F |

#### CougarPoint
**Generation:** 6 Series - Cougar Point (Desktop/Mobile PCH) - PCH

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| CougarPointSystem.inf, CougarPointUSB.inf | 10.1.18981.6008 | 10.1.3.2 | 15/06/2021* | 1C10, 1C12, 1C14, 1C16, 1C18, 1C1A, 1C1C, 1C1E, 1C22, 1C24, 1C25, 1C26, 1C2D, 1C40, 1C41, 1C42, 1C43, 1C44, 1C46, 1C47, 1C49, 1C4A, 1C4B, 1C4C, 1C4D, 1C4E, 1C4F, 1C50, 1C52, 1C54, 1C56, 1C58, 1C59, 1C5A, 1C5C |

#### RaptorLakePCH-S
**Generation:** 700 Series - Raptor Lake PCH-S - Desktop PCH

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| RaptorLakePCH-SSystem.inf | 10.1.20404.8794 | 10.1.46.5 | 07/12/2025* | 7A00, 7A01, 7A02, 7A03, 7A04, 7A05, 7A06, 7A07, 7A08, 7A09, 7A0A, 7A0B, 7A0C, 7A0D, 7A0E, 7A0F, 7A10, 7A11, 7A12, 7A13, 7A14, 7A15, 7A16, 7A17, 7A18, 7A19, 7A1A, 7A1B, 7A1C, 7A1D, 7A1E, 7A1F, 7A20, 7A21, 7A23, 7A24, 7A26, 7A27, 7A2F, 7A30, 7A31, 7A32, 7A33, 7A34, 7A35, 7A36, 7A37, 7A38, 7A39, 7A3A, 7A3B, 7A3C, 7A3D, 7A3E, 7A3F, 7A40, 7A41, 7A42, 7A43, 7A44, 7A45, 7A46, 7A47, 7A48, 7A49, 7A4A, 7A4B |

#### AlderLakePCH-S
**Generation:** 600 Series - Alder Lake PCH-S - Desktop PCH

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| AlderLakePCH-SSystem.inf, AlderLakePCH-SSystemLPSS.inf, AlderLakePCH-SSystemNorthpeak.inf | 10.1.20404.8794 | 10.1.37.5 | 07/12/2025* | 7A80, 7A81, 7A82, 7A83, 7A84, 7A85, 7A86, 7A87, 7A88, 7A89, 7A8A, 7A8B, 7A8C, 7A8D, 7A8E, 7A8F, 7A90, 7A91, 7A92, 7A93, 7A94, 7A95, 7A96, 7A97, 7A98, 7A99, 7A9A, 7A9B, 7A9C, 7A9D, 7A9E, 7A9F, 7AA0, 7AA1, 7AA3, 7AA4, 7AA6, 7AA7, 7AA8, 7AA9, 7AAA, 7AAB, 7AAF, 7AB0, 7AB1, 7AB2, 7AB3, 7AB4, 7AB5, 7AB6, 7AB7, 7AB8, 7AB9, 7ABA, 7ABB, 7ABC, 7ABD, 7ABE, 7ABF, 7AC0, 7AC1, 7AC2, 7AC3, 7AC4, 7AC5, 7AC6, 7AC7, 7AC8, 7AC9, 7ACA, 7ACB, 7ACC, 7ACD, 7ACE, 7ACF, 7ADA, 7ADB, 7ADC, 7ADD, 7ADE, 7ADF, 7AEE, 7AEF, 7AF9, 7AFA, 7AFB, 7AFC, 7AFD, 7AFE |

#### AlderLakePCH-P
**Generation:** 600 Series - Alder Lake PCH-P (Mobile Performance) - Mobile PCH

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| AlderLakePCH-PSystem.inf, AlderLakePCH-PSystemLPSS.inf, AlderLakePCH-PSystemNorthpeak.inf | 10.1.20404.8794 | 10.1.36.7 | 07/12/2025* | 5180, 5181, 5182, 5183, 5184, 5185, 5186, 5187, 5188, 5189, 518A, 518B, 518C, 518D, 518E, 518F, 5190, 5191, 5192, 5193, 5194, 5195, 5196, 5197, 5198, 5199, 519A, 519B, 519C, 519D, 519E, 519F, 51A0, 51A1, 51A3, 51A4, 51A6, 51AF, 51B0, 51B1, 51B2, 51B3, 51B4, 51B5, 51B6, 51B7, 51B8, 51B9, 51BA, 51BB, 51BC, 51BD, 51BE, 51BF, 51EF, 51FB |

#### AlderLakePCH-N
**Generation:** 600 Series - Alder Lake PCH-N (Mobile Low Power) - Mobile PCH

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| AlderLakePCH-NSystem.inf, AlderLakePCH-NSystemNorthpeak.inf | 10.1.20404.8794 | 10.1.50.8 | 07/12/2025* | 5480, 5481, 5482, 5483, 5484, 5485, 5486, 5487, 5488, 5489, 548A, 548B, 548C, 548D, 548E, 548F, 5490, 5491, 5492, 5493, 5494, 5495, 5496, 5497, 5498, 5499, 549A, 549B, 549C, 549D, 549E, 549F, 54A0, 54A1, 54A3, 54A4, 54A6, 54AF, 54B0, 54B1, 54B2, 54B3, 54B4, 54B5, 54B6, 54B7, 54B8, 54B9, 54BA, 54BB, 54BC, 54BD, 54BE, 54BF, 54EF |

#### TigerLakePCH-H
**Generation:** 500 Series - Tiger Lake PCH-H (Mobile High Performance) - Mobile PCH

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| TigerLakePCH-HSystem.inf, TigerLakePCH-HSystemISH.inf, TigerLakePCH-HSystemLPSS.inf, TigerLakePCH-HSystemNorthpeak.inf, TigerLakePCH-HSystemThermal.inf | 10.1.20404.8794 | 10.1.34.13 | 07/12/2025* | 4380, 4381, 4382, 4383, 4384, 4385, 4386, 4387, 4388, 4389, 438A, 438B, 438C, 438D, 438E, 438F, 4390, 4391, 4392, 4393, 4394, 4395, 4396, 4397, 4398, 4399, 439A, 439B, 439C, 439D, 439E, 439F, 43A0, 43A1, 43A2, 43A3, 43A4, 43A6, 43AF, 43B0, 43B1, 43B2, 43B3, 43B4, 43B5, 43B6, 43B7, 43B8, 43B9, 43BA, 43BB, 43BC, 43BD, 43BE, 43BF, 43C0, 43C1, 43C2, 43C3, 43C4, 43C5, 43C6, 43C7, 43DB, 43DC, 43DD, 43E6, 43E7, 43EF, 43F9, 43FC, 43FE |

#### TigerLakePCH-LP
**Generation:** 500 Series - Tiger Lake PCH-U (Mobile) - Mobile PCH

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| TigerlakePCH-LPSystem.inf, TigerlakePCH-LPSystemLPSS.inf, TigerlakePCH-LPUSBFunctionController.inf | 10.1.20404.8794 | 10.1.24.7 | 07/12/2025* | A080, A081, A082, A083, A084, A085, A086, A087, A088, A089, A08A, A08B, A08C, A08D, A08E, A08F, A090, A091, A092, A093, A094, A095, A096, A097, A098, A099, A09A, A09B, A09C, A09D, A09E, A09F, A0A0, A0A1, A0A3, A0A4, A0A6, A0A8, A0A9, A0AC, A0AF, A0B0, A0B1, A0B2, A0B3, A0B4, A0B5, A0B6, A0B7, A0B8, A0B9, A0BA, A0BB, A0BC, A0BD, A0BE, A0BF, A0C7, A0DA, A0DB, A0DC, A0DD, A0EC, A0EE, A0FD |

#### CometLakePCH-H
**Generation:** 400 Series - Comet Lake PCH-H (Mobile High Performance) - Mobile PCH

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| CometLakePCH-HSystem.inf, CometLakePCH-HSystemLPSS.inf, CometLakePCH-HSystemThermal.inf | 10.1.20404.8794 | 10.1.31.2 | 07/12/2025* | 0680, 0681, 0682, 0683, 0684, 0685, 0686, 0687, 0688, 0689, 068A, 068B, 068C, 068D, 068E, 068F, 0690, 0691, 0692, 0693, 0694, 0695, 0696, 0697, 0698, 0699, 069A, 069B, 069C, 069D, 069E, 069F, 06A0, 06A1, 06A3, 06A4, 06A6, 06A8, 06A9, 06AA, 06AB, 06AC, 06AD, 06AE, 06AF, 06B0, 06B1, 06B2, 06B3, 06B4, 06B5, 06B6, 06B7, 06B8, 06B9, 06BA, 06BB, 06BC, 06BD, 06BE, 06BF, 06C0, 06C1, 06C2, 06C3, 06C7, 06E8, 06E9, 06EA, 06EB, 06EF, 06F9, 06FB |

#### CometLakePCH-LP
**Generation:** 400 Series - Comet Lake PCH-U (Mobile) - Mobile PCH

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| CometLakePCH-LPSystem.inf, CometLakePCH-LPSystemNorthpeak.inf, CometLakePCH-LPSystemThermal.inf | 10.1.20404.8794 | 10.1.27.4 | 07/12/2025* | 0280, 0281, 0282, 0283, 0284, 0285, 0286, 0287, 0288, 0289, 028A, 028B, 028C, 028D, 028E, 028F, 0290, 0291, 0292, 0293, 0294, 0295, 0296, 0297, 0298, 0299, 029A, 029B, 029C, 029D, 029E, 029F, 02A0, 02A1, 02A3, 02A4, 02A6, 02A8, 02A9, 02AA, 02AB, 02B0, 02B1, 02B2, 02B3, 02B4, 02B5, 02B6, 02B7, 02B8, 02B9, 02BA, 02BB, 02BC, 02BD, 02BE, 02BF, 02C5, 02C6, 02C7, 02E8, 02E9, 02EA, 02EB, 02EF, 02F9, 02FB |

#### CometLakePCH-V
**Generation:** 400 Series - Comet Lake PCH-V (Workstation) - Workstation PCH

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| CometLakePCH-VSystem.inf, CometLakePCH-VSystemLPSS.inf, CometLakePCH-VSystemNorthpeak.inf, CometLakePCH-VSystemThermal.inf | 10.1.20404.8794 | 10.1.33.5 | 07/12/2025* | A390, A391, A392, A393, A394, A395, A396, A397, A398, A399, A39A, A39B, A39C, A39D, A39E, A39F, A3A0, A3A1, A3A3, A3A4, A3A6, A3A7, A3A8, A3A9, A3AA, A3B1, A3B3, A3C0, A3C1, A3C2, A3C3, A3C4, A3C5, A3C6, A3C7, A3C8, A3C9, A3CA, A3CB, A3CC, A3CD, A3CE, A3CF, A3D0, A3D1, A3D2, A3D3, A3D4, A3D5, A3D6, A3D7, A3D8, A3D9, A3DA, A3DB, A3DC, A3DD, A3DE, A3DF, A3E0, A3E1, A3E2, A3E3, A3E6, A3E7, A3E8, A3E9, A3EA, A3EB, A3EC, A3ED, A3EE, A3F0 |

#### KabyLakePCH-H
**Generation:** 200 Series - Kaby Lake PCH-H (Mobile High Performance) - Mobile PCH

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| KabyLakePCH-HSystem.inf, KabyLakePCH-HSystemLPSS.inf, KabyLakePCH-HSystemNorthpeak.inf, KabyLakePCH-HSystemThermal.inf | 10.1.20404.8794 | 10.1.11.5 | 07/12/2025* | A290, A291, A292, A293, A294, A295, A296, A297, A298, A299, A29A, A29B, A29C, A29D, A29E, A29F, A2A0, A2A1, A2A3, A2A4, A2A6, A2A7, A2A8, A2A9, A2AA, A2B1, A2B3, A2C0, A2C1, A2C2, A2C3, A2C4, A2C5, A2C6, A2C7, A2C8, A2C9, A2CA, A2CB, A2CC, A2CD, A2CE, A2CF, A2D0, A2D1, A2D2, A2D3, A2D4, A2D5, A2D6, A2D7, A2D8, A2D9, A2DA, A2DB, A2DC, A2DD, A2DE, A2DF, A2E0, A2E1, A2E2, A2E3, A2E6, A2E7, A2E8, A2E9, A2EA, A2EB, A2EC, A2ED, A2EE |

#### SunrisePoint-H
**Generation:** 100 Series - Sunrise Point-H (Desktop/Mobile PCH) - PCH

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| SunrisePoint-HSystem.inf, SunrisePoint-HSystemLPSS.inf, SunrisePoint-HSystemThermal.inf | 10.1.20404.8794 | 10.1.6.3 | 07/12/2025* | A110, A111, A112, A113, A114, A115, A116, A117, A118, A119, A11A, A11B, A11C, A11D, A11E, A11F, A120, A121, A123, A124, A126, A127, A128, A129, A12A, A130, A131, A140, A141, A142, A143, A144, A145, A146, A147, A148, A149, A14A, A14B, A14C, A14D, A14E, A14F, A150, A151, A152, A153, A154, A155, A156, A157, A158, A159, A15A, A15B, A15C, A15D, A15E, A15F, A160, A161, A162, A163, A166, A167, A168, A169, A16A |

#### SunrisePoint-LP
**Generation:** 100 Series - Sunrise Point-LP (Mobile PCH) - Mobile PCH

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| SunrisePoint-LPSDHost.inf, SunrisePoint-LPSystem.inf, SunrisePoint-LPSystemLPSS.inf, SunrisePoint-LPSystemNorthpeak.inf, SunrisePoint-LPSystemThermal.inf | 10.1.20404.8794 | 10.1.5.3 | 07/12/2025* | 9D10, 9D11, 9D12, 9D13, 9D14, 9D15, 9D16, 9D17, 9D18, 9D19, 9D1A, 9D1B, 9D21, 9D23, 9D24, 9D26, 9D27, 9D28, 9D29, 9D2A, 9D2B, 9D2D, 9D31, 9D41, 9D43, 9D46, 9D48, 9D4B, 9D4E, 9D50, 9D51, 9D53, 9D56, 9D58, 9D60, 9D61, 9D62, 9D63, 9D64, 9D65, 9D66 |

#### Wellsburg PCH
**Generation:** C610/X99 - Wellsburg (Workstation Chipset) - Chipset

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| WellsburgSystem.inf, WellsburgUSB.inf | 10.1.18981.6008 | 10.1.3.2 | 15/06/2021* | 8D10, 8D11, 8D12, 8D13, 8D14, 8D15, 8D16, 8D17, 8D18, 8D19, 8D1A, 8D1B, 8D1C, 8D1D, 8D1E, 8D1F, 8D22, 8D24, 8D26, 8D2D, 8D40, 8D41, 8D42, 8D43, 8D44, 8D45, 8D46, 8D47, 8D48, 8D49, 8D4A, 8D4B, 8D4C, 8D4D, 8D4E, 8D4F, 8D50, 8D51, 8D52, 8D53, 8D54, 8D55, 8D56, 8D57, 8D58, 8D59, 8D5A, 8D5B, 8D5C, 8D5D, 8D5E, 8D5F, 8D7C, 8D7D, 8D7E, 8D7F |

#### Patsburg PCH
**Generation:** C600/X79 - Patsburg (Server/Workstation Chipset) - Chipset

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| PatsburgSystem.inf, PatsburgUSB.inf | 10.1.18981.6008 | 10.1.3.2 | 15/06/2021* | 1D10, 1D11, 1D12, 1D13, 1D14, 1D15, 1D16, 1D17, 1D18, 1D19, 1D1A, 1D1B, 1D1C, 1D1D, 1D1E, 1D1F, 1D22, 1D24, 1D25, 1D26, 1D2D, 1D70, 1D71, 1D72, 1D73, 1D74, 1D76, 1D77 |

#### Lewisburg
**Generation:** C620 - Lewisburg (Server Chipset) - Chipset

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| LewisburgSystem.inf | 10.1.19928.8615 | 10.1.9.6 | 24/07/2024* | 37C0, 37C8, A190, A191, A192, A193, A194, A195, A196, A197, A198, A199, A19A, A19B, A19C, A19D, A19E, A19F, A1A1, A1A3, A1A4, A1A6, A1B1, A1BA, A1BB, A1BC, A1BD, A1BE, A1C0, A1C1, A1C2, A1C3, A1C4, A1C5, A1C6, A1C7, A1E7, A1E8, A1E9, A1EA, A1EC, A1ED, A1F8, A1F9, A1FC, A210, A211, A212, A213, A214, A215, A216, A217, A218, A219, A21A, A21B, A21C, A21D, A21E, A21F, A221, A223, A224, A226, A231, A23A, A23B, A23C, A23D, A23E, A240, A241, A242, A243, A244, A245, A246, A247, A267, A268, A269, A26A, A26C, A26D, A278, A279, A27C |

#### Emmitsburg
**Generation:** C621A/C627A - Emmitsburg (Server Chipset) - Chipset

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| EmmitsburgSystem.inf, EmmitsburgSystemLPSS.inf | 10.1.20404.8794 | 10.1.40.6 | 07/12/2025* | 1B80, 1BAD, 1BB0, 1BB1, 1BB2, 1BB3, 1BB4, 1BB5, 1BB8, 1BB9, 1BBA, 1BBB, 1BBC, 1BBD, 1BBE, 1BBF, 1BC6, 1BC7, 1BC9, 1BCA, 1BCC, 1BCE, 1BE6, 1BFF |

#### LynxPointLP
**Generation:** 8 Series - Lynx Point-LP (Mobile PCH) - Desktop/Mobile

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| LynxPointLPSystem.inf | 10.1.18981.6008 | 10.1.3.2 | 15/06/2021* | 9C10, 9C11, 9C12, 9C13, 9C14, 9C15, 9C16, 9C17, 9C18, 9C19, 9C1A, 9C1B, 9C1C, 9C1D, 9C1E, 9C1F, 9C22, 9C23, 9C24, 9C40, 9C41, 9C42, 9C43, 9C44, 9C45, 9C46, 9C47, 9C48, 9C49, 9C4A, 9C4B, 9C4C, 9C4D, 9C4E, 9C4F, 9C50, 9C51, 9C52, 9C53, 9C54, 9C55, 9C56, 9C57, 9C58, 9C59, 9C5A, 9C5B, 9C5C, 9C5D, 9C5E, 9C5F |

#### WildcatPointLP
**Generation:** 9 Series - Wildcat Point-LP (Mobile PCH) - Desktop/Mobile

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| WildcatPointLPSystem.inf, WildcatPointLPUSB.inf | 10.1.18981.6008 | 10.1.3.2 | 15/06/2021* | 9C90, 9C92, 9C94, 9C96, 9C98, 9C9A, 9CA2, 9CA4, 9CA6, 9CB1, 9CC1, 9CC2, 9CC3, 9CC5, 9CC6, 9CC7, 9CC9 |

#### JasperLakePCH-N
**Generation:** Atom - Jasper Lake PCH-N (Mobile/Embedded PCH) - Desktop/Mobile

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| JasperLakePCH-NSystem.inf, JasperLakePCH-NSystemLPSS.inf, JasperLakePCH-NSystemNorthpeak.inf | 10.1.20404.8794 | 10.1.32.3 | 07/12/2025* | 4D80, 4D81, 4D82, 4D83, 4D84, 4D85, 4D86, 4D87, 4D88, 4D89, 4D8A, 4D8B, 4D8C, 4D8D, 4D8E, 4D8F, 4D90, 4D91, 4D92, 4D93, 4D94, 4D95, 4D96, 4D97, 4D98, 4D99, 4D9A, 4D9B, 4D9C, 4D9D, 4D9E, 4D9F, 4DA0, 4DA1, 4DA3, 4DA4, 4DA6, 4DA8, 4DA9, 4DAA, 4DAB, 4DAF, 4DB8, 4DB9, 4DBA, 4DBB, 4DBC, 4DBD, 4DBE, 4DBF, 4DC5, 4DC6, 4DE8, 4DE9, 4DEA, 4DEB, 4DEF, 4DFB |

#### LynxPoint-HRefresh
**Generation:** 8 Series Refresh - Lynx Point-H Refresh (Desktop/Mobile PCH) - Desktop/Mobile

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| Lynxpoint-HRefreshSystem.inf | 10.1.18981.6008 | 10.1.3.2 | 15/06/2021* | 8C90, 8C92, 8C94, 8C96, 8C98, 8C9A, 8C9C, 8C9E, 8CA2, 8CA4, 8CC1, 8CC2, 8CC3, 8CC4, 8CC5, 8CC6 |


### OTHER / LEGACY

#### Legacy
**Generation:** 10.0.x Package - Legacy Drivers

| INF | Package | Version | Date | HWIDs |
|--------|---------|---------|------|--------|
| Chipset_SMBus.inf, Chipset_System.inf, Chipset_Thermal.inf | 10.0.27.0 | 10.0.27 | 22/04/2015* | 0C59, 0C5A, 0C5B, 0C5C, 0C5D, 0C5E, 1D68, 2330, 2332, 24D3, 25A4, 266A, 269B, 27DA, 283E, 284F, 2930, 2932, 3A30, 3A32, 3A60, 3A62, 3B30, 9DEE, 9DF7, A2AB, A2F7, A2F9, A36E, A377 |

---

**Note on package versions:** Intel occasionally releases INF packages in two variants: consumer and server. Each variant may provide INF files for different devices. In this list, we denote the server variant with the (S) suffix.

**Date detection logic:**
- Dates without asterisk are taken directly from the INF file's DriverVer field
- Dates marked with * indicate that the original INF date was invalid (e.g., 07/18/1968) or missing, so the date was taken from the corresponding .cat file's digital signature timestamp

**Source:** [Universal Intel Chipset Device Updater](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater) / **Project by:** [Marcin Grygiel](https://www.linkedin.com/in/marcin-grygiel/) / **Last Update:** 13-02-2026
