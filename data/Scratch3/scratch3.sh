#!/bin/sh -e

if [ $(docker ps -a -f "name=/scratch3$" -q) ]; then
  docker rm -f scratch3
fi

docker pull darkmagus/scratch3
docker run -p 8601:8601 -d --name scratch3 darkmagus/scratch3

s3splash

#wget http://localhost:8601/ -t 10 --waitretry 1 -o /dev/null
google-chrome --new-window --app http://localhost:8601/
