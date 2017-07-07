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

sudo /etc/init.d/nginx restart
