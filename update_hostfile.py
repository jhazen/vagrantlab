#!/usr/bin/env python3

import yaml
import os

s = open('servers.yaml')
d = yaml.load_all(s)

# Delete hosts.conf, if it exists
if os.path.exists('saltstack/salt/base/general/hosts.conf'):
    os.unlink('saltstack/salt/base/general/hosts.conf')

hostfile = "saltstack/salt/base/general/hosts.conf"

# Static routes
with open(hostfile, 'a') as f:
    f.write('127.0.0.1 localhost\n')
    f.write('192.168.200.11 mst1\n')

# Routes for all servers in servers.yaml
for boxes in d:
    for box in boxes:
        with open(hostfile, 'a') as f:
            f.write("{} {}\n".format(box['ip'], box['name']))

