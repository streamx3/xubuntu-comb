#!/bin/bash


RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Colour

printf "${GREEN}Applying Ulauncher configuration${NC}\n"

cp -rf ulauncher ~/.config/

cp -f /usr/share/applications/ulauncher.desktop .
echo "X-GNOME-Autostart-enabled=true" >> ulauncher.desktop

if [ -d "/home/$(whoami)/.config/autostart" ]
then
	echo "User autostart directory exists."
else
	echo "User autostart directory missing. Creating..."
	mkdir ~/.config/autostart
fi

echo "Creating autostart shortcut for ulauncher"
cp -fv ulauncher.desktop ~/.config/autostart/
