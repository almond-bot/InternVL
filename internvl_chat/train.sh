#!/bin/bash

NAME=$1
if [ -z "$NAME" ]; then
  echo "Usage: $0 <NAME>"
  echo "NAME: human_zed_in_bowl"
  exit 1
fi

PARAMS=${PARAMS:-8}
PER_DEVICE_BATCH_SIZE=${PER_DEVICE_BATCH_SIZE:-4}
EPOCHS=${EPOCHS:-1}

curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.bashrc

uv sync
source .venv/bin/activate

if ! hf auth whoami > /dev/null 2>&1; then
  hf auth login
fi

if [ ! -d "pretrained" ]; then
  mkdir "pretrained"
fi
hf download OpenGVLab/InternVL2_5-${PARAMS}B --local-dir pretrained/InternVL2_5-${PARAMS}B
hf download almond-bot/${NAME} --local-dir data/${NAME} --repo-type dataset

rm -fr shell/data/custom.json
cp custom.json shell/data/custom.json

LINE_COUNT=$(wc -l < data/${NAME}/annotations.jsonl)
sed -i.bak "s/<name>/${NAME}/g" shell/data/custom.json
sed -i.bak "s/<samples>/${LINE_COUNT}/" shell/data/custom.json
rm shell/data/custom.json.bak


rm -fr work_dirs
nohup bash -c "GPUS=1 PER_DEVICE_BATCH_SIZE=${PER_DEVICE_BATCH_SIZE} PARAMS=${PARAMS} EPOCHS=${EPOCHS} bash train_bg.sh ${NAME}" > /dev/null 2>&1 &
disown