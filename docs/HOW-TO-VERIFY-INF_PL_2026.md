## Jak samodzielnie zweryfikować najnowsze pliki INF

Zamiast ufać różnym programom do aktualizacji sterowników (nawet oficjalnemu narzędziu Intel Driver & Support Assistant), które często sugerują nieprawidłowe wersje lub downgrade, możesz łatwo ręcznie sprawdzić **prawdziwą najnowszą wersję INF** dla dowolnego urządzenia chipsetu Intela. Oto jak to zrobić.

---

### Krok po kroku (wybierz jedno lub więcej urządzeń chipsetu)

#### 1. Otwórz Menedżer urządzeń  
Wybierz jedną z poniższych metod:
- Naciśnij **klawisz Win + X** → **Menedżer urządzeń**
- Naciśnij **klawisz Win**, wpisz `Menedżer urządzeń` i zatwierdź Enterem
- Naciśnij **klawisz Win + R**, wpisz `devmgmt.msc` i zatwierdź Enterem

<img width="825" height="344" alt="image" src="https://github.com/user-attachments/assets/f51d40d6-565e-4129-ad69-a9826458bb7a" />

---

#### 2. Znajdź urządzenie chipsetu Intela
- Rozwiń sekcję **"Urządzenia systemowe"**.
- Poszukaj wpisu zawierającego w nazwie **"Intel"**, **"Chipset"**, **"LPC"** itp.
- **Często nazwa sama zawiera identyfikator sprzętu** – na przykład: `Intel(R) C600/X79 series chipset LPC Controller – 1D41`  
  Tutaj HWID to **`1D41`**.

<img width="781" height="350" alt="image" src="https://github.com/user-attachments/assets/66dba885-3eee-4169-8d44-87c22777da8e" />

---

#### 3. Jeśli HWID nie ma w nazwie, sprawdź właściwość Hardware Ids
- Kliknij prawym przyciskiem myszy na urządzenie → **Właściwości** → zakładka **Szczegóły**.
- W rozwijanej liście **"Właściwość"** wybierz **"Identyfikatory sprzętu"**.
- Zobaczysz coś w stylu: `PCI\VEN_8086&DEV_1D41&CC_0601`  
  Część po **`DEV_`** (tutaj **`1D41`**) to identyfikator urządzenia.

<img width="441" height="290" alt="image" src="https://github.com/user-attachments/assets/bb9d2ac3-27c0-4af8-b469-0d40f853386d" />

---

#### 4. Znajdź HWID w bazie danych, którą utrzymuję na GitHub
Otwórz w przeglądarce moją najnowszą bazę danych INF:  
👉 **[intel-chipset-infs-latest.md](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/data/intel-chipset-infs-latest.md)**

Naciśnij **Ctrl+F** i wyszukaj ten HWID (np. **`1D41`**).

<img width="891" height="194" alt="image" src="https://github.com/user-attachments/assets/3f73a395-96f3-4aca-8c0d-2eb235e1b368" />

> **Uwaga:** Jeśli Twoje urządzenie **nie jest traktowane jako element chipsetu** lub jest urządzeniem chipsetowym, którego Intel **nigdy nie dołączył do żadnego ze swoich pakietów Chipset Device Software** (tzn. plik INF pochodzi z Windows Inbox Drivers), to HWID **może nie pojawić się** w tej bazie.
  
Od razu zobaczysz:
- ✅ **Najnowszą wersję INF** dla tego urządzenia,
- ✅ Który (najnowszy) **pakiet Intel Chipset Device Software** go zawiera,
- ✅ **Podana data pochodzi ze znacznika czasu podpisu cyfrowego** powiązanego pliku `.cat` (pliku katalogowego podpisującego pliki INF). Daje to dokładną informację o dacie wydania pakietu, **nawet jeśli sam plik INF zawiera fikcyjną datę, np. 1968/1970** – tak się dzieje, ponieważ Intel przestał umieszczać daty w nowszych plikach INF.
  
---

#### 5. Porównaj z tym, co mówi inny program
Jeśli inny program nie widzi najnowszej wersji lub sugeruje **downgrade do starszej wersji**, to nie jest to poprawne.

---

Uwierz mi, **nikt inny nie jest na tyle szalony**, aby pobrać, rozpakować i przeanalizować **każdy dostępny instalator Intel Chipset Device Software**, a następnie skompilować je w kompletną, przeszukiwalną bazę danych. To właśnie zrobiłem – i na tym opiera się **[Universal Intel Chipset Updater](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater)**.

To narzędzie wykonuje powyższe sprawdzenie **automatycznie** dla wszystkich urządzeń chipsetu Intela w kilka sekund, a następnie pobiera i instaluje właściwe pakiety z pełną weryfikacją sum kontrolnych.

--- 

Autor: Marcin Grygiel aka FirstEver ([LinkedIn](https://www.linkedin.com/in/marcin-grygiel))
