# Inception Project Architecture

## 🏗️ Overview
The Inception project is a multi-container Docker application that creates a complete web hosting environment with WordPress, database, web server, and various bonus services. All services are containerized and orchestrated using Docker Compose.

---

## 🌐 Network Architecture

```
┌───────────────────────────────────────────────────────────────────────┐
│                           HOST SYSTEM                                 │
│  ┌─────────────────────────────────────────────────────────────────┐  │
│  │                    Docker Network: inception                    │  │
│  │                         (bridge driver)                         │  │
│  │                                                                 │  │
│  │  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐   │  │
│  │  │ MariaDB  │    │WordPress │    │  Nginx   │    │  Redis   │   │  │
│  │  │:3306     │◄──►│:9000     │◄──►│:443      │    │:6379     │   │  │
│  │  │          │    │          │    │          │    │          │   │  │
│  │  └──────────┘    └──────────┘    └──────────┘    └──────────┘   │  │
│  │                                      ▲                          │  │
│  │  ┌──────────┐    ┌──────────┐        │        ┌──────────┐      │  │
│  │  │   FTP    │    │FileBrows.│        │        │ Adminer  │      │  │
│  │  │:21       │◄──►│:8082     │        │        │:80       │      │  │
│  │  │:21000-   │    │          │        │        │          │      │  │
│  │  │21010     │    └──────────┘        │        └──────────┘      │  │
│  │  └──────────┘                        │                          │  │
│  │                                      │                          │  │
│  │  ┌──────────┐                        │                          │  │
│  │  │ Static   │                        │                          │  │
│  │  │ Website  │                        │                          │  │
│  │  │:80       │                        │                          │  │
│  │  └──────────┘                        │                          │  │
│  └──────────────────────────────────────┼──────────────────────────┘  │
│                                         │                             │
│  ┌──────────────────────────────────────┼──────────────────────────┐  │
│  │                 HOST PORTS           │                          │  │
│  │  443 ───────────────────────────────►│ HTTPS (Nginx)            │  │
│  │  21 ────────────────────────────────►│ FTP                      │  │
│  │  21000-21010 ───────────────────────►│ FTP Passive Ports        │  │
│  │  6379 ──────────────────────────────►│ Redis                    │  │
│  │  8080 ──────────────────────────────►│ Static Website           │  │
│  │  8081 ──────────────────────────────►│ Adminer                  │  │
│  │  9000 ──────────────────────────────►│ File Browser             │  │
│  └─────────────────────────────────────────────────────────────────┘  │
└───────────────────────────────────────────────────────────────────────┘
```

---

## 🔧 Service Details

### 📊 **Mandatory Services**

#### 1. **MariaDB** (Database)
```
┌───────────────────────────────────┐
│            MariaDB                │
│  ┌─────────────────────────────┐  │
│  │   Database: wordpress       │  │
│  │   User: $SQL_USER           │  │
│  │   Password: $SQL_PASSWORD   │  │
│  │   Root: $SQL_ROOT_PASSWORD  │  │
│  └─────────────────────────────┘  │
│                                   │
│  Volume: mariadb_data             │
│  └─► /var/lib/mysql               │
│                                   │
│  Network: inception               │
│  Internal Port: 3306              │
│  External Access: None            │
└───────────────────────────────────┘
```
- **Purpose**: Database server for WordPress
- **Technology**: MariaDB 10.5+ on Debian Bullseye
- **Data Persistence**: `/home/$USER/data/mariadb`
- **Configuration**: Remote root access enabled for containers

#### 2. **WordPress** (Application)
```
┌───────────────────────────────────┐
│            WordPress              │
│  ┌─────────────────────────────┐  │
│  │   PHP-FPM 7.4               │  │
│  │   WP-CLI                    │  │
│  │   Redis Object Cache        │  │
│  │   Admin: $WP_ADMIN_USER     │  │
│  │   User: $WP_USER            │  │
│  └─────────────────────────────┘  │
│                                   │
│  Volume: wordpress_data           │
│  └─► /var/www/html                │
│                                   │
│  Network: inception               │
│  Internal Port: 9000 (FastCGI)    │
│  External Access: Via Nginx       │
└───────────────────────────────────┘
```
- **Purpose**: Content Management System
- **Technology**: WordPress + PHP-FPM on Debian Bullseye
- **Features**: Redis caching, automatic installation
- **Data Persistence**: `/home/$USER/data/wordpress`

#### 3. **Nginx** (Web Server)
```
┌───────────────────────────────────┐
│             Nginx                 │
│  ┌─────────────────────────────┐  │
│  │   SSL/TLS Termination       │  │
│  │   Reverse Proxy             │  │
│  │   Static File Serving       │  │
│  │   Certificate: Self-signed  │  │
│  └─────────────────────────────┘  │
│                                   │
│  Volume: wordpress_data (shared)  │
│  └─► /var/www/html                │
│                                   │
│  Network: inception               │
│  Internal Port: 443               │
│  External Port: 443 (HTTPS)       │
└───────────────────────────────────┘
```
- **Purpose**: Web server and SSL termination
- **Technology**: Nginx on Debian Bullseye
- **Features**: HTTPS only, FastCGI proxy to WordPress
- **SSL**: Self-signed certificate for `joao-alm.42.fr`

### 🎁 **Bonus Services**

#### 4. **Redis** (Cache)
```
┌───────────────────────────────────┐
│             Redis                 │
│  ┌─────────────────────────────┐  │
│  │   In-Memory Cache           │  │
│  │   Object Caching for WP     │  │
│  │   Session Storage           │  │
│  └─────────────────────────────┘  │
│                                   │
│  Network: inception               │
│  Internal Port: 6379              │
│  External Port: 6379              │
└───────────────────────────────────┘
```
- **Purpose**: Application caching and performance
- **Integration**: WordPress Redis Object Cache plugin

#### 5. **FTP** (File Transfer)
```
┌───────────────────────────────────┐
│              FTP                  │
│  ┌─────────────────────────────┐  │
│  │   vsftpd Server             │  │
│  │   User: $FTP_USER           │  │
│  │   Password: $FTP_PASSWORD   │  │
│  │   Passive Ports: 21000-21010│  │
│  └─────────────────────────────┘  │
│                                   │
│  Volume: wordpress_data (shared)  │
│  └─► /var/www/html                │
│                                   │
│  Network: inception               │
│  External Ports: 21, 21000-21010  │
└───────────────────────────────────┘
```
- **Purpose**: File upload/download access
- **Access**: WordPress files via FTP client

#### 6. **Adminer** (Database Management)
```
┌──────────────────────────────────────┐
│            Adminer                   │
│  ┌────────────────────────────────┐  │
│  │   Web-based DB Admin           │  │
│  │   Apache + PHP                 │  │
│  │   MariaDB Interface            │  │
│  └────────────────────────────────┘  │
│                                      │
│  Network: inception                  │
│  Internal Port: 80                   │
│  External Port: 8081                 │
│  Access: http://joao-alm.42.fr:8081  │
└──────────────────────────────────────┘
```
- **Purpose**: Database administration interface
- **Access**: Web browser, connects to MariaDB

#### 7. **File Browser** (File Management)
```
┌──────────────────────────────────────┐
│          File Browser                │
│  ┌────────────────────────────────┐  │
│  │   Web File Manager             │  │
│  │   User: $FB_ADMIN_USER         │  │
│  │   Password: $FB_ADMIN_PASS     │  │
│  │   WordPress File Access        │  │
│  └────────────────────────────────┘  │
│                                      │
│  Volumes:                            │
│  ├─► wordpress_data → /srv           │
│  └─► filebrowser_data → /database    │
│                                      │
│  Network: inception                  │
│  External Port: 9000                 │
│  Access: http://joao-alm.42.fr:9000  │
└──────────────────────────────────────┘
```
- **Purpose**: Web-based file management
- **Access**: Upload, download, edit WordPress files

#### 8. **Static Website** (Portfolio)
```
┌──────────────────────────────────────┐
│          Static Website              │
│  ┌────────────────────────────────┐  │
│  │   Personal Portfolio           │  │
│  │   Nginx Static Server          │  │
│  │   HTML/CSS/JS                  │  │
│  └────────────────────────────────┘  │
│                                      │
│  Network: inception                  │
│  Internal Port: 80                   │
│  External Port: 8080                 │
│  Access: http://joao-alm.42.fr:8080  │
└──────────────────────────────────────┘
```
- **Purpose**: Personal portfolio/static content
- **Technology**: Custom HTML/CSS/JS served by Nginx

---

## 🔄 Data Flow & Interactions

### **Web Request Flow (HTTPS)**
```
[Browser] ──HTTPS:443──► [Nginx] ──FastCGI:9000──► [WordPress] ──MySQL:3306──► [MariaDB]
                           │                           │
                           │                           │
                           │                      ┌────▼────┐
                           │                      │  Redis  │
                           │                      │  Cache  │
                           │                      └─────────┘
                           │
                      ┌────▼────┐
                      │WordPress│
                      │  Files  │
                      └─────────┘
```

### **File Management Flow**
```
[FTP Client] ──FTP:21──► [FTP Server] ──► [WordPress Files]
                                               ▲
[Web Browser] ──HTTP:9000──► [File Browser] ───┘
```

### **Database Management Flow**
```
[Web Browser] ──HTTP:8081──► [Adminer] ──MySQL:3306──► [MariaDB]
```

---

## 📂 Volume Mapping & Persistence

```
Host Filesystem             Container Mounts
/home/$USER/data/
├── mariadb/      ◄───────► mariadb:/var/lib/mysql
├── wordpress/    ◄──────┬► wordpress:/var/www/html
│                        ├► nginx:/var/www/html
│                        ├► ftp:/var/www/html
│                        └► filebrowser:/srv
└── filebrowser/  ◄───────► filebrowser:/database
```

### **Shared Volume Strategy**
- **`wordpress_data`**: Shared between Nginx (serving), WordPress (processing), FTP (uploading), and File Browser (managing)
- **`mariadb_data`**: Exclusive to MariaDB for database files
- **`filebrowser_data`**: Exclusive to File Browser for application data

---

## 🔒 Security & Environment Variables

### **Environment Configuration (.env)**
```bash
# Database
SQL_ROOT_PASSWORD=secure_root_pass
SQL_USER=wordpress_user
SQL_PASSWORD=secure_db_pass

# WordPress
WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=secure_admin_pass
WP_ADMIN_EMAIL=admin@example.com
WP_USER=user
WP_USER_EMAIL=user@example.com
WP_USER_PASSWORD=secure_user_pass

# Domain
DOMAIN_NAME=joao-alm.42.fr

# FTP
FTP_USER=ftpuser
FTP_PASSWORD=secure_ftp_pass

# File Browser
FB_ADMIN_USER=admin
FB_ADMIN_PASSWORD=secure_fb_pass
```

### **Security Features**
- 🔐 All credentials externalized to environment variables
- 🚫 No hardcoded passwords in source code
- 📜 Self-signed SSL certificates for HTTPS
- 🌐 Internal network isolation (inception bridge)
- 🔒 File permissions properly configured

---

## 🚀 Service Dependencies

```
Startup Order:
1. MariaDB ──┐
2. Redis ────┼──► WordPress ──► Nginx
3. FTP ──────┘
4. Adminer (depends on MariaDB)
5. File Browser (depends on WordPress)
6. Static Website (independent)
```

### **Critical Dependencies**
- **WordPress** requires MariaDB and Redis to be running
- **Nginx** requires WordPress for FastCGI processing
- **Adminer** requires MariaDB for database access
- **File Browser** requires WordPress volume to be initialized
- **FTP** requires WordPress volume for file access

---

## 🌍 Access Points

| Service      | URL                          | Protocol       | Purpose         |
|--------------|------------------------------|----------------|-----------------|
| WordPress    | `https://joao-alm.42.fr`     | HTTPS          | Main website    |
| Adminer      | `http://joao-alm.42.fr:8081` | HTTP           | Database admin  |
| File Browser | `http://joao-alm.42.fr:9000` | HTTP           | File management |
| Static Site  | `http://joao-alm.42.fr:8080` | HTTP           | Portfolio       |
| FTP          | `ftp://joao-alm.42.fr:21`    | FTP            | File transfer   |
| Redis	       | `joao-alm.42.fr:6379`        | Redis Protocol | Cache access    |

---

## 🛠️ Technology Stack

| Layer                 | Technology              | Purpose                  |
|-----------------------|-------------------------|--------------------------|
| **Container Runtime** | Docker + Docker Compose | Orchestration            |
| **Base Images**       | Debian Bullseye         | Consistent foundation    |
| **Web Server**        | Nginx                   | Reverse proxy + SSL      |
| **Application**       | WordPress + PHP-FPM     | CMS                      |
| **Database**          | MariaDB                 | Data persistence         |
| **Cache**             | Redis                   | Performance optimization |
| **File Management**   | File Browser + vsftpd   | File operations          |
| **Database Admin**    | Adminer                 | DB management            |
| **Static Hosting**    | Nginx                   | Static content           |

---

## 📋 Project Requirements Compliance

### **Mandatory (3 services)**
- ✅ **Nginx**: Web server with SSL/TLS
- ✅ **WordPress**: CMS with PHP-FPM
- ✅ **MariaDB**: Database server

### **Bonus (5 services)**
- ✅ **Redis**: Caching service
- ✅ **FTP**: File transfer protocol
- ✅ **Adminer**: Database administration
- ✅ **File Browser**: Web-based file management
- ✅ **Static Website**: Additional web service

### **Technical Requirements**
- ✅ Custom Dockerfiles (no pre-built images)
- ✅ Debian Bullseye base images
- ✅ Docker Compose orchestration
- ✅ Volume persistence
- ✅ Custom network
- ✅ Environment variable configuration
- ✅ No hardcoded credentials

---

This architecture creates a complete, production-like web hosting environment with redundant file management capabilities, comprehensive database administration, and performance optimization through caching.