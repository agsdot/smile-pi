#!/usr/bin/env bash

echo "basic package"

if ( ! grep -q 'gitprompt.sh' ~/.bashrc ); then
  echo "install bash-git-prompt"

  cd ~
  git clone https://github.com/magicmonty/bash-git-prompt.git .bash-git-prompt --depth=1

  echo "alias vi=vim" >> ~/.bash_aliases
  echo "alias ls='ls -aF --color'" >> ~/.bash_aliases

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
sudo pacman -S --noconfirm --needed nodejs
sudo pacman -S --noconfirm --needed npm
sudo pacman -S --noconfirm --needed python2
sudo pacman -S --noconfirm --needed python2-pip
sudo pacman -S --noconfirm --needed ruby
echo "done with rubies and javascriptrs"


if [ ! -f ~/.npmrc ]; then
  touch ~/.npmrc
  echo "prefix=${HOME}/.node_modules" >> ~/.npmrc
fi

rm -rf ~/.bash_aliases
if [ ! -f ~/.bash_aliases ]; then
  echo "setup aliases"
  touch ~/.bash_aliases
  echo "alias vi=vim" >> ~/.bash_aliases
  echo "alias ls='ls -aF --color'" >> ~/.bash_aliases
  echo "export EDITOR=vim" >> ~/.bash_aliases
  echo "export PYTHON=python2" >> ~/.bash_aliases
  echo "alias python=/usr/bin/python2" >> ~/.bash_aliases
  echo "alias pip=/usr/bin/pip2" >> ~/.bash_aliases

  echo "export NODE_PATH=~/.node_modules/lib/node_modules:$NODE_PATH" >> ~/.bash_aliases
  echo "unset MANPATH" >> ~/.bash_aliases
  echo "export MANPATH=\"~/.node_modules/share/man:$(manpath)\"" >> ~/.bash_aliases

  echo "export NPMPATH=$HOME/.node_modules/bin" >> ~/.bash_aliases
  echo "export GEMPATH=$(ruby -rubygems -e 'puts Gem.user_dir')/bin" >> ~/.bash_aliases
  source ~/.bash_aliases
  echo "export PATH=$PATH:$NPMPATH:$GEMPATH" >> ~/.bash_aliases
fi
source ~/.bash_aliases

