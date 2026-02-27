# Installation (For NVIDIA 50‑Series GPUs)

This README explains how to install **Pro Suite 2.0** for NVIDIA 50‑series GPUs (5060Ti, 5070Ti, 5080).

---

### ✅ Environment Requirements

| Category       | Detail                                      |
| -------------- | ------------------------------------------- |
| OS             | Ubuntu 22.04 LTS Desktop                    |
| GPU Driver     | NVIDIA Linux-x86\_64-570.133.07 + CUDA 12.8 |
| Kernel Version | 6.8 or later                                |
| GCC Version    | 12.3                                        |

> ⚠️ **Important:** Automatic Ubuntu updates may break compatibility between kernel, driver, and CUDA. Disable auto‑updates or carefully manage upgrades.

---

### 1️⃣ Precautions Before Installation

* Avoid special characters in file/folder names (no spaces, `! ? ' @ # $ % ^ & * ( ) +`).
* Required TCP ports:

  * **Pro Suite Web**: 8899, 8799
  * **Pro Suite Service**: 3019, 5432, 9400, 7017, 8000
  * **Prometheus**: 3090, 9100
* Confirm system has external network access.
* If connecting via SSH, enable X11 forwarding:

  ```bash
  ssh -X user@remote_host
  ```
* Verify GPU recognition:

  ```bash
  sudo lshw -c display
  ```
* Check timezone:

  ```bash
  cat /etc/timezone
  ```

  Change if needed:

  ```bash
  sudo timedatectl set-timezone Asia/Taipei
  ```

---

### 2️⃣ Installation Steps

#### Step 1: Update Kernel (≥6.8)

```bash
uname -r
```

If older than 6.8, update:

```bash
sudo dpkg -l | grep "mainline\|060800"   # remove if present
sudo apt purge -y {kernel package}

sudo docker ps -a
sudo docker rm -f {container}

sudo apt update
sudo apt install -y linux-generic-hwe-22.04
sudo update-grub
sudo update-initramfs -u
sudo reboot
```

After reboot:

```bash
sudo apt upgrade
sudo apt install build-essential linux-headers-$(uname -r)
```

---

#### Step 2: Install GCC 12.3

```bash
sudo apt install gcc-12
sudo rm /usr/bin/gcc
sudo ln -s /usr/bin/gcc-12 /usr/bin/gcc
```

Verify:

```bash
gcc --version
ll /usr/bin/gcc
```

---

#### Step 3: Install NVIDIA Driver (570.133.07)

Remove old drivers:

```bash
sudo dpkg -l | grep nvidia
sudo apt-get remove --purge '^nvidia-.*'
sudo apt-get remove --purge '^libnvidia-.*'

sudo nvidia-uninstall
```

Stop running processes:

```bash
sudo lsof /dev/nvidia*
sudo systemctl stop display-manager
sudo systemctl stop nvidia-persistenced
sudo modprobe -r nvidia-drm
sudo modprobe -r nvidia
```

Remove old `.so` files if found:

```bash
sudo find /usr -name libnvidia*
rm -r /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1/
```

Run installer:

```bash
cd {ProSuite_package_dir}
sudo ./NVIDIA-Linux-x86_64-570.133.07.run -m=kernel-open
```

Follow prompts:

* Continue installation → Yes
* Compatibility libraries → Yes
* Rebuild initramfs (if prompted) → Yes
* Run X utility → No

Reboot, then verify:

```bash
nvidia-smi
```

---

#### Step 4: Install Pro Suite

**Precaution:**

* This version supports offline installation. If no internet access, rename apt sources first:

```bash
sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak
```

* Restore after install:

```bash
sudo mv /etc/apt/sources.list.bak /etc/apt/sources.list
```

**Extract & Install:**

```bash
tar xvf {ProSuite_package}.tar
cd {ProSuite_package}
sudo ./install.sh -c
```

**Menu Option 0 – Install Pro Suite:**

* Select **Pascari AI-Series cache memory** SSD.
* If LVM already exists, remove it first (see Appendix A.1).
* After install, if error appears:

```
Error response from daemon: could not select device driver "nvidia" with capabilities: [[gpu]]
```

Restart Docker:

```bash
sudo systemctl restart docker
```

---

### 🐞 Troubleshooting (Appendix A)

* **Pascari AI-Series cache memory Occupied**: Check VG name (`/dev/prosuite-vg/prosuite-rd`), remove incorrect RAID, or delete boot partition entry in `/etc/fstab`. Use `sudo lvremove /dev/ai/ai` if needed.
* **Permission Issues**:

  * Method 1: Add sandbox config `/etc/apt/apt.conf.d/10sandbox` → `APT::Sandbox::User "root";`
  * Method 2: Manually install `.deb` → `sudo dpkg -i {file}.deb`
* **Ubuntu Auto Update Issues**: Review `/var/log/dpkg.log`, reinstall NVIDIA driver if mismatched, or disable unattended upgrades in `/etc/apt/apt.conf.d/50unattended-upgrades`.
* **Docker GPU Runtime Error**:

  * Verify driver with `nvidia-smi`
  * Check runtime: `nvidia-container-runtime --version`
  * Confirm setup: `cat /etc/docker/daemon.json`
  * Restart Docker: `sudo systemctl restart docker`

---

## ✅ Success Criteria

* GPU driver (570.133.07) loads successfully (`nvidia-smi`).
* Kernel version is ≥6.8 and GCC is 12.3.
* Pro Suite installation completes and Web UI URL is displayed.
* Services run without errors after Docker restart if required.

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

