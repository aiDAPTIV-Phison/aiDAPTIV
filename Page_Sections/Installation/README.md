# aiDAPTIV+ Installation Guides

This repository contains **two independent installation guides**, each
designed for a **different hardware platform and workload type**.

You should **only follow the guide that matches your system**.

---

## Option 1: llama.cpp Inference (DGX Spark Systems Only)

This guide is intended **only for NVIDIA DGX Spark–based systems** and
covers **inference-only workflows** using aiDAPTIV-enabled `llama.cpp`.

It includes:

- Deploying the aiDAPTIV-enabled `llama.cpp` inference package
- Model preparation (GGUF, quantization, LoRA, multimodal)
- SSD-based KV-cache offload
- Native and Docker-based inference
- Client interaction (Python, curl, Web UI)
- KV-cache resume and locking

➡️ **Choose this option only if you are running on a DGX Spark system**  
➡️ **Inference-only workloads**  
➡️ **aiDAPTIV+ Middleware is NOT required**

> ⚠️ This guide is **not intended for AI100E-based systems**.

[Guide](llama.cpp/README.md)

---

## Option 2: aiDAPTIV+ Middleware (AI100E Systems)

This guide is intended **only for systems using the AI100E drive** and
covers the **aiDAPTIV+ middleware stack** for **model fine-tuning**.

It includes:

- NVIDIA GPU drivers
- CUDA & cuDNN
- aiDAPTIVLink middleware installation
- Phison SSD setup (LVM / mount)
- Training environment verification

➡️ **Choose this option if you are using an AI100E drive**  
➡️ **Required for fine-tuning workflows**  
➡️ **Not required for DGX Spark inference**

[Guide](Middleware/README.md)

---

## ✅ Choosing the Right Path

| System Type | Primary Use Case | Required Guide |
|------------|-----------------|----------------|
| **DGX Spark** | Inference only | llama.cpp/README.md |
| **AI100E-based system** | Fine-tuning / training | Middleware/README.md |


---

If you are unsure which guide applies to your setup, **identify your
system type first**:

- **DGX Spark** → Inference only → `llama.cpp`
- **AI100E system** → Training / fine-tuning → Middleware
