#!/usr/bin/env bash
apt-get -y install git
apt-get -y update && sudo apt-get -y dist-upgrade

## for tmux
sed -i 's@#en_US.UTF-8 UTF-8@en_US.UTF-8 UTF-8@' /etc/locale.gen
locale-gen
##

sed -i '/wheel ALL/s/^#//g' /etc/sudoers

# http://stackoverflow.com/questions/59838/check-if-a-directory-exists-in-a-shell-script
# if /vagrant directory exists, whether this script is running on vagrant or rpi3
if [ -d /vagrant ]; then
  NON_ROOT_HOME=/home/vagrant
  NON_ROOT_USER=vagrant
else
  NON_ROOT_HOME=/home/pi
  NON_ROOT_USER=pi
fi

echo " "
echo NON_ROOT_HOME
echo $NON_ROOT_HOME
echo " "
echo NON_ROOT_USER
echo $NON_ROOT_USER
echo " "

# if $NON_ROOT_HOME/smile_v2 directory doesn't exist
if [ ! -d $NON_ROOT_HOME/vagrant-archbox ]; then
  echo "get me some vagrant - archbox stuff"
  cd $NON_ROOT_HOME
  git clone https://github.com/canuk/vagrant-archbox $NON_ROOT_HOME/vagrant-archbox
  chown -R $NON_ROOT_USER:$NON_ROOT_USER $NON_ROOT_HOME/vagrant-archbox
fi

# If not vagrant, i.e. booting up a rpi3
if [ ! -d /vagrant ]; then
  if [ ! -f $NON_ROOT_HOME/rpi3_install.sh ]; then
    echo "setup shortcut to run rpi3_install script"
    touch $NON_ROOT_HOME/rpi3_install.sh
    echo "#!/usr/bin/env bash" >> $NON_ROOT_HOME/rpi3_install.sh
    echo "bash ~/vagrant-archbox/setup_scripts/rpi3_install.sh">> $NON_ROOT_HOME/rpi3_install.sh
    chmod +x $NON_ROOT_HOME/rpi3_install.sh
    chown -R $NON_ROOT_USER:$NON_ROOT_USER $NON_ROOT_HOME/rpi3_install.sh
    # http://stackoverflow.com/questions/13633638/create-file-with-contents-from-shell-script
    # cat > $NON_ROOT_HOME/rpi3_install.sh << EOF
    # #!/usr/bin/env bash
    # bash ~/vagrant-archbox/setup_scripts/rpi3_install
    # EOF
  fi
  # the pacman -Syu may have done a kernel update, a reboot makes things cleaner when
  # installing future packages
  reboot
fi
