# Installation

Before installing aiDAPTIVLink, prepare your system with the necessary GPU drivers, CUDA toolkit, libraries, and disk setup.

### ✅ Environment Requirements

| Category       | Detail                           |
|----------------|----------------------------------|
| OS             | Ubuntu 22.04.3 Desktop           |
| GPU Driver     | NVIDIA Driver 550                |
| Python Version | Python 3.10.12                   |

---

### 1️⃣ Install NVIDIA GPU Driver

```bash
sudo apt install nvidia-utils-550
sudo apt install nvidia-driver-550
sudo reboot
```

After reboot, confirm installation:

```bash
nvidia-smi
```

> You should see your GPU listed along with the installed driver and CUDA version.

---

### 2️⃣ Install CUDA Toolkit (12.4.1)

```bash
wget https://developer.download.nvidia.com/compute/cuda/12.4.1/local_installers/cuda_12.4.1_550.54.15_linux.run
sudo sh cuda_12.4.1_550.54.15_linux.run
```

> ❗ During installation:
> - Do **not** install the driver again.
> - Uncheck `[X] Driver` and continue with `Install`.

---

### 3️⃣ Install cuDNN (9.4.0)

```bash
wget https://developer.download.nvidia.com/compute/cudnn/9.4.0/local_installers/cudnn-local-repo-ubuntu2204-9.4.0_1.0-1_amd64.deb
sudo dpkg -i cudnn-local-repo-ubuntu2204-9.4.0_1.0-1_amd64.deb
sudo cp /var/cudnn-local-repo-ubuntu2204-9.4.0/cudnn-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cudnn-cuda-12
```

---

### 4️⃣ Install aiDAPTIVLink

> ⚠️ Recommended: Use a fresh Ubuntu system.  
> Alternatively, see [Docker Install (Appendix D)](#) for isolated setup.

```bash
wget https://phisonbucket.s3.ap-northeast-1.amazonaws.com/setup_vNXUN_2_03_00.sh
bash setup_vNXUN_2_03_00.sh
```

- Select `1. Deploy aiDAPTIV+`
- If prompted, you can optionally choose to update firmware (`FW Update`)
- On success, an `aiDAPTIV2/` folder will appear on your Desktop

---

### 5️⃣ Set Up LVM Drives

> If you only have **one SSD**, skip to the _Single SSD Setup_ section below.

**Install LVM Tools**

```bash
sudo apt update
sudo apt install lvm2 xfsprogs
```

**Check SSDs**

```bash
lshw -class disk -class storage | grep -E 'ai100|logical name|version: EIFZ'
lsblk | grep nvme
```

**Wipe & Create Volume Group**

```bash
sudo wipefs -a /dev/nvme1n1 /dev/nvme2n1
sudo pvcreate /dev/nvme1n1 /dev/nvme2n1
sudo vgcreate ai /dev/nvme1n1 /dev/nvme2n1
sudo lvcreate --type striped -i 2 -I 128k -l 100%FREE -n ai ai
```

**Format & Mount**

```bash
sudo mkfs.xfs -f -s size=4k -m crc=0 /dev/ai/ai
sudo mkdir -p /mnt/nvme0
sudo mount /dev/ai/ai /mnt/nvme0
sudo chown -R $USER:$USER /mnt/nvme0
```

**(Optional) Make Persistent**

```bash
echo '/dev/ai/ai /mnt/nvme0 xfs defaults,nofail 0 0' | sudo tee -a /etc/fstab
# To remove:
sudo sed -i '/\/dev\/ai\/ai/d' /etc/fstab
```

**Verify**

```bash
lsblk
```

---

### 🔁 Single SSD Setup (If only one SSD)

```bash
sudo mkfs -t ext4 /dev/nvme1n1
sudo mkdir -p /mnt/nvme0
sudo mount /dev/nvme1n1 /mnt/nvme0
sudo chown -R $USER:$USER /mnt/nvme0
```

---

### 🔧 Firmware Update (Optional)

To run firmware update later:

```bash
bash setup_vNXUN_2_03_00.sh
```

- Select option `3. FW Update`
- Add the NVMe device(s) to update
- Confirm and proceed with update

---

## Installation Test
