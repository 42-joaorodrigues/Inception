#!/bin/bash

echo "Starting Adminer with Apache..."

# Ensure proper permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Start Apache in the foreground
echo "Starting Adminer..."
echo "Adminer will be available for database management"
echo "Connect to MariaDB using:"
echo "  Server: mariadb"
echo "  Username: [your database username]"
echo "  Password: [your database password]"
echo "  Database: [your database name]"

exec apache2ctl -D FOREGROUND
