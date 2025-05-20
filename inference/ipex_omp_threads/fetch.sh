#!/bin/bash

# Check if directory is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Input directory
DIR="$1"

# Output CSV file
OUTPUT="latency_results.csv"

# Write CSV header
echo "Model,Input Size,TTFT (ms),Inter-Token (ms) (P90),End-to-End (ms)" > "$OUTPUT"

# Process each file in the directory
for file in "$DIR"/*_i{32,64,1024}.txt; do
    if [ -f "$file" ]; then
        # Extract model name and input size from filename
        filename=$(basename "$file")
        model=$(echo "$filename" | sed 's/sys3_local_ipex_\(.*\)_i[0-9]\+\.txt/\1/')
        input_size=$(echo "$filename" | grep -o 'i[0-9]\+' | sed 's/i//')

        # Extract latency values using grep and sed
        ttft=$(grep "First token average latency" "$file" | sed 's/.*: \([0-9.]\+\) ms.*/\1/')
        inter_token=$(grep "P90 2... latency" "$file" | sed 's/.*: \([0-9.]\+\) ms.*/\1/')
        end_to_end=$(grep "Inference latency" "$file" | sed 's/.*: \([0-9.]\+\) ms.*/\1/')

        # Write to CSV if all values are found
        if [ -n "$ttft" ] && [ -n "$inter_token" ] && [ -n "$end_to_end" ]; then
            echo "$model,$input_size,$ttft,$inter_token,$end_to_end" >> "$OUTPUT"
        fi
    fi
done

echo "Results written to $OUTPUT"