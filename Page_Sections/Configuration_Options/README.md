# Configuration Options

## YAML Options

aiDAPTIVLink uses YAML files to define datasets, environment variables, and training parameters.  
These files must follow the expected format for smooth operation.

**Common Keys Across Datasets**
- `data_path` → Local file path or Hugging Face dataset repository name  
- `strategy` → Dataset type (`qa`, `pretrain`, `rag`, `vqa`)  
- `system_prompt` → (Optional) system-level instruction for training  
- `user_prompt` → Training prompt; must include `{question}` (and `{rag}` if using RAG)  
- `question_key` → Column key for questions (QA, RAG)  
- `answer_key` → Column key for answers (QA, RAG)  
- `rag_key` → Nested key for retrieval context in RAG datasets (e.g., `context.sentences`)  
- `image_key` → Column key for images in multimodal (VQA) datasets  
- `text` → Column key for pretraining text  
- `exp_type` → Defines the purpose: `train`, `inference`, or `eval`  
- `label_key` → Usually the same as `answer_key`  

**Formatting Rules**
- Each dataset entry must have a **unique name**.  
- Separate multiple datasets in one file using `---`.  
- For multi-turn chat datasets:  
  ```yaml
  question_key: [q1, q2, q3]
  answer_key: [a1, a2, a3]
  ```
---

## Command Line Options

The aiDAPTIV Toolkit includes CLI commands for performance testing, training, and running models.  
These commands interact with the YAML configs you define.

---

### Performance Testing

```bash
python3 aidaptest_run.py --t 1
```

**Type values:**  
- `--t 1` → Test performance  
- `--t 2` → Find max batch size  
- `--t 3` → Find max batch size + test performance

### Docker Run Example

```bash
docker run --gpus all -it --ipc=host --privileged=true --ulimit memlock=-1 \
  -v /data:/data aiDAPTIV_vNXUN_2_03_00
```

### Training Settings

These options are typically set in the `project.ini` or YAML files and passed automatically:

- `num_gpus` → Number of GPUs to use  
- `model_name_or_path` → Path to pretrained model  
- `nvme_path` → Path to aiDAPTIVCache device (e.g., `/mnt/nvme0`)  
- `seq_len` → Sequence length for training (e.g., `2048`)  
- `start_bs` / `end_bs` → Batch size range for testing  
- `training_hour` → Expected training time  
- `triton` → Enable Triton inference server (`True`/`False`)  

> ⚡ Advanced parameters like **learning rate**, **optimizer settings**, and **LoRA rank** are also YAML-configurable and do not need to be passed manually at the CLI.

---

## Dataset Considerations

aiDAPTIVLink supports multiple dataset strategies for training, evaluation, and inference.  
Datasets can be local or pulled directly from Hugging Face, and must be defined in YAML configuration files.

---

### Supported Dataset Types
- **QA datasets** – Question/Answer style datasets.  
- **Pretrain datasets** – Standard text corpora for pretraining.  
- **RAG datasets** – Retrieval-Augmented Generation (RAG) data that combines questions with external context.  
- **Multimodal datasets** – Visual Question Answering (VQA) and other multi-input data types.

---

### General Rules
- Each dataset entry requires a **unique name**.  
- Use `---` to separate multiple datasets in a YAML file.  
- Keys vary by dataset type, but every dataset requires at least:
  - `data_path` → local path or Hugging Face dataset repo name  
  - `strategy` → `qa`, `pretrain`, or `rag`  
  - `exp_type` → `train`, `inference`, or `eval`  

---

### Example: QA Dataset
```yaml
<DATASET_NAME>:
  data_path: local_or_hf_repo
  strategy: "qa"
  system_prompt:
  user_prompt: "answer the following question {question}"
  question_key: question
  answer_key: cot_answer
  exp_type: train
  label_key: cot_answer
```
---

### Example: RAG Dataset
```yaml
<DATASET_NAME>:
  data_path: local_or_hf_repo
  strategy: "rag"
  system_prompt:
  user_prompt: "Context: {rag}, based on the context answer the question: {question}"
  question_key: question
  answer_key: answer
  rag_key: context.sentences   # supports nested format
  exp_type: train
  label_key: answer
```
Note: For multi-turn chat datasets, convert into arrays, e.g.
question_key: [q1, q2, q3] and answer_key: [a1, a2, a3].

---

### Example: Pretrain Dataset
```yaml
<DATASET_NAME>:
  data_path: local_or_hf_repo
  strategy: "pretrain"
  system_prompt:
  user_prompt:
  text: text_column
  exp_type: train
```
---

### Example: Multimodal (VQA) Dataset
```yaml
<DATASET_NAME>:
  data_path: local_or_hf_repo
  strategy: "vqa"
  system_prompt:
  user_prompt: "Based on the image, answer the following question: {question}"
  question_key: question
  answer_key: answer
  image_key: image   # key pointing to the image field in dataset
  exp_type: train
  label_key: answer
```
Note: Multimodal datasets must include an image_key (or equivalent) that points to the image data source.
Supported formats: .json or .csv with references to image files.
---

## Importance of the Cache

aiDAPTIVCache is a **core requirement** for scaling LLM training and inference with aiDAPTIVLink.  
It provides **high-endurance SSD storage that acts as extended GPU memory (VRAM)**, enabling larger models to run efficiently even when GPU VRAM is limited.

---

#### Model Size Requirements
The amount of DRAM and aiDAPTIVCache needed scales with the size of the LLM:

| LLM Model Size | DRAM Requirement | aiDAPTIVCache Capacity | aiDAPTIVCache Count |
|----------------|------------------|-------------------------|----------------------|
| ≤ 13B          | 64 GB            | 1 TB                   | 1 |
| < 34B          | 64 GB            | 1 TB                   | 2 |
| < 70B          | 128 GB           | 2 TB                   | 2 |
| < 180B         | 128 GB           | 2 TB                   | 4 |

> ⚡ Recommendations:  
> • Use PCIe Gen4 (or higher) SSDs  
> • DRAM speed ≥ 2933 MHz  
> • At least 8 DRAM channels (e.g., 16 GB × 8)

---

#### PCIe Lane Planning
CPU PCIe lanes must support both GPUs and aiDAPTIVCache devices:

**Total PCIe lanes = (GPU count × 16) + (aiDAPTIVCache count × 4)**

**Example:**  
For 4 GPUs and a 70B LLM model (which requires 2 caches):  
**4 × 16 + 2 × 4 = 72 lanes**  
Your CPU and motherboard must provide at least **72 PCIe lanes** for optimal performance.

---

#### Why aiDAPTIVCache Matters
- **VRAM Extension** – Provides additional memory capacity beyond GPU VRAM by leveraging high-endurance SSDs.  
- **Performance Scaling** – Supports larger batch sizes and stable training throughput for big models.  
- **Balanced Architecture** – Cache must be paired with sufficient DRAM, GPU power, and PCIe bandwidth; an imbalance can lead to bottlenecks or training failures.  

✅ **Bottom line:** aiDAPTIVCache is not optional — it **defines the maximum model size and efficiency** your system can realistically handle.

