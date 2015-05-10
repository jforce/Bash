#!/bin/bash
#autor j.francisco.o.rocha@gmail.com
# xfreerdp -d XXX -p "xxxxx" -a 32 -x 0x80 -z --plugin cliprdr -g 1280x850 host

testXfreerdp=`which xfreerdp`
if [ "$testXfreerdp" != "" ] ; then
	address=$(zenity --title="New RDP Connection" --entry --text="RDP Server IP address:")
	xfreerdp $address
	exit 0
	else
	echo "Porfavor instale freerdp-x11."
fi

testRdesktop=`which rdesktop`
if [ "$testRdesktop" != "" ] ; then
	address=$(zenity --title="New RDP Connection" --entry --text="RDP Server IP address:")
	rdesktop $address
	exit 0
	else
	echo "Porfavor instale rdesktop."
fi
