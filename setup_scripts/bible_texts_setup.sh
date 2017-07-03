#!/usr/bin/env bash

sudo rm -rf /usr/share/nginx/html/bible_for_children
sudo rm -rf /usr/share/nginx/html/bible_web
sudo rm -rf /usr/share/nginx/html/bible_asv

cd

echo "download bible_for_children"
git clone https://github.com/canuk/bible_for_children

echo "download bible_web"
git clone https://github.com/canuk/bible_web

echo "download bible_asv"
git clone https://github.com/canuk/bible_asv

# echo "download code_monster"
# git clone https://github.com/glinden/code-monster-from-crunchzilla code_monster
#
# echo "move snap and code_monster to nginx"

echo "move bible_for_children to nginx"
sudo mv bible_for_children /usr/share/nginx/html/

echo "move bible_web to nginx"
sudo mv bible_web /usr/share/nginx/html/

echo "move bible_asv to nginx"
sudo mv bible_asv /usr/share/nginx/html/

cd; cd -
cd ~/smile-pi
