FROM debian:bullseye

# Install PHP, php-fpm, necessary extensions, wget, tar, and mariadb-client
RUN apt-get update && apt-get install -y \
    php7.4 php7.4-fpm php7.4-mysql php7.4-cli php7.4-curl php7.4-xml php7.4-mbstring \
    wget curl tar unzip less ca-certificates gnupg \
    mariadb-client \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Make sure PHP-FPM can run and listen on all interfaces
RUN mkdir -p /run/php \
    && chown -R www-data:www-data /run/php \
    && sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf

# Create web root
RUN mkdir -p /var/www/html \
    && chown -R www-data:www-data /var/www/html

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Install WP-CLI
RUN wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp \
    && chmod +x /usr/local/bin/wp

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm7.4", "-F"]
