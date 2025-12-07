#!/bin/bash
set -e

# Generate self-signed cert if missing
if [ ! -f /etc/nginx/certs/nginx.crt ] || [ ! -f /etc/nginx/certs/nginx.key ]; then
    mkdir -p /etc/nginx/certs
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/certs/nginx.key \
        -out /etc/nginx/certs/nginx.crt \
        -subj "/C=MA/ST=Benguerir/L=Benguerir/O=42/OU=Inception/CN=mamir.42.fr"
fi

# Start nginx
nginx -g "daemon off;"
