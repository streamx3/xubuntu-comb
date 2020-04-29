#!/bin/bash


RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Colour

printf "${GREEN}Checking and user autostart directory${NC}\n"

UNAME=`whoami`
DIRECTORY="/home/${UNAME}/.config/autostart"
if [[ -d "$DIRECTORY" ]]
then
  echo "$DIRECTORY exists on your filesystem."
else
  echo "$DIRECTORY does not exists on your filesystem. Creating..."
  mkdir -v $DIRECTORY
fi
