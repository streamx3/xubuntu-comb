#!/bin/bash


RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Colour

printf "${GREEN}Installing Source Code Pro from Adobe's github repo:${NC}\n"
wget -c https://github.com/probil/Monaco-IDE-font/raw/master/dist/Monaco.ttf
sudo mv -v Monaco.ttf /usr/share/fonts/
fc-cache -f -v
