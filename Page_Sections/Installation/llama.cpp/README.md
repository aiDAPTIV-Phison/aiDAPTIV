# aiDAPTIV+ llama.cpp Inference Guide (DGX Spark Systems Only)

This guide describes how to run **llama.cpp inference accelerated by aiDAPTIV+ SSD KV-cache offload** on **NVIDIA DGX Spark–based systems**.

It is intended for **inference-only workflows** and is **not a general-purpose inference guide**.

---

## 🔍 Inference vs Middleware Clarification

aiDAPTIV+ supports **multiple AI workflows**, which are installed and used independently depending on the hardware platform and workload type.

### llama.cpp Inference (This Guide)
- **Inference-only workloads** using GGUF models  
- **Designed for NVIDIA DGX Spark–based systems**  
- Uses CUDA-enabled GPUs with SSD-based KV-cache offload  
- **Does NOT require aiDAPTIV+ Middleware**

### aiDAPTIV+ Middleware
- **Fine-tuning and training workflows**
- Required for **AI100E-based systems**
- Installed separately
- Not required for inference-only DGX Spark workflows

> ⚠️ **Important:**  
> If your system uses an **AI100E drive**, do **not** follow this guide.  
> AI100E systems must use the **aiDAPTIV+ Middleware installation guide** instead.

---

## ✅ Prerequisites (DGX Spark Systems Only)

This guide is intended **only for NVIDIA DGX Spark–based systems** and
covers **inference-only workflows** using an aiDAPTIV-enabled `llama.cpp`
package.

The integration in this guide is **NVIDIA GPU–specific**, leverages
CUDA for execution, and uses a Phison aiDAPTIV SSD for **KV-cache offload**
to extend effective GPU memory during inference.

You **do NOT** need to install aiDAPTIV+ Middleware to follow this guide.

### Required Components

- A supported **NVIDIA GPU**
- NVIDIA GPU driver installed
- CUDA & cuDNN installed (per GPU generation)
- A **Phison aiDAPTIV SSD** mounted for KV-cache offload  
  *(examples assume `/mnt/nvme0`)*

> **Note:** If you plan to **fine-tune or train models**, refer to the
aiDAPTIV+ Middleware installation guide instead. Those workflows require
a different software stack.

---

## 📌 What This Guide Covers

- Deploying the aiDAPTIV-enabled `llama.cpp` inference package
- Environment and dependency setup
- Model preparation (GGUF, LoRA, multimodal)
- Running inference servers (native and Docker)
- aiDAPTIV KV-cache offload arguments
- Client interaction (Python, curl, Web UI)
- KV-cache resume and lock mechanisms
- Troubleshooting and best practices

---

## 1️⃣ Deploy aiDAPTIV llama.cpp

> ℹ️ **Note:** The installer package is not currently hosted for public download.  
> For the most up-to-date installer, please contact: **jim_wen@phison.com** by email

### Extract Package

```bash
unzip aiDAPTIV_*.zip
cd aiDAPTIV_*
```

Expected files include:
- `ada.exe`
- `llama-server`
- `llama-quantize`

---

### Grant Required Permissions

```bash
sudo chmod a+x ada.exe
sudo setcap cap_sys_admin,cap_dac_override=+eip ada.exe
sudo chmod +x llama-server
```

---

## 2️⃣ SSD Preparation and Mount

```bash
sudo apt update
sudo apt install -y nvme-cli
sudo nvme list
```

```bash
sudo mkfs.ext4 /dev/nvme1n1
sudo mkdir -p /mnt/nvme0
sudo mount /dev/nvme1n1 /mnt/nvme0
sudo chown -R $USER:$USER /mnt/nvme0
```

---

## 3️⃣ Environment Dependencies

```bash
sudo apt update
sudo apt install -y python3.10-dev libgomp1 liburing2
```

---

## 4️⃣ Model Preparation

Download GGUF models from Hugging Face.

Recommended quantization:
- **Q4_K_M**

---

## 5️⃣ Running Inference

```bash
./llama-server \
  --flash-attn on \
  --model Meta-Llama-3.1-8B-Instruct-Q4_K_M.gguf \
  --predict 400 \
  --ctx-size 8192 \
  --gpu-layers 100 \
  --offload-path /mnt/nvme0 \
  --ssd-kv-offload-gb 10 \
  --dram-kv-offload-gb 10 \
  --kv-cache-resume-policy 0 \
  --swa-full
```

---

## 6️⃣ Client Interaction

### Python
```python
import requests

response = requests.post(
    "http://127.0.0.1:8080/completion",
    json={"prompt": "Hello", "cache_prompt": True}
)

print(response.json()["content"])
```

### curl
```bash
curl http://127.0.0.1:8080/completion \
  -H "Content-Type: application/json" \
  -d '{"prompt":"Hello","cache_prompt":true}'
```

---

## ✅ Ready for Inference

If KV-cache files appear under:

```text
/mnt/nvme0/inference_phison/
```

then **aiDAPTIV+ is successfully accelerating llama.cpp inference**
using SSD-based KV-cache offload.
