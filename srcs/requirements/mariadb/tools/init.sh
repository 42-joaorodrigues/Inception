#!/bin/bash

# Initialize MariaDB data directory if it doesn't exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB in the background
mysqld_safe --datadir=/var/lib/mysql --user=mysql &

# Wait for MariaDB to start
while ! mysqladmin ping --silent; do
    sleep 1
done

# Set root password and create database and user
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$SQL_ROOT_PASSWORD';"
mysql -u root -p$SQL_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $SQL_DB_NAME;"
mysql -u root -p$SQL_ROOT_PASSWORD -e "CREATE USER IF NOT EXISTS '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASSWORD';"
mysql -u root -p$SQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON $SQL_DB_NAME.* TO '$SQL_USER'@'%';"
mysql -u root -p$SQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"

# Stop the background process
mysqladmin -u root -p$SQL_ROOT_PASSWORD shutdown

# Start MariaDB in foreground
exec mysqld --user=mysql --datadir=/var/lib/mysql
