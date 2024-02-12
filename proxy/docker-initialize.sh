#!/bin/sh -e

# Disable proxy environment variables.
export http_proxy=""
export https_proxy=""
export HTTP_PROXY=""
export HTTPS_PROXY=""

# Install certificate
cp /etc/squid/certs/proxy-selfsigned.crt /usr/share/ca-certificates/proxy-selfsigned.crt
echo "proxy-selfsigned.crt" >> /etc/ca-certificates.conf

# Update certificates
update-ca-certificates

# Initialize log directory.
/usr/lib/squid/security_file_certgen -c -s /var/log/ssl_db -M 20MB
chown -R proxy:proxy /var/log/ssl_db
mkdir -p /var/log/squid
chown proxy:proxy /var/log/squid

# Initialize cache directory.
chown proxy:proxy /var/spool/squid
squid -z --foreground
