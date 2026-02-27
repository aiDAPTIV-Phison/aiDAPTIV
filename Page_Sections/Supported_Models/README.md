# Supported Models

## 📦 Supported Model Formats

aiDAPTIV middleware currently supports the following model weight file formats for loading pretrained models:

- `.safetensors`
- `.bin`
- `.pt`
- `.pth`
- `None` *(auto-detects available file format)*

> ⚠️ Formats such as `.gguf` (used by llama.cpp) are **not** currently supported.

When `weight_file_format` is not explicitly specified, aiDAPTIV middleware will automatically detect the available format in the model directory.

Only PyTorch-compatible models are supported in this version.

## ✅ Supported Models

The following models have been validated to run with aiDAPTIV middleware. Triton support indicates whether the model can be deployed using NVIDIA Triton Inference Server.

| #  | Task                    | Model Name                        | Triton Support |
|----|-------------------------|-----------------------------------|----------------|
| 1  | Text Generation         | Llama-2-7b-hf                     | ✅             |
| 2  | Text Generation         | Llama-2-13b-hf                    | ✅             |
| 3  | Text Generation         | Llama-2-70b-hf                    | ✅             |
| 4  | Text Generation         | Meta-Llama-3-8B                  | ✅             |
| 5  | Text Generation         | Meta-Llama-3-70B                 | ✅             |
| 6  | Text Generation         | Mistral-7B-Instruct-v0.1         | ✅             |
| 7  | Text Generation         | Mixtral-8x7B-Instruct-v0.1       | ✅             |
| 8  | Text Generation         | Mixtral-8x22B-Instruct-v0.1      | ✅             |
| 9  | Text Generation         | CodeLlama-7b-hf                  | ✅             |
| 10 | Text Generation         | Phind-CodeLlama-34B-v1           | ✅             |
| 11 | Text Generation         | CodeLlama-70b-hf                 | ✅             |
| 12 | Text Generation         | LlamaGuard-7b                    | ✅             |
| 13 | Text Generation         | falcon-180B                      | ❌             |
| 14 | Text Generation         | ko-llm-llama-2-7b-LoRA-IA3       | ✅             |
| 15 | Text Generation         | b.11.0.0                         | ❌             |
| 16 | Text Generation         | vicuna-33b-v1.3                  | ✅             |
| 17 | Text Generation         | Breeze-7B-Instruct-v0            | ✅             |
| 18 | Speech Recognition      | whisper-large-v2                 | ✅             |
| 19 | Text Generation         | Qwen1.5-0.5B-Chat                | ✅             |
| 20 | Text Generation         | Qwen1.5-1.8B-Chat                | ✅             |
| 21 | Text Generation         | Qwen1.5-4B-Chat                  | ✅             |
| 22 | Text Generation         | Qwen1.5-7B-Chat                  | ✅             |
| 23 | Text Generation         | Qwen1.5-14B-Chat                 | ✅             |
| 24 | Text Generation         | Qwen1.5-72B-Chat                 | ✅             |
| 25 | Text Generation         | Qwen1.5-110B-Chat                | ❌             |
| 26 | Text Generation         | Yi-1.5-6B                        | ✅             |
| 27 | Text Generation         | Yi-1.5-9B-Chat                   | ✅             |
| 28 | Text Generation         | Yi-1.5-34B-Chat                  | ✅             |
| 29 | Text Generation         | deepseek-llm-7b-chat             | ✅             |
| 30 | Text Generation         | deepseek-moe-16b-chat            | ✅             |
| 31 | Text Generation         | deepseek-llm-67b-chat            | ✅             |
| 32 | Text Generation         | Yuan2-M32-hf                     | ❌             |
| 33 | Text Generation         | Baichuan-7B                      | ✅             |
| 34 | Text Generation         | chatglm-6b                       | ✅             |
| 35 | Text Generation         | Qwen2-72B                        | ✅             |
| 36 | Fill-Mask               | bert-base-uncased                | ✅             |
| 37 | Text Generation         | glm-4-9b                         | ✅             |
| 38 | Text Generation         | Qwen2-7B                         | ✅             |
| 39 | Text Generation         | Qwen2-72B-Instruct               | ✅             |
| 40 | Text Generation         | Baichuan2-7B-Chat                | ✅             |
| 41 | Text Generation         | DeepSeek-Coder-V2-Instruct       | ✅             |
| 42 | Text Generation         | chatglm3-6b                      | ✅             |
| 43 | Text Generation         | glm-4-9b-chat                    | ✅             |
| 44 | Text Generation         | Llama-3.1-8B-Instruct            | ✅             |
| 45 | Text Generation         | Meta-Llama-3.1-70b-Instruct      | ✅             |
| 46 | Text Generation         | Gemma2-9b-it                     | ✅             |
| 47 | Text Generation         | Gemma2-27b-it                    | ✅             |
| 48 | Text Generation         | Llama-3-Taiwan-70B-Instruct      | ✅             |
| 49 | Image-Text-to-Text      | InternVL2-1B                     | ✅             |
| 50 | Image-Text-to-Text      | InternVL2-2B                     | ✅             |
| 51 | Image-Text-to-Text      | InternVL2-4B                     | ✅             |
| 52 | Image-Text-to-Text      | InternVL2-8B                     | ✅             |
| 53 | Image-Text-to-Text      | InternVL2-26B                    | ✅             |
| 54 | Image-Text-to-Text      | InternVL2-40B                    | ✅             |
| 55 | Image-Text-to-Text      | InternVL2-Llama3-76B             | ✅             |
| 56 | Image-Text-to-Text      | Llama-3.2-11B-Vision-Instruct    | ✅             |
| 57 | Image-Text-to-Text      | Llama-3.2-90B-Vision-Instruct    | ✅             |
| 58 | Image-Text-to-Text      | llava-1.5-7b-hf                  | ✅             |
| 59 | Image-Text-to-Text      | llava-1.5-13b-hf                 | ✅             |
| 60 | Image-Text-to-Text      | Qwen2-VL-2B-Instruct             | ✅             |
| 61 | Image-Text-to-Text      | Qwen2-VL-7B-Instruct             | ✅             |
| 62 | Image-Text-to-Text      | Qwen2-VL-72B-Instruct            | ✅             |
| 63 | Text Generation         | Qwen2.5-72B-Instruct             | ✅             |
| 64 | Text Generation         | Pixtral-12B                      | ✅             |
| 65 | Text Generation         | Smaug-72B-v0.1                   | ✅             |
| 66 | Text Generation         | chameleon-7b                    | ✅             |
| 67 | Text Generation         | chameleon-30b                   | ✅             |
| 68 | Text Generation         | Phi-3-vision-128k-instruct       | ✅             |
| 69 | Text Generation         | Phi-3.5-vision-instruct          | ✅             |
| 70 | Text Generation         | Llama-3.3-70B-Instruct           | ✅             |
| 71 | Text Generation         | DeepSeek-R1-Distill-Llama-70B    | ✅             |
| 72 | Text Generation         | DeepSeek-R1-Distill-Qwen-32B     | ✅             |
| 73 | Text Generation         | QwQ-32B                          | ✅             |
| 74 | Text Generation         | LongWriter-glm-9b               | ✅             |
| 75 | Text Generation         | Qwen-2-0.5B                     | ✅             |
| 76 | Text Generation         | Qwen2.5-0.5B-Instruct            | ✅             |
| 77 | Text Generation         | Llama-3.2-3B-Instruct            | ✅             |
| 78 | Image-Text-to-Text      | llava-v1.6-vicuna-7b-hf          | ✅             |
| 79 | Text Generation         | Phi-3.5-mini-instruct            | ✅             |
| 80 | Text Generation         | grantie-3.0-8b-instruct          | ✅             |
| 81 | Text Generation         | gemma-3-1b-it                    | ✅             |
| 82 | Text Generation         | gemma-3-27b-it                   | ✅             |
| 83 | Speech Recognition      | whisper-large-v3-turbo           | ✅             |
| 84 | Image-Text-to-Text      | Qwen2.5-VL-7B-Instruct           | ✅             |
| 85 | Image-Text-to-Text      | Qwen2.5-VL-72B-Instruct          | ✅             |
| 86 | Text Generation         | Phi-4                            | ✅             |
| 87 | Text Generation         | Phi-4-reasoning                  | ✅             |
| 88 | Text Generation         | Qwen3-0.6B                       | ✅             |
| 89 | Text Generation         | Qwen3-32B                        | ✅             |
| 90 | Text Generation         | Mistral-Small-3.1-24B-Instruct   | ✅             |
| 91 | Text Generation         | Deepseek-v3-bf16                 | ✅             |

---

> ✅ = Triton-compatible  
> ❌ = Currently not supported via Triton

