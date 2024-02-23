#!/bin/bash
set -euxo pipefail
cd "$(dirname "$0")"

raspberry_pi_ip_address="$1"
source="../../grove_py_installer/"
target="${raspberry_pi_ip_address}:~/grove_py_installer/"

rsync -avh --delete "${source}" "${target}"