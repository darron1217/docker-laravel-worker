#!/bin/bash

# Display PHP error's or not
if [[ "$ERRORS" != "1" ]] ; then
 echo display_errors = Off >> /etc/php7/conf.d/php.ini
else
 echo display_errors = On >> /etc/php7/conf.d/php.ini
fi

# Increase the memory_limit
if [ ! -z "$PHP_MEM_LIMIT" ]; then
 sed -i "s/memory_limit = 128M/memory_limit = ${PHP_MEM_LIMIT}M/g" /etc/php7/conf.d/php.ini
fi

# Increase the post_max_size
if [ ! -z "$PHP_POST_MAX_SIZE" ]; then
 sed -i "s/post_max_size = 100M/post_max_size = ${PHP_POST_MAX_SIZE}M/g" /etc/php7/conf.d/php.ini
fi

# Increase the upload_max_filesize
if [ ! -z "$PHP_UPLOAD_MAX_FILESIZE" ]; then
 sed -i "s/upload_max_filesize = 100M/upload_max_filesize= ${PHP_UPLOAD_MAX_FILESIZE}M/g" /etc/php7/conf.d/php.ini
fi

# Set Timezone
if [ ! -z "$TIMEZONE" ]; then
 cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
fi

# Add Cronjob
if [ ! -z "$CRONJOB" ]; then
 crontab -l | { cat; echo "${CRONJOB}"; } | crontab -
fi

# Start supervisord and services
/usr/bin/supervisord -n -c /etc/supervisord.conf
