#!/bin/sh
while true ; do
clear
echo "Dispositivo           Tam   Usad  Disp  U%  PontoMontagem"
df -h | grep dsk
echo ""
df -h | grep DISC
sleep 5
done
