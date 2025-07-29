<div align="center">

<a href="https://www.phison.com/en/aidaptiv-plus-ai-data-storage-solution">
  <img alt="aiDAPTIV+ logo" src="https://github.com/atp224/aiDAPTIVTestPage/blob/main/assets/aiDAPTIV_logo.jpg?raw=true" height="110" style="max-width: 100%;">
</a>
  
<a href="https://discord.gg/rJW6MS6m"><img src="https://github.com/atp224/aiDAPTIVTestPage/blob/main/assets/Discord_button.png?raw=true" width="165"></a>


### Finetune and Inference bigger Llama, Falcon, Deepseek models by using SSD Offload!

</div>

## What is aiDAPTIVLink?

**aiDAPTIVLink** is Phison’s middleware layer in the **aiDAPTIV+** stack that lets you train and run larger language models on your own hardware by leveraging high‑performance SSD caching alongside your GPU VRAM. In practice, it minimizes “out‑of‑memory” barriers for fine‑tuning and keeps I/O efficient during inference.

**Key capabilities**
- **Scale beyond VRAM limits:** Use fast NVMe storage as an extension to GPU memory so you can work with bigger models or longer context windows on the same hardware.
- **On‑prem by design:** Keep data local to your workstation, server, or lab cluster—no cloud dependency.
- **Minimal code changes:** Designed to drop into existing PyTorch workflows with little or no refactoring.
- **Lower time‑to‑first‑token (TTFT) at inference:** Storage‑aware scheduling reduces cold‑start stalls so responses begin faster.  
  > Note: aiDAPTIV+ removes memory bottlenecks for training, but it is **not** intended to speed up the core math of fine‑tuning itself.

---

## How to obtain

aiDAPTIVLink is distributed as part of the **aiDAPTIV+** offering.

- **Commercial availability:** Included with purchases of **aiDAPTIVCache** (Phison’s NVMe caching solution) for workstations and servers.  
- **Evaluation / pilots:** Reach out for a demo.
- **Academic programs:** Universities and student clubs can inquire about our outreach program for on‑prem testing.

**Get in touch**
- 📩 **Sales/General**: `peter_cmaylo@phison.com`
- 🧪 **Evaluation request**: `chris_ramseyer@phison.com`
- 🎓 **University outreach**: `aaron_pham@phison.com`

> After you receive access, follow the repo’s **Installation** and **Quickstart** sections to integrate aiDAPTIVLink into your training or inference workflow.
