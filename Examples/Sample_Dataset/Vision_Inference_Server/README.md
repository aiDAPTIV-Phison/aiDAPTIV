# Vision Inference Server Sample Dataset

This folder contains the **sample image dataset** used by the [aiDAPTIV+ Vision Inference Sample](../../Training_Examples/Vision_Inference_Server/README.md).

The dataset provides example product packaging images for quick **vision-language model (VLM) inference testing** using `Qwen2.5-VL-3B-Instruct` and `vLLM`.

---

## Folder Structure

```
Vision_Inference_Server/
├── damaged-and-intact-packages/
│ ├── damaged/
│ ├── intact/
│ └── unrelated/
```


### Subfolder descriptions:
- **damaged/** — Images showing damaged product packaging.  
- **intact/** — Images showing undamaged (normal) product packaging.  
- **unrelated/** — Irrelevant or background images used for negative testing.

---

## Usage

These images are referenced by the inference example in:

```bash
Training_Examples/Vision_Inference_Server/quick_test.py
```


You can run inference on them directly or replace them with your own dataset to test different image scenarios.

---

> 📦 This dataset is intended for demo and validation purposes only.  
> It is not designed for training or large-scale benchmarking.


