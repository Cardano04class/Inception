*This project has been created as part of the 42 curriculum by mamir.*

# Inception

## Description

Inception is a system administration and DevOps project from the 42
curriculum.\
The goal is to build a fully‑functional WordPress website running inside
a custom Docker-based infrastructure.

This project makes you design and assemble multiple custom Docker
images, enforce strict networking and security rules, configure services
manually, and deploy everything using a single `docker-compose.yml`.

Your WordPress website must run securely over HTTPS using TLS
certificates generated at build time.\
Each service runs in its own container, and the data persists through
mounted volumes in `/home/mamir/data`.

------------------------------------------------------------------------

## Instructions

### Requirements

-   Docker\
-   Docker Compose\
-   A domain pointing to your machine (for HTTPS)\
-   The mandatory folder structure provided by the subject

All commands must be run from inside the project root.

------------------------------------------------------------------------

### Build the entire project:

``` bash
make
```

### Stop containers:

``` bash
make stop
```

### Clean containers, images, networks:

``` bash
make clean
```

### Clean everything including volumes:

``` bash
make fclean
```

### Rebuild from scratch:

``` bash
make re
```

------------------------------------------------------------------------

## Resources

### Official Documentation

-   Docker: https://docs.docker.com\
-   Docker Compose: https://docs.docker.com/compose\
-   Nginx: https://nginx.org/en/docs/\
-   MariaDB: https://mariadb.org/documentation/\
-   WordPress: https://wordpress.org/support/

### How AI Was Used

AI (ChatGPT) was used during development to:

-   Help debug Docker and WordPress connectivity issues\
-   Refine Dockerfiles and entrypoint scripts\
-   Provide explanations for Docker networking\
-   Improve the readability and structure of the README

All infrastructure, configuration, and code were written, tested, and
validated manually.

------------------------------------------------------------------------

## Notes

-   The project must not expose port **80**.\
-   HTTP must *not* serve the site --- all traffic must be strictly
    HTTPS (port 443).\
-   Volumes must be mapped to:
    -   `/home/mamir/data/mariadb`\
    -   `/home/mamir/data/wordpress`
