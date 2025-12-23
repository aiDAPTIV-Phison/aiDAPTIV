# aiDAPTIV+ Middleware Installation Guide (AI100E Systems Only)

This guide describes how to install and configure the **aiDAPTIV+ Middleware
stack** for **model fine-tuning and training workflows** on **AI100E-based systems**.

It is intended for workloads that require:
- GPU memory extension via aiDAPTIVLink
- Dataset staging and checkpointing
- Fine-tuning or training large models

This guide is **not intended for inference-only workflows**.

---

## 🔍 Middleware vs Inference Clarification

aiDAPTIV+ supports **multiple AI workflows**, which are installed and used
independently depending on the hardware platform and workload type.

### aiDAPTIV+ Middleware (This Guide)
- **Fine-tuning and training workflows**
- **Required for AI100E-based systems**
- Includes aiDAPTIVLink, drivers, and training runtime
- Supports LLM fine-tuning, checkpointing, and memory offload

### llama.cpp Inference
- **Inference-only workloads**
- **Designed for NVIDIA DGX Spark systems**
- Installed separately
- Does **NOT** require aiDAPTIV+ Middleware

> ⚠️ **Important:**  
> If you are running on a **DGX Spark system**, do **not** follow this guide.
> DGX Spark systems should use the **llama.cpp inference guide** instead.


## Installation

Before installing aiDAPTIVLink, prepare your system with the necessary GPU drivers, CUDA toolkit, libraries, and disk setup.

### ✅ Environment Requirements

| Category       | Detail                                       |
|----------------|----------------------------------------------|
| OS             | Ubuntu 24.04.3 Desktop (kernel 6.14 +)       |
| GPU Driver     | NVIDIA Driver 550                            |
| Python Version | Python 3.12                                  |
| CUDA Toolkit   | CUDA 12.4.1 (40-Series) / 12.8.0 (50-Series) |
| cuDNN Library  | cuDNN 9.4.0 (40-Series) / 9.8.0 (50-Series)  |

---

### 1️⃣ Install NVIDIA GPU Driver


#### For 40-Series GPUs (Ada Lovelace)

```bash
sudo apt install nvidia-utils-550 nvidia-driver-550
sudo reboot
```

#### For 50 Series GPUs (Blackwell)

```bash
sudo apt install nvidia-utils-570 nvidia-driver-570-open
sudo reboot
```

After reboot, confirm installation:

```bash
nvidia-smi
```

> You should see your GPU listed along with the installed driver and CUDA version.

---

### 2️⃣ Install CUDA Toolkit

#### For 40-Series GPUs (Ada Lovelace)

```bash
wget https://developer.download.nvidia.com/compute/cuda/12.4.1/local_installers/cuda_12.4.1_550.54.15_linux.run
sudo sh cuda_12.4.1_550.54.15_linux.run
```

#### For 50-Series GPUs (Blackwell)

```bash
wget https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda_12.8.0_570.86.10_linux.run
sudo sh cuda_12.8.0_570.86.10_linux.run
```


> ❗ During installation:
> - Do **not** install the driver again.
> - Uncheck `[X] Driver` and continue with `Install`.

---

### 3️⃣ Install cuDNN (9.4.0)

#### For 40-Series GPUs (Ada Lovelace)
```bash
wget https://developer.download.nvidia.com/compute/cudnn/9.4.0/local_installers/cudnn-local-repo-ubuntu2404-9.4.0_1.0-1_amd64.deb
sudo dpkg -i cudnn-local-repo-ubuntu2404-9.4.0_1.0-1_amd64.deb
sudo cp /var/cudnn-local-repo-ubuntu2404-9.4.0/cudnn-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cudnn-cuda-12
```

#### For 50-Series GPUs (Blackwell)
```bash
wget https://developer.download.nvidia.com/compute/cudnn/9.8.0/local_installers/cudnn-local-repo-ubuntu2404-9.8.0_1.0-1_amd64.deb
sudo dpkg -i cudnn-local-repo-ubuntu2404-9.8.0_1.0-1_amd64.deb
sudo cp /var/cudnn-local-repo-ubuntu2404-9.8.0/cudnn-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cudnn-cuda-12
```

### 🔍 Summary Table (optional addition)

| GPU Generation | Driver | CUDA | cuDNN |
|----------------|---------|-------|--------|
| 40-Series (Ada) | 550 | 12.4.1 | 9.4.0 |
| 50-Series (Blackwell) | 570-open | 12.8.0 | 9.8.0 |


So:  
- ✅ **40-series → driver 550, CUDA 12.4.1, cuDNN 9.4.0**  
- ✅ **50-series → driver 570-open, CUDA 12.8.0, cuDNN 9.8.0**  


---

### 4️⃣ Install aiDAPTIVLink

> ⚠️ Recommended: Use a fresh Ubuntu system.  
> Alternatively, see [🐳 Docker Installation](#docker-installation-alternative-setup) for isolated setup.

#### Create and activate a Python virtual environment (required as of v2.0.4.A1):
```bash
sudo apt install python3-venv -y
python3 -m venv ~/aidaptiv_env
source ~/aidaptiv_env/bin/activate
```

You’ll see (aidaptiv_env) at the start of your terminal prompt.
This ensures aiDAPTIVLink installs dependencies in an isolated Python environment and avoids version conflicts.

Now run the setup script:


```bash
wget https://phisonbucket.s3.ap-northeast-1.amazonaws.com/setup_vNXUN_2_04_A1.sh
bash setup_vNXUN_2_04_A1.sh
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

**(Optional) Clean Existing Partitions**

> If the SSDs were previously used, clear existing partition data to avoid conflicts.

```bash
sudo wipefs -a /dev/nvme1n1 /dev/nvme2n1
```

**Create Volume Group and Logical Volume**

```bash
sudo pvcreate /dev/nvme1n1 /dev/nvme2n1
sudo vgcreate ai /dev/nvme1n1 /dev/nvme2n1
sudo lvcreate --type striped -i 2 -I 128k -l 100%FREE -n ai ai
```

**Format and Mount**

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
df -h | grep /mnt/nvme0
```

---

### 🔁 Single SSD Setup (If only one SSD)

```bash
sudo mkfs -t ext4 /dev/nvme1n1
sudo mkdir -p /mnt/nvme0
sudo mount /dev/nvme1n1 /mnt/nvme0
sudo chown -R $USER:$USER /mnt/nvme0
```

> ⚠️ Using a single SSD is supported but may reduce I/O performance compared to striped (dual-SSD) LVM setups.

---

### 🧹 (Optional) Dissolve or Recreate LVM

If you need to remove or rebuild your LVM group later:

```bash
sudo umount /mnt/nvme0
sudo lvremove /dev/ai/ai
sudo vgremove ai
sudo pvremove /dev/nvme1n1 /dev/nvme2n1
```

---

### 💡 Optional – Enable Swap File on aiDAPTIVCache

Add a swap file to extend memory for large batch sizes:

```bash
sudo dd if=/dev/zero of=/mnt/nvme0/swapfile bs=1M count=256k
sudo chmod 600 /mnt/nvme0/swapfile
sudo mkswap /mnt/nvme0/swapfile
sudo swapon /mnt/nvme0/swapfile
echo '/mnt/nvme0/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

---

### 🔧 Firmware Update (Optional)

To run firmware update later:

```bash
bash setup_vNXUN_2_04_A1.sh
```

- Select option `3. FW Update`
- Add the NVMe device(s) to update
- Confirm and proceed with update

---
### 🐳 Docker Installation (Alternative Setup)

> If you prefer to install aiDAPTIVLink in an isolated container environment, you can use the Docker method instead of native installation.

---

### ✅ Install Docker and NVIDIA Container Toolkit

- [Install Docker Engine (Ubuntu)](https://docs.docker.com/engine/install/ubuntu/)
- [Install NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

After installation, restart Docker:

```bash
sudo systemctl restart docker
```

---

### 📦 Download and Load Docker Image

```bash
wget https://phisonbucket.s3.ap-northeast-1.amazonaws.com/aiDAPTIV_vNXUN_2_04_A1.tar.gz
docker load < aiDAPTIV_vNXUN_2_04_A1.tar.gz
```

Confirm the image was loaded:

```bash
docker image list
```

> You should see: `aidaptiv:vNXUN_2_04_A1`

---

### 📁 Locate Config and Command Files

After loading the Docker image, a folder will be created at:

```bash
/home/root/aiDAPTIV2/commands
```

This folder includes the following structure:

```
commands/
├── env_config/
│   └── env_config.yaml
├── exp_config/
│   └── exp_config.yaml
└── example.sh
```

> You can modify these files to match your training project parameters.

---

### 🚀 Run the Docker Container

```bash
docker run --gpus all -it --ipc=host --privileged=true --ulimit memlock=-1 \
--ulimit stack=67108864 -v </path/to/model>:/app -v </path/to/LVM>:/mnt \
-v /dev/mapper:/dev/mapper -v /var/lock:/var/lock aidaptiv:vNXUN_2_04_A1
```

Replace:

- `</path/to/model>` with the path to your model directory  
- `</path/to/LVM>` with your mounted LVM volume (e.g., `/mnt/nvme0`)

> ✅ You do **not** need to run this if you're using the native install method above.

---

---

## 🧪 Installation Test

After completing the installation (native or Docker), you can run the following checks to confirm the setup was successful.

---

### ✅ System-Level Checks

Verify that your GPU, CUDA, and cuDNN are all correctly installed:

```bash
nvidia-smi
nvcc --version
```

Expected:
- `nvidia-smi` should show your GPU and driver version.
- `nvcc` should show CUDA 12.4 or 12.8 depending on your GPU generation.

Check cuDNN version:

```bash
cat /usr/include/cudnn_version.h | grep CUDNN_MAJOR -A 2
```

Expected:
- Output includes `#define CUDNN_MAJOR 9`

---

### ✅ aiDAPTIV Directory Check

```bash
ls ~/Desktop/aiDAPTIV2/
```

Expected:
- You should see files and folders such as `commands/`, `env_config/`, etc.

```bash
phisonai2 -v
```
Expected output: aiDAPTIVLink vNXUN_2_04_A1

---

### ✅ Docker Image Check (if using Docker)

```bash
docker image list | grep aidaptiv
```

Expected:
- `aidaptiv:vNXUN_2_04_A1` appears in the list

---

### ✅ Node.js/NPM (Optional UI or CLI Tool)

If your setup includes a Node.js-based management tool (for launching, logging, or interacting with aiDAPTIV), run:

```bash
node -v
npm -v
```

Then inside the aiDAPTIV UI folder (if applicable):

```bash
npm install
npm run test
```

Expected:
- No errors from `npm install`
- Test output showing success or passed checks

> If `npm run test` doesn't exist, consider using `npm run lint`, `npm run dev`, or `npx vitest` depending on your tooling.

---

### ✅ LVM Mount Check

Make sure the LVM volume is mounted:

```bash
df -h | grep /mnt/nvme0
```

Expected:
- A mounted device entry for `/mnt/nvme0`

---

✅ If all tests pass, aiDAPTIVLink is ready for training or inference!

---
_Last updated for aiDAPTIV Middleware v2.0.4 (NXUN_2_04_A1) — Ubuntu 24.04.3 LTS, Kernel 6.14+._

