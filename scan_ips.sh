#!/bin/bash
#autor j.francisco.o.rocha@gmail.com
# 2013/10

rede=$1
interface=$2
count=0

function ajuda () {
	echo "./scan_ips.sh [rede] [interface]"
	}

function ipProgress () {
if [ $count -le 30 ]; then
	echo -n -e "\r### Teste ao 192.168.$rede.$i"
	count=`expr $count + 1`
else
count=0
fi
}

function testPort () {
    local porta=${1}
    if nc -w 5 -z $ip $1 2>/dev/null
    then
    echo -e "Porta ${porta} aberta"
    fi
}

function runTeste () {
if [[ $rede != "" ]]; then
	for (( i = 1; i <= 254; i++ ));	do
	ip=$(ping -c 1 -v -w1 192.168.$rede.$i | grep ttl | cut -d" " -f4 | sed -e 's/://g')
		if [[ $ip != "" ]]; then
		tput civis # hide cursor
		ipProgress
		tput cnorm # unhide cursor
		echo " "
		arping -I $interface -c 1 $ip
		arp-scan --interface=$interface $ip | grep 192
		arp-fingerprint -o  "-I $interface" $ip | grep 192
		# PCs
		testPort 22
		# Axel
		testPort 514
		testPort 515
		# TPA
		testPort 11003
		# Windows
		testPort 135
		testPort 139
		testPort 445
		testPort 3389
		# VNC
		testPort 5900
		# Telefones / APs
		testPort 80
		else
		tput civis # hide cursor
		ipProgress
		fi
		tput cnorm # unhide cursor
	done
	echo -e "\n"
else
	ajuda
fi
}

function validacao () {
if [ "$(id -u)" != "0" ]; then
	echo "Tem de executar este script como Super User!"
	ajuda
	exit 0
fi

if [[ ! -e $(which arp-scan) ]]; then
sudo apt-get --yes install arp-scan
fi

if [ $rede -ge 0 -a $rede -le 256 ]; then
	echo A rede a testar é $rede
else
	echo A rede $rede não é válida
	ajuda
	exit 0
fi

if [[ "$interface" == eth* ]] || [[ "$interface" == wlan* ]] ;
then
    echo A interface é $interface
    else
    echo A interface $interface não é valida
    ajuda
    exit 0
fi
}

validacao
runTeste
