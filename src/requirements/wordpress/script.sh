#!/bin/bash

# Create directory if it doesn't exist and navigate to it


#mv /wordpress/wp-config.php /var/www/wordpress

cd /var/www/wordpress

echo "ENV =" $SQL_DATABASE $SQL_USER $SQL_PASSWORD

# Create wp-config.php file
    wp config create --allow-root \
        --dbname=$SQL_DATABASE \
        --dbuser=$SQL_USER \
        --dbpass=$SQL_PASSWORD \
        --dbhost=$SQL_HOSTNAME --path='/var/www/wordpress'

#     # Remove wp-config-sample.php if it exists
#     [ -f wp-content/wp-config-sample.php ] && rm /var/www/wordpress/wp-config-sample.php
# fi

# Sleep for 6 seconds
sleep 6

# Check if WordPress is already installed
if wp core is-installed --url=$DOMAIN_NAME --allow-root ; then
    echo "WordPress already installed"
else 
    # Install WordPress
    wp core install --url=$DOMAIN_NAME/ \
                    --title="$WP_TITLE" \
                    --admin_user=$WP_ADMIN_USER \
                    --admin_password=$WP_ADMIN_PASSWORD \
                    --admin_email=$WP_ADMIN_EMAIL \
                    --skip-email --allow-root

    # Create a user with author role
    wp user create $WP_USER $WP_EMAIL --role=author --user_pass=$WP_PASSWORD --allow-root

    # Install and activate the Salient theme
    wp theme install salient --activate --allow-root

    # Update all plugins
    wp plugin update --all --allow-root
fi

# Update PHP-FPM configuration
sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g' /etc/php/7.3/fpm/pool.d/www.conf

# Change ownership of the web directory
chown www-data:www-data -R /var/www/*

# Create /run/php directory if it doesn't exist
mkdir -p /run/php

# Start PHP-FPM
touch /run/php/php7.3-fpm.pid



# #!/bin/bash

# # Create directory if it doesn't exist and navigate to it
# mkdir -p /var/www/html && cd /var/www/html

# # Check if wp-config.php file exists
# if [ -f ./wp-config.php ]; then
#     echo "Config already exists"
# else
#     # Create wp-config.php file
#     /usr/local/bin/wp config create --allow-root \
#         --dbname=$SQL_DB \
#         --dbuser=$SQL_USER \
#         --dbpass=$SQL_PASSWORD \
#         --dbhost=$SQL_HOSTNAME:3306 --path='/var/www/html'

#     mv /wp-config.php /var/www/html/

#     # Remove wp-config-sample.php if it exists
#     [ -f /var/www/html/wp-config-sample.php ] && rm /var/www/html/wp-config-sample.php
# fi

# sleep 6

# # Check if WordPress is already installed
# if /usr/local/bin/wp core is-installed --url=$DOMAIN_NAME --allow-root ; then
#     echo "WordPress already installed"
# else 
#     # Install WordPress
#     /usr/local/bin/wp core install --url=$DOMAIN_NAME/ \
#                     --title="$WP_TITLE" \
#                     --admin_user=$WP_ADMIN_USER \
#                     --admin_password=$WP_ADMIN_PASSWORD \
#                     --admin_email=$WP_ADMIN_EMAIL \
#                     --skip-email --allow-root

#     # Create a user with author role
#     /usr/local/bin/wp user create $WP_USER $WP_EMAIL --role=author --user_pass=$WP_PASSWORD --allow-root

#     # Install and activate the Salient theme
#     /usr/local/bin/wp theme install salient --activate --allow-root

#     # Update all plugins
#     /usr/local/bin/wp plugin update --all --allow-root
# fi

# # Update PHP-FPM configuration
# sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/g' /etc/php/7.4/fpm/pool.d/www.conf

# # Change ownership of the web directory
# chown www-data:www-data -R /var/www/html/

# # Create /run/php directory if it doesn't exist
# [ ! -d /run/php ] && mkdir /run/php

# # Start PHP-FPM
# /usr/sbin/php-fpm7.4 -F


