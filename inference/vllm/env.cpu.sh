#!/bin/sh

export PIP_EXTRA_INDEX_URL="https://download.pytorch.org/whl/cpu";
apt-get update -y \
apt-get install -y --no-install-recommends ccache git curl wget ca-certificates \
  gcc-12 g++-12 libtcmalloc-minimal4 libnuma-dev ffmpeg libsm6 libxext6 libgl1 \
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 10 --slave /usr/bin/g++ g++ /usr/bin/g++-12;
pip install --upgrade pip;
pip install -r requirements/cpu.txt;
pip install intel-openmp==2024.2.1 intel_extension_for_pytorch==2.6.0;
pip install -r requirements/build.txt
VLLM_TARGET_DEVICE=cpu python3 setup.py bdist_wheel;
pip install dist/*.whl
