#!/bin/bash
#autor j.francisco.o.rocha@gmail.com

rede=$1

if [[ $rede != "" ]]; then
	for (( i = 1; i <= 254; i++ ))
	do
	ip=$(ping -c 1 -v  192.168.$rede.$i | grep ttl | cut -d" " -f4 | sed -e 's/://g')
		if [[ $ip != "" ]]; then
#		arp-scan $ip | grep 192
#		arp-fingerprint $ip | grep 192
		echo $ip on
		fi
	done
	read -p "Precione alguma tecla para continuar"
	else
	echo -e "Tem de indicar um valor entre 0 e 256\npara identificar a rede que vai ser testada"
fi
