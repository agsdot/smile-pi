#!/bin/bash

cd ~
echo "smile plug portal page script"

echo "install build tools one will need"

echo "install jake globally from npm"

PATH="$PATH:$HOME/.node_modules/bin" $HOME/.node_modules/bin/npm install -g jake

echo "make backups"
echo "in /etc/nginx/"
sudo \cp /etc/nginx/nginx.conf /etc/nginx/nginx_original.conf
echo "in /usr/share/nginx/html/"
sudo \cp /usr/share/nginx/html/index.html /usr/share/nginx/html/index_original.html

cd
rm -rf ~/vagrant-archbox
git clone https://github.com/agsdot/vagrant-archbox

# if /vagrant directory exists, whether this script is running on vagrant or rpi3
if [ -d /vagrant ]; then
  sudo \cp ~/vagrant-archbox/setup_files/nginx.conf.vagrant /etc/nginx/nginx.conf
else
  sudo \cp ~/vagrant-archbox/setup_files/nginx.conf.rpi3 /etc/nginx/nginx.conf
fi

echo "prepare the portal page"

cd ~
rm -rf smile-plug-portal-web
echo "clone the repo"
git clone https://bitbucket.org/gseit/smile-plug-portal-web

cd ~/smile-plug-portal-web/src/views/

sed -i 's@/smile/frontend/src/@/smile/@' home.js
sed -i 's@:8001/@/wikipedia/@' home.js
sed -i 's@:8008/@/khan/@' home.js

cd ~/smile-plug-portal-web/
echo "build smile plug portal"

#jake build
PATH="$PATH:$HOME/.node_modules/bin" $HOME/.node_modules/bin/jake build

cd ~/smile-plug-portal-web/target/

echo "put in place new smile plug portal files, html js assets"
sudo rm -rf /usr/share/nginx/html/assets/
sudo rm -rf /usr/share/nginx/html/js/
sudo rm -rf /usr/share/nginx/html/index.html

sudo \cp -r ~/smile-plug-portal-web/target/assets/ /usr/share/nginx/html/assets/
sudo \cp -r ~/smile-plug-portal-web/target/js/ /usr/share/nginx/html/js/
sudo \cp -r ~/smile-plug-portal-web/target/index.html /usr/share/nginx/html/index.html

echo "stop nginx and smile_backend service"
sudo systemctl stop nginx
sudo systemctl stop smile_backend

echo "start nginx and smile_backend service"
sudo systemctl start nginx
sudo systemctl start smile_backend
