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


def buildExtraPackagesList():
  extraPackages = ""
  for file in os.listdir(common.extraPkgPath):
    if file.endswith('.deb'):
      extraPackages += '/extra/' + file + ' '
  return extraPackages


def getArchives():
  archives = []
  for file in os.listdir(common.archivesPath):
    if file.endswith('.list'):
      archives.append(file.removesuffix('.list'))
  return archives


if __name__ == '__main__':
  common.buildTestImage()
  volumes = common.buildVolumes('docker-run-pkg-list.sh', getArchives())
  client = docker.from_env()
  logs = ''
  exitCode = 0
  try:
    container = client.containers.run('darkmagus/apt-test',
      command='./docker-run.sh',
      volumes=volumes,
      detach=True,
      environment={
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
