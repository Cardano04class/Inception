#!/bin/bash
set -e

# Create run directory for PHP-FPM
mkdir -p /run/php
chown -R www-data:www-data /run/php

# Make PHP-FPM listen on TCP port 9000
sed -i "s|^listen = .*|listen = 0.0.0.0:9000|" /etc/php/7.4/fpm/pool.d/www.conf

# Initialize WordPress config if missing
if [ ! -f /var/www/html/wp-config.php ]; then
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    sed -i "s/database_name_here/${DB_NAME}/" /var/www/html/wp-config.php
    sed -i "s/username_here/${DB_USER}/" /var/www/html/wp-config.php
    sed -i "s/password_here/${DB_PASSWORD}/" /var/www/html/wp-config.php
    sed -i "s/localhost/mariadb/" /var/www/html/wp-config.php
fi

# Start PHP-FPM in foreground
php-fpm7.4 --nodaemonize
