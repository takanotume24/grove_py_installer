#!/bin/bash
set -euxo pipefail
cd "$(dirname "$0")"

base_dir="$1"
installer_dir="$2"

cd "${base_dir}/upm/"
mraa_build_dir="${base_dir}/mraa/build"
PKG_CONFIG_PATH="${PKG_CONFIG_PATH:-}:${mraa_build_dir}/lib/pkgconfig"

sudo apt install \
    python-dev \
    clang \
    libmodbus-dev \
    libjpeg-dev \
    -y

upm_build_dir="${base_dir}/upm/build/"
mkdir -p "${upm_build_dir}"
cd "${upm_build_dir}"

cmake .. \
    -DBUILDSWIGJAVA=OFF \
    -DBUILDSWIGNODE=OFF \
    -DBUILDSWIGPYTHON=ON \
    -DWERROR=OFF \
    -DCMAKE_C_COMPILER=/usr/bin/clang \
    -DCMAKE_CXX_COMPILER=/usr/bin/clang++

make -j4
sudo make install

installed_python_version="$("${installer_dir}/script/get_python_version.sh")"

# https://github.com/eclipse/upm/issues/696#issuecomment-771098228
src_dir="${upm_build_dir}/src"
dest_dir="/usr/local/lib/python${installed_python_version}/dist-packages/upm"
find "${src_dir}" -type f \( -name "*.py" -o -name "*.so" \) | sudo xargs -I {} cp {} "${dest_dir}"

src_dir="${upm_build_dir}/interfaces"
find "${src_dir}" -type f \( -name "*.py" -o -name "*.so" \) | sudo xargs -I {} cp {} "${dest_dir}"
