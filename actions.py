#!/usr/bin/env python3

import sys
import signal
import subprocess
from typing import List

actions = {'ppa', 'cfg_mc', 'cfg_yakuake', 'cfg_ulauncher', 'cfg_xfconf', 'cfg_xfce4-terminal', 'dummy', 'font_source_code', 'font_monaco', 'snap', 'vim'}


def signal_handler(sig, frame):
    print('Detected Ctrl+C: ' + sys.argv[0] + ' interrupted.')
    sys.exit(0)


def exe(command:str):
    command = 'cd actions/' + command + ' && bash apply.sh &&  cd ../.. '
    process = subprocess.run(command, shell=True)


def perform_actions(given_actions:List[str]):
    for a in given_actions:
        if a in actions:
            if a == 'dummy':
                print('Skipping dummy action')
            else:
                exe(a)
        else:
            print(a + ': not found')


if __name__ == '__main__':
    signal.signal(signal.SIGINT, signal_handler)
    if len(sys.argv) > 1:
        if sys.argv[1] == 'list':
            print(' '.join(actions) )
        else:
            perform_actions(sys.argv[1:])
    else:
        perform_actions(actions)
