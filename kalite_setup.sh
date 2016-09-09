#!/usr/bin/env bash

echo ""
echo "kalite setup"
echo ""

rm -rf ~/.kalite/database/data.sqlite
rm -rf ~/.kalite/secretkey.txt

#http://stackoverflow.com/questions/29466663/memory-error-while-using-pip-install-matplotlib
sudo /usr/bin/pip2 --no-cache-dir install ka-lite

rm -rf ~/kalite_files
mkdir -p ~/kalite_files
cd ~/kalite_files

wget http://pantry.learningequality.org/downloads/ka-lite/0.16/content/contentpacks/en.zip

wget http://pantry.learningequality.org/downloads/ka-lite/0.16/content/ka-lite-0.16-resized-videos-english.torrent

sudo pacman -S aria2 --noconfirm --needed
#(download file by torrenting it)
#aria2c ka-lite-0.16-resized-videos-english.torrent --seed-time=0

/usr/bin/kalite manage setup --username=kalitedbadmin --password=kalitedbadmin123 --noinput

/usr/bin/kalite manage retrievecontentpack local en ~/kalite_files/en.zip

cd ~
rm -rf ~/vagrant-archbox
git clone https://github.com/agsdot/vagrant-archbox

sudo cp ~/vagrant-archbox/setup_files/kalite.service /usr/lib/systemd/system/
sudo systemctl enable kalite
sudo systemctl start kalite
