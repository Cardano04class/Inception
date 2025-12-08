FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx openssl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/certs /var/www/html

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf
COPY start_nginx.sh /start_nginx.sh
RUN chmod +x /start_nginx.sh

EXPOSE 443

ENTRYPOINT ["/start_nginx.sh"]
