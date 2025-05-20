MODELS=( "$HF_MODEL")

MID=("$HF_MODEL_ID")

ID="$MODEL"

mod_dir="results"
mkdir $mod_dir

for MD in 0 1 2 3 4 5 6 ; do
        MDL=${MODELS[$MD]}
        MDID=${MID[$MD]}
        echo "MDL--> $MDL"
        for INP in 32 64 1024 ;do
                for NP in 1 2 4 ; do
                  echo "llama-cli -m models/$MDID.gguf -n 64 -t $((NP*24)) --color -f inputs/$ID/$INP.txt --log-file ./$mod_dir/sys3_local_llama_cpp_${MDID}_emr$((NP*24))c_i${INP}.txt -no-cnv"
                  llama-cli -m models/$MDID.gguf -n 64 -t $((NP*24)) --color -f inputs/$ID/$INP.txt --log-file ./$mod_dir/sys3_local_llama_cpp_${MDID}_emr$((NP*24))c_i${INP}.txt -no-cnv
                done
        done
done