FROM debian:bullseye

# Install nginx
RUN apt-get update && apt-get install -y \
    nginx \
    && rm -rf /var/lib/apt/lists/*

# Create necessary directories for nginx
RUN mkdir -p /var/log/nginx /var/cache/nginx/client_temp /var/cache/nginx/proxy_temp \
    /var/cache/nginx/fastcgi_temp /var/cache/nginx/uwsgi_temp /var/cache/nginx/scgi_temp
RUN chown -R www-data:www-data /var/log/nginx /var/cache/nginx

# Remove default nginx configuration
RUN rm -f /etc/nginx/sites-enabled/default

# Copy our static website
COPY www/ /usr/share/nginx/html/

# Copy custom nginx configuration
COPY conf/nginx.conf /etc/nginx/sites-available/default
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

# Set proper permissions
RUN chown -R www-data:www-data /usr/share/nginx/html
RUN chmod -R 755 /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
