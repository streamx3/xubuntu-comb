#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Colour

printf "${GREEN}Copying yakuakerc...${NC}\n"
cp -vf yakuakerc ~/.config/

cp -v /usr/share/applications/org.kde.yakuake.desktop .
sed -i '/^$/d' org.kde.yakuake.desktop
echo "X-GNOME-Autostart-enabled=true" >> org.kde.yakuake.desktop
echo "" >> org.kde.yakuake.desktop
mv -v org.kde.yakuake.desktop ~/.config/autostart/
