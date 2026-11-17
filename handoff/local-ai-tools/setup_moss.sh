#!/bin/bash
# ComfyUI + MOSS-Image setup on D: (everything, including pip cache, stays on D:)
set -u
ROOT=/d/ai
CU=$ROOT/ComfyUI
LOG=$ROOT/setup_moss.log
export PIP_CACHE_DIR=$ROOT/pip-cache
export HF_HOME=$ROOT/hf-cache
exec > >(tee -a "$LOG") 2>&1
echo "=== $(date) start ==="

step() { echo; echo "######## [$1] $2 ########"; }

step 1/5 "ComfyUI clone"
if [ ! -d "$CU/.git" ]; then
  git clone --depth 1 https://github.com/comfyanonymous/ComfyUI.git "$CU" || { echo "CLONE FAILED"; exit 1; }
else
  git -C "$CU" pull --ff-only
fi

step 2/5 "python venv + torch (CUDA 12.8)"
[ -d "$CU/venv" ] || python -m venv "$CU/venv"
PY="$CU/venv/Scripts/python.exe"
"$PY" -m pip install --upgrade pip
"$PY" -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128 || { echo "TORCH FAILED"; exit 1; }

step 3/5 "ComfyUI requirements"
"$PY" -m pip install -r "$CU/requirements.txt" || { echo "REQ FAILED"; exit 1; }

step 4/5 "MOSS-Image models (~17 GB)"
HF=https://huggingface.co/Comfy-Org/MOSS-Image/resolve/main
get() {  # url dest
  mkdir -p "$(dirname "$2")"
  echo "-> $(basename "$2")"
  curl -L --fail --retry 5 -C - --progress-bar -o "$2" "$1" || { echo "DOWNLOAD FAILED: $2"; exit 1; }
}
get $HF/vae/flux2-vae.safetensors "$CU/models/vae/flux2-vae.safetensors"
get $HF/loras/moss_image_edit_lora_rank_64_bf16.safetensors "$CU/models/loras/moss_image_edit_lora_rank_64_bf16.safetensors"
get https://huggingface.co/lodestones/MOSS-Image-SFT-8-steps-dmd/resolve/main/lora.safetensors "$CU/models/loras/moss_sft_8step_dmd.safetensors"
get $HF/diffusion_models/moss_image_sft_int8_convrot.safetensors "$CU/models/diffusion_models/moss_image_sft_int8_convrot.safetensors"
get $HF/text_encoders/qwen3.5_9b_int8_convrot.safetensors "$CU/models/text_encoders/qwen3.5_9b_int8_convrot.safetensors"

step 5/5 "workflow templates"
mkdir -p $ROOT/workflows
for w in image_moss_image_t2i image_moss_image_edit; do
  curl -L --fail -s -o "$ROOT/workflows/$w.json" "https://raw.githubusercontent.com/Comfy-Org/workflow_templates/main/templates/$w.json" && echo "-> $w.json"
done

echo; echo "=== $(date) ALL DONE ==="
sleep 5
