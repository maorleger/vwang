#!/bin/bash

set -x -e

# Install dependencies
sudo add-apt-repository ppa:neovim-ppa/stable -y
sudo add-apt-repository ppa:jonathonf/vim -y
sudo apt-get update
sudo apt-get install vim neovim tmux git python unzip -y

# Setup workspace dir
mkdir ~/workspace && cd $_

# download my dotfiles
git clone https://github.com/maorleger/dot_files ~/workspace/maor_dotfiles
cd ~/
ln -s ~/workspace/maor_dotfiles/.lein .
ln -s ~/workspace/maor_dotfiles/.tmux.conf .
ln -s ~/workspace/maor_dotfiles/.vimrc.bundles.local .
ln -s ~/workspace/maor_dotfiles/.vimrc_local .

# setup braintree's vim dotfiles
cd ~/workspace
git clone https://github.com/braintreeps/vim_dotfiles
cd vim_dotfiles
./activate.sh

# TODO
# setup jeff's vim
mkdir -p ~/.config/nvim/
echo "
set runtimepath^=~/jeff/.vim runtimepath+=~/jeff/.vim/after
let &packpath = &runtimepath
source ~/jeff/.vimrc
" > ~/.config/nvim/init.vim

git clone https://github.com/jschomay/.vim.git ~/jeff/.vim
ln -s ~/jeff/.vim/vimrc ~/jeff/.vimrc
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
sed -i.tmp 's:colorscheme \(.*\):try | colorscheme \1 | catch | endtry:g' ~/jeff/.vimrc
nvim +PluginInstall +qall

# add some local stuff to my vim config
echo "
set nobackup
set nowb
set noswapfile
" >> ~/.vimrc_local

# install java
sudo apt-get install default-jre -y

# install clojure
curl -O https://download.clojure.org/install/linux-install-1.9.0.315.sh
chmod +x linux-install-1.9.0.315.sh
sudo ./linux-install-1.9.0.315.sh

# install lein
mkdir ~/bin
cd $_
wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
chmod +x lein

# install exercism
cd ~/bin
wget https://github.com/exercism/cli/releases/download/v2.4.1/exercism-linux-64bit.tgz
tar -xzvf exercism-linux-64bit.tgz

# Configure exercism
~/bin/exercism configure --key $(cat /tmp/jeff.exercism)
~/bin/exercism configure --dir ~/workspace/exercism
mkdir -p ~/workspace/exercism/clojure
cd $_
git clone https://github.com/jschomay/clojure-exercism .

# setup gitconfig
git config --global core.editor "vim"
git config --global push.default simple

# setup joker
cd ~/bin
wget https://github.com/candid82/joker/releases/download/v0.8.8/joker-0.8.8-linux-amd64.zip
unzip joker-0.8.8-linux-amd64.zip

# give jeff access
cat /tmp/jeff_key.pub >> ~/.ssh/authorized_keys

# install zsh and oh-myzsh
cd /tmp
sudo apt-get install zsh -y
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh
sed -i.tmp 's:env zsh::g' install.sh
sed -i.tmp 's:chsh -s .*$::g' install.sh
sh install.sh

# oh-my-zsh will move the current .zshrc to a pre version if it exists so I need to replace the symlink after the fact
cd ~
rm -rf ~/.zshrc
ln -s ~/workspace/maor_dotfiles/.zshrc .

