#!/usr/bin/bash
mkdir Installed_Packages
cd Installed_Packages
xargs -n 1 curl -O < ../Kernal-6.18.2_Firmware-20251125-2.url
ls | awk '{print "file://"$1" \\"}' > packages_pacman.list
xargs -a packages_pacman.list sudo pacman -U
