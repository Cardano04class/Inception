#!/bin/bash
set -e

# Ensure runtime directories exist for PHP-FPM
mkdir -p /run/php /var/www/html
chown -R www-data:www-data /run/php /var/www/html

# Install curl if not present (for WordPress download)
if ! command -v curl >/dev/null 2>&1; then
    apt-get update && apt-get install -y curl && apt-get clean && rm -rf /var/lib/apt/lists/*
fi

# Wait for the database to be ready
echo "Waiting for database at $DB_HOST..."
until mysqladmin ping -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" --silent; do
    sleep 1
done
echo "Database ready!"

# Initialize WordPress files if wp-config.php does not exist
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Initializing WordPress files..."
    curl -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz
    tar -xzf /tmp/wordpress.tar.gz -C /var/www/html --strip-components=1
    rm /tmp/wordpress.tar.gz

    # Set correct ownership
    chown -R www-data:www-data /var/www/html

    # Generate wp-config.php from environment variables
    cat > /var/www/html/wp-config.php <<EOF
<?php
define('DB_NAME', '${WP_DB_NAME}');
define('DB_USER', '${WP_DB_USER}');
define('DB_PASSWORD', '${WP_DB_PASSWORD}');
define('DB_HOST', '${WP_DB_HOST}');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');
define('AUTH_KEY',         '$(openssl rand -base64 32)');
define('SECURE_AUTH_KEY',  '$(openssl rand -base64 32)');
define('LOGGED_IN_KEY',    '$(openssl rand -base64 32)');
define('NONCE_KEY',        '$(openssl rand -base64 32)');
define('AUTH_SALT',        '$(openssl rand -base64 32)');
define('SECURE_AUTH_SALT', '$(openssl rand -base64 32)');
define('LOGGED_IN_SALT',   '$(openssl rand -base64 32)');
define('NONCE_SALT',       '$(openssl rand -base64 32)');
\$table_prefix = 'wp_';
define('WP_DEBUG', false);
if ( !defined('ABSPATH') ) define('ABSPATH', __DIR__ . '/');
require_once ABSPATH . 'wp-settings.php';
EOF

    chown www-data:www-data /var/www/html/wp-config.php
fi

# Start PHP-FPM in the foreground
exec php-fpm7.4 -F
