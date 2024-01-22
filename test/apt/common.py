import os
import docker


verbose = False
verbose = True
archivesPath = os.path.abspath('../../basics/config/archives/')
pkgListPath = os.path.abspath('../../basics/config/package-lists/')
extraPkgPath = os.path.abspath('../../basics/config/packages.chroot/')


def buildTestImage():
  client = docker.from_env()
  with open('Dockerfile', 'rb') as dockerFile:
    client.images.build(fileobj=dockerFile, tag='darkmagus/apt-test')
