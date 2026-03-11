# PowerShell Gallery — Publishing Tutorial

## 1. Utwórz konto

Wejdź na **https://www.powershellgallery.com** i zaloguj się kontem Microsoft (Outlook/Hotmail/Live).

---

## 2. Wygeneruj API Key

- Kliknij swoją nazwę użytkownika → **API Keys** → **Create**
- Wypełnij:
  - **Key Name** — dowolna etykieta np. `My Tool Name`
  - **Expires** — maksymalnie 365 dni (musisz regenerować co rok)
  - **Scopes** → zaznacz **Push new packages and package versions**
  - **Packages** → wpisz dokładną nazwę pakietu np. `my-tool-name`
- Kliknij **Create** → **skopiuj klucz natychmiast** — pokazuje się tylko raz

---

## 3. Wygeneruj GUID

Uruchom w PowerShell (nie trzeba admina):

```powershell
[guid]::NewGuid()
```

Zapisz wynik — ten GUID identyfikuje Twój pakiet na zawsze. Nie zmienia się między wersjami.

---

## 4. Dodaj PSScriptInfo do PS1

Wklej poniższy blok jako **pierwszą rzecz w pliku** — przed jakimkolwiek kodem:

```powershell
<#PSScriptInfo
.VERSION 1.0.0
.GUID twoj-guid-tutaj
.NAME nazwa-pakietu-na-gallery
.AUTHOR Twoje Imię
.COMPANYNAME Twoja Firma
.COPYRIGHT (c) 2026 Twoje Imię. All rights reserved.
.TAGS tag1 tag2 tag3 Windows Automation
.LICENSEURI https://github.com/TwojeRepo/LICENSE
.PROJECTURI https://github.com/TwojeRepo
.ICONURI
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES
v1.0.0 - Initial release
#>
```

Zaraz pod PSScriptInfo dodaj opis skryptu:

```powershell
<#
.SYNOPSIS
    Krótki opis w jednej linii.

.DESCRIPTION
    Szczegółowy opis narzędzia.
    Co robi, jakie ma wymagania, co jest warte uwagi dla moderatora Gallery.

.PARAMETER ParamName
    Opis parametru.

.EXAMPLE
    .\my-script.ps1
    Opis przykładu.

.NOTES
    Dodatkowe informacje.
#>
```

---

## 5. Zweryfikuj lokalnie

```powershell
Test-ScriptFileInfo -Path ".\nazwa-skryptu.ps1"
```

Sprawdź czy kolumna **Name** i **Version** są poprawne. Jeśli błąd — sprawdź czy PSScriptInfo jest na samej górze pliku.

---

## 6. Opublikuj

```powershell
Publish-Script -Path ".\nazwa-skryptu.ps1" `
               -NuGetApiKey "twoj-api-key" `
               -Repository PSGallery
```

---

## 7. Aktualizacje (każda kolejna wersja)

W bloku PSScriptInfo zmień tylko:

```powershell
.VERSION 1.0.1
.RELEASENOTES
v1.0.1 - Opis zmian
```

GUID zostaje ten sam na zawsze. Publikuj tą samą komendą co w kroku 6.

---

## ⚠️ Ważne zasady

- Publikuj na Gallery **dopiero po** opublikowaniu release na GitHub
- Numer wersji musi być zawsze wyższy niż poprzedni
- API Key wygasa po roku — regeneruj przed publikacją
- `.NAME` w PSScriptInfo musi być identyczne z nazwą w polu **Packages** w API Key
