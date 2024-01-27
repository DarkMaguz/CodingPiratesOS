#!/bin/python3

import os

import docker
import multiprocessing as mp

import common


def runDocker(archive: str):
  client = docker.from_env()
  volumes = common.buildVolumes('docker-run-archives.sh', [archive])
  logs = ""
  exitCode = 0
  try:
    container = client.containers.run(
      'darkmagus/apt-test',
      volumes=volumes,
      detach=True
      )
    exitCode = container.wait()["StatusCode"]
    logs = container.logs().decode()
    container.remove()
  except docker.errors.ContainerError as e:
    return [True, str(e)]
  else:
    hasError = 'Err:' in logs or exitCode != 0
    return [hasError, logs]


def runTest(archive: str, queue: mp.Queue):
  assert os.path.exists(os.path.join(common.archivesPath, archive + '.key'))
  assert os.path.exists(os.path.join(common.archivesPath, archive + '.list'))
  queue.put([archive, runDocker(archive)])


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
      archive = file.removesuffix('.list')
      p = mp.Process(target=runTest, args=(archive, queue))
      p.start()
      processes.append(p)
  joinProcesses(processes)
  assert not hasFailedRepo(queue)
