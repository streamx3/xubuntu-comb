#!/bin/bash


RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Colour

printf "${GREEN}Applying xfce4-terminal configuration ${NC}\n"

value=$( grep -ic "focal" /etc/lsb-release )
if [ $value -eq 1 ]
then
  printf "[ ${GREEN}OK${NC} ] Detected 20.04\n"
  cp -rf terminal ~/.config/xfce4/
else
  printf "[${RED}FAIL${NC}] Config is only tested on 20.04. Leaving.\n"
fi
