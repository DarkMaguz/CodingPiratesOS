#!/bin/python3

import os
import requests

# List VSIX extensions to download from the visualstudio marketplace.
targets = [
  {
    'url': 'https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-dotnettools/vsextensions/vscode-dotnet-runtime/2.0.1/vspackage',
    'name': 'ms-dotnettools.vscode-dotnet-runtime-2.0.1.vsix'
  },
  {
    'url': 'https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-dotnettools/vsextensions/csdevkit/1.3.8/vspackage?targetPlatform=linux-x64',
    'name': 'ms-dotnettools.csdevkit-1.3.8@linux-x64.vsix'
  },
  {
    'url': 'https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-dotnettools/vsextensions/csharp/2.16.24/vspackage?targetPlatform=linux-x64',
    'name':'ms-dotnettools.csharp-2.16.24@linux-x64.vsix'
  },
  {
    'url': 'https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-python/vsextensions/python/2023.25.10292213/vspackage',
    'name': 'ms-python.python-2023.25.10292213.vsix'
  }
]

# Get source directory for this script.
DIR = os.path.dirname(os.path.abspath(__file__))

# Get the path to the extensions folder.
extensionsFolder = os.path.abspath(DIR + '/../basics/config/includes.chroot/etc/skel/.cpos/vscode-extensions')

# Download the extensions.
for t in targets:
  fileName = t['name']
  url = t['url']
  targetExtensionPath = os.path.join(extensionsFolder, fileName)
  # Skip if the file already exists.
  if os.path.exists(targetExtensionPath):
    print('Skipping: {} - already exists'.format(fileName))
    continue
  # Download the file.
  result = requests.get(url, allow_redirects=True)
  # Check if the download was successful, if not print the reason and exit.
  if result == False:
    print('Unable to download: {}\n\tReason: {}'.format(fileName, result.reason))
    exit(1)
  # Write the file.
  open(targetExtensionPath, 'wb').write(result.content)
