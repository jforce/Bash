#!/bin/bash
#rsync -Cravzpu --delete "/home/francisco/Área de Trabalho/UA/" "/media/F648-1CBC/UA/"
#rsync --verbose --stats --recursive --delete "/home/francisco/Área de Trabalho/UA1/" "/media/F648-1CBC/UA1/"
#rsync -Cravzp "/home/francisco/Área de Trabalho/UA/" "/media/F648-1CBC/UA/"
#rsync -rvt --modify-window=1 --delete "/home/francisco/Área de Trabalho/UA1/" "/media/F648-1CBC/UA1/"  
#rsync -rvt --modify-window=1 --delete "/media/INTENSO/UA/" "/home/francisco/Área de Trabalho/UA/"
#mkdir -p $HOME/UA/pen
#rsync -rvt --modify-window=1 --delete /media/INTENSO/ $HOME/UA/Pen
#read -p "Preciose uma tecla qualquer para fechar a janela"


rsync -rvt --modify-window=1 /home/francisco/Box.Net/paparoka/ /home/francisco/Box.Net/teste

# Script para backup via SSH usando o rsync
# Versão 0.1

## PARAMETROS ##
# Mude os parâmetros abaixo, referentes ao seu sistema
LOG=$HOME/backup`date +%Y-%m-%d`.log

# DESTINO
# IP ou hostname da máquina de destino
ENDERECODESTINO=192.168.1.158
# Utilizador no destino
USRDESTINO=xbmc
# Diretório de destino
DIRDESTINO=/home/xbmc/

# ORIGEM
# Diretório de origem
DIRORIGEM=$HOME/People

## FIM DE PARAMETROS ##

# Checar se a máquina de destino está ligada
/bin/ping -c 1 -W 2 $ENDERECODESTINO > /dev/null
if [ "$?" -ne 0 ];
then
   #echo -e `date +%c` >> $LOG
   #echo -e "\n$ENDERECODESTINO desligado." >> $LOG
   #echo -e "Backup não realizado\n" >> $LOG
   #echo -e "--- // ---\n" >> $LOG
   echo -e "\n$ENDERECODESTINO desligado."
   echo -e "Backup não realizado.\n"
else
   HORA_INI=`date +%s`
   #echo -e `date +%c` >> $LOG
   #echo -e "\n$DESTINO ligado!" >> $LOG
   #echo -e "Iniciando o backup...\n" >> $LOG
   #rsync -ah --delete --stats --progress --log-file=$LOG -e ssh $SRC $USR@$DESTINO:$DIR
   rsync -ah --delete --stats --progress -e ssh $DIRORIGEM $USRDESTINO@$ENDERECODESTINO:$DIRDESTINO
   HORA_FIM=`date +%s`
   TEMPO=`expr $HORA_FIM - $HORA_INI`
   #echo -e "\nBackup finalizado com sucesso!" >> $LOG
   #echo -e "Duração: $TEMPO s\n" >> $LOG
   #echo -e "--- // ---\n" >> $LOG
   echo -e "\nBackup finalizado com sucesso!"
   echo -e "Duração: $TEMPO s\n"
   echo -e "Consulte o log da operação em $LOG.\n"
fi

# Afazeres

#	- Incluir em cron job!
#	- Definir como lidar com o arquivo.log (deletar, arquivar, deixar...)
#	- Incluir wakeonlan para ligar o computador se estiver desligado
#	- Desligar máquina de destino após o término do backup
#	- Criar alça para quando a transferência falhar (e.g.,falta de espaço)
