#!/usr/bin/env bash

sudo pacman -S --noconfirm --needed unzip
sudo pacman -S --noconfirm --needed emacs-nox
sudo pacman -S --noconfirm --needed tmux

sudo sed -i 's@#en_US.UTF-8 UTF-8@en_US.UTF-8 UTF-8@' /etc/locale.gen
sudo locale-gen

echo "clone the plug branch of the smile_v2 repo"

if [ ! -d "~/smile_v2" ]; then
  cd
  git clone https://bitbucket.org/smileconsortium/smile_v2.git
  cd smile_v2
  git checkout -b plug origin/plug
  cd
fi

echo "setup nginx conf files"
sudo cp ~/smile_v2/vagrant/nginx.conf /etc/nginx/nginx.conf
sudo cp ~/smile_v2/vagrant/proxy.conf /etc/nginx/proxy.conf
#https://stackoverflow.com/questions/584894/sed-scripting-environment-variable-substitution
#https://askubuntu.com/questions/20414/find-and-replace-text-within-a-file-using-commands
sudo sed -i 's@/vagrant@'"$HOME"/smile_v2/frontend/src'@' /etc/nginx/nginx.conf

echo "setup smile_backend systemd service"
cp ~/smile_v2/vagrant/smile_backend.service /tmp/smile_backend.service
sed -i 's@/vagrant@'"$HOME"/smile_v2'@' /tmp/smile_backend.service
sudo cp /tmp/smile_backend.service /usr/lib/systemd/system/smile_backend.service

echo "configure elasticsearch"

sudo mkdir -p /var/lib/elasticsearch
sudo chown elasticsearch /var/lib/elasticsearch
sudo chgrp elasticsearch /var/lib/elasticsearch
sudo cp ~/smile_v2/vagrant/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

#sudo unzip analysis-icu*.zip -d analysis-icu/
# cruft from doing a manual elasticsearch-plugin install, left there for documentation purposes

cd /usr/share/elasticsearch/plugins/
sudo rm -rf *

echo "get elasticsearch marvel-agent plugin"
echo y | sudo elasticsearch-plugin install marvel-agent

echo "get elasticsearch-river-couchdb"
cd /tmp
sudo rm -rf *

sudo elasticsearch-plugin install elasticsearch/elasticsearch-river-couchdb/2.6.0 > /dev/null
sudo unzip elasticsearch-river-couchdb*.zip -d elasticsearch-river-couchdb

touch  /tmp/plugin-descriptor.properties
echo "
description=Elasticsearch River Couchdb
version=2.6.0
name=elasticsearch-river-couchdb
site=false
jvm=true
classname=org.elasticsearch.plugin.river.couchdb.CouchdbRiverPlugin
java.version=1.7
elasticsearch.version=2.3.5
isolated=false
" >> /tmp/plugin-descriptor.properties
sudo cp /tmp/plugin-descriptor.properties /tmp/elasticsearch-river-couchdb/plugin-descriptor.properties
sudo mv /tmp/elasticsearch-river-couchdb /usr/share/elasticsearch/plugins/elasticsearch-river-couchdb

echo "cleanup tmp dir"
cd /tmp
sudo rm -rf *

echo "install ~/smile_v2/backend node dependencies"
cd ~/smile_v2/backend/

# version of hiredis can be changed in package.json
sudo sed -i 's@0.1.17@0.5.0@' package.json

npm install

echo "npm packages put in"

cd ~/vagrant-archbox/setup_files/
sudo cp -rf create_ap.service /usr/lib/systemd/system/create_ap.service
sudo cp redis.service /usr/lib/systemd/system/redis.service
echo "redis.service accounted for"

cd ~/vagrant-archbox/setup_files/
sudo cp -rf etc_hosts /etc/hosts
echo "hosts file overwritten"

cp ~/vagrant-archbox/setup_files/couch_setup.sh ~/smile_v2/backend/assets/couchdb/couch_setup.sh
cd ~/smile_v2/backend/assets/couchdb/
chmod +x couch_setup.sh
./couch_setup.sh

# To address nginx permissions issue, $HOME/smile_v2/frontend/src/ accessibility
sudo chmod +755 $HOME

echo "systemctl for couch"
sudo systemctl enable couchdb
sudo systemctl start couchdb

echo "systemctl for elasticsearch"
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch

echo "systemctl for nginx"
sudo systemctl enable nginx
sudo systemctl start nginx

echo "systemctl for redis"
sudo systemctl enable redis
sudo systemctl start redis

echo "systemctl for smile_backend"
sudo systemctl enable smile_backend
sudo systemctl start smile_backend

echo "systemctl for create_ap"
sudo systemctl enable create_ap
sudo systemctl start create_ap
