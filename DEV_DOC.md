
# DEV_DOC — Developer Documentation

This document explains how developers can set up, build, run, and maintain the
Inception project.

---

## 1. Prerequisites

Before starting development, install:

### **Required software**
- Docker
- Docker Compose
- Make
- Git

### **Required configuration**
A `.env` file must be placed in the project's root:

```
MYSQL_DATABASE=
MYSQL_USER=
MYSQL_PASSWORD=
MYSQL_ROOT_PASSWORD=
DOMAIN_NAME=
```

This file provides environment variables for Docker Compose.

---

## 2. Setting Up the Environment From Scratch

1. Clone the repository:
```sh
git clone <repository>
cd <repository>
```

2. Ensure the folder structure is present:
```
srcs/
 ├── docker-compose.yml
 ├── requirements/
 │    ├── mariadb/
 │    ├── nginx/
 │    └── wordpress/
```

3. Create the `.env` file with your credentials.

4. Build and launch the containers using the Makefile:
```sh
make
```

---

## 3. Build and Launch the Project

### **Using Makefile**
```sh
make
```

### **Using Docker Compose**
```sh
docker compose up -d --build
```

This will:
- Build images from Dockerfiles.
- Start all services.
- Recreate containers if needed.

---

## 4. Useful Development Commands

### **List containers**
```sh
docker ps
```

### **Enter a container**
```sh
docker exec -it wordpress bash
docker exec -it mariadb bash
```

### **Show logs**
```sh
docker logs nginx
docker logs wordpress
docker logs mariadb
```

### **Rebuild a single service**
```sh
docker compose build wordpress
docker compose build nginx
docker compose build mariadb
```

---

## 5. Volumes and Persistent Data

The stack uses named volumes to persist data:

### **MariaDB volume**
Stores database files:
```
/var/lib/mysql
```

### **WordPress volume**
Stores WordPress installation + uploaded content:
```
/var/www/html
```

### **List volumes**
```sh
docker volume ls
```

### **Inspect a volume**
```sh
docker volume inspect mariadb_data
```

### **Remove volumes (danger: deletes all data)**
```sh
docker compose down -v
```

or using the Makefile:
```sh
make fclean
```

---

## 6. Directory Structure Overview

```
.
├── Makefile
├── .env
└── srcs
    ├── docker-compose.yml
    └── requirements
        ├── mariadb
        │   └── Dockerfile
        ├── nginx
        │   └── Dockerfile
        └── wordpress
            └── Dockerfile
```

---

## 7. SSL / Nginx Configuration

Nginx generates or uses existing TLS certificates located in:

```
/etc/nginx/ssl/
```

If using self-signed certificates, browsers may require confirmation.

---

## 8. Cleaning and Rebuilding Everything

### **Stop containers**
```sh
make stop
```

### **Remove containers**
```sh
make down
```

### **Remove containers + volumes + images**
```sh
make fclean
```

This resets the entire environment.

---

## 9. Troubleshooting

### **Port already in use**
```sh
sudo lsof -i :443
sudo kill <pid>
```

### **Database fails to start**
- Check `.env` credentials.
- Ensure no previous corrupted volume exists.

### **WordPress cannot connect to MariaDB**
- Verify service name is `mariadb` in `docker-compose.yml`.
- Test DB connection manually:

```sh
docker exec -it mariadb mysql -u$MYSQL_USER -p
```
---