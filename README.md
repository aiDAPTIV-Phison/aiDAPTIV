<div align="center">
<a href="https://www.phison.com/en/aidaptiv-plus-ai-data-storage-solution"><picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://github.com/aiDAPTIV-Phison/aiDAPTIV/blob/571b1d5108ea57f87ec3c9f40a9d38f2e028e166/assets/dark_logo.png">
    <source media="(prefers-color-scheme: light)" srcset="https://github.com/aiDAPTIV-Phison/aiDAPTIV/blob/571b1d5108ea57f87ec3c9f40a9d38f2e028e166/assets/light_logo.png">
    <img alt="aiDAPTIV logo" src="https://github.com/atp224/aiDAPTIVTestPage/blob/main/assets/aiDAPTIV_logo.jpg?raw=true" height="110" style="max-width: 100%;">
  </picture></a>

<a href="https://discord.gg/mJ3DtVWVCn"><img src="https://github.com/aiDAPTIV-Phison/aiDAPTIV/blob/571b1d5108ea57f87ec3c9f40a9d38f2e028e166/assets/Discord_button.png" width="165"></a>

### Storage-accelerated LLM inference and fine-tuning beyond GPU VRAM limits
</div>

**This is the official GitHub repository for Phison’s aiDAPTIV technology platform.**  
aiDAPTIV is a storage-accelerated AI infrastructure platform designed to remove GPU memory bottlenecks during large language model (LLM) training and inference by using high-performance NVMe SSDs as a fast extension to GPU VRAM.

This enables developers, researchers, and enterprises to run larger models, longer context windows, and more demanding workloads on existing on-prem hardware without relying on cloud infrastructure.

### What you’ll find in this repository
- Installation and deployment guides for aiDAPTIV memory management middleware
- LLM inference and fine-tuning workflows (PyTorch, vLLM, llama.cpp)
- Documentation on KV-cache offload and SSD-based memory tiering
- Hardware compatibility, benchmarks, and performance guidance
- Integration examples and reference architectures

## What is aiDAPTIV middleware?

**aiDAPTIV middleware** is Phison’s middleware layer in the **aiDAPTIV** stack that lets you train and run larger language models on your own hardware by leveraging high‑performance SSD caching alongside your GPU VRAM. In practice, it minimizes “out‑of‑memory” barriers for fine‑tuning and keeps I/O efficient during inference.

**Key capabilities**
- **Scale beyond VRAM limits:** Use fast NVMe storage as an extension to GPU memory so you can work with bigger models or longer context windows on the same hardware.
- **On‑prem by design:** Keep data local to your workstation, server, or lab cluster, no cloud dependency.
- **Minimal code changes:** Designed to drop into existing PyTorch workflows with little or no refactoring.
- **Lower time‑to‑first‑token (TTFT) at inference:** Storage‑aware scheduling reduces cold‑start stalls so responses begin faster.  
  > Note: aiDAPTIV removes memory bottlenecks for training, but it is **not** intended to speed up the core math of fine‑tuning itself.

---

## How to obtain

aiDAPTIV middleware is distributed as part of the **aiDAPTIV** offering.

- **Commercial availability:** Included with purchases of **Pascari AI-Series cache memory** (Phison’s NVMe caching solution) for workstations and servers.  
- **Evaluation / pilots:** Reach out for a free trial of aiDAPTIV.
- **Academic programs:** Universities and student clubs can inquire about our outreach program for on‑prem testing.

---
**Information on how to install aiDAPTIV middleware is found [here](Page_Sections/Installation/README.md)!**
---

## System Requirements

To ensure optimal performance and compatibility, aiDAPTIV middleware requires the following software and hardware components:

## 🧠 Operating System Compatibility

aiDAPTIV middleware is currently supported **only on Linux** systems.

> ✅ **Recommended Distribution:** Ubuntu 24.04.3 LTS (Desktop or Server Edition)  
> ⚙️ **Kernel Version:** 6.14 or higher  
> 🚫 **Not supported:** Windows or macOS

---

## ✅ Supported NVIDIA GPUs

aiDAPTIV middleware and aiDAPTIV have been validated with the following NVIDIA GPUs.  
> *Note: PCIe Gen 4 ×16 bandwidth is recommended for optimal I/O throughput.*

---

### 🧩 Professional GPUs

| Product Name                                      | Architecture | Memory Type | Capacity | Bandwidth | FP16 TFLOPS | SMs | Power (TDP) | Notes |
|--------------------------------------------------|--------------|-------------|-----------|------------|--------------|-----|--------------|-------|
| **NVIDIA H200 NVL**                              | Hopper       | HBM3e       | 141 GB    | 4800 GB/s  | 1671         | 132 | 300–600 W configurable | Data center |
| **NVIDIA H100 PCIe**                             | Hopper       | HBM2e       | 80 GB     | 2048 GB/s  | 1639         | 114 | 350 W | Data center |
| **NVIDIA RTX Pro 6000 Blackwell (Workstation)**  | Blackwell    | GDDR7       | 96 GB     | 1792 GB/s  | 1000         | 188 | 600 W | Flagship Pro |
| **NVIDIA RTX Pro 6000 Blackwell (Max-Q)**        | Blackwell    | GDDR7       | 96 GB     | 1792 GB/s  | 878          | 188 | 300 W | Mobile / Low-Power |
| **NVIDIA RTX Pro 6000 Blackwell (Server)**       | Blackwell    | GDDR7       | 96 GB     | 1792 GB/s  | 1000         | 188 | 400–600 W configurable | Data center |
| **NVIDIA RTX 6000 Ada Generation**               | Ada Lovelace | GDDR6       | 48 GB     | 960 GB/s   | 728          | 142 | 300 W | Workstation |
| **NVIDIA RTX 5000 Ada Generation**               | Ada Lovelace | GDDR6       | 32 GB     | 576 GB/s   | 522          | 100 | 250 W | Workstation |
| **NVIDIA RTX 4500 Ada Generation**               | Ada Lovelace | GDDR6       | 24 GB     | 432 GB/s   | 317          | 60  | 210 W | Workstation |
| **NVIDIA RTX 4000 Ada Generation**               | Ada Lovelace | GDDR6       | 20 GB     | 360 GB/s   | 214          | 48  | 130 W | Workstation |
| **NVIDIA RTX 4000 SFF Ada Generation**           | Ada Lovelace | GDDR6       | 20 GB     | 280 GB/s   | 153          | 48  | 70 W  | Small Form Factor |
| **NVIDIA RTX A6000**                             | Ampere       | GDDR6       | 48 GB     | 768 GB/s   | 310          | 84  | 300 W | Legacy Pro |
| **NVIDIA RTX A5000**                             | Ampere       | GDDR6       | 24 GB     | 768 GB/s   | 222          | 64  | 230 W | Legacy Pro |
| **NVIDIA L40**                                   | Ada Lovelace | GDDR6       | 48 GB     | 960 GB/s   | —            | —   | — | Data center |
| **NVIDIA L40S**                                  | Ada Lovelace | GDDR6       | 48 GB     | 960 GB/s   | —            | —   | — | Data center |

---

### 🎮 Consumer GPUs

| Product Name                     | Architecture | Memory Type | Capacity | Bandwidth | FP16 TFLOPS | SMs | Power (TDP) | Notes |
|---------------------------------|--------------|-------------|-----------|------------|--------------|-----|--------------|-------|
| **GeForce RTX 5090**            | Blackwell    | GDDR7       | 32 GB     | 1792 GB/s  | 838          | 170 | 575 W | Desktop |
| **GeForce RTX 5080**            | Blackwell    | GDDR7       | 16 GB     | 960 GB/s   | 450          | 84  | 360 W | Desktop |
| **GeForce RTX 5070 Ti**         | Blackwell    | GDDR7       | 16 GB     | 896 GB/s   | 352          | 70  | 300 W | Desktop |
| **GeForce RTX 4090**            | Ada Lovelace | GDDR6X      | 24 GB     | 1008 GB/s  | 661          | 128 | 450 W | Desktop |
| **GeForce RTX 4090 D**          | Ada Lovelace | GDDR6X      | 24 GB     | 1008 GB/s  | —            | —   | 450 W | China variant |
| **GeForce RTX 4080 Super**      | Ada Lovelace | GDDR6X      | 16 GB     | 736 GB/s   | 418          | 80  | 320 W | Desktop |
| **GeForce RTX 4080**            | Ada Lovelace | GDDR6X      | 16 GB     | 717 GB/s   | 390          | 76  | 320 W | Desktop |
| **GeForce RTX 4070 Ti Super**   | Ada Lovelace | GDDR6X      | 16 GB     | 672 GB/s   | 321          | 66  | 285 W | Desktop |
| **GeForce RTX 3090 Ti**         | Ampere       | GDDR6X      | 24 GB     | 1008 GB/s  | 320          | 84  | 450 W | Legacy |
| **GeForce RTX 3090**            | Ampere       | GDDR6X      | 24 GB     | 936 GB/s   | 285          | 82  | 350 W | Legacy |

---

### 💻 Laptop GPUs

| Product Name                     | Architecture | Memory Type | Capacity | Bandwidth | FP16 TFLOPS | SMs | Power (TDP) | Notes |
|---------------------------------|--------------|-------------|-----------|------------|--------------|-----|--------------|-------|
| **GeForce RTX 5090 Laptop GPU** | Blackwell    | GDDR7       | 24 GB     | 896 GB/s   | 456          | 82  | 95–150 W | Mobile |
| **GeForce RTX 5080 Laptop GPU** | Blackwell    | GDDR7       | 16 GB     | 896 GB/s   | 333          | 60  | 80–150 W | Mobile |
| **GeForce RTX 4090 Laptop GPU** | Ada Lovelace | GDDR6       | 16 GB     | 576 GB/s   | 343          | 76  | 80–150 W | Mobile |
| **GeForce RTX 3080 Ti Laptop GPU** | Ampere     | GDDR6       | 16 GB     | 512 GB/s   | 189          | 58  | 80–150 W | Legacy Mobile |

---

### ⚙️ Compatibility Notes

- **Minimum VRAM for inference:** 20–24 GB (for Llama-3 8B-class models).  
- **Minimum VRAM for fine-tuning:** 16 GB (requires Pascari AI-Series cache memory SSD tiering).  
- **Interface:** PCIe Gen 4 ×16 recommended; PCIe Gen 3 supported with reduced throughput.  
- **Architectures validated:** Blackwell (B100 / RTX 50 Series), Hopper (H100/H200), Ada Lovelace (RTX 40 Series), Ampere (RTX 30 Series).  
- **In progress:** AMD Radeon Instinct and Intel Gaudi series under internal testing.

> *Specifications validated from Phison Technical Marketing internal testing and official NVIDIA product documentation as of October 2025.*

---
## 🧠 Inference & Training Model Compatibility

**aiDAPTIV** extends GPU memory by tiering model weights and activations across **GPU VRAM**, **system RAM**, and **Pascari AI-Series cache memory SSDs**.  
This lets you **fine-tune and run larger models** on affordable hardware.

- **Training:** total usable memory ≈ GPU VRAM + system RAM + Pascari AI-Series cache memory.  
- **Inference:** model weights + KV cache must fit primarily in **GPU VRAM** (can be reduced with quantization).

### 🧩 Model VRAM & KV Cache Requirements

| Model | Precision | GPU VRAM | KV Cache | Total VRAM Required |
|:------|:----------|:---------|:---------|:--------------------|
| Llama-3.2-3B | FP16 | 6 GB | 13.6 GB | 19.6 GB |
| Llama-3.2-3B | Q4 | 1.5 GB | 3.4 GB | 4.9 GB |
| Llama-3.1-8B | FP16 | 16 GB | 15.6 GB | 31.6 GB |
| Llama-3.1-8B | Q4 | 4 GB | 3.6 GB | 7.6 GB |
| Llama-3.1-70B | FP16 | 140 GB | 39 GB | 179 GB |
| Llama-3.1-70B | Q4 | 35 GB | 9.75 GB | 44.75 GB |

### 💾 Recommended Pascari AI-Series cache memory Drive Capacity

| SSD Capacity | Max Model Size Supported | Recommended System RAM |
|:-------------|:--------------------------|:-----------------------|
| 320 GB | Up to 13B | 64 GB |
| 1 TB | Up to 34B | 64 GB |
| 2 TB | Up to 70B | 128 GB |
| 4 TB | Up to 180B | 256 GB |

---

### ✅ Compatible CPUs

aiDAPTIV middleware has been tested with the following high-performance processors:

| Brand | Model                        | Sockets | Cores | Base Clock (GHz) | PCIe Lanes |
|-------|------------------------------|---------|-------|------------------|------------|
| Intel | Xeon Gold 5320               | Dual    | 26    | 2.2              | 64         |
| Intel | Xeon Gold 6330               | Dual    | 28    | 2.0              | 64         |
| Intel | Xeon w5-3425                 | Single  | 12    | 3.2              | 112        |
| Intel | Xeon Gold 6538Y+             | Dual    | 32    | 2.2              | 80         |
| Intel | Xeon Silver 4410T            | Dual    | 10    | 2.7              | 80         |
| Intel | Xeon Silver 4410Y            | Dual    | 8     | 2.0              | 80         |
| Intel | Xeon Silver 5315Y            | Dual    | 8     | 3.2              | 64         |
| Intel | Core i9-13900                | Single  | 24    | 1.5 (base)       | 20         |
| Intel | Core i9-12900E               | Single  | 16    | 1.7 (base)       | 20         |
| AMD   | Ryzen Threadripper 7980X     | Single  | 64    | 5.1              | 92         |
| AMD   | EPYC 7713P                   | Single  | 64    | 2.0              | 128        |
| AMD   | EPYC 9174F                   | Single  | 16    | 4.1              | 128        |

> **Note:** The CPUs listed above are ones Phison has validated internally.  
> In practice, aiDAPTIV can run on a much broader range of processors.  
> From a hardware standpoint, the key requirements are:  
> - **PCIe Gen 4.0 or better**  
> - **≥ 8 CPU cores**  
> - **At least 24 PCIe lanes** (16 for a GPU + 2×4 for SSDs)  
>  
> Most modern Intel and AMD processors released in the last 10 years meet these requirements.  

---

### ✅ Compatible aiDAPTIV middleware Caching Device

aiDAPTIV middlewarerequires the use of an **Pascari AI-Series cache memory** SSD for storage-accelerated training and inference.

| Model     | Form Factor | Interface | Notes                         |
|-----------|-------------|-----------|-------------------------------|
| AI100E    | U.2 or M.2  | PCIe 4.0  | Required for aiDAPTIV middleware use |

> *Ensure the AI100E SSD is properly installed in a PCIe Gen 4 compatible slot for peak performance.*

---

## Where to Buy

aiDAPTIV products are available through regional distributors.  
Select your country or territory below to view purchase options.

### 🇺🇸 United States

- [AI Training PC](https://www.neweggbusiness.com/product/product.aspx?item=9b-83-367-001&tpk=9b-83-367-001)  
- [AI Workstation](https://www.neweggbusiness.com/product/product.aspx?item=9b-83-367-003&tpk=9b-83-367-003)  
- [AI100E 320 GB M.2](https://www.neweggbusiness.com/product/product.aspx?item=9b-20-979-149&tpk=9b-20-979-149)  
- [AI100E 1 TB M.2](https://www.neweggbusiness.com/product/product.aspx?item=9b-20-979-047&tpk=9b-20-979-047)  
- [AI100E 2 TB M.2](https://www.neweggbusiness.com/product/product.aspx?item=9b-20-979-049&tpk=9b-20-979-049)  
- [AI100E 1 TB U.2](https://www.neweggbusiness.com/product/product.aspx?item=9b-20-979-051&tpk=9b-20-979-051)  
- [AI100E 2 TB U.2](https://www.neweggbusiness.com/product/product.aspx?item=9b-20-979-054&tpk=9b-20-979-054)  

### 🌏 Asia Pacific

Please contact your **local Phison partners** for aiDAPTIV inquiries in regions outside the US (TW, CN, MY, ID, JP).  
*Note: aiDAPTIV Cache (SSD) is only sold through System Integrators as part of a full AI Training PC / Workstation / Server solution.*  

---

**Get in touch**
- 📩 **Sales/General**: `peter_cmaylo@phison.com`
- 🧪 **Free Trial**: `aaron_pham@phison.com`
- 🎓 **University outreach**: `aaron_pham@phison.com`

> After you receive access, follow the repo’s [Installation](Page_Sections/Installation/README.md) section to integrate aiDAPTIV middleware into your training or inference workflow.

---
For full installation steps, supported OS details, and performance tuning, see the [User Manual](assets/user_manual.pdf).

