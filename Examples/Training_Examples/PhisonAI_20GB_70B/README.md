# 🧠 PhisonAI 70B Fine-Tuning (Meta-Llama-3.1-70B-Instruct)

This guide fine-tunes **Meta-Llama-3.1-70B-Instruct** on **aiDAPTIV+** using the **Dahoas/rm-static** dataset.

You can run this example in **three ways**:

1. **⭐ Recommended:** Native installation with a Python virtual environment (no Docker required)  
2. **Optional:** Docker wrapper script (`phisonai2` as a host-side shortcut)  
3. **Optional:** Direct `docker run` command

> **Note:** All methods use the **same YAML configs** (`env_config.yaml`, `exp_config.yaml`, `QA_dataset_config.yaml`). Only the *launch method* changes.

---

## 🧩 Test Environment (Verified Configuration)

This fine-tuning example was verified on the following system configuration:

| Component | Specification |
|----------|----------------|
| **aiDAPTIV+ SSD** | 2 TB Phison AI100 |
| **GPU** | 2 × NVIDIA RTX 4000 ADA (20 GB) |
| **System Memory (DRAM)** | 128 GB |
| **Host Environment** | Ubuntu 24.04.3 |
| **aiDAPTIV+ Stack Version** | `vNXUN_2_04_A1` |

> ⚠️ **70B is large.** This config assumes **aiDAPTIV+ NVMe offload** is available and properly configured.  
> If you hit OOM or instability, reduce batch size further (see notes in `exp_config.yaml`).

---

## 1) Prerequisites (All Methods)

- NVIDIA GPU with drivers installed  
- NVMe SSD mounted (e.g., `/mnt/nvme0`) for aiDAPTIV+ cache  
- 70B model files available at (or symlinked to):  
  `/home/{username}/workspace/models/Meta-Llama-3.1-70B-Instruct`  
- This example folder downloaded locally (configs + scripts), such as:

```text
https://github.com/atp224/aiDAPTIVTestPage/tree/main/Repository_Files/Training_Examples/PhisonAI_20GB_70B
```

Open a terminal inside this folder before proceeding.

---

# ⭐ Method 1: Native Installation + Python VENV (Recommended)

This is the **simplest** way to run this training example once the middleware is installed.

---

## 2) Create & activate a Python virtual environment

```bash
sudo apt install python3-venv
python3 -m venv ~/aidaptiv-venv
source ~/aidaptiv-venv/bin/activate
```

Your shell should show:

```text
(aidaptiv-venv) phison@hostname:~$
```

---

## 3) Install the aiDAPTIV Middleware (Native)

With the VENV active:

```bash
wget https://phisonbucket.s3.ap-northeast-1.amazonaws.com/setup_vNXUN_2_04_A1.sh
bash setup_vNXUN_2_04_A1.sh
```

This script will:

- Install aiDAPTIV middleware  
- Register the `phisonai2` launcher inside your VENV  
- Configure dependencies for training and inference

Verify installation:

```bash
phisonai2 -h
```

---

## 4) Configure `env_config.yaml`

Inside this example folder:

```yaml
path_settings:
  lora:
    lora_weight: ""          # optional
    lora_optimizer: ""       # optional
    lora_output_dir: ""      # optional

  model_name_or_path: "/home/{username}/workspace/models/Meta-Llama-3.1-70B-Instruct"
  multi_node_env_path: null
  optimizer_path: ""

  train_data_path:
    - ./QA_dataset_config.yaml

  val_data_path: null

  nvme_path: "/mnt/nvme0"
  output_dir: "output/"
  log_name: "output/PhisonAI_20GB_70B.log"
```

Replace `{username}` with your real Linux username.

---

## 5) Configure `exp_config.yaml` (70B Settings)

This example uses safe defaults for 70B:

```yaml
process_settings:
  num_gpus: 1
  specify_gpus: "0"
  master_port: 8299
  multi_node_settings:
    enable: False
    master_addr: "127.0.0.1"

run_settings:
  task_type: "text-generation"
  task_mode: "train"
  per_device_train_batch_size: 2
  per_update_total_batch_size: 20
  num_train_epochs: 1
  max_iter: -1
  max_seq_len: 4096
  triton: True
  weight_file_format: null
  from_config: false
  precision_mode: 1
  enable_save_optimizer_state: false

  model_saver:
    max_num_of_saved_model_on_epoch_end: -1
    enable_save_model_on_iteration: false
    max_num_of_saved_model_on_iteration: 2
    num_of_iteration_to_save_model: 2

  lr_scheduler:
    mode: 1
    learning_rate: 0.000007

  optimizer:
    beta1: 0.9
    beta2: 0.95
    eps: 0.00000001
    weight_decay: 0.01

  early_stop:
    enable: false
    min_delta: 0.01
    patience: 2
    verbose: false

  lora:
    enable_lora: false
    lora_rank: 8
    lora_alpha: 16
    lora_task_type: "CAUSAL_LM"
    lora_target_modules: null
```

> ⚠️ If you see OOM errors, reduce to:  
> `per_device_train_batch_size: 1`  
> `per_update_total_batch_size: 10`

---

## 6) Dataset setup (`QA_dataset_config.yaml`)

This example uses the **Dahoas/rm-static** dataset in a QA-style training setup.

---

### **Option A: Auto-download via Hugging Face**

```yaml
rm-static:
  data_path: "Dahoas/rm-static"
  strategy: "QA"
  system_prompt: ""
  user_prompt: "{question}"
  question_key: "instruction"
  answer_key: "response"
  label_key: "response"
  exp_type: train
```

Middleware will cache the dataset under:

```text
~/.cache/huggingface/datasets
```

You only need to adjust the `data_path` line.

---

### **Option B: Local dataset copy**

```bash
git lfs install
git clone https://huggingface.co/datasets/Dahoas/rm-static
mkdir -p ~/workspace/dataset
mv rm-static ~/workspace/dataset/
```

Then set:

```yaml
rm-static:
  data_path: "/home/{username}/workspace/dataset/rm-static"
  strategy: "QA"
  system_prompt: ""
  user_prompt: "{question}"
  question_key: "instruction"
  answer_key: "response"
  label_key: "response"
  exp_type: train
```

---

## 7) Run the fine-tuning job (Native + VENV)

With the VENV active:

```bash
phisonai2 --env_config env_config.yaml --exp_config exp_config.yaml
```

Logs:

```text
output/PhisonAI_20GB_70B.log
```

Follow logs live:

```bash
tail -F output/PhisonAI_20GB_70B.log
```

Expected output:

```text
[INFO] You are loading [LlamaForCausalLM] with FlashAttention2
[PHISON START] Epoch: 0, Iteration: 0
[Loss]: ...
```

---

# Method 2: Docker Wrapper Script (Optional)

This mirrors the 8B example but uses the 70B configs.

---

## 8) Create the `phisonai2` Docker wrapper

```bash
mkdir -p "$HOME/bin"

cat > "$HOME/bin/phisonai2" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
IMAGE="licensesp/aidaptiv:vNXUN_2_04_A1"

docker run --rm -it   --gpus "device=0"   --ipc=host --privileged=true   --ulimit memlock=-1 --ulimit stack=67108864   --network=host   --entrypoint /bin/bash   -v "$PWD:/workspace"   -v "/home/$USER/workspace:/home/$USER/workspace"   -v "/usr/local/models:/usr/local/models"   -v "/mnt/nvme0:/mnt/nvme0"   -v /dev/mapper:/dev/mapper   "$IMAGE" -lc 'set -euo pipefail; cd /workspace; mkdir -p .nvme_cache vlm_model; phisonai2 "$@"'
EOF
```

```bash
chmod +x "$HOME/bin/phisonai2"
```

Add to PATH:

```bash
export PATH="$HOME/bin:$PATH"
```

---

## 9) Run training via wrapper + Docker

```bash
phisonai2 --env_config env_config.yaml --exp_config exp_config.yaml
```

---

# Method 3: Direct Docker Command (Optional)

```bash
docker run --rm -it   --gpus "device=0"   --ipc=host --privileged=true   --ulimit memlock=-1 --ulimit stack=67108864   --network=host   -v "$PWD:/workspace"   -v "/home/$USER/workspace:/home/$USER/workspace"   -v "/usr/local/models:/usr/local/models"   -v "/mnt/nvme0:/mnt/nvme0"   -v /dev/mapper:/dev/mapper   licensesp/aidaptiv:vNXUN_2_04_A1   bash -lc 'cd /workspace && mkdir -p .nvme_cache vlm_model && phisonai2 --env_config env_config.yaml --exp_config exp_config.yaml'
```

---

# 12) Common Issues & Quick Fixes (70B-specific notes)

| Message / Symptom | Why it happens | Fix |
|-------------------|----------------|-----|
| Nothing prints in terminal | Logs written to file | `tail -F output/PhisonAI_20GB_70B.log` |
| Permission denied in NVMe | Root-owned mount | `sudo chown -R $USER:$USER /mnt/nvme0` |
| HF dataset permission error | Cache owned by root | `sudo chown -R $USER:$USER ~/.cache/huggingface` |
| NCCL hangs | Multi-GPU mismatch | Use `num_gpus: 1`, `specify_gpus: "0"` |
| CUDA OOM | 70B memory pressure | Lower batch size or seq length |

---

## Notes

- The **native VENV method** is recommended for most users.  
- 70B models require careful tuning of batch size and sequence length.  
- aiDAPTIV+ offload enables large-model training even with limited GPU VRAM.  

✅ Once you see training iterations and loss values in the log file, your **aiDAPTIV+ 70B fine-tuning setup is working correctly**.
