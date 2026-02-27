# 🧠 PhisonAI 8B Fine-Tuning (Meta-Llama-3.1-8B-Instruct)

This guide fine-tunes **Meta-Llama-3.1-8B-Instruct** on **aiDAPTIV** using the **Dahoas/rm-static** dataset.

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
| **Pascari AI-Series cache memory** | 320 GB Phison AI100 |
| **GPU** | 2 × NVIDIA RTX 4000 ADA (20 GB each) |
| **System Memory (DRAM)** | 128 GB |
| **Host Environment** | Ubuntu 24.04.3 |
| **aiDAPTIV Stack Version** | `vNXUN_2_04_A1` |

---

## 1) Prerequisites (All Methods)

- NVIDIA GPU with drivers installed  
- NVMe SSD mounted (e.g., `/mnt/nvme0`) for Pascari AI-Series cache memory  
- Model files available at (or symlinked to):  
  ` /home/{username}/workspace/models/Meta-Llama-3.1-8B-Instruct`  
- This example folder downloaded locally (configs + scripts):

```text
https://github.com/aiDAPTIV-Phison/aiDAPTIV/tree/main/Examples/Training_Examples/PhisonAI_20GB_8B
```

Open a terminal in that folder before proceeding.

---

# ⭐ Method 1: Native Installation + Python VENV (Recommended)

This is the **simplest and fastest** way to run this training example. No Docker is required once the middleware is installed.

---

## 2) Create & activate a Python virtual environment

```bash
sudo apt install python3-venv
python3 -m venv ~/aidaptiv-venv
source ~/aidaptiv-venv/bin/activate
```

Your shell prompt should show something like:

```text
(aidaptiv-venv) phison@hostname:~$
```

> You must activate this VENV before running `phisonai2` natively.

---

## 3) Install the aiDAPTIV Middleware (Native)

With the VENV active:

```bash
wget https://phisonbucket.s3.ap-northeast-1.amazonaws.com/setup_vNXUN_2_04_A1.sh
bash setup_vNXUN_2_04_A1.sh
```

This script will:

- Install aiDAPTIV middleware under something like `/home/{username}/aiDAPTIV2`  
- Register the `phisonai2` launcher inside your active VENV  
- Configure dependencies required for training/inference

Verify installation:

```bash
phisonai2 -h
```

You should see the `phisonai2` CLI help.

---

## 4) Configure `env_config.yaml`

In this example folder, open `env_config.yaml` and ensure:

```yaml
path_settings:
  lora:
    lora_weight: ""          # optional: load LoRA weights
    lora_optimizer: ""       # optional: load LoRA optimizer state
    lora_output_dir: ""      # optional: where to save LoRA weights
  model_name_or_path: "/home/{username}/workspace/models/Meta-Llama-3.1-8B-Instruct"
  multi_node_env_path: null
  optimizer_path: ""         # optional: load optimizer state
  train_data_path:
    - ./QA_dataset_config.yaml
  val_data_path: null

  nvme_path: "/mnt/nvme0"
  output_dir: "output/"
  log_name: "output/PhisonAI_20GB_8B.log"
```

Replace `{username}` with your actual Linux username.

> 💡 If your NVMe is mounted somewhere else (e.g., `/mnt/nvme1`), change `nvme_path` accordingly.

---

## 5) Configure `exp_config.yaml`

Open `exp_config.yaml` in this example folder and verify these key fields:

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
  per_device_train_batch_size: 8
  per_update_total_batch_size: 160
  num_train_epochs: 1
  max_iter: -1
  max_seq_len: 12000
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

For a simple first run, keeping `num_gpus: 1` and `specify_gpus: "0"` is recommended.

---

## 6) Dataset setup (QA_dataset_config.yaml)
This example uses the Dahoas/rm-static dataset in a QA-style training configuration.

### Option A: Auto-download via Hugging Face

Your QA_dataset_config.yaml should contain:

```yaml
rm-static:
  data_path: "Dahoas/rm-static"   # HF dataset to auto-download
  strategy: "QA"
  system_prompt: ""
  user_prompt: "{question}"
  question_key: "instruction"
  answer_key: "response"
  label_key: "response"
  exp_type: train
```

The middleware will download and cache the dataset under `~/.cache/huggingface/datasets`.

### Option B: Local dataset copy

```bash
git lfs install
git clone https://huggingface.co/datasets/Dahoas/rm-static
mkdir -p ~/workspace/dataset
mv rm-static ~/workspace/dataset/
```

Then set in `QA_dataset_config.yaml`:

```yaml
data_path: "/home/{username}/workspace/dataset/rm-static"
```

Again, replace `{username}` with your actual login.

---

## 7) Run the fine-tuning job (Native + VENV)

From this example folder, with your VENV active:

```bash
phisonai2 --env_config env_config.yaml --exp_config exp_config.yaml
```

Training logs are written to:

```text
output/PhisonAI_20GB_8B.log
```

To follow the logs in real time:

```bash
tail -F output/PhisonAI_20GB_8B.log
```

When things are working correctly, you should see log lines similar to:

```text
[INFO] You are loading [LlamaForCausalLM] with FlashAttention2
[PHISON START] Epoch: 0, Iteration: 0
[Loss]: ...
```

---

# Method 2: Docker Wrapper Script (Optional)

If you prefer to keep everything inside a Docker container, you can use a **wrapper script** on the host that internally calls `docker run` with the correct volumes and options.

> This method is similar to the original version of this example that used `phisonai2` as a Docker front-end.

---

## 8) Create the `phisonai2` Docker wrapper

On the host:

```bash
mkdir -p "$HOME/bin"

cat > "$HOME/bin/phisonai2" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
IMAGE="licensesp/aidaptiv:vNXUN_2_04_A1"

docker run --rm -it   --gpus "device=0"   --ipc=host --privileged=true   --ulimit memlock=-1 --ulimit stack=67108864   --network=host   --entrypoint /bin/bash   -v "$PWD:/workspace"   -v "/home/$USER/workspace:/home/$USER/workspace"   -v "/usr/local/models:/usr/local/models"   -v "/mnt/nvme0:/mnt/nvme0"   -v /dev/mapper:/dev/mapper   "$IMAGE" -lc 'set -euo pipefail; cd /workspace; mkdir -p .nvme_cache vlm_model; phisonai2 "$@"'
EOF

chmod +x "$HOME/bin/phisonai2"
```

Make sure `~/bin` is on your PATH (e.g., in `~/.bashrc`):

```bash
export PATH="$HOME/bin:$PATH"
```

Reload your shell or source your bashrc:

```bash
source ~/.bashrc
```

---

## 9) Run training via wrapper + Docker

From the example folder on the **host**:

```bash
phisonai2 --env_config env_config.yaml --exp_config exp_config.yaml
```

Inside the container:

- `/workspace` maps to the example folder  
- `/home/$USER/workspace` maps to host workspace (models/datasets)  
- `/usr/local/models` and `/mnt/nvme0` are also mounted

Training logs and behavior are the same as in the native method. Logs still go to:

```text
output/PhisonAI_20GB_8B.log
```

You can follow them from the host:

```bash
tail -F output/PhisonAI_20GB_8B.log
```

---

# Method 3: Direct Docker Command (Optional)

You can also launch the container manually without a wrapper.

---

## 10) One-shot foreground run

From the example folder on the host:

```bash
docker run --rm -it   --gpus "device=0"   --ipc=host --privileged=true   --ulimit memlock=-1 --ulimit stack=67108864   --network=host   -v "$PWD:/workspace"   -v "/home/$USER/workspace:/home/$USER/workspace"   -v "/usr/local/models:/usr/local/models"   -v "/mnt/nvme0:/mnt/nvme0"   -v /dev/mapper:/dev/mapper   licensesp/aidaptiv:vNXUN_2_04_A1   bash -lc 'cd /workspace && mkdir -p .nvme_cache vlm_model && phisonai2 --env_config env_config.yaml --exp_config exp_config.yaml'
```

To use all GPUs in the container:

- Change `--gpus "device=0"` → `--gpus all`  
- Update `process_settings` in `exp_config.yaml`:
  ```yaml
  num_gpus: 4
  specify_gpus: "0,1,2,3"
  ```

---

## 11) Detached run + host-side log tail (Optional)

Run the container in the background and write logs to a file:

```bash
CONTAINER_NAME=aidaptiv-train
LOG_FILE="$PWD/output/train.log"

mkdir -p output

sudo docker run -d --rm   --name "$CONTAINER_NAME"   --gpus "device=0"   --ipc=host --privileged=true   --ulimit memlock=-1 --ulimit stack=67108864   --network=host   -v "$PWD:/workspace"   -v "/home/$USER/workspace:/home/$USER/workspace"   -v "/usr/local/models:/usr/local/models"   -v "/mnt/nvme0:/mnt/nvme0"   -v /dev/mapper:/dev/mapper   licensesp/aidaptiv:vNXUN_2_04_A1   bash -lc 'set -euo pipefail; cd /workspace; mkdir -p .nvme_cache vlm_model output; phisonai2 --env_config env_config.yaml --exp_config exp_config.yaml 2>&1 | tee -a output/train.log'
```

Follow the log file from the host:

```bash
tail -F "$LOG_FILE"
```

Stop the container when done:

```bash
docker stop "$CONTAINER_NAME"
```

---

# 12) Common Issues & Quick Fixes

| Message / Symptom | Why it happens | Fix |
|-------------------|----------------|-----|
| Nothing prints in terminal after checkpoint load | Training logs are written to a file | Use `tail -F output/PhisonAI_20GB_8B.log` |
| `Permission denied` under `/mnt/nvme0/.process_table.bin.lock` | NVMe mount owned by root | `sudo chown -R $USER:$USER /mnt/nvme0` or use a user subdir and point `nvme_path` there |
| `PermissionError` in `~/.cache/huggingface/datasets` | Cache created by another user/root | `sudo chown -R $USER:$USER ~/.cache/huggingface` |
| NCCL warnings / hangs with multiple ranks | Multi-GPU config mismatch | Start with `num_gpus: 1`, `specify_gpus: "0"` |
| Dataset not found | Wrong `data_path` | Use `data_path: "Dahoas/rm-static"` or an absolute local path |

---

## Notes

- The **native VENV method** is now the recommended path for most users.  
- Docker-based methods are provided for environments where native install is restricted or containerization is required.  
- You can adjust batch size, sequence length, epochs, and LoRA parameters in `exp_config.yaml` to tune performance and memory use.

✅ Once you see training iterations and loss values in the log file, your **aiDAPTIV 8B fine-tuning setup is working correctly**.
