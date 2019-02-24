# Base the image off of Debian buster.
FROM debian:buster

# Getting the prerequisite packages.
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y live-build

# Make the base directory for our application.
RUN mkdir /usr/app

# Set our working directory.
WORKDIR /usr/app

# Install configuration-, data- and script files.
#COPY basics /usr/app/basics
#COPY data /usr/app/data
#COPY scripts /usr/app/scripts

CMD ["scripts/build.sh"]
