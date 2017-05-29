#!/bin/bash

while true; do
	read -p "Do you want to run a single or multiple webcontrol instances? [s/m] " sm
	case $sm in
		[Ss]* ) curl -o /srv/example-single.tar.gz https://raw.githubusercontent.com/mowfax/webControl_docker/master/examples/example-single.tar.gz;
            tar -xvf /srv/example-single.tar.gz -C /srv/;
            break;
            ;
		[Mm]* )curl -o /srv/example-multi.tar.gz https://raw.githubusercontent.com/mowfax/webControl_docker/master/examples/example-multi.tar.gz;
            tar -xvf /srv/example-multi.tar.gz -C /srv/;
            break;
            ;
		* ) echo "Please answer single[S] or multiple[M].";;
	esac
done
