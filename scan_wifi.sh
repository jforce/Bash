#!/bin/sh
#
# Este script foi escrito com intuito de capturar e logar rede Wifi
# desenvolvido por jaccon@xxxxxxxxx
#
# Thanks for Your network.

interface="wlan0"
log_dir="/var/log/airlog/"
logfile="$log_dir/scans.log"
date_log=`date +%H-%M-%S`

# start script

function cabecalho ()
{
tput clear
tput sgr0
setterm -foreground white
setterm -background red
echo "AirLog.NG developer by Jakin Skywalker"
tput sgr0
setterm -foreground blue
echo "**************************************"
tput sgr0
setterm -foreground white -bold on
echo "Start Log into: $date_log"
tput sgr0
echo ""
setterm -background blue
setterm -foreground white -bold on
read -p "==|| Para iniciar o scan pressione Enter ||=="
tput sgr0
}

function capture ()
{
while true
do
tput clear
#sleep 1
setterm -foreground white -bold on
echo "AirLog.NG status: searching...."
tput sgr0
setterm -foreground red
echo "################################"
tput sgr0
setterm -foreground white -bold on
echo "Horario da ocorrencia: `date +%H:%M:%S`"
tput sgr0
setterm -foreground red
echo "#################################"
tput sgr0
echo ""
setterm -foreground yellow -bold on
echo "Procurando por access points pela interface $interface"
echo ""
tput sgr0
if ( `iwlist $interface scanning` 2> /dev/null ) ;then
echo "Rede nao encontrada"
else
tput bel
setterm -foreground white -bold on
echo "Rede WiFi encontrada"
tput sgr0
setterm -foreground green -bold on
tail -n 10 /var/log/airlog/scans.log
tput sgr0
sleep 2
echo "Para finalizar tecle CTRL+c"
iwlist $interface scanning >> /var/log/airlog/scans.log
fi
done
}

cabecalho
capture
