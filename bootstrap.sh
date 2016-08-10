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

# http://stackoverflow.com/questions/59838/check-if-a-directory-exists-in-a-shell-script
# if /vagrant directory exists, whether this script is running on vagrant or rpi3
if [ -d /vagrant ]; then
  NON_ROOT_HOME=/home/vagrant
  NON_ROOT_USER=vagrant
else
  NON_ROOT_HOME=/home/alarm
  NON_ROOT_USER=alarm
fi

echo " "
echo NON_ROOT_HOME
echo $NON_ROOT_HOME
echo " "
echo NON_ROOT_USER
echo $NON_ROOT_USER
echo " "

# if $NON_ROOT_HOME/smile_v2 directory doesn't exist
if [ ! -d $NON_ROOT_HOME/vagrant-archbox ]; then
  echo "get me some vagrant - archbox stuff"
  cd $NON_ROOT_HOME
  git clone https://github.com/agsdot/vagrant-archbox $NON_ROOT_HOME/vagrant-archbox
  chown -R $NON_ROOT_USER:$NON_ROOT_USER $NON_ROOT_HOME/vagrant-archbox
fi

# If not vagrant, i.e. booting up a rpi3
if [ ! -d /vagrant ]; then
  # the pacman -Syu may have done a kernel update, a reboot makes things cleaner when
  # installing future packages
  reboot
fi
