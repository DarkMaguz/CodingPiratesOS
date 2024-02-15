FROM debian:trixie

ENV http_proxy=""
ENV https_proxy=""
ENV HTTP_PROXY=""
ENV HTTPS_PROXY=""

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y openssl squid-openssl squidclient sudo

EXPOSE 3128

ENTRYPOINT ["/usr/sbin/squid", "-NYCd1"]
#ENTRYPOINT ["/usr/sbin/squid", "--foreground", "-d2"]
