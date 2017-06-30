#!/usr/bin/env bash

sudo rm -rf  /usr/share/nginx/html/smile-bible-for-children

cd

echo "download smile-bible-for-children"
git clone https://github.com/canuk/smile-bible-for-children

echo "download smile-web-bible"
git clone https://github.com/canuk/smile-web-bible

echo "download smile-web-bible"
git clone https://github.com/canuk/smile-bible-asv

# echo "download code_monster"
# git clone https://github.com/glinden/code-monster-from-crunchzilla code_monster
#
# echo "move snap and code_monster to nginx"

echo "move smile-bible-for-children to nginx"
sudo mv smile-bible-for-children /usr/share/nginx/html/

echo "move smile-web-bible to nginx"
sudo mv smile-web-bible /usr/share/nginx/html/

echo "move smile-bible-asv to nginx"
sudo mv smile-bible-asv /usr/share/nginx/html/

cd; cd -
cd ~/vagrant-archbox
