#!/bin/bash
curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.bashrc

uv sync
source .venv/bin/activate

hf auth login

mkdir pretrained
hf download OpenGVLab/InternVL2_5-8B --local-dir pretrained/InternVL2_5-8B
hf download almond-bot/human_zed_in_bowl --local-dir ~/human_zed_in_bowl --repo-type dataset

nohup bash -c "GPUS=1 PER_DEVICE_BATCH_SIZE=4 bash shell/internvl2.5/2nd_finetune/internvl2_5_8b_dynamic_res_2nd_finetune_lora.sh" > /dev/null 2>&1 &
disown