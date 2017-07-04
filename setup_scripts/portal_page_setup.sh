#!/usr/bin/env bash

cd
cd -
cd ~
echo "smile plug portal page script"

echo "install build tools one will need"

echo "install jake globally from npm"

sudo /usr/bin/npm install -g jake

echo "make backups"
echo "in /etc/nginx/"
sudo \cp /etc/nginx/nginx.conf /etc/nginx/nginx_original.conf
echo "in /usr/share/nginx/html/"
sudo \cp /usr/share/nginx/html/index.html /usr/share/nginx/html/index_original.html

cd
rm -rf ~/smile-pi
git clone https://github.com/canuk/smile-pi

echo "prepare the portal page"

cd ~
rm -rf smile-plug-portal-web
echo "clone the repo"
git clone https://bitbucket.org/gseit/smile-plug-portal-web

cd ~/smile-plug-portal-web/src/views/

sed -i 's@/smile/frontend/src/@/smile/@' home.js
#sed -i 's@:8001/@/wikipedia/@' home.js
#sed -i 's@:8008/@/khan/@' home.js

cd ~/smile-plug-portal-web/
echo "build smile plug portal"

LAST_FOUR_MAC_ADDRESS="$(ip addr | grep link/ether | awk '{print $2}' | tail -1  | sed s/://g | tr '[:lower:]' '[:upper:]' | tail -c 5)"

cd ~/smile-pi/
GIT_HASH="$(git rev-parse HEAD)"

sudo sed -i 's@Administer@Administer Smile Plug (SMILE_'"$LAST_FOUR_MAC_ADDRESS"')@' ~/smile-plug-portal-web/src/templates/admin.html
sudo sed -i 's@breadcrumb-->@breadcrumb '"$GIT_HASH"' -->@' ~/smile-plug-portal-web/src/templates/admin.html

ruby ~/smile-pi/setup_files/build_portal.rb
rm ~/smile-plug-portal-web/src/views/home.js
cp ~/smile-pi/setup_files/home.js ~/smile-plug-portal-web/src/views/home.js

#jake build
cd ~/smile-plug-portal-web/
 jake build

cd ~/smile-plug-portal-web/target/

echo "put in place new smile plug portal files, html js assets"
sudo rm -rf /usr/share/nginx/html/assets/
sudo rm -rf /usr/share/nginx/html/js/
sudo rm -rf /usr/share/nginx/html/index.html
sudo rm -rf /usr/share/nginx/html/404.html
sudo rm -rf /usr/share/nginx/html/50x.html


sudo \cp -r ~/smile-plug-portal-web/target/assets/ /usr/share/nginx/html/assets/
sudo \cp -r ~/smile-plug-portal-web/target/js/ /usr/share/nginx/html/js/
sudo \cp -r ~/smile-plug-portal-web/target/index.html /usr/share/nginx/html/index.html
sudo \cp ~/smile-pi/setup_files/404.html /usr/share/nginx/html/404.html
sudo \cp ~/smile-pi/setup_files/50x.html /usr/share/nginx/html/50x.html

echo "install and configure php tools needed for the shutdown / reboot script"
echo "nginx php configurations and c installation"

sudo apt-get --yes --force-yes install php5-fpm
sudo systemctl enable php5-fpm

# if /vagrant directory exists, whether this script is running on vagrant or rpi3
if [ -d /vagrant ]; then
  sudo \cp ~/smile-pi/setup_files/nginx.conf.vagrant /etc/nginx/nginx.conf
else
  sudo \cp ~/smile-pi/setup_files/nginx.conf.rpi3 /etc/nginx/nginx.conf
fi

sudo systemctl stop nginx
sudo systemctl stop php5-fpm

sudo systemctl start nginx
sudo systemctl start php5-fpm

echo "setup shutdown_php.c and reboot_php.c files"

cd /tmp
\cp ~/smile-pi/setup_files/shutdown_php.c /tmp/shutdown_php.c
\cp ~/smile-pi/setup_files/reboot_php.c /tmp/reboot_php.c

gcc -o shutdown_php shutdown_php.c
sudo mv shutdown_php /usr/local/bin/
sudo chown root:root /usr/local/bin/shutdown_php
sudo chmod 4755 /usr/local/bin/shutdown_php

gcc -o reboot_php reboot_php.c
sudo mv reboot_php /usr/local/bin/
sudo chown root:root /usr/local/bin/reboot_php
sudo chmod 4755 /usr/local/bin/reboot_php

echo "put in a php info page"
sudo \cp ~/smile-pi/setup_files/info.php /usr/share/nginx/html/info.php

echo "stop nginx and smile_backend service"
sudo systemctl stop nginx
sudo systemctl stop smile_backend

echo "start nginx and smile_backend service"
sudo systemctl start nginx
sudo systemctl start smile_backend

cd; cd -
cd ~/smile-pi
