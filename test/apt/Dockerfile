FROM debian:bookworm

RUN sed -i "s/Components: main/Components: main contrib non-free non-free-firmware/" /etc/apt/sources.list.d/debian.sources
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get upgrade -y
Run apt-get -y install gnupg ca-certificates wget curl nano

ENTRYPOINT ["/docker-run.sh"]