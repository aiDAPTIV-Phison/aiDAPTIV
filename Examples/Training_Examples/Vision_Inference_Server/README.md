# aiDAPTIV+ Vision Inference Sample

This repo contains a **minimal, runnable sample** showing how to spin up a local **vLLM OpenAI-compatible inference server** for **Qwen2.5-VL-3B-Instruct** and run quick **image-based inference tests**.

It’s designed as a lightweight **sanity-check / sample workload** for aiDAPTIV+, demonstrating how SSD-backed storage can extend memory capacity for vision-language inference.

> If you’re using aiDAPTIV+ for SSD-backed VRAM expansion, follow the same steps—vLLM will load the model while your storage stack handles the heavy lifting.

---

## Platform Notes
- **Linux (Ubuntu 22.04 +)** → fully supported and recommended.  
  Commands below work out of the box once NVIDIA drivers, Docker, and the NVIDIA Container Toolkit are installed.

---

## Contents
- `quick_test.py` – minimal Python script that sends an image query to the local OpenAI endpoint (picks a random image if `--image` is omitted).  
- `README.md` – you’re here.

---

## Requirements
- **NVIDIA GPU** with recent drivers  
- **Docker** with **NVIDIA Container Toolkit** (for `--gpus all`)  
- Internet access to pull:  
  - Docker image → `vllm/vllm-openai:latest`  
  - Model weights → `Qwen/Qwen2.5-VL-3B-Instruct` (from Hugging Face on first run)  
- **Python 3.10 +** (only required if running `quick_test.py` or the notebook locally)

---

## 1) Start the vLLM Inference Server

### Option A — Let vLLM download the model (quick start)
```bash
# Stop any previous container
sudo docker stop vllm-qwen2_5-vl3b 2>/dev/null || true

# Run vLLM on all GPUs with host networking on port 8501
sudo docker run -d --rm --gpus all --network host \
  --name vllm-qwen2_5-vl3b \
  vllm/vllm-openai:latest \
  --model Qwen/Qwen2.5-VL-3B-Instruct \
  --trust-remote-code \
  --max-model-len 8192 \
  --max-num-seqs 4 \
  --port 8501
 ```
### Option B - Keep models on a local folder (repeatable)

```
mkdir -p .models
# (Optional) pre-download model into .models/Qwen2.5-VL-3B-Instruct

sudo docker run -d --rm --gpus all --network host \
  -v "${PWD}/.models:/model" \
  --name vllm-qwen2_5-vl3b \
  vllm/vllm-openai:latest \
  --model /model/Qwen2.5-VL-3B-Instruct \
  --trust-remote-code \
  --max-model-len 8192 \
  --max-num-seqs 4 \
  --port 8501
```

Endpoint: `http://localhost:8501/v1`

**Health checks:**

```bash
curl http://localhost:8501/v1/models
curl -s http://localhost:8501/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"Qwen/Qwen2.5-VL-3B-Instruct","messages":[{"role":"user","content":"Hello from vLLM!"}]}'
```



## 2) Get the Sample Image Set

This demo uses the **Damaged and Intact Packages** dataset, which contains example product packaging images for quick inference testing.

You have two ways to access it:

### Option A — Download directly
```bash
mkdir -p data/images
curl -L -o data/archive.zip https://phisonbucket.s3.ap-northeast-1.amazonaws.com/online_course_program/archive.zip
unzip -o data/archive.zip -d data/images
```

After extraction, the folder structure will look like:
```bash
data/images/damaged-and-intact-packages/{damaged,intact,unrelated}
```

### Option B — Use the included dataset in this repo

If you’ve cloned this repository, the same image set is already included under:

```bash
Repository_Files/Sample_Dataset/Vision_Inference_Server/damaged-and-intact-packages/
```


You can also browse it directly here:  
👉 [Sample_Dataset/Vision_Inference_Server/damaged-and-intact-packages/](../../Sample_Dataset/Vision_Inference_Server/damaged-and-intact-packages/)





## 3) Run a quick test

### Python script

*(Recommended: use a virtual environment)*

```bash
sudo apt update
sudo apt install -y python3-venv
python3 -m venv .venv
source .venv/bin/activate
pip install "openai>=1.54,<2" pillow
```

Run with a random image (script will pick one from data/images):
```bash
python quick_test.py
```

Run with a specific image:
```bash
python quick_test.py --image data/images/damaged-and-intact-packages/damaged/damagedfoodpackagingbox10.jpeg
```

## 4) Stop the server

```bash
docker stop vllm-qwen2_5-vl3b
```


## Notes

- The demo uses the OpenAI Chat Completions API via vLLM’s compatibility layer.  
- No fine-tuning or tool calling is performed.  
- The sample images are for demonstration purposes only.  
- To try other models, change `--model` to any supported VLM on Hugging Face.  
- This example is intended for quick local testing and validation of aiDAPTIV+ inference setups.
