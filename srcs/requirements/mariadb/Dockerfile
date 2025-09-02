FROM debian:bullseye

# Install MariaDB server & client
RUN apt-get update
RUN apt-get install -y mariadb-server mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Ensure run directory exists
RUN mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld \
    && chmod 777 /var/run/mysqld

# Copy config and setup script
COPY conf/mysqld.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/mariadb.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/mariadb.sh

# Expose MariaDB port
EXPOSE 3306

ENTRYPOINT [ "/usr/local/bin/mariadb.sh" ]
CMD ["mysqld"]
