## Deploying Universal Intel Chipset Device Updater via MDM

Managing Intel chipset INF updates across a fleet of machines used to mean either hoping Windows Update eventually catches up, or manually touching each device. With the `-quiet` and `-auto` flags introduced in v2026.03.0010, the **Universal Intel Chipset Device Updater** is fully suited for silent, unattended deployment through any enterprise MDM platform.

This guide covers deployment for **Microsoft Intune**, **Microsoft SCCM / Configuration Manager**, **VMware Workspace ONE**, and **PDQ Deploy** — using the current release as of the time of writing.

---

### Prerequisites (all platforms)

Before deploying through any MDM solution, verify the following on your target machines:

- **Windows 10 build 17763 (LTSC 2019) or newer** — required for full TLS 1.2 support out-of-the-box
- **.NET Framework 4.7.2 or newer** — required for GitHub connectivity and hash verification
- **Administrator privileges** — the script auto-elevates, but the deployment context must already run as SYSTEM or a local admin account
- **Internet access to GitHub** — the script downloads INF packages and verifies hashes from `raw.githubusercontent.com` and GitHub release assets; ensure these are not blocked by your proxy or firewall
- **PowerShell execution policy** — the `-ExecutionPolicy Bypass` flag in the launch command handles this; no policy change is needed on the endpoint

**Recommended launch command for all MDM deployments:**
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%SystemRoot%\Temp\IntelChipset\universal-intel-chipset-updater.ps1" -quiet
```

> **Note:** `-quiet` implies `-auto` and suppresses all console output. The full installation log is always written to `%ProgramData%\chipset_update.log` regardless of quiet mode — use this for deployment verification.

---

### Microsoft Intune

Intune supports two practical deployment methods for this tool: as a **Win32 app** (recommended) or via a **PowerShell script policy**.

#### Method A: Win32 App (recommended)

This method gives you full detection rules, assignment filters, and reporting.

**1. Prepare the package**

Download the latest SFX executable from the [Releases page](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/releases):
```
ChipsetUpdater-2026.03.0011-Win10-Win11.exe
```

Create a wrapper `install.cmd` that runs the SFX silently — the SFX extracts to `%SystemRoot%\Temp\IntelChipset\` and automatically launches the PS1 with `-quiet`:
```batch
ChipsetUpdater-2026.03.0011-Win10-Win11.exe
```

> The SFX package is pre-configured to extract and launch `universal-intel-chipset-updater.ps1 -quiet` automatically. No additional wrapper is needed unless you want custom pre/post actions.

**2. Package as .intunewin**

Use the [Microsoft Win32 Content Prep Tool](https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool):
```
IntuneWinAppUtil.exe -c "C:\Package" -s "ChipsetUpdater-2026.03.0011-Win10-Win11.exe" -o "C:\Output"
```

**3. Create the Win32 app in Intune**

- Navigate to **Intune admin center** → **Apps** → **Windows** → **Add** → **Windows app (Win32)**
- Upload the `.intunewin` file
- Set the **Install command**:
  ```
  ChipsetUpdater-2026.03.0011-Win10-Win11.exe
  ```
- Set the **Uninstall command** (no uninstall needed — INF files are part of the OS):
  ```
  cmd.exe /c echo No uninstall required
  ```
- **Install behavior**: `System`
- **Device restart behavior**: `Determine behavior based on return codes`
  - Add return code `3010` → `Soft reboot` (in case Windows flags a pending restart after INF installation)

**4. Detection rule**

Use a **Registry** detection rule to verify the log was written (confirming the script ran):
- **Key path**: `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion`
- **Value name**: *(leave empty — detect key existence only)*

Or use a **File** detection rule for the log:
- **Path**: `C:\ProgramData`
- **File**: `chipset_update.log`
- **Detection method**: File or folder exists

**5. Assign and deploy**

Assign to a device group. For piloting, use **Assigned** to a test group first, then roll out via **Available** or **Required** to broader groups.

---

#### Method B: PowerShell Script Policy

Simpler but with less reporting granularity. Use this for quick rollouts.

- Navigate to **Intune admin center** → **Devices** → **Scripts and remediations** → **Platform scripts** → **Add** → **Windows 10 and later**
- Upload `universal-intel-chipset-updater.ps1` directly
- Settings:
  - **Run this script using the logged on credentials**: `No` (run as SYSTEM)
  - **Enforce script signature check**: `No`
  - **Run script in 64-bit PowerShell host**: `Yes`
- Assign to a device group

> **Limitation:** Intune PowerShell scripts have a default timeout. For systems that create large restore points or have slow disks, the total execution time can exceed 10 minutes. If timeouts occur, switch to Method A (Win32 app) which has a configurable timeout.

---

### Microsoft SCCM / Configuration Manager

SCCM offers the most control over targeting, scheduling, and compliance reporting.

#### 1. Create the Package

- In the **Configuration Manager console**, go to **Software Library** → **Application Management** → **Packages** → **Create Package**
- **Name**: `Universal Intel Chipset Device Updater v2026.03.0011`
- **Source folder**: Point to a network share containing `ChipsetUpdater-2026.03.0011-Win10-Win11.exe`
- Create a **Standard Program** with:
  - **Command line**:
    ```
    ChipsetUpdater-2026.03.0011-Win10-Win11.exe
    ```
  - **Run**: `Hidden`
  - **Program can run**: `Whether or not a user is logged on`
  - **Run with administrative rights**: ✅ checked

#### 2. Alternatively — deploy the PS1 directly

If you prefer deploying the script without the SFX wrapper:

- Place `universal-intel-chipset-updater.ps1` on your distribution point
- Set the **Command line** to:
  ```
  powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "universal-intel-chipset-updater.ps1" -quiet
  ```
- **Run**: `Hidden`
- **Program can run**: `Whether or not a user is logged on`

#### 3. Distribution and Deployment

- **Distribute content** to your Distribution Points
- **Deploy** to a Device Collection
  - **Purpose**: `Required` for mandatory rollout, `Available` for self-service
  - **Schedule**: Set a maintenance window if you want to control timing (recommended — the script creates a restore point which can be I/O intensive)
  - **User experience** → **Allow clients to run software independently of assignments**: depends on your policy
  - **Return codes**: Add `3010` as a **Soft Reboot** if not already present

#### 4. Compliance verification

Create a **Configuration Item** that checks for the existence of `%ProgramData%\chipset_update.log` or queries the last write time of that file to confirm the script ran within the expected window.

---

### VMware Workspace ONE (UEM)

Workspace ONE supports deployment via **Freestyle Orchestrator** or the classic **Scripts** and **Sensors** approach.

#### Method A: Internal App (SFX EXE)

- In the **Workspace ONE UEM console**, go to **Apps & Books** → **Applications** → **Native** → **Add Application** → **Upload**
- Upload `ChipsetUpdater-2026.03.0011-Win10-Win11.exe`
- **Deployment options**:
  - **Install Command**: *(leave default — SFX handles everything)*
  - **Admin Privileges**: `Yes`
  - **Install Context**: `Device`
- Under **Files**, add a **Post-Install Script** if you need to verify the log:
  ```powershell
  Test-Path "$env:ProgramData\chipset_update.log"
  ```

#### Method B: Scripts (PowerShell)

- Navigate to **Resources** → **Scripts** → **Add** → **Windows**
- Upload or paste `universal-intel-chipset-updater.ps1`
- **Execution Context**: `System`
- **Execution Architecture**: `64-bit`
- **Timeout**: Set to `900` seconds (15 minutes) to account for restore point creation on slower systems
- Under **Assignment**, target the appropriate Smart Group

#### Sensor for compliance reporting

Create a **Sensor** to report back whether the update ran successfully:

```powershell
# Returns the last line of the log containing completion status
if (Test-Path "$env:ProgramData\chipset_update.log") {
    $last = Get-Content "$env:ProgramData\chipset_update.log" | Select-Object -Last 5
    return ($last -join " ")
} else {
    return "Log not found"
}
```

- **Evaluation type**: `String`
- Assign to the same Smart Group as the deployment

---

### PDQ Deploy

PDQ Deploy is the fastest option for on-premise environments and ad-hoc rollouts.

#### 1. Create a new Package

- Open **PDQ Deploy** → **New Package**
- **Name**: `Universal Intel Chipset Device Updater v2026.03.0011`

#### 2. Add a Step — Install (SFX)

- **Step type**: `Install`
- **Install file**: Browse to `ChipsetUpdater-2026.03.0011-Win10-Win11.exe`
- **Run as**: `Deploy User (PDQ)` or `Local System` — either works since the script auto-elevates
- **Success codes**: Add `0`, `3010`

#### 3. Alternatively — PowerShell Step

If deploying the PS1 directly (e.g. from a file share):

- **Step type**: `PowerShell`
- **Script**:
  ```powershell
  $dest = "$env:SystemRoot\Temp\IntelChipset"
  New-Item -ItemType Directory -Path $dest -Force | Out-Null
  Copy-Item "\\your-share\scripts\universal-intel-chipset-updater.ps1" "$dest\universal-intel-chipset-updater.ps1" -Force
  & powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "$dest\universal-intel-chipset-updater.ps1" -quiet
  ```
- **Run as**: `Local System`
- **Timeout**: `900` seconds

#### 4. Schedule or deploy on-demand

- Use **Auto Deployments** to schedule recurring runs (e.g. monthly, after Patch Tuesday)
- Or deploy **On Demand** to individual machines or groups from the PDQ Deploy console

#### 5. Verify results

After deployment, use **PDQ Inventory** to query the log file across machines:
- **Scanner** → **File** → `C:\ProgramData\chipset_update.log` → check **Last Modified** date

---

### Verifying a successful deployment (all platforms)

Regardless of the MDM platform used, the primary verification method is the log file:

```
%ProgramData%\chipset_update.log
```

A successful run ends with a line similar to:
```
[2026-03-11 14:32:07] [INFO] Script execution completed in 4.21 minutes with 0 errors
```

A run with issues will contain `[ERROR]` entries — these are always written to the log even in `-quiet` mode, so the log is always the authoritative source of truth.

**Quick PowerShell check across a fleet (run from your management workstation):**
```powershell
$computers = Get-Content "C:\computers.txt"
foreach ($pc in $computers) {
    $log = "\\$pc\c$\ProgramData\chipset_update.log"
    if (Test-Path $log) {
        $last = Get-Content $log | Select-Object -Last 1
        [PSCustomObject]@{ Computer = $pc; Status = $last }
    } else {
        [PSCustomObject]@{ Computer = $pc; Status = "Log not found" }
    }
} | Format-Table -AutoSize
```

---

### Notes on reboot behavior

The script installs INF files which modify device configurations at the bus level. Windows will typically not force an immediate reboot, but a **restart is required** to fully apply the changes. Plan your deployment windows accordingly:

- In **Intune**: use the `3010` soft reboot return code and configure a maintenance window or allow the user to defer
- In **SCCM**: configure the deployment's **User Experience** → **Commit changes at deadline or during maintenance window**
- In **Workspace ONE**: use a post-install reboot policy set to `Defer`
- In **PDQ Deploy**: add a **Reboot** step after the install step, or handle via your standard patch reboot policy

---

Deploying chipset INF updates at scale used to require custom packaging and scripting from scratch. The `-quiet` flag makes this tool a drop-in for any MDM workflow — the hard part (detecting the right hardware, matching packages, verifying hashes, creating restore points) is handled automatically.

👉 **[Universal Intel Chipset Device Updater — GitHub](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater)**

---

Author: Marcin Grygiel aka FirstEver ([LinkedIn](https://www.linkedin.com/in/marcin-grygiel))
