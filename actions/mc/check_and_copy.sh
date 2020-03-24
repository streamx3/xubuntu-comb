#!/bin/bash

CONF_SUM1=$(md5sum data/mc/ini | sed "s/  data\/mc\/ini//g")

echo "Checking user "`whoami`
if [ -f  ~/.config/mc/ini ]; then
	echo "Config exist"
	CONF_SUM2=$(md5sum ~/.config/mc/ini | awk '{print $1}')
else 
	echo "Config does not exist"
	CONF_SUM2="N/A"
fi

if [[ "$CONF_SUM1" == "$CONF_SUM2" ]]
then
	echo "Skipping, user mc config is identical already"
else
	echo "Writing user config"
	cp -rfv ./data/mc ~/.config/
fi