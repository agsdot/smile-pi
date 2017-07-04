#!/usr/bin/env bash

sudo rm -rf  /usr/share/nginx/html/snap
sudo rm -rf  /usr/share/nginx/html/code_monster
sudo rm -rf  /usr/share/nginx/html/blockly-games-en
sudo rm -rf  /usr/share/nginx/html/jslogo

cd

echo "download snap and add to nginx"
git clone https://github.com/jmoenig/Snap--Build-Your-Own-Blocks snap
sudo mv snap /usr/share/nginx/html/
sudo cp ~/smile-pi/portal_data_files/snap.txt /usr/share/nginx/html/snap/portal_data.txt
sudo cp ~/smile-pi/portal_data_files/snap-byob.png /usr/share/nginx/html/snap/

echo "download code_monster and add to nginx"
git clone https://github.com/glinden/code-monster-from-crunchzilla code_monster
sudo mv code_monster /usr/share/nginx/html/
sudo cp ~/smile-pi/portal_data_files/code_monster.txt /usr/share/nginx/html/code_monster/portal_data.txt
sudo cp ~/smile-pi/portal_data_files/code-monster.png /usr/share/nginx/html/code_monster/

echo "download blockly games and add to nginx"
git clone https://github.com/canuk/blockly-games-offline.git blockly-games-offline
cd blockly-games-offline
unzip blockly-games-en.zip
sudo mv blockly-games /usr/share/nginx/html/blockly-games-en
sudo cp ~/smile-pi/portal_data_files/blockly_games.txt /usr/share/nginx/html/blockly-games-en/portal_data.txt
sudo cp ~/smile-pi/portal_data_files/blockly-games-logo.png /usr/share/nginx/html/blockly-games-en/

echo "download jslogo and add to nginx"
git clone https://github.com/inexorabletash/jslogo.git jslogo
sudo mv jslogo /usr/share/nginx/html/
sudo cp ~/smile-pi/portal_data_files/jslogo.txt /usr/share/nginx/html/jslogo/portal_data.txt
sudo cp ~/smile-pi/portal_data_files/jslogo.png /usr/share/nginx/html/jslogo/

cd; cd -
cd ~/smile-pi
