#!/usr/bin/env bash

echo "install yaourt"
sudo pacman -S --noconfirm --needed yaourt

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
