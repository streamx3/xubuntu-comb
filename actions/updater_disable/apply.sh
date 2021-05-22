#!/bin/bash


RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Colour

printf "${GREEN}Disabling startup for Update Notifier${NC}\n"

if [ -d "/home/$(whoami)/.config/autostart" ]
then
	echo "User autostart directory exists."
else
	echo "User autostart directory missing. Creating..."
	mkdir ~/.config/autostart
fi

cp -rf update-notifier.desktop ~/.config/autostart/
