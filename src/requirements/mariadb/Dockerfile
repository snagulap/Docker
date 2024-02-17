FROM debian:buster

RUN apt-get -y update && apt-get install -y mariadb-server

COPY ./50-server.cnf /etc/mysql/mariadb.conf.d

COPY ./script.sh .

CMD ["/script.sh"] 

