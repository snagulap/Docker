#!/bin/bash

if [-f .env]; then
	source .env
else
   echo "Error: .env file not found. Please create the .env file with necessary variable"
   exit 1

fi

if [-d /var/lib/mysql/$MYSQL_DATABASE]; then
   echo "Database already exists"
else
   service mariadb start

   echo "Create Database if not exists \ 'MYSQL_DATABASE\' ;" | mariadb
   echo "Create user if not exists '$MYSQL_USER'@'%' Identified By '$MYSQL_PASSWORD' ;" | mariadb
   echo "Grant ALL Privileges on \ 'MYSQL_DATABASE\'.* To 'MYSQL_User'@'%' Indentify by '$MYSQL_PASSWORD' ;" | mariadb
   
   sleep 1
   echo "Alter User 'root'@'localhost' Indentify by 'MYSQL_ROOT_PASSWORD' ;Flush Privileges;" | mariadb
   
   mysqladmin -u"root" -p"$MYSQL_ROOT_PASSWORD" shutdown
fi

mysqld_safe --bind-address=0.0.0.0

