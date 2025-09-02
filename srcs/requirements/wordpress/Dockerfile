# Use Debian or Alpine (project requires it)
FROM debian:bullseye

# Install php-fpm and necessary extensions
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    php \
    php-fpm \
    php-mysql \
    mariadb-client \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Create directories for php-fpm
RUN mkdir -p /run/php

# Copy php-fpm config (we’ll create this next)
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Copy WordPress setup script
COPY tools/setup_wordpress.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup_wordpress.sh

WORKDIR /var/www/html

# Run the script at container startup
ENTRYPOINT ["/usr/local/bin/setup_wordpress.sh"]

# Expose php-fpm port
EXPOSE 9000
