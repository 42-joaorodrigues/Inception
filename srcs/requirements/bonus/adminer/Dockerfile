FROM debian:bullseye

# Install PHP, Apache, and necessary extensions
RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    libapache2-mod-php \
    php-mysql \
    php-mysqli \
    php-mbstring \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Configure Apache
RUN mkdir -p /var/www/html
RUN chown -R www-data:www-data /var/www/html

# Enable Apache modules
RUN a2enmod php7.4
RUN a2enmod rewrite

# Configure Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Remove default Apache files
RUN rm -f /var/www/html/index.html

# Download Adminer
RUN curl -L https://www.adminer.org/latest.php -o /var/www/html/adminer.php

# Create a custom index.php that redirects to adminer.php
RUN echo '<?php header("Location: adminer.php"); exit(); ?>' > /var/www/html/index.php

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# Copy custom configuration script
COPY tools/init.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/init.sh

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/init.sh"]
