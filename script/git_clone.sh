#!/bin/bash
set -euxo pipefail
cd "$(dirname "$0")"

# Retrieve GitHub URL and directory path from arguments
GITHUB_URL=$1
DIRECTORY_PATH=$2

# Check if the directory exists
if [[ ! -d "$DIRECTORY_PATH" ]]; then
  # If the directory does not exist, execute git clone
  echo "Directory does not exist. Executing git clone..."
  git clone "$GITHUB_URL" "$DIRECTORY_PATH"
else
  # If the directory exists, display a message
  echo "Directory already exists. Skipping git clone."
fi