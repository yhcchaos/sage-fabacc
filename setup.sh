#!/bin/bash
sudo chmod +x  install_packages.sh
./install_packages.sh
pip install --no-deps -r requirements.txt
pip install -r requirements.txt
pip install -e .
cd sage_rl
./build.sh
./set_sysctl.sh

