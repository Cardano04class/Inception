#!/bin/bash
set -e

export DB_PASSWORD=$(cat ${DB_PASSWORD_FILE})
export DB_ROOT_PASSWORD=$(cat ${DB_ROOT_PASSWORD_FILE})

service mariadb start

until mysqladmin ping --silent; do
    sleep 1
done

if ! mysql -u root -p"$DB_ROOT_PASSWORD" -e "USE $DB_NAME;" >/dev/null 2>&1; then
    echo "Initializing database..."
    mysql -u root -p"$DB_ROOT_PASSWORD" -e "CREATE DATABASE $DB_NAME;"
    mysql -u root -p"$DB_ROOT_PASSWORD" -e "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"
    mysql -u root -p"$DB_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"
    mysql -u root -p"$DB_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"
else
    echo "Database already initialized."
fi

service mariadb stop
exec mysqld_safe
