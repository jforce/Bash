#!/usr/bin/env bash

URL="http://cups3.radiopopular.pt:631/printers/?ORDER=asc&QUERY=%2FP1&x=18&y=13"
wget -O - "${URL}" > PAGE1.HTML
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/P1&FIRST=10&ORDER=asc"
wget -O - "${URL}" > PAGE2.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/P1&FIRST=20&ORDER=asc"
wget -O - "${URL}" > PAGE3.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/P1&FIRST=30&ORDER=asc"
wget -O - "${URL}" > PAGE4.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/P1&FIRST=40&ORDER=asc"
wget -O - "${URL}" > PAGE5.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/P1&FIRST=50&ORDER=asc"
wget -O - "${URL}" > PAGE6.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/P1&FIRST=60&ORDER=asc"
wget -O - "${URL}" > PAGE7.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/P1&FIRST=70&ORDER=asc"
wget -O - "${URL}" > PAGE8.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/P1&FIRST=80&ORDER=asc"
wget -O - "${URL}" > PAGE9.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/P1&FIRST=90&ORDER=asc"
wget -O - "${URL}" > PAGE10.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/P1&FIRST=100&ORDER=asc"
wget -O - "${URL}" > PAGE11.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/P1&FIRST=110&ORDER=asc"
wget -O - "${URL}" > PAGE12.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/P1&FIRST=120&ORDER=asc"
wget -O - "${URL}" > PAGE12.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/P1&FIRST=130&ORDER=asc"
wget -O - "${URL}" > PAGE13.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/P1&FIRST=140&ORDER=asc"
wget -O - "${URL}" > PAGE14.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/P1&FIRST=150&ORDER=asc"
wget -O - "${URL}" > PAGE15.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/P1&FIRST=160&ORDER=asc"
wget -O - "${URL}" > PAGE16.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/P1&FIRST=170&ORDER=asc"
wget -O - "${URL}" > PAGE17.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/P1&FIRST=180&ORDER=asc"
wget -O - "${URL}" > PAGE18.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/P1&FIRST=190&ORDER=asc"
wget -O - "${URL}" > PAGE19.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?ORDER=asc&QUERY=%2FS1&x=18&y=13"
wget -O - "${URL}" > PAGE20.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/S1&FIRST=10&ORDER=asc"
wget -O - "${URL}" > PAGE21.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/S1&FIRST=20&ORDER=asc"
wget -O - "${URL}" > PAGE22.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/S1&FIRST=30&ORDER=asc"
wget -O - "${URL}" > PAGE23.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/S1&FIRST=40&ORDER=asc"
wget -O - "${URL}" > PAGE24.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/S1&FIRST=50&ORDER=asc"
wget -O - "${URL}" > PAGE25.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/S1&FIRST=60&ORDER=asc"
wget -O - "${URL}" > PAGE26.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/S1&FIRST=70&ORDER=asc"
wget -O - "${URL}" > PAGE27.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/S1&FIRST=80&ORDER=asc"
wget -O - "${URL}" > PAGE28.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/S1&FIRST=90&ORDER=asc"
wget -O - "${URL}" > PAGE29.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/S1&FIRST=100&ORDER=asc"
wget -O - "${URL}" > PAGE30.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/S1&FIRST=110&ORDER=asc"
wget -O - "${URL}" > PAGE31.HTML 2> /dev/null
URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/S1&FIRST=120&ORDER=asc"
wget -O - "${URL}" > PAGE32.HTML 2> /dev/null
#URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/S1&FIRST=130&ORDER=asc"
#wget -O - "${URL}" > PAGE33.HTML 2> /dev/null
#URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/S1&FIRST=140&ORDER=asc"
#wget -O - "${URL}" > PAGE34.HTML 2> /dev/null
#URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/S1&FIRST=150&ORDER=asc"
#wget -O - "${URL}" > PAGE35.HTML 2> /dev/null
#URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/S1&FIRST=160&ORDER=asc"
#wget -O - "${URL}" > PAGE36.HTML 2> /dev/null
#URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/S1&FIRST=170&ORDER=asc"
#wget -O - "${URL}" > PAGE37.HTML 2> /dev/null
#URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/S1&FIRST=180&ORDER=asc"
#wget -O - "${URL}" > PAGE38.HTML 2> /dev/null
#URL="http://cups3.radiopopular.pt:631/printers/?QUERY=/S1&FIRST=190&ORDER=asc"
#wget -O - "${URL}" > PAGE39.HTML 2> /dev/null

OLD_IFS="${IFS}"
IFS=$'\n'
ARRAY=(`ls -t PAGE*`)
echo "local;protocolo;IP;porta;axel" > lista.csv
for p in ${ARRAY[*]}; do
	file="$p"	
	locarray=(`cat $file | grep "Location"`)
	devarray=(`cat $file | grep "Device URI"`)
	n=${#locarray[@]}
	for (( i=0; i<n; i++ ))
	do
		COMB[$i]=${locarray[$i]}";"${devarray[$i]}
		COMB2=(`echo ${COMB[$i]} | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | sed -e 's/Location: //g;s/Device URI: //g;s/:\/\//;/g;s/\/P/;P/g;s/\/S/;S/g;s/\/s/;s/g;s/\/p/;p/g'`)
		IP=(`echo $COMB2 | awk -F';' '{print $3}'`)
		ping -c 1 -W 2 $IP > /dev/null # Testa o IP
		if [ "$?" -ne 0 ]; then
			echo "$COMB2;Off" >> lista.csv
		else
			AXEL=(`exec 3>/dev/tcp/$IP/514; echo $?`) # Testa a porta 514
			#AXEL=(`nc -z $IP 514; echo $?`) # Testa a porta 514
				if [ "$AXEL" -ne 1 ]; then
				echo "$COMB2;Sim" >> lista.csv
				else
				echo "$COMB2;Não" >> lista.csv
				fi
		fi
	done
done	

IFS="${OLD_IFS}"
