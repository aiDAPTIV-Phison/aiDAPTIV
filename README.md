<div align="center">

<a href="https://www.phison.com/en/aidaptiv-plus-ai-data-storage-solution"><picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://github.com/aiDAPTIV-Phison/aiDAPTIV/blob/571b1d5108ea57f87ec3c9f40a9d38f2e028e166/assets/dark_logo.png">
    <source media="(prefers-color-scheme: light)" srcset="https://github.com/aiDAPTIV-Phison/aiDAPTIV/blob/571b1d5108ea57f87ec3c9f40a9d38f2e028e166/assets/light_logo.png">
    <img alt="aiDAPTIV+ logo" src="https://github.com/atp224/aiDAPTIVTestPage/blob/main/assets/aiDAPTIV_logo.jpg?raw=true" height="110" style="max-width: 100%;">
  </picture></a>

  
<a href="https://discord.gg/mJ3DtVWVCn"><img src="https://github.com/aiDAPTIV-Phison/aiDAPTIV/blob/571b1d5108ea57f87ec3c9f40a9d38f2e028e166/assets/Discord_button.png" width="165"></a>


### Finetune and Inference bigger Llama, Falcon, Deepseek models by using SSD Offload!

</div>

## What is aiDAPTIVLink?

**aiDAPTIVLink** is Phison’s middleware layer in the **aiDAPTIV+** stack that lets you train and run larger language models on your own hardware by leveraging high‑performance SSD caching alongside your GPU VRAM. In practice, it minimizes “out‑of‑memory” barriers for fine‑tuning and keeps I/O efficient during inference.

**Key capabilities**
- **Scale beyond VRAM limits:** Use fast NVMe storage as an extension to GPU memory so you can work with bigger models or longer context windows on the same hardware.
- **On‑prem by design:** Keep data local to your workstation, server, or lab cluster, no cloud dependency.
- **Minimal code changes:** Designed to drop into existing PyTorch workflows with little or no refactoring.
- **Lower time‑to‑first‑token (TTFT) at inference:** Storage‑aware scheduling reduces cold‑start stalls so responses begin faster.  
  > Note: aiDAPTIV+ removes memory bottlenecks for training, but it is **not** intended to speed up the core math of fine‑tuning itself.

---

## How to obtain

aiDAPTIVLink is distributed as part of the **aiDAPTIV+** offering.

- **Commercial availability:** Included with purchases of **aiDAPTIVCache** (Phison’s NVMe caching solution) for workstations and servers.  
- **Evaluation / pilots:** Reach out for a demo.
- **Academic programs:** Universities and student clubs can inquire about our outreach program for on‑prem testing.

---
**Information on how to install aiDAPTIVLink is found [here](Page_Sections/Installation/README.md)!**
---

## System Requirements

To ensure optimal performance and compatibility, aiDAPTIVLink requires the following hardware components:

### ✅ Compatible GPUs

aiDAPTIVLink is validated with the following NVIDIA GPUs (PCIe 4.0 x16):

| Vendor  | Product Name                        | Memory Type | Capacity  | Bus Width |
|---------|-------------------------------------|-------------|-----------|-----------|
| NVIDIA  | H200                                | HBM2e       | 80 GB     | 5120-bit  |
| NVIDIA  | H100                                | HBM2e       | 80 GB     | 5120-bit  |
| NVIDIA  | RTX A6000                           | GDDR6       | 48 GB     | 384-bit   |
| NVIDIA  | RTX A5000                           | GDDR6       | 24 GB     | 384-bit   |
| NVIDIA  | GeForce RTX 4090                    | GDDR6X      | 24 GB     | 384-bit   |
| NVIDIA  | GeForce RTX 4090 D                  | GDDR6X      | 24 GB     | 384-bit   |
| NVIDIA  | L40                                  | GDDR6       | 48 GB     | 384-bit   |
| NVIDIA  | L40S                                 | GDDR6       | 48 GB     | 384-bit   |
| NVIDIA  | RTX 6000 Ada Generation             | GDDR6       | 48 GB     | 384-bit   |
| NVIDIA  | RTX 5000 Ada Generation             | GDDR6       | 32 GB     | 256-bit   |
| NVIDIA  | RTX 4000 Ada Generation             | GDDR6       | 20 GB     | 160-bit   |
| NVIDIA  | RTX 4000 SFF Ada Generation         | GDDR6       | 20 GB     | 160-bit   |

> *Note: PCIe Gen 4 x16 bandwidth is recommended for optimal I/O throughput.*

---

### ✅ Compatible CPUs

aiDAPTIVLink has been tested with the following high-performance processors:

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

> *We recommend CPUs with high PCIe lane counts to support simultaneous GPU and SSD throughput.*

---

### ✅ Compatible aiDAPTIV+ Caching Device

aiDAPTIVLink requires the use of an **aiDAPTIVCache** SSD for storage-accelerated training and inference.

| Model     | Form Factor | Interface | Notes                         |
|-----------|-------------|-----------|-------------------------------|
| AI100E    | U.2 or M.2  | PCIe 4.0  | Required for aiDAPTIVLink use |

> *Ensure the AI100E SSD is properly installed in a PCIe Gen 4 compatible slot for peak performance.*

---

## Where to Buy

aiDAPTIV+ products are available through regional distributors.  
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

Please contact your **local Phison partners** for aiDAPTIV+ inquiries in regions outside the US (TW, CN, MY, ID, JP).  
*Note: aiDAPTIV Cache (SSD) is only sold through System Integrators as part of a full AI Training PC / Workstation / Server solution.*  

---

**Get in touch**
- 📩 **Sales/General**: `peter_cmaylo@phison.com`
- 🧪 **Evaluation request**: `chris_ramseyer@phison.com`
- 🎓 **University outreach**: `aaron_pham@phison.com`

> After you receive access, follow the repo’s [Installation](Page_Sections/Installation/README.md) section to integrate aiDAPTIVLink into your training or inference workflow.

---
For full installation steps, supported OS details, and performance tuning, see the [User Manual](assets/user_manual.pdf).

