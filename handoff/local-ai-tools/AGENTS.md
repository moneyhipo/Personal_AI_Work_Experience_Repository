# Local AI tools (image generation + local LLM) — setup recipe

Recorded 2026-11-18 on the desktop so the same setup can be repeated on the laptop (user request).
Desktop: RTX 3070 8 GB VRAM, 16 GB RAM, C: small (30 GB free) → everything goes on D:.
Laptop: C: has plenty of space; check GPU VRAM and RAM first (`nvidia-smi`, RAM in Task Manager) and pick the drive.

## 1. ComfyUI + MOSS-Image (text-to-image, also edit via LoRA)
- MOSS-Image: OpenMOSS, 5B DiT + Qwen3.5-9B text encoder, Apache-2.0 (commercial use OK). Repo `github.com/openmoss/moss-image`, ComfyUI weights `huggingface.co/Comfy-Org/MOSS-Image`. Native in ComfyUI (no plugin).
- Script: `setup_moss.sh` (this folder). Run it in a visible window (progress bars):
  `cmd //c start "MOSS-Image setup" //wait "C:\Program Files\Git\bin\bash.exe" /d/ai/setup_moss.sh`
  It clones ComfyUI to `D:\ai\ComfyUI`, makes a venv, installs torch cu128 + requirements, downloads ~17 GB, keeps pip/HF caches on D:. Change `ROOT` for another drive.
- Files chosen for 8 GB VRAM / 16 GB RAM: `moss_image_sft_int8_convrot` (5.4 GB), `qwen3.5_9b_int8_convrot` text encoder (9.8 GB), `flux2-vae`, edit LoRA `moss_image_edit_lora_rank_64_bf16`, community 8-step LoRA `lodestones/MOSS-Image-SFT-8-steps-dmd/lora.safetensors` (strength 1.0, no CFG). With more VRAM (≥16 GB) the bf16 files are better.
- Official numbers (diffusers, `--profile minimal`, 1024², 50 steps): GPU 3.85 GB, system RAM peak 14 GB. Close LLM apps and games while generating.
- Workflows: `D:\ai\workflows\image_moss_image_t2i.json`, `image_moss_image_edit.json` (Comfy-Org/workflow_templates). Defaults: 50 steps, CFG 3, shift 5, Euler/sgm_uniform.
- Measured 2026-11-18 (desktop, 1024², 25 steps, CFG 2.5, er_sde/simple, int8 files): first image 336 s total (≈220 s loading 15 GB of weights from D:, 110 s sampling at 4.4 s/step); GPU 100 %, 234 W, 79 °C, VRAM 7.3/8 GB; python ~6 GB RAM. Keep ComfyUI running between images. Result quality was good (prompt followed, clean white background).
- Start: `D:\ai\ComfyUI\venv\Scripts\python.exe main.py --listen 127.0.0.1 --port 8188`, submit API-format JSON to `/prompt` (example `D:\ai\test_prompt.json`; node types UNETLoader, CLIPLoader type `moss_image`, VAELoader, EmptyFlux2LatentImage, KSampler). Do not run Mem Reduct while it loads.
- GPU stuck in P0 (55-60 W idle, 1815 MHz) after some session; NVIDIA control panel reset did not help, reboot fixed it (P8, ~24 W). `nvidia-smi --query-gpu=pstate,power.draw --format=csv` to check.
- Changing Windows power settings (`powercfg`) was blocked by the auto-mode classifier; ask the user to do it in Settings.
- Qwen-Image (20B) was judged too heavy for 8 GB / 16 GB; MOSS chosen instead.

## 2. LM Studio "Bionic" (LM Studio renamed, signed by Element Labs Inc.)
- App at `D:\Bionic`. Settings: `%USERPROFILE%\.lmstudio\apps\bionic\settings.json` and `...\apps\bionic\.internal\settings.json`; classic LM Studio settings `%USERPROFILE%\.lmstudio\settings.json`; server `...\.lmstudio\.internal\http-server-config.json`.
- Script: `tune_bionic.py` (this folder). Edit it with the app closed; it backs up each file as `.bak_<time>`. What it sets:
  - models folder `D:\ai\lm-models` (and moves existing models there; on the laptop pick any roomy drive)
  - language ko, JIT model TTL 3600 → 600 s (frees RAM for image generation), default context 16384, resource widget on, deleted chats → trash, session-complete notification on, server `logSensitiveData` false
- Left alone (user's choice): agent `sessionAccess: operate`, web search on, external API models off.
- If the model list is empty after moving, set the folder once in 보관함 → 모델 디렉터리.
- Models on the desktop: Qwen3.5-9B Q4_K_M (main: vision + tools + reasoning, 16K fits 8 GB), Qwen3-4B-Instruct (fast), Qwen3-VL-4B (redundant with 9B).

## Laptop (user 2026-11-18: Intel integrated graphics only)
- Do not install MOSS/ComfyUI on the laptop: no NVIDIA GPU → minutes (Arc iGPU, PyTorch XPU) to tens of minutes (Iris Xe/CPU) per image.
- Local LLM on the laptop: only small models (Qwen3-4B Q4) on CPU/Vulkan.
- Preferred: compute on the desktop, use from the laptop. Bionic "원격 기기" (LM Link) to use the desktop's loaded models; ComfyUI started with `--listen` on the desktop and opened at `http://<desktop LAN IP>:8188`. LAN only, never expose to the internet.

## 3. Virtual memory (page file)
- Page file only prevents out-of-memory crashes; it is not usable speed. It never extends VRAM.
- OK use: a short RAM peak (text encoder loaded once per prompt, then freed). Bad use: weights that are touched every step (DiT in "low memory" mode, LLM layers offloaded to CPU) — if they land in the page file, every step reads GBs from SSD, many times slower.
- Rule: real RAM ≥ peak of what runs every step; page file (system-managed, or fixed 1.5–2x RAM on an SSD) as a safety net for peaks. Put it on the fastest SSD.
