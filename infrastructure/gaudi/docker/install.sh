#!/bin/sh

wget -nv https://vault.habana.ai/artifactory/gaudi-installer/1.20.1/habanalabs-installer.sh
chmod +x habanalabs-installer.sh
./habanalabs-installer.sh install --type base
