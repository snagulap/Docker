FROM debian:buster

WORKDIR /db
RUN apt-get -y update \
    && apt-get install -y mariadb-server mariadb-client

COPY ./50-server.cnf /etc/mysql/mariadb.conf.d/
# RUN chmod 644 /etc/mysql/mariadb.conf.d/50-server.cnf

EXPOSE 3306
COPY ./script.sh .
RUN chmod +x script.sh

CMD ["/db/script.sh"] 
# CMD ["tail", "-f", "/dev/null"]
