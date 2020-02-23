#!/usr/bin/env bash

#https://unix.stackexchange.com/questions/197448/change-password-programmatically
#https://stackoverflow.com/questions/27837674/changing-an-aix-password-via-script
echo "set default login to the raspberry pi something other than pi / raspberry"
echo 'pi:smile-pi' | sudo chpasswd

echo "basic package"

if [ -f "/usr/lib/systemd/system/create_ap.service" ]; then
  echo "create_ap service and Wifi network already configured"
  echo "re-download a fresh create_ap.service template and reconfigure"
  cd ~
  rm -rf ~/smile-pi
  #git clone https://github.com/canuk/smile-pi
  git clone https://github.com/agsdot/vagrant-archbox ~/smile-pi
  cd ~/smile-pi
fi

if ( ! grep -q 'gitprompt.sh' ~/.bashrc ); then
  echo "install bash-git-prompt"

  cd ~
  git clone https://github.com/magicmonty/bash-git-prompt.git .bash-git-prompt --depth=1

  echo "source ~/.bash-git-prompt/gitprompt.sh" >> ~/.bashrc
  echo "GIT_PROMPT_ONLY_IN_REPO=1" >> ~/.bashrc
  source ~/.bashrc

  echo "cleanup bash-git-prompt install"
  rm -rf ~/bash-git-prompt
fi

echo "Install TJ git-extras for nice extra git utilities"
curl -sSL http://git.io/git-extras-setup | sudo bash /dev/stdin

if ( ! grep -q 'plugin' ~/.vimrc ); then
  echo "improve vim"
  git clone git://github.com/brianleroux/quick-vim.git /tmp/quick-vim
  cd /tmp/quick-vim
  ./quick-vim install
  rm -rf /tmp/quick-vim
fi

echo "checking for alias reference in the ~/.bashrc"
if ( ! grep -q 'bash_alias' ~/.bashrc )
then
  echo "bashrc doesn't have reference to bash_aliases, put it in"
  echo "if [ -f ~/.bash_aliases ]; then source ~/.bash_aliases; fi" >> ~/.bashrc
fi

# get the nodejs repo
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs
#sudo apt-get install -y npm

echo "installing rubies and javascripts"
sudo apt-get -y install nodejs
sudo apt-get -y install python
sudo apt-get -y install python-pip
sudo apt-get -y install ruby
sudo apt-get -y install ruby-dev
echo "done with rubies and pythons"

if [ ! -f ~/.npmrc ]; then
  echo "setup ~/.npmrc"
  touch ~/.npmrc
  echo "prefix=${HOME}/.node_modules" >> ~/.npmrc
  echo "python=/usr/bin/python" >> ~/.npmrc
fi

if [ ! -f ~/.gitconfig ]; then
  echo "setup ~/.gitconfig"
  cp ~/smile-pi/setup_files/.gitconfig ~/.gitconfig
fi

if [ ! -f ~/.bash_aliases ]; then
  echo "setup ~/.bash_aliases"
  cp ~/smile-pi/setup_files/.bash_aliases ~/.bash_aliases
fi
source ~/.bash_aliases

echo "make npm up to date"
sudo npm install -g npm

#https://github.com/oblique/create_ap
echo "install create_ap"
cd
rm -rf ~/create_ap
sudo apt-get install -y hostapd
sudo apt-get install -y dnsmasq
# a started hostapd service interferes with create_ap starting up one of itself
sudo systemctl unmask hostapd
sudo systemctl stop hostapd
sudo systemctl disable hostapd

git clone https://github.com/oblique/create_ap ~/create_ap
cd create_ap
sudo make install

# need to reboot before installing compass
echo "install compass"
sudo gem install compass --no-ri --no-rdoc

#https://github.com/nodejs/node-gyp/issues/454
echo "install node-gyp"
sudo npm install -g node-gyp

echo "install nginx"
sudo apt-get -y install nginx
sudo apt-get -y install nginx-extras

echo "setup create_ap"
#note to self, Raspbian Jesse Lite already uses systemd
LAST_FOUR_MAC_ADDRESS="$(ip addr | grep link/ether | awk '{print $2}' | tail -1  | sed s/://g | tr '[:lower:]' '[:upper:]' | tail -c 5)"
#rpi3
ETH0_NAME="$(ip addr | grep 2: | awk '{print $2}' | tail -1  | sed s/://g)"

#rpi4
ETH0_NAME="eth0"

cd ~/smile-pi/setup_files/
sudo rm -rf /usr/lib/systemd/system/create_ap.service
sudo cp -rf create_ap.service /usr/lib/systemd/system/create_ap.service
sudo sed -i 's@ SMILE @ SMILE_'"$LAST_FOUR_MAC_ADDRESS"' @' /usr/lib/systemd/system/create_ap.service
sudo sed -i 's@ eth0 @ '"$ETH0_NAME"' @' /usr/lib/systemd/system/create_ap.service

# If not vagrant, i.e. booting up a rpi3
#if [ ! -d /vagrant ]; then
  echo "systemctl for create_ap"
  sudo systemctl daemon-reload
  sudo systemctl enable create_ap
  sudo systemctl stop create_ap
  sudo systemctl start create_ap
#fi

echo "setup nginx conf files"

cd ~
sudo rm -rf /home/pi/smile_v2
git clone https://bitbucket.org/smileconsortium/smile_v2.git
cd smile_v2
git checkout -b plug origin/plug
sudo cp ~/smile_v2/vagrant/nginx.conf /etc/nginx/nginx.conf
sudo cp ~/smile_v2/vagrant/proxy.conf /etc/nginx/proxy.conf
#https://stackoverflow.com/questions/584894/sed-scripting-environment-variable-substitution
#https://askubuntu.com/questions/20414/find-and-replace-text-within-a-file-using-commands
sudo sed -i 's@/vagrant@'"$HOME"/smile_v2/frontend/src'@' /etc/nginx/nginx.conf
sudo sed -i 's@/couchdb/(.*)      /$1  break;@/couchdb/(.*)      /smile/$1  break;@' /etc/nginx/nginx.conf
sudo sed -i 's@/couchdb           /    break;@/couchdb           /smile    break;@' /etc/nginx/nginx.conf

cd ~/smile-pi/setup_files/
sudo cp -rf etc_hosts /etc/hosts
echo "hosts file overwritten"

# To address nginx permissions issue, $HOME/smile_v2/frontend/src/ accessibility
sudo chmod +755 $HOME

echo "make sure one can ssh into the raspberry pi"
#https://raspberrypi.stackexchange.com/questions/73119/enabling-ssh-by-default-on-raspbian-stretch
#https://www.raspberrypi.org/documentation/remote-access/ssh/README.md
sudo touch /boot/ssh

echo "systemctl for nginx"
sudo systemctl daemon-reload
sudo systemctl enable nginx
sudo systemctl stop nginx
sudo systemctl start nginx

sudo systemctl enable ssh
sudo systemctl start ssh

cd; cd -
cd ~/smile-pi
