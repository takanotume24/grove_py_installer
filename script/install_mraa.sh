#!/bin/bash
set -euxo pipefail
cd "$(dirname "$0")"

base_dir="$1"
mraa_build_dir="${base_dir}/mraa/build"

mkdir -p "${mraa_build_dir}"
cd "${mraa_build_dir}"

cmake ..
make -j4
sudo make install
