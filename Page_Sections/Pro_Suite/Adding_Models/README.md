# Pro Suite 2.0  
## Guide: Accessing and Preparing LLMs from Hugging Face

📄 **Download PDF version:**  
[Click here to download the full guide (PDF)](https://github.com/aiDAPTIV-Phison/aiDAPTIV/blob/97718c9e0221acea62e4cc60f256cfe98ac789a6/assets/Phison%20aiDAPTIV%20ProSuite%202.0%20getting%20access%20to%20models%20on%20HuggingFace.pdf)

This document explains how to:

- Create a Hugging Face account  
- Request access to Meta Llama 3.x models  
- Generate a Hugging Face access token  
- Download LLMs using Linux CLI  
- Prepare and import models into Pro Suite  

Because of licensing restrictions, aiDAPTIV systems cannot ship with most LLMs pre-installed.  
This guide walks you through safely downloading and enabling them for fine-tuning and inference.

---

## 1. Introduction

aiDAPTIV provides the hardware and software required to fine-tune many of today’s most widely used LLMs.  
However, many models—such as Meta’s Llama models—require free licensing approval before use.

This guide uses **Llama 3.x** as the example model family.

---

## 2. Create a Hugging Face Account

1. Visit: https://huggingface.co  
2. Click **Sign Up**  
3. Enter email, password, and username  
4. Verify your account via the confirmation email

---

## 2.1. Optional: Join or Create an Organization

Creating or joining an organization allows teams (universities, labs, companies) to collaborate and share model access.

---

## 3. Accessing Models

Once logged in, navigate to the **Models** page at the top of HuggingFace and search:

```
meta-llama
```

---

## 3.1. Request Access to Meta Llama 3.x

Find the **Instruct** versions of the models, such as:

- Llama-3.2-1B-Instruct  
- Llama-3.2-3B-Instruct  
- Llama-3.1-8B-Instruct  
- Llama-3.1-70B-Instruct  
- Llama-3.1-405B-Instruct  

Each model requires accepting Meta’s community license.  
Click **“Expand to review and access”**, complete the form, and submit your request.  
Access is typically granted within minutes.

---

## 3.2. Generate a Hugging Face Access Token

Pro Suite uses Hugging Face tokens to authenticate downloads.

Steps:

1. Click your profile icon  
2. Select **Access Tokens**  
3. Create a new token  
4. Set permissions to **Read**  
5. Name the token  
6. Click **Create Token**  

Copy the token immediately—this is the only time it will be visible.

---

## 3.3. Downloading LLMs via Linux Commands

Run these commands in a Linux terminal, replacing:

```
[YOUR_API_KEY]
```

with your Hugging Face access token.

Do **not** use `sudo`—downloads will fail.

```bash
bash <(curl -sSL https://g.bodaay.io/hfd) -t [YOUR_API_KEY] download meta-llama/Llama-3.2-1B-Instruct
bash <(curl -sSL https://g.bodaay.io/hfd) -t [YOUR_API_KEY] download meta-llama/Llama-3.2-3B-Instruct
bash <(curl -sSL https://g.bodaay.io/hfd) -t [YOUR_API_KEY] download meta-llama/Llama-3.1-8B-Instruct
bash <(curl -sSL https://g.bodaay.io/hfd) -t [YOUR_API_KEY] download meta-llama/Llama-3.1-70B-Instruct
bash <(curl -sSL https://g.bodaay.io/hfd) -t [YOUR_API_KEY] download meta-llama/Llama-3.1-405B-Instruct
```

Downloaded models will appear under:

```
~/Storage/[model-name]
```

---

## 3.4. LLM Preparation

Once downloaded, models must be placed in Pro Suite’s model directory.

You have two options:

---

## Option A (Recommended): Copy Model Directly

1. Open a terminal  
2. Navigate to your model folder:

```bash
cd ~/Storage/meta-llama
```

3. Copy the model directory:

```bash
sudo cp -r Llama-3.1-8B-Instruct/ /usr/local/models/
```

Enter your root password when prompted.

---

## Option B: Upload a ZIP Archive

Use this if you plan to deploy models to multiple systems.

1. Navigate to the model folder  
2. Select all files  
3. Compress them into a `.zip` archive  
4. Open aiDAPTIV in your browser  
5. Go to **Models**  
6. Drag-and-drop the ZIP file or click to upload  
7. Wait for the system to decompress and install the model

---

## 4. Activating the Model

Once uploaded or copied:

1. Open Pro Suite  
2. Navigate to **Models**  
3. Find your newly added model  
4. Check the **Available** box to load it into memory  

After activation, the model is ready for fine‑tuning or inference.

---

## 5. Summary

This guide covered:

- Creating and configuring a Hugging Face account  
- Requesting access to restricted Meta Llama models  
- Generating a read-only access token  
- Downloading LLMs using Linux commands  
- Preparing models for aiDAPTIV 
- Activating models for use  

You now have everything required to bring your own LLMs into aiDAPTIV.

---


