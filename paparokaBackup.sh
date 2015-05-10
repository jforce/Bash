#!/usr/bin/env bash

####################################################
# #
# paparokaBackup [opção]
# Opção:
# D: Descarrega o site para o computador
# C: Carrega o site todo para o servidor
#
# Autor: j.francisco.o.rocha@gmail.com
# #
####################################################

OPCAO=$1
shopt -s -o nounset
declare -rx SCRIPT=${0##*/}
declare IFS=$'\n'
declare -rx LFTP="/usr/bin/lftp"
declare HOST="ftp.paparoka.com"
declare USER="paparoka"
declare PASS="3ci35mO4Im"
declare LCD="$HOME/Dropbox/Paparoka/backup/Site/"
declare RCD="/"
declare BCD="$HOME/Dropbox/Paparoka/backup/"
declare OPCAO
declare RETENCAO=10
declare NUMBACKUPS=""
declare DIFRN=""
declare FILE="$(date +%Y-%m-%d).tar.gz"

function mensagemErro () {
	echo -e "Formato do comando: paparokaBackup [opção]\n Opção:\n D: Descarrega o site para o computador\n C: Carrega o site todo para o servidor"
	}

function printnofound () {
	echo -e "Não existe o utilitario $1. Porfavor instale.\n"
}

function startLFTP () {
	if [ ! -x "$LFTP" ]; then
		printnofound $LFTP >&2
		exit 192
	fi
	mkdir -p $HOME/.lftp/
	echo "set ssl:verify-certificate no" > $HOME/.lftp/rc
	echo "set ftp:ssl-allow no" >> $HOME/.lftp/rc
	#echo "set net:connection-limit 5" >> $HOME/.lftp/rc
	echo "set net:connection-limit 1" >> $HOME/.lftp/rc
	mkdir -p $HOME/Dropbox/Paparoka/backup/Site/
	}

function gerirBackup () {
#CRIAR BACKUP
tar --create --gzip --file=$BCD$FILE $LCD

#ANALIZAR RETENCAO
NUMBACKUPS=$(ls -1 $BCD*tar.gz | wc -l)
if [ $NUMBACKUPS -ge $RETENCAO ]; then
	DIFRN=$(($NUMBACKUPS-$RETENCAO))
	if [ $DIFRN -gt 0 ]; then
	echo -e "O numero maximo de backups em retenção é $RETENCAO"
	echo -e "Removendo os ficheiros:\n$(ls -rt1 $BCD*tar.gz | head -$DIFRN)"
	ls -rt1 $BCD*tar.gz | head -$DIFRN | xargs rm
	echo "Conteudo da pasta $HOME/Dropbox/Paparoka/backup/"
	ls -lahi "$HOME/Dropbox/Paparoka/backup/"
	fi
fi
	}


if [[ $OPCAO != "" ]]; then
	if [[ $OPCAO == "D" ]]; then
		if [[ ! -f "$BCD$FILE" ]]; then
			echo -e "Escolheu a opção:$OPCAO\nO site vai ser todo descarregado para a pasta:\n$LCD"
			read -p "Precione qualquer tecla para continuar ou faça [CTRL]+[C] para abortar..." -n1 -s
			startLFTP
			$LFTP -c "set ftp:list-options -a;open ftp://$USER:$PASS@$HOST;lcd $LCD;cd $RCD;mirror --use-pget-n=5 --use-cache --continue --delete;quit"
			gerirBackup
			rm $LCD.cagefs/tmp/mysql.sock
		else
			echo -e "O backup $FILE já foi feito!\nPode consultar o ficheiro na pasta:\n$BCD"
		fi
	else
		if [[ $OPCAO == "C" ]]; then
			echo -e "Escolheu a opção:$OPCAO\nO site vai ser todo carregado para:\nServidor:$HOST\nPasta:$RCD"
			read -p "Precione qualquer tecla para continuar ou faça [CTRL]+[C] para abortar..." -n1 -s
			startLFTP
			$LFTP -c "set ftp:list-options -a;open ftp://$USER:$PASS@$HOST;lcd $LCD;cd $RCD;mirror -R --use-pget-n=5 --use-cache --continue;quit"
		else
			mensagemErro
		fi
	fi
else
	mensagemErro
fi

###############################
# Opções do mando LFTP (mirror)
#########################################################################
# -c, --continue          continue a mirror job if possible
# -e, --delete            delete files not present at remote site
# -s, --allow-suid        set suid/sgid bits according to remote site
#     --allow-chown       try to set owner and group on files
# -n, --only-newer        download only newer files (-c won't work)
# -r, --no-recursion      don't go to subdirectories
# -p, --no-perms          don't set file permissions
#     --no-umask          don't apply umask to file modes
# -R, --reverse           reverse mirror (put files)
# -L, --dereference       download symbolic links as files
# -N, --newer-than FILE   download only files newer than the file
# -P, --parallel[=N]      download N files in parallel
# -i RX, --include RX    include matching files
# -x RX, --exclude RX    exclude matching files
# -I GP, --include-glob GP        include matching files
# -X GP, --exclude-glob GP        exclude matching files
# -v, --verbose[=level]   verbose operation
#     --use-cache         use cached directory listings
# --Remove-source-files   remove files after transfer (use with caution)
# -a                      same as --allow-chown --allow-suid --no-umask
#########################################################################

##########################################################
#lftp -c "set ftp:list-options -a;
#open ftp://$USER:$PASS@$HOST;
#lcd $LCD;
#cd $RCD;
#mirror --reverse \
#       --delete \
#       --verbose \
#       --exclude-glob a-dir-to-exclude/ \
#       --exclude-glob a-file-to-exclude \
#       --exclude-glob a-file-group-to-exclude* \
#       --exclude-glob other-files-to-esclude"
############################################################
