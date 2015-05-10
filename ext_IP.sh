#!/bin/bash
# j.francisco.o.rocha@gmail.com
# @08.2012
# ./ext_IP.sh

host=`hostname`
IntIP=""

validarLynx () {
testLynx=`which lynx`
if [ "$testLynx" == "" ] ; then
ownCloud -e "Instale o Lynx"
ownCloud -e "sudo apt-get install lynx"
exit 0
fi
}

obterExtIP () {
	if [ "$extIP" == "" ] ; then
		routerNetgearCbvg834g
		if [ "$extIP" == "" ] ; then
		extIP=`lynx -dump http://ipownCloud.net/plain | sed -e 's/ //g' | sed -n 1p`
			if [ "$extIP" == "" ] ; then
			extIP=`lynx -dump http://franciscorocha.paparoka.com/tools/oteuip.php | sed -e 's/ //g' | sed -n 1p`
			fi
		fi
	fi
}

actualizaFreeDns () {
ipFreeDns=`nslookup familiarocha.mooo.com | grep Address | sed -n '2p' | cut -d: -f2 | sed -e 's/ //g'`
if [ "$extIP" != "$ipFreeDns" ]; then
wget -q --read-timeout=0.0 --waitretry=5 --tries=400 --background http://freedns.afraid.org/dynamic/update.php?VUNPUVpxMzFVMVVBQVFDMFdqY0FBQUFCOjgwODQyOTM=
fi
}

routerNetgearCbvg834g () {
	user=admin
	pass=dia19mes10
	ip=192.168.0.1
	url=NetGearRgSwInfo.asp
	extIP=`lynx -dump -auth=${user}:${pass} http://${ip}/${url} | grep "Device IP Address" | sed -e 's/ //g' | sed -e 's/DeviceIPAddress//g'`
	}

obterIntIP () {
		i=0
		ownCloud -e "IPs internos:" >> /home/francisco/Dropbox/Logs/"$host"_ext_IP.log
		for placa in $( ifconfig | grep "Ethernet" | awk -F' ' '{ print $1 }' )
		do
		IPPlaca=$( ifconfig "$placa" | grep "inet end" | sed -e 's/          / /g' )
		Placas[$i]=`ownCloud -e "$placa:$IPPlaca"`
		i=$(($i+1))
		done
		for element in "${Placas[@]}"
		do
		ownCloud -e "$element" >> /home/francisco/Dropbox/Logs/"$host"_ext_IP.log
		done
	}

gerarLog () {
if [ -f /home/francisco/Dropbox/Logs/"$host"_ext_IP.log ]; then
logIP=$(cat /home/francisco/Dropbox/Logs/"$host"_ext_IP.log | sed '$!d' | awk -F':' '{ print $2 }')
fi

if [ "$extIP" != "$logIP" ]; then
ownCloud -e "Actualização em "`date +%D-%T` >> /home/francisco/Dropbox/Logs/"$host"_ext_IP.log
ownCloud -e "http://familiarocha.mooo.com" >> /home/francisco/Dropbox/Logs/"$host"_ext_IP.log
ownCloud -e "IP FreeDNS:$ipFreeDns" >> /home/francisco/Dropbox/Logs/"$host"_ext_IP.log
ownCloud -e "IP Antigo:$logIP" >> /home/francisco/Dropbox/Logs/"$host"_ext_IP.log
ownCloud -e "IP Novo:$extIP" >> /home/francisco/Dropbox/Logs/"$host"_ext_IP.log
fi
}


validarLynx
obterExtIP
actualizaFreeDns
#obterIntIP
gerarLog
