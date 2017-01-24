#!/usr/bin/env bash

#echo "Run this script twice" #under root login.
#http://blog.rodneyrehm.de/archives/36-Always-Run-Script-As-Root.html

#if [ ! -f "/home/alarm/init_resize.sh" ]; then
#  echo " "
#  echo "1 of 2 runs for the restoreImageSize.sh script"
#  echo "Grow the partition"
#  echo " "
#  cd /home/alarm
#  curl -O https://raw.githubusercontent.com/RPi-Distro/raspi-config/master/init_resize.sh
#  sudo sh init_resize.sh
#else
#  echo " "
#  echo "2 of 2 runs for the restoreImageSize.sh script"
#  echo "Resize up the file system"
#  echo " "
#  # http://raspberrypi.stackexchange.com/questions/499/how-can-i-resize-my-root-partition
#  sudo resize2fs /dev/mmcblk0p2
#  echo "You are done proceed with the other scripts you had in mind"
#  sudo reboot
#fi

# above script good, below script experimental, to see if I can safely resize partition and filesystem in one go

echo " "
echo "Grow the partition"
echo "And Grow the filesystem"
echo " "
cd /home/alarm

if [ ! -f "/home/alarm/init_resize.sh" ]; then
  # file of interest not present
  curl -O https://raw.githubusercontent.com/RPi-Distro/raspi-config/master/init_resize.sh

  #http://stackoverflow.com/questions/15559359/insert-line-after-first-match-using-sed
  # perl worked whereas sed didn't seem to work
  perl -pi -e '$_ .= qq(  sudo resize2fs /dev/mmcblk0p2\n) if /if main; then/' /home/alarm/init_resize.sh
  sudo sh init_resize.sh
elif ( ! grep -q 'resize2fs' /home/alarm/init_resize.sh ); then
  # file of interest present
  # resize2fs line not there
  perl -pi -e '$_ .= qq(  sudo resize2fs /dev/mmcblk0p2\n) if /if main; then/' /home/alarm/init_resize.sh
  sudo sh init_resize.sh
else
  # file of interest present
  # resize2fs line already there
  sudo sh init_resize.sh
fi
