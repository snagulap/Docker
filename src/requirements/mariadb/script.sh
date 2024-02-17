#!/bin/bash

#define variables
DB_NAME = mydatabase
DB_USER = myuser
DB_PASSWORD = mypassword

#RUN container
docker run -d \
	--name mariadb
	-e MYSQL_ROOT_PASSWORD=$DB_PASSWORD
	-e MYSQL_DATABASE=$DB_NAME
	-e MYSQL_USER=$DB_USER
	-e MYSQL_PASSWORD=$DB_PASSWORD
	-p 3306:3306
	mariadb

#check if the container running
if["$(docker ps -q -f name=mariadb)"]; then
	echo "container is running"
	echo "Database Name: $DB_NAME"
	echo "Username: $DB_USER"
	echo "PASSWORD: $DB_PASSOWRD"
else 
	echo "Failed to start mariadb container."
fi



