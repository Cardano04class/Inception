#!/bin/bash
set -e

if [ ! -f /etc/nginx/certs/nginx.crt ]; then
    echo "Generating SSL certificates..."
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout /etc/nginx/certs/nginx.key \
        -out /etc/nginx/certs/nginx.crt \
        -subj "/CN=$DOMAIN_NAME"
fi

nginx -g "daemon off;"
