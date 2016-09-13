#!/usr/bin/env bash

echo ""
echo "kalite setup"
echo ""

rm -rf ~/.kalite/database/data.sqlite
rm -rf ~/.kalite/secretkey.txt

echo "pip install ka-lite"
#http://stackoverflow.com/questions/29466663/memory-error-while-using-pip-install-matplotlib
sudo /usr/bin/pip2 --no-cache-dir install ka-lite

rm -rf ~/kalite_files
mkdir -p ~/kalite_files

echo "downloading english content pack for kalite"
cd ~/kalite_files
wget http://pantry.learningequality.org/downloads/ka-lite/0.16/content/contentpacks/en.zip

cd ~/kalite_files
#(download file by torrenting it)
echo "downloading and torrenting a 38 gb file"
echo "if at all possible try to seed/torrent this file from another nearby computer on the same subnet, it should expedite the process"
echo "http://pantry.learningequality.org/downloads/ka-lite/0.16/content/ka-lite-0.16-resized-videos-english.torrent"
wget http://pantry.learningequality.org/downloads/ka-lite/0.16/content/ka-lite-0.16-resized-videos-english.torrent
sudo pacman -S aria2 --noconfirm --needed
aria2c ka-lite-0.16-resized-videos-english.torrent --seed-time=0

echo "kalite manage setup"
/usr/bin/kalite manage setup --username=kalitedbadmin --password=kalitedbadmin123 --noinput

echo "move videos in ~/.kalite/content directory"
mv ~/.kalite/content/ ~/.kalite/content_backup/
mv ~/kalite_files/ka-lite-0.16-resized-videos ~/.kalite/content/
cp -r ~/.kalite/content_backup/assessement ~/.kalite/content/

echo "/usr/bin/kalite manage retrievecontentpack local en ~/kalite_files/en.zip"
echo "this may take awhile, as in 30 minutes plus or so..."
/usr/bin/kalite manage retrievecontentpack local en ~/kalite_files/en.zip

echo "kalite manage setup, run it again for safekeeping, new content was added to the ~/.kalite directory"
rm -rf ~/.kalite/database/data.sqlite
# make sure videos in content directory are loaded
echo "DO_NOT_RELOAD_CONTENT_CACHE_AT_STARTUP = False" >> ~/.kalite/settings.py
# https://github.com/learningequality/ka-lite/issues/4991
/usr/bin/kalite manage setup --username=kalitedbadmin --password=kalitedbadmin123 --noinput

cd ~
rm -rf ~/vagrant-archbox
git clone https://github.com/agsdot/vagrant-archbox

sudo cp ~/vagrant-archbox/setup_files/kalite.service /usr/lib/systemd/system/
sudo systemctl enable kalite
sudo systemctl start kalite
