#!/bin/sh

MODELS=("$HF_MODEL")
MODELS_ID=("$HF_MODEL_ID")

for MD in 0 ; do
        MDL=${MODELS[$MD]}
        MID=${MODELS_ID[$MD]}
        git lfs clone https://huggingface.co/$MDL
        python  /home/intel/thebeginner86/llama.cpp/convert_hf_to_gguf.py $MID --outfile ./$MID.gguf --outtype bf16
        rm -rf $MID
done