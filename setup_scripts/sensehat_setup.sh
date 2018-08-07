#!/usr/bin/env bash

echo "sensehat python prep"
cd /home/pi/
sudo apt-get --yes --force-yes install sense-hat
# wget https://pypi.python.org/packages/15/be/b4fb144778db838aaf6bf86d939407627b2e6283503fa91195dbcafeb6c6/sense-hat-2.2.0.tar.gz#md5=69929250cb72349a8a82edf2584b1d83
# tar -zxvf sense-hat-2.2.0.tar.gz
# cd sense-hat-2.2.0
# sudo python setup.py install --root=$pkgdir/ --optimize=1
#
# echo "sensehat python packages, about 20 minutes"
# sudo pacman -S ghostscript --noconfirm --needed
# sudo PIP_NO_INPUT=1 pip install -U numpy
# sudo PIP_NO_INPUT=1 pip install -U pillow
# sudo PIP_NO_INPUT=1 pip install -U pathlib
#
# echo "python library sensor prep"
# cd /home/pi/
# git clone https://github.com/RPi-Distro/RTIMULib
# cd RTIMULib/Linux/python
# sudo python setup.py build
# sudo python setup.py install
#
# echo "get latest pacman and install sensors"
# sudo apt-get -y update
# sudo apt-get --yes --force-yes install i2c-tools
# sudo apt-get --yes --force-yes install lm_sensors
# if ! grep -q 'dtparam=i2c_arm=on' "/boot/config.txt"; then
#   sudo bash -c 'echo "dtparam=i2c_arm=on" >> /boot/config.txt'
# fi
# if ! grep -q i2c-dev "/etc/modules-load.d/raspberrypi.conf"; then
#   sudo bash -c 'echo "i2c-dev" >> /etc/modules-load.d/raspberrypi.conf'
# fi
# if ! grep -q i2c-bcm2708 "/etc/modules-load.d/raspberrypi.conf"; then
#   sudo bash -c 'echo "i2c-bcm2708" >> /etc/modules-load.d/raspberrypi.conf'
# fi

echo "device permissions"
sudo usermod -a -G video pi

echo "testing sensor data"
sudo i2cdetect -y 1

echo "systemctl service configurations"
sudo cp /home/pi/smile-pi/setup_files/smileled.service /usr/lib/systemd/system/smileled.service

sudo systemctl daemon-reload

sudo systemctl enable smileled
sudo systemctl start smileled

echo "done"
