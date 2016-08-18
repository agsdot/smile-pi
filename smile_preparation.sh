#!/usr/bin/env bash

echo "yaourt install dependencies"
sudo pacman -S --noconfirm --needed yajl

cd /tmp
git clone https://aur.archlinux.org/package-query.git
cd package-query
echo y | makepkg -si
cd ..
git clone https://aur.archlinux.org/yaourt.git
cd yaourt
echo y | makepkg -si
cd ..

# If not vagrant, i.e. booting up a rpi3
if [ ! -d /vagrant ]; then
  echo "install create_ap"
  yaourt -S --noconfirm create_ap
fi

echo "install compass"
gem install compass

#https://github.com/nodejs/node-gyp/issues/454
echo "install node-gyp"
npm config set python /usr/bin/python2
npm install -g node-gyp

echo "install redis and hiredis"
sudo pacman -S --noconfirm --needed redis
sudo pacman -S --noconfirm --needed hiredis

npm install -g hiredis
npm install -g redis

echo "install couchdb"
sudo pacman -S --noconfirm --needed couchdb

echo "install nginx"
sudo pacman -S --noconfirm --needed nginx

echo "install elasticsearch"
sudo pacman -S --noconfirm --needed elasticsearch
