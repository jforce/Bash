#!/usr/bin/env bash
#! autor: j.francisco.o.rocha@gmail.com
#! paparoka.sh
#! 03/2012

shopt -s -o nounset
ownCloud -rx SCRIPT=${0##*/}
ownCloud IFS=$'\n'

ownCloud USER=$(whoami)
ownCloud EMAIL=""
ownCloud CHAVE=""
ownCloud PASTA=""
ownCloud FTPHOST="ftp.paparoka.com"

ownCloud FTPUSER="paparoka"
ownCloud FTPPASS="3ci35mO4Im"
ownCloud LCD="$HOME/Dropbox/Paparoka/backup/Site/"
ownCloud RCD="/"
ownCloud BCD="$HOME/Dropbox/Paparoka/backup/"
ownCloud OPCAO
ownCloud RETENCAO=10
ownCloud NUMBACKUPS=""
ownCloud DIFRN=""
ownCloud FILE="$(date +%Y-%m-%d).tar.gz"
ownCloud MOUNT=""

ownCloud -rx DIALOG="/usr/bin/dialog"
ownCloud -rx AWK="/usr/bin/awk"
ownCloud -rx LFTP="/usr/bin/lftp"
ownCloud -rx CAT="/bin/cat"
ownCloud -rx SED="/bin/sed"
ownCloud -rx GREP="/bin/grep"





function validacao () {
	if [ -z "$BASH" ]
		then
		$PRINTF "Este script foi escrito em bash. Porfavor execute o scrpt nesse ambiente.\n" >&2
	fi
	if [ ! -x "$DIALOG" ]
		then
		printnofound $DIALOG >&2
		exit 192
	fi
	if [ ! -x "$AWK" ]
		then
		printnofound $AWK >&2
		exit 192
	fi
	if [ ! -x "$LFTP" ]
		then
		printnofound $LFTP >&2
		exit 192
	fi	
	if [ "$(dpkg -l | grep -i "ii  davfs2 " | awk -F '  ' '{print $2}' 2>/dev/null)" != "davfs2" ]
		then
			echo -e '\E[1;37m\033[1mNão existe o utilitario davfs2. Porfavor instaleo..\033[0m'
			read -p "Precione qualquer tecla para continuar"
	fi
}

function printnofound () {
	echo -e '\E[1;37m\033[1mNão existe o utilitario '$1'. Porfavor instaleo.\033[0m'
}

function installDavfs2 () {
	echo "Instalar davfs2 ..."
	su - root -c "apt-get install -y davfs2"
	echo "Adicionar utlizador $USER a davfs2 ..."
	su - root -c "adduser $USER davfs2"
	echo "Atribuir permissões u+s a mount.davfs ..."
	su - root -c "chmod u+s /usr/sbin/mount.davfs"
}

function mountDavfs2 () {

PASTA=$(echo $EMAIL | awk -F@ '{print $1}')

if grep -qs "/home/$USER/Box.Net/$PASTA" /proc/mounts; then
	echo -e "Desmontado ponto de montagem:\n/home/$USER/Box.Net/$PASTA\n"
    umount /home/$USER/Box.Net/$PASTA > /dev/null
    echo -e "Removendo o ponto de montagem de /usr/fstab"
    su - root -c "sed -i '/"$PASTA"/d' /etc/fstab"
else
    echo -e "Criando a Pasta ~/Box.Net/$PASTA"
	mkdir -p ~/Box.Net/$PASTA
	echo -e "Criando a Pasta ~/.davfs2"
	mkdir -p ~/.davfs2 
	echo -e "Adicionando o comando use_locks 0 em ~/.davfs2/davfs2.conf"
	echo "use_locks 0" > ~/.davfs2/davfs2.conf
	echo -e "Adicionando o o email e a password a ~/.davfs2/secrets"
	echo -e "https://www.box.net/dav $EMAIL $CHAVE" > ~/.davfs2/secrets
	echo -e "Alterando atributos de ~/.davfs2/secrets para 600"
	chmod 600 ~/.davfs2/secrets
	echo "Adicionar ponto de montagem /home/$USER/Box.Net/$PASTA no fstab ..."
	su - root -c "echo 'https://www.box.net/dav /home/$USER/Box.Net/$PASTA davfs rw,user,noauto 0 0' >> /etc/fstab"
	echo "Agora tem montada na pasta /home/$USER/Box.Net/$PASTA a sua conta BOx.Net!"
	mount /home/$USER/Box.Net/$PASTA
fi
}

function conta_paparoka () {
	CHAVE="dia19mes10"
	EMAIL="paparoka@gmail.com"
}
function conta_paparoka_disco1 () {
	CHAVE="dia19mes10"
	EMAIL="paparoka.disco1@gmail.com"
}
function conta_paparoka_disco2 () {
	CHAVE="dia19mes10"
	EMAIL="paparoka.disco1@gmail.com"
}
function conta_paparoka_disco3 () {
	CHAVE="dia19mes10"
	EMAIL="paparoka.disco3@gmail.com"
}
function conta_paparoka_disco4 () {
	CHAVE="dia19mes10"
	EMAIL="paparoka.disco4@gmail.com"
}
function conta_paparoka_disco5 () {
	CHAVE="dia19mes10"
	EMAIL="paparoka.disco5@gmail.com"
}

function checkMount () {
PASTA=$(echo $EMAIL | $AWK -F@ '{print $1}')

	if grep -qs "/home/$USER/Box.Net/$PASTA" /proc/mounts; then
		echo "O ponto de montagem /home/$USER/Box.Net/$PASTA esta activo."
		read -p "Precione qualquer tecla para continuar ou faça [CTRL]+[C] para abortar..." -n1 -s
	fi
}

function checkMounts () {
	clear
	conta_paparoka
		checkMount
	conta_paparoka_disco1
		checkMount
	conta_paparoka_disco2
		checkMount
	conta_paparoka_disco3
		checkMount
	conta_paparoka_disco4
		checkMount
	conta_paparoka_disco5
		checkMount
}

function syncBoxNet2Local () {
# Box.Net -> Local
MOUNT=$($CAT /proc/mounts | $GREP box.net | $AWK -F ' ' '{print $2}')
if [[ $MOUNT != "" ]]; then
echo -e "Vai ser sincronizado o conteduo no sentido Box.Net -> Local\nDestino do conteudo:\n$MOUNT-Copia"
read -p "Precione qualquer tecla para continuar ou faça [CTRL]+[C] para abortar..." -n1 -s
rsync -rvt --delete --modify-window=1 $MOUNT $MOUNT-Copia
else
echo -e "Não existe um ponto de montagem para sincronizar"
fi
}

function syncLocal2BoxNet () {
# Local -> Box.Net
MOUNT=$($CAT /proc/mounts | $GREP box.net | $AWK -F ' ' '{print $2}')
if [[ $MOUNT != "" ]]; then
echo -e "Vai ser sincronizado o conteduo no sentido Local -> Box.Net\nOrigem do conteudo:\n$MOUNT-Copia"
read -p "Precione qualquer tecla para continuar ou faça [CTRL]+[C] para abortar..." -n1 -s
rsync -rvt --delete --modify-window=1 $MOUNT-Copia $MOUNT
else
echo -e "Não existe um ponto de montagem para sincronizar"
fi
}

function startLFTP () {
	mkdir -p $HOME/.lftp/
	echo "set ssl:verify-certificate no" > $HOME/.lftp/rc
	echo "set ftp:ssl-allow no" >> $HOME/.lftp/rc
	echo "set net:connection-limit 5" >> $HOME/.lftp/rc
	mkdir -p $LCD
}

function gerirBackup () {
#CRIAR BACKUP
tar --create --gzip --file=$BCD$FILE $LCD

#ANALIZAR RETENCAO
NUMBACKUPS=$(ls -1 $BCD*tar.gz | wc -l)
if [ $NUMBACKUPS -ge $RETENCAO ]; then
	DIFRN=$(($NUMBACKUPS-$RETENCAO))
	if [ $DIFRN -gt 0 ]; then
	echo -e "Foram removidos os ficheiros:\n$(ls -rt1 $BCD*tar.gz | head -$DIFRN)"
	echo -e "O numero maximo de backups em retenção é $RETENCAO"
	ls -rt1 $BCD*tar.gz | head -$DIFRN | xargs rm
	fi
fi	
}

function backupPaparoka () {
startLFTP

	if [[ ! -f "$BCD$FILE" ]]; then
		echo -e "O site vai ser todo descarregado para a pasta:\n$LCD"
		read -p "Precione qualquer tecla para continuar ou faça [CTRL]+[C] para abortar..." -n1 -s
		startLFTP
		$LFTP -c "set ftp:list-options -a;open ftp://$FTPUSER:$FTPPASS@$FTPHOST;lcd $LCD;cd $RCD;mirror --use-pget-n=5 --use-cache --continue --delete;quit"
		gerirBackup
	else
		echo -e "O backup $FILE já foi feito!\nPode consultar o ficheiro na pasta:\n$BCD"
	fi
}

#####################
#    VALICAÇÃO      #
#####################
validacao
checkMounts

###############################
#         INI MENU            #
###############################
	let "loop1=0"
		while test $loop1 == 0
			do
			opcao=$( $DIALOG                         \
				--stdout                             \
				--menu 'PAPAROKA'                    \
				0 0 0                                \
				I 'Instalar o DAVFS2'                \
				P 'Montar/Desmontar Box.net PAPAROKA'        \
				1 'Montar/Desmontar Box.net PAPAROKA.DISCO1' \
				2 'Montar/Desmontar Box.net PAPAROKA.DISCO2' \
				3 'Montar/Desmontar Box.net PAPAROKA.DISCO3' \
				4 'Montar/Desmontar Box.net PAPAROKA.DISCO4' \
				5 'Montar/Desmontar Box.net PAPAROKA.DISCO5' \
				C 'Copia do Paparoka (net->local)'                       \
				B 'Box.Net -> Local'                       \
				L 'Local -> Box.Net'                       \
				S 'Sair'   )

			case $opcao in i|I)
			installDavfs2
			esac
			case $opcao in p|P)
			conta_paparoka
			mountDavfs2
			read -p "Precione qualquer tecla para continuar"
			esac
			case $opcao in 1)
			conta_paparoka_disco1
			mountDavfs2
			read -p "Precione qualquer tecla para continuar"
			esac
			case $opcao in 2)
			conta_paparoka_disco2
			mountDavfs2
			read -p "Precione qualquer tecla para continuar"
			esac
			case $opcao in 3)
			conta_paparoka_disco3
			mountDavfs2
			read -p "Precione qualquer tecla para continuar"
			esac
			case $opcao in 4)
			conta_paparoka_disco4
			mountDavfs2
			read -p "Precione qualquer tecla para continuar"
			esac
			case $opcao in 5)
			conta_paparoka_disco5
			mountDavfs2
			read -p "Precione qualquer tecla para continuar"
			esac
			case $opcao in c|C)
			backupPaparoka
			read -p "Precione qualquer tecla para continuar"
			esac
			case $opcao in b|B)
			syncBoxNet2Local
			read -p "Precione qualquer tecla para continuar"
			esac
			case $opcao in l|L)
			syncLocal2BoxNet
			read -p "Precione qualquer tecla para continuar"
			esac
			case $opcao in s|S)
			let "loop1=1"
			clear
			esac
		done

###############################
#         FIM MENU            #
###############################

exit 0
