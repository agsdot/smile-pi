#!/usr/bin/env bash

sudo rm -rf /usr/share/nginx/html/edify_music

cd

echo "download edify_music"
git clone https://github.com/canuk/edify_music.git

echo "move edify_music to nginx"
sudo mv edify_music /usr/share/nginx/html/
sudo cp ~/smile-pi/portal_data_files/edify_music.txt /usr/share/nginx/html/edify_music/portal_data.txt
sudo cp ~/smile-pi/portal_data_files/edify_music.png /usr/share/nginx/html/edify_music/

cd; cd -
cd ~/smile-pi
