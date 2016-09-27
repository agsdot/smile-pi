#!/usr/bin/env bash

sudo rm -rf  /usr/share/nginx/html/snap 
sudo rm -rf  /usr/share/nginx/html/code_monster

cd

echo "download snap"
git clone https://github.com/jmoenig/Snap--Build-Your-Own-Blocks snap

echo "download code_monster"
git clone https://github.com/glinden/code-monster-from-crunchzilla code_monster

echo "move snap and code_monster to nginx"

sudo mv snap /usr/share/nginx/html/
sudo mv code_monster /usr/share/nginx/html/
