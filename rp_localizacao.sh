#!/bin/bash
# j.francisco.o.rocha@gmail.com
# @12.2013

#origem=/Control-Panel/Scripts
origem=./

function requisitos () {
	if [ "$(id -u)" != "0" ]; then
		echo "Tem de executar este script como Super User!"
		exit 0
	fi
	if [[ ! -e $origem/rp_localizacao.dat ]]; then
		echo "O ficheiro rp_localizacao.dat não foi encontrado na pasta $origemgthumb gpicview."
		exit 0
	fi
	if [[ ! -e $(which dialog) ]]; then
		apt-get --yes install dialog
	fi
	}
	
function gravarDados () {
	if [[ ! -e $origem/hostname.log ]]; then
		echo "" > $origem/hostname.log
	fi
	sed -i '/Identificação/d' $origem/hostname.log
	sed -i '/^$/d' $origem/hostname.log
	echo " " >> $origem/hostname.log
	sed -i '1iIdentificação;Local:'"$local"';Função:'"$funcao"';Zona:'"$zona"';AutoImp:'"$autoimp" $origem/hostname.log

	CPULOG=` cat $origem/hostname.log | grep "CPU:" `
	MEMLOG=` cat $origem/hostname.log | grep "MemTotal:" `
	HDLOG=` cat $origem/hostname.log | grep "sda:" `

	CPU=` cat /proc/cpuinfo | grep name | tail -1 | awk -F': ' '{ print "CPU:" $2}' | sed -e 's/  //g' `
	MEM=` cat /proc/meminfo | grep MemTotal | sed -e 's/ //g' `
	HD=` dmesg | grep "[sh]d[a-g]" | grep blocks | awk '{ print $5 ":" $10 $11 $12 }' | sed -e 's/ //g;s/\[//g;s/\]//g' `

	if [[ $CPULOG != $CPU ]]; then
		sed -i '/CPU:/d' $origem/hostname.log
		sed -i '2i'"$CPU" $origem/hostname.log
	fi
	if [[ $CPULOG != $CPU ]]; then
		sed -i '/MemTotal:/d' $origem/hostname.log
		sed -i '3i'"$MEM" $origem/hostname.log
	fi
	if [[ $CPULOG != $CPU ]]; then
		sed -i '/sda:/d' $origem/hostname.log
		sed -i '4i'""$HD"" $origem/hostname.log
	fi
	
	}

function recolherDados () {
locais=` cat $origem/rp_localizacao.dat | grep local | awk -F'=' '{ print $2 }' | sed -e 's/$/ ←/g' | sort -d `
funcoes=` cat $origem/rp_localizacao.dat | grep funcao | awk -F'=' '{ print $2 }' | sed -e 's/$/ ←/g' | sort -d `

local=$(dialog                                   \
       --stdout                                  \
       --title "Identificação do posto $posto"   \
       --menu "Porfavor escolha o local:"        \
        0 0 0                                    \
       ${locais})
       [ $? -ne 0 ] && clear && echo "Aplicação cancelada." && exit 0
       
funcao=$(dialog                                   \
       --stdout                                   \
       --title "Identificação do posto $posto"    \
       --menu "Porfavor escolha a função:"        \
        0 0 0                                     \
       ${funcoes})
       [ $? -ne 0 ] && clear && echo "Aplicação cancelada." && exit 0

zona=$(dialog                                                                                  \
       --stdout                                                                                \
       --title "Identificação do posto $posto"                                                 \
       --inputbox "Porfavor descreva sumariamente a zona\nonde o posto se encontra instalado:" \
        0 0)
        [ $? -ne 0 ] && clear && echo "Aplicação cancelada." && exit 0
        
autoimp=$(dialog                                                  \
		--stdout                                                  \
		--title "Identificação do posto $posto"                   \
		--menu "Activar configuração automática ou manual das Impressoras?" \
		0 0 0                                                     \
		A 'Automática'                                                   \
		M 'Manual')
	[ $? -ne 0 ] && clear && echo "Aplicação cancelada." && break       
	}

function menu () {

if [[ $local == "" ]]; then
	zona=` cat $origem/hostname.log | grep Identificação | awk -F';' '{ print $4 }' | awk -F':' '{ print $2 }' `
	local=` cat $origem/hostname.log | grep Identificação | awk -F';' '{ print $2 }' | awk -F':' '{ print $2 }' `
	funcao=` cat $origem/hostname.log | grep Identificação | awk -F';' '{ print $3 }' | awk -F':' '{ print $2 }' `
	autoimp=` cat $origem/hostname.log | grep Identificação | awk -F';' '{ print $5 }' | awk -F':' '{ print $2 }' `
	posto=` cat $origem/hostname.log | /bin/sed -n '$p' `

	if [[ $local == "" ]]; then
		recolherDados
	fi
fi

let "loop1=0"
while test $loop1 == 0
do
	opcao=$( dialog                                                                                                              \
		--stdout                                                                                                                 \
		--title "Identificação do posto $posto"                                                                                  \
		--menu "\n  Local: $local\n Função: $funcao\n   Zona: $zona\nPrinter: $autoimp\n\nOs dados apresentados estão correctos?" \
		0 0 0                                                                                                                    \
		S 'Sim'                                                                                                                  \
		N 'Não')

	[ $? -ne 0 ] && clear && echo "Aplicação cancelada." && break

	case $opcao in 
	s|S) gravarDados ; clear ; echo "Os dados foram gravados." ; exit 0 ;;
	n|N) recolherDados ;;
	esac
done

exit 0
	
	}

requisitos
menu

