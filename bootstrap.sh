#!/usr/bin/env bash

echo "$PWD"
echo "$HOME"
HOME="/home/vagrant"
echo "$HOME"

pacman -Syu
pacman -S --noconfirm --needed --force vim git wget base-devel

if [ ! -d "/tmp/sexy-bash-prompt" ]; then
  echo "making bash prompts better"
  (cd /tmp && git clone --depth 1 https://github.com/twolfson/sexy-bash-prompt && cd sexy-bash-prompt && make install) && source ~/.bashrc
fi

if [ ! -d "/tmp/quick-vim" ]; then
  echo "improve vim"
  git clone git://github.com/brianleroux/quick-vim.git /tmp/quick-vim
  cd /tmp/quick-vim
  ./quick-vim install
fi

echo "checking for aliases"
if ( ! grep -q 'bash_alias' ~/.bashrc )
then
  echo "bashrc doesn't have it"
  echo "if [ -f ~/.bash_aliases ]; then source ~/.bash_aliases; fi" >> ~/.bashrc
else
  echo "bashrc already had an alias"
fi


echo "installing rubies and javascripts"
pacman -S --noconfirm --needed nodejs
pacman -S --noconfirm --needed npm
pacman -S --noconfirm --needed python2
pacman -S --noconfirm --needed python2-pip
pacman -S --noconfirm --needed ruby
echo "done with rubies and javascriptrs"

if [ ! -f ~/.bash_aliases ]; then
  echo "setup aliases"
  touch ~/.bash_aliases
  echo "alias vi=vim" >> ~/.bash_aliases
  echo "alias ls='ls -aF --color'" >> ~/.bash_aliases
  echo "export EDITOR=vim" >> ~/.bash_aliases
  echo "export PYTHON=python2" >> ~/.bash_aliases
  echo "alias python=/usr/bin/python2" >> ~/.bash_aliases
  echo "alias pip=/usr/bin/pip2" >> ~/.bash_aliases
  export NPMPATH=$HOME/.node_modules/bin
  export GEMPATH=$(ruby -rubygems -e "puts Gem.user_dir")/bin
  #echo "export PATH=$PATH:$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$HOME/.node_modules/bin" >> ~/.bash_aliases
  echo "export npm_config_prefix=~/.node_modules" >> ~/.bash_aliases
  echo "export PATH=$PATH:$NPMPATH:$GEMPATH" >> ~/.bash_aliases
fi
source ~/.bash_aliases

echo "install compass"
gem install compass
echo "go no go install compass"
