# aiDAPTIV+ llama.cpp Inference Guide

This guide describes how to run **llama.cpp inference accelerated by aiDAPTIV+ SSD KV-cache offload**.

It is based on the official *aiDAPTIV llama.cpp Inference User Guide (NEUO301F0B)*, rewritten as a
**clean, text-only Markdown README** suitable for GitHub and developer documentation.

---

## 🔍 Inference vs Middleware Clarification

aiDAPTIV+ supports **multiple AI workflows**, which are installed and used independently:

- **llama.cpp (this guide)**  
  → Inference-only workloads using GGUF models  
  → **Does NOT require aiDAPTIV+ Middleware or fine-tuning stack**

- **aiDAPTIV+ Middleware**  
  → Fine-tuning and training workflows  
  → Installed separately and not required for inference

This README focuses **only on llama.cpp inference**.

---

## ✅ Prerequisites

This guide is intended for **inference-only workflows**.

You **do NOT** need to install aiDAPTIV+ Middleware to follow this guide.

Required components:

- A supported **NVIDIA GPU**
- NVIDIA GPU driver installed
- CUDA & cuDNN installed (per GPU generation)
- A **Phison aiDAPTIV SSD** mounted for KV-cache offload  
  (examples assume `/mnt/nvme0`)

If you plan to **fine-tune or train models**, refer to the Middleware installation guide separately.

---

## 📌 What This Guide Covers

- Deploying the aiDAPTIV-enabled `llama.cpp` inference package
- Environment and dependency setup
- Model preparation (GGUF, LoRA, multimodal)
- Running inference servers (native + Docker)
- aiDAPTIV KV-cache offload arguments
- Client interaction (Python, curl, Web UI)
- KV-cache resume and lock mechanisms
- Troubleshooting and best practices

---

## 1️⃣ Deploy aiDAPTIV llama.cpp

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
./llama-server   --flash-attn on   --model Meta-Llama-3.1-8B-Instruct-Q4_K_M.gguf   --predict 400   --ctx-size 8192   --gpu-layers 100   --offload-path /mnt/nvme0   --ssd-kv-offload-gb 10   --dram-kv-offload-gb 10   --kv-cache-resume-policy 0   --swa-full
```

---

## 6️⃣ Client Interaction

### Python
```python
import requests
print(requests.post(
  "http://127.0.0.1:8080/completion",
  json={"prompt":"Hello","cache_prompt":True}
).json()["content"])
```

### curl
```bash
curl http://127.0.0.1:8080/completion  -H "Content-Type: application/json"  -d '{"prompt":"Hello","cache_prompt":true}'
```

---

## ✅ Ready for Inference

If KV cache files appear under:

```
/mnt/nvme0/inference_phison/
```

aiDAPTIV+ is successfully accelerating llama.cpp inference.
