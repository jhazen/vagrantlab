#!/usr/bin/env python

import yaml
import os

s = file('servers.yaml')
d = yaml.load_all(s)

if os.path.exists('saltstack/salt/base/general/hosts.conf'):
    os.unlink('saltstack/salt/base/general/hosts.conf')

hostfile = "saltstack/salt/base/general/hosts.conf"

for boxes in d:
    for box in boxes:
        with open(hostfile, 'a') as f:
            f.write("{} {}\n".format(box['ip'], box['name']))

with open(hostfile, 'a') as f:
    f.write('10.0.0.101 mst\n')
