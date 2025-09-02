#!/bin/bash
set -e

# Initialize database directory if empty
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    
    # Start MariaDB temporarily for setup
    mysqld_safe --user=mysql --datadir=/var/lib/mysql --skip-networking --socket=/var/run/mysqld/mysqld.sock &
    pid="$!"
    
    # Wait for socket connection
    for i in {60..0}; do
        if mysqladmin ping --socket=/var/run/mysqld/mysqld.sock &>/dev/null; then
            break
        fi
        echo "MariaDB init process in progress..."
        sleep 1
    done
    
    if [ "$i" = 0 ]; then
        echo "MariaDB initialization failed."
        exit 1
    fi
    
    # Create database, user, and grant privileges
    mysql --socket=/var/run/mysqld/mysqld.sock -uroot <<-EOSQL
        CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        DELETE FROM mysql.user WHERE User='';
        DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
        DROP DATABASE IF EXISTS test;
        DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
        FLUSH PRIVILEGES;
EOSQL
    
    # Stop temporary mysqld
    if ! kill -s TERM "$pid" || ! wait "$pid"; then
        echo "Failed to stop temporary MariaDB server"
        exit 1
    fi
    
    echo "MariaDB setup complete."
fi

echo "Starting MariaDB..."
# Start MariaDB normally
exec mysqld --user=mysql --datadir=/var/lib/mysql
