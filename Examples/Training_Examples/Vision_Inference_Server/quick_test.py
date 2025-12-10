#!/usr/bin/env python3
import argparse
import base64
import mimetypes
from pathlib import Path
import random
from openai import OpenAI

def to_data_url(path: str) -> str:
    p = Path(path)
    if not p.exists():
        raise FileNotFoundError(f"Image not found: {p}")
    mime, _ = mimetypes.guess_type(p.name)
    if mime is None:
        mime = "image/jpeg"
    with open(p, "rb") as f:
        b64 = base64.b64encode(f.read()).decode("utf-8")
    return f"data:{mime};base64,{b64}"

def pick_random_image(folder="data/images/damaged-and-intact-packages"):
    exts = ["*.jpg", "*.jpeg", "*.png", "*.webp", "*.JPG", "*.JPEG", "*.PNG", "*.WEBP"]
    all_images = []
    for e in exts:
        all_images += list(Path(folder).rglob(e))
    if not all_images:
        raise FileNotFoundError(f"No images found under {folder}")
    return str(random.choice(all_images))

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--api-base", default="http://localhost:8501/v1")
    parser.add_argument("--model", default="Qwen/Qwen2.5-VL-3B-Instruct")
    parser.add_argument("--image", help="Path to an image file; if omitted, picks a random sample")
    parser.add_argument("--prompt", default="Identify any packaging damage and describe it briefly.")
    parser.add_argument("--tool-choice", default="auto", help="auto | none")
    parser.add_argument("--max-tokens", type=int, default=256)
    args = parser.parse_args()

    img_path = args.image or pick_random_image()
    print(f"Using image: {img_path}")

    client = OpenAI(base_url=args.api_base, api_key="dummy-key")

    data_url = to_data_url(img_path)

    messages = [
        {
            "role": "user",
            "content": [
                {"type": "text", "text": args.prompt},
                {"type": "image_url", "image_url": {"url": data_url}},
            ],
        }
    ]

    tools = [
        {
            "type": "function",
            "function": {
                "name": "report_damage",
                "description": "Record detected packaging damage",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "is_damaged": {"type": "boolean"},
                        "damage_type": {"type": "string"},
                        "severity": {"type": "string"},
                        "notes": {"type": "string"},
                    },
                    "required": ["is_damaged"],
                },
            },
        }
    ]

    resp = client.chat.completions.create(
        model=args.model,
        messages=messages,
        tools=tools,
        tool_choice=args.tool_choice,
        temperature=0.2,
        max_tokens=args.max_tokens,
    )

    choice = resp.choices[0]
    msg = choice.message
    print("\n=== Assistant ===")
    if getattr(msg, "tool_calls", None):
        print("(tool calls)")
        for tc in msg.tool_calls:
            print(f"- {tc.type} -> {tc.function.name}({tc.function.arguments})")
    if msg.content:
        print(msg.content)

if __name__ == "__main__":
    main()
