#!/bin/bash
set -e

# This script creates the database and user using environment variables
# It is safe to run repeatedly because it uses IF NOT EXISTS
# Use socket connection (no password needed for root at startup)

echo "Creating database and user..."
echo "Database name: $MYSQL_DATABASE"
echo "User name: $MYSQL_USER"

# Use double quotes in heredoc so variables are interpolated
mysql -u root --socket=/run/mysqld/mysqld.sock <<-EOF
CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
EOF

echo "Database and user creation completed"

# Verify the user was created and can connect
echo "Verifying user can connect..."
mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -h localhost "$MYSQL_DATABASE" -e "SELECT 1;" 2>&1 && echo "✓ User verification successful" || echo "✗ User verification failed"
