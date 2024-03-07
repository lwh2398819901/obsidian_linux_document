#!/bin/bash

# 获取当前目录路径
current_directory=$(pwd)

# 定义输入和输出目录
input_directory=$current_directory
output_directory=$current_directory/jupyterLab

# 遍历输入目录中的所有.md文件
for file in "$input_directory"/*.md; do
    # 提取文件名（不含扩展名）
    filename=$(basename -- "$file")
    filename="${filename%.*}"
    
    # 设置输出文件路径
    output_file="$output_directory/$filename.ipynb"
    
    # 使用notedown命令将md文件转换为ipynb格式
    #notedown "$file" --to notebook --run --output "$output_file"
    notedown "$file" > "$output_file"
done