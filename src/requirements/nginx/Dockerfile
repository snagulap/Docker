FROM debian:12

RUN apt-get -y update && apt-get -y install nginx && apt-get install openssl

#copy the custom NGINX configuration file
COPY nginx.conf /etc/nginx/conf.d/nginx.conf

#create a directory SSlcertificates

RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -newkey  rsa:4096 -sha256 -days 365 -nodes \
        -out /etc/nginx/ssl/snagulap.42.fr.crt \
        -keyout /etc/nginx/ssl/snagulap.42.fr.key \
        -subj "/C=DE/ST=BW/L=Heilbronn/O=42heilbronn/OU=student/CN=snagulap.42.fr"

#RUN chmod 755 /etc/nginx/ssl/nginx.crt
#RUN chmod 755 /etc/nginx/ssl/nginx.key

#Start NGINX
CMD ["nginx", "-g", "daemon off;"]
