# Instrukcja tworzenia nowego release

---

## 1. Przygotuj pliki

Zaktualizuj wersję i zawartość:

- `universal-intel-chipset-device-updater.ps1` — zmień `.VERSION` w bloku PSScriptInfo oraz `$ScriptVersion` w kodzie

---

## 2. Wygeneruj plik SHA256

Uruchom `Generate_Hash.bat` — wygeneruje plik hash dla PS1:

```
universal-intel-chipset-device-updater-2026.xx.xxxx-ps1.sha256
```

---

## 3. Utwórz archiwum SFX w WinRAR

Dodaj do archiwum plik:
```
universal-intel-chipset-device-updater.ps1
```

### Zakładka General

| Opcja | Wartość |
|-------|---------|
| Archive name | `ChipsetUpdater-2026.xx.xxxx-Win10-Win11.exe` |
| Archive format | `RAR` |
| Compression method | `Best` |
| Create SFX archive | `Yes` |
| Create solid archive | `Yes` |
| Add recovery record | `Yes` |
| Lock archive | `Yes` |

### Advanced → SFX options → General

| Opcja | Wartość |
|-------|---------|
| Path to extract | `%SystemRoot%\Temp\universal-intel-chipset-device-updater` |

### Advanced → SFX options → Setup

| Opcja | Wartość |
|-------|---------|
| Run after extraction | `powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Normal -File "%SystemRoot%\Temp\universal-intel-chipset-device-updater\universal-intel-chipset-device-updater.ps1"` |

### Advanced → SFX options → Modes

| Opcja | Wartość |
|-------|---------|
| Hide all | `Yes` |

### Advanced → SFX options → Advanced

| Opcja | Wartość |
|-------|---------|
| Request administrative access | `Yes` |

### Advanced → SFX options → Update

| Opcja | Wartość |
|-------|---------|
| Overwrite all files | `Yes` |

### Advanced → SFX options → Logo and icon

| Opcja | Wartość |
|-------|---------|
| Load SFX icon | `FirstEverTech.ico` |

---

## 4. Podpisz cyfrowo plik SFX

Podpisz wygenerowany plik EXE swoim certyfikatem:

```
ChipsetUpdater-2026.xx.xxxx-Win10-Win11.exe
```

---

## 5. Opublikuj release na GitHub

Utwórz nowy release i dodaj pliki:

```
ChipsetUpdater-2026.xx.xxxx-Win10-Win11.exe
universal-intel-chipset-device-updater-2026.xx.xxxx-ps1.sha256
```

---

## 6. Zaktualizuj plik wersji na GitHub

Zaktualizuj zawartość pliku:
```
/src/universal-intel-chipset-device-updater.ver
```

**[Opcjonalnie]** Dla zachowania kompatybilności ze starszymi wersjami zaktualizuj również:
```
/src/universal-intel-chipset-updater.ver
```

---

## 7. Opublikuj na PowerShell Gallery

Publikuj **dopiero po** opublikowaniu release na GitHubie — skrypt weryfikuje hash który musi już być dostępny w repo.
> Twój API Key możesz skopiować ze swojego konta ([PowerShell Gallery](https://www.powershellgallery.com/account/apikeys)).

```powershell
Publish-Script -Path ".\universal-intel-chipset-device-updater.ps1" `
               -NuGetApiKey "twoj-api-key" `
               -Repository PSGallery
```

---

Autor: Marcin Grygiel aka FirstEver ([LinkedIn](https://www.linkedin.com/in/marcin-grygiel))
