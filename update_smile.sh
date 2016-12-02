#!/usr/bin/env bash
echo "pull the plug branch of the smile_v2 repo"

if [ ! -d "~/smile_v2" ]; then
  cd ~/smile_v2
  git fetch --all
  git reset --hard  origin/plug
  cd
fi

echo "install ~/smile_v2/backend node dependencies"
cd ~/smile_v2/backend/

# version of hiredis can be changed in package.json
sudo sed -i 's@0.1.17@0.5.0@' package.json

PATH="$PATH:$HOME/.node_modules/bin" $HOME/.node_modules/bin/npm install

echo "npm packages put in"

### troubleshooting code, may remove later , to get smile_backend service working ####
sudo chmod +755 $HOME/smile_v2
sudo chmod +755 $HOME/smile_v2/backend
sudo chmod +755 $HOME/smile_v2/backend/main.js

echo "restart smile_backend"
sudo systemctl restart smile_backend

cp ~/vagrant-archbox/setup_files/couch_setup.sh ~/smile_v2/backend/assets/couchdb/couch_setup.sh
cd ~/smile_v2/backend/assets/couchdb/
chmod +x couch_setup.sh
sh couch_setup.sh

cd; cd -
cd ~/vagrant-archbox
