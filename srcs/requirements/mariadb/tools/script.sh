#!/bin/sh
set -e

# Directories
mkdir -p /var/lib/mysql
mkdir -p /run/mysqld
chown -R mysql:mysql /var/lib/mysql /run/mysqld

# Initialize DB if empty
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB..."
    mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql

    # Start temporary server in background
    mysqld_safe --datadir=/var/lib/mysql &
    pid="$!"

    # Wait until server is ready
    until mysqladmin ping >/dev/null 2>&1; do
        sleep 1
    done

    # Create DB and users
    mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
    mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -e "CREATE USER IF NOT EXISTS 'wp_admin'@'%' IDENTIFIED BY 'secure_admin_password';"
    mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
    mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO 'wp_admin'@'%';"
    mysql -e "FLUSH PRIVILEGES;"

    # Stop temporary server
    mysqladmin shutdown
fi

# Start MariaDB as PID 1
exec mysqld
