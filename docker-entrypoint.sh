#!/bin/sh -x

set -e

cp /tmp/host/config.json /var/www/factorio/
chown -R www-data:www-data /var/www/factorio

service apache2 start

a=$(ps -A | grep apache2)

while [ "$a" ]; do
        sleep 1000;
        a=$(ps -A | grep apache2);
done
