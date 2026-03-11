## Wdrażanie uniwersalnego aktualizatora układów Intel Chipset Device za pomocą MDM

Zarządzanie aktualizacjami plików INF układów Intel Chipset w całej flocie komputerów oznaczało do tej pory albo poleganie na tym, że Windows Update w końcu je dostarczy, albo ręczną obsługę każdego urządzenia. Dzięki flagom `-quiet` i `-auto` wprowadzonym w wersji v2026.03.0010, **Universal Intel Chipset Device Updater** w pełni nadaje się do cichego, bezobsługowego wdrażania za pośrednictwem dowolnej platformy MDM w przedsiębiorstwie.

Ten przewodnik opisuje wdrażanie dla **Microsoft Intune**, **Microsoft SCCM / Configuration Manager**, **VMware Workspace ONE** i **PDQ Deploy** — z użyciem aktualnego wydania w momencie pisania tego tekstu.

---

### Wymagania wstępne (dla wszystkich platform)

Przed wdrożeniem za pomocą dowolnego rozwiązania MDM, sprawdź następujące elementy na komputerach docelowych:

- **Windows 10 build 17763 (LTSC 2019) lub nowszy** — wymagany do pełnej obsługi TLS 1.2 od razu po instalacji
- **.NET Framework 4.7.2 lub nowszy** — wymagany do łączności z GitHub i weryfikacji skrótów (hashy)
- **Uprawnienia administratora** — skrypt automatycznie podnosi swoje uprawnienia, ale kontekst wdrożenia musi już działać jako SYSTEM lub lokalne konto administratora
- **Dostęp do Internetu (GitHub)** — skrypt pobiera pakiety INF i weryfikuje skróty z `raw.githubusercontent.com` i zasobów wydań GitHub; upewnij się, że nie są one blokowane przez twoje proxy lub zaporę sieciową
- **Zasady wykonywania PowerShell** — flaga `-ExecutionPolicy Bypass` w poleceniu uruchomieniowym rozwiązuje tę kwestię; nie jest wymagana żadna zmiana zasad na komputerze docelowym

**Zalecane polecenie uruchomieniowe dla wszystkich wdrożeń MDM:**
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%SystemRoot%\Temp\IntelChipset\universal-intel-chipset-updater.ps1" -quiet
```

> **Uwaga:** `-quiet` implikuje `-auto` i wycisza wszystkie dane wyjściowe konsoli. Pełny dziennik instalacji jest zawsze zapisywany w `%ProgramData%\chipset_update.log` niezależnie od trybu cichego — użyj go do weryfikacji wdrożenia.

---

### Microsoft Intune

Intune obsługuje dwie praktyczne metody wdrażania tego narzędzia: jako **aplikację Win32** (zalecane) lub za pomocą **zasad skryptów PowerShell**.

#### Metoda A: Aplikacja Win32 (zalecana)

Ta metoda zapewnia pełne reguły wykrywania, filtry przypisań i raportowanie.

**1. Przygotuj pakiet**

Pobierz najnowszy plik wykonywalny SFX ze [strony Releases](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases):
```
ChipsetUpdater-2026.03.0011-Win10-Win11.exe
```

Utwórz skrypt opakowujący `install.cmd`, który uruchomi SFX w trybie cichym — SFX rozpakowuje pliki do `%SystemRoot%\Temp\IntelChipset\` i automatycznie uruchamia plik PS1 z flagą `-quiet`:
```batch
ChipsetUpdater-2026.03.0011-Win10-Win11.exe
```

> Pakiet SFX jest wstępnie skonfigurowany do rozpakowania i uruchomienia `universal-intel-chipset-updater.ps1 -quiet` automatycznie. Dodatkowy skrypt opakowujący nie jest potrzebny, chyba że chcesz dodać niestandardowe akcje przed lub po instalacji.

**2. Spakuj jako plik .intunewin**

Użyj [narzędzia Microsoft Win32 Content Prep Tool](https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool):
```
IntuneWinAppUtil.exe -c "C:\Package" -s "ChipsetUpdater-2026.03.0011-Win10-Win11.exe" -o "C:\Output"
```

**3. Utwórz aplikację Win32 w Intune**

- Przejdź do **centrum administracyjnego Intune** → **Aplikacje** → **Windows** → **Dodaj** → **Aplikacja Windows (Win32)**
- Prześlij plik `.intunewin`
- Ustaw **Polecenie instalacji**:
  ```
  ChipsetUpdater-2026.03.0011-Win10-Win11.exe
  ```
- Ustaw **Polecenie odinstalowania** (odinstalowanie nie jest potrzebne — pliki INF są częścią systemu operacyjnego):
  ```
  cmd.exe /c echo Nie wymaga odinstalowania
  ```
- **Zachowanie podczas instalacji**: `System`
- **Zachowanie przy ponownym uruchomieniu urządzenia**: `Określ zachowanie na podstawie kodów powrotu`
  - Dodaj kod powrotu `3010` → `Miękki restart` (na wypadek, gdyby Windows oznaczył oczekujący restart po instalacji INF)

**4. Reguła wykrywania**

Użyj reguły wykrywania opartej na **Rejestrze**, aby sprawdzić, czy dziennik został zapisany (potwierdzając, że skrypt został uruchomiony):
- **Ścieżka klucza**: `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion`
- **Nazwa wartości**: *(pozostaw puste — wykrywaj tylko istnienie klucza)*

Lub użyj reguły wykrywania opartej na **Pliku** dla dziennika:
- **Ścieżka**: `C:\ProgramData`
- **Plik**: `chipset_update.log`
- **Metoda wykrywania**: Plik lub folder istnieje

**5. Przypisz i wdróż**

Przypisz do grupy urządzeń. Do testów pilotażowych użyj najpierw **Przypisane** do grupy testowej, a następnie wdróż do szerszych grup poprzez **Dostępne** lub **Wymagane**.

---

#### Metoda B: Zasady skryptów PowerShell

Prostsza, ale z mniejszą szczegółowością raportowania. Użyj tej metody do szybkich wdrożeń.

- Przejdź do **centrum administracyjnego Intune** → **Urządzenia** → **Skrypty i korekty** → **Skrypty platformy** → **Dodaj** → **Windows 10 i nowsze**
- Prześlij bezpośrednio plik `universal-intel-chipset-updater.ps1`
- Ustawienia:
  - **Uruchom ten skrypt przy użyciu poświadczeń zalogowanego użytkownika**: `Nie` (uruchom jako SYSTEM)
  - **Wymuszaj sprawdzanie podpisu skryptu**: `Nie`
  - **Uruchom skrypt w 64-bitowym hoście PowerShell**: `Tak`
- Przypisz do grupy urządzeń

> **Ograniczenie:** Skrypty PowerShell w Intune mają domyślny limit czasu. W przypadku systemów, które tworzą duże punkty przywracania lub mają wolne dyski, całkowity czas wykonania może przekroczyć 10 minut. W przypadku przekroczenia limitu czasu przełącz się na metodę A (aplikacja Win32), która ma konfigurowalny limit czasu.

---

### Microsoft SCCM / Configuration Manager

SCCM oferuje największą kontrolę nad targetowaniem, harmonogramowaniem i raportowaniem zgodności.

#### 1. Utwórz pakiet

- W **konsoli Configuration Manager** przejdź do **Biblioteka oprogramowania** → **Zarządzanie aplikacjami** → **Pakiety** → **Utwórz pakiet**
- **Nazwa**: `Universal Intel Chipset Device Updater v2026.03.0011`
- **Folder źródłowy**: Wskaż udział sieciowy zawierający plik `ChipsetUpdater-2026.03.0011-Win10-Win11.exe`
- Utwórz **Program standardowy** z:
  - **Wiersz polecenia**:
    ```
    ChipsetUpdater-2026.03.0011-Win10-Win11.exe
    ```
  - **Uruchom**: `Ukryty`
  - **Program może być uruchomiony**: `Niezależnie od tego, czy użytkownik jest zalogowany`
  - **Uruchom z uprawnieniami administracyjnymi**: ✅ zaznaczone

#### 2. Alternatywnie — wdróż bezpośrednio plik PS1

Jeśli wolisz wdrożyć skrypt bez opakowania SFX:

- Umieść `universal-intel-chipset-updater.ps1` w swoim punkcie dystrybucji
- Ustaw **Wiersz polecenia** na:
  ```
  powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "universal-intel-chipset-updater.ps1" -quiet
  ```
- **Uruchom**: `Ukryty`
- **Program może być uruchomiony**: `Niezależnie od tego, czy użytkownik jest zalogowany`

#### 3. Dystrybucja i wdrożenie

- **Rozpowszechnij zawartość** do swoich punktów dystrybucji
- **Wdróż** do kolekcji urządzeń
  - **Cel**: `Wymagane` dla obowiązkowego wdrożenia, `Dostępne` dla samoobsługi
  - **Harmonogram**: Ustaw okno konserwacji, jeśli chcesz kontrolować czas (zalecane — skrypt tworzy punkt przywracania, co może być intensywne dla operacji we/wy)
  - **Doświadczenie użytkownika** → **Zezwalaj klientom na uruchamianie oprogramowania niezależnie od przypisań**: zależy od twojej polityki
  - **Kody powrotu**: Dodaj `3010` jako **Miękki restart**, jeśli jeszcze nie istnieje

#### 4. Weryfikacja zgodności

Utwórz **element konfiguracji**, który sprawdza istnienie pliku `%ProgramData%\chipset_update.log` lub odczytuje datę ostatniej modyfikacji tego pliku, aby potwierdzić, że skrypt został uruchomiony w oczekiwanym oknie czasowym.

---

### VMware Workspace ONE (UEM)

Workspace ONE obsługuje wdrażanie za pomocą **Freestyle Orchestrator** lub klasycznego podejścia z wykorzystaniem **Skryptów** i **Czujników**.

#### Metoda A: Aplikacja wewnętrzna (SFX EXE)

- W **konsoli Workspace ONE UEM** przejdź do **Aplikacje i książki** → **Aplikacje** → **Natywne** → **Dodaj aplikację** → **Prześlij**
- Prześlij plik `ChipsetUpdater-2026.03.0011-Win10-Win11.exe`
- **Opcje wdrożenia**:
  - **Polecenie instalacji**: *(pozostaw domyślne — SFX obsługuje wszystko)*
  - **Uprawnienia administratora**: `Tak`
  - **Kontekst instalacji**: `Urządzenie`
- W sekcji **Pliki** dodaj **skrypt po instalacji**, jeśli chcesz zweryfikować dziennik:
  ```powershell
  Test-Path "$env:ProgramData\chipset_update.log"
  ```

#### Metoda B: Skrypty (PowerShell)

- Przejdź do **Zasoby** → **Skrypty** → **Dodaj** → **Windows**
- Prześlij lub wklej plik `universal-intel-chipset-updater.ps1`
- **Kontekst wykonania**: `System`
- **Architektura wykonania**: `64-bitowa`
- **Limit czasu**: Ustaw na `900` sekund (15 minut), aby uwzględnić tworzenie punktu przywracania na wolniejszych systemach
- W sekcji **Przypisanie**, wyceluj w odpowiednią grupę inteligentną

#### Czujnik do raportowania zgodności

Utwórz **Czujnik**, który raportuje, czy aktualizacja została uruchomiona pomyślnie:

```powershell
# Zwraca ostatnią linię dziennika zawierającą status zakończenia
if (Test-Path "$env:ProgramData\chipset_update.log") {
    $last = Get-Content "$env:ProgramData\chipset_update.log" | Select-Object -Last 5
    return ($last -join " ")
} else {
    return "Nie znaleziono dziennika"
}
```

- **Typ oceny**: `Ciąg znaków`
- Przypisz do tej samej grupy inteligentnej, co wdrożenie

---

### PDQ Deploy

PDQ Deploy to najszybsza opcja dla środowisk lokalnych i wdrożeń ad-hoc.

#### 1. Utwórz nowy pakiet

- Otwórz **PDQ Deploy** → **Nowy pakiet**
- **Nazwa**: `Universal Intel Chipset Device Updater v2026.03.0011`

#### 2. Dodaj krok — Instalacja (SFX)

- **Typ kroku**: `Instalacja`
- **Plik instalacyjny**: Przeglądaj do `ChipsetUpdater-2026.03.0011-Win10-Win11.exe`
- **Uruchom jako**: `Użytkownik wdrażający (PDQ)` lub `System lokalny` — obie opcje działają, ponieważ skrypt automatycznie podnosi uprawnienia
- **Kody sukcesu**: Dodaj `0`, `3010`

#### 3. Alternatywnie — krok PowerShell

Jeśli wdrażasz plik PS1 bezpośrednio (np. z udziału sieciowego):

- **Typ kroku**: `PowerShell`
- **Skrypt**:
  ```powershell
  $dest = "$env:SystemRoot\Temp\IntelChipset"
  New-Item -ItemType Directory -Path $dest -Force | Out-Null
  Copy-Item "\\twoj-udział\skrypty\universal-intel-chipset-updater.ps1" "$dest\universal-intel-chipset-updater.ps1" -Force
  & powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "$dest\universal-intel-chipset-updater.ps1" -quiet
  ```
- **Uruchom jako**: `System lokalny`
- **Limit czasu**: `900` sekund

#### 4. Zaplanuj lub wdróż na żądanie

- Użyj **Automatycznych wdrożeń**, aby zaplanować cykliczne uruchamianie (np. co miesiąc, po wtorku z łatami)
- Lub wdróż **Na żądanie** do poszczególnych maszyn lub grup z konsoli PDQ Deploy

#### 5. Zweryfikuj wyniki

Po wdrożeniu użyj **PDQ Inventory**, aby odpytać plik dziennika na wszystkich maszynach:
- **Skaner** → **Plik** → `C:\ProgramData\chipset_update.log` → sprawdź datę **Ostatniej modyfikacji**

---

### Weryfikacja pomyślnego wdrożenia (wszystkie platformy)

Niezależnie od używanej platformy MDM, podstawową metodą weryfikacji jest plik dziennika:

```
%ProgramData%\chipset_update.log
```

Pomyślne uruchomienie kończy się linią podobną do:
```
[2026-03-11 14:32:07] [INFO] Wykonanie skryptu zakończone w 4.21 minut z 0 błędami
```

Uruchomienie z problemami będzie zawierać wpisy `[ERROR]` — są one zawsze zapisywane w dzienniku nawet w trybie `-quiet`, więc dziennik jest zawsze autorytatywnym źródłem prawdy.

**Szybkie sprawdzenie PowerShell w całej flocie (uruchom ze swojej stacji roboczej administracyjnej):**
```powershell
$computers = Get-Content "C:\computers.txt"
foreach ($pc in $computers) {
    $log = "\\$pc\c$\ProgramData\chipset_update.log"
    if (Test-Path $log) {
        $last = Get-Content $log | Select-Object -Last 1
        [PSCustomObject]@{ Computer = $pc; Status = $last }
    } else {
        [PSCustomObject]@{ Computer = $pc; Status = "Nie znaleziono dziennika" }
    }
} | Format-Table -AutoSize
```

---

### Uwagi dotyczące zachowania po restarcie

Skrypt instaluje pliki INF, które modyfikują konfiguracje urządzeń na poziomie magistrali. Windows zazwyczaj nie wymusi natychmiastowego restartu, ale **restart jest wymagany**, aby w pełni zastosować zmiany. Zaplanuj swoje okna wdrożeniowe odpowiednio:

- W **Intune**: użyj kodu powrotu miękkiego restartu `3010` i skonfiguruj okno konserwacji lub zezwól użytkownikowi na odroczenie
- W **SCCM**: skonfiguruj **Doświadczenie użytkownika** wdrożenia → **Zatwierdź zmiany w terminie lub podczas okna konserwacji**
- W **Workspace ONE**: użyj zasad ponownego uruchamiania po instalacji ustawionych na `Odrocz`
- W **PDQ Deploy**: dodaj krok **Restart** po kroku instalacji lub obsłuż to poprzez swoją standardową politykę restartów dla poprawek

---

Wdrażanie aktualizacji INF układów chipsetów na dużą skalę wymagało do tej pory niestandardowego pakowania i tworzenia skryptów od podstaw. Flaga `-quiet` sprawia, że to narzędzie można łatwo zintegrować z każdym przepływem pracy MDM — trudna część (wykrywanie odpowiedniego sprzętu, dopasowywanie pakietów, weryfikacja skrótów, tworzenie punktów przywracania) jest obsługiwana automatycznie.

👉 **[Universal Intel Chipset Device Updater — GitHub](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater)**

---

Autor: Marcin Grygiel aka FirstEver ([LinkedIn](https://www.linkedin.com/in/marcin-grygiel))