#!/bin/bash
set -euxo pipefail
cd "$(dirname "$0")"

PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')

# メジャーとマイナーバージョンのみを抽出（例: 3.9）
PYTHON_VERSION_SHORT=$(echo "$PYTHON_VERSION" | cut -d. -f1,2)
echo "$PYTHON_VERSION_SHORT"
