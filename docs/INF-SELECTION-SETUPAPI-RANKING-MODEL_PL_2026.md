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

## Model wyboru INF i rankingu sterowników SetupAPI

### Terminologia

- **INF**: deklaracyjny plik sterownika
- **Pakiet sterownika**: INF + pliki binarne + katalog podpisów
- **Wybór sterownika**: proces rankingu SetupAPI

---

## Przegląd

System Windows wykorzystuje SetupAPI do wieloczynnikowego rankingu sterowników.

Numer wersji INF nie jest częścią logiki wyboru.

---

## Potwierdzone elementy rankingu SetupAPI

### 1. Signature score (najwyższy priorytet)
- WHQL / Microsoft / OEM
- określa poziom zaufania i kwalifikację

---

### 2. Scoring funkcjonalny INF (częściowo udokumentowany)

Niektóre INF mogą zawierać parametry typu FeatureScore lub podobne mechanizmy wpływające na priorytet.

Jednak:

- dokładna lokalizacja i sposób przetwarzania nie są w pełni publicznie udokumentowane
- zachowanie może zależeć od implementacji SetupAPI

Traktowane jako sygnał priorytetowy.

---

### 3. Identifier score
- HWID
- Compatible ID
- siła dopasowania (exact > compatible > generic)

---

### 4. DriverVer (tie-break)
- data DriverVer
- następnie numer wersji
- używany tylko przy remisie

---

## Wersja INF a logika systemu

Numer wersji INF:

- ma charakter metadanych
- nie wpływa na ranking SetupAPI
- nie wpływa na dopasowanie sprzętu

Jedynym elementem wersyjnym używanym w decyzji jest DriverVer (tylko tie-break).

---

## Równoważność funkcjonalna (konstrukt inżynierski)

„Równoważność funkcjonalna” jest abstrakcją inżynierską oznaczającą:

- identyczne HWID/CompatID
- identyczny wynik bindowania
- identyczny stan systemu

Nie jest to termin oficjalny Windows Driver Framework.

---

## Zachowanie systemu

### Windows Update (runtime)
- stosuje model SetupAPI
- DriverVer tylko jako tie-break

### Windows Setup (upgrade systemu)
- może zmieniać sterowniki
- stosuje polityki inbox i migracji

---

## Podsumowanie

Ranking sterowników Windows opiera się na wieloczynnikowym modelu SetupAPI:

1. Signature score
2. Identifier score (HWID/CompatID)
3. Scoring funkcjonalny INF (częściowo nieudokumentowany)
4. DriverVer (tie-break)

Numer wersji INF nie jest częścią systemu rankingu.

Część mechanizmów scoringu INF-level nie jest w pełni publicznie opisana i powinna być traktowana jako zależna od implementacji.

Autor: Marcin Grygiel aka FirstEver ([LinkedIn](https://www.linkedin.com/in/marcin-grygiel))

---

## 📘 Przydatne linki


- [Najnowsze Wersje](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/Intel_Chipset_Drivers_Latest.md)
- [Updater Tool](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater)
- [Link do oficjalnego Intel Chipset Device Software](https://www.intel.com/content/www/us/en/download/19347/chipset-inf-utility.html)
- [Link w wyszukiwarkce Intela do Chipset INF Utility](https://www.intel.com/content/www/us/en/search.html?q=Chipset%20INF%20Utility)
- [Issue Tracker](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/issues)
