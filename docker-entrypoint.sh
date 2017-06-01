#!/bin/sh -x

set -e

#copy personal discord-bot information into container
cp /tmp/host/config.json /var/www/factorio/
cp /tmp/host/savedata.json /var/www/factorio/
chown -R www-data:www-data /var/www/factorio

#change default port range
mv /var/www/factorio/manage.sh /var/www/factorio/manage_org.sh
sed -e "s:3429:$PORT_PREFIX:" /var/www/factorio/manage_org.sh > /var/www/factorio/manage.sh

#change default password
a=$(echo -n $ADMINPASS | md5sum | awk '{ print $1 }')
echo "$ADMINUSER|$a|admin" > /var/www/users.txt;

#start apache service and get its process line
service apache2 start
a=$(ps -A | grep apache2)

#keep container running as long as apache2 is running
while [ "$a" ]; do
        sleep 1000;
        a=$(ps -A | grep apache2);
done

#shutdown all running factorio instances gracefully
killall factorio

#save discord channel settings
cp /var/www/factorio/savedata.json /tmp/host/

#copy logfiles from container to host if debugging is necessary
mkdir /tmp/host/systemlog
mkdir /tmp/host/factoriolog
rm -rf /tmp/host/systemlog/*
rm -rf /tmp/host/factoriolog/*
cp -R /var/log/* /tmp/host/systemlog/
cp -R /var/www/factorio/logs/* /tmp/host/factoriolog/
