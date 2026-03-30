# Supported Models

## Supported Model Formats

aiDAPTIV middleware currently supports the following model weight file formats for loading pretrained models:

- `.safetensors`
- `.bin`
- `.pt`
- `.pth`
- `None` *(auto-detects available file format)*

> ⚠️ Formats such as `.gguf` (used by llama.cpp) are not supported within aiDAPTIV middleware. llama.cpp-based workflows are supported separately outside of the middleware stack.

When `weight_file_format` is not explicitly specified, aiDAPTIV middleware will automatically detect the available format in the model directory.

Only PyTorch-compatible models (e.g., Hugging Face Transformers format) are supported in this version of aiDAPTIV middleware.

## Supported Models

> The following models have been validated through internal testing.  
> aiDAPTIV middleware may support additional PyTorch-compatible models beyond this list.

| #  | Task               | Model Name                   |
|----|--------------------|------------------------------|
| 1  | Text Generation    | Llama-2-7b-hf                |
| 2  | Text Generation    | Llama-2-13b-hf               |
| 3  | Text Generation    | Llama-2-70b-hf               |
| 4  | Text Generation    | Meta-Llama-3-8B              |
| 5  | Text Generation    | Meta-Llama-3-70B             |
| 6  | Text Generation    | Llama-3.1-8B-Instruct        |
| 7  | Text Generation    | Meta-Llama-3.1-70B-Instruct  |
| 8  | Text Generation    | Mistral-7B-Instruct-v0.1     |
| 9  | Text Generation    | Mixtral-8x7B-Instruct-v0.1   |
| 10 | Text Generation    | Mixtral-8x22B-Instruct-v0.1  |
| 11 | Text Generation    | CodeLlama-7b-hf              |
| 12 | Text Generation    | CodeLlama-70b-hf             |
| 13 | Text Generation    | Phind-CodeLlama-34B-v1       |
| 14 | Text Generation    | Qwen1.5-7B-Chat              |
| 15 | Text Generation    | Qwen1.5-14B-Chat             |
| 16 | Text Generation    | Qwen1.5-72B-Chat             |
| 17 | Text Generation    | Yi-1.5-6B                    |
| 18 | Text Generation    | Yi-1.5-34B-Chat              |
| 19 | Text Generation    | deepseek-llm-7b-chat         |
| 20 | Text Generation    | deepseek-llm-67b-chat        |
| 21 | Text Generation    | deepseek-moe-16b-chat        |
| 22 | Speech Recognition | whisper-large-v2             |

