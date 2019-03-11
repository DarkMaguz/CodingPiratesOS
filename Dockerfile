# Base the image off of Debian buster.
FROM debian:buster

# Getting the prerequisite packages.
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y live-build debian-cd

# Make the base directory for our application.
RUN mkdir /usr/app

# Set our working directory.
WORKDIR /usr/app

CMD ["scripts/build.sh"]
