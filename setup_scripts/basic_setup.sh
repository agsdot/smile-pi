#!/usr/bin/env bash

echo "basic package"

if [ -f "/usr/lib/systemd/system/create_ap.service" ]; then
  echo "create_ap service and Wifi network already configured"
  echo "re-download a fresh create_ap.service template and reconfigure"
  cd ~
  rm -rf ~/vagrant-archbox
  git clone https://github.com/agsdot/vagrant-archbox
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

echo "installing rubies and javascripts"
# sudo pacman -S --noconfirm --needed nodejs
# sudo pacman -S --noconfirm --needed npm

### manual install of nodejs 0.10.25 ###
### until fix found, the new version node 6.2 affects image upload and socket io ###

if [ ! -f "$HOME/.node_module/bin/node" ]; then
  echo "setup nodejs 0.10.25"
  cd ~ && mkdir node-v0.10.25
  cd node-v0.10.25

  # If not vagrant, i.e. booting up a rpi3
  if [ ! -d /vagrant ]; then
    wget http://nodejs.org/dist/v0.10.25/node-v0.10.25-linux-arm-pi.tar.gz --progress=bar:force
    cd ~ && mkdir .node_modules
    cd .node_modules
    tar --strip-components 1 -xzf ~/node-v0.10.25/node-v0.10.25-linux-arm-pi.tar.gz
  else
    wget http://nodejs.org/dist/v0.10.25/node-v0.10.25-linux-x64.tar.gz --progress=bar:force
    cd ~ && mkdir .node_modules
    cd .node_modules
    tar --strip-components 1 -xzf ~/node-v0.10.25/node-v0.10.25-linux-x64.tar.gz
  fi

fi

### manual install of nodejs 0.10.25 ###
sudo pacman -S --noconfirm --needed python2
sudo pacman -S --noconfirm --needed python2-pip
sudo pacman -S --noconfirm --needed ruby
echo "done with rubies and pythons"

if [ ! -f ~/.npmrc ]; then
  echo "setup ~/.npmrc"
  touch ~/.npmrc
  echo "prefix=${HOME}/.node_modules" >> ~/.npmrc
  echo "python=/usr/bin/python2" >> ~/.npmrc
fi

if [ ! -f ~/.gitconfig ]; then
  echo "setup ~/.gitconfig"
  cp ~/vagrant-archbox/setup_files/.gitconfig ~/.gitconfig
fi

if [ ! -f ~/.bash_aliases ]; then
  echo "setup ~/.bash_aliases"
  cp ~/vagrant-archbox/setup_files/.bash_aliases ~/.bash_aliases
fi
source ~/.bash_aliases

# for npm stuffs #
# source ~/.bash_aliases
# http://stackoverflow.com/questions/30281057/node-forever-usr-bin-env-node-no-such-file-or-directory
# https://github.com/nodejs/node-v0.x-archive/issues/3911
#echo "softlink node and npm to /usr/bin location"
#sudo ln -s "$(which node)" /usr/bin/node
#sudo ln -s "$(which npm)" /usr/bin/npm
echo "make npm up to date"
#$HOME/.node_modules/bin/npm config set python /usr/bin/python2
#https://github.com/nodejs/node-v0.x-archive/issues/3911
PATH="$PATH:$HOME/.node_modules/bin" $HOME/.node_modules/bin/npm install -g npm
####

#if [ ! -f "/usr/bin/yaourt" ]; then
#
#  echo "yaourt install dependencies"
#  sudo pacman -S --noconfirm --needed yajl
#
#  cd /tmp
#  git clone https://aur.archlinux.org/package-query.git
#  cd package-query
#  echo y | makepkg -si
#  cd ..
#  git clone https://aur.archlinux.org/yaourt.git
#  cd yaourt
#  echo y | makepkg -si
#  cd ..
#  # If not vagrant, i.e. booting up a rpi3
#  if [ ! -d /vagrant ]; then
#    echo "install create_ap"
#    yaourt -S --noconfirm create_ap
#  fi
#
#fi

# pacman now has create_ap in it's repo
sudo pacman -S --noconfirm --needed create_ap

echo "install compass"
gem install compass --no-ri --no-rdoc

#https://github.com/nodejs/node-gyp/issues/454
echo "install node-gyp"
$HOME/.node_modules/bin/npm install -g node-gyp

echo "install nginx"
sudo pacman -S --noconfirm --needed nginx

echo "setup create_ap"

LAST_FOUR_MAC_ADDRESS="$(ip addr | grep link/ether | awk '{print $2}' | tail -1  | sed s/://g | tr '[:lower:]' '[:upper:]' | tail -c 5)"

cd ~/vagrant-archbox/setup_files/
sudo rm -rf /usr/lib/systemd/system/create_ap.service
sudo cp -rf create_ap.service /usr/lib/systemd/system/create_ap.service
sudo sed -i 's@ SMILE @ SMILE_'"$LAST_FOUR_MAC_ADDRESS"' @' /usr/lib/systemd/system/create_ap.service

# If not vagrant, i.e. booting up a rpi3
#if [ ! -d /vagrant ]; then
  echo "systemctl for create_ap"
  sudo systemctl enable create_ap
  sudo systemctl stop create_ap
  sudo systemctl start create_ap
#fi

echo "setup nginx conf files"

cd ~
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

cd ~/vagrant-archbox/setup_files/
sudo cp -rf etc_hosts /etc/hosts
echo "hosts file overwritten"

# To address nginx permissions issue, $HOME/smile_v2/frontend/src/ accessibility
sudo chmod +755 $HOME

echo "systemctl for nginx"
sudo systemctl enable nginx
sudo systemctl stop nginx
sudo systemctl start nginx

cd; cd -
cd ~/vagrant-archbox
