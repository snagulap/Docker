#!/bin/bash

# Create directory if it doesn't exist and navigate to it


#mv /wordpress/wp-config.php /var/www/wordpress

cd /var/www/wordpress
wp core download --allow-root --force

# Create wp-config.php file
    wp config create --allow-root \
        --dbname=$SQL_DATABASE \
        --dbuser=$SQL_USER \
        --dbpass=$SQL_PASSWORD \
        --dbhost=$SQL_HOSTNAME:3306 --path='/var/www/wordpress'

#     # Remove wp-config-sample.php if it exists
#     [ -f wp-content/wp-config-sample.php ] && rm /var/www/wordpress/wp-config-sample.php
# fi

# Check if WordPress is already installed
if ! wp core is-installed --url=$DOMAIN_NAME --allow-root ; then
    # echo "WordPress already installed"
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
    wp theme install astra --activate --allow-root

    # Update all plugins
    wp plugin update --all --allow-root
fi

# Update PHP-FPM configuration
sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g' /etc/php/7.3/fpm/pool.d/www.conf

# Change ownership of the web directory
chown www-data:www-data -R /var/www/wordpress

# Create /run/php directory if it doesn't exist
mkdir -p /run/php

# Start PHP-FPM
# touch /run/php/php7.3-fpm.pid
php-fpm7.3 -F


