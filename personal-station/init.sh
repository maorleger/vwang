#!/bin/bash

set -x -e

# Install dependencies
sudo add-apt-repository ppa:neovim-ppa/stable -y
sudo add-apt-repository ppa:jonathonf/vim -y
sudo apt-get update
sudo apt-get install vim neovim tmux git python unzip -y

# Setup workspace dir
mkdir ~/workspace && cd $_

