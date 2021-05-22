#!/usr/bin/env python

import os
import sys
import signal
import subprocess
from typing import List, Dict, Any
from datetime import datetime
import sqlite3
import json

ACTIONS_DEBUG = False

SUPPORTED_UBUNTU_RELEASES_MAJOR_NUM = [16, 18, 20, 21, 22, 23, 24]

key_executable = 'exe'
key_release = 'DISTRIB_RELEASE'
key_release_num = 'DISTRIB_RELEASE_NUM'
key_min_version = 'min_version'
key_max_version = 'max_version'
key_dependencies = 'dependencies'
key_name = 'name'
key_date = 'date'
file_info = 'info.json'
file_apply = 'apply.sh'
file_database = 'actions/actions.db'
dir_actions = 'actions/'
db_processed_table = '''processed'''
date_format = '%m/%d/%y %H:%M:%S'


def ubuntu_release_number_to_int(rel_num: str) -> int:
    now = datetime.now()
    year = now.year - 2000
    splitter = '.'
    if splitter in rel_num:
        subs = rel_num.split(splitter)
        a = int(subs[0])
        b = int(subs[1])
        if b in [4, 10]:
            return a * 100 + b
    return None


def get_lsb_release() -> Dict[str, str]:
    file_lsb = '/etc/lsb-release'
    lsb_dict = None
    if os.path.isfile(file_lsb):
        with open(file_lsb) as f:
            lines = f.readlines()
            if len(lines) > 1:
                lsb_dict = {}
                for line in lines:
                    l = line.replace('\n', '').split('=')
                    if len(l) == 2:
                        lsb_dict[l[0]] = l[1]
    distr_desc = 'DISTRIB_DESCRIPTION'
    if distr_desc in lsb_dict:
        lsb_dict[distr_desc] = lsb_dict[distr_desc].replace('"', '')
    lsb_dict[key_release_num] = ubuntu_release_number_to_int(lsb_dict[key_release])
    return lsb_dict


def signal_handler(sig, frame):
    print('Detected Ctrl+C: ' + sys.argv[0] + ' interrupted.')
    sys.exit(0)


def exe(command: str):
    command = 'cd ' + dir_actions + command + ' && bash ' + file_apply + ' &&  cd ../.. '
    process = subprocess.run(command, shell=True)


def check_executed(action_name: str) -> Dict[str, Any]:
    rv = {}
    conn = sqlite3.connect(file_database)
    cur = conn.cursor()
    q = '''SELECT * FROM ''' + db_processed_table + ''' WHERE name = "''' + action_name + '''";'''
    cur.execute(q)
    resp = cur.fetchall()
    if len(resp) > 0 and len(resp[0]):
        if ACTIONS_DEBUG:
            print(resp[0][1] + ' is already executed this time, on ' + resp[0][2])
        rv = {'id': resp[0][0], key_name: resp[0][1], key_date: resp[0][2]}
    conn.close()
    return rv


def process_single_action(action: Dict[str, str], all_actions: Dict[str, str]):
    exe_info = check_executed(action[key_name])

    if exe_info is not None and len(exe_info) > 0:
        # print(action[key_name] + ' is already executed this time, on ' + exe_info[key_date])
        if 'force' in action and action['force']:
            print('Removing previous exectuion timestamp:')
            conn = sqlite3.connect(file_database)
            cur = conn.cursor()
            q = 'DELETE FROM ' + db_processed_table + ' WHERE ' + key_name + ' = "' + action[key_name] + '";'
            print(q)
            cur.execute(q)
            conn.commit()
            conn.close()
        else:
            return

    if key_dependencies in action:
        for dep in action[key_dependencies]:
            if dep != '':
                dep_exe_info = check_executed(dep)
                if dep_exe_info == {}:
                    if ACTIONS_DEBUG:
                        print('Executing dependency of ' + action[key_name] + ' : ' + dep )
                    process_single_action(all_actions[dep], all_actions)
    if ACTIONS_DEBUG:
        print('Executing ' + action[key_executable])
    q = '''INSERT INTO ''' + db_processed_table + '''(''' + key_name + ''',''' + key_date + ''') values ("''' + \
        action[key_name] + '''","''' + datetime.now().strftime(date_format) + '''");'''
    if ACTIONS_DEBUG:
        print(q)
    exe(action[key_name])
    conn = sqlite3.connect(file_database)
    cur = conn.cursor()
    cur.execute(q)
    conn.commit()
    conn.close()
    if ACTIONS_DEBUG:
        print('Finished exec ' + action[key_name])


def process_actions(given_actions: List[str], force: bool):
    db_loaded = load_db()
    lsb_release = get_lsb_release()
    actions = load_actions()
    if len(given_actions) == 0:
        given_actions = actions
    if force:
        if len(given_actions) != 1:
            print('ERROR: CANNOT FORCE MORE THAN 1 ACTION!. Leaving...')
            sys.exit(-1)
        print('FORCING EXECUTION OF ACTION [' + given_actions[0] + ']')
        actions[given_actions[0]]['force'] = True
        process_single_action(actions[given_actions[0]], actions)
        return
    for a in given_actions:
        if a in actions and a not in db_loaded:
            if a == 'dummy':
                print('Skipping dummy action')
                continue
            if key_min_version in actions[a]:
                a_min = ubuntu_release_number_to_int(actions[a][key_min_version])
                if a_min > lsb_release[key_release_num]:
                    print('Skipping ' + a + '[' + key_min_version + ']:' + actions[a][key_min_version] + ', SYS:' +
                          lsb_release[key_release] + '\t\t TOO NEW!')
                    continue
                a_max = ubuntu_release_number_to_int(actions[a][key_max_version])
                if a_max < lsb_release[key_release_num]:
                    print('Skipping ' + a + '[' + key_max_version + ']:' + actions[a][key_max_version] + ', SYS:' +
                          lsb_release[key_release] + '\t\t TOO OLD!')
                    continue
            process_single_action(actions[a], actions)
        elif a in db_loaded:
            print(a + ': has being executed earlier.')
        else:
            print(a + ': not found')


def load_db() -> Dict[str, Dict[str, Any]]:
    # processed_table structure:
    # id INTEGER PRIMARY KEY AUTOINCREMENT
    # name TEXT
    # date TEXT
    create_q = '''CREATE TABLE IF NOT EXISTS ''' + db_processed_table + \
               ''' (id INTEGER PRIMARY KEY AUTOINCREMENT, ''' + key_name + ''' TEXT, ''' + key_date + ''' TEXT);'''
    conn = sqlite3.connect(file_database)
    cur = conn.cursor()
    cur.execute(create_q)
    conn.commit()
    cur.execute('''SELECT * FROM  ''' + db_processed_table )
    data = cur.fetchall()
    new_data = {}
    if len(data) > 0:
        for row in data:
            if len(row) != 3:
                print("Invalid row, skipping...")
            else:
                _id = row[0]
                name = row[1]
                date = row[2]
                try:
                    date = datetime.strptime(date, date_format)
                except ValueError:
                    print('Invalid "date" column in processed table with id = ' + str(_id) + ', Using None.')
                    date = None
                new_data[name] = {'id': _id, key_date: date}
    conn.close()
    return new_data


def load_actions() -> Dict[str, Dict[str, Any]]:
    _actions = {}
    if not os.path.isdir(dir_actions):
        print('Dir "' + dir_actions + '" is missing. Leaving...')
        sys.exit(-1)
    dirs = os.listdir(dir_actions)
    if len(dirs) < 1:
        print('Dir "' + dir_actions + '" is empty. Leaving...')
        sys.exit(-1)
    for d in dirs:
        dir_joined = os.path.join(dir_actions, d)
        if not os.path.isdir(dir_joined):
            continue
        file_nfo_joined = os.path.join(dir_joined, file_info)
        file_apply_joined = os.path.join(dir_joined, file_apply)
        if os.path.exists(file_nfo_joined) and os.path.isfile(file_nfo_joined):
            if ACTIONS_DEBUG:
                print(file_nfo_joined)
            with open(file_nfo_joined, 'r') as f:
                nfo = json.load(f)
                nfo[key_name] = d
                if os.path.isfile(file_apply_joined):
                    nfo[key_executable] = file_apply_joined
                _actions[d] = nfo
        elif os.path.exists(file_apply_joined) and os.path.isfile(file_apply_joined):
            nfo = {key_name: d, key_executable: file_apply_joined}
            _actions[d] = nfo
    return _actions


if __name__ == '__main__':
    signal.signal(signal.SIGINT, signal_handler)
    if len(sys.argv) > 1:
        if sys.argv[1] == 'list':
            actions = load_actions()
            print(' '.join(actions))
        elif len(sys.argv) == 3 and sys.argv[2] == '-f':
            ACTIONS_DEBUG = True
            print('ENFORCING DEBUG MESSAGES...')
            process_actions([sys.argv[1]], True)
        else:
            process_actions(sys.argv[1:], False)
    else:
        process_actions([], False)
