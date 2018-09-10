#!/usr/bin/env python

import os
import re
import sys
from beebotte import *

if '_SPEEBEE_API' in os.environ:
    _hostname = os.environ['_SPEEBEE_API']
else:
    _hostname = 'api.beebotte.com'

if '_SPEEBEE_TOKEN' in os.environ:
    _token = os.environ['_SPEEBEE_TOKEN']
else:
    print "No token specified. We cannot post to Beebotte without it. Please "\
          "set the _SPEEBEE_TOKEN environment variable."
    sys.exit()

if '_SPEEBEE_CHANNEL' in os.environ:
    _channel = os.environ['_SPEEBEE_CHANNEL']
else:
    _channel = 'speebee'

bbt = BBT(token=_token, hostname=_hostname)


def returnValue(speed):
    s = speed.split(" ")
    # if there are no spaces, we have an IP address and return it
    if len(s) == 1:
        return s[0]
    # if not, we have some units, and convert to number
    s[0] = float(s[0])
    if "Mbytes/s" in s[1]:
        s[0] *= 8
    return s[0]

SpeedTest = sys.argv[1]

file = open(SpeedTest, "r")

for LINE in file.readlines():
    if "IP" in LINE:
        ip = returnValue(re.match(r'IP: (.*)', LINE).group(1))
    elif "Ping" in LINE:
        ping = returnValue(re.match(r'Ping: (.*)', LINE).group(1))
    elif "Download" in LINE:
        download = returnValue(re.match(r'Download: (.*)', LINE).group(1))
    elif "Upload" in LINE:
        upload = returnValue(re.match(r'Upload: (.*)', LINE).group(1))

bbt.writeBulk(_channel, [
    {"resource": "public_ip", "data": ip},
    {"resource": "ping", "data": ping},
    {"resource": "download", "data": download},
    {"resource": "upload", "data": upload},
])
