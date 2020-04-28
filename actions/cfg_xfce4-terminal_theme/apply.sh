#!/bin/bash


RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Colour

printf "${GREEN}Applying xfce4-terminal scrollbar theme ${NC}\n"

sudo mv -v /usr/share/applications/xfce4-terminal.desktop /usr/share/applications/xfce4-terminal.desktop.bak &&  sudo cp -rf xfce4-terminal.desktop /usr/share/applications/
sudo cp -rf AT-Dark /usr/share/themes

