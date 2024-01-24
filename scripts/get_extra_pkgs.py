#!/bin/python3

# Manage download of extra deb packages.
# Add url of a valid deb package to 'targets' and it be installed during build.

import os
import requests


targets = [
  'http://ftp.dk.debian.org/debian/pool/main/i/icu/libicu63_63.1-6+deb10u3_amd64.deb'
]

# Get source directory for this script.
DIR = os.path.dirname(os.path.abspath(__file__))
extraPkgPath = os.path.abspath(DIR + '/../basics/config/packages.chroot/')

for url in targets:
  filename = url.split('/')[-1]
  result = requests.get(url, allow_redirects=True)
  if result == False:
    print('Unable to download: {}\n\tReason: {}'.format(filename, result.reason))
    exit(1)
  outputPath = extraPkgPath + '/' + filename
  open(outputPath, 'wb').write(result.content)
