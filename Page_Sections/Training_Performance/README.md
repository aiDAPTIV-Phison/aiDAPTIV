# 📊 aiDAPTIV Pro Suite Fine-Tuning Training Performance

These benchmarks measure **training throughput (tokens/s)** for **Llama 3.1 8B and 70B Instruct** models on various NVIDIA GPUs using **Phison aiDAPTIV Pro Suite 2.0.7**.  
All runs used the [Dolly Creative Writing dataset](https://huggingface.co/datasets/lionelchg/dolly_creative_writing), 1 epoch, 12 000 sequence length, and Triton ON.

---

### 🧠 Test System
| Component | Spec |
|:-----------|:------|
| CPU | Intel W5-3435X |
| Memory | 512 GB DDR5-4800 |
| Storage | 4 TB E18DC boot + 2× AI100 2 TB RAID 0 |
| OS | Ubuntu 24 |
| aiDAPTIV Pro Suite | v2.0.7 |

---

### 🚀 Fine-Tuning Performance Summary

| GPU | Model 8B (1×) Tokens/s | Model 8B (2×) Tokens/s | Model 70B (1×) Tokens/s | Model 70B (2×) Tokens/s |
|:----|:------------------------|:------------------------|:-------------------------|:-------------------------|
| RTX 5090 | 2 486 | — | 304 | — |
| RTX 5080 | 1 528 | — | 124 | — |
| RTX 4070 Ti Super | 1 169 | 2 315 | 93 | 215 |
| RTX 4000 Ada | 1 876 | 2 132 | 102 | 201 |
| RTX 5000 Ada | 2 097 | 3 977 | 223 | 434 |
| RTX 6000 Ada | 2 151 | 3 854 | 230 | 446 |
| RTX 6000 Pro (Max Q) | 3 402 | 6 269 | 377 | 718 |

---

### ⚙️ Notes
- **Batch sizes** scale roughly ×2 when doubling GPUs.  
- Reducing **Max Seq Len** increases tokens/s.  
- Throughput scales near-linearly up to 4 GPUs.  
- Use this guide for relative comparison only.
