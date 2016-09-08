#!/usr/bin/env bash

# for npm stuffs #
source ~/.bash_aliases
# http://stackoverflow.com/questions/30281057/node-forever-usr-bin-env-node-no-such-file-or-directory
# https://github.com/nodejs/node-v0.x-archive/issues/3911
#echo "softlink node and npm to /usr/bin location"
#sudo ln -s "$(which node)" /usr/bin/node
#sudo ln -s "$(which npm)" /usr/bin/npm
echo "make npm up to date"
#$HOME/.node_modules/bin/npm config set python /usr/bin/python2
#https://github.com/nodejs/node-v0.x-archive/issues/3911
PATH="$PATH:$HOME/.node_modules/bin" $HOME/.node_modules/bin/npm install -g npm
####

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
gem install compass --no-ri --no-rdoc

#https://github.com/nodejs/node-gyp/issues/454
echo "install node-gyp"
$HOME/.node_modules/bin/npm install -g node-gyp

echo "install redis and hiredis"
sudo pacman -S --noconfirm --needed redis
sudo pacman -S --noconfirm --needed hiredis

$HOME/.node_modules/bin/npm install -g hiredis
$HOME/.node_modules/bin/npm install -g redis

echo "install couchdb"
sudo pacman -S --noconfirm --needed couchdb

echo "install nginx"
sudo pacman -S --noconfirm --needed nginx

echo "install elasticsearch"
sudo pacman -S --noconfirm --needed elasticsearch
