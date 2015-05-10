#!/bin/bash
# youtube2mp3.sh
# j.francisco.o.rocha@gmail.com
# 05/2012

FFMPEG=`which ffmpeg`
if [ "$FFMPEG" = "" ] ; then
	echo "Porfavor instale ffmpeg.";
	exit 0;
fi

ZENITY=`which zenity`
if [ "$ZENITY" = "" ] ; then
	echo "Porfavor instale zenity.";
	exit 0;
fi

YOUTUBEDL=`which youtube-dl`
if [ "$YOUTUBEDL" = "" ] ; then
	sudo add-apt-repository ppa:nilarimogard/webupd8;
	sudo apt-get update;
	sudo apt-get install youtube-dl;
	echo "Porfavor instale youtube-dl.";
fi

ID3V2=`which id3v2`
if [ "$ID3V2" = "" ] ; then
	echo "Porfavor instale id3v2.";
	exit 0;
fi

MP3GAIN=`which mp3gain`
if [ "$MP3GAIN" = "" ] ; then
	echo "Porfavor instale mp3gain.";
	exit 0;
fi

# sudo add-apt-repository ppa:gstreamer-developers/ppa && sudo apt-get update && sudo apt-get upgrade
# sudo apt-get -f install
# sudo apt-get install gstreamer0.10-plugins-bad


Y_TEMP=~/.youtube-dl-$RANDOM-$RANDOM.flv

BITRATE="256k"
# 128k 192k 256k 320k

regex='v=(.*)'

IFS=$'\n'

function menProgFechado () {
	zenity --error --text "O programa foi cancelado" --title="YouTube MP3 Extractor"
	exit 0
	}

function limparPtCode () {
	limparPtCode=$(echo -e "$1" | sed -e '{
							s/á/a/g
							s/é/e/g
							s/í/i/g
							s/ó/o/g
							s/ú/u/g
							s/à/a/g
							s/è/e/g
							s/ì/i/g
							s/ò/o/g
							s/ù/u/g
							s/ã/a/g
							s/ẽ/e/g
							s/õ/o/g
							s/â/a/g
							s/ê/e/g
							s/ü/u/g
							s/û/u/g
							s/Á/A/g
							s/É/E/g
							s/Í/I/g
							s/Ó/O/g
							s/Ú/U/g
							s/À/A/g
							s/È/E/g
							s/Ì/I/g
							s/Ò/O/g
							s/Ù/U/g
							s/Ã/A/g
							s/Ẽ/E/g
							s/Õ/O/g
							s/Â/A/g
							s/Ê/E/g
							s/Ü/U/g
							s/Û/U/g}')
	}

function ConvYoutube () {
ping -c 1 www.google.com
if [ $? -eq 0 ] ; then
	dest_dir=$(zenity --file-selection=/home/francisco/Música/ --title="YouTube MP3 Extractor | Seleccione o destino dos MP3" --directory)
	if [[ $? != 0 ]]; then
	#menProgFechado
	exit 0;
	fi
	Y_ADDRESS=( `zenity --width=400 --height=130  --text-info --editable --title="YouTube MP3 Extractor | Escreva os URL's Youtube" --text "Escreva o(s) endereço(s) Youtube e precione em OK!"` )
	if [[  $? == 0  ]]; then
for CONTADOR in $(seq 0 $((${#Y_ADDRESS[*]} - 1))); do
		if [[ ${Y_ADDRESS[$CONTADOR]} =~ $regex ]]; then
			video_id=${BASH_REMATCH[1]}
			video_id=$(echo $video_id | cut -d'&' -f1)
			video_title="$(youtube-dl --get-title ${Y_ADDRESS[$CONTADOR]})"
			video_title=$(zenity --width=400 --height=130 --title "YouTube MP3 Extractor | Validação" --entry --text "O ficheiro vai ser gerado...\nDestino:\n$dest_dir\nO nome sugerido é:\n$video_title\nDepois de validar precione [Ok]\nFormato correcto: Artista - Musica" --entry-text "$video_title")
			if [[ $? != 0 ]]; then
			#menProgFechado
			exit 0;
			fi
			artista=$(echo "$video_title" | sed -e 's/ - /-/g' | awk -F'-' '{ print $1 }')
			titulo=$(echo "$video_title" | sed -e 's/ - /-/g' | awk -F'-' '{ print $2 }')	
			coproc zenity  --width=400 --height=130 --progress --auto-close --title="YouTube MP3 Extractor | $artista - $titulo" --text='A iniciar...'
			echo 10 >&${COPROC[1]}
			echo '#A descarregar do Youtube...' >&${COPROC[1]}
			youtube-dl --output=$Y_TEMP --format=18 "${Y_ADDRESS[$CONTADOR]}"
			echo 66 >&${COPROC[1]}
			echo '#A gerar MP3...' >&${COPROC[1]}
			#ffmpeg -i $Y_TEMP -acodec libmp3lame -ac 2 -ab $BITRATE -vn -y -metadata title="$titulo" -metadata artist="$artista" -metadata comment="ID:$video_id" "$dest_dir/$video_title.mp3"
			ffmpeg -i $Y_TEMP -acodec libmp3lame -ac 2 -ab $BITRATE -vn -y "$dest_dir/$video_title.mp3"			
			echo 88 >&${COPROC[1]}
			echo '#A gravar MP3 TAGS...' >&${COPROC[1]}
			limparPtCode "$artista"
			artista=$limparPtCode
			limparPtCode "$titulo"
			titulo=$limparPtCode
			id3v2 -2 --artist "$artista" --song "$titulo" --album "Singles" --comment "www.youtube.com/watch?v=$video_id" --WOAS "${Y_ADDRESS[$CONTADOR]}" --WOAF "${Y_ADDRESS[$CONTADOR]}" "$dest_dir/$video_title.mp3"
			rm $Y_TEMP
			echo 100 >&${COPROC[1]}      # Close Zenity and therefore the background task.
		else
			zenity --error --text "Desculpe o programa encontrou um problema no endereço:\n${Y_ADDRESS[$CONTADOR]}\nVerifique o endereço e volte a tentar..." --title="YouTube MP3 Extractor"
			exit 0;
		fi
done
	zenity --width=400 --height=130 --title "YouTube MP3 Extractor | Processo conluido" --question --text "Pode consultar os ficheiros MP3 gerados aqui:\nDestino:\n$dest_dir\nQuer converter mais musica?"
	if [ $? == 0 ]; then
	ConvYoutube
	fi
	else
	#menProgFechado
	exit 0;
	fi
else
	zenity --error --text "O programa foi cancelado.\nO acesso a internet esta com problemas\nVerifique e volte a tentar." --title="YouTube MP3 Extractor"
	exit 0;
fi
}

function normalizarMP3 () {
	dest_dir=$(zenity --file-selection=/home/francisco/Música/ --title="Normalizar MP3| Seleccione a localização dos MP3" --directory)
	if [[ $? != 0 ]]; then
	exit 0;
	fi
	find -L "$dest_dir" -mindepth 1 -maxdepth 100 -type f -iname "*.mp3" -exec mp3gain -r -m +4 -c {} \; | tee >(zenity --width=500 --height=300 --title="Normalizar MP3 | A processar ..." --text-info)
	}

# MENU
while true; do
	menu_launch="$(zenity  --width 400 --height 200 --title="Menu" --list --radiolist  --column "Opção" --column "Descrição" TRUE "YouTube MP3 Extractor" FALSE "Normaliza MP3")"
	if [[ $? != 0 ]]; then
	exit 0;
	fi
	if [ "$menu_launch" = "YouTube MP3 Extractor" ]; then
		`ConvYoutube $@`
	elif [ "$menu_launch" = "Normaliza MP3" ]; then
		`normalizarMP3 $@`
	else
		clear
		echo Opção Invalida
	fi
done
