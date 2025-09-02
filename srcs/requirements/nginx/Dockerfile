FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Copy Nginx config
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Create SSL cert (self-signed)
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/selfsigned.key \
        -out /etc/nginx/ssl/selfsigned.crt \
        -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=student/CN=joao-alm.42.fr" \
        -days 365

WORKDIR /var/www/html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
