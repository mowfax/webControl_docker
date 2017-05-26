# webControl_docker
dockerized version of 3Ra webControl for factorio:
https://github.com/3RaGaming/Web_Control

Example of docker run command:

docker run -d -p 443:443/tcp -p 34290-34299:34290-34299/udp -v /srv/webControl/:/tmp/host -v /srv/webControl/server2/:/var/www/factorio/server2 --name webControl mowfax/factoriowebcontrol:latest

Notes:
The Factorio Serverport corresponds with the ServerID (i.e. server1 = 34291, server2 = 34292 etc.)
You should place your own config.json in the folder that you link into /tmp/host because it gets copied to the right place when the container spins up.
The second volume is an example if you want to permanently save one or more of your server-folders outside of the container. This way you can scrap your container without losing your factorio servers.

At the moment, you would have to go into the container and copy the server1 example folder, but I want to implement some sort of populating an empty folder that you link.

Example:
docker exec -it CONTAINERNAME /bin/bash
cp -R /var/www/factorio/server1 /var/www/factorio/server2
