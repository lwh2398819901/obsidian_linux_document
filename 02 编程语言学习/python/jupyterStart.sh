#!/bin/bash

# 获取外部传入的目标目录参数
target_directory="$1"
echo "target_directory: $target_directory"  > /tmp/jupyterStart.log
env >> /tmp/jupyterStart.log

# 检查是否有端口号为8888的JupyterLab实例在运行
if lsof -Pi :8888 -sTCP:LISTEN -t >/dev/null ; then
    echo "JupyterLab is already running on port 8888"
    exit 1
else
    echo "Starting JupyterLab in $target_directory"
    cd "$target_directory" && jupyter lab --NotebookApp.token=''
fi