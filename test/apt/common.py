import os
import docker


verbose = False
archivesPath = os.path.abspath('../../basics/config/archives/')
pkgListPath = os.path.abspath('../../basics/config/package-lists/')


def buildTestImage():
  client = docker.from_env()
  with open('Dockerfile', 'rb') as dockerFile:
    client.images.build(fileobj=dockerFile, tag='darkmagus/apt-test')
