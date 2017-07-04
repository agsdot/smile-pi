#!/usr/bin/env bash

sudo rm -rf /usr/share/nginx/html/the_bible_project

cd

echo "download the_bible_project offline portal"
git clone https://github.com/canuk/the-bible-project-offline.git the_bible_project

echo "move edify_music to nginx"
sudo mv the_bible_project /usr/share/nginx/html/
sudo cp ~/smile-pi/portal_data_files/the_bible_project.txt /usr/share/nginx/html/the_bible_project/portal_data.txt
sudo cp ~/smile-pi/portal_data_files/the_bible_project.png /usr/share/nginx/html/the_bible_project/

cd; cd -
cd ~/smile-pi
