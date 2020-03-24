#!/bin/bash


RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Colour

printf "${GREEN}Adding PPAs and repos${NC}\n"

printf "${GREEN}Adding SublimeText${NC}\n"
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

printf "${GREEN}Adding Ulauncher${NC}\n"
sudo add-apt-repository ppa:agornostal/ulauncher


sudo apt-get update
sudo apt-get install sublime-text ulauncher
