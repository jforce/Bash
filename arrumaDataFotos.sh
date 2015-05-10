#!/usr/bin/env bash
#------------------------------------------
# j.francisco.o.rocha@gmail.com
# ./arrumaPhotos.sh
# 08/2011
#------------------------------------------

declare IFS=$'\n'

if [[ ! -e $(which jhead) ]]; then
	echo -e '\E[1;37m\033[1mO comando exiftran esta a ser instalado no seu sistema...\033[0m'
	sudo apt-get --yes install jhead &> /dev/null
fi

if [[ ! -e $(which exiftran) ]]; then
	echo -e '\E[1;37m\033[1mO comando exiftran esta a ser instalado no seu sistema...\033[0m'
	sudo apt-get --yes install exiftran &> /dev/null
fi

if [[ ! -e $(which dialog) ]]; then
	echo -e '\E[1;37m\033[1mO comando dialog esta a ser instalado no seu sistema...\033[0m'
	sudo apt-get --yes install dialog &> /dev/null
fi


function origemFicheiros () {
	if [[ $dirOrigem = "" ]]; then
		dirOrigem=`dialog --stdout --title "Porfavor escolha a pasta origem" --backtitle "Aplicação para processar a data das Fotos" --dselect $HOME/  8 70`
	fi
limparCodeInvalid $dirOrigem
dirOrigem=$limparCodeInvalid
}

function validarData () {
mudeiData="Data modificada: Não"
jpgData=$(exiftran -d "$caminhoCompleto" | grep -i "0x9003" | egrep -o [0-9][0-9][0-9][0-9]:[0-9][0-9]:[0-9][0-9]) 1>&- 2>&-
if [ "$jpgData" == "" ]; then
	jpgFileData=$(stat -c %y "$caminhoCompleto" | awk -F'.' '{ print $1 }' | sed -e 's/-/:/g;s/ /-/g') 1>&- 2>&-
	#gravarData=`jhead -ts$jpgFileData $caminhoCompleto | egrep -o contains`
	mudeiData="Data modificada: Sim"
	if [[ "$gravarData" == "contains" ]]; then
		#jhead -de $caminhoCompleto
		#jhead -mkexif $caminhoCompleto
		#jhead -ts$jpgFileData $caminhoCompleto
		mudeiData="Data modificada: Sim"
	fi
	if [[ "$mudeiData" == "Data modificada: Sim" ]]; then
	echo "$jpgFileData;$caminhoCompleto" >> $HOME/listaFotosModificadas2.txt
	fi
	jpgData=$(exiftran -d "$caminhoCompleto" | grep -i "0x9003" | egrep -o [0-9][0-9][0-9][0-9]:[0-9][0-9]:[0-9][0-9] | sed -e 's/:/_/g') 1>&- 2>&-
fi
}

function processaFotos () {
	echo -e "Inicio de Processamento Fotos - $timeHoje\n-------------------------------------------------------------" &>> $HOME/arrumaDataFotos.log
	dirOrigemFicheiros=( `find "$dirOrigem" -mindepth 1 -maxdepth $dirNiveis -type f -iname "*.jpg" -o -iname "*.JPG" | sed -e '/OsMeusVideosFamiliares/d' | sed -e '/thumbnails/d'` ) &> /dev/null
	totalFicheiros=${#dirOrigemFicheiros[*]} &> /dev/null
	echo -e "Numero total de ficheiros a Processar=$totalFicheiros" &>> $HOME/arrumaDataFotos.log
	echo -e "Directorio Origem=$dirOrigem" &>> $HOME/arrumaDataFotos.log
	i=0

for caminhoCompleto in $( find "$dirOrigem" -mindepth 1 -maxdepth $dirNiveis -type f -iname "*.jpg" -o -iname "*.JPG" | sed -e '/OsMeusVideosFamiliares/d' | sed -e '/thumbnails/d' )
	do
	progress=$(( 100*(++i)/$totalFicheiros )) &> /dev/null
	echo $progress
	echo -e "OrigemComFicheiro: $caminhoCompleto" &>> $HOME/arrumaDataFotos.log
	echo -e "Formato de Data valida: $jpgData" &>> $HOME/arrumaDataFotos.log
	validarData
	echo "XXX"
	echo "A processar $totalFicheiros ficheiros...\nOrigem:$caminhoCompleto\n$mudeiData\nData:$DATA"
	echo "XXX"
done
	echo -e "Fim do Processamento Fotos - $timeHoje\n----------------------------------------------------------\n" &>> $HOME/arrumaDataFotos.log
}

function dialogProcessarFotos () {
		origemFicheiros
		( processaFotos ) | dialog --title "Processando Ficheiros" --backtitle "Aplicação para processar as Fotos" --gauge "" 10 80
	}

function mensagemInicioProcessamento () {
continuar=n

dialog --title "Processando Ficheiros"  --backtitle "Aplicação para processar a data das Fotos" --clear --yesno "Esta aplicação processa o directorio escolhido processado a data das fotos (Os ficheiros originais não são alterados)\nQuer continuar?" 10 50
	case $? in
0)
 continuar=s
 echo "Decidiu continuar com a operação"
	;;
1)
 clear
 echo "Decidiu abortar a operação - Aplicação terminada normalmente"

	;;
255)
 clear
 echo "Decidiu abortar a operação - Aplicação terminada normalmente"

	;;
esac
	}

function mensagemFimProcessamento () {
	if [ "$opFotos" == "1" ]; then
		dialog --title "Processando Ficheiros"  --backtitle "Aplicação para processar as Fotos" --clear --msgbox "A tarefa foi concluida!" 10 50
	fi
	}

function fotos () {
	mensagemInicioProcessamento
	if [[ $continuar == "s" ]]
		then
		dialogProcessarFotos
	fi
	if [[ $processaAmbos == "n" ]]
		then
		mensagemFimProcessamento
	fi
	}


function verLogs () {
	if [[ -f "$HOME/arrumaDataFotos.log" ]]; then
		dialog --title "Log de processamento" --backtitle "Aplicação para processar a data das Fotos" --textbox "$HOME/arrumaDataFotos.log" 100 100
	else
		dialog --title "Log de processamento" --backtitle "Aplicação para processar a data das Fotos" --clear --msgbox "Não existe nenhum registo.\nProvavelmente ainda não executou nenhum processamento." 10 50
	fi
	}

function removerLogs () {
	dialog --title "Processando Ficheiros"  --backtitle "Aplicação para processar a data das Fotos" --clear --yesno "Esta prestes a remover o ficheiro:\n$HOME/arrumaDataFotos.log\nQuer continuar?" 10 50

case $? in

0)
	if [[ -f "$HOME/arrumaDataFotos.log" ]]; then
	rm -f $HOME/arrumaDataFotos.log
	mensagemFimProcessamento
	else
	dialog --title "Log de processamento" --backtitle "Aplicação para processar a data das Fotos" --clear --msgbox "Não existe nenhum registo!\nProvavelmente ainda não executou o processamento." 10 50
	fi

	;;
1)
 clear
 echo "Decidiu abortar a operação - Aplicação terminada normalmente"

	;;
255)
 clear
 echo "Decidiu abortar a operação - Aplicação terminada normalmente"

	;;
esac
	}

function limparCodeInvalid () {
	limparCodeInvalid=$(echo -e "$1" | sed -r 's/\/$//')
	}

function menuProcessamento () {

let "loop1=0"

while test $loop1 == 0
	do
	declare dirOrigem=""
	declare dirOrigemFicheiros=""
	declare totalFicheiros=""
	declare ficheiros=""
	declare dirDestino=""
	declare progress=""
	declare caminhoCompleto=""
	declare jpgFileName=""
	declare jpgData=""
	declare DATA=""
	declare dirNiveis=20
	declare i=""
	declare timeHoje=""
	declare continuar=""
	declare mudeiData=""
	timeHoje=$(date)

	opcao=$( dialog --stdout --title "Menu de Procressamento" --backtitle "Aplicação para processar a data das Fotos" --clear --menu 'Escolha uma opção:' 0 0 0 \
		F  'Processamento da data das [F]otos'    \
		C  '[C]onsultar historico de actividade'  \
		R  '[R]emover historico de actividade'    \
		S  '[S]air' )
		
	case $opcao in f|F)
	fotos
	esac
	case $opcao in c|C)
	verLogs
	esac
	case $opcao in r|R)
	removerLogs
	esac
	case $opcao in s|S)
	let "loop1=1"
	clear
	esac
	case $opcao in 255)
	let "loop1=1"
	clear
	esac
done
	}

menuProcessamento

exit 0
