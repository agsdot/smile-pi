#!/usr/bin/env bash

# On a rpi3, loggin in as root
# curl -O https://raw.githubusercontent.com/agsdot/vagrant-archbox/master/bootstrap.sh
# chmod +x bootstrap.sh
# ./bootstrap.sh

# After that is done, login as alarm user and clone the repo and run the remaining scripts as alarm (non root)
# cd ; git clone https://github.com/agsdot/vagrant-archbox.git; cd vagrant-archbox
# chmod +x the scripts, then run scripts in order of 1) basic_package.sh 2) smile_preparation.sh 3) smile_setup.sh

pacman -Syu
pacman -S --noconfirm --needed --force vim git wget base-devel

sed -i '/wheel ALL/s/^#//g' /etc/sudoers
