#!/usr/bin/env bash

echo "basic package"

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

### manual install of nodejs 0.10.25 ###
sudo pacman -S --noconfirm --needed python2
sudo pacman -S --noconfirm --needed python2-pip
sudo pacman -S --noconfirm --needed ruby
echo "done with rubies and javascriptrs"

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
