#!/bin/sh -e

docker rm -f scratch3 || :

<<<<<<< HEAD
docker pull darkmagus/scratch3
docker run -p 8601:80 -d --name scratch3 darkmagus/scratch3
=======
#docker pull darkmagus/scratch3
#docker run -p 8601:80 -d --name scratch3 darkmagus/scratch3
>>>>>>> 19a0bf4d7ad7670e0c6705cc2eccae5461bcfb03

wget http://localhost:8601/ -t 10 --waitretry 1 -o /dev/null
google-chrome --new-window --app http://localhost:8601/
