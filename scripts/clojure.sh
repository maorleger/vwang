#!/bin/bash

set -x -e

CONFIG_DIR=~/.workstation_config

# install java
sudo apt-get install default-jre -y

# install clojure
cd $CONFIG_DIR
curl -O https://download.clojure.org/install/linux-install-1.9.0.315.sh
chmod +x linux-install-1.9.0.315.sh
sudo ./linux-install-1.9.0.315.sh

# install lein
cd ~/bin
wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
chmod +x lein

# setup joker
cd ~/bin
wget https://github.com/candid82/joker/releases/download/v0.8.8/joker-0.8.8-linux-amd64.zip
unzip joker-0.8.8-linux-amd64.zip
