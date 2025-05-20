#!/bin/bash

# Check if directory is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Input directory
DIR="$1"

# Validate directory
if [ ! -d "$DIR" ]; then
    echo "Error: '$DIR' is not a directory"
    exit 1
fi

# Output CSV file
OUTPUT="latency_results.csv"

# Write CSV header
echo "Model,Input Size,TTFT (ms),Inter-Token (ms),End-to-End (ms),TPS" > "$OUTPUT"

# Process each .txt file in the directory
for file in "$DIR"/*_i{32,64,1024}.txt; do
    if [ -f "$file" ]; then
        # Extract model name and input size from filename
        filename=$(basename "$file")
        model=$(echo "$filename" | sed 's/\(.*\)_i[0-9]\+\.txt/\1/')
        input_size=$(echo "$filename" | grep -o 'i[0-9]\+' | sed 's/i//')

        # Extract relevant metrics
        prompt_eval_time=$(grep "llama_perf_context_print: prompt eval time" "$file" | awk '{print $6}' | sed 's/[^0-9.]//g')
        eval_time=$(grep "llama_perf_context_print:        eval time" "$file" | awk '{print $5}' | sed 's/[^0-9.]//g')
        total_time=$(grep "total time" "$file" | awk '{print $5}' | sed 's/[^0-9.]//g')
        tps=$(grep "llama_perf_context_print:        eval time" "$file" | awk '{print $15}')

        # Debug: Log extracted values
        if [ -z "$prompt_eval_time" ] || [ -z "$eval_time" ] || [ -z "$total_time" ] || [ -z "$tps" ]; then
            echo "Warning: Missing data in $file"
            echo "prompt_eval_time: $prompt_eval_time, eval_time: $eval_time, total_time: $total_time, tps: $tps"
            continue
        fi

        # Calculate TTFT: prompt eval time
        if [ -n "$prompt_eval_time" ] && [ -n "$eval_time" ]; then
            # Use bc for floating-point arithmetic
            ttft=$(echo "scale=2; $prompt_eval_time" | bc)
        else
            ttft="N/A"
        fi

        # Calculate Inter-Token Latency: 1000 / TPS
        if [ -n "$tps" ] && [ "$(echo "$tps > 0" | bc)" -eq 1 ]; then
            inter_token=$(echo "scale=2; 1000 / $tps" | bc)
        else
            inter_token="N/A"
        fi

        # End-to-End: Use total time
        end_to_end="$total_time"

        # Write to CSV if key values are present
        if [ -n "$end_to_end" ] && [ "$end_to_end" != "N/A" ]; then
            echo "$model,$input_size,$ttft,$inter_token,$end_to_end,$tps" >> "$OUTPUT"
        fi
    fi
done

echo "Results written to $OUTPUT"