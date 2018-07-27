#!/bin/bash

set -x -e

echo 'starting docker install'

# setup the docker ce repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
apt-cache policy docker-ce

# install docker
sudo apt-get install -y docker-ce docker-compose

# add user to the docker group
sudo usermod -aG docker ubuntu

echo 'finished docker install'
