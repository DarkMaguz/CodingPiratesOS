import os
import docker
import multiprocessing as mp

verbose = True
archivesPath = os.path.abspath('../../basics/config/archives/')

def buildTestImage():
  client = docker.from_env()
  with open('Dockerfile', 'rb') as df:
    client.images.build(fileobj=df, tag='darkmagus/apt-test')


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
    logs = container.logs().decode()
    if 'Err:' in logs:
      return logs
  except docker.errors.ContainerError as e:
    return str(e)
  else:
    return None


def runTest(repoName, listFile, keyFile, queue):
  assert os.path.exists(keyFile)
  queue.put([repoName, runDocker(listFile, keyFile)])


def joinProcesses(processes):
  for p in processes:
    p.join()


def printFailure(repo):
  if not verbose: return
  lines = str(repo[1]).split('\n')
  print('%s failed:\n\t%s' % (repo[0], '\n\t'.join(lines)))


def hasFailedRepo(queue):
  aRepoHasFailed = False
  while not queue.empty():
    result = queue.get()
    if result[1] != None:
      printFailure(result)
      aRepoHasFailed = True
  return aRepoHasFailed


if __name__ == '__main__':
  buildTestImage()
  processes = []
  queue = mp.Queue()
  for file in os.listdir(archivesPath):
    if file.endswith('list'):
      repoName = file.removesuffix('.list')
      listFile = os.path.join(archivesPath, file)
      keyFile = os.path.join(archivesPath, repoName + '.key')
      p = mp.Process(target=runTest, args=(repoName, listFile, keyFile, queue))
      p.start()
      processes.append(p)
  joinProcesses(processes)
  assert not hasFailedRepo(queue)
