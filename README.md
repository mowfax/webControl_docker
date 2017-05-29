# webControl_docker
dockerized version of 3Ra webControl for factorio:
https://github.com/3RaGaming/Web_Control

## Install premade examples:

If you don't have curl installed, do it now:
`apt-get install -y curl`

Then run:
`bash <(curl -s https://raw.githubusercontent.com/mowfax/webControl_docker/master/examples/examples.sh)`

Now you get asked if you want to run a single or multi instances of webcontrol.

## Single instance example:

Answer `s` at the prompt.

This will unpack the folder `/srv/webcontrol/`

`run-webcontrol.sh` - contains the run-command that you should configure to your liking. (ToDo: Explain run-command parameters)

`rm-webcontrol.sh` - is an easy way to stop and delete your container, should you want to execute the run command again.

`/config/config.json` - this file is vital! You HAVE to fill it with your discord-bot information. Otherwise, the container will exit immediately. Please refer to [this guide](http://3ragaming.com/faq/web_control/) on how to setup your discord-bot.

ToDo: explaining server1 server2

## Multi instance example:

Answer `m` at the prompt.

This will unpack the folders `/srv/webcontrol/` and `/srv/nginx-proxy/`

### Part1 - starting the reverse proxy

First, inside the `nginx-proxy`folder, you have to execute `./run-nginx-proxy.sh`

Second, start `./run-letsencrypt.sh`

Before going further, inspect the letsencrypt container multiple times until the initial creation of diffie hellman files is finished:
`docker logs letsencrypt`

Now you have a flexible reverse proxy infrastructure that is configured directly in the run-command of your container and gets SSL certificates automatically from [Let's Encrypt](https://letsencrypt.org/)

### Part2 - starting the webcontrol instances

Inside the `webcontrol`folder, all files and folders have an instance indicator `A` or `B`. For ease of explanation, I only refer to one instance here.

The only exception is `rm-webcontrol.sh`. This script is an easy way to stop and delete both your instance containers, should you want to execute the run commands on your instances again.

`run-webcontrol.sh` - contains the run-command that you should configure to your liking. (ToDo: Explain run-command parameters)

`/configA/config.json` - this file is vital! You HAVE to fill it with your discord-bot information. Otherwise, the container will exit immediately. Please refer to [this guide](http://3ragaming.com/faq/web_control/) on how to setup your discord-bot.

ToDo: explaining serverA1 serverA2 serverB1 serverB2

## Simple example of docker run command:

docker run -d -p 443:443/tcp -p 34290-34299:34290-34299/udp -v /srv/webControl/config/:/tmp/host -v /srv/webControl/server1/:/var/www/factorio/server1 --restart unless-stopped --name webcontrol mowfax/factoriowebcontrol:latest

Notes:
1) The Factorio Serverport corresponds with the ServerID (i.e. server1 = 34291, server2 = 34292 etc.)

2) You should place your own config.json in the folder that you link into /tmp/host because it gets copied to the right place when the container spins up. If there is no config.json, the container will immediately exit.

3) The second volume is an example if you want to permanently save one or more of your server-folders outside of the container. This way you can scrap your container without losing your factorio servers. For example server-folders, see the example archives above.

4) --restart unless-stopped will restart your container in case the apache2 service crashes
