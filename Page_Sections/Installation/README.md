# aiDAPTIV+ Installation Guides

This repository contains **two independent installation guides**, depending on how you plan to use aiDAPTIV+.

You **do not need to install both** unless your workflow requires it.

---

## 🧠 Option 1: llama.cpp Inference (Inference Only)

This guide covers **running llama.cpp with aiDAPTIV+ for inference workloads**, including:

- Deploying the aiDAPTIV-enabled llama.cpp inference package
- Model preparation (GGUF, quantization, LoRA, multimodal)
- SSD KV-cache offload configuration
- Native and Docker-based inference
- Client interaction (Python, curl, Web UI)
- KV-cache resume and locking

➡️ **Choose this option if you only need inference**  
➡️ **Middleware installation is NOT required**

📄 **Guide:**  
👉 [llama.cpp/README.md](llama.cpp/README.md)

---

## 🧪 Option 2: aiDAPTIV+ Middleware (Fine-Tuning & Training)

This guide covers the **aiDAPTIV+ middleware stack**, which is primarily used for **model fine-tuning and training workflows**, including:

- NVIDIA GPU drivers
- CUDA & cuDNN
- aiDAPTIVLink middleware installation
- Phison SSD setup (LVM / mount)
- Training environment verification

➡️ **Choose this option if you plan to fine-tune or train models**  
➡️ **Not required for llama.cpp inference-only workflows**

📄 **Guide:**  
👉 [Middleware/README.md](Middleware/README.md)

---

## ✅ Choosing the Right Path

| Use Case | Required Guide |
|--------|----------------|
| Inference only (llama.cpp) | llama.cpp/README.md |
| Fine-tuning / training | Middleware/README.md |
| Fine-tuning + inference | Both (Middleware → llama.cpp) |

---

If you are unsure which guide applies to your use case, start with the **llama.cpp inference guide**, as it has the fewest dependencies.
