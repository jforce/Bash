#!/usr/bin/env bash
#! autor: cfjrocha@gmail.com
#! 2008

counter=0

if [ "$(id -u)" != "0" ]; then
	clear
	echo "Este Script só pode ser invocado com o Sudo ou pelo utilizador root."
	exit 1
fi

function identificaDiscos () {

labels=($(ls -l /dev/disk/by-label/ | grep DISC | awk -F' ' '{ print $9 }'))
devices=($(ls -l /dev/disk/by-label/ | grep DISC | awk -F' ' '{ print $11 }'))

numeroLabels=${#labels[@]}

while [ "$counter" -le "$numeroLabels  ] ; do
	for l in "${labels[@]}"; do
		for d in "${devices[@]}"; do
			counter=$(( $counter + 1 ))
			echo Disco$counter:
			echo label: $l
			echo device: $d
		done
	done
done
}

function conteudo () {
clear
echo "  ____________________________________________________"
echo "||  A Criar Folha de Calculo com conteudo dos HD's... ||"
echo "||____________________________________________________||"
echo

dia="$(date +%d)"
mes="$(date +%B)"
ano="$(date +%Y)"
hora="$(date +%H)"
min="$(date +%M)"

echo "Processando DISC01..."
if [[ -d /media/DISC01 ]]; then
	mkdir -p /media/DISC01/AMinhaMusica
	mkdir -p /media/DISC01/AsMinhasSeries
	mkdir -p /media/DISC01/OsMeusDocumentarios
	mkdir -p /media/DISC01/OsMeusFilmes
	mkdir -p /media/DISC01/OsMeusFilmesHD
	mkdir -p /media/DISC01/OsMeusFilmesInfantis
	mkdir -p /media/DISC01/OsMeusVideosMusicais
	du --max-depth=2 /media/DISC01/ > /tmp/lista_.txt
	sed -e 's/\/media\///g' -e 's/\//\t/g' /tmp/lista_.txt > /tmp/lista_0.txt
else
	echo "DISC01 não esta presente"
fi

echo "Processando DISC02..."
if [[ -d /media/DISC02 ]]; then
	mkdir -p /media/DISC02/AMinhaMusica
	mkdir -p /media/DISC02/AsMinhasSeries
	mkdir -p /media/DISC02/OsMeusDocumentarios
	mkdir -p /media/DISC02/OsMeusFilmes
	mkdir -p /media/DISC02/OsMeusFilmesHD
	mkdir -p /media/DISC02/OsMeusFilmesInfantis
	mkdir -p /media/DISC02/OsMeusVideosMusicais
	du --max-depth=2 /media/DISC02/ > /tmp/lista_.txt
	sed -e 's/\/media\///g' -e 's/\//\t/g' /tmp/lista_.txt >> /tmp/lista_0.txt
else
	echo "DISC02 não esta presente"
fi

echo "Processando DISC03..."
if [[ -d /media/DISC03 ]]; then
	mkdir -p /media/DISC03/AMinhaMusica
	mkdir -p /media/DISC03/AsMinhasSeries
	mkdir -p /media/DISC03/OsMeusDocumentarios
	mkdir -p /media/DISC03/OsMeusFilmes
	mkdir -p /media/DISC03/OsMeusFilmesHD
	mkdir -p /media/DISC03/OsMeusFilmesInfantis
	mkdir -p /media/DISC03/OsMeusVideosMusicais
	du --max-depth=2 /media/DISC03/ > /tmp/lista_.txt
	sed -e 's/\/media\///g' -e 's/\//\t/g' /tmp/lista_.txt >> /tmp/lista_0.txt
else
	echo "DISC03 não esta presente"
fi

echo "Processando DISC04..."
if [[ -d /media/DISC04 ]]; then
	mkdir -p /media/DISC04/AMinhaMusica
	mkdir -p /media/DISC04/AsMinhasSeries
	mkdir -p /media/DISC04/OsMeusDocumentarios
	mkdir -p /media/DISC04/OsMeusFilmes
	mkdir -p /media/DISC04/OsMeusFilmesHD
	mkdir -p /media/DISC04/OsMeusFilmesInfantis
	mkdir -p /media/DISC04/OsMeusVideosMusicais
	du --max-depth=2 /media/DISC04/ > /tmp/lista_.txt
	sed -e 's/\/media\///g' -e 's/\//\t/g' /tmp/lista_.txt >> /tmp/lista_0.txt
else
	echo "DISC04 não esta presente"
fi

echo "Processando DISC05..."
if [[ -d /media/DISC05 ]]; then
	mkdir -p /media/DISC05/AMinhaMusica
	mkdir -p /media/DISC05/AsMinhasSeries
	mkdir -p /media/DISC05/OsMeusDocumentarios
	mkdir -p /media/DISC05/OsMeusFilmes
	mkdir -p /media/DISC05/OsMeusFilmesHD
	mkdir -p /media/DISC05/OsMeusFilmesInfantis
	mkdir -p /media/DISC05/OsMeusVideosMusicais
	du --max-depth=2 /media/DISC05/ > /tmp/lista_.txt
	sed -e 's/\/media\///g' -e 's/\//\t/g' /tmp/lista_.txt >> /tmp/lista_0.txt
else
	echo "DISC05 não esta presente"
fi

echo "Processando DISC06..."
if [[ -d /media/DISC06 ]]; then
	mkdir -p /media/DISC06/AMinhaMusica
	mkdir -p /media/DISC06/AsMinhasSeries
	mkdir -p /media/DISC06/OsMeusDocumentarios
	mkdir -p /media/DISC06/OsMeusFilmes
	mkdir -p /media/DISC06/OsMeusFilmesHD
	mkdir -p /media/DISC06/OsMeusFilmesInfantis
	mkdir -p /media/DISC06/OsMeusVideosMusicais
	du --max-depth=2 /media/DISC06/ > /tmp/lista_.txt
	sed -e 's/\/media\///g' -e 's/\//\t/g' /tmp/lista_.txt >> /tmp/lista_0.txt
else
	echo "DISC06 não esta presente"
fi

echo "Gerando Relatorio de Filmes ..."
# Remover pastas indesejadas
sed -e '/lost+found/ d' -e '/.Trash-1000/ d' -e '/AsMinhasImagens/ d' -e '/OutrosAssuntos/ d' -e '/AsMinhasFotos/ d' -e '/OsMeusVideosFamiliares/ d' /tmp/lista_0.txt > /tmp/lista_1.txt
# Ordenar colunas, remover niveis indesejados e ordenar linhas
awk -F "\t" '{printf "%s\t%s\t%s\t%s\n", $3,$4,$1,$2}' /tmp/lista_1.txt | awk 'NF > 3' | sort -d > $HOME/conteudo.csv
# Adicionar linha de cabeçalho
sed -i '1i\Categoria\tConteúdo a '$dia' de '$mes' de '$ano' às '$hora'.'$min'\tTamanho\tDisco' $HOME/conteudo.csv

echo "Gerando Relatorio de Filmes Repetidos ..."
awk -F"\t" '{if (x[$2]) { x_count[$2]++; print $0; if (x_count[$2] == 1) { print x[$2] } } x[$2] = $0}' $HOME/conteudo.csv | awk -F "\t" '{printf "%s\t%s\t%s\t%s\n", $2,$1,$3,$4}' | sort -d > $HOME/conteudo_repetido.csv

# Remover ficheiros indesejados
rm /tmp/lista_*.txt

}

function remover {
clear
echo "  ____________________________________________________"
echo "||          Removendo Ficheiros Desnecessários        ||"
echo "||____________________________________________________||"
echo
echo "   Removendo o Ficheiro Thumbs.db da maquina"
sudo find /media/ -name Thumbs.db -exec rm -f {} \;
echo "   Removendo o Ficheiro desktop.ini da maquina"
sudo find /media/ -name desktop.ini -exec rm -f {} \;
echo "   Removendo o Ficheiro .DS_Store da maquina"
sudo find /media/ -name .DS_Store -exec rm -f {} \;
echo "   Removendo o Ficheiro ZbThumbnail.info da maquina"
sudo find /media/ -name ZbThumbnail.info -exec rm -f {} \;
echo "   Removendo o Ficheiro Picasa.ini da maquina"
sudo find /media/ -name Picasa.ini -exec rm -f {} \;
echo "   Removendo o Ficheiro ehthumbs_vista.db da maquina"
sudo find /media/ -name ehthumbs_vista.db -exec rm -f {} \;
echo "   Removendo o Ficheiro ehthumbs_vista.db:encryptable da maquina"
sudo find /media/ -name ehthumbs_vista.db:encryptable -exec rm -f {} \;
echo "   Removendo o Ficheiro ._* da maquina"
sudo find /media/ -name ._* -exec rm -f {} \;
echo "   Removendo o Ficheiro ehthumbs.db:encryptable da maquina"
sudo find /media/ -name ehthumbs.db:encryptable -exec rm -f {} \;
echo "   Remoção de Ficheiros da maquina concluida!"
}

function copia {
clear
echo "  ____________________________________________________"
echo "||          Realizando copias de segurança            ||"
echo "||                 DISC02  ->   DISC05                ||"
echo "||____________________________________________________||"
echo
echo "   Realizando Backup das Fotos de DISC02/AsMinhasFotos/"
echo "   para DISC05/OutrosAssuntos/Backup/AsMinhasFotos/"
echo $(date) >> /home/francisco/log_foto.txt
sudo rsync -a -r -v --delete --delete-excluded /media/DISC02/AsMinhasFotos/ /media/DISC05/OutrosAssuntos/Backup/AsMinhasFotos/ >> /home/francisco/log_foto.txt
echo "   Backup das fotos concluido!"
echo "   Realizando Backup dos Videos de DISC02/OsMeusVideosFamiliares/"
echo "   para DISC05/OutrosAssuntos/Backup/OsMeusVideosFamiliares/"
echo $(date) >> /home/francisco/log_video.txt
sudo rsync -a -r -v --delete --delete-excluded /media/DISC02/OsMeusVideosFamiliares/ /media/DISC05/OutrosAssuntos/Backup/OsMeusVideosFamiliares/ >> /home/francisco/log_video.txt
echo "   Backup dos Videos concluido!"
}

function hd1Check {
clear
echo "  ____________________________________________________"
echo "||               File Check do DISC01...              ||"
echo "||  usb-WD_Ext_HDD_1021_574341565932363538353035-0:0  ||"
echo "||      uuid=e4252223-80a3-422c-8bc6-d6ffa9488bfd     ||"
echo "||____________________________________________________||"
echo
# killall -9 java
# killall -9 amule
# sleep 10
sudo umount /dev/sdb1
sudo /sbin/e2fsck -f -y -v /dev/sdb1
# sudo mount /dev/disk/by-id/usb-WD_Ext_HDD_1021_574341565932363538353035-0:0-part1
echo "   File Check do hd1 concluido!"
# azureus>/dev/null&
# amule>/dev/null&
# sleep 10
}

function hd2Check {
clear
echo "  ____________________________________________________"
echo "||               File Check do DISC02...              ||"
echo "||  usb-WD_Ext_HDD_1021_574341565932353334323937-0:0  ||"
echo "||      uuid=a2f11c9f-2ef3-4a75-b892-74598a85e739     ||"
echo "||____________________________________________________||"
echo
sudo umount /dev/sdc1
sudo /sbin/e2fsck -f -y -v /dev/sdc1
# sudo mount /dev/disk/by-id/usb-WD_Ext_HDD_1021_574341565932353334323937-0:0-part1
echo "   File Check do hd2 concluido!"
}

function hd3Check {
clear
echo "  ____________________________________________________"
echo "||               File Check do DISC03...              ||"
echo "|| usb-WD_10EACS_External_574341553434303839323036-0:0||"
echo "||      uuid=a2f11c9f-2ef3-4a75-b892-74598a85e739     ||"
echo "||____________________________________________________||"
echo
sudo umount /dev/sdd1
sudo /sbin/e2fsck -f -y -v /dev/sdd1
# sudo mount /dev/disk/by-id/usb-WD_10EACS_External_574341553434303839323036-0:0-part1
echo "   File Check do hd3 concluido!"
}

function hd4Check {
clear
echo "  ____________________________________________________"
echo "||               File Check do DISC04...              ||"
echo "|| usb-WD_10EAVS_External_574341553431383338343535-0:0||"
echo "||      uuid=a2f11c9f-2ef3-4a75-b892-74598a85e739     ||"
echo "||____________________________________________________||"
echo
sudo umount /dev/sde1
sudo /sbin/e2fsck -f -y -v /dev/sde1
# sudo mount /dev/disk/by-id/usb-WD_10EAVS_External_574341553431383338343535-0:0-part1
echo "   File Check do hd3 concluido!"
}

function hd5Check {
clear
echo "  ______________________________________________________"
echo "||                 File Check do DISC05...              ||"
echo "||usb-WD_Ext_HDD_1021_5743415A4135353939383232-0:0-part1||"
echo "||        uuid=592f6e6a-b798-4f32-83b4-e6efb0f5df7d     ||"
echo "||______________________________________________________||"
echo
sudo umount /dev/sdf1
sudo /sbin/e2fsck -f -y -v /dev/sdf1
# sudo mount /dev/disk/by-id/usb-WD_Ext_HDD_1021_5743415A4135353939383232-0:0-part1
echo "   File Check do hd5 concluido!"
}

function hd6Check {
clear
echo "  ______________________________________________________"
echo "||               File Check do DISC06...                ||"
echo "||usb-WD_Ext_HDD_1021_5743415A4135343735373631-0:0-part1||"
echo "||       uuid=592f6e6a-b798-4f32-83b4-e6efb0f5df7d      ||"
echo "||______________________________________________________||"
echo
sudo umount /dev/sdg1
sudo /sbin/e2fsck -f -y -v /dev/sdg1
# sudo mount /dev/disk/by-id/usb-WD_Ext_HDD_1021_5743415A4135343735373631-0:0-part1
echo "   File Check do hd6 concluido!"
}

function hd7Check {
clear
echo "  ______________________________________________________"
echo "||               File Check do DISC99...                ||"
echo "||usb-WD_Ext_HDD_1021_5743415A4135343735373631-0:0-part1||"
echo "||       uuid=592f6e6a-b798-4f32-83b4-e6efb0f5df7d      ||"
echo "||______________________________________________________||"
echo
sudo umount /dev/sdh1
sudo /sbin/e2fsck -f -y -v /dev/sdh1
# sudo mount /dev/disk/by-id/usb-WD_Ext_HDD_1021_5743415A4135343735373631-0:0-part1
echo "   File Check do hd6 concluido!"
}

function actualiza {
clear
echo "  ____________________________________________________"
echo "||          Actualizando o comando Locate             ||"
echo "||____________________________________________________||"
echo
sudo updatedb
echo "   Actualização o comando Locate concluida!"
}

function atrib755 {
clear
echo "  ____________________________________________________"
echo "||         Alterando permissões para 755...           ||"
echo "||____________________________________________________||"
echo
echo "Processando DISC01..."
sudo chmod -R 755 "/media/DISC01"
sudo chmod -R 777 "/media/DISC01/lost+found/"
sudo chown -R francisco:francisco "/media/DISC01"
echo "Processando DISC02..."
sudo chmod -R 755 "/media/DISC02"
sudo chmod -R 777 "/media/DISC02/lost+found/"
sudo chown -R francisco:francisco "/media/DISC02"
echo "Processando DISC03..."
sudo chmod -R 755 "/media/DISC03"
sudo chmod -R 777 "/media/DISC03/lost+found/"
sudo chown -R francisco:francisco "/media/DISC03"
echo "Processando DISC04..."
sudo chmod -R 755 "/media/DISC04"
sudo chmod -R 777 "/media/DISC04/lost+found/"
sudo chown -R francisco:francisco "/media/DISC04"
echo "Processando DISC05..."
sudo chmod -R 755 "/media/DISC05"
sudo chmod -R 777 "/media/DISC05/lost+found/"
sudo chown -R francisco:francisco "/media/DISC05"
echo "Processando DISC06..."
sudo chmod -R 755 "/media/DISC06"
sudo chmod -R 777 "/media/DISC06/lost+found/"
sudo chown -R francisco:francisco "/media/DISC06"
echo "Processando DISC99..."
sudo chmod -R 755 "/media/DISC99"
sudo chmod -R 777 "/media/DISC99/lost+found/"
sudo chown -R francisco:francisco "/media/DISC99"

sudo chmod -R 700 "/media/DISC02/OutrosAssuntos/zZz"
sudo chmod -R 755 "/media/DISC02/AsMinhasFotos"
sudo chmod -R 755 "/media/DISC02/OsMeusVideosFamiliares"
echo "Alteração de permissões concluida!"


}

function atrib777 {
clear
echo "  ____________________________________________________"
echo "||         Alterando permissões para 777...           ||"
echo "||____________________________________________________||"
echo
echo "Processando DISC01..."
sudo chmod -R 777 "/media/DISC01"
sudo chown -R francisco:francisco "/media/DISC01"
echo "Processando DISC02..."
sudo chmod -R 777 "/media/DISC02"
sudo chown -R francisco:francisco "/media/DISC02"
echo "Processando DISC03..."
sudo chmod -R 777 "/media/DISC03"
sudo chown -R francisco:francisco "/media/DISC03"
echo "Processando DISC04..."
sudo chmod -R 777 "/media/DISC04"
sudo chown -R francisco:francisco "/media/DISC04"
echo "Processando DISC05..."
sudo chmod -R 777 "/media/DISC05"
sudo chown -R francisco:francisco "/media/DISC05"
echo "Processando DISC06..."
sudo chmod -R 777 "/media/DISC06"
sudo chown -R francisco:francisco "/media/DISC06"
echo "Processando DISC99..."
sudo chmod -R 777 "/media/DISC99"
sudo chown -R francisco:francisco "/media/DISC99"
sudo chmod -R 700 "/media/DISC02/OutrosAssuntos/zZz"
sudo chmod -R 755 "/media/DISC02/AsMinhasFotos"
sudo chmod -R 755 "/media/DISC02/OsMeusVideosFamiliares"
echo "Alteração de permissões concluida!"
}

function zZz {
clear
echo "  ____________________________________________________"
echo "||          Pasta zZz a ser desbloqueada...           ||"
echo "||____________________________________________________||"
echo
echo "Alterando permissões para 777..."
sudo chmod -R 777 "/media/DISC02/OutrosAssuntos/zZz"
sudo chmod -R 777 "/media/DISC01/lost+found/"
sudo chmod -R 777 "/media/DISC02/lost+found/"
sudo chmod -R 777 "/media/DISC03/lost+found/"
sudo chmod -R 777 "/media/DISC04/lost+found/"
sudo chmod -R 777 "/media/DISC05/lost+found/"
sudo chmod -R 777 "/media/DISC06/lost+found/"
echo "Alterando dono e grupo para francisco..."
sudo chown -R francisco:francisco "/media/DISC02/OutrosAssuntos/zZz"
echo "Alteração de permissões concluida!"
read -p "Precione alguma tecla para continuar"
echo "Bloqueando a pasta zZz ..."
sudo chmod -R 700 "/media/DISC02/OutrosAssuntos/zZz"
echo "Alteração de permissões concluida!"
}

function discosStdby {
clear
echo "  ____________________________________________________"
echo "||          Colocando discos em Stand by...           ||"
echo "||____________________________________________________||"
echo
sudo hdparm -y /dev/sdc
sudo hdparm -y /dev/sdd
sudo hdparm -y /dev/sde
sudo hdparm -y /dev/sdf
sudo hdparm -y /dev/sdg
sudo hdparm -C /dev/sdc
sudo hdparm -C /dev/sdd
sudo hdparm -C /dev/sde
sudo hdparm -C /dev/sdf
sudo hdparm -C /dev/sdg
sudo hdparm -C /dev/sdi
echo " Tarefa concluída !"
}

function discosSleep {
clear
echo "  ____________________________________________________"
echo "||          Colocando discos em Sleep ...             ||"
echo "||____________________________________________________||"
echo
sudo hdparm -Y /dev/sdc
sudo hdparm -Y /dev/sdd
sudo hdparm -Y /dev/sde
sudo hdparm -Y /dev/sdf
sudo hdparm -Y /dev/sdg
sudo hdparm -C /dev/sdc
sudo hdparm -C /dev/sdd
sudo hdparm -C /dev/sde
sudo hdparm -C /dev/sdf
sudo hdparm -C /dev/sdg
sudo hdparm -C /dev/sdi
echo " Tarefa concluída !"
}

function discosUmount () {
clear
sudo chmod -R 777 /media/DISC01/lost+found/
sudo chmod -R 777 /media/DISC02/lost+found/
sudo chmod -R 777 /media/DISC03/lost+found/
sudo chmod -R 777 /media/DISC04/lost+found/
sudo chmod -R 777 /media/DISC05/lost+found/
sudo chmod -R 777 /media/DISC06/lost+found/
sudo chmod -R 777 /media/DISC99/lost+found/

echo "  ____________________________________________________"
echo "||          Desmontando Disco 01 ....                 ||"
echo "||____________________________________________________||"
echo
umount /media/DISC01
echo "  ____________________________________________________"
echo "||          Desmontando Disco 02 ....                 ||"
echo "||____________________________________________________||"
echo
umount /media/DISC02
echo "  ____________________________________________________"
echo "||          Desmontando Disco 03 ....                 ||"
echo "||____________________________________________________||"
echo
umount /media/DISC03
echo "  ____________________________________________________"
echo "||          Desmontando Disco 04 ....                 ||"
echo "||____________________________________________________||"
echo
umount /media/DISC04
echo "  ____________________________________________________"
echo "||          Desmontando Disco 05 ....                 ||"
echo "||____________________________________________________||"
echo
umount /media/DISC05
echo "  ____________________________________________________"
echo "||          Desmontando Disco 06 ....                 ||"
echo "||____________________________________________________||"
echo
umount /media/DISC06
echo "  ____________________________________________________"
echo "||          Desmontando Disco 99 ....                 ||"
echo "||____________________________________________________||"
echo
umount /media/DISC99

echo " Tarefa concluida !"

}

hdCheck () {
		OLD_IFS="${IFS}"
		IFS=$'\n'
		ARRAY=(`ls /dev/sd* | grep 1 | sed -e /sda/d`)
		COUNT=${#ARRAY[@]}
		for i in ${ARRAY[*]}; do
			DISCO="$i"
			echo A processar $DISCO ...
			sudo umount $DISCO
			sudo /sbin/e2fsck -f -y -v $DISCO
		done
		IFS=OLD_IFS
	}


#######################################################
#                      MENUS                          #
#######################################################

function menuDesliga {
let "loopd=0"
while test $loopd == 0
do
clear
echo "    _____________________________________________________________"
echo "  ||                           MENU DESLIGAR                     ||"
echo "  ||_____________________________________________________________||"
echo "  ||                                                             ||"
echo "  ||                                                             ||"
echo "  ||   [7] Alterar atributos dos ficheiros para 755 e desligar   ||"
echo "  ||   [C] Realizar copia de segurança e desligar                ||"
echo "  ||   [D] Verificar integridades dos discos e desligar          ||"
echo "  ||   [R] Remover ficheiros indesejados e desligar              ||"
echo "  ||   [T] Fazer todas as anteriores e desligar                  ||"
echo "  ||                                                             ||"
echo "  ||   [M] Menu Principal                                        ||"
echo "  ||_____________________________________________________________||"
echo "     ==========================================================="
echo
echo "Opção? " && read opcao
case $opcao in m|M)
let "loopd=1"
esac
case $opcao in 7)
atrib777
init 0
esac
case $opcao in c|C)
copia
init 0
esac
case $opcao in d|D)
hdCheck
init 0
esac
case $opcao in r|R)
remover
init 0
esac
case $opcao in t|T)
remover
atrib755
copia
hdCheck
init 0
esac
done
}

function menuCheck {
let "loopc=0"
while test $loopc == 0
do
clear
echo "    ____________________________________________________"
echo "  ||                    MENU STORAGE                    ||"
echo "  ||____________________________________________________||"
echo "  ||                                                    ||"
echo "  ||                                                    ||"
echo "  ||   [1] Verificar integridade do HD01                ||"
echo "  ||   [2] Verificar integridade do HD02                ||"
echo "  ||   [3] Verificar integridade do HD03                ||"
echo "  ||   [4] Verificar integridade do HD04                ||"
echo "  ||   [5] Verificar integridade do HD05                ||"
echo "  ||   [6] Verificar integridade do HD06                ||"
echo "  ||   [9] Verificar integridade do HD99                ||"
echo "  ||   [T] Verificar integridade de todos               ||"
echo "  ||   [S] Colocar os discos em Stand by                ||"
echo "  ||   [A] Colocar os discos em Sleep                   ||"
echo "  ||   [D] Desmontar todos os discos                    ||"
echo "  ||                                                    ||"
echo "  ||   [M] Menu Principal                               ||"
echo "  ||____________________________________________________||"
echo "     =================================================="
echo
echo "Opção? " && read opcao
case $opcao in m|M)
let "loopc=1"
esac
case $opcao in 1)
hd1Check
read -p "Precione alguma tecla para continuar"
esac
case $opcao in 2)
hd2Check
read -p "Precione alguma tecla para continuar"
esac
case $opcao in 3)
hd3Check
read -p "Precione alguma tecla para continuar"
esac
case $opcao in 4)
hd4Check
read -p "Precione alguma tecla para continuar"
esac
case $opcao in 5)
hd5Check
read -p "Precione alguma tecla para continuar"
esac
case $opcao in 6)
hd6Check
read -p "Precione alguma tecla para continuar"
esac
case $opcao in 9)
hd7Check
read -p "Precione alguma tecla para continuar"
esac
case $opcao in t|T)
hdCheck
read -p "Precione alguma tecla para continuar"
esac
case $opcao in s|S)
discosStdby
read -p "Precione alguma tecla para continuar"
esac
case $opcao in a|A)
discosSleep
read -p "Precione alguma tecla para continuar"
esac
case $opcao in d|D)
discosUmount
read -p "Precione alguma tecla para continuar"
esac

done
}

function menuAtrib {
let "loopa=0"
while test $loopa == 0
do
clear
echo "    ____________________________________________________"
echo "  ||                  MENU ATRIBUTOS                    ||"
echo "  ||____________________________________________________||"
echo "  ||                                                    ||"
echo "  ||                                                    ||"
echo "  ||   [7] Alterar atributos dos ficheiros para 777     ||"
echo "  ||   [5] Alterar atributos dos ficheiros para 755     ||"
echo "  ||   [Z] Desbloquear zZz                              ||"
echo "  ||                                                    ||"
echo "  ||   [M] Menu Principal                               ||"
echo "  ||____________________________________________________||"
echo "     =================================================="
echo
echo "Opção? " && read opcao
case $opcao in m|M)
let "loopa=1"
esac
case $opcao in 7)
atrib777
read -p "Precione alguma tecla para continuar"
esac
case $opcao in 5)
atrib755
read -p "Precione alguma tecla para continuar"
esac
case $opcao in z|Z)
zZz
read -p "Precione alguma tecla para continuar"
esac
done
}

identificaDiscos
exit 0

let "loop=0"
while test $loop == 0
do
clear
echo "    ____________________________________________________"
echo "  ||                  MENU PRINCIPAL                    ||"
echo "  ||____________________________________________________||"
echo "  ||                                                    ||"
echo "  ||                                                    ||"
echo "  ||   [R] Remover Ficheiros indesejados                ||"
echo "  ||   [C] Realizar copia de segurança (2=>5)           ||"
echo "  ||   [L] Actualizar db do comando locate              ||"
echo "  ||   [A] Menu para Alterar atributos dos ficheiros    ||"
echo "  ||   [S] Menu de manutenção do Storage                ||"
echo "  ||   [D] Menu para Desligar                           ||"
echo "  ||   [T] Tudo [R][C][L][F][S][A](com Atributos 755)   ||"
echo "  ||                                                    ||"
echo "  ||                                                    ||"
echo "  ||   Pressione [Q] para Sair                          ||"
echo "  ||____________________________________________________||"
echo "     =================================================="
echo
echo "Opção? " && read opcao
case $opcao in q|Q)
let "loop=1"
esac
case $opcao in r|R)
remover
read -p "Precione alguma tecla para continuar"
esac
case $opcao in a|A)
menuAtrib
esac
case $opcao in c|C)
copia
read -p "Precione alguma tecla para continuar"
esac
case $opcao in s|S)
menuCheck
esac
case $opcao in l|L)
actualiza
esac
case $opcao in t|T)
remover
conteudo
atrib755
copia
hdCheck
read -p "Precione alguma tecla para continuar"
esac
case $opcao in d|D)
menuDesliga
esac
done
exit
fi


