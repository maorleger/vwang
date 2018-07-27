#!/bin/bash

set -x -e

CONFIG_DIR=~/.workstation_config

# Install dependencies
sudo add-apt-repository ppa:neovim-ppa/stable -y
sudo add-apt-repository ppa:jonathonf/vim -y
sudo apt-get update
sudo apt-get install vim neovim tmux git python unzip -y

# setup all directories that other scripts expect
mkdir -p $CONFIG_DIR
mkdir -p ~/bin

# download my dotfiles
cd $CONFIG_DIR
git clone https://github.com/maorleger/dot_files $CONFIG_DIR/maor_dotfiles
cd ~
ln -s $CONFIG_DIR/maor_dotfiles/.lein .
ln -s $CONFIG_DIR/maor_dotfiles/.tmux.conf .
ln -s $CONFIG_DIR/maor_dotfiles/.vimrc.bundles.local .
ln -s $CONFIG_DIR/maor_dotfiles/.vimrc_local .
ln -s $CONFIG_DIR/maor_dotfiles/.gitconfig .

# setup braintree's vim dotfiles
cd $CONFIG_DIR
git clone https://github.com/braintreeps/vim_dotfiles braintree_dotfiles
cd braintree_dotfiles
./activate.sh

# Add pairing specific vim config
echo "
set nobackup
set nowb
set noswapfile
" >> ~/.vimrc_local

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
ln -s $CONFIG_DIR/maor_dotfiles/.zshrc .

# Setup workspace dir
mkdir -p ~/workspace && cd $_

# setup gitconfig defaults
git config --global core.editor "vim"
git config --global push.default simple

echo 'finished init script'
