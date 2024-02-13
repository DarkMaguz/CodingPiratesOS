import os
import docker


verbose = True
archivesPath = os.path.abspath('../../basics/config/archives/')
pkgListPath = os.path.abspath('../../basics/config/package-lists/')
extraPkgPath = os.path.abspath('../../basics/config/packages.chroot/')


def buildTestImage():
  print('Building darkmagus/apt-test image...')
  client = docker.from_env()
  # Build the image
  with open('Dockerfile', 'rb') as dockerFile:
    img, build_logs = client.images.build(
      fileobj=dockerFile,
      tag='darkmagus/apt-test',
      network_mode='cpos'
    )
    # Print build logs
    if verbose:
      for chunk in build_logs:
        if 'stream' in chunk:
          for line in chunk['stream'].splitlines():
            print(line)
  print('Done.')


def buildVolumes(dockerRunScript: str, archives: []):
  volumes = {}
  for archive in archives:
    archiveKey = archive + '.key'
    archiveList = archive + '.list'
    volumes[os.path.join(archivesPath, archiveKey)] = {
      'bind': os.path.join('/etc/apt/trusted.gpg.d/', archiveKey + '.gpg'),
      'mode': 'ro'
    }
    volumes[os.path.join(archivesPath, archiveList)] = {
      'bind': os.path.join('/etc/apt/sources.list.d/', archiveList),
      'mode': 'ro'
    }
  # Add bind path to docker-run-*.sh test script.
  volumes[os.path.abspath(dockerRunScript)] = {
    'bind': '/docker-run.sh',
    'mode': 'ro'
  }
  # Add bind path to extra deb packages.
  volumes[extraPkgPath] = {
    'bind': '/extra/',
    'mode': 'ro'
  }
  return volumes
