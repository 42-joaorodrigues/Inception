#!/bin/bash

echo "Starting phpMyAdmin..."

# Ensure proper permissions
chown -R www-data:www-data /var/www/html/phpmyadmin
chmod -R 755 /var/www/html/phpmyadmin
chmod 777 /var/www/html/phpmyadmin/tmp

# Start Apache in foreground
exec apache2ctl -D FOREGROUND