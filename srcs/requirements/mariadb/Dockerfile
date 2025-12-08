FROM debian:bullseye

# Install MariaDB server and client
RUN apt-get update && apt-get install -y \
    mariadb-server mariadb-client \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create runtime directory for MySQL socket
RUN mkdir -p /run/mysqld \
    && chown -R mysql:mysql /run/mysqld

# Ensure MariaDB will read custom conf and listen on all interfaces
RUN mkdir -p /etc/mysql/mariadb.conf.d \
    && chown -R mysql:mysql /etc/mysql/mariadb.conf.d

# Copy optional initialization scripts
# Any SQL files or shell scripts in this directory will be executed at container start
COPY init.sh /docker-entrypoint-initdb.d/
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /docker-entrypoint-initdb.d/init.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["mysqld"]
