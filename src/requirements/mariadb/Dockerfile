FROM debian:buster

RUN apt-get -y update && apt-get install -y mariadb-server

COPY ./50-server.cnf /etc/mysql/mariadb.conf.d
RUN chmod 664 /etc/mysql/mariadb.conf.d

EXPOSE 3306

COPY ./script.sh .
RUN chmod +x script.sh

CMD ["/script.sh"] 

