#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Colour

printf "${GREEN}Configuring MC...${NC}\n"

CONF_SUM1=$(md5sum data/mc/ini | sed "s/  data\/mc\/ini//g")

echo "Checking user "`whoami`
if [ -f  ~/.config/mc/ini ]; then
	echo "Config exist"
	CONF_SUM2=$(md5sum ~/.config/mc/ini | awk '{print $1}')
else 
	echo "Config does not exist"
	CONF_SUM2="N/A"
fi

sudo cp -rfv ./data/mc /root/.config/

