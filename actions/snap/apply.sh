#!/bin/bash


RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Colour

printf "${GREEN}Installing snaps:${NC}\n"

printf "${GREEN}Installing GitKraken...${NC}\n"
sudo snap install gitkraken
printf "${GREEN}Installing PyCharm Pro...${NC}\n"
sudo snap install --classic pycharm-professional
printf "${GREEN}Installing Visual Studio Code...${NC}\n"
sudo snap install --classic vscode
printf "${GREEN}Installing Go...${NC}\n"
sudo snap install --classic --channel=latest/stable go
printf "${GREEN}Installing Skype...${NC}\n"
sudo snap install --classic skype
printf "${GREEN}Installing Slack...${NC}\n"
sudo snap install --classic slack
