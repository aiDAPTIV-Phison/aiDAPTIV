# aiDAPTIV+ Installation Guides

This repository contains **two separate installation and setup guides**, depending on how you plan to use aiDAPTIV+.

Please follow the guides **in order** if you plan to run llama.cpp inference with aiDAPTIV+.

---

## 📦 1. aiDAPTIV+ Middleware Installation

This guide covers the **core system setup** required for aiDAPTIV+, including:

- NVIDIA GPU drivers
- CUDA & cuDNN
- aiDAPTIVLink installation
- Phison SSD setup (LVM / mount)
- System verification and testing

➡️ **Start here first**

📄 **Guide:**  
👉 [Middleware/README.md](Middleware/README.md)

---

## 🧠 2. llama.cpp Inference with aiDAPTIV+

This guide covers **running llama.cpp inference on top of an existing aiDAPTIV+ installation**, including:

- Deploying aiDAPTIV-enabled llama.cpp
- Model preparation (GGUF, quantization, LoRA, multimodal)
- SSD KV-cache offload configuration
- Native and Docker inference
- Client interaction (Python, curl, Web UI)
- KV-cache resume and locking

➡️ **Follow this after completing the middleware installation**

📄 **Guide:**  
👉 [llama.cpp/README.md](llama.cpp/README.md)

---

## ✅ Recommended Order

1. **aiDAPTIV+ Middleware Installation**
2. **llama.cpp Inference Guide**

---

If you are only installing aiDAPTIV+ middleware and **not** running llama.cpp, you may stop after Guide #1.
