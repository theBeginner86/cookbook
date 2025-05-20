MODELS=( "$HF_MODEL")

MID=("$HF_MODEL_ID")

mod_dir="results"
mkdir $mod_dir

for MD in 0 ; do
        MDL=${MODELS[$MD]}
        MDID=${MID[$MD]}
        echo "MDL--> $MDL"
        for INP in 32 64 1024 ;do
                for NP in 1 2 4 ; do
                  echo "LOCAL_SIZE=$NP deepspeed --bind_core_list 0-$((NP*24-1)) --bind_cores_to_rank run.py --benchmark -m "${MDL}" --dtype bfloat16 --ipex  --autotp --shard-model --token --num-iter 10 --num-warmup 3 --greedy --max 64 --input-tokens $INP |& tee ./$mod_dir/sys3_local_ipex_deepspeed_${MDID}_emr$((NP*24))c_i${INP}.txt"
                  LOCAL_SIZE=$NP deepspeed --bind_core_list 0-$((NP*24-1)) --bind_cores_to_rank run.py --benchmark -m "${MDL}" --dtype bfloat16 --ipex  --autotp --shard-model --token --num-iter 10 --num-warmup 3 --greedy --max 64 --input-tokens $INP |& tee ./$mod_dir/sys3_local_ipex_deepspeed_${MDID}_emr$((NP*24))c_i${INP}.txt
                done
        done
done