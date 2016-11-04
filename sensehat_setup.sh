#!/usr/bin/env bash

echo "sensehat python prep"

wget https://pypi.python.org/packages/15/be/b4fb144778db838aaf6bf86d939407627b2e6283503fa91195dbcafeb6c6/sense-hat-2.2.0.tar.gz#md5=69929250cb72349a8a82edf2584b1d83
tar -zxvf sense-hat-2.2.0.tar.gz
sudo python2 setup.py install --root=$pkgdir/ --optimize=1
sudo /usr/bin/pip2.7 install -U numpy
sudo /usr/bin/pip2.7 install -U pillow
sudo /usr/bin/pip2.7 install -U pathlib


echo "python library sensor prep"
git clone https://github.com/RPi-Distro/RTIMULib
cd RTIMULib/Linux/python
sudo /usr/bin/python2.7 setup.py build
sudo /usr/bin/python2.7 setup.py install

sudo pacman -Syu
sudo pacman -S i2c-tools
sudo pacman -S lm_sensors
sudo cat 'dtparam=i2c_arm=on' >> /boot/config.txt
sudo cat 'i2c-dev' >> /etc/modules-load.d/raspberrypi.conf
sudo cat 'i2c-bcm2708' >> /etc/modules-load.d/raspberrypi.conf

echo "testing sensor data"
sudo i2cdetect -y 1

echo "device permissions"
sudo usermod -a -G video alarm

echo "systemctl service configurations"
sudo cp /usr/lib/systemd/system/smileled.service /home/alarm/setup_files/smileled.service
sudo systemctl start smileled
sudo systemctl enable smileled

