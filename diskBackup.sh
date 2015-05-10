!/bin/bash
clear

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
REDE=` ifconfig | grep -o 192.* | sed -e 's/ .*//g' | awk -F'.' '{ print $3 }' `

function montarFTP () {
ftpTest=` df | grep ftp `
if [[ $ftpTest == "" ]]; then
	if [ "$REDE" == "79" ] || [ "$REDE" == "73" ] || [ "$REDE" == "71" ]; then
		curlftpfs -o allow_other -o nonempty ftp://cat-monitor:qazwsx@$IP/Centro_de_Tecnologia/Maquinas /home/partimag
	else
		curlftpfs -o allow_other -o nonempty ftp://ct:qazwsx@$IP/ /home/partimag
	fi
	echo "Ponto de montagem /home/partimag activo para o IP $IP"
else
	echo "Ponto de montagem /home/partimag ja existia para o IP $IP"
fi
	}

function perguntaIP () {
		xxx=$(dialog                                                                                       \
       --stdout                                                                                              \
       --title "Menu"                                                                            \
       --inputbox "Porfavor identifique o IP do servidor\nIndicando o ultimo octeto do ip 192.168.$REDE.xxx:" \
        0 0)
        [ $? -ne 0 ] && clear && echo "Aplicação cancelada." && exit 0
        IP=192.168.$REDE.$xxx
        echo $IP > $SCRIPTPATH/diskBackup.dat
	}

function identificaIP () {
if [ "$REDE" == "79" ] || [ "$REDE" == "73" ] || [ "$REDE" == "71" ]; then
	IP=192.168.71.214
else
	if [[ -e $SCRIPTPATH/diskBackup.dat ]]; then
		IP=` cat $SCRIPTPATH/diskBackup.dat `
		REDEDAT=`echo $IP | awk -F'.' '{ print $3 }' `
		if [[ "$REDE" != "$REDEDAT" ]]; then
			perguntaIP
		fi
	else
		perguntaIP
	fi
fi
	}

function backupDiscoR () {
	disks=` dmesg | grep "[sh]d[a-g]" | grep "logical blocks" | awk -F': ' '{ print $2 $3 }' | sed -e "s/ //g;s/].*.(/] (/g;s/\[//g;s/\]//g" `

	disk=$(dialog                          \
		--stdout                           \
		--title "Menu"                     \
		--menu "Escolha o disco a copiar:" \
		0 0 0                              \
		${disks})
	[ $? -ne 0 ] && clear && echo "Aplicação cancelada." && exit 0

	nome=$(dialog                                               \
		--stdout                                                \
		--title "Menu"                                          \
		--inputbox "Digite o nome da imagem sem o sufixo -img:" \
		0 0)
	[ $? -ne 0 ] && clear && echo "Aplicação cancelada." && exit 0

	backupDiscoM
	}

function backRestM () {
let "loop1=0"
while test $loop1 == 0
do
	opcao=$( dialog                                                                           \
		--stdout                                                                              \
		--title "Menu"                                                                        \
		--menu "\nPorfavor indique qual e a opção desejada" \
		0 0 0                                                                                 \
		B 'Backup'                                                                               \
		R 'Restore')
	[ $? -ne 0 ] && clear && echo "Aplicação cancelada." && exit 0

	case $opcao in
	r|R) /usr/sbin/clonezilla.sh ; exit 0 ;;
	b|B) backupDiscoR ;;
	esac
done
	}

function backupDiscoM () {
let "loop1=0"
while test $loop1 == 0
do
	opcao=$( dialog                                                                           \
		--stdout                                                                              \
		--title "Menu"                                                                        \
		--menu "\nDisco: $disk\n Nome: $nome-img\n\nOs dados apresentados estão correctos?" \
		0 0 0                                                                                 \
		S 'Sim'                                                                               \
		N 'Não')
	[ $? -ne 0 ] && clear && echo "Aplicação cancelada." && exit 0

	case $opcao in
	s|S) /usr/sbin/ocs-sr -q2 -c -j2 -z1p -i 2000 -p true savedisk $nome-img "$disk" ; exit 0 ;;
	n|N) backupDiscoR ;;
	esac
done
	}

function restoreDisco () {
	rpdistro=` ls -dtr /home/partimag/rpdistro* | awk -F'/' '{ print $4 }'| sed -n '$p' `
	/usr/sbin/ocs-sr -g auto -e1 auto -e2 -c -r -j2 -p true restoredisk $rpdistro sda
	}

if [ "$1" = "m" ] || [ "$1" = "M" ]; then
	identificaIP
	montarFTP
	if [ "$REDE" == "79" ] || [ "$REDE" == "73" ] || [ "$REDE" == "71" ]; then
	backRestM
	else
	restoreDisco
	fi
fi


if [ "$1" = "u" ] || [ "$1" = "U" ]; then
	if [[ ftpTest == "" ]]; then
		echo "Ponto de montagem /home/partimag inactivo para o IP $IP"
	else
		umount /home/partimag
		echo "Ponto de montagem /home/partimag inactivo para o IP $IP"
	fi
fi

if [ "$1" != "m" ] && [ "$1" != "M" ] && [ "$1" != "u" ] && [ "$1" != "U" ]; then
    echo "Formato do comando:"
    echo "$0 [m|M] - Montar IP"
    echo "$0 [u|U] - Desmontar IP"
fi
