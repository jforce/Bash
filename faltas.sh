#!/bin/sh

####################################################
# #
# Autor: Phillipe Smith #
# E-Mail: phillipe@archlinux.com.br #
# #
# Descricao: Programa para conversão entre alguns #
# formatos de vídeo #
# #
# OBS: Esteja a livre para modificar esse script #
# conforme sua necessidade. #
# #
####################################################


#DIALOG=`which Xdialog`
#DIALOG=`which dialog`
DIALOG= `which zenity`

XTERM="xterm -bg black -fg white -fa 'Terminal' -fs 11 -T Convertendo_Video........"

#Verificar a existência do Xdialog no sistema
if [ ! $DIALOG ];then
$XTERM -e echo "Xdialog não encontrado... Instale-o e depois execute novamente o script!"
exit 0
fi

#Verificar se existe o mencoder no sistema
if [ ! `which mencoder` ];then
$DIALOG --msgbox "Você deve instalar o MPLAYER para utilizar o script..." 10 50
exit 0
fi

#Verificar se existe o ffmpeg no sistema
if [ ! `which ffmpeg` ];then
$DIALOG --msgbox "É necessário o FFMPEG para execução do programa...." 10 50
exit 0
fi

convert() {

$DIALOG --title "Escolha o arquivo de vídeo" \
--fselect $HOME 40 150 2> /tmp/arq.tmp.$$
vdval=$?

if [ $vdval = 1 ]; then
exit 0
fi

arq=`cat /tmp/arq.tmp.$$ | tail -n 1 | cut -d"." -f1`

rm -rf /tmp/arq.tmp.*

$DIALOG --title "Opções" --radiolist "Escolha a operação desejada:" 30 50 0 \
"1" "AVI para RMVB" off \
"2" "AVI para MPG" off \
"3" "RMVB para AVI" off \
"4" "WMV para AVI" off \
"5" "MOV para AVI" off \
"6" "MPG para AVI" off \
"7" "OGV para AVI" off \
"8" "WMV para MPG" off \
"9" "FLV para MPG" off 2> /tmp/opt.tmp.$$

opval=$?

if [ $opval = 1 ];then
exit 0;
fi

opt=`cat /tmp/opt.tmp.$$ | tail -n 1`

rm -rf /tmp/opt.tmp.*

case $opt in
1) #De AVI para RMVB:
$XTERM -e mencoder $arq.avi -oac mp3lame -lameopts br=192 -ovc lavc -lavcopts vcodec=mpeg4:vhq -o $arq.rmvb
;;

2) #De AVI para MPG:
$XTERM -e mencoder $arq.avi -oac mp3lame -lameopts br=192 -ovc lavc -lavcopts vcodec=mpeg4:vhq -o $arq.mpg
;;

3) #De RMVB para AVI:
$XTERM -e mencoder $arq.rmvb -oac mp3lame -lameopts br=192 -ovc lavc -lavcopts vcodec=mpeg4:vhq -o $arq.avi
;;

4)#De WMV para AVI:
$XTERM -e mencoder $arq.wmv -ofps 23.976 -ovc lavc -oac copy -o $arq.avi
;;

5)#De MOV para AVI:
$XTERM -e mencoder -ovc lavc -lavcopts vcodec=mpeg4 -oac mp3lame -lameopts vbr=3 $arq.mov -o $arq.avi -v
;;

6)#De MPG para AVI:
$XTERM -e mencoder $arq.mpg -ovc xvid -oac mp3lame -xvidencopts bitrate=800 -o $arq.avi
;;

7)#De OGV para AVI:
$XTERM -e mencoder -idx $arq.ogv -ovc lavc -oac mp3lame -o $arq.avi
;;

8)#De WMV para MPG:
$XTERM -e mencoder $arq.wmv -ofps 23.976 -ovc lavc -oac copy -o $arq.mpg
;;

9)#De FLV para MPG:
$XTERM -e ffmpeg -i $arq.flv $arq.mpg
;;

*) exit 1
esac
}

$DIALOG --title "Video Converter" \
--ok-label "Prosseguir" --cancel-label "Cancelar" --yesno \
"Conversor para vários formatos populares de\n arquivos de vídeo" 10 60
inival=$?

if [ $inival = 1 ];then
exit 0
else
convert
fi

$DIALOG --title "Aviso!" --backtitle "Vídeo convertido com sucesso!" \
--yesno "Deseja converter outro vídeo?" 10 50
outraop=$?

if [ $outraop = 1 ];then
exit 0
else
convert
fi
