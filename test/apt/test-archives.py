#!/bin/python3

import os
import docker
import multiprocessing as mp

import common

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
  logs = ""
  exitCode = 0
  try:
    container = client.containers.run('darkmagus/apt-test', command='./docker-run.sh', volumes=volumes, detach=True)
    exitCode = container.wait()["StatusCode"]
    logs = container.logs().decode()
  except docker.errors.ContainerError as e:
    return [True, str(e)]
  else:
    hasError = 'Err:' in logs or exitCode != 0
    return [hasError, logs]


def runTest(repoName, listFile, keyFile, queue):
  assert os.path.exists(keyFile)
  queue.put([repoName, runDocker(listFile, keyFile)])


def joinProcesses(processes):
  for p in processes:
    p.join()


def printResult(result):
  if not result[1][0]:
    if not common.verbose:
      return
  lines = str(result[1][1]).split('\n')
  status = 'failed' if result[1][0] else 'passed'
  print('%s %s:\n\t%s' % (result[0], status, '\n\t'.join(lines)))


def hasFailedRepo(queue):
  aRepoHasFailed = False
  while not queue.empty():
    result = queue.get()
    if result[1][0]:
      aRepoHasFailed = True
    printResult(result)
  return aRepoHasFailed


if __name__ == '__main__':
  common.buildTestImage()
  processes = []
  queue = mp.Queue()
  for file in os.listdir(common.archivesPath):
    if file.endswith('list'):
      repoName = file.removesuffix('.list')
      listFile = os.path.join(common.archivesPath, file)
      keyFile = os.path.join(common.archivesPath, repoName + '.key')
      p = mp.Process(target=runTest, args=(repoName, listFile, keyFile, queue))
      p.start()
      processes.append(p)
  joinProcesses(processes)
  assert not hasFailedRepo(queue)
