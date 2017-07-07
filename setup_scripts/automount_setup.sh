#!/usr/bin/env bash

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
