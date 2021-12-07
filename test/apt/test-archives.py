import os
import docker

def runDocker(listFile, keyFile):
  client = docker.from_env()
  volumes = {
    listFile: {
      'bind': '/etc/apt/sources.list.d/test.list',
      'mode': 'ro'
    },
    keyFile: {
      'bind': '/etc/apt/sources.list.d/test.key',
      'mode': 'ro'
    },
    os.path.abspath('docker-run.sh'): {
      'bind': '/docker-run.sh',
      'mode': 'ro'
    }
  }
  try:
    container = client.containers.run('darkmagus/apt-test', command='./docker-run.sh', volumes=volumes, detach=True)
    container.wait()
    #print('kkk')
    print(container.logs())
  except docker.errors.ContainerError as e:
    print('Error': e)
    raise e
  else:
    return None


def buildImage():
  client = docker.from_env()
  with open('Dockerfile', 'rb') as df:
    client.images.build(fileobj=df, tag='darkmagus/apt-test')

buildImage()

archivesPath = os.path.abspath('../../basics/config/archives/')
for file in os.listdir(archivesPath):
  if file.endswith('list'):
    listFile = os.path.join(archivesPath, file)
    tmp = file.removesuffix('.list') + '.key'
    keyFile = os.path.join(archivesPath, tmp)
    #print('key:', keyFile)
    #print('file:', file)
    assert os.path.exists(keyFile)
    assert (runDocker(listFile, keyFile) == None)
    break
