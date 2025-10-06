#!/bin/bash

# Create the chroot list file
echo "ftpuser" > /etc/vsftpd.chroot_list

# Create user list file
echo "ftpuser" > /etc/vsftpd.userlist

# Set ownership of the WordPress directory  
chown -R www-data:www-data /var/www/html
chmod -R 775 /var/www/html

# Make sure the user can write to the directory
if [ ! -f "/var/www/html/.write_test" ]; then
    touch /var/www/html/.write_test 2>/dev/null || true
fi

echo "Starting vsftpd..."
exec vsftpd /etc/vsftpd.conf
