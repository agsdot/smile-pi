#!/usr/bin/env bash
cd

echo "Install SQLite"
sudo apt-get --yes --force-yes install php5-sqlite

sudo rsync -Pavz rsync://dev.worldpossible.org/rachelmods/en-worldmap-10 /usr/share/nginx/html/world-map
sudo mv /usr/share/nginx/html/world-map/map.html /usr/share/nginx/html/world-map/index.html

sudo mv ~/smile-pi/setup_files/marker-icon@2x.png /usr/share/nginx/html/world-map/lib/leaflet/images/marker-icon@2x.png

sudo cp ~/smile-pi/portal_data_files/world_map.txt /usr/share/nginx/html/world-map/portal_data.txt
sudo cp ~/smile-pi/portal_data_files/world_map.png /usr/share/nginx/html/world-map/

cd; cd -
cd ~/smile-pi
