#!/usr/bin/env bash

# https://raspberrypi.stackexchange.com/questions/41959/automount-various-usb-stick-file-systems-on-jessie-lite
echo "install usbmount"
sudo apt-get --yes --force-yes install usbmount

echo "install ntfs support"
sudo apt-get --yes --force-yes install ntfs-3g

sudo sed -i 's/FILESYSTEMS=\"vfat ext2 ext3 ext4 hfsplus\"/FILESYSTEMS=\"vfat ntfs fuseblk ext2 ext3 ext4 hfsplus\"/' /etc/usbmount/usbmount.conf
sudo sed -i 's/FS_MOUNTOPTIONS=\"\"/FS_MOUNTOPTIONS=\"-fstype=ntfs-3g,nls=utf8,umask=007,gid=46 -fstype=fuseblk,nls=utf8,umask=007,gid=46 -fstype=vfat,gid=1000,uid=1000,umask=007\"/' /etc/usbmount/usbmount.conf

echo "setup usbmount rules"
sudo rm -rf /etc/udev/rules.d/usbmount.rules
sudo cp /home/pi/smile-pi/setup_files/usbmount.rules /etc/udev/rules.d/usbmount.rules

echo "setup usbmount service"
sudo cp /home/pi/smile-pi/setup_files/usbmount@.service /etc/systemd/system/usbmount@.service

# https://serverfault.com/questions/766506/automount-usb-drives-with-systemd
sudo rm -rf  /usr/local/bin/usb-mount.sh
sudo cp /home/pi/smile-pi/setup_files/usb-mount.sh /usr/local/bin/usb-mount.sh
sudo chmod +x /usr/local/bin/usb-mount.sh

sudo rm -rf /etc/systemd/system/usb-mount@.service
sudo cp /home/pi/smile-pi/setup_files/usb-mount@.service /etc/systemd/system/usb-mount@.service

sudo rm -rf /etc/udev/rules.d/99-local.rules
sudo cp /home/pi/smile-pi/setup_files/99-local.rules /etc/udev/rules.d/99-local.rules

sudo udevadm control --reload-rules
sudo systemctl daemon-reload

sudo apt-get install nginx-extras
sudo rm -rf /usr/share/nginx/html/.fancyindex
sudo git clone https://github.com/luk1337/Directory-Theme.git /usr/share/nginx/html/.fancyindex

sudo \cp /etc/nginx/nginx.conf /etc/nginx/nginx_old.conf
sudo \cp ~/smile-pi/setup_files/nginx.conf.rpi3 /etc/nginx/nginx.conf

echo "update smile plug portal page"
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

rm -f ~/smile-pi/home.js
ruby ~/smile-pi/setup_files/build_portal.rb
rm ~/smile-plug-portal-web/src/views/home.js
cp ~/smile-pi/home.js ~/smile-plug-portal-web/src/views/home.js
rm ~/smile-plug-portal-web/src/templates/navbar.html
cp ~/smile-pi/setup_files/navbar_usb.html ~/smile-plug-portal-web/src/templates/navbar.html

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

sudo /etc/init.d/nginx restart
