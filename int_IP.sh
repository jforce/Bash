#!/bin/bash
# j.francisco.o.rocha@gmail.com
# @11.2013
# ./intIP.sh

host=`hostname`
IntIP=""

validarLynx () {
testLynx=`which lynx`
if [ "$testLynx" == "" ] ; then
echo -e "Instale o Lynx"
echo -e "sudo apt-get install lynx"
exit 0
fi
}

function emailSend () {
        mutt -s "IP de $host mudou" -F $HOME/.mutt/mutt_r -- franciscorocha@radiopopular.pt <<EOF
Actualização em `date +%D-%T`
IP Antigo:$logIP
IP Novo:$intIP
EOF
    }

obterIntIP () {
        intIP=$(ifconfig eth0 | sed -e 's/Bcast/\nBcast/g;s/ //g'| grep "inetend" | awk -F: '{ print $2 }')
        }

gerarLog () {
if [ ! -f $HOME/"$host"_int_IP.log ]; then
> $HOME/"$host"_int_IP.log
fi

logIP=$(cat $HOME/"$host"_int_IP.log | sed '$!d')
echo $logIP
echo $intIP

if [ "$intIP" != "$logIP" ]; then
echo -e "Actualização em "`date +%D-%T` >> $HOME/"$host"_int_IP.log
echo -e "$intIP" >> $HOME/"$host"_int_IP.log
emailSend
fi
}


validarLynx
obterIntIP
gerarLog
