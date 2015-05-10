#!/usr/bin/env bash
#------------------------------------------
# j.francisco.o.rocha@gmail.com
# ./arrumaPhotos.sh
# 08/2011
#------------------------------------------

declare IFS=$'\n'

if [[ ! -e $(which jhead) ]]; then
	echo -e '\E[1;37m\033[1mO comando exiftran esta a ser instalado no seu sistema...\033[0m'
	sudo apt-get --yes install jhead > /dev/null 2>&1
fi

if [[ ! -e $(which exiftran) ]]; then
	echo -e '\E[1;37m\033[1mO comando exiftran esta a ser instalado no seu sistema...\033[0m'
	sudo apt-get --yes install exiftran > /dev/null 2>&1
fi

if [[ ! -e $(which dialog) ]]; then
	echo -e '\E[1;37m\033[1mO comando dialog esta a ser instalado no seu sistema...\033[0m'
	sudo apt-get --yes install dialog > /dev/null 2>&1
fi

function origemFicheiros () {
	if [[ $dirOrigem = "" ]]; then
		if [ "$processaAmbos" == "S" ]; then
			dirOrigem=`dialog --stdout --title "Porfavor escolha a pasta origem" --backtitle "Aplicação para processar as Fotos e Videos" --dselect $HOME/  8 70`
		fi
	fi
	if [[ $dirOrigem = "" ]]; then
		if [ "$opFotos" == "1" ]; then
			dirOrigem=`dialog --stdout --title "Porfavor escolha a pasta origem" --backtitle "Aplicação para processar as Fotos" --dselect $HOME/  8 70`
		fi
		if [ "$opVideos" == "1" ]; then
			dirOrigem=`dialog --stdout --title "Porfavor escolha a pasta origem" --backtitle "Aplicação para processar os Videos" --dselect $HOME/  8 70`
		fi
	fi
limparCodeInvalid $dirOrigem
dirOrigem=$limparCodeInvalid
}

function destinoFicheiros () {
	if [[ $dirOrigem = "" ]]; then
		if [ "$processaAmbos" == "S" ]; then
			dirDestino=`dialog --stdout --title "Porfavor escolha a pasta destino" --backtitle "Aplicação para processar as Fotos e Videos" --dselect $dirOrigem/  8 70`
		fi
	fi
	if [[ $dirDestino = "" ]]; then
		if [ "$opFotos" == "1" ]; then
			dirDestino=`dialog --stdout --title "Porfavor escolha a pasta destino"  --backtitle "Aplicação para processar as Fotos"  --dselect $dirOrigem/  8 70`
		fi
		if [ "$opVideos" == "1" ]; then
			dirDestino=`dialog --stdout --title "Porfavor escolha a pasta destino"  --backtitle "Aplicação para processar os Videos"  --dselect $dirOrigem/  8 70`
		fi
	fi
limparCodeInvalid $dirDestino
dirDestino=$limparCodeInvalid
	if [[ ! -f "$dirDestino" ]]; then
		mkdir -p "$dirDestino"
	fi
}

function validarData () {
if [ "$opFotos" == "1" ]; then
	mudeiData="Data modificada: Não"
	jpgData=$(exiftran -d "$caminhoCompleto" | grep -i "0x9003" | egrep -o [0-9][0-9][0-9][0-9]:[0-9][0-9]:[0-9][0-9] | sed -e 's/:/_/g') > /dev/null 2>&1
		if [ "$jpgData" == "" ]; then
			jpgFileData=$(stat -c %y "$caminhoCompleto" | awk -F'.' '{ print $1 }' | sed -e 's/-/:/g;s/ /-/g') > /dev/null 2>&1
			gravarData=`jhead -ts$jpgFileData $caminhoCompleto | egrep -o contains`
			mudeiData="Data modificada: Sim"
			if [[ "$gravarData" == "contains" ]]; then
				jhead -de $caminhoCompleto
				jhead -mkexif $caminhoCompleto
				jhead -ts$jpgFileData $caminhoCompleto
				mudeiData="Data modificada: Sim"
			fi
			if [[ "$mudeiData" == "Data modificada: Sim" ]]; then
			echo "Data Modificada;$jpgFileData;$caminhoCompleto" &>> $HOME/arrumaPhotosVideos.log
			fi
			jpgData=$(exiftran -d "$caminhoCompleto" | grep -i "0x9003" | egrep -o [0-9][0-9][0-9][0-9]:[0-9][0-9]:[0-9][0-9] | sed -e 's/:/_/g') > /dev/null 2>&1
		fi
	DATA=$(echo $jpgData | sed -e 's/_//g') > /dev/null 2>&1
fi
if [ "$opVideos" == "1" ]; then
	aviData=$(stat -c %y "$caminhoCompleto" | awk -F' ' '{ print $1 }' | sed -e 's/-/_/g') > /dev/null 2>&1
	DATA=$(echo $aviData | sed -e 's/_//g') > /dev/null 2>&1
fi
}

function processaFotos () {
	echo -e "Inicio de Processamento Fotos - $timeHoje\n-------------------------------------------------------------" &>> $HOME/arrumaPhotosVideos.log
	dirOrigemFicheiros=( `find "$dirOrigem" -mindepth 1 -maxdepth $dirNiveis -type f -iname "*.jpg" -o -iname "*.JPG" | sed -e '/AsMinhasFotos/d' | sed -e '/OsMeusVideosFamiliares/d' | sed -e '/thumbnails/d'` ) &> /dev/null
	totalFicheiros=${#dirOrigemFicheiros[*]} > /dev/null 2>&1
	echo -e "Numero total de ficheiros a Processar=$totalFicheiros" &>> $HOME/arrumaPhotosVideos.log
	echo -e "Directorio Origem=$dirOrigem" &>> $HOME/arrumaPhotosVideos.log
	echo -e "Directorio Destino=$dirDestino/AsMinhasFotos" &>> $HOME/arrumaPhotosVideos.log
	i=0

for caminhoCompleto in $( find "$dirOrigem" -mindepth 1 -maxdepth $dirNiveis -type f -iname "*.jpg" -o -iname "*.JPG" | sed -e '/AsMinhasFotos/d' | sed -e '/OsMeusVideosFamiliares/d' | sed -e '/thumbnails/d' )
	do
	progress=$(( 100*(++i)/$totalFicheiros )) > /dev/null 2>&1
	echo $progress
	jpgFileName=$(echo -e "$caminhoCompleto" | awk -F'/' '{print $NF}') > /dev/null 2>&1
	validarData
	echo -e "OrigemComFicheiro: $caminhoCompleto" &>> $HOME/arrumaPhotosVideos.log
	echo -e "Destino: $dirDestino/AsMinhasFotos" &>> $HOME/arrumaPhotosVideos.log
	echo -e "Ficheiro: $jpgFileName" &>> $HOME/arrumaPhotosVideos.log
	echo -e "Data: $jpgData" &>> $HOME/arrumaPhotosVideos.log
	if date --date="$DATA" > /dev/null 2>&1
		then
		echo -e "Formato de Data valida" &>> $HOME/arrumaPhotosVideos.log
		echo -e "Data: $jpgData" &>> $HOME/arrumaPhotosVideos.log
		if [[ ! -d "$dirDestino/AsMinhasFotos/$jpgData" ]]; then
		echo -e A criar "$dirDestino/AsMinhasFotos/$jpgData" &>> $HOME/arrumaPhotosVideos.log
		mkdir -p "$dirDestino/AsMinhasFotos/$jpgData" &>> $HOME/arrumaPhotosVideos.log
		fi
			if [[ ! -f "$dirDestino/AsMinhasFotos/$jpgData/$jpgFileName" ]]; then
			echo -e A copiar "$caminhoCompleto" para "$dirDestino/AsMinhasFotos/$jpgData\n" &>> $HOME/arrumaPhotosVideos.log
			cp "$caminhoCompleto" "$dirDestino/AsMinhasFotos/$jpgData" > /dev/null 2>&1
			echo "XXX"
			echo "A copiar $totalFicheiros ficheiros...\nOrigem:$caminhoCompleto\nDestino:$dirDestino/AsMinhasFotos/$jpgData\n$mudeiData"
			echo "XXX"
			else
			echo "XXX"
			echo "A copiar $totalFicheiros ficheiros...\nOperação sem sucesso! - O Ficheiro $jpgFileName já existe no destino!"
			echo "XXX"
			echo -e "Operação sem sucesso! - O ficheiro $jpgFileName já existe no destino!\n" &>> $HOME/arrumaPhotosVideos.log
			fi
		else
		echo -e "O ficheiro $jpgFileName tem data com formato invalido!\n" &>> $HOME/arrumaPhotosVideos.log
	fi
done
	echo -e "Fim do Processamento Fotos - $timeHoje\n----------------------------------------------------------\n" &>> $HOME/arrumaPhotosVideos.log
}

function processaVideos () {
	echo -e "Inicio de Processamento Videos Familiares - $timeHoje\n--------------------------------------------------------------" &>> $HOME/arrumaPhotosVideos.log
	dirOrigemFicheiros=( `find "$dirOrigem" -mindepth 1 -maxdepth $dirNiveis -type f -iname "*.mpg" -o -iname "*.MPG" -o -iname "*.mp4" -o -iname "*.MP4" | sed -e '/AsMinhasFotos/d' | sed -e '/OsMeusVideosFamiliares/d' | sed -e '/thumbnails/d'` ) &> /dev/null
	totalFicheiros=${#dirOrigemFicheiros[*]} > /dev/null 2>&1
	echo -e "Numero total de videos a processar=$totalFicheiros" &>> $HOME/arrumaPhotosVideos.log
	i=0

for caminhoCompleto in $(find "$dirOrigem" -mindepth 1 -maxdepth $dirNiveis -type f -iname "*.mpg" -o -iname "*.MPG" -o -iname "*.mp4" -o -iname "*.MP4" | sed -e '/AsMinhasFotos/d' | sed -e '/OsMeusVideosFamiliares/d' | sed -e '/thumbnails/d' )
	do
	progress=$(( 100*(++i)/$totalFicheiros )) > /dev/null 2>&1
	echo $progress
	aviFileName=$(echo -e "$caminhoCompleto" | awk -F'/' '{print $NF}') > /dev/null 2>&1
	validarData
	echo -e "OrigemComFicheiro: $caminhoCompleto" &>> $HOME/arrumaPhotosVideos.log
	echo -e "Destino: $dirDestino/OsMeusVideosFamiliares" &>> $HOME/arrumaPhotosVideos.log
	echo -e "Ficheiro: $aviFileName" &>> $HOME/arrumaPhotosVideos.log
	echo -e "Data: $aviData" &>> $HOME/arrumaPhotosVideos.log
	if date --date="$DATA" > /dev/null 2>&1
		then
		echo -e "Formato de Data valida" &>> $HOME/arrumaPhotosVideos.log
		if [[ ! -d "$dirDestino/OsMeusVideosFamiliares/$aviData/" ]]; then
		echo -e A criar "$dirDestino/OsMeusVideosFamiliares/$aviData/" &>> $HOME/arrumaPhotosVideos.log
		mkdir -p "$dirDestino/OsMeusVideosFamiliares/$aviData/" &>> $HOME/arrumaPhotosVideos.log
		fi
			if [[ ! -f "$dirDestino/OsMeusVideosFamiliares/$aviData/$aviFileName" ]]; then
			echo -e A copiar "$caminhoCompleto" para "$dirDestino/OsMeusVideosFamiliares/$aviData/\n" &>> $HOME/arrumaPhotosVideos.log
			cp "$caminhoCompleto" "$dirDestino/OsMeusVideosFamiliares/$aviData" > /dev/null 2>&1
			echo "XXX"
			echo "A copiar $totalFicheiros ficheiros...\nOrigem:$caminhoCompleto\nDestino:$dirDestino/OsMeusVideosFamiliares/$aviData"
			echo "XXX"
			else
			echo "XXX"
			echo "A copiar $totalFicheiros ficheiros...\nOperação sem sucesso! - O Ficheiro $aviFileName já existe no destino!"
			echo "XXX"
			echo -e "Operação sem sucesso - O ficheiro $aviFileName já existe no destino!\n" &>> $HOME/arrumaPhotosVideos.log
			fi
		else
		echo -e "O ficheiro $aviFileName tem data com formato invalido!\n" &>> $HOME/arrumaPhotosVideos.log
	fi
done
	echo -e "Fim do Processamento Videos Familiares - $timeHoje\n-----------------------------------------------------------\n" &>> $HOME/arrumaPhotosVideos.log
}

function dialogProcessarFotos () {
		origemFicheiros
		destinoFicheiros
		( processaFotos ) | dialog --title "Processando Ficheiros" --backtitle "Aplicação para processar as Fotos" --gauge "" 10 80
	}

function dialogProcessarVideos () {
		origemFicheiros
		destinoFicheiros
		( processaVideos ) | dialog --title "Processando Ficheiros" --backtitle "Aplicação para processar os Videos" --gauge "" 10 80
	}

function mensagemInicioProcessamento () {
continuar=n

dialog --title "Processando Ficheiros"  --backtitle "Aplicação para processar as Fotos e Videos" --clear --yesno "Esta aplicação tranfere os ficheiros da sua origem para o destino (Os ficheiros originais não são alterados)\nQuer continuar?" 10 50
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
	if [ "$opVideos" == "1" ]; then
		dialog --title "Processando Ficheiros"  --backtitle "Aplicação para processar os Videos" --clear --msgbox "A tarefa foi concluida!" 10 50
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

function videos () {
	if [[ $processaAmbos == "s" ]]; then
		continuar=s
	else
		mensagemInicioProcessamento
	fi
	if [[ $continuar == "s" ]];	then
		dialogProcessarVideos
		mensagemFimProcessamento
	fi
	}

function verLogs () {
	if [[ -f "$HOME/arrumaPhotosVideos.log" ]]; then
		dialog --title "Log de processamento" --backtitle "Aplicação para processar as Fotos e Videos" --textbox "$HOME/arrumaPhotosVideos.log" 100 100
	else
		dialog --title "Log de processamento" --backtitle "Aplicação para processar as Fotos e Videos" --clear --msgbox "Não existe nenhum registo.\nProvavelmente ainda não executou nenhum processamento." 10 50
	fi
	}

function removerLogs () {
	dialog --title "Processando Ficheiros"  --backtitle "Aplicação para processar as Fotos e Videos" --clear --yesno "Esta prestes a remover o ficheiro:\n$HOME/arrumaPhotosVideos.log\nQuer continuar?" 10 50

case $? in

0)
	if [[ -f "$HOME/arrumaPhotosVideos.log" ]]; then
	rm -f $HOME/arrumaPhotosVideos.log
	mensagemFimProcessamento
	else
	dialog --title "Log de processamento" --backtitle "Aplicação para processar as Fotos e Videos" --clear --msgbox "Não existe nenhum registo!\nProvavelmente ainda não executou o processamento." 10 50
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
	declare aviFileName=""
	declare jpgData=""
	declare aviData=""
	declare DATA=""
	declare dirNiveis=20
	declare i=""
	declare timeHoje=""
	declare continuar=""
	declare processaAmbos=""
	declare opFotos=""
	declare opVideos=""
	timeHoje=$(date)

	opcao=$( dialog --stdout --title "Menu de Procressamento" --backtitle "Aplicação para processar as Fotos e Videos" --clear --menu 'Escolha uma opção:' 0 0 0 \
		F  'Processamento de [F]otos'             \
		V  'Processamento de [V]ideos'            \
		A  'Processamento [A]mbos (Fotos Videos)' \
		C  '[C]onsultar historico de actividade'  \
		R  '[R]emover historico de actividade'    \
		S  '[S]air' )

	case $opcao in f|F)
	processaAmbos=n
	opFotos=1
	fotos
	esac
	case $opcao in v|V)
	processaAmbos=n
	opVideos=1
	videos
	esac
	case $opcao in a|A)
	processaAmbos=s
	opFotos=1
	opVideos=1
	fotos
	videos
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
