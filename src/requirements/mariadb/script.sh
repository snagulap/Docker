#!/bin/bash

# Start MariaDB server as a foreground process
service mysql start
# Wait for MariaDB to start
sleep 5

echo "CREATE DATABASE IF NOT EXISTS $SQL_DATABASE ;" > db1.sql
echo "CREATE USER IF NOT EXISTS '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASSWORD' ;" >> db1.sql
echo "GRANT ALL PRIVILEGES ON $SQL_DATABASE.* TO '$SQL_USER'@'%' ;" >> db1.sql
echo "FLUSH PRIVILEGES;" >> db1.sql

# Execute SQL script
mysql < db1.sql

# Stop MariaDB server
mysqladmin -u root -p"$SQL_ROOT_PWD" shutdown



# #!/bin/bash

# if [ -d /var/lib/mysql/$SQL_DATABASE ] ; then
# 	echo "Database already exists"
# else
#     service mysql start

#     echo "CREATE DATABASE IF NOT EXISTS \`$SQL_DATABASE\` ;" | mariadb
#     echo "CREATE USER IF NOT EXISTS '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASSWORD' ;" | mariadb
#     echo "GRANT ALL PRIVILEGES ON \`$SQL_DATABASE\`.* TO '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASSWORD' ;" | mariadb

#     sleep 1
#     echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$SQL_ROOT_PWD' ; FLUSH PRIVILEGES;" | mariadb
#     service mariadb stop
#     mysqladmin -u"root" -p"$SQL_ROOT_PWD" shutdown
# fi

mysqld_safe --bind-address=0.0.0.0




