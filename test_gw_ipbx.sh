#!/bin/bash
#autor j.francisco.o.rocha@gmail.com


for (( i = 1; i <= 254; i++ ))
	do
	ping -c 1 -v  192.168.$i.254 | grep ttl | cut -d" " -f4 | sed -e 's/://g'
	ping -c 1 -v  192.168.$i.253 | grep ttl | cut -d" " -f4 | sed -e 's/://g'
done
read -p "Precione alguma tecla para continuar"
