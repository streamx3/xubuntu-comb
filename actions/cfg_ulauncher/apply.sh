#!/bin/bash


RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Colour

printf "${GREEN}Applying Ulauncher configuration${NC}\n"

cp -rf ulauncher ~/.config/

cp -f /usr/share/applications/ulauncher.desktop .
echo "X-GNOME-Autostart-enabled=true" >> ulauncher.desktop

echo "Creating autostart shortcut for ulauncher"
cp -fv ulauncher.desktop $DIRECTORY
