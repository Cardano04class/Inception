# USER_DOC — User Documentation

This document explains how to use and operate the services provided by the
Inception project. It is intended for end users or administrators who want to
run the stack, access the website, and verify that everything is working
correctly.

---

## 1. Overview of the Services

The stack provides the following services:

### **1. Nginx**
- Acts as the web server and reverse proxy.
- Serves the WordPress website over HTTPS.

### **2. WordPress + PHP-FPM**
- The content management system (CMS).
- Runs inside its own container using PHP-FPM.

### **3. MariaDB**
- Stores the WordPress database (users, posts, settings, etc.).
- Persistent using Docker volumes.

These services run together to provide a fully functional website with
persistence and secure access.

---

## 2. Starting the Project

You can start the project from the root of the repository.

### **Start**
```sh
make
```

or equivalently:

```sh
docker compose up -d
```

This will:
- Build all container images.
- Start Nginx, MariaDB, and WordPress.
- Create volumes if they do not exist.

---

## 3. Stopping the Project

### **Stop services**
```sh
make stop
```

or:

```sh
docker compose stop
```

### **Stop and remove everything**
```sh
make down
```

### **Stop + remove volumes (warning: deletes database)**
```sh
make fclean
```

---

## 4. Accessing the Website and Admin Panel

### **Public website**
Open in your browser:

```
https://localhost
```

(or your configured domain)

### **WordPress admin panel**
```
https://localhost/wp-admin
```

Login with the admin credentials you configured during WordPress setup.

---

## 5. Locating and Managing Credentials

### **WordPress admin credentials**
- Created during the first WordPress setup step.
- Stored inside the WordPress database (MariaDB).

### **MariaDB credentials**
Defined in the `.env` file in the project root:

```
MYSQL_USER=
MYSQL_PASSWORD=
MYSQL_ROOT_PASSWORD=
MYSQL_DATABASE=
```

Never commit real credentials to Git.

---

## 6. Checking That Services Are Running

### **List running containers**
```sh
docker ps
```

You should see:
- nginx
- wordpress (php-fpm)
- mariadb

### **Check logs**
```sh
docker logs nginx
docker logs wordpress
docker logs mariadb
```

### **Check services via browser**
Open:

```
https://localhost
```

If the website loads → the stack is running correctly.

---

## 7. Persistent Data

Your data persists thanks to Docker volumes:

- **MariaDB database:** `mariadb_data`
- **WordPress files:** `wordpress_data`

Removing containers will not delete website content unless you delete the volumes.

---