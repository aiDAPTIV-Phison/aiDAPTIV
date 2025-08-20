# Installation

This README explains how to install **aiDAPTIV+ Pro Suite 2.0** using the official installation guide. It follows the same structured style as your aiDAPTIVLink README.

---

### ✅ Environment Requirements

| Category   | Detail                     |
| ---------- | -------------------------- |
| OS         | Ubuntu 24.04 LTS Desktop   |
| GPU Driver | NVIDIA Driver 550 or later |
| Kernel     | 6.8.0-41-generic           |

> ⚠️ **Important:** Do **not** connect to the internet during OS installation to avoid automatic kernel updates. Pro Suite currently only supports this specific kernel.

---

### 1️⃣ Precautions Before Installation

* Do **not** use special characters in folder or file names (avoid spaces, `! ? ' @ # $ % ^ & * ( ) +`).
* Ensure required TCP ports are available:

  * **Pro Suite Web**: 8899, 8799
  * **Pro Suite Service**: 3019, 5432, 9400, 7017, 8000
  * **Prometheus**: 3090, 9100
* Confirm external network access.
* If connecting via SSH, enable X11 forwarding:

  ```bash
  ssh -X user@remote_host
  ```
* Verify GPU recognition:

  ```bash
  sudo lshw -c display
  ```
* Confirm system timezone:

  ```bash
  cat /etc/timezone
  ```

  Change if needed:

  ```bash
  sudo timedatectl set-timezone Asia/Taipei
  ```

---

### 2️⃣ Install Pro Suite

#### Step 1: Place Tar File

Copy the provided `Pro_Suite.tar` file into your Linux environment.

#### Step 2: Extract the Package

```bash
tar xvf Pro_Suite.tar
```

#### Step 3: Run Installer

```bash
cd Pro_Suite/
sudo ./install.sh
```

* If `yad` is missing, the script will prompt to install it—press `y` to continue.
* The main installation menu will appear.

#### Step 4: Select Installation (Menu Option 0)

* Available SSD(s) will be listed—choose the SSD for **aiDAPTIVCache**.
* If LVM has already been created manually, remove it before proceeding.
* The program installs required apt packages and pulls Docker images.
* After completion, the installer will display the **Pro Suite Web URL(s)**.

---

### 3️⃣ Uninstallation

Run the installer again:

```bash
cd Pro_Suite/
sudo ./install.sh
```

* Select **Num 6** to uninstall.
* Confirm prompts:

  1. Remove LVM Raid0?
  2. Remove Pro Suite Docker image?
  3. Remove Pro Suite data?

---

### 4️⃣ Upgrade Pro Suite

1. Run `install.sh` again:

   ```bash
   sudo ./install.sh
   ```
2. Select **Num 2** – *Upgrade Pro Suite all service*.
3. On success, the installer will display the updated **Pro Suite Web URL(s)**.

---

### 5️⃣ Service Management

* **Check Status (Num 1):** Shows status of each Pro Suite container.
* **Start Service (Num 3):** Starts all Pro Suite services.
* **Stop Service (Num 4):** Stops all services.
* **Restart Service (Num 5):** Restarts all services (useful for troubleshooting).
* **Download Models (Num 7):** Opens a list of available LLM models to download.
* **Debug Mode (Num 8):**

  * Option 1: Restart a specific service.
  * Option 2: Pull/refresh Docker images.
  * Option 3: Clean memory buffer/cache.
  * Option 4: Create LVM.
  * Option 5: Update embedded model.

---

### 🐞 Debugging

If issues occur, generate a log package before contacting Phison:

```bash
sudo bash export_log.sh
```

The log includes system info, hardware details, NVIDIA version, Pro Suite container info, and install logs.

---

## ✅ Success Criteria

* You can access the Pro Suite Web UI at the displayed URL(s).
* GPU is recognized by the system.
* Services can be started/stopped without errors.
* Models can be downloaded and enabled.

---

---

## 🛠️ Pro Suite Maintenance & Management

Once Pro Suite is installed, you can manage it directly through the installer’s numbered menu options:

- **6 – Uninstall Pro Suite**  
  Removes LVM RAID0, Docker images, and Pro Suite data (with confirmation prompts).  
- **2 – Upgrade Pro Suite**  
  Updates all services to the latest supported version (NXUN_2.0.X only).  
- **1 – Check Status**  
  Shows the status of Pro Suite containers and services.  
- **3 – Start Service**  
  Starts all Pro Suite services if they are stopped.  
- **4 – Stop Service**  
  Stops all running Pro Suite services.  
- **5 – Restart Service**  
  Restarts Pro Suite, useful for resolving abnormal issues.  
- **7 – Download Models**  
  Lets you pull and install supported LLMs directly from Pro Suite.  
- **8 – Debug Mode**  
  Advanced troubleshooting: restart a service, refresh/pull Docker images, clear cache, recreate LVM, or update embedded models.

💡 *Tip: Restarting (option 5) often resolves common issues without requiring a full reinstall.*


