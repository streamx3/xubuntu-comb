#!/bin/bash


RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Colour

printf "${GREEN}Applying xconfg and xfce4-panel configuration${NC}\n"

cp -rf panel ~/.config/xfce4/
cp -rf xfconf ~/.config/xfce4/

