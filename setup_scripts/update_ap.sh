#!/usr/bin/env bash

echo "update SSID with LAST_FOUR_MAC_ADDRESS"

LAST_FOUR_MAC_ADDRESS="$(ip addr | grep link/ether | awk '{print $2}' | tail -1  | sed s/://g | tr '[:lower:]' '[:upper:]' | tail -c 5)"
ETH0_NAME="$(ip addr | grep 2: | awk '{print $2}' | tail -1  | sed s/://g)"

echo "new SSID: $LAST_FOUR_MAC_ADDRESS"
sudo sed -i 's/SMILE_F69F/SMILE_'"$LAST_FOUR_MAC_ADDRESS"'/' /usr/share/nginx/html/index.html

cd ~/smile-pi/setup_files/
sudo rm -rf /usr/lib/systemd/system/create_ap.service
sudo \cp -rf create_ap.service /usr/lib/systemd/system/create_ap.service
sudo sed -i 's@ SMILE @ SMILE_'"$LAST_FOUR_MAC_ADDRESS"' @' /usr/lib/systemd/system/create_ap.service
sudo sed -i 's@ eth0 @ '"$ETH0_NAME"' @' /usr/lib/systemd/system/create_ap.service

echo "reload systemctl"
sudo systemctl daemon-reload
sudo systemctl restart create_ap
