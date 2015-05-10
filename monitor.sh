#!/bin/bash
# j.francisco.o.rocha@gmail.com
# @09.2012
# ./monitor.sh

tm=25

dirDestMsg="/usr1/sms"
dirDestDat="/home9/frocha/software"
dirDestLog="/home9/frocha/software"

#dirDestMsg="."
#dirDestDat="."
#dirDestLog="."

numeroDest01="916644665"
numeroDest02="912256928"
numeroDest03="919402942"
#   1 ano
timeLog=17520
# 1/2 ano
#timeLog=8760
# 1 mes
#timeLog=1440

function status () {
	if [ -e "$dirDestDat"/monitor.dat ]; then
	. "$dirDestDat"/monitor.dat
	else
	echo "STATUS=Normal" > "$dirDestDat"/monitor.dat
	fi
	}

function tempF () {
	# Temperatura em ºF
	tf=`curl -u apc:radiopopular --silent http://apc:radiopopular@172.16.91.15/pages/status.html | grep "0_TEMP" | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | sed -e 's/ &#176;F//g'`
	}

function tempC () {
	# Temperatura em ºC
	tc=$(echo "scale=2;($tf-32)*5/9" | bc -l)
	}

function tempo () {
	# ht hora da teresa
	ht=`date +%H:%M`
	# h hora real
	h=`date --date='+1 hour' +%H:%M`
	# hl hora limite
	hl=`date --date='+2 hour' +%H:%M`
	# data real
	d=`date +%Y-%m-%d`
	# data amanha
	da=`date -d 'tomorrow' +%Y-%m-%d`
	# data ontem
	do=`date -d 'yesterday' +%Y-%m-%d`
	}

function mensagem () {
	dm=$(echo $d | sed -e 's/-//g')
	hm=$(echo $h | sed -e 's/://g')
	if [[ $1 != "" ]]; then
		echo "Source: COBOL" > "$dirDestMsg/$1.$dm.$hm".msg
		echo "Data-int: $d $da" >> "$dirDestMsg/$1.$dm.$hm".msg
		echo "Hora-int: $ht $hl" >> "$dirDestMsg/$1.$dm.$hm".msg
		echo "To: $1" >> "$dirDestMsg/$1.$dm.$hm".msg
		echo "Mensagem:" >> "$dirDestMsg/$1.$dm.$hm".msg
		echo "TMax=$tmºC" >> "$dirDestMsg/$1.$dm.$hm".msg
		echo "TActual=$tcºC" >> "$dirDestMsg/$1.$dm.$hm".msg
		echo "Data=$d" >> "$dirDestMsg/$1.$dm.$hm".msg
		echo "Hora=$h" >> "$dirDestMsg/$1.$dm.$hm".msg
		echo "Status=$STATUS" >> "$dirDestMsg/$1.$dm.$hm".msg
	fi
	}

function log () {
	numLog=0
	if [ -e "$dirDestLog"/monitor.log ]; then
		numLog=$(cat "$dirDestLog"/monitor.log | wc -l)
	fi
	if [ $numLog -ge $timeLog ]; then
		sed -i '1d' "$dirDestLog"/monitor.log
	fi
	echo "$d;$h;$tm;$tc" >> "$dirDestLog"/monitor.log
	}

function processarEnvio () {
	if (( $(echo "$tc >= $tm" | bc -l) )) ; then
		if [[ "$STATUS" == "Normal" ]]; then
			echo "STATUS=Aviso1" > "$dirDestDat"/monitor.dat
			STATUS=Aviso1
			mensagem $numeroDest01
			mensagem $numeroDest02
			mensagem $numeroDest03
			exit 0
		fi
		if [[ "$STATUS" == "Aviso1" ]]; then
			echo "STATUS=Aviso2" > "$dirDestDat"/monitor.dat
			STATUS=Aviso2
			mensagem $numeroDest01
			mensagem $numeroDest02
			mensagem $numeroDest03
			exit 0
		fi
		if [[ "$STATUS" == "Aviso2" ]]; then
			echo "STATUS=Aviso3" > "$dirDestDat"/monitor.dat
			STATUS=Aviso3
			mensagem $numeroDest01
			mensagem $numeroDest02
			mensagem $numeroDest03
			exit 0
		fi
		if [[ "$STATUS" == "Aviso3" ]]; then
		exit 0
		fi
	else
		if [[ "$STATUS" == "Aviso1" ]]; then
			if (( $(echo "$tc <= $tm" | bc -l) )) ; then
			echo "STATUS=Normal" > "$dirDestDat"/monitor.dat
			STATUS=Normal
			mensagem $numeroDest01
			mensagem $numeroDest02
			mensagem $numeroDest03
			fi
		fi
		if [[ "$STATUS" == "Aviso2" ]]; then
			if (( $(echo "$tc <= $tm" | bc -l) )) ; then
			echo "STATUS=Normal" > "$dirDestDat"/monitor.dat
			STATUS=Normal
			mensagem $numeroDest01
			mensagem $numeroDest02
			mensagem $numeroDest03
			fi
		fi
		if [[ "$STATUS" == "Aviso3" ]]; then
			if (( $(echo "$tc <= $tm" | bc -l) )) ; then
			echo "STATUS=Normal" > "$dirDestDat"/monitor.dat
			STATUS=Normal
			mensagem $numeroDest01
			mensagem $numeroDest02
			mensagem $numeroDest03
			fi
		fi
		echo "STATUS=Normal" > "$dirDestDat"/monitor.dat
		STATUS=Normal
	fi
	}

tempF
tempC
tempo
status
processarEnvio
log
