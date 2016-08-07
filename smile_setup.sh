#!/usr/bin/env bash

HOME="/home/vagrant"
echo "$HOME"

echo "clone the plug branch of the smile_v2 repo"

rm -rf ~/smile_v2
if [ ! -d "~/smile_v2" ]; then
  cd
  git clone https://bitbucket.org/smileconsortium/smile_v2.git
  cd smile_v2
  git checkout -b plug origin/plug
  cd
fi

echo "setup nginx conf files"
sudo cp ~/smile_v2/vagrant/nginx.conf /etc/nginx/nginx.conf
sudo cp ~/smile_v2/vagrant/proxy.conf /etc/nginx/proxy.conf
#https://stackoverflow.com/questions/584894/sed-scripting-environment-variable-substitution
#https://askubuntu.com/questions/20414/find-and-replace-text-within-a-file-using-commands
sudo sed -i 's@/vagrant@'"$HOME"/smile_v2/frontend/src'@' /etc/nginx/nginx.conf

echo "setup smile_backend systemd service"
cp ~/smile_v2/vagrant/smile_backend.service /tmp/smile_backend.service
sed -i 's@/vagrant@'"$HOME"/smile_v2'@' /tmp/smile_backend.service
sudo cp /tmp/smile_backend.service /usr/lib/systemd/system/smile_backend.service

