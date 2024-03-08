#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <current_directory>"
    exit 1
fi
# 获取参数
current_directory=$1
echo "当前目录: $current_directory"
input_directory=$current_directory
output_directory=$current_directory/jupyterLab

if [ ! -d "$output_directory" ]; then
    mkdir "$output_directory"
    echo "创建文件夹"
else
    echo "文件夹已存在"
fi

for file in "$input_directory"/*.md; do
    filename=$(basename "$file")
    filename="${filename%.*}"
    notebook_filename="$output_directory/$filename.ipynb"
    
    if [ ! -f "$notebook_filename" ] || [ "$file" -nt "$notebook_filename" ]; then
        /media/liuwh/655657a9-165b-475d-873c-1f135878dc45/anaconda/anaconda3/bin/notedown "$file" --to notebook --output "$notebook_filename"
    fi
done