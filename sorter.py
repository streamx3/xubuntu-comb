#!/usr/bin/env python
s1 = """
    vim mc rar unrar pv htop meld qtcreator git gitg tmux \
    mercurial tortoisehg vlc audacious gdebi synaptic ipython ipython3 minicom \
    ipython-qtconsole ipython3-qtconsole python-pip python3-pip gpicview \
    gparted gnome-do filezilla xfonts-terminus guake tilda openssh-server \
    xubuntu-restricted-extras google-chrome-stable wireshark iftop kdiff3 \
    krusader libssl-dev libncurses5-dev unzip gawk subversion youtube-dl \
    linux-headers arduino exfat-fuse exfat-utils cmake cmake-qt-gui qbs \
    qt5-default p7zip-full linssid kismet baobab chromium-browser elinks \
    zeal rtorrent midori gitk yakuake xclip nmon tasksel nmap acpi texlive \
    sqlite3 cu krename rpm"""


def sort(s):
    out = '    '
    s = s.replace('\\', '').replace('\n', '').split(' ')
    s = [n for n in s if n != '']
    s.sort()
    # print(s)
    for n in s:
        last = out.split('\n')[-1:][0]
        l = len(last)
        if (l + len(n) + 1) > 80:
            out += '\\\n    '
        out += n + ' '
    print(out)

sort(s1)
