# aiDAPTIV Installation Guide (NXUN205.A1)

This guide aligns with the **aiDAPTIVLink 2.0 NXUN205.A1** installation manual and specification.

> **Scope:** aiDAPTIVLink 2 is primarily intended for **post-training and fine-tuning** workflows.  
> Inference acceleration features such as KV-cache offload belong to **aiDAPTIVLink 3**.

---

## 1. Recommended Environment

Use the following baseline environment for the smoothest installation experience:

| Component | Recommended Version |
|---|---|
| OS | Ubuntu 24.04.3 Desktop |
| Kernel | 6.14 |
| NVIDIA Driver | 580 |
| CUDA | 13.0 |
| Python | 3.12 |

> A fresh Ubuntu install is strongly recommended to avoid dependency conflicts.  
> If you are not using a fresh system, prefer the Docker-based workflow.

---

## 2. Before You Start

Before installing aiDAPTIV, make sure you have:

- A supported NVIDIA GPU
- aiDAPTIV cache SSD(s), such as:
  - **AI100E (PCIe 4.0)**
  - **AI200E (PCIe 5.0)**
- Sufficient DRAM and PCIe lane capacity for your target model size
- Internet access for package installation and model downloads
- A Hugging Face account for gated model access (if applicable)

---

## 3. Install NVIDIA Driver

Install the validated NVIDIA 580 driver stack:

```bash
sudo apt update
sudo apt install nvidia-utils-580
sudo apt install nvidia-driver-580-open
sudo reboot
```

### Validate Driver Installation

```bash
nvidia-smi
```

Expected result:
- Driver is installed successfully
- GPU is visible
- CUDA version is shown in the output

---

## 4. Install CUDA 13.0

Download and install the CUDA 13.0 runfile:

```bash
wget https://developer.download.nvidia.com/compute/cuda/13.0.0/local_installers/cuda_13.0.0_580.65.06_linux.run
sudo sh cuda_13.0.0_580.65.06_linux.run
```

### Important During Installation

When the CUDA installer opens:

- Continue
- Accept the license
- **Uncheck Driver**
- Leave CUDA selected
- Proceed with installation

In other words:

```text
[X] Driver  -->  [ ] Driver
```

### Export CUDA Environment Variables

```bash
export CUDA_HOME=/usr/local/cuda-13.0
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH
```

To make this persistent, add those lines to your shell profile (for example `~/.bashrc`).

### Validate CUDA

```bash
nvcc -V
```

Expected result:
- CUDA version should report **13.0**

---

## 5. Install cuDNN

Install **cuDNN 9.17** compatible with CUDA 13.

Use the NVIDIA cuDNN archive/download page and install the version that matches:
- Ubuntu
- CUDA 13
- cuDNN 9.17

> Avoid mixing older cuDNN instructions from previous releases (such as 9.4 / 9.8) with NXUN205.A1.

---

## 6. Prepare Optional Python Environment

Using a Python virtual environment is recommended for dependency isolation:

```bash
python3 -m venv aidaptiv_env
source aidaptiv_env/bin/activate
```

You should now see something like this at the beginning of your prompt:

```text
(aidaptiv_env)
```

---

## 7. Set Up Hugging Face Access

Some models require Hugging Face authentication before download.

### Install the Hub CLI

```bash
pip install --upgrade huggingface_hub
```

### Log In

```bash
huggingface-cli login
```

When prompted:
- Paste your Hugging Face token
- Approve credential storage if needed

> You can generate a token from your Hugging Face account settings.  
> A **Read** token is sufficient for downloading models.

### Optional Git Credential Storage

```bash
git config --global credential.helper store
```

---

## 8. Download a Model (Example: Llama-3.1-8B-Instruct)

If your model is gated, request access first on Hugging Face.

Example download flow:

```bash
mkdir -p /home/$USER/Desktop/llm
cd /home/$USER/Desktop/llm
mkdir Llama-3.1-8B-Instruct

huggingface-cli download --token HF_TOKEN --resume-download meta-llama/Llama-3.1-8B-Instruct \
  --local-dir-use-symlinks False --local-dir Llama-3.1-8B-Instruct
```

Replace:
- `HF_TOKEN` with your actual token
- `meta-llama/Llama-3.1-8B-Instruct` with your desired model repo if needed
- `Llama-3.1-8B-Instruct` with your destination folder name if desired

After download, verify the files exist:

```bash
ls /home/$USER/Desktop/llm/Llama-3.1-8B-Instruct
```

---

## 9. Set Up aiDAPTIV Cache Storage (LVM)

If you have **two SSDs**, the recommended setup is a striped LVM volume.

### 9.1 Install LVM Tools

```bash
sudo apt update
sudo apt install lvm2 xfsprogs
```

### 9.2 Identify Your SSDs

```bash
lshw -class disk -class storage | grep -E 'ai100|logical name|version: EIFZ'
lsblk | grep nvme
```

Confirm the correct device names before continuing.  
Examples commonly look like:

- `/dev/nvme1n1`
- `/dev/nvme2n1`

### 9.3 Optional: Clear Old Filesystem Signatures

Only do this if the drives were used previously and you want to repurpose them.

```bash
sudo wipefs -a /dev/nvme1n1 /dev/nvme2n1
```

### 9.4 Create LVM Volume

```bash
sudo pvcreate /dev/nvme1n1 /dev/nvme2n1
sudo vgcreate ai /dev/nvme1n1 /dev/nvme2n1
sudo lvcreate --type striped -i 2 -I 128k -l 100%FREE -n ai ai
```

### 9.5 Format and Mount

```bash
sudo mkfs.xfs -f -s size=4k -m crc=0 /dev/ai/ai
sudo mkdir -p /mnt/nvme0
sudo mount /dev/ai/ai /mnt/nvme0
sudo chown -R $USER:$USER /mnt/nvme0
```

### 9.6 Optional: Make Mount Persistent

```bash
echo '/dev/ai/ai /mnt/nvme0 xfs defaults,nofail 0 0' | sudo tee -a /etc/fstab
```

To remove it later:

```bash
sudo sed -i '/\/dev\/ai\/ai/d' /etc/fstab
```

### 9.7 Validate Mount

```bash
lsblk
df -h | grep /mnt/nvme0
```

You should see `/mnt/nvme0` mounted and available.

---

## 10. Single SSD Setup (Alternative)

If you only have **one SSD**, use this simpler setup instead:

```bash
sudo mkfs -t ext4 /dev/nvme1n1
sudo mkdir -p /mnt/nvme0
sudo mount /dev/nvme1n1 /mnt/nvme0
sudo chown -R $USER:$USER /mnt/nvme0
```

> Single SSD is supported, but dual-SSD striped LVM is preferred for better I/O throughput.

---

## 11. Optional: Remove or Rebuild LVM Later

If you need to dissolve the LVM configuration:

```bash
sudo umount /mnt/nvme0
sudo lvremove -y /dev/ai/ai
sudo vgremove -y ai
sudo pvremove -y /dev/nvme1n1 /dev/nvme2n1
```

---

## 12. Native Middleware Installation

Use the official installer script:

```bash
wget https://phisonbucket.s3.ap-northeast-1.amazonaws.com/setup_vNXUN_2_05_A1.sh
bash setup_vNXUN_2_05_A1.sh
```

### Installer Flow

When prompted:

1. Select:

```text
1. Deploy aiDAPTIV
```

2. If firmware mismatch is detected, you may be asked whether to update SSD firmware:
   - `Y` = run firmware update
   - `N` = continue installation

3. You may also be asked whether to download the tarball from cloud:
   - `Y` = download automatically
   - `N` = manually provide the local path to `vNXUN_2_05_A1.tar`

### Example Prompts

```text
Select an action:
1. Deploy aiDAPTIV
2. Exit
```

```text
If the FW version does not match, do you need to update the SSD FW? (Y/N)
```

```text
Would you like to download vNXUN_2_05_A1.tar from cloud? (Y/N)
```

### Successful Installation Indicators

After successful install:

- A success message appears
- The `aiDAPTIV2` folder is created
- `phisonai2 -v` reports the expected version

Validate:

```bash
phisonai2 -v
```

Expected result:

```text
version: vNXUN205_A1
```

### Restart Docker Service After Install

```bash
sudo systemctl restart docker
```

---

## 13. Docker-Based Workflow

If you prefer Docker or are avoiding native dependency conflicts, use the container image.

### 13.1 Load the Docker Image

```bash
wget https://phisonbucket.s3.ap-northeast-1.amazonaws.com/aiDAPTIV_vNXUN_2_05_A1.tar.gz
docker load < aiDAPTIV_vNXUN_2_05_A1.tar.gz
```

### 13.2 Verify Image

```bash
docker images | grep aidaptiv
```

Expected output should include:

```text
aidaptiv:vNXUN_2_05_A1
```

### 13.3 Run the Container

```bash
docker run --gpus all -it --ipc=host --privileged=true --ulimit memlock=-1 \
  -v /data:/data aidaptiv:vNXUN_2_05_A1
```

> Make sure NVIDIA Container Toolkit is installed if GPU access in Docker is required.

---

## 14. Firmware Update (If Needed Later)

To rerun the installer and perform firmware update when needed:

```bash
bash setup_vNXUN_2_05_A1.sh
```

Then choose the firmware update path from the interactive menu when prompted.

---

## 15. Validation Checklist

Run these checks after setup.

### Check Driver

```bash
nvidia-smi
```

### Check CUDA

```bash
nvcc -V
```

Expected:
- CUDA version = **13.0**

### Check Middleware Version

```bash
phisonai2 -v
```

Expected:
- `vNXUN205_A1`

### Check SSD Mount

```bash
df -h | grep /mnt/nvme0
```

### Check Docker Image (if using Docker)

```bash
docker images | grep aidaptiv
```

---

## 16. Optional: Create Swap on aiDAPTIV Cache

A swap file can be useful for very large workloads or experiments.

Example flow:

```bash
sudo fallocate -l 64G /mnt/nvme0/swapfile
sudo chmod 600 /mnt/nvme0/swapfile
sudo mkswap /mnt/nvme0/swapfile
sudo swapon /mnt/nvme0/swapfile
swapon --show
```

To make it persistent:

```bash
echo '/mnt/nvme0/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

---

## 17. Quick Troubleshooting Notes

### CUDA or cuDNN mismatch
If CUDA, torch, and cuDNN versions do not match, some packages may fail to import or build correctly.

Useful checks:

```bash
pip list | grep -E 'torch|nvidia|cuda'
nvcc -V
nvidia-smi
```

### `ninja` build errors
If you see missing `ninja` issues:

```bash
pip install ninja
```

### `sentencepiece` missing
If tokenizer conversion fails:

```bash
pip install --user sentencepiece
```

### `protobuf` issues
If a model complains about protobuf:

```bash
pip install --upgrade protobuf
```

### LVM mount not visible
Recheck:

```bash
lsblk
df -h
sudo mount -a
```

---

## 18. Summary

At the end of a successful installation, you should have:

- Ubuntu 24.04.3 with NVIDIA 580 installed
- CUDA 13.0 configured
- cuDNN 9.17 installed
- Hugging Face authentication ready
- aiDAPTIV cache mounted at `/mnt/nvme0`
- aiDAPTIV middleware installed as **vNXUN205_A1**
- Optional Docker image loaded as **aidaptiv:vNXUN_2_05_A1**

You are then ready to move on to:
- dataset configuration
- training config setup
- benchmark toolkit usage
- fine-tuning workflows
