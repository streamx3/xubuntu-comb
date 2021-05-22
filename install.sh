#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Colour



if [[ $EUID -eq 0 ]]; then
    echo "${RED}This script must NOT be run as root${NC}"
    exit 1
fi

sudo echo "" > /dev/null
printf "${GREEN}Cursors: Painting Black!${NC}\n"
sudo cp -rf /usr/share/icons/DMZ-Black/cursors/* /usr/share/icons/DMZ-White/cursors

printf "${GREEN}Updating repo list...${NC}\n"
sudo apt-get update

printf "${GREEN}Getting aptitude...${NC}\n"
sudo apt-get install -y aptitude

printf "${GREEN}Performing full upgrade...${NC}\n"
sudo aptitude full-upgrade -y

printf "${GREEN}Installing everyting...${NC}\n"
sudo aptitude install -y \
    acpi exfat-fuse exfat-utils filezilla gdebi gnome-disk-utility \
    gpicview mc meld openssh-server p7zip-full rar \
    unrar unzip vim vlc xfce4-goodies xfonts-terminus \
    xubuntu-restricted-addons \
    baobab cmake cu elinks gawk git gitg gitk gparted \
    htop iftop ipython3 \
    kdiff3 kismet krename krusader libncurses5-dev libssl-dev linssid \
    linux-headers minicom nmap nmon pv python3-pip python-is-python3 qt5-default \
    rpm rtorrent sqlite3 sqlitebrowser stacer synaptic tasksel texlive tilda tmux \
    wireshark xclip yakuake zeal

printf "${GREEN}Adding current user to dialout group...${NC}\n"
sudo adduser `whoami` dialout

printf "${GREEN}Removing crap...${NC}\n"
sudo aptitude purge -y gnome-mines gnome-sudoku simple-scan parole sgt-launcher sgt-puzzles

printf "${GREEN}Fixing hddtemp...${NC}\n"
sudo chmod u+s /usr/sbin/hddtemp

printf "${GREEN}Patching users .bashrc...${NC}\n"
echo -e "
export PS1=\"\[\033[38;5;2m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\] \w \[$(tput sgr0)\]\[\033[38;5;2m\]\\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\"
" >> ~/.bashrc

printf "${GREEN}Patching root's .bashrc...${NC}\n"
sudo su -c "echo -e \"
export PS1=\\\"\[\033[38;5;1m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\] \w \[$(tput sgr0)\]\[\033[38;5;1m\]#\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\\\"
\" >> /root/.bashrc"

printf "${GREEN}Executing discreete actions...${NC}\n"
python3 actions.py

printf "${GREEN}Cleaning cache...${NC}\n"
sudo aptitude autoclean
sudo aptitude clean

for a in `seq 10 -1 1`
do
    printf "${RED}Rebooting in $a ...${NC}\n"
    sleep 1
done

sudo reboot
