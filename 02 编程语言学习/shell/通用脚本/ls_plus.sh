#!/bin/bash

function usage() {
    echo "Usage: $0 source_dir target_dir type"
    echo "Example: $0 /path/to/source/dir /path/to/target/dir pdf"
}

if [ $# -ne 3 ]; then
    usage
    exit 1
fi

# 指定软连接的目标文件夹
source_dir="$1"
target_dir="$2"
type="$3"

# 创建目标文件夹（如果不存在的话）
mkdir -p "$target_dir"

# 遍历当前文件夹及其子文件夹内的所有指定类型文件
find "$source_dir" -name "*.$type" | while read file; do
    # 获取相对路径以保留目录结构
    relative_path=$(realpath --relative-to="$source_dir" "$file")
    file_name=$(basename "$file")
    target_file="$target_dir/$relative_path"
    
    # 检查在目标文件夹下是否已存在同名软连接
    if [ -e "$target_file" ]; then
        # 计算新的文件名
        count=1
        while [ -e "${target_file%.*}_$count.$type" ]; do
            count=$((count + 1))
        done
        new_file_name="${file_name%.*}_$count.type"
        ln -s "$file" "$target_dir/$relative_path/${new_file_name}"
    else
        mkdir -p "$(dirname "$target_file")"
        ln -s "$file" "$target_file"
    fi
done
