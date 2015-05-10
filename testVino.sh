#!/bin/bash
# ./testVino.sh
# j.francisco.o.rocha@gmail.com
# 08/2012

# Verifica se o vino-server esta a correr
testVino=`ps -A | grep vino-server`

# Se o vino server nao estiver a correr chama o vino-server
if [ "$testVino" == "" ] ; then
/usr/lib/vino/vino-server
fi
