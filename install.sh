#!/usr/bin/bash
sudo ./add_user.sh
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
yay --needed - < packages
cp -r .config $HOME
cp -r home/* $HOME
dms
