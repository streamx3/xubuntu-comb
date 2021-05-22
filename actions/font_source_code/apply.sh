#!/bin/bash


RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Colour

printf "${GREEN}Installing Source Code Pro from Adobe's github repo:${NC}\n"
git clone https://github.com/adobe-fonts/source-code-pro.git
cd source-code-pro
mv -v OTF source-code-pro
sudo cp -rf source-code-pro /usr/share/fonts/opentype/
cd ..
rm -rf source-code-pro

