FROM darkmagus/codingpiratesos:latest

RUN dpkg --add-architecture i386
RUN sed -i "s/Components: main/Components: main contrib non-free non-free-firmware/" /etc/apt/sources.list.d/debian.sources
RUN apt-get update && apt-get upgrade -y

ENTRYPOINT ["/docker-run.sh"]
