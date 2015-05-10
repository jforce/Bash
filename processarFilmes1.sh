#!/usr/bin/env bash
#! autor: j.francisco.o.rocha@gmail.com
#! processarFilmes.sh
#! 04/2010

####################################
# Global variable declarations INI #
#								   #
shopt -s -o nounset
declare -rx SCRIPT=${0##*/}
declare dirDiscos="/media"
declare dirNiveis=5
declare IFS=$'\n'
#								   #
# Global variable declarations END #
####################################

############################
####  INI TESTES GERAIS ####
############################
# TESTE ROOT
if [ "$(id -u)" != "0" ]; then
	clear
	echo -e '\E[1;37m\033[1mDesculpe tem de executar este comando com o sudo.\033[0m'
	sudo su
#	exit 1
fi
# TESTE dialog
if [ "$(dpkg -l | grep -i "ii  dialog" | awk -F '  ' '{print $2}' 2>/dev/null)" != "dialog" ]; then
	echo -e '\E[1;37m\033[1mInstalando o comando dialog...\033[0m'
	apt-get install dialog -y > /dev/null
fi

# TESTE sed
if [ "$(dpkg -l | grep -i "ii  sed" | awk -F '  ' '{print $2}' 2>/dev/null)" != "sed" ]; then
	echo -e '\E[1;37m\033[1mInstalando o comando sed...\033[0m'
	apt-get install sed -y > /dev/null
fi

# TESTE ffmpeg
if [ "$(dpkg -l | grep -i "ii  ffmpeg " | awk -F '  ' '{print $2}' 2>/dev/null)" != "ffmpeg" ]; then
	echo -e '\E[1;37m\033[1mInstalando o comando ffmpeg...\033[0m'
	apt-get install ffmpeg -y > /dev/null
fi

# TESTE imagemagick
if [ "$(dpkg -l | grep -i "ii  imagemagick" | awk -F '  ' '{print $2}' 2>/dev/null)" != "imagemagick" ]; then
	echo -e '\E[1;37m\033[1mInstalando o comando imagemagick...\033[0m'
	apt-get install imagemagick -y > /dev/null
fi



###########################
#### FIM TESTES GERAIS ####
###########################

function analizaFicheiro () {
	echo -e '\E[1;37m\033[1mProcessando as pastas ...\033[0m'
	faltaFicheiro=0
	pastaSFicheiroAnt=0
	for caminhoCompleto in $(find "$dirDiscos" -mindepth 1 -maxdepth $dirNiveis -type f \
							\(\
							   -iname "*.rm" -o \
							   -iname "*.asf" -o \
							   -iname "*.mp4" -o \
							   -iname "*.wmv" -o \
							   -iname "*.avi" -o \
							   -iname "*.flv" -o \
							   -iname "*.iso" -o \
							   -iname "*.vob" -o \
							   -iname "*.mkv" -o \
							   -iname "*.m4u" -o \
							   -iname "*.mpg" -o \
							   -iname "*.mpeg" -o \
							   -iname "*.rmvb" \) | grep OsMeusFilmes | sed -e '/OsMeusFilmesInfantis/ d')
	do
	pastaSFicheiro=$(echo "$caminhoCompleto" | sed 's/\(.*\)./\1/' | awk -F'/' '{for(i=1;i<NF-1;++i)printf $i"/";print $i;}'| sed -e 's/  //g' | sed -e 's/\/VIDEO_TS//g')
		if [[ "$pastaSFicheiro" != "$pastaSFicheiroAnt" ]]; then
			if [[ ! -f "$pastaSFicheiro/$ficheiro" ]]; then
			echo "O ficheiro $pastaSFicheiro/$ficheiro não existe"
			faltaFicheiro=1
			fi
			pastaSFicheiroAnt=$pastaSFicheiro
		fi
	done
	if [ $faltaFicheiro = 0 ]; then
		echo -e '\E[1;37m\033[1mO ficheiro '"$ficheiro"' esta presente em todas as pastas.\033[0m'
		else
		echo -e '\E[1;37m\033[1mO ficheiro '"$ficheiro"' não esta presente em todas as pastas.\033[0m'
	fi
	}
	
function pacoteMinimo () {
	echo -e '\E[1;37m\033[1mProcessando as pastas ...\033[0m'
	
	ficheiro1=Folder.jpg
	ficheiro2=mymovies.xml
	ficheiro3=disc.png
	ficheiro4=backdrop.jpg
	ficheiro5=fanart.jpg
	faltaFicheiros=0
	faltaFicheiro1=0
	faltaFicheiro2=0
	faltaFicheiro3=0
	faltaFicheiro4=0
	faltaFicheiro5=0
	pastaSFicheiroAnt=0

	for caminhoCompleto in $(find "$dirDiscos" -mindepth 1 -maxdepth $dirNiveis -type f \
							\(\
							   -iname "*.rm" -o \
							   -iname "*.asf" -o \
							   -iname "*.mp4" -o \
							   -iname "*.wmv" -o \
							   -iname "*.avi" -o \
							   -iname "*.flv" -o \
							   -iname "*.iso" -o \
							   -iname "*.vob" -o \
							   -iname "*.mkv" -o \
							   -iname "*.m4u" -o \
							   -iname "*.mpg" -o \
							   -iname "*.mpeg" -o \
							   -iname "*.rmvb" \) | grep OsMeusFilmes | sed -e '/OsMeusFilmesInfantis/ d')
	do
	pastaSFicheiro=$(echo "$caminhoCompleto" | sed 's/\(.*\)./\1/' | awk -F'/' '{for(i=1;i<NF-1;++i)printf $i"/";print $i;}'| sed -e 's/  //g' | sed -e 's/\/VIDEO_TS//g')
		if [[ "$pastaSFicheiro" != "$pastaSFicheiroAnt" ]]; then
			if [[ ! -f "$pastaSFicheiro/$ficheiro1" ]]; then
			echo "O ficheiro $pastaSFicheiro/$ficheiro1 não existe"
			faltaFicheiros=1
			faltaFicheiro1=1
			fi
			if [[ ! -f "$pastaSFicheiro/$ficheiro2" ]]; then
			echo "O ficheiro $pastaSFicheiro/$ficheiro2 não existe"
			faltaFicheiros=1
			faltaFicheiro2=1
			fi
			if [[ ! -f "$pastaSFicheiro/$ficheiro3" ]]; then
			echo "O ficheiro $pastaSFicheiro/$ficheiro3 não existe"
			faltaFicheiro3=1
			fi
			if [[ ! -f "$pastaSFicheiro/$ficheiro4" ]]; then
			echo "O ficheiro $pastaSFicheiro/$ficheiro4 não existe"
			faltaFicheiro4=1
			fi
			if [[ ! -f "$pastaSFicheiro/$ficheiro5" ]]; then
			echo "O ficheiro $pastaSFicheiro/$ficheiro5 não existe"
			faltaFicheiro5=1
			fi
			pastaSFicheiroAnt=$pastaSFicheiro
		fi
	done
	if [ $faltaFicheiros = 0 ]; then
		echo -e '\E[1;37m\033[1mOs conteudos importantes estão presentes em todas as pastas.\033[0m'
		else
		echo -e '\E[1;37m\033[1mExistem conteudos importantes em falta em algumas pastas.\033[0m'
	fi
	}

function dirName () {
	ficheiro=mymovies.xml
	analizaFicheiro
	mudeiNomes=0
	if [ $faltaFicheiro = 0 ] ; then
		echo -e '\E[1;37m\033[1mProcessando as pastas ...\033[0m'
		for caminhoCompleto in $(find $dirDiscos -mindepth 1 -maxdepth $dirNiveis -type f -name "mymovies.xml" | grep mymovies.xml | sed -e 's/\/mymovies.xml//g' -e 's/  //g' )
		do	
		filme=$(cat $caminhoCompleto/mymovies.xml | grep LocalTitle | sed -e 's/<LocalTitle>//g' -e 's/<\/LocalTitle>//g' -e 's/.$//g' -e 's/://g'  -e 's/?//g' -e 's/\&amp\;/\&/'  -e 's/  //g')
		ano=$(cat $caminhoCompleto/mymovies.xml | grep ProductionYear | sed -e 's/<ProductionYear>//g' | sed -e 's/<\/ProductionYear>//g' | sed -e 's/.$//g' -e 's/^M//g' -e 's/  //g')
		pastaSFilme=$(echo "$caminhoCompleto" | sed 's/\(.*\)./\1/' | awk -F'/' '{for(i=1;i<NF-1;++i)printf $i"/";print $i}'| sed -e 's/  //g')
			if [ "$caminhoCompleto" != "$pastaSFilme/$filme ($ano)" ]; then
			mudeiNomes=1
			echo -e '\E[1;37m\033[1m##############\033[0m'
			echo -e '\E[1;37m\033[1m# Origem:'"$caminhoCompleto"'\033[0m'
			echo -e '\E[1;37m\033[1m# Destino:'"$pastaSFilme/$filme ($ano)"'\033[0m'
			echo -e '\E[1;37m\033[1m##############\033[0m'
			echo ""
			mv "$caminhoCompleto" "$pastaSFilme/$filme ($ano)"
			chown francisco:francisco "$pastaSFilme/$filme ($ano)"
			fi
		done
	else
		echo -e '\E[1;37m\033[1mO ficheiro mymovies.xml não existe em algumas pastas.\033[0m'
		echo -e '\E[1;37m\033[1mExecute a opção [V] para determinar onde esta ausente.\033[0m'	
	fi
	if [ $mudeiNomes = 0 ]; then
	echo -e '\E[1;37m\033[1mNão foram feitas alterações nos nomes dos filmes.\033[0m'
	fi
	}

function backdrop () {
	echo -e '\E[1;37m\033[1mFilmes com estructura ISO ou VIDEO_TS não são processados.\033[0m'
	echo -e '\E[1;37m\033[1mProcessando as pastas ...\033[0m'
	processarBackdrops=0
	for caminhoCompleto in $(find "$dirDiscos" -maxdepth $dirNiveis -type d | grep OsMeusFilmes | sed -e '/OsMeusFilmesInfantis/ d')
	do
			if [[ ! -f "$caminhoCompleto/backdrop.jpg" ]]; then
				for FILME in $(
					find "$caminhoCompleto/" -mindepth 1 -maxdepth 1 -type f \
						\(\
						   -iname "*.rm" -o \
						   -iname "*.asf" -o \
						   -iname "*.mp4" -o \
						   -iname "*.wmv" -o \
						   -iname "*.avi" -o \
						   -iname "*.flv" -o \
						   -iname "*.mkv" -o \
						   -iname "*.m4u" -o \
						   -iname "*.mpg" -o \
						   -iname "*.mpeg" -o \
						   -iname "*.rmvb" \))
				do
					if [[ ! -f "$caminhoCompleto/backdrop.jpg" ]]; then
					processarBackdrops=1
					DURACAO_FILME=( $(ffmpeg -i "$FILME" 2>&1 | sed -n "s/.* Duration: \([^,]*\), start: .*/\1/p") )
					TEMPO_TOT_FILME_SEG=( $(echo "$DURACAO_FILME" | awk -F':' '{ print $1*3600 + $2*60 + $3 }' | awk -F'.' '{print $1}'))
					TEMPO_DIV_FILME=( $(echo "$TEMPO_TOT_FILME_SEG" | awk '{ print $1 / 5 }' | awk -F'.' '{ print $1 }'))
					TEMPO_DIV_FILME4=( $(echo "$TEMPO_TOT_FILME_SEG" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
					TEMPO_DIV_FILME3=( $(echo "$TEMPO_DIV_FILME4" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
					TEMPO_DIV_FILME2=( $(echo "$TEMPO_DIV_FILME3" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
					TEMPO_DIV_FILME1=( $(echo "$TEMPO_DIV_FILME2" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
					echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop.jpg ...\033[0m'
					ffmpeg -ss "$TEMPO_DIV_FILME1" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop.jpg"  2>/dev/null
					chown francisco:francisco "$caminhoCompleto/backdrop.jpg"
					if [[ ! -f "$caminhoCompleto/fanart.jpg" ]]; then
						echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/fanart.jpg ...\033[0m'
						cp "$caminhoCompleto/backdrop.jpg" "$caminhoCompleto/fanart.jpg"
						chown francisco:francisco "$caminhoCompleto/fanart.jpg"
					fi
					echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop1.jpg ...\033[0m'
					ffmpeg -ss "$TEMPO_DIV_FILME2" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop1.jpg"  2>/dev/null
					chown francisco:francisco "$caminhoCompleto/backdrop1.jpg"
					echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop2.jpg ...\033[0m'
					ffmpeg -ss "$TEMPO_DIV_FILME3" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop2.jpg"  2>/dev/null
					chown francisco:francisco "$caminhoCompleto/backdrop2.jpg"
					echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop3.jpg ...\033[0m'
					ffmpeg -ss "$TEMPO_DIV_FILME4" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop3.jpg"  2>/dev/null
					chown francisco:francisco "$caminhoCompleto/backdrop3.jpg"
					else
						if [[ ! -f "$caminhoCompleto/backdrop4.jpg" ]]; then
						processarBackdrops=1
						DURACAO_FILME=( $(ffmpeg -i "$FILME" 2>&1 | sed -n "s/.* Duration: \([^,]*\), start: .*/\1/p") )
						TEMPO_TOT_FILME_SEG=( $(echo "$DURACAO_FILME" | awk -F':' '{ print $1*3600 + $2*60 + $3 }' | awk -F'.' '{print $1}'))
						TEMPO_DIV_FILME=( $(echo "$TEMPO_TOT_FILME_SEG" | awk '{ print $1 / 5 }' | awk -F'.' '{ print $1 }'))
						TEMPO_DIV_FILME4=( $(echo "$TEMPO_TOT_FILME_SEG" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
						TEMPO_DIV_FILME3=( $(echo "$TEMPO_DIV_FILME4" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
						TEMPO_DIV_FILME2=( $(echo "$TEMPO_DIV_FILME3" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
						TEMPO_DIV_FILME1=( $(echo "$TEMPO_DIV_FILME2" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
						echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop4.jpg ...\033[0m'
						ffmpeg -ss "$TEMPO_DIV_FILME1" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop4.jpg" 2>/dev/null
						chown francisco:francisco "$caminhoCompleto/backdrop4.jpg"
						echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop5.jpg ...\033[0m'
						ffmpeg -ss "$TEMPO_DIV_FILME2" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop5.jpg" 2>/dev/null
						chown francisco:francisco "$caminhoCompleto/backdrop5.jpg"
						echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop6.jpg ...\033[0m'
						ffmpeg -ss "$TEMPO_DIV_FILME3" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop6.jpg" 2>/dev/null
						chown francisco:francisco "$caminhoCompleto/backdrop6.jpg"
						echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop7.jpg ...\033[0m'
						ffmpeg -ss "$TEMPO_DIV_FILME4" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop7.jpg" 2>/dev/null
						chown francisco:francisco "$caminhoCompleto/backdrop7.jpg"
						else
							if [[ ! -f "$caminhoCompleto/backdrop8.jpg" ]]; then
							processarBackdrops=1
							DURACAO_FILME=( $(ffmpeg -i "$FILME" 2>&1 | sed -n "s/.* Duration: \([^,]*\), start: .*/\1/p") )
							TEMPO_TOT_FILME_SEG=( $(echo "$DURACAO_FILME" | awk -F':' '{ print $1*3600 + $2*60 + $3 }' | awk -F'.' '{print $1}'))
							TEMPO_DIV_FILME=( $(echo "$TEMPO_TOT_FILME_SEG" | awk '{ print $1 / 5 }' | awk -F'.' '{ print $1 }'))
							TEMPO_DIV_FILME4=( $(echo "$TEMPO_TOT_FILME_SEG" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
							TEMPO_DIV_FILME3=( $(echo "$TEMPO_DIV_FILME4" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
							TEMPO_DIV_FILME2=( $(echo "$TEMPO_DIV_FILME3" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
							TEMPO_DIV_FILME1=( $(echo "$TEMPO_DIV_FILME2" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
							echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop8.jpg ...\033[0m'
							ffmpeg -ss "$TEMPO_DIV_FILME1" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop8.jpg" 2>/dev/null
							chown francisco:francisco "$caminhoCompleto/backdrop8.jpg"
							echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop9.jpg ...\033[0m'
							ffmpeg -ss "$TEMPO_DIV_FILME2" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop9.jpg" 2>/dev/null
							chown francisco:francisco "$caminhoCompleto/backdrop9.jpg"
							echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop10.jpg ...\033[0m'
							ffmpeg -ss "$TEMPO_DIV_FILME3" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop10.jpg" 2>/dev/null
							chown francisco:francisco "$caminhoCompleto/backdrop10.jpg"
							echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop11.jpg ...\033[0m'
							ffmpeg -ss "$TEMPO_DIV_FILME4" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop11.jpg" 2>/dev/null
							chown francisco:francisco "$caminhoCompleto/backdrop11.jpg"
							else
								if [[ ! -f "$caminhoCompleto/backdrop12.jpg" ]]; then
								processarBackdrops=1
								DURACAO_FILME=( $(ffmpeg -i "$FILME" 2>&1 | sed -n "s/.* Duration: \([^,]*\), start: .*/\1/p") )
								TEMPO_TOT_FILME_SEG=( $(echo "$DURACAO_FILME" | awk -F':' '{ print $1*3600 + $2*60 + $3 }' | awk -F'.' '{print $1}'))
								TEMPO_DIV_FILME=( $(echo "$TEMPO_TOT_FILME_SEG" | awk '{ print $1 / 5 }' | awk -F'.' '{ print $1 }'))
								TEMPO_DIV_FILME4=( $(echo "$TEMPO_TOT_FILME_SEG" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
								TEMPO_DIV_FILME3=( $(echo "$TEMPO_DIV_FILME4" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
								TEMPO_DIV_FILME2=( $(echo "$TEMPO_DIV_FILME3" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
								TEMPO_DIV_FILME1=( $(echo "$TEMPO_DIV_FILME2" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
								echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop12.jpg ...\033[0m'
								ffmpeg -ss "$TEMPO_DIV_FILME1" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop12.jpg" 2>/dev/null
								chown francisco:francisco "$caminhoCompleto/backdrop12.jpg"
								echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop13.jpg ...\033[0m'
								ffmpeg -ss "$TEMPO_DIV_FILME2" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop13.jpg" 2>/dev/null
								chown francisco:francisco "$caminhoCompleto/backdrop13.jpg"
								echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop14.jpg ...\033[0m'
								ffmpeg -ss "$TEMPO_DIV_FILME3" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop14.jpg" 2>/dev/null
								chown francisco:francisco "$caminhoCompleto/backdrop14.jpg"
								echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop15.jpg ...\033[0m'
								ffmpeg -ss "$TEMPO_DIV_FILME4" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop15.jpg" 2>/dev/null
								chown francisco:francisco "$caminhoCompleto/backdrop15.jpg"
								fi
							fi
						fi
					fi
				done
			else
			if [[ ! -f "$caminhoCompleto/fanart.jpg" ]]; then
				echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/fanart.jpg ...\033[0m'
				cp "$caminhoCompleto/backdrop.jpg" "$caminhoCompleto/fanart.jpg"
				chown francisco:francisco "$caminhoCompleto/fanart.jpg"
			fi
		fi
	done
	if [ $processarBackdrops = 0 ]; then
		echo -e '\E[1;37m\033[1mNão foram encontrados filmes sem backdrops e fanart.\033[0m'
	fi
	}

function nfo () {
	echo -e '\E[1;37m\033[1mProcessando as pastas ...\033[0m'
	nfoProcessados=0
	for caminhoCompleto in $(find $dirDiscos -mindepth 1 -maxdepth $dirNiveis -type f -name "movie.nfo" | grep VIDEO_TS | sed -e '/OsMeusFilmesInfantis/ d')
	do
	nfoProcessados=1
	caminhoDestino=$(echo "$caminhoCompleto" | sed -e 's/\/VIDEO_TS\/movie.nfo//g')
	echo -e '\E[1;37m\033[1m##############\033[0m'
	echo -e '\E[1;37m\033[1m# Origem:'"$caminhoCompleto"'\033[0m'
	echo -e '\E[1;37m\033[1m# Destino:'"$caminhoDestino/movie.nfo"'\033[0m'
	echo -e '\E[1;37m\033[1m##############\033[0m'
	echo ""
	mv "$caminhoCompleto" "$caminhoDestino/movie.nfo"
	chown francisco:francisco "$caminhoDestino/movie.nfo"
	done
	if [ $nfoProcessados = 0 ]; then
		echo -e '\E[1;37m\033[1mNão foram processados ficheiros movie.nfo.\033[0m'
	fi
	}

function tbn () {
	ficheiro=mymovies.xml
	analizaFicheiro
	if [ $faltaFicheiro = 0 ] ; then
	ficheiro=Folder.jpg
	analizaFicheiro
	fi
	tnbProcessados=0
	if [ $faltaFicheiro = 0 ] ; then
		echo -e '\E[1;37m\033[1mProcessando as pastas ...\033[0m'
		for caminhoCompleto in $(find $dirDiscos -mindepth 1 -maxdepth $dirNiveis -type f -name "mymovies.xml" | grep mymovies.xml | sed -e 's/\/mymovies.xml//g' -e 's/  //g' | grep OsMeusFilmes | sed -e '/OsMeusFilmesInfantis/ d')
		do
		filme=$(cat $caminhoCompleto/mymovies.xml | grep LocalTitle | sed -e 's/<LocalTitle>//g' -e 's/<\/LocalTitle>//g' -e 's/.$//g' -e 's/://g'  -e 's/?//g' -e 's/\&amp\;/\&/'  -e 's/  //g')
		ano=$(cat $caminhoCompleto/mymovies.xml | grep ProductionYear | sed -e 's/<ProductionYear>//g' | sed -e 's/<\/ProductionYear>//g' | sed -e 's/.$//g' -e 's/^M//g' -e 's/  //g')
		pastaSFilme=$(echo "$caminhoCompleto" | sed 's/\(.*\)./\1/' | awk -F'/' '{for(i=1;i<NF-1;++i)printf $i"/";print $i}'| sed -e 's/  //g')
		if [[ ! -f "$caminhoCompleto/movie.tbn" ]]; then
			tnbProcessados=1
			echo -e '\E[1;37m\033[1m##############\033[0m'
			echo -e '\E[1;37m\033[1m# Origem:'"$caminhoCompleto/Folder.jpg"'\033[0m'
			echo -e '\E[1;37m\033[1m# Destino:'"$caminhoCompleto/movie.tbn"'\033[0m'
			echo -e '\E[1;37m\033[1m##############\033[0m'
			echo ""
			convert "$caminhoCompleto/Folder.jpg" "$caminhoCompleto/movie.tbn"
			chown francisco:francisco "$caminhoCompleto/movie.tbn"
		fi
		if [[ ! -f "$pastaSFilme/$filme ($ano).tbn" ]]; then
			tnbProcessados=1
			echo -e '\E[1;37m\033[1m##############\033[0m'
			echo -e '\E[1;37m\033[1m# Origem:'"$caminhoCompleto/movie.tbn"'\033[0m'
			echo -e '\E[1;37m\033[1m# Destino:'"$pastaSFilme/$filme ($ano).tbn"'\033[0m'
			echo -e '\E[1;37m\033[1m##############\033[0m'
			echo ""			
			cp "$caminhoCompleto/movie.tbn" "$pastaSFilme/$filme ($ano).tbn"
			chown francisco:francisco "$pastaSFilme/$filme ($ano).tbn"
		fi
		done
		else
		echo -e '\E[1;37m\033[1mO ficheiro Folder.jpg ou mymovies.xml não existem em algumas pastas.\033[0m'
		echo -e '\E[1;37m\033[1mExecute a opção [V] para determinar onde estão ausentes.\033[0m'
	fi
	if [ $tnbProcessados = 0 ]; then
		echo -e '\E[1;37m\033[1mNão foram processados ficheiros TNB.\033[0m'
	fi	
	}

function filmesFicheiros () {
	echo -e '\E[1;37m\033[1mProcessando as pastas ...\033[0m'
	caminhoCompleto=$(find "$dirDiscos" -mindepth 1 -maxdepth $dirNiveis -type f \
						\(\
						   -iname "*.rm" -o \
						   -iname "*.asf" -o \
						   -iname "*.mp4" -o \
						   -iname "*.wmv" -o \
						   -iname "*.avi" -o \
						   -iname "*.flv" -o \
						   -iname "*.mkv" -o \
						   -iname "*.m4u" -o \
						   -iname "*.mpg" -o \
						   -iname "*.mpeg" -o \
						   -iname "*.rmvb" \) | grep OsMeusFilmes | sed -e '/OsMeusFilmesInfantis/ d')
	echo "$caminhoCompleto" | awk -F'/' '{if (x[$5]) { x_count[$5]++; print $0; if (x_count[$5] == 1) { print x[$5] } } x[$5] = $0}' | sort -d
#	caminhoProcessado=$(echo "$caminhoCompleto" | awk -F'/' '{if (x[$5]) { x_count[$5]++; print $0; if (x_count[$5] == 1) { print x[$5] } } x[$5] = $0}') | sort -d
##
#	for filmeMaisFicheiros in $caminhoProcessado
#	do
#	ficheiroFilme=$(echo $filmeMaisFicheiros | sed )
#	nomeFicheiro=$(echo $ficheiroFilme | sed )
#	extencaoFicheiro=$(echo $ficheiroFilme | sed )
#	termFicheiroFilme=$(echo $ficheiroFilme | sed )
#	if [termFicheiroFilmes != CD1]; then
#	
#	fi
#	if [termFicheiroFilmes != CD2]; then
#	
#	fi
#	done
	}

function xerox () {
	clear
	rede=$(                                   \
	 dialog                                   \
		--title 'Instalação de Impressora'    \
		--stdout                              \
		--inputbox 'Indique a rede:'          \
		0 0                                   \
		  )
	echo "A rede indicada foi: $rede"
	}

function analizaFicheiros () {
let "loop1f=0"
while test $loop1f == 0
do
opcao=$( dialog                  \
	--stdout                     \
	--menu 'Analizar ficheiros'  \
	0 0 0                        \
	F 'Analiza Folder.jpg'       \
	X 'Analiza mymovies.xml'     \
	D 'Analiza disc.png'         \
	B 'Analiza backdrop.jpg'     \
	A 'Analiza fanart.jpg'       \
	M 'Analiza movie.nfo'        \
	V 'Voltar'   )

case $opcao in f|F)
ficheiro=Folder.jpg
analizaFicheiro
read -p "Precione qualquer tecla para continuar"
esac
case $opcao in x|X)
ficheiro=mymovies.xml
analizaFicheiro
read -p "Precione qualquer tecla para continuar"
esac
case $opcao in d|D)
ficheiro=disc.png
analizaFicheiro
read -p "Precione qualquer tecla para continuar"
esac
case $opcao in b|B)
ficheiro=backdrop.jpg
analizaFicheiro
read -p "Precione qualquer tecla para continuar"
esac
case $opcao in a|A)
ficheiro=fanart.jpg
analizaFicheiro
read -p "Precione qualquer tecla para continuar"
esac
case $opcao in m|M)
ficheiro=movie.nfo
analizaFicheiro
read -p "Precione qualquer tecla para continuar"
esac
case $opcao in v|V)
let "loop1f=1"
clear
esac

done
	}



let "loop1=0"
while test $loop1 == 0
do
opcao=$( dialog                           \
	--stdout                              \
	--menu 'Processar filmes'             \
	0 0 0                                 \
	V 'Validar presença de conteudos'     \
	F 'Nome das pastas = Nome do filme'   \
	B 'Criar ficheiros backdrop e fanart' \
	N 'Processar ficheiros movie.nfo'     \
	T 'Processar ficheiros TNB'           \
	D 'Filmes com + de 1 ficheiro'        \
	G 'Executa todas as opções'           \
	S 'Sair'   )

case $opcao in v|V)
analizaFicheiros
esac
case $opcao in f|F)
dirName
read -p "Precione qualquer tecla para continuar"
esac
case $opcao in b|B)
backdrop
read -p "Precione qualquer tecla para continuar"
esac
case $opcao in n|N)
nfo
read -p "Precione qualquer tecla para continuar"
esac
case $opcao in t|T)
tbn
read -p "Precione qualquer tecla para continuar"
esac
case $opcao in d|D)
filmesFicheiros
read -p "Precione qualquer tecla para continuar"
esac
case $opcao in g|G)
dirName
backdrop
nfo
tbn
filmesFicheiros
read -p "Precione qualquer tecla para continuar"
esac
case $opcao in s|S)
let "loop1=1"
clear
esac

done
