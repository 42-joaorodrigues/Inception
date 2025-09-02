#!/bin/bash
set -e

# Extract hostname from WORDPRESS_DB_HOST (remove port if present)
DB_HOST=$(echo "$WORDPRESS_DB_HOST" | cut -d':' -f1)

# Wait for database to be ready
until mysqladmin ping -h"$DB_HOST" --silent; do
    echo "Waiting for database connection..."
    sleep 2
done

# Download WordPress if not already present
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Downloading WordPress..."
    wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz
    tar -xzf /tmp/wordpress.tar.gz -C /tmp/
    mv /tmp/wordpress/* /var/www/html/
    rm -rf /tmp/wordpress /tmp/wordpress.tar.gz

    # Download WP-CLI
    wget https://raw.githubusercontent.com/wp-cli/wp-cli/master/phar/wp-cli.phar -O /usr/local/bin/wp
    chmod +x /usr/local/bin/wp

    cd /var/www/html

    # Create wp-config.php
    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --allow-root

    # Install WordPress
    wp core install \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root

    # Create second user (regular user)
    wp user create \
        "$WP_USER" \
        "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author \
        --allow-root

    echo "WordPress installation completed with 2 users created!"
fi

chown -R www-data:www-data /var/www/html

# Start php-fpm in foreground
exec php-fpm7.4 -F
