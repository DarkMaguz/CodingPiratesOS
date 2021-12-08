# Base the image off of Debian buster.
FROM debian:buster-slim

# Getting the prerequisite packages.
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y qemu qemu-kvm --no-install-recommends

# Make the base directory for our application.
RUN mkdir /usr/app

# Set our working directory.
WORKDIR /usr/app

COPY docker-run.sh .

EXPOSE 5900

CMD ["./docker-run.sh"]
