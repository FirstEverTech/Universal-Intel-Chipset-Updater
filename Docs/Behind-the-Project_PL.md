# 🛠️ Universal Intel Chipset Driver Updater — Making Of [PL]
## Jak osobista obsesja przerodziła się w najpełniejszą bazę danych Intel INF, jaka kiedykolwiek powstała

Od lat oprogramowanie Intel Chipset Device Software (dawniej: Intel Chipset INF Utility) jest jednym z najbardziej mylących pakietów wydanych przez głównego producenta sprzętu.  

Nie planowałem zostać archeologiem plików INF Intela — ale im więcej grzebałem, tym dziwniejsza stawała się ta historia. Ostatecznie ta ciekawość przerodziła się w projekt na pełną skalę: automatyczny aktualizator zdolny do zlokalizowania i zainstalowania najnowszego, poprawnego pliku INF dla każdego chipsetu Intela, od Sandy Bridge (2011) po czasy współczesne.

Ten dokument to historia zza kulis o tym, jak projekt został stworzony, dlaczego istnieje i jakie techniczne koszmary musiały zostać rozwiązane po drodze.

---

## 🌀 1. Punkt wyjścia: Przypadek katastrofy X79 / C600

Mój osobisty komputer oparty jest na niemal prehistorycznym chipsecie X79 (C600) — i tak, nadal używam go na co dzień w 2025 roku, także do testów GPU, jak moja demostracja technologii [NVIDIA Smooth Motion](https://www.youtube.com/watch?v=TXstp8kN7j4).

Aktualizacja sterownika chipsetu Intela powinna być trywialna.  
Ale w przypadku X79 przerodziła się w wielodniowe śledztwo kryminalistyczne.

Publiczne pakiety Intela pokazują wersje takie jak:

| Rok  | Instalator      | Wersja INF  | Wsparcie | Uwagi                            |
| :--- | :-------------- | :---------- | :------- | :------------------------------- |
| 2011 | 9.2.3.1020      | 9.2.3.1013  | ✅ Pełne | Pierwsza wersja INF dla X79/C600 |
| 2013 | 9.4.4.1006      | 9.2.3.1032  | ✅ Pełne | Ostatnia wersja INF 9.4.xxxx     |
| 2015 | 10.0.27         | 10.0.27     | ✅ Pełne | Ostatnia wersja INF 10.0.xx      |
| 2015 | 10.1.1.45       | 10.1.1.45   | ✅ Pełne | Ostatnia wersja INF 10.1.1.xx    |
| 2017 | 10.1.2.86       | 10.1.2.86   | ✅ Pełne | Ostatnia wersja INF 10.1.2.xx    |
| 2021 | 10.1.18981.6008 | 10.1.3.2    | ✅ Pełne | Ostatnia wersja INF 10.1.xxxx    |
| 2025 | 10.1.20266.8668 | Brak        | ❌ Brak HWIDs | Brak wpisów dla 1Dxx/1Exx        |

...ale wersje instalatora nie mówią nic o tym, co faktycznie zostanie zainstalowane.

- Niektóre "nowsze" pakiety zawierają starsze pliki INF.
- Niektóre "stabilne" pakiety zawierają zmodyfikowaną przez OEM zawartość.
- Niektóre wersje istnieją w pięciu różnych wariantach, wszystkie podpisane cyfrowo przez Intela — ale o różnych zawartościach.

To był moment, w którym zdałem sobie sprawę:  
Oprogramowanie Intel Chipset Device Software nie jest pakietem sterowników. To muzeum historii zapakowane w archiwum ZIP.

---

## 📜 2. Śledzenie 14 lat historii plików INF

Aby zrozumieć, co Intel faktycznie wydał, pobrałem 90 różnych instalatorów chipsetu Intela, od wersji 10.0.13.0 do 10.1.20314.8688, w tym:

- Publiczne pobrania Intela
- Pakiety OEM (ASUS/MSI/Gigabyte/Dell/EVGA)
- Archiwa CAB Windows Update
- Legacy'owe mirror'y i zachowane serwery FTP

Po wypakowaniu wszystkich pakietów uzyskałem:

- 4832 pliki INF
- 2641 unikalnych identyfikatorów sprzętowych (Hardware IDs)
- 86783 relacji wersji

Z tego zbioru danych wygenerowałem pierwszą w historii kompletną macierz wersji INF chipsetu Intela, dostępną teraz tutaj:  
👉 [Lista najnowszych plików INF](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/Intel_Chipset_INFs_Latest.md)

Ta baza danych jest fundamentem narzędzia aktualizującego.

---

## 🔧 3. Dlaczego potrzebny był aktualizator

Oficjalny instalator Intela to w istocie:

- generyczna nakładka
- zawierająca setki plików INF
- instalująca tylko mały ich podzbiór
- i po cichu pomijająca resztę, szczególnie na starszych platformach (X79, C600, QM77, HM65, itp.)

Co gorsza:

- Wersja pakietu ≠ Wersja INF
- Nowsze pakiety mogą nie zawierać wsparcia dla starszych chipsetów
- Windows często preferuje przestarzałe, dostarczone z systemem pliki INF
- Pakiety OEM czasami zawierają nowsze wersje niż najnowszy pakiet samego Intela

Innymi słowy:  
Aby znaleźć "najnowszy sterownik chipsetu Intela", musisz przeszukać 14 lat pakietów i skrzyżować dane z tysięcy plików.

Więc to zautomatyzowałem.

<img width="977" height="460" alt="image" src="https://github.com/user-attachments/assets/68e19bd4-ab42-4fe4-9734-2566a284caa3" />

---

## 🚀 4. Universal Intel Chipset Driver Updater — Rozwiązanie

Moje narzędzie porównuje zainstalowane wersje INF z globalną bazą danych i instaluje najnowszą prawidłową wersję dla Twoich dokładnych identyfikatorów sprzętowych.

Obsługuje:

- Windows 10 & 11 (x64)
- Od Sandy Bridge → do najnowszych generacji Intela
- Wszystkie główne rodziny chipsetów (desktop, mobile, stacje robocze, serwery)

Wykorzystuje wieloetapowy proces weryfikacji:

- Wykrywanie identyfikatorów sprzętowych
- Mapowanie INF ze zbioru danych
- Bezpieczne pobieranie z podwójnych mirrorów
- Weryfikacja skrótu SHA256
- Weryfikacja podpisu cyfrowego
- Walidacja łańcucha certyfikatów
- Bezpieczna instalacja
- Opcjonalny restart systemu

Ale w nowym wydaniu, bezpieczeństwo poczyniło ogromny skok naprzód.

---

## 🛡️ 5. v10.1-2025.11.5 — Przełomowe wydanie pod względem bezpieczeństwa

Najnowsza aktualizacja jest największą ewolucją narzędzia do tej pory.  
Oto, co się zmieniło.

### 🔒 Główne Ulepszenia Bezpieczeństwa

- Automatyczny Punkt Przywracania Windows przed instalacją INF
- Pełna weryfikacja SHA256 wszystkich pobrań
- Walidacja podpisu cyfrowego (główny certyfikat Intela + łańcuch)
- Pobieranie z dwoma źródłami zapasowymi z niezależną weryfikacją
- Bezpieczna obsługa plików tymczasowych & automatyczne czyszczenie

### ⚙ Ulepszenia Techniczne

- GUID-based cache busting dla GitHub RAW
- Wielometodowa ekstrakcja ZIP (System.IO + zapasowe COM)
- Lepsza odporność na niestabilne łącze internetowe
- Czystszy postęp i komunikaty o błędach
- Bardziej szczegółowy Tryb Debug

### 🎯 Ulepszenia UX (Doświadczenia Użytkownika)

- Zero zduplikowanych wiadomości
- Jasne formatowanie skrótów "Oczekiwany vs Rzeczywisty"
- Wskaźniki postępu krok po kroku
- Wsparcie SFX EXE dla wykonania jednym kliknięciem

---

## 🔍 6. Niezależny Audyt Bezpieczeństwa (Wynik: 9.4 / 10)

Wydanie zostało ocenione poprzez zautomatyzowany audyt bezpieczeństwa oparty na AI:

### Główne Plusy

- Weryfikacja wielowarstwowa na najwyższym poziomie
- Bezpieczny powrót do poprzedniego stanu dzięki Punktowi Przywracania
- Publiczne skróty dla wszystkich zasobów
- Doskonała przejrzystość i logowanie
- Silne mechanizmy awaryjne

### Drobne Pozostałe Ryzyka

- Wymaga uprawnień administratora
- Wymagane połączenie internetowe
- Nadal nie jest aktualizatorem firmware'u (tylko INF)

**Ostateczny werdykt:**  
To najbezpieczniejsza, najbardziej stabilna i najbardziej profesjonalna wersja narzędzia do tej pory.  
Pełny audyt załączony do wglądu.

---

## 🧬 7. "Paradoks Wersji" — Wyjaśnienie chaosu INF Intela

Jednym z najbardziej zaskakujących odkryć był wewnętrzny brak spójności w pakietach Intela.

**Przykład:**

- 10.1.2.19 (2016) jest starszy
- 10.1.1.36 (2016) jest nowszy

Oba współdzielą identyczne numery wersji w różnych pakietach.  
Wersje OEM różnią się rozmiarem, liczbą plików INF i zawartością.  
CABy Windows Update często używają różnych znaczników czasu.  
Najnowszy publiczny pakiet Intela (10.1.20266.8668) nie instaluje niczego na X79.

Dlaczego?  
Ponieważ najnowsze pakiety Intela są ukierunkowane na platformę C620 (Lewisburg).  
Zawierają one tylko zalążki kompatybilności dla starszych chipsetów — żadnych faktycznych aktualizacji INF.

Dlatego właśnie ten projekt istnieje: aby przywrócić porządek w chaosie.

---

## 🧩 8. Co Intel powinien był zrobić

Nowoczesne, jasne, ukierunkowane na platformę podejście:

| Nazwa pliku                                  | Wersja | Data        |
|---------------------------------------------|--------|-------------|
| IntelChipset-Patsburg-21.4.0.exe           | 21.4.0 | 24/04/2021  |
| IntelChipset-LunarLake-25.8.1.exe          | 25.8.1 | 15/08/2025  |
| IntelChipset-GraniteRapids-24.9.0.exe      | 24.9.0 | 30/09/2024  |

Zamiast tego Intel wybrał:

- Jeden masywny pakiet na wszystko
- Nieprzewidywalne wewnętrzne wersjonowanie
- Warianty OEM z identycznymi nazwami
- Ciche działanie no-op dla platform legacy

Ten aktualizator to naprawia.

---

## 📦 9. Instrukcja użycia (EXE, BAT lub PowerShell)

### Opcja 1: SFX EXE (Zalecana)

1. Pobierz:  
   `ChipsetUpdater-10.1-2025.11.5-Win10-Win11.exe`
2. Uruchom jako Administrator
3. Postępuj zgodnie z monitami

### Opcja 2: Plik wsadowy (Batch)

1. Pobierz `Universal-Intel-Chipset-Updater.bat + .ps1`
2. Umieść w jednym folderze
3. Uruchom `.bat` jako Administrator

### Opcja 3: PowerShell

powershell -ExecutionPolicy Bypass -File Universal-Intel-Chipset-Updater.ps1

Logs:
`C:\Windows\Temp\IntelChipset\chipset_update.log`

---

## 🧠 10. Ostatnie przemyślenia: Dlaczego ten projekt istnieje

Ekosystem INF chipsetów Intela ewoluował przez prawie 25 lat — z tysiącami plików, ciągłą rotacją sprzętu i brakiem autorytatywnej, "ostatecznej" listy wersji dla starszych platform.

Więc taką stworzyłem.

Ten projekt jest próbą wniesienia:

- jasności
- spójności
- automatyzacji
- bezpieczeństwa
- i historycznej dokładności

...do części ekosystemu Windows, która była zaniedbywana przez ponad dekadę.

Jeśli odkryjesz niespójności w bazie danych, chętnie je zaktualizuję.  

Autor: Marcin Grygiel aka FirstEver ([LinkedIn](https://www.linkedin.com/in/marcin-grygiel))

---

## 📘 Przydatne linki


- [Najnowsze Wersje](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/Intel_Chipset_Drivers_Latest.md)
- [Updater Tool](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater)
- [Link do oficjalnego Intel Chipset Device Software](https://www.intel.com/content/www/us/en/download/19347/chipset-inf-utility.html)
- [Link w wyszukiwarkce Intela do Chipset INF Utility](https://www.intel.com/content/www/us/en/search.html?q=Chipset%20INF%20Utility)
- [Issue Tracker](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/issues)
