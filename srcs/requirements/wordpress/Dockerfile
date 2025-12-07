FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-cli \
    curl \
    wget \
    mariadb-client \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create the WordPress directory
RUN mkdir -p /var/www/html

# Copy entrypoint
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
