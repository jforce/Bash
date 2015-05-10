#!/bin/sh
date=`date`

if [ "$(id -u)" != "0" ]; then
	clear
	echo $date "Este Script só pode ser invocado com o Sudo ou pelo utilizador root."
    echo $date "Este Script só pode ser invocado com o Sudo ou pelo utilizador root." >> /var/log/memoria.log
	exit 1
fi



PATH="/bin:/usr/bin:/usr/local/bin"


percent=50

#Memoria Total
ramtotal=`grep -F "MemTotal:" < /proc/meminfo | awk '{print $2}'`
# Memoria livre:
ramlivre=`grep -F "MemFree:" < /proc/meminfo | awk '{print $2}'`

# RAM utilizada pelo sistema:
ramusada=`expr $ramtotal - $ramlivre`

# Percentagem de RAM utilizada pelo sistema:
putil=`expr $ramusada \* 100 / $ramtotal`

echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
date
echo
echo "Mem. utilizada: $putil %";

if [ $putil -gt $percent ]
then
   echo $date >> /var/log/memoria.log
   echo "Mem. utilizada: $putil %" >> /var/log/memoria.log

   echo "Memoria acima de $percent %, cache foi limpa!";
   sync
   # 'Limpando' cache:
   echo 3 > /proc/sys/vm/drop_caches
   echo
    free -m
   echo
echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
else
    echo "Cache nao foi limpa!";
echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    unset percent ramtotal ramlivre ramusada putil
    exit $?
fi
