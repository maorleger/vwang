#!/bin/bash

set -x -e

CONFIG_DIR=~/.workstation_config

# add nodejs and yarn repos
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -

echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

# install rcm
wget -qO - https://apt.thoughtbot.com/thoughtbot.gpg.key | sudo apt-key add -
echo "deb https://apt.thoughtbot.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/thoughtbot.list

# Install dependencies
sudo add-apt-repository ppa:neovim-ppa/stable -y
sudo add-apt-repository ppa:jonathonf/vim -y
sudo apt-get update
sudo apt-get install -y \
  vim \
  neovim \
  tmux \
  git \
  python \
  unzip \
  nodejs \
  yarn \
  rcm

# setup all directories that other scripts expect
mkdir -p $CONFIG_DIR
mkdir -p ~/bin

# download all dotfiles
git clone https://github.com/maorleger/dotfiles $HOME/.dotfiles
git clone https://github.com/braintreeps/vim_dotfiles $HOME/.vim

# install zsh and oh-myzsh
cd /tmp
sudo apt-get install zsh -y
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh
sed -i.tmp 's:env zsh -l::g' install.sh
sed -i.tmp 's:chsh -s .*$::g' install.sh
sh install.sh

# oh-my-zsh will move the current .zshrc to a pre version if it exists so I need to replace the symlink after the fact
cd ~
rm -rf ~/.zshrc

# Activate all dotfiles
env RCRC=$HOME/.dotfiles/rcrc rcup
$HOME/.vim/activate.sh

# Add pairing specific vim config
echo "
set nobackup
set nowb
set noswapfile
" >> $HOME/.vimrc_local

# Setup workspace dir
mkdir -p $HOME/workspace && cd $HOME/workspace

# setup gitconfig defaults
git config --global core.editor "vim"
git config --global push.default simple

# install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo 'finished init script'
