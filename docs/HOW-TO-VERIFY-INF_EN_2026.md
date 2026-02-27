## How to verify the latest INF files yourself

Instead of trusting other driver updaters (even the official Intel Driver & Support Assistant) that often suggest incorrect versions or downgrades, you can easily check the **true latest INF version** for any Intel chipset device manually. Here’s how:

---

### Step‑by‑step (pick one or more chipset devices)

#### 1. Open Device Manager  
Choose one of the following methods:
- Press **Win key + X** → **Device Manager**
- Press **Win key**, type `Device Manager` and press Enter
- Press **Win key + R**, type `devmgmt.msc` and press Enter

<img width="825" height="344" alt="image" src="https://github.com/user-attachments/assets/f51d40d6-565e-4129-ad69-a9826458bb7a" />

---

#### 2. Find an Intel chipset device
- Expand the **"System devices"** section.
- Look for any entry with **"Intel"**, **"Chipset"**, **"LPC"**, etc. in its name.  
- **Often the name already contains the Hardware ID** – for example:  
  `Intel(R) C600/X79 series chipset LPC Controller – 1D41`  
  Here the HWID is **`1D41`**.

<img width="817" height="341" alt="image" src="https://github.com/user-attachments/assets/58c94b5e-d6e8-4a01-a161-21f3c3b78e7c" />

---

#### 3. If the HWID is not in the name, check the Hardware IDs property
- Right‑click the device → **Properties** → **Details** tab.
- In the **Property** dropdown, select **"Hardware Ids"**.
- You will see something like:  
  `PCI\VEN_8086&DEV_1D41&CC_0601`  
  The part after **`DEV_`** (here **`1D41`**) is the device ID.

<img width="441" height="290" alt="image" src="https://github.com/user-attachments/assets/bb9d2ac3-27c0-4af8-b469-0d40f853386d" />

---

#### 4. Look up the HWID in the database I maintain on GitHub
Open my latest INF database in your browser:  
👉 **[intel-chipset-infs-latest.md](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater/blob/main/data/intel-chipset-infs-latest.md)**

Press **Ctrl+F** and search for that HWID (e.g. **`1D41`**).

You will immediately see:
- ✅ The **latest INF version** for that device,
- ✅ Which (latest) **Intel Chipset Device Software package** contains it,
- ✅ The **date shown is taken from the digital signature timestamp** of the associated `.cat` file (the catalog file that signs the INF files).  
  
  This accurately reflects when the package was released, **even if the INF itself contains a dummy date like 1968/1970** – this happens because Intel no longer embeds dates in newer INF files.

<img width="891" height="194" alt="image" src="https://github.com/user-attachments/assets/3f73a395-96f3-4aca-8c0d-2eb235e1b368" />

> **Note:** If your device is **not treated as a chipset component**, or if it is a chipset device that Intel **never included in any of its Chipset Device Software packages** (i.e., the INF comes from Windows Inbox Drivers), the HWID **may not appear** in this database.

---

#### 5. Compare with what your driver tool says
If another program tells you to **downgrade to an older version**, you now know it’s wrong.

---

Believe me, **no one else is crazy enough** to download, extract and examine **every single Intel Chipset Device Software installer ever released**, then compile them into a complete, searchable database. That is exactly what I did – and it is the foundation of the **[Universal Intel Chipset Updater](https://github.com/FirstEverTech/Universal-Intel-Chipset-Updater)**.

The tool does the above check **automatically** for all your Intel chipset devices in seconds, then downloads and installs the correct packages with full hash verification.

---

Author: Marcin Grygiel aka FirstEver ([LinkedIn](https://www.linkedin.com/in/marcin-grygiel))
