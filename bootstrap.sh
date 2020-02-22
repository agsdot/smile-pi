#!/usr/bin/env bash
apt-get -y install git
apt-get -y update && sudo apt-get -y dist-upgrade
apt-get -y install exfat-fuse

## for tmux
sed -i 's@#en_US.UTF-8 UTF-8@en_US.UTF-8 UTF-8@' /etc/locale.gen
## raspbian buster has a space between the # and the en_US
sed -i 's@# en_US.UTF-8 UTF-8@en_US.UTF-8 UTF-8@' /etc/locale.gen
locale-gen
##

sed -i '/wheel ALL/s/^#//g' /etc/sudoers

  NON_ROOT_HOME=/home/pi
  NON_ROOT_USER=pi

echo " "
echo NON_ROOT_HOME
echo $NON_ROOT_HOME
echo " "
echo NON_ROOT_USER
echo $NON_ROOT_USER
echo " "

# if $NON_ROOT_HOME/smile_v2 directory doesn't exist
if [ ! -d $NON_ROOT_HOME/smile-pi ]; then
  echo "get me some vagrant - archbox stuff"
  cd $NON_ROOT_HOME
  git clone https://github.com/agsdot/smile-pi $NON_ROOT_HOME/smile-pi
  chown -R $NON_ROOT_USER:$NON_ROOT_USER $NON_ROOT_HOME/smile-pi
fi

# If not vagrant, i.e. booting up a rpi3
if [ ! -d /vagrant ]; then
  if [ ! -f $NON_ROOT_HOME/rpi3_install.sh ]; then
    echo "setup shortcut to run rpi3_install script"
    touch $NON_ROOT_HOME/rpi3_install.sh
    echo "#!/usr/bin/env bash" >> $NON_ROOT_HOME/rpi3_install.sh
    echo "bash ~/smile-pi/setup_scripts/rpi3_install.sh">> $NON_ROOT_HOME/rpi3_install.sh
    chmod +x $NON_ROOT_HOME/rpi3_install.sh
    chown -R $NON_ROOT_USER:$NON_ROOT_USER $NON_ROOT_HOME/rpi3_install.sh
    # http://stackoverflow.com/questions/13633638/create-file-with-contents-from-shell-script
    # cat > $NON_ROOT_HOME/rpi3_install.sh << EOF
    # #!/usr/bin/env bash
    # bash ~/smile-pi/setup_scripts/rpi3_install
    # EOF
  fi
  # the pacman -Syu may have done a kernel update, a reboot makes things cleaner when
  # installing future packages
  reboot
fi
