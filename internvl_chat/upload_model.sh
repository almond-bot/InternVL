PARAMS=${PARAMS:-8}
NAME=$1
if [ -z "$NAME" ]; then
  echo "Usage: $0 <NAME>"
  echo "NAME: human_zed_in_bowl"
  exit 1
fi

OUTPUT_DIR="work_dirs/internvl_chat_v2_5/internvl2_5_${PARAMS}b_dynamic_res_2nd_finetune_lora"

hf upload almond-bot/InternVL2_5-${PARAMS}B_${NAME} ${OUTPUT_DIR}_merge/