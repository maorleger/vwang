#!/bin/bash

set -x -e

CONFIG_DIR=~/.workstation_config/jeff

# setup jeff's vim
mkdir -p ~/.config/nvim/
mkdir -p $CONFIG_DIR

echo "
set runtimepath^=$CONFIG_DIR/.dotfiles/.vim runtimepath+=$CONFIG_DIR/.dotfiles/.vim/after
let &packpath = &runtimepath
source $CONFIG_DIR/.dotfiles/.vimrc
" > ~/.config/nvim/init.vim

git clone https://github.com/jschomay/.dotfiles.git $CONFIG_DIR/.dotfiles

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
sed -i.tmp 's:colorscheme \(.*\):try | colorscheme \1 | catch | endtry:g' $CONFIG_DIR/.dotfiles/.vimrc
nvim +PluginInstall +qall

# pull down jeff's clojure repo
mkdir -p ~/workspace/exercism/clojure
cd $_
git clone https://github.com/jschomay/clojure-exercism .

