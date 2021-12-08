#!/bin/sh -e

docker rm -f scratch3 || :

docker pull darkmagus/scratch3
docker run -p 8601:80 -d --name scratch3 darkmagus/scratch3

wget http://localhost:8601/ -t 10 --waitretry 1 -o /dev/null
google-chrome --new-window --app http://localhost:8601/
