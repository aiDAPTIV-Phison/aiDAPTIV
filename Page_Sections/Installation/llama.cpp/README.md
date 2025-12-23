# aiDAPTIV+ llama.cpp Inference Guide

This guide describes how to run **llama.cpp inference accelerated by aiDAPTIV+ SSD KV‑cache offload**.
It closely follows the official *aiDAPTIV llama.cpp Inference User Guide (NEUO301F0B)*, but is rewritten
as a **clean, text‑only Markdown README** suitable for GitHub.

> **Prerequisite**
> - You must complete the aiDAPTIV+ installation first (drivers, CUDA, cuDNN, aiDAPTIVLink, SSD mount).
> - A Phison aiDAPTIV SSD must be mounted (examples assume `/mnt/nvme0`).

---

## 📌 What This Guide Covers

- Deploying aiDAPTIV‑enabled `llama.cpp`
- Environment and dependency setup
- Model preparation (GGUF, LoRA, multimodal)
- Running inference servers (native + Docker)
- aiDAPTIV KV‑cache offload arguments
- Client interaction (Python, curl, Web UI)
- KV‑cache resume and lock mechanisms
- Troubleshooting and best practices

---

## 1️⃣ Deploy aiDAPTIV llama.cpp

### Extract Package

Extract the provided aiDAPTIV llama.cpp package:

```bash
unzip aiDAPTIV_*.zip
cd aiDAPTIV_*
```

Expected files include:
- `ada.exe`
- `llama-server`
- `llama-quantize`
- conversion scripts (if included)

---

### Grant Required Permissions

aiDAPTIV requires elevated permissions to manage SSD offload.

```bash
sudo chmod a+x ada.exe
sudo setcap cap_sys_admin,cap_dac_override=+eip ada.exe
sudo chmod +x llama-server
```

Verify capabilities:

```bash
sudo getcap ./ada.exe
```

Expected:
```text
ada.exe = cap_sys_admin,cap_dac_override+eip
```

---

## 2️⃣ SSD Preparation and Mount

### Install NVMe Tools

```bash
sudo apt update
sudo apt install -y nvme-cli
```

List NVMe devices:

```bash
sudo nvme list
lsblk | grep nvme
```

### Format and Mount Phison SSD

> ⚠️ **Warning:** This erases all data on the selected device.

```bash
sudo mkfs.ext4 /dev/nvme1n1
sudo mkdir -p /mnt/nvme0
sudo mount /dev/nvme1n1 /mnt/nvme0
sudo chown -R $USER:$USER /mnt/nvme0
```

Verify:

```bash
df -h | grep /mnt/nvme0
```

> ℹ️ `/mnt/nvme0` is used throughout this guide.  
> You may change it, but must pass the same path to `--offload-path`.

---

## 3️⃣ Environment Dependencies

Install required system libraries:

```bash
sudo apt update
sudo apt install -y   python3.10-dev   libgomp1   liburing2
```

---

## 4️⃣ Model Preparation

### Download Models (Recommended)

Models should be downloaded from **Hugging Face** in GGUF format when possible.

### Example: Llama 3.1 8B Instruct

Recommended quantization:
- **Q4_K_M**

Example repository:
```
bartowski/Meta-Llama-3.1-8B-Instruct-GGUF
```

---

### Convert Base Model → GGUF (If Needed)

If your model is not already in GGUF format:

```bash
python3 convert_hf_to_gguf.py "<base_model_dir>" --outfile <output_model>.gguf
```

Example:

```bash
python3 convert_hf_to_gguf.py Meta-Llama-3.1-8B-Instruct   --outfile Llama-3.1-8B-Instruct.gguf
```

---

### Multimodal Models (Optional)

For image‑text models, download **both**:
- Model GGUF file
- Multimodal projector (`.mmproj`, f16)

Convert projector:

```bash
python3 convert_hf_to_gguf.py gemma-3-4b-it   --outfile gemma-3-4b-it.mmproj   --mmproj
```

---

### LoRA Adapter Conversion (Optional)

If using LoRA adapters, convert them to GGUF:

```bash
python3 convert_lora_to_gguf.py "<lora_dir>" --base "<base_model_dir>"
```

> ⚠️ Rename the tensor file to `adapter_model.bin` before conversion.

---

### Quantization (Optional)

Convert full‑precision GGUF → quantized GGUF:

```bash
./llama-quantize "<input>.gguf" "<output>.gguf" Q4_K_M
```

---

## 5️⃣ llama.cpp Server Arguments

### General Arguments

| Argument | Description |
|--------|-------------|
| `--model` | Path to GGUF model |
| `--ctx-size` | Base context size |
| `--predict` | Tokens to generate |
| `--gpu-layers` | Layers stored in VRAM |
| `--lora` | GGUF LoRA adapter |
| `--flash-attn` | Enable Flash Attention |

---

### aiDAPTIV Arguments

| Argument | Description |
|--------|-------------|
| `--offload-path` | Phison SSD mount path |
| `--ssd-kv-offload-gb` | KV cache offload size on SSD |
| `--dram-kv-offload-gb` | KV cache offload size in DRAM |
| `--extend-ctx-size` | Extended context size |
| `--extend-device` | 0 = DRAM, 1 = SSD |
| `--kv-cache-resume-policy` | 0 = clean, 1 = resume |
| `--debug-log-path` | Debug log output path |

---

## 6️⃣ Running Inference

### Native Text Generation

```bash
./llama-server   --flash-attn on   --model Meta-Llama-3.1-8B-Instruct-Q4_K_M.gguf   --predict 400   --ctx-size 8192   --gpu-layers 100   --offload-path /mnt/nvme0   --ssd-kv-offload-gb 10   --dram-kv-offload-gb 10   --kv-cache-resume-policy 0   --swa-full
```

Expected output:
```text
server is listening on http://0.0.0.0:8080
```

---

### Multimodal Inference

```bash
./llama-server   --flash-attn on   --model <model.gguf>   --mmproj <projector.mmproj>   --ctx-size 8192   --predict 400   --gpu-layers 100   --offload-path /mnt/nvme0   --ssd-kv-offload-gb 10   --dram-kv-offload-gb 10   --kv-cache-resume-policy 0   --swa-full
```

---

### Docker-Based Inference (Optional)

```bash
docker run --rm --gpus all   -it --net=host --ipc=host --privileged=true   --ulimit memlock=-1   --ulimit stack=67108864   -v /mnt/nvme0:/mnt   <image_name>:<version>   --flash-attn on   --model <model.gguf>   --offload-path /mnt   --ssd-kv-offload-gb 10   --dram-kv-offload-gb 10   --kv-cache-resume-policy 0
```

---

## 7️⃣ Client Interaction

### Python Client

```bash
pip install requests
```

```python
import requests

url = "http://127.0.0.1:8080/completion"
payload = {
  "prompt": "How much is one plus one?",
  "cache_prompt": True
}

r = requests.post(url, json=payload)
print(r.json()["content"])
```

---

### curl Client

```bash
curl http://127.0.0.1:8080/completion   -H "Content-Type: application/json"   -d '{"prompt":"What is the future of AI?","cache_prompt":true}'
```

---

### Web UI

Open in browser:

```
http://127.0.0.1:8080
```

---

## 8️⃣ KV Cache Resume & Locking (Advanced)

### Resume KV Cache

```bash
--kv-cache-resume-policy 1
```

All of the following must match:
- aiDAPTIV version
- Model weights
- LoRA weights
- Multimodal projector
- Flash Attention setting

---

### Lock KV Cache (Prevent Eviction)

Example request payload:

```json
{
  "cache_prompt": true,
  "prompt": ["Explain KV cache in LLMs"],
  "offload_folder_name": "doc1",
  "n_predict": 0
}
```

Stored at:

```
/mnt/nvme0/inference_phison/doc1/
```

Locked KV cache:
- Reusable
- Never evicted

---

## 9️⃣ Notes & Best Practices

- Only **1 GPU / 1 slot** supported
- Always enable **Flash Attention**
- Exclude:
  - `llama-server`
  - offload directory
  from antivirus scanning
- Ensure Ada service is running before inference

---

## 🔧 Troubleshooting

**aiDAPTIV not supported**
- Verify Ada permissions
- Confirm Phison SSD presence
- Confirm `--offload-path` permissions

**Server launch failure**
- Check GPU usage (`top`, `nvidia-smi`)
- Verify model path
- Kill conflicting processes

---

## ✅ Ready for Inference

If the server launches and KV cache files appear under:

```
/mnt/nvme0/inference_phison/
```

aiDAPTIV+ is successfully accelerating llama.cpp inference.
