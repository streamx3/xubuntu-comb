#!/bin/bash


RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Colour

printf "${GREEN}Disabling startup for Update Notifier${NC}\n"

cp -rf update-notifier.desktop ~/.config/autostart/
