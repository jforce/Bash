#!/usr/bin/env bash
#------------------------------------------
# j.francisco.o.rocha@gmail.com
# arrumaPhotos2.sh
# 08/2011
#------------------------------------------

declare IFS=$'\n'


function progressSpin () {
	chars=( "-" "\\" "|" "/" )
	interval=.05
	count=0
	while [ $count -le 4 ]
	do
		pos=$(($count % 4))
		echo -en "\b${chars[$pos]}"
		count=$(($count + 1))
		sleep $interval
	done
}

function progressBarPerc () {
	MAX=$1
	PERCENT=0
	FOO=">"
	BAR=""
	while [ $PERCENT -lt $(($MAX+1)) ]
	do
		echo -ne "\r\t[ "
		echo -ne "$BAR$FOO ] $((PERCENT*100/$MAX))% "
		BAR="${BAR}="
		let PERCENT=$PERCENT+1
		sleep 0.05
	done
}

function progressBar2 () {
	count=0
	BAR=""
	until [ $count -eq 5 ]
	do
		echo -n -e "\r[      ]"
		echo -n -e "\r[ "
		echo -n -e "$BAR"
		BAR="${BAR}>"
		sleep 0.03
		count=`expr $count + 1`
	done
	echo -n -e " ]"
	}

function progressBar () {
	count=0
	BAR=""
	until [ $count -eq 10 ]
	do
		echo -n -e "\r[            ]"
		echo -n -e "\r[ "
		echo -n -e "$BAR▌"
		BAR="${BAR}▌"
		sleep 0.02
		count=`expr $count + 1`
	done
#	echo -n -e "\r[            ]"
	sleep 0.05
	}


for i in `seq 1 25`; do
sleep 1
#echo -e -n "."
#spin
#barra 20
tput civis # hide cursor
progressBar
done
tput cnorm # unhide cursor
