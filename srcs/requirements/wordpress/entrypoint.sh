#!/bin/bash
set -e

mkdir -p /run/php
chown -R www-data:www-data /run/php

echo "Waiting for database at $WP_DB_HOST..."
until mysqladmin ping -h "$WP_DB_HOST" -u "$WP_DB_USER" -p"$WP_DB_PASSWORD" --silent; do
    sleep 1
done
echo "Database ready!"

# Download WordPress if not present
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Downloading WordPress..."
    wget -q https://wordpress.org/latest.tar.gz -O /tmp/wp.tar.gz
    tar -xzf /tmp/wp.tar.gz -C /var/www/html --strip-components=1
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    sed -i "s/database_name_here/$WP_DB_NAME/" /var/www/html/wp-config.php
    sed -i "s/username_here/$WP_DB_USER/" /var/www/html/wp-config.php
    sed -i "s/password_here/$WP_DB_PASSWORD/" /var/www/html/wp-config.php
    sed -i "s/localhost/$WP_DB_HOST/" /var/www/html/wp-config.php

    chown -R www-data:www-data /var/www/html
fi

# Install WordPress using WP-CLI if not already installed
if command -v wp >/dev/null 2>&1; then
    echo "DEBUG: Environment variables at entrypoint:"
    echo "  WP_ADMIN_USER from env: '$WP_ADMIN_USER'"
    echo "  WP_ADMIN_PASSWORD from env: '$WP_ADMIN_PASSWORD'"
    echo "  WP_ADMIN_EMAIL from env: '$WP_ADMIN_EMAIL'"
    echo "  DOMAIN_NAME from env: '$DOMAIN_NAME'"
    
    WP_ADMIN_USER=${WP_ADMIN_USER:-mamir}
    WP_ADMIN_PASSWORD=${WP_ADMIN_PASSWORD:-wordpress}
    WP_ADMIN_EMAIL=${WP_ADMIN_EMAIL:-admin@${DOMAIN_NAME:-example.test}}
    WP_SITE_TITLE=${WP_SITE_TITLE:-"My Website"}

    echo "DEBUG: After defaults:"
    echo "  WP_ADMIN_USER: '$WP_ADMIN_USER'"
    echo "  WP_ADMIN_PASSWORD: '***'"
    echo "  WP_ADMIN_EMAIL: '$WP_ADMIN_EMAIL'"

    echo "========================================"
    echo "WP-CLI Configuration:"
    echo "  WP-CLI: $(which wp)"
    echo "  Path: /var/www/html"
    echo "  Admin user: $WP_ADMIN_USER"
    echo "  Admin email: $WP_ADMIN_EMAIL"
    echo "  Site URL: ${DOMAIN_NAME:-localhost}"
    echo "  Site title: $WP_SITE_TITLE"
    echo "========================================"

    # Wait for database to be fully ready
    sleep 2

    # Check if WordPress is already installed (checks database, not just files)
    echo "Checking if WordPress is already installed..."
    if wp core is-installed --path=/var/www/html --allow-root 2>&1; then
        echo "✓ WordPress is already installed"
    else
        echo "✗ WordPress not installed. Running wp core install..."
        if wp core install \
            --url="${DOMAIN_NAME:-localhost}" \
            --title="${WP_SITE_TITLE}" \
            --admin_user="${WP_ADMIN_USER}" \
            --admin_password="${WP_ADMIN_PASSWORD}" \
            --admin_email="${WP_ADMIN_EMAIL}" \
            --path=/var/www/html \
            --skip-email \
            --allow-root; then
            echo "✓ WordPress installation completed successfully"
            echo "  Login at: https://${DOMAIN_NAME:-localhost}/wp-login.php"
            echo "  Username: $WP_ADMIN_USER"
        else
            EXIT_CODE=$?
            echo "✗ WordPress installation FAILED with exit code: $EXIT_CODE"
            exit $EXIT_CODE
        fi
    fi
else
    echo "⚠ wp-cli not found at /usr/local/bin/wp"
fi

exec "$@"
