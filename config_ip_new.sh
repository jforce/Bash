#!/usr/bin/env bash
# j.francisco.o.rocha@gmail.com


function dhcp () {
echo -e "# This file describes the network interfaces available on your system" > /etc/network/interfaces
echo -e "# and how to activate them. For more information, see interfaces(5)." >> /etc/network/interfaces
echo -e "" >> /etc/network/interfaces
echo -e "# The loopback network interface" >> /etc/network/interfaces
echo -e "auto lo" >> /etc/network/interfaces
echo -e "iface lo inet loopback" >> /etc/network/interfaces
echo -e "" >> /etc/network/interfaces
echo -e "# The primary network interface" >> /etc/network/interfaces
echo -e "auto eth0" >> /etc/network/interfaces
echo -e "iface eth0 inet dhcp" >> /etc/network/interfaces
echo -e "IP dinamico configurado (DHCP)"
sudo service networking restart
}

function ipfixo () {
REDE=`ip addr | grep inet | grep eth0 | sed -e 's/\/.*$//g' | awk '{ print $2 }' | awk -F '.' '{ print $3}'`
if [ $1 != "" ]; then
REDE=$1
fi
read -p "Indique o IP pretendido na mascara 192.168.$REDE.XXX: " IP
echo -e "# This file describes the network interfaces available on your system" > /etc/network/interfaces
echo -e "# and how to activate them. For more information, see interfaces(5)." >> /etc/network/interfaces
echo -e "" >> /etc/network/interfaces
echo -e "# The loopback network interface" >> /etc/network/interfaces
echo -e "auto lo" >> /etc/network/interfaces
echo -e "iface lo inet loopback" >> /etc/network/interfaces
echo -e "" >> /etc/network/interfaces
echo -e "# The primary network interface" >> /etc/network/interfaces
echo -e "auto eth0" >> /etc/network/interfaces
echo -e "iface eth0 inet static" >> /etc/network/interfaces
echo -e "address 192.168.$REDE.$IP" >> /etc/network/interfaces
echo -e "netmask 255.255.255.0" >> /etc/network/interfaces
echo -e "network 192.168.$REDE.0" >> /etc/network/interfaces
echo -e "broadcast 192.168.$REDE.255" >> /etc/network/interfaces
echo -e "gateway 192.168.$REDE.254" >> /etc/network/interfaces
echo -e "IP fixo 192.168.$REDE.$IP configurado"
sudo service networking restart
}

function ipmanual () {
read -p "Indique o IP do Modem (XXX.XXX.XXX.XXX): " GW
read -p "Indique o IP para o pc (XXX.XXX.XXX.XXX): " IP
read -p "Indique o IP para mascara rede (255.255.255.XXX): " MASK
read -p "Indique o IP para network (XXX.XXX.XXX.0): " NET
read -p "Indique o IP para broadcast (XXX.XXX.XXX.255): " BRC
echo -e "# This file describes the network interfaces available on your system" > /etc/network/interfaces
echo -e "# and how to activate them. For more information, see interfaces(5)." >> /etc/network/interfaces
echo -e "" >> /etc/network/interfaces
echo -e "# The loopback network interface" >> /etc/network/interfaces
echo -e "auto lo" >> /etc/network/interfaces
echo -e "iface lo inet loopback" >> /etc/network/interfaces
echo -e "" >> /etc/network/interfaces
echo -e "# The primary network interface" >> /etc/network/interfaces
echo -e "auto eth0" >> /etc/network/interfaces
echo -e "iface eth0 inet static" >> /etc/network/interfaces
echo -e "address $IP" >> /etc/network/interfaces
echo -e "netmask $MASK" >> /etc/network/interfaces
echo -e "network $NET" >> /etc/network/interfaces
echo -e "broadcast $BRC" >> /etc/network/interfaces
echo -e "gateway $GW" >> /etc/network/interfaces
sudo service networking restart
}

if [ "$1" == M ] || [ "$1" == m ]; then
	ipmanual
	exit 0
fi

if [ "$1" == F ] || [ "$1" == f ]; then
ipfixo $2
else
	if [ "$1" == D ] || [ "$1" == d ]; then
	dhcp
	else
	echo "Formato:"
	echo "$0 [d|D] - Activa DHCP"
	echo "$0 [f|F] [rede] - Activa IP Fixo na rede indicada ou na rede actual"
	echo "$0 [m|M] - Activa IP Manual na interface eth0"
	fi
fi
