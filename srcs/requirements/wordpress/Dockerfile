FROM debian:bullseye

# Install PHP-FPM and required extensions
RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-curl \
    php7.4-gd \
    php7.4-intl \
    php7.4-mbstring \
    php7.4-soap \
    php7.4-xml \
    php7.4-xmlrpc \
    php7.4-zip \
    wget \
    netcat \
    && rm -rf /var/lib/apt/lists/*

# Download and install WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Copy configuration files and scripts
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/
COPY tools/init.sh /usr/local/bin/

# Make script executable
RUN chmod +x /usr/local/bin/init.sh

# Set working directory
WORKDIR /var/www/html

# Expose PHP-FPM port
EXPOSE 9000

# Start the initialization script
ENTRYPOINT ["/usr/local/bin/init.sh"]
