#!/bin/bash

this_dir="$(echo $0 | sed 's/install.sh//g')"
wallpaper_filename=$1

##### INSTALLATION #####

cd /tmp

# upgrade debian
sudo apt update -y

# First debloat the system
sudo apt autoremove $(cat "$this_dir/to_uninstall") --purge -y

# Then install packages
sudo apt install $(cat "$this_dir/to_install") -y

# install starship prompt on top of oh-my-zsh
curl -fsSL https://starship.rs/install.sh | bash

# install pywal
pip install pywal --break-system-packages

##### CONFIGURATION #####

cd ~

# apply theme with pywal
wal -i ~/Pictures/$wallpaper_filename

# create Projects folder
mkdir -p Repos

# clone dotfiles repository
cd Repos
git clone https://github.com/gbaudino/dotfiles.git
cd dotfiles

# copy configuration files stored in home
files=$(ls dots)
for file in $files; do
    mv ~/.$file ~/.$file.old
    cp ~/Projects/dotfiles/dots/$file ~/.$file
done

# copy starship configuration
mkdir -p ~/.config/starship
mv ~/.config/starship/starship.toml ~/.config/starship/starship.toml.old
cp ~/Projects/dotfiles/starship/starship.toml ~/.config/starship

# copy rofi configuration
mkdir -p ~/.config/rofi
mv ~/.config/rofi/config.rasi ~/.config/rofi/config.rasi.old
cp ~/Projects/dotfiles/rofi/config.rasi ~/.config/rofi

# set git default editor
git config --global core.editor "nano"
