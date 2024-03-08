#!/bin/bash

# 无限循环
while true; do
    current_directory=$(pwd)
    input_directory=$current_directory
    output_directory=$current_directory/jupyterLab
    
    if [ ! -d "$output_directory" ]; then
        mkdir "$output_directory"
    fi
    
    for file in "$input_directory"/*.md; do
        filename=$(basename "$file")
        filename="${filename%.*}"
        notebook_filename="$output_directory/$filename.ipynb"
        
        if [ ! -f "$notebook_filename" ] || [ "$file" -nt "$notebook_filename" ]; then
            notedown "$file" --to notebook --output "$notebook_filename"
        fi
    done
    
    # 等待十秒钟
    sleep 10
done