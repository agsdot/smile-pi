#!/usr/bin/env bash

HOME="/home/vagrant"
echo "$HOME"

echo "clone the plug branch of the smile_v2 repo"

rm -rf ~/smile_v2
if [ ! -d "~/smile_v2" ]; then
  cd
  git clone https://bitbucket.org/smileconsortium/smile_v2.git
  cd smile_v2
  git checkout -b plug origin/plug
  cd
fi
echo "thats all folks"


