#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Colour

sudo echo "" > /dev/null
printf "${GREEN}Cursors: Painting Black!${NC}\n"
sudo cp -rf /usr/share/icons/DMZ-Black/cursors/* /usr/share/icons/DMZ-White/cursors

printf "${GREEN}Updating repo list...${NC}\n"
sudo apt-get update

printf "${GREEN}Getting aptitude...${NC}\n"
sudo apt-get install -y aptitude

printf "${GREEN}Installing everyting...${NC}\n"
sudo aptitude install -y \
    acpi exfat-fuse exfat-utils filezilla gdebi \
    gpicview mc meld openssh-server p7zip-full rar \
    unrar unzip vim vlc xfce4-goodies xfonts-terminus \
    xubuntu-restricted-addons \
    baobab cmake cu elinks gawk git gitg gitk gparted \
    htop iftop ipython3 \
    kdiff3 kismet krename krusader libncurses5-dev libssl-dev linssid \
    linux-headers minicom nmap nmon pv python-pip python3-pip qt5-default \
    rpm rtorrent sqlite3 sqlitebrowser tasksel texlive tilda tmux \
    wireshark xclip yakuake zeal

#DEVELOPMENT ACTIONS BEGIN

printf "${GREEN}Configuring VIM...${NC}\n"
sudo su -c "echo -e \"
set number
set tabstop=4
set statusline+=%F
set laststatus=2
\" >> /etc/vim/vimrc"

printf "${GREEN}Adding current user to dialout group...${NC}\n"
sudo adduser `whoami` dialout

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

#DEVELOPMENT ACTIONS END

printf "${GREEN}Removing crap...${NC}\n"
sudo aptitude purge -y gnome-mines gnome-sudoku simple-scan parole sgt-launcher sgt-puzzles

printf "${GREEN}Fixing hddtemp...${NC}\n"
sudo chmod u+s /usr/sbin/hddtemp

printf "${GREEN}Patching users .bashrc...${NC}\n"
echo -e "
export PS1=\"\[\033[38;5;2m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\] \w \[$(tput sgr0)\]\[\033[38;5;2m\]\\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\"
alias mc='mc -S dark'
" >> ~/.bashrc

printf "${GREEN}Patching root's .bashrc...${NC}\n"
sudo su -c "echo -e \"
export PS1=\\\"\[\033[38;5;1m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\] \w \[$(tput sgr0)\]\[\033[38;5;1m\]#\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\\\"
alias mc='mc -S dark'
\" >> /root/.bashrc"

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
