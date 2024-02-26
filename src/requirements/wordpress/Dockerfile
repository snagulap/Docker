# syntax=docker/dockerfile:1
FROM debian:buster

# Install dependencies
RUN apt-get update -y && \
    apt-get -y install php7.3 php-fpm php-mysql curl mariadb-client
    

# Expose port 9000
EXPOSE 9000

# Install WordPress
RUN mkdir -p /var/www/wordpress && cd /var/www/wordpress && \
    curl -O https://wordpress.org/latest.tar.gz && \
    tar -xzvf latest.tar.gz -C /var/www && \
    rm latest.tar.gz

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY wp-config.php /var/www/wordpress
RUN chmod 644 /var/www/wordpress/wp-config.php
RUN chown www-data:www-data /var/www/wordpress/wp-config.php


# Change ownership of the WordPress directory
# RUN chown -R www-data:www-data /var/www/wordpress

# Copy wp-config.php and script.sh
# COPY wp-config.php /var/www/wordpress
COPY /conf/www.conf /etc/php/7.3/fpm/pool.d
COPY script.sh /tmp

# Set execute permissions for script.sh
RUN chmod +x /tmp/script.sh

EXPOSE 9000
# Set the default command to run script.sh
CMD ["/tmp/script.sh"]



# syntax=docker/dockerfile:1
# FROM debian:buster

# RUN apt-get update -y && \
#     apt-get install -y php-mysql curl && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

# EXPOSE 9000

# RUN mkdir -p /var/www && \
#     curl -O https://wordpress.org/latest.tar.gz && \
#     tar -xzvf latest.tar.gz -C /var/www && \
#     rm latest.tar.gz

# RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
#     chmod +x wp-cli.phar && \
#     mv wp-cli.phar /usr/local/bin/wp

# RUN chown -R www-data:www-data /var/www/wordpress

# COPY wp-config.php /etc/php/pool.d
# COPY script.sh .

# RUN chmod +x script.sh

# CMD ["/script.sh"]





# FROM debian:buster

# RUN apt-get update -y && \
#     apt-get install -y php-mysql && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

# EXPOSE 9000

# RUN	mkdir -p /var/www
# RUN	curl -O https://wordpress.org/wordpress-6.4.2.tar.gz \
# 	&& tar -xzvf wordpress-6.4.2.tar.gz -C /var/www \
# 	&& rm wordpress-6.4.2.tar.gz

# RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# RUN chmod +x wp-cli.phar
# RUN mv wp-cli.phar /usr/local/bin/wp

# RUN	chown -R root:root /var/www/wordpress

# COPY ./wp-config.php /etc/php/pool.d
# COPY ./script.sh .

# RUN chmod +x script.sh

# CMD ["/script.sh"]
