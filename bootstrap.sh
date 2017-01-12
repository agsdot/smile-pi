#!/usr/bin/env bash

pacman -Syu --noconfirm --needed
# parted libnewt (for whiptail) are needed for resizing restoring an installed image to fullsize
pacman -S --noconfirm --needed --force base-devel git wget unzip vim emacs-nox tmux dialog parted libnewt

## for tmux
sed -i 's@#en_US.UTF-8 UTF-8@en_US.UTF-8 UTF-8@' /etc/locale.gen
locale-gen
##

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
