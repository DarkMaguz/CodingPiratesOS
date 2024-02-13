# Base the image off of Debian bookworm.
FROM debian:bookworm

# Adding APT proxy configuration.
ADD ./proxy/etc/apt/apt.conf /etc/apt/apt.conf.d/00-cpos-proxy

# Getting the prerequisite packages.
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y live-build debian-cd ca-certificates

# Installing proxy self signed certificate.
# Since there may or may not be a proxy, we need to make sure 
# the build won't fail in either case.
# The ADD command will fail if there are no files in the certs directory.
# To get around this, there is a file named ".crt" in the certs directory.
RUN mkdir -p /tmp/proxy-certs
ADD ./proxy/etc/squid/certs/*.crt /tmp/proxy-certs/
RUN ls /tmp/proxy-certs/ | tr -d ' ' >> /etc/ca-certificates.conf
RUN if [ -n "$(ls /tmp/proxy-certs/)" ]; then mv /tmp/proxy-certs/* /usr/share/ca-certificates/; fi
RUN rm -rf /tmp/proxy-certs
RUN update-ca-certificates

# Make the base directory for our application.
RUN mkdir /usr/app

# Set our working directory.
WORKDIR /usr/app

CMD ["scripts/build.sh"]
