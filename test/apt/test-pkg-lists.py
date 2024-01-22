#!/bin/python3

import os
import docker

import common


def buildPackageList():
  pkgList = ""
  for file in os.listdir(common.pkgListPath):
    if file.endswith('list.chroot'):
      with open(os.path.join(common.pkgListPath, file), 'rt') as pkgListFile:
        for line in pkgListFile:
          if line.startswith('!') or line.strip() == '':
            continue
          pkgList += line.strip() + ' '
  return pkgList[:-1]


def buildVolumes():
  volumes = {}
  KEYS = []
  for file in os.listdir(common.archivesPath):
    volumes[os.path.join(common.archivesPath, file)] = {
      'bind': os.path.join('/etc/apt/sources.list.d/', file),
      'mode': 'ro'
    }
    if file.endswith('.key'):
      KEYS.append(os.path.join('/etc/apt/sources.list.d/', file))
  volumes[os.path.abspath('docker-run-pkg-list.sh')] = {
    'bind': '/docker-run.sh',
    'mode': 'ro'
  }
  # Add bind path to extra deb packages
  volumes[common.extraPkgPath] = {
    'bind': '/extra/',
    'mode': 'ro'
  }
  return [volumes, KEYS]


def buildExtraPackagesList():
  extraPackages = ""
  for file in os.listdir(common.extraPkgPath):
    if file.endswith('.deb'):
      extraPackages += '/extra/' + file + ' '
  return extraPackages

if __name__ == '__main__':
  common.buildTestImage()
  vk = buildVolumes()
  volumes = vk[0]
  keys = vk[1]
  keyStr = ''
  for key in keys:
    keyStr += key + ','
  keyStr = keyStr[:-1]
  client = docker.from_env()
  logs = ''
  exitCode = 0
  try:
    container = client.containers.run('darkmagus/apt-test',
      command='./docker-run.sh',
      volumes=volumes,
      detach=True,
      environment={
        'KEYS': keyStr,
        'PKG_LIST': buildPackageList(),
        'EXTRA_PACKAGES': buildExtraPackagesList()
      })
    exitCode = container.wait()["StatusCode"]
    logs = container.logs().decode()
  except docker.errors.ContainerError as e:
    print("error:", str(e))
  else:
    if common.verbose:
      print("output:", logs)
