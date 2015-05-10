#!/bin/bash
# j.francisco.o.rocha@gmail.com
# @09.2012
# ./smsTest.sh

dirDestMsg="/usr1/sms"

#dirDestMsg="."
#dirDestDat="."
#dirDestLog="."

numeroDest01="916644665"
numeroDest02="912256928"
numeroDest03="919402942"


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
		echo "Se esta a ler este" >> "$dirDestMsg/$1.$dm.$hm".msg
		echo "SMS significa que" >> "$dirDestMsg/$1.$dm.$hm".msg
		echo "o envio de SMS tem:" >> "$dirDestMsg/$1.$dm.$hm".msg
		echo "Status=OK" >> "$dirDestMsg/$1.$dm.$hm".msg
		echo "Data=$d" >> "$dirDestMsg/$1.$dm.$hm".msg
		echo "Hora=$h" >> "$dirDestMsg/$1.$dm.$hm".msg

	fi
	}


tempo
mensagem $numeroDest01
