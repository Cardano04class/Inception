# *This project has been created as part of the 42 curriculum by mamir.*

# Inception -- Docker-Based Web Infrastructure

## Description

Inception is a system administration and containerization project that
introduces you to Docker by having you create a fully isolated web
infrastructure using Dockerfiles, Docker Compose, networks, and
volumes.\
The goal is to design and deploy a WordPress website running behind an
NGINX reverse‑proxy and connected to a MariaDB database --- all built
**from scratch using Dockerfiles only** (no prebuilt images).

The setup includes: - A MariaDB database container\
- A WordPress + PHP-FPM container\
- An NGINX HTTPS‑only server\
- A shared Docker network for communication\
- Bind‑mounted persistent data directories\
- Environment variables for configuration

------------------------------------------------------------------------

## Instructions

### **Prerequisites**

-   Docker\
-   Docker Compose\
-   A `.env` file configured with all required variables\
-   A domain name pointing to your machine

### **Project Structure**

    inception/
    │
    ├── Makefile
    ├── docker-compose.yml
    ├── .env
    └── srcs/
        ├── requirements/
        │   ├── nginx/
        │   ├── mariadb/
        │   └── wordpress/
        └── ...

### **Build & Run**

``` sh
make
```

### **Stop and Clean Everything**

``` sh
make fclean
```

### **Rebuild from Scratch**

``` sh
make re
```

------------------------------------------------------------------------

## Resources

### **Documentation & Tutorials**

-   Docker Docs -- https://docs.docker.com\
-   Docker Compose -- https://docs.docker.com/compose\
-   MariaDB Docs -- https://mariadb.com/kb/en/documentation\
-   NGINX Docs -- https://nginx.org/en/docs\
-   WordPress Codex -- https://developer.wordpress.org

### **How AI Was Used**

AI was used strictly for: - Structuring the README\
- Debugging Dockerfile and environment issues\
- Suggesting best practices for container communication and health
checks\
- Providing explanations and high-level comparisons for system concepts

All implementation, configuration, and final decisions were made
manually.

------------------------------------------------------------------------

## Additional Project Requirements

### **Design Choices & Docker Usage**

The project uses Docker to create an isolated, reproducible, and modular
web stack.\
Each service has: - Its own Dockerfile\
- Its own container\
- Its own role in the system

**Why this design?** - Clear isolation between components\
- Better security and reproducibility\
- Deterministic environment\
- Avoid dependency conflicts\
- Faster redeployment

### **Comparisons**

#### **1. Virtual Machines vs Docker**

  Virtual Machines            Docker Containers
  --------------------------- -------------------------
  Full OS per VM              Shared host kernel
  Heavy, resource-intensive   Lightweight & fast
  Slow startup                Instant startup
  Strong isolation            Process-level isolation
  Ideal for multi‑OS setups   Ideal for microservices

#### **2. Secrets vs Environment Variables**

  -----------------------------------------------------------------------
  Environment Variables         Secrets (e.g., Docker Secrets)
  ----------------------------- -----------------------------------------
  Simple to use                 More secure

  Visible in container using    Mounted as files, not exposed in env
  `env`                         

  Stored in plain text          Encrypted / protected

  OK for local projects         Recommended for production
  -----------------------------------------------------------------------

For this project, `.env` is required by the subject and considered
acceptable.

#### **3. Docker Network vs Host Network**

  -----------------------------------------------------------------------
  Docker Network                        Host Network
  ------------------------------------- ---------------------------------
  Isolated                              Shares host network namespace

  Services discover each other by       Full access to host ports
  container name                        

  More secure                           Less secure

  Enables virtual private networks      Higher risk of port conflicts
  -----------------------------------------------------------------------

This project uses a **Docker bridge network** for isolation.

#### **4. Docker Volumes vs Bind Mounts**

  Bind Mounts                    Volumes
  ------------------------------ ------------------------
  Direct host → container path   Managed by Docker
  Good for development           Good for production
  Must manage host permissions   Docker handles storage
  Faster to modify               More stable long-term

The project uses **Bind Mounts**, because the subject requires mounting
to `/home/login/data`.

------------------------------------------------------------------------
