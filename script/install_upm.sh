#!/bin/bash
set -euxo pipefail
cd "$(dirname "$0")"

base_dir="$1"

cd "${base_dir}/upm/"
mraa_build_dir="${base_dir}/mraa/build"
PKG_CONFIG_PATH="${PKG_CONFIG_PATH:-}:${mraa_build_dir}/lib/pkgconfig"

sudo apt install \
    libmodbus-dev \
    libjpeg-dev \
    -y

# 以下のモジュールはビルドに失敗するので除外する。
rm -r "${base_dir}/upm/src/nmea_gps"

upm_build_dir="${base_dir}/upm/build/"
mkdir -p "${upm_build_dir}"
cd "${upm_build_dir}"

cmake .. -DBUILDSWIGJAVA=OFF -DBUILDSWIGNODE=OFF -DBUILDSWIGPYTHON=ON
make -j4
sudo make install

installed_python_version="python$(./get_python_version.sh)"

src_dir="${upm_build_dir}/src"
dest_dir="/usr/local/lib/python${installed_python_version}/dist-packages/upm"
find "$src_dir" -type f \( -name "*.py" -o -name "*.so" \) | sudo xargs -I {} cp {} "$dest_dir"

src_dir="${upm_build_dir}/interfaces"
find "$src_dir" -type f \( -name "*.py" -o -name "*.so" \) | sudo xargs -I {} cp {} "$dest_dir"
