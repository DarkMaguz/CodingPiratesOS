FROM debian:bullseye

RUN sed -i "s/main/main contrib non-free/" /etc/apt/sources.list
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get -y install gnupg ca-certificates wget curl nano
