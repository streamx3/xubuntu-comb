#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Colour

printf "${GREEN}Configuring MC...${NC}\n"
bash ./check_and_copy.sh
sudo bash ./check_and_copy.sh
