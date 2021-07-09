#!/usr/bin/env python

# Only allow a particular HOSTNAME to access the given port...

# from https://unix.stackexchange.com/a/534117/66983
# and https://unix.stackexchange.com/a/91711/66983
# If the ufw table is empty you might need to execute the script twice (as inserting on top will not work properly)
# crontab -e and add '*/5 * * * * root /path/to/update_ufw.py > /dev/null 2>&1'
HOSTNAME="domain.com"
PORT="5001"

import os
import subprocess

if os.geteuid() != 0:
    print("This script must be run as root")
    exit(1)

def run(cmd):
    process = subprocess.Popen(['bash', '-c', cmd],
                     stdout=subprocess.PIPE)
    stdout, stderr = process.communicate()
    return stdout.decode('utf-8')

new_ip_output = run("getent ahosts \"{}\" | awk '{{ print $1 }}'".format(HOSTNAME))
new_ips=set(new_ip_output.split())
old_ip_output = run("/usr/sbin/ufw status | grep {} | head -n1 | tr -s ' ' | cut -f3 -d ' '".format(HOSTNAME))
old_ips=set(old_ip_output.split())


if old_ips == new_ips:
    print ("All IPs still OK.")
else:
    # add new IPs
    for new_ip in new_ips:
        if new_ip not in old_ips:
            out = run("/usr/sbin/ufw insert 1 allow from {} to any port {} comment {}".format(new_ip, PORT, HOSTNAME))
            print(out)
    
    # remove old IPs
    for old_ip in old_ips:
         if old_ip not in new_ips:
            out = run("/usr/sbin/ufw delete allow from {} to any port {}".format(old_ip, PORT))
            print(out)
    
    # add deny rule
    out = run("/usr/sbin/ufw deny {}".format(PORT))
    print(out)