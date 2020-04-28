#!/bin/bash


RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Colour

printf "${GREEN}Applying xfce4-terminal configuration ${NC}\n"

cp -rf terminal ~/.config/xfce4/

