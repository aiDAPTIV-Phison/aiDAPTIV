# 🧩 aiDAPTIV+ Training Examples

This folder contains example training and inference setups for **Phison aiDAPTIV+**, demonstrating fine-tuning and inference workflows across different model types and sizes.

Each subfolder includes ready-to-run configuration files (`env_config.yaml`, `exp_config.yaml`, and dataset configs) along with detailed setup instructions.

---

## 📘 Available Examples

### 🧠 **PhisonAI 20GB–8B Fine-Tuning**
Fine-tunes **Meta-Llama-3.1-8B-Instruct** using the **Dahoas/rm-static** dataset on aiDAPTIV+.

- Example path:  
  [`PhisonAI_20GB_8B/`](./PhisonAI_20GB_8B)

---

### 🚀 **PhisonAI 70B Fine-Tuning**
Fine-tunes the larger **Meta-Llama-3.1-70B-Instruct** using the **Dolly Creative Writing**  dataset on aiDAPTIV+.

- Example path:  
  [`PhisonAI_20GB_70B/`](./PhisonAI_20GB_70B)

---

### 👁️ **Vision Inference Server**
Demonstrates **vision-language inference** using **Qwen2.5-VL** or similar VLMs, capable of processing both image and text inputs.

- Example path:  
  [`Vision_Inference_Server/`](./Vision_Inference_Server)
- Key features:
  - Image-to-text inference pipeline
  - Example dataset of damaged vs. intact packages

---

## ⚙️ Getting Started

Each example folder includes its own `README.md` with detailed setup and command-line instructions.

Before running, ensure:
- Docker and NVIDIA Container Toolkit are installed
- aiDAPTIV+ environment is active (aiDAPTIVLink + aiDAPTIVCache)
- The correct Docker image is available:
  - `licensesp/aidaptiv:vNXUN_2_04_A1`

---

## 📁 Folder Structure
```bash
Training_Examples/
├── PhisonAI_20GB_8B/
│ ├── dataset/
│ ├── output/
│ ├── env_config.yaml
│ ├── exp_config.yaml
│ ├── QA_dataset_config.yaml
│ └── README.md
├── PhisonAI_70B//
│ ├── dataset/
│ ├── output/
│ ├── env_config.yaml
│ ├── exp_config.yaml
│ ├── QA_dataset_config.yaml
│ └── README.md
├── Vision_Inference_Server/
├── quicktest.py
└── README.md
```

---
## 🧾 Notes

- All examples assume access to aiDAPTIV+ infrastructure with compatible SSD caching.
- Model directories (e.g., `/usr/local/models/`) should already contain the required base models.
- Adjust `num_gpus` and NVMe mount paths in each config based on your local system.

---

✅ **Tip:** Start with the 8B example to verify your setup, then move on to 70B or Vision Inference once everything runs smoothly.


