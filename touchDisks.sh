#!/bin/bash
dirDiscos="/media/DISC*"
function ciclo () {
for (( i = 1; i <= 254; i++ ))
	do
	find -L $dirDiscos -mindepth 1 -maxdepth 5 -type f -name *$1* | grep VIDEO_TS | sed -e '/OsMeusFilmesInfantis/ d' | sed -e '/movie-trailer/ d'
#	ping -c 1 -v  192.168.59.$i | grep ttl | cut -d" " -f4 | sed -e 's/://g'
	echo -n -e "."
done
}

ciclo $1

#for (( i = 1; i <= 254; i++ ))
	#do ping -c 1 -v  192.168.1.$i | grep ttl | cut -d" " -f4 | sed -e 's/://g'
#done
#for (( i = 1; i <= 254; i++ ))
#	do ping -c 1 -v  192.168.2.$i | grep ttl | cut -d" " -f4 | sed -e 's/://g'
#done
read -p "Precione alguma tecla para continuar"
