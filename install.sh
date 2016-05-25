#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

sudo echo "" > /dev/null
printf "${GREEN}Cursors: Painting Black!${NC}\n"
sudo cp -rf /usr/share/icons/DMZ-Black/cursors/* /usr/share/icons/DMZ-White/cursors

printf "${GREEN}Adding Chrome repo...${NC}\n"
echo "### THIS FILE IS AUTOMATICALLY CONFIGURED ###" > google-chrome.list
echo "# You may comment out this entry, but any other modifications may be lost." >> google-chrome.list
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> google-chrome.list
sudo mv -fv google-chrome.list /etc/apt/sources.list.d/

printf "${GREEN}Adding Chrome repo key...${NC}\n"
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

printf "${GREEN}Updating repo list...${NC}\n"
sudo apt-get update

printf "${GREEN}Getting aptitude...${NC}\n"
sudo apt-get install -y aptitude

printf "${GREEN}Installing everyting...${NC}\n"
sudo aptitude install -y vim mc rar unrar pv htop meld qtcreator git gitg tmux \
    mercurial tortoisehg vlc audacious gdebi synaptic ipython ipython3 minicom \
    ipython-qtconsole ipython3-qtconsole python-pip python3-pip gpicview \
    gparted gnome-do filezilla xfonts-terminus guake tilda openssh-server \
    xubuntu-restricted-extras google-chrome-stable wireshark iftop kdiff3 \
    krusader libssl-dev libncurses5-dev unzip gawk subversion youtube-dl \
    linux-headers arduino exfat-fuse exfat-utils

printf "${GREEN}Removing crap...${NC}\n"
sudo aptitude purge -y ristretto gnome-mines gnome-sudoku xfburn simple-scan \
    parole

printf "${GREEN}Configuring VIM...${NC}\n"
sudo su -c "echo -e \"
set number
set tabstop=4
set statusline+=%F
set laststatus=2
\" >> /etc/vim/vimrc"


printf "${GREEN}Patching users .bashrc...${NC}\n"
echo -e "export PS1=\"\[\033[38;5;2m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\] \w \[$(tput sgr0)\]\[\033[38;5;2m\]\\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\"
alias mc=\"mc -S dark\"
" >> ~/.bashrc


printf "${GREEN}Patching root's .bashrc...${NC}\n"
sudo su -s "echo -e \"export PS1=\"\[\033[38;5;1m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\] \w \[$(tput sgr0)\]\[\033[38;5;1m\]\\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\"
alias mc=\"mc -S dark\"
" >> /root/.bashrc"

printf "${GREEN}Adding current user to dialout group...${NC}\n"
sudo adduser `whoami` dialout

printf "${GREEN}Performing full upgrade...${NC}\n"
sudo aptitude full-upgrade -y

printf "${GREEN}Cleaning cache...${NC}\n"
sudo aptitude autoclean
sudo aptitude clean

printf "${RED}Rebooting in 5...${NC}\n"
sleep 1
printf "${RED}Rebooting in 4...${NC}\n"
sleep 1
printf "${RED}Rebooting in 3...${NC}\n"
sleep 1
printf "${RED}Rebooting in 2...${NC}\n"
sleep 1
printf "${RED}Rebooting in 1...${NC}\n"
sleep 1

sudo reboot
