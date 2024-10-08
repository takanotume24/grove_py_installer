#!/bin/bash
set -euxo pipefail
cd "$(dirname "$0")/.."
repository_root="$(pwd)"

sudo apt update && sudo apt upgrade -y

base_dir="$1"
installer_dir="${repository_root}"

mkdir -p "${base_dir}"
cd "${base_dir}"

"${installer_dir}/script/git_clone.sh" https://github.com/Seeed-Studio/grove.py.git "${base_dir}/grove.py"
cd "${base_dir}/grove.py"
git checkout 88e277108522e8c92e61089d287cc4ad82ff251c

cd "${base_dir}"
"${installer_dir}/script/git_clone.sh" https://github.com/eclipse/mraa.git "${base_dir}/mraa"
"${installer_dir}/script/git_clone.sh" https://github.com/eclipse/upm.git "${base_dir}/upm"

cd "${base_dir}/mraa"

sudo apt install \
    git \
    build-essential \
    swig \
    cmake \
    libjson-c-dev \
    -y

# install mraa
"${installer_dir}/script/install_mraa.sh" "${base_dir}"

# install upm
"${installer_dir}/script/install_upm.sh" "${base_dir}" "${installer_dir}"

# install python packages
cd "${base_dir}/grove.py"
git apply "${installer_dir}/patch/adc.patch"
python3 -m venv .venv
source .venv/bin/activate
pip install .

installed_python_version="python$("${installer_dir}/script/get_python_version.sh")"
ln -s "/usr/local/lib/${installed_python_version}/dist-packages/upm/" "${base_dir}/grove.py/.venv/lib/${installed_python_version}/site-packages/upm"
ln -s "/usr/local/lib/${installed_python_version}/dist-packages/mraa.py" "${base_dir}/grove.py/.venv/lib/${installed_python_version}/site-packages/mraa.py"
ln -s "/usr/local/lib/${installed_python_version}/dist-packages/_mraa.so" "${base_dir}/grove.py/.venv/lib/${installed_python_version}/site-packages/_mraa.so"

# enable I2C
sudo raspi-config nonint do_i2c 0
