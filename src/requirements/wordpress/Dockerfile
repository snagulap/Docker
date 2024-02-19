FROM debian:buster

RUN apt-get -y update
RUN apt install -y php-mysql
#RUN apt install curl -y

EXPOSE 9000
COPY ./wp-config.php /etc/php/pool.d

COPY ./script.sh .
RUN chmod +x script.sh

CMD ["./script.sh"]
