#!/usr/bin/env bash

cd
cd -
cd ~
echo "update smile plug portal page script"

echo "make backups"
echo "in /etc/nginx/"
sudo \cp /etc/nginx/nginx.conf /etc/nginx/nginx_original.conf
echo "in /usr/share/nginx/html/"
sudo \cp /usr/share/nginx/html/index.html /usr/share/nginx/html/index_original.html

echo "prepare the portal page"

cd ~/smile-plug-portal-web
git fetch --all
sudo git reset --hard origin/master

echo "build smile plug portal"
rm -f ~/smile-pi/home.js
ruby ~/smile-pi/setup_files/build_portal.rb
rm -f ~/smile-plug-portal-web/src/views/home.js
cp ~/smile-pi/home.js ~/smile-plug-portal-web/src/views/home.js

cd ~/smile-plug-portal-web/
sudo jake build

cd ~/smile-plug-portal-web/target/

echo "put in place new smile plug portal files, html js assets"
sudo rm -rf /usr/share/nginx/html/assets/
sudo rm -rf /usr/share/nginx/html/js/
sudo rm -rf /usr/share/nginx/html/index.html

sudo \cp -r ~/smile-plug-portal-web/target/assets/ /usr/share/nginx/html/assets/
sudo \cp -r ~/smile-plug-portal-web/target/js/ /usr/share/nginx/html/js/
sudo \cp -r ~/smile-plug-portal-web/target/index.html /usr/share/nginx/html/index.html

echo "restart nginx"
sudo systemctl restart nginx

cd; cd -
cd ~/smile-pi
