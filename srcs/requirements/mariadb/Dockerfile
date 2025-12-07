FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY tools/init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init.sh

VOLUME /var/lib/mysql

EXPOSE 3306

CMD ["/usr/local/bin/init.sh"]
