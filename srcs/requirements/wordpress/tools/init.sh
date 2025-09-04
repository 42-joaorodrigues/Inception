#!/bin/bash

# Create PHP-FPM run directory
mkdir -p /run/php

# Wait for MariaDB to be ready
while ! nc -z mariadb 3306; do
    sleep 1
done

# Wait for Redis to be ready
while ! nc -z redis 6379; do
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

    # Add Redis configuration to wp-config.php
    wp config set WP_REDIS_HOST "$WORDPRESS_REDIS_HOST" --allow-root
    wp config set WP_REDIS_PORT "$WORDPRESS_REDIS_PORT" --allow-root
    wp config set WP_REDIS_TIMEOUT 1 --allow-root
    wp config set WP_REDIS_READ_TIMEOUT 1 --allow-root
    wp config set WP_REDIS_DATABASE 0 --allow-root
    
    # Enable Redis object cache
    wp config set WP_CACHE true --raw --allow-root

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

    # Install and activate Redis Object Cache plugin
    wp plugin install redis-cache --activate --allow-root
    
    # Enable Redis object cache
    wp redis enable --allow-root
    
    # Test Redis connection
    echo "Testing Redis connection..."
    php /usr/local/bin/test-redis.php
fi

# Set correct permissions
chown -R www-data:www-data /var/www/html

# Start PHP-FPM
exec php-fpm7.4 -F
