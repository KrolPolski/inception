#!/bin/bash
set -e

# Wait for database
until mysql -h$WORDPRESS_DB_HOST -u$WORDPRESS_DB_USER -p$WORDPRESS_DB_PASSWORD -e "SELECT 1"; do
    echo "Waiting for MariaDB..."
    sleep 3
done

# WordPress installation
if [ ! -f wp-config.php ]; then
   php -d memory_limit=512M /usr/local/bin/wp core download --allow-root

    # Configure WordPress
    wp config create \
        --dbname=$WORDPRESS_DB_NAME \
        --dbuser=$WORDPRESS_DB_USER \
        --dbpass=$WORDPRESS_DB_PASSWORD \
        --dbhost=$WORDPRESS_DB_HOST \
        --allow-root

    # Install WordPress
    wp core install \
        --url=$WORDPRESS_URL \
        --title=$WORDPRESS_TITLE \
        --admin_user=$WORDPRESS_ADMIN_USER \
        --admin_password=$WORDPRESS_ADMIN_PASSWORD \
        --admin_email=$WORDPRESS_ADMIN_EMAIL \
        --allow-root
    # Add editor user
    wp user create $WORDPRESS_EDITOR_USER \
	    $WORDPRESS_EDITOR_EMAIL \
	    --role=editor \
	    --user_pass=$WORDPRESS_EDITOR_PASSWORD
fi

exec "$@"
