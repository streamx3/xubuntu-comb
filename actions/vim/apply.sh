#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Colour

printf "${GREEN}Configuring VIM...${NC}\n"
sudo su -c "echo -e \"
set number
set tabstop=4
set statusline+=%F
set laststatus=2
\" >> /etc/vim/vimrc"
