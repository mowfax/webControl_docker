#!/bin/bash

##Define cleanup procedure
cleanup() {
    echo "Container stopped, performing cleanup..."
	
	#shutdown all running factorio instances gracefully
    killall factorio
    
    #save discord channel settings
    if [ -f /tmp/host/savedata.json ]; then
        cp /var/www/factorio/savedata.json /tmp/host/
    fi
	
    #copy logfiles from container to host if debugging is necessary
    mkdir /tmp/host/systemlog
    mkdir /tmp/host/factoriolog
    rm -rf /tmp/host/systemlog/*
    rm -rf /tmp/host/factoriolog/*
    cp -R /var/log/* /tmp/host/systemlog/
    cp -R /var/www/factorio/logs/* /tmp/host/factoriolog/
}

##Trap SIGTERM
trap cleanup SIGTERM

##Startup

#copy personal discord-bot information into container
cp /tmp/host/config.json /var/www/factorio/
if [ -f /tmp/host/savedata.json ]; then
        cp /tmp/host/savedata.json /var/www/factorio/
fi
chown -R www-data:www-data /var/www/factorio

#change default port range
mv /var/www/factorio/manage.sh /var/www/factorio/manage_org.sh
sed -e "s:3429:$PORT_PREFIX:" /var/www/factorio/manage_org.sh > /var/www/factorio/manage.sh

#change default password
a=$(echo -n $ADMINPASS | md5sum | awk '{ print $1 }')
echo "$ADMINUSER|$a|admin" > /var/www/users.txt;

#start apache2
service apache2 stop
rm -rf /var/run/apache2/apache2.pid
service apache2 start

##Wait
p=$(cat /var/run/apache2/apache2.pid)
wait $p

##Cleanup
cleanup
