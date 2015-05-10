#!/bin/bash

wget=`which wget`
if [ "$wget" = "" ] ; then
	echo "Porfavor instale wget";
	exit 0
fi
wget http://www.teamviewer.com/download/teamviewer_linux.deb
sudo dpkg -i teamviewer_linux.deb
rm teamviewer_linux.deb
