#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
    source .env
else
    echo "Error: .env file not found. Please create the .env file with necessary variables."
    exit 1
fi

# Change directory to WordPress installation path
cd /var/www/wordpress

# Sleep for 5 seconds
sleep 5

# Check if wp-config.php file exists
if [ -f ./wp-config.php ]; then
    echo "Config already exists"
else
    # Create wp-config.php file
    wp config create --allow-root \
        --dbname=$SQL_DB \
        --dbuser=$SQL_USR \
        --dbpass=$SQL_PWD \
        --dbhost=$SQL_HOSTNAME:3306 --path='/var/www/wordpress'
fi

# Remove object-cache.php if BONUS is not set
if [ -z $BONUS ] && [ -f wp-content/object-cache.php ]; then
    rm -rf wp-content/object-cache.php
fi

# Check if WordPress is already installed
if wp core is-installed --url=$DOMAIN_NAME --allow-root; then
    echo "WordPress already installed"
else
    # Install WordPress
    wp core install --url=$DOMAIN_NAME/ \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USR \
        --admin_password=$WP_ADMIN_PWD \
        --admin_email=$WP_ADMIN_EMAIL \
        --skip-email --allow-root

    # Create additional user and activate Astra theme
    wp user create $WP_USR $WP_EMAIL --role=author --user_pass=$WP_PWD --allow-root
    wp theme install astra --activate --allow-root
fi

# Configure Redis caching if BONUS is set
if [ ! -z $BONUS ]; then
    if ! wp plugin is-installed redis-cache --allow-root; then
        echo "Bonus enabled but not installed"
        
        # Configure Redis settings
        wp config set WP_REDIS_HOST redis --allow-root
        wp config set WP_REDIS_PORT 6379 --raw --allow-root
        wp config set WP_CACHE_KEY_SALT $DOMAIN_NAME --allow-root

        # Install and activate Redis cache plugin
        wp plugin install redis-cache --activate --allow-root
        wp plugin update --all --allow-root
        wp redis enable --allow-root
    elif [ ! -f wp-content/object-cache.php ]; then
        wp redis enable --allow-root
    fi
fi

# Adjust PHP-FPM configuration
sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 9000/g' /etc/php/8.2/fpm/pool.d/www.conf
sed -i 's/;clear_env = no/clear_env = no/g' /etc/php/8.2/fpm/pool.d/www.conf

# Start PHP-FPM
/usr/sbin/php-fpm8.2 -F

