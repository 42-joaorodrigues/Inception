FROM debian:bullseye

# Install necessary packages
RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    php-mysql \
    php-mbstring \
    php-zip \
    php-gd \
    php-json \
    php-curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Download and install phpMyAdmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.tar.gz \
    && tar xzf phpMyAdmin-5.2.1-all-languages.tar.gz \
    && mv phpMyAdmin-5.2.1-all-languages /var/www/html/phpmyadmin \
    && rm phpMyAdmin-5.2.1-all-languages.tar.gz \
    && chown -R www-data:www-data /var/www/html/phpmyadmin

# Remove default Apache files and create redirect
RUN rm -f /var/www/html/index.html
RUN echo '<?php header("Location: /phpmyadmin/"); exit(); ?>' > /var/www/html/index.php

# Copy configuration files
COPY conf/config.inc.php /var/www/html/phpmyadmin/
COPY tools/init.sh /usr/local/bin/

# Make init script executable
RUN chmod +x /usr/local/bin/init.sh

# Create necessary directories
RUN mkdir -p /var/www/html/phpmyadmin/tmp \
    && chown -R www-data:www-data /var/www/html/phpmyadmin/tmp \
    && chmod 777 /var/www/html/phpmyadmin/tmp

# Expose port 80
EXPOSE 80

ENTRYPOINT ["/usr/local/bin/init.sh"]