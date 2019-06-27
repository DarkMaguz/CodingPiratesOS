#!/usr/bin/python3

from __future__ import absolute_import
from __future__ import print_function
from __future__ import unicode_literals

import pexpect
import time

print('Starting test...')
testStatus=0

child = pexpect.spawnu('vncdo sleep 1 keydown enter sleep 0.1 keyup enter')

time.sleep(5)

if child.isalive():
    child.close()

exit(testStatus)
