<a id="top"></a>
# 🐛 Known Issues & Solutions

This document contains all reported issues, bugs, and their corresponding solutions for the Universal Intel Chipset Device Updater. The list is maintained by the community and updated regularly.

## 📑 Quick Navigation

- [Issue #1: Touchpad Stops Working After Chipset Update](#issue-1-touchpad-stops-working-after-chipset-update)
- [Issue #2: PowerShell Execution Policy Restriction](#issue-2-powershell-execution-policy-restriction)
- [Issue #3: Script Fails to Extract Intel Chipset Device Software](#issue-3-script-fails-to-extract-intel-chipset-device-software)
- [Issue #4: Installer Cannot Continue Due to Missing or Corrupted Previous Intel Chipset Installation](#issue-4-installer-cannot-continue-due-to-missing-or-corrupted-previous-intel-chipset-installation)
- [Issue #5: Change in Intel Chipset Software installer starting from version 10.1.20378.8757](#issue-5-change-in-intel-chipset-software-installer)
- [Issue #6: Error 1603 During MSI Installation Due to Corrupted Previous Installation](#issue-6-error-1603-during-msi-installation-due-to-corrupted-previous-installation)

---

<a id="issue-1-touchpad-stops-working-after-chipset-update"></a>
## Issue #1: Touchpad Stops Working After Chipset Update

**Affected Systems**: Lenovo ThinkPad T480 and T480s laptops

**Symptoms**:  
- Touchpad becomes completely unresponsive after chipset INFs update  
- No cursor movement or touchpad clicks registered

**Cause**:  
Chipset INF update interferes with touchpad driver functionality.

**Solution**:
1. Download the appropriate touchpad driver for your model:
   - **ELAN UltraNav Driver** (for ThinkPad T480s):  
     `n22ga09w.exe` – https://download.lenovo.com/pccbbs/mobiles/n22ga09w.exe
   - **Synaptics UltraNav Driver** (for ThinkPad T480):  
     `n23gz21w.exe` – https://download.lenovo.com/pccbbs/mobiles/n23gz21w.exe
2. Run the downloaded installer as Administrator  
3. Restart your system

[↑ Back to top](#top)

---

<a id="issue-2-powershell-execution-policy-restriction"></a>
## Issue #2: PowerShell Execution Policy Restriction

**Affected Systems**: All Windows systems with default PowerShell settings

**Symptoms**:
- SFX EXE fails to run with PowerShell execution policy errors  
- Script terminates immediately without user interaction  
- Error message:  
  ```
  File ... cannot be loaded because running scripts is disabled on this system
  ```

**Cause**:  
Windows PowerShell blocks script execution by default for security reasons.

**Solution**:

### For SFX EXE Users

#### ✅ Permanent Fix (Recommended)
1. **Press Windows + X** and select **Windows PowerShell (Admin)**
2. Run the command:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
3. Type **Y** to confirm  
4. Run the ChipsetUpdater-10.1-2025.11-INF-Win10-Win11.exe normally

#### ⚠️ Temporary Fix (One-Time Bypass)
1. Open Command Prompt as Administrator  
2. Navigate to your EXE location  
3. Run:
   ```cmd
   PowerShell -ExecutionPolicy Bypass -Command "& {Start-Process -FilePath 'ChipsetUpdater-10.1-2025.x.x-Win10-Win11.exe' -Verb RunAs}"
   ```

---

### For PS1 Users (Direct PowerShell Script)

#### Permanent Fix:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
Type **Y** to confirm.  
Now you can run the PS1 script normally.

#### Temporary Fix:
```powershell
powershell -ExecutionPolicy Bypass -File "universal-intel-device-updater.ps1"
```

---

### Alternative: Use Batch Files Instead

If the SFX continues to fail:

1. Download both `.bat` and `.ps1` files  
2. Place them in the same folder  
3. Right-click the `.bat` file → **Run as administrator**

---

### Security Notes
- Permanent fix affects only the current user and is safe for trusted scripts  
- Temporary bypass is safest for one-time use  
- Revert execution policy anytime with:  
  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope CurrentUser
  ```

[↑ Back to top](#top)

---

<a id="issue-3-script-fails-to-extract-intel-chipset-device-software"></a>
## Issue #3: Script Fails to Extract Intel Chipset Device Software

**Symptoms**:  
Script downloads Intel Chipset Device Software but fails to install them.

**Cause**:  
Corrupted download or temporary file conflicts.

**Solution**:
1. Delete contents of:  
   ```
   C:\Windows\Temp\IntelChipset
   ```
2. Run the script again  
3. Ensure a stable internet connection during download

[↑ Back to top](#top)

---

<a id="issue-4-installer-cannot-continue-due-to-missing-or-corrupted-previous-intel-chipset-installation"></a>
## Issue #4: Installer Cannot Continue Due to Missing or Corrupted Previous Intel Chipset Installation

**Symptoms**:  
- The installer reports that it cannot continue  
- Windows Installer (MSI) cannot find the original Intel Chipset Device Software package  
- Installation halts before INF processing begins

<img width="503" height="396" alt="Intel_Issue" src="https://github.com/user-attachments/assets/a8e10bf2-8169-48b3-9f4f-7ab9ffcf60f2" />
  
**Cause**:  
This issue occurs when a previous installation of *Intel Chipset Device Software* was not cleanly uninstalled or its original MSI package has become corrupted or missing. This problem existed *before* using the Universal Intel Chipset Updater.

**Solution**:

1. **Uninstall via Windows (if possible)**  
   Try removing **Intel Chipset Device Software** from the standard Windows *Apps & Features* list.

2. **Reinstall (you need the same version of SetupChipset.exe file).**  
   - Copy the version from the end of the link in the "Use source" window  
     e.g. C:\ProgramData\Package Cache\{D220324C-2510-4BF2-B789-56832E9223E2}v10.1.18981.6008
   - Search Google for the missing package: Download Intel Chipset Device Software v10.1.18981.6008
   - Download the SetupChipset.exe file (may be zipped) and reinstall it

3. **Use a Cleanup Tool (Recommended)**  
   If the entry is missing or the uninstall fails, use **[Revo Uninstaller (Free Version)](https://www.revouninstaller.com/products/revo-uninstaller-free/)**.  
   It will remove:
   - leftover registry entries  
   - broken MSI references  
   - residual program files  

   Community reports, including MSI forum discussions, confirm that Revo Uninstaller reliably fixes this issue.

3. **Reinstall the Intel Chipset Package**  
   After cleanup, run the installer again. It should now proceed normally.

**Important**:  
A successful installation will always show one of two prompts:
- **Installation/Upgrade**, or  
- **Downgrade**

If neither appears, cleanup was incomplete.

[↑ Back to top](#top)

---

<a id="issue-5-change-in-intel-chipset-software-installer"></a>
## Issue #5: Change in Intel Chipset Software installer starting from version 10.1.20378.8757

Intel has decided to replace the existing small `SetupChipset.exe` installer (approximately 2-3 MB in size) with a "new" one that is 105-106 MB. The difference is that the new large EXE installer contains two MSI files for x86 and x64 systems (each about 10 MB), an over 80 MB .NET Framework 4.7.2 package installer, and a 0.5 MB SetupChipset1.cab file with the license agreement.  

**And this is where logic completely breaks down.**

This chipset software is clearly intended mainly for modern platforms from the last ~5 years, which in practice means **Windows 11** and sometimes **Windows 10**. Both operating systems already ship with **.NET Framework 4.8 / 4.8.1** built into the OS, and **.NET 4.7.2** cannot even be installed there — it is simply ignored because a newer version is already present.

At the same time, these new chipset packages don’t actually install anything on older systems anyway. They may look like they update INF files, but in reality the packages only contain data for relatively recent Intel platforms. On older systems, nothing meaningful gets installed.

So we end up in a bizarre situation:

- old systems → nothing gets installed
- new systems → .NET 4.7.2 is completely pointless
- installer size → over 100× larger than the actual content it deploys

And let’s be honest — no one running a modern Intel platform in 2026 is using Windows 7 or 8.1, and even if they were, these packages wouldn’t help them anyway.
This is a very strange move, as the actual INF and CAT files contained in these archives take up only 0.5 MB after compression. All of this could be safely installed using a simple command in a BAT (batch) file:

```batch
@ECHO OFF
start/wait "" pnputil -i -a "%~dp0Drivers\*.inf" /subdirs 
exit
```

Alternatively, a small SFX installer (similar to mine) could be created to extract the archive and perform the installation, with its size not exceeding 1 MB. So why are they requiring users to download an installer that is over 100x larger?


**Solution**:  
Every new large installer can be "slimmed down" and reduced to approximately 10 MB by following these steps:

1. Extract EXE: `SetupChipset.exe /extract`
2. Delete: `SetupChipset.msi` file and the `.NET Framework 4.7.2` folder
3. Rename: `SetupChipset.x64.msi` to `SetupChipset.msi`
4. Open `SetupChipset.msi` in **[Orca 3.1.4000.1830](https://softpedia-secure-download.com/dl/3430724d90fd167de1765d4aea06f51d/697b864f/100079861/software/authoring/Orca.Msi)**
5. Delete: `SETUPEXEDIR OR (REMOVE="ALL")` in the `LaunchCondition` table → OK
6. Save the edited MSI file

#### ⚠️ Make sure the edited `SetupChipset.msi` and `SetupChipset1.cab` files are in the same directory when running the MSI installer.

In future versions of Universal Intel Chipset Software (starting from 2026), I will add the ability to install the latest reduced-size MSI versions. These versions, like the old installer, will install silently in the background and update all INF files for available Intel devices in the system. Please note that the new installer appears in the list of installed programs as `Chipset Setup`, not as `Intel(R) Chipset Device Software`.

[↑ Back to top](#top)

---

<a id="issue-6-error-1603-during-msi-installation-due-to-corrupted-previous-installation"></a>
## Issue #6: Error 1603 During MSI Installation Due to Corrupted Previous Installation

**Affected Systems**: All Windows systems with a damaged or incomplete previous installation of Intel Chipset Device Software

**Symptoms**:
- MSI installer fails with **Error 1603**
- Installation halts before any INF files are processed
- Error persists even after downloading fresh copies of the installer
- Logs show that Windows Installer cannot properly remove or upgrade the existing product

**Cause**:
This issue occurs when a previous installation of *Intel Chipset Device Software* was not cleanly uninstalled, leaving behind:
- Corrupted or incompatible uninstall data in the Windows registry
- Orphaned entries in the Windows Installer database
- Broken or missing uninstaller executables for older versions

When a new installer attempts to upgrade or overwrite the existing product, it fails because the old product cannot be properly removed — resulting in the generic **Error 1603**.

**Important**: This problem exists *before* using the Universal Intel Chipset Updater and is not caused by it. The same error can affect **any MSI package**, not just Intel INF installers.

---

### 🔧 Solution: Clean the Corrupted Installation

#### Step 1: Download the Dedicated Uninstaller Tool
I have created a dedicated tool that completely cleans your system of any Intel Chipset software installations.

The tool consists of two files:
- [`uninstall-intel-chipset.bat`](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/src/uninstall-intel-chipset.bat) – easy‑to‑run batch wrapper
- [`uninstall-intel-chipset.ps1`](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/src/uninstall-intel-chipset.ps1) – the PowerShell script that does the work

**How to use:**
1. Download **both files** and place them in the same folder
2. Right‑click the `.bat` file and select **Run as administrator**
3. Follow the on‑screen prompts

The tool will:
- Detect all installed versions (both old EXE‑based and new MSI‑based)
- Display version information for each found product
- Attempt silent uninstall using the correct commands
- Remove orphaned registry entries
- Leave INF files untouched (your hardware continues to work normally)
- Create a System Restore Point before making changes
- Log all actions to `%TEMP%\Intel_Chipset_Uninstall.log`

<img width="602" height="752" alt="image" src="https://github.com/user-attachments/assets/fb70dca0-a543-477a-b85d-f74486a4ee9a" />

---

#### Step 2: Note the Detected Version(s)
After running the tool, take note of which Intel Chipset versions were found and removed. This information will help with the next step.

---

#### Step 3: Run the Exact Same Version Installer
1. Locate the installer for the **exact version** that was previously installed (the one you noted in Step 2)
2. Run the installer as Administrator
3. If available, choose **Repair** from the installer's interface
4. If Repair is not available, try **Uninstall** directly from the installer

If repair or uninstall succeeds, the corrupted installation is now cleaned.

---

#### Step 4: Reboot Your System
Restart your computer to ensure all changes take effect and any locked files are released.

---

#### Step 5: Remove Any Remaining Traces (if needed)
If you used the Repair option in Step 3, the old version may still be present. In that case:

- Run the uninstaller tool **again** — it should now succeed without Error 1603
- Alternatively, uninstall the version normally via **Apps & Features**

---

#### Step 6: Run the Universal Intel Chipset Updater
After successfully cleaning the old installation, run the Universal Intel Chipset Updater again. It should now install the latest version without any errors.

---

### 📥 Direct Links & Resources

- **Uninstaller Tool (both files)**:  
  [`uninstall-intel-chipset.bat`](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/src/uninstall-intel-chipset.bat)  
  [`uninstall-intel-chipset.ps1`](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/src/uninstall-intel-chipset.ps1)

- **Full Case Discussion & Solution Details**:  
  [github.com/FirstEverTech/Universal-Intel-Chipset-Updater/issues/14#issuecomment-4010882232](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/issues/14#issuecomment-4010882232)

---

### ⚠️ Notes
- This solution has been tested and confirmed to work on systems where standard uninstall methods failed
- The uninstaller tool is provided as‑is, without warranty. Always test in a non‑production environment first
- Not affiliated with Intel Corporation

[↑ Back to top](#top)

---

## 🔍 Reporting New Issues

If you encounter a new issue not listed here, please:

- Check if the issue is already listed in this document  
- Open a new GitHub Issue with detailed description  
- Include your system specifications and exact error messages  
- Share any workarounds or solutions you've discovered  

---

Last Updated: 29/01/2026
