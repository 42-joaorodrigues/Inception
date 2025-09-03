#!/bin/bash

# Create PHP-FPM run directory
mkdir -p /run/php

# Wait for MariaDB to be ready
while ! nc -z mariadb 3306; do
    sleep 1
done

# Change to WordPress directory
cd /var/www/html

# Download WordPress if not already present
if [ ! -f wp-config.php ]; then
    # Download WordPress
    wp core download --allow-root

    # Create wp-config.php
    wp config create \
        --dbname="$SQL_DB_NAME" \
        --dbuser="$SQL_USER" \
        --dbpass="$SQL_PASSWORD" \
        --dbhost="$SQL_HOST" \
        --allow-root

    # Install WordPress
    wp core install \
        --url="https://$DOMAIN_NAME" \
        --title="Inception WordPress" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root

    # Create additional user
    wp user create \
        "$WP_USER" \
        "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --allow-root
fi

# Set correct permissions
chown -R www-data:www-data /var/www/html

# Start PHP-FPM
exec php-fpm7.4 -F
