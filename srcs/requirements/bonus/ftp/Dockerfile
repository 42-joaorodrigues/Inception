FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    vsftpd \
    && rm -rf /var/lib/apt/lists/*

# Create FTP user and set up directories
RUN useradd -m -d /var/www/html -s /bin/bash ftpuser && \
    echo "ftpuser:ftppassword" | chpasswd && \
    mkdir -p /var/www/html && \
    usermod -a -G www-data ftpuser && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 775 /var/www/html && \
    mkdir -p /var/run/vsftpd/empty

COPY conf/vsftpd.conf /etc/vsftpd.conf
COPY tools/init.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/init.sh

EXPOSE 21 21000-21010

ENTRYPOINT ["/usr/local/bin/init.sh"]
