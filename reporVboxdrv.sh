#! /bin/bash
#! autor: j.francisco.o.rocha@gmail.com
#! 2008
if [ "$(id -u)" != "0" ]; then
	clear
	echo "Este Script só pode ser invocado com o Sudo ou pelo utilizador root."
	exit 1
fi
sudo /etc/init.d/vboxdrv setup

