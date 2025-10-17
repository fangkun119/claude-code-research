#!/bin/bash

# 创建并激活 Python Virtual Environment
if [ -d ".venv" ]; then
    echo ".venv exists!"
else
    uv venv --python=3.12 .venv
fi

source .venv/bin/activate

# 安装 Python Package 依赖
export UV_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple/
# uv pip install -r requirements.txt
uv pip install markitdown[all]==0.1.3
markitdown --version

