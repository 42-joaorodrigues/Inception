# Inception Project - Host Setup Instructions

## To access your WordPress site locally:

Add this line to your `/etc/hosts` file:

```
127.0.0.1   joao-alm.42.fr
```

### On Linux:
```bash
sudo echo "127.0.0.1   joao-alm.42.fr" >> /etc/hosts
```

### On macOS:
```bash
sudo echo "127.0.0.1   joao-alm.42.fr" >> /etc/hosts
```

### On Windows:
Add the line to `C:\Windows\System32\drivers\etc\hosts`

## After adding the host entry:

1. Run `make` to build and start the containers
2. Access your site at: https://joao-alm.42.fr
3. Accept the self-signed certificate warning in your browser

## WordPress Login Credentials:

- **Admin User**: jrodrig
- **Admin Password**: adminpass123
- **Admin Email**: jrodrig@student.42.fr

- **Regular User**: normaluser
- **User Password**: userpass123
- **User Email**: user@student.42.fr

## Services:

- **NGINX**: Reverse proxy with SSL/TLS (port 443)
- **WordPress**: Content management system with PHP-FPM
- **MariaDB**: Database server

## Data Persistence:

All data is stored in `/home/joao-alm/data/`:
- MariaDB data: `/home/joao-alm/data/mariadb`
- WordPress files: `/home/joao-alm/data/wordpress`
