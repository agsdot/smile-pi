#!/usr/bin/env bash

echo "sensehat python prep"
cd /home/alarm/
wget https://pypi.python.org/packages/15/be/b4fb144778db838aaf6bf86d939407627b2e6283503fa91195dbcafeb6c6/sense-hat-2.2.0.tar.gz#md5=69929250cb72349a8a82edf2584b1d83
tar -zxvf sense-hat-2.2.0.tar.gz
cd sense-hat-2.2.0
sudo python2 setup.py install --root=$pkgdir/ --optimize=1

echo "sensehat python packages, about 20 minutes"
sudo pacman -S ghostscript --noconfirm --needed
sudo PIP_NO_INPUT=1 /usr/bin/pip2.7 install -U numpy
sudo PIP_NO_INPUT=1 /usr/bin/pip2.7 install -U pillow
sudo PIP_NO_INPUT=1 /usr/bin/pip2.7 install -U pathlib

echo "python library sensor prep"
cd /home/alarm/
git clone https://github.com/RPi-Distro/RTIMULib
cd RTIMULib/Linux/python
sudo /usr/bin/python2.7 setup.py build
sudo /usr/bin/python2.7 setup.py install

echo "get latest pacman and install sensors"
sudo pacman -Syu --noconfirm --needed
sudo pacman -S --noconfirm --needed i2c-tools
sudo pacman -S --noconfirm --needed lm_sensors
sudo bash -c 'echo "dtparam=i2c_arm=on" >> /boot/config.txt'
sudo bash -c 'echo "i2c-dev" >> /etc/modules-load.d/raspberrypi.conf'
sudo bash -c 'echo "i2c-bcm2708" >> /etc/modules-load.d/raspberrypi.conf'

echo "device permissions"
sudo usermod -a -G video alarm

echo "testing sensor data"
sudo i2cdetect -y 1

echo "systemctl service configurations"
sudo cp /home/alarm/vagrant-archbox/setup_files/smileled.service /usr/lib/systemd/system/smileled.service
sudo systemctl enable smileled
sudo systemctl start smileled

echo "done"
