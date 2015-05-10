#!/bin/bash
# j.francisco.o.rocha@gmail.com (2011)
#
# Cria ficheiros backdrop nas pastas onde não existem
#

CRIAR_BACKDROPS () {

IFS=$'\n'
for CAMINHO_COMPLETO in $(find "$CAMINHO" -maxdepth $NIVEIS -type d | grep OsMeusFilmes)

do

	if [[ ! -f "$CAMINHO_COMPLETO/backdrop.jpg" ]]; then

		for FILME in $(
			find "$CAMINHO_COMPLETO/" -mindepth 1 -maxdepth 1 -type f \
				\(\
				   -name "*.rm" -o \
				   -name "*.asf" -o \
				   -name "*.mp4" -o \
				   -name "*.wmv" -o \
				   -name "*.avi" -o \
				   -name "*.flv" -o \
				   -name "*.mkv" -o \
				   -name "*.m4u" -o \
				   -name "*.mpg" -o \
				   -name "*.mpeg" -o \
				   -name "*.rmvb" \))
		do
			if [[ ! -f "$CAMINHO_COMPLETO/backdrop.jpg" ]]; then
			DURACAO_FILME=( $(ffmpeg -i "$FILME" 2>&1 | sed -n "s/.* Duration: \([^,]*\), start: .*/\1/p") )
			TEMPO_TOT_FILME_SEG=( $(echo "$DURACAO_FILME" | awk -F':' '{ print $1*3600 + $2*60 + $3 }' | awk -F'.' '{print $1}'))
			TEMPO_DIV_FILME=( $(echo "$TEMPO_TOT_FILME_SEG" | awk '{ print $1 / 5 }' | awk -F'.' '{ print $1 }'))
			TEMPO_DIV_FILME4=( $(echo "$TEMPO_TOT_FILME_SEG" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
			TEMPO_DIV_FILME3=( $(echo "$TEMPO_DIV_FILME4" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
			TEMPO_DIV_FILME2=( $(echo "$TEMPO_DIV_FILME3" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
			TEMPO_DIV_FILME1=( $(echo "$TEMPO_DIV_FILME2" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
			echo "DURACAO_FILME $DURACAO_FILME"
			echo "TEMPO_TOT_FILME_SEG $TEMPO_TOT_FILME_SEG"
			echo "TEMPO_DIV_FILME $TEMPO_DIV_FILME"
			echo "nao existe backdrop.jpg aqui $CAMINHO_COMPLETO"
			echo "filme é $FILME"
			echo "TEMPO_DIV_FILME1: $TEMPO_DIV_FILME1 - TEMPO_DIV_FILME2: $TEMPO_DIV_FILME2- TEMPO_DIV_FILME3: $TEMPO_DIV_FILME3 - TEMPO_DIV_FILME4: $TEMPO_DIV_FILME4"
			ffmpeg -ss "$TEMPO_DIV_FILME1" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$CAMINHO_COMPLETO/backdrop.jpg" 2>&1
			if [[ ! -f "$CAMINHO_COMPLETO/fanart.jpg" ]]; then
				cp $CAMINHO_COMPLETO/backdrop.jpg $CAMINHO_COMPLETO/fanart.jpg
			fi
			ffmpeg -ss "$TEMPO_DIV_FILME2" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$CAMINHO_COMPLETO/backdrop1.jpg" 2>&1
			ffmpeg -ss "$TEMPO_DIV_FILME3" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$CAMINHO_COMPLETO/backdrop2.jpg" 2>&1
			ffmpeg -ss "$TEMPO_DIV_FILME4" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$CAMINHO_COMPLETO/backdrop3.jpg" 2>&1
			else
				if [[ ! -f "$CAMINHO_COMPLETO/backdrop4.jpg" ]]; then
				DURACAO_FILME=( $(ffmpeg -i "$FILME" 2>&1 | sed -n "s/.* Duration: \([^,]*\), start: .*/\1/p") )
				TEMPO_TOT_FILME_SEG=( $(echo "$DURACAO_FILME" | awk -F':' '{ print $1*3600 + $2*60 + $3 }' | awk -F'.' '{print $1}'))
				TEMPO_DIV_FILME=( $(echo "$TEMPO_TOT_FILME_SEG" | awk '{ print $1 / 5 }' | awk -F'.' '{ print $1 }'))
				TEMPO_DIV_FILME4=( $(echo "$TEMPO_TOT_FILME_SEG" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
				TEMPO_DIV_FILME3=( $(echo "$TEMPO_DIV_FILME4" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
				TEMPO_DIV_FILME2=( $(echo "$TEMPO_DIV_FILME3" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
				TEMPO_DIV_FILME1=( $(echo "$TEMPO_DIV_FILME2" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
				echo "DURACAO_FILME $DURACAO_FILME"
				echo "TEMPO_TOT_FILME_SEG $TEMPO_TOT_FILME_SEG"
				echo "TEMPO_DIV_FILME $TEMPO_DIV_FILME"
				echo "nao existe backdrop.jpg aqui $CAMINHO_COMPLETO"
				echo "filme é $FILME"
				echo "TEMPO_DIV_FILME1: $TEMPO_DIV_FILME1 - TEMPO_DIV_FILME2: $TEMPO_DIV_FILME2- TEMPO_DIV_FILME3: $TEMPO_DIV_FILME3 - TEMPO_DIV_FILME4: $TEMPO_DIV_FILME4"
				ffmpeg -ss "$TEMPO_DIV_FILME1" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$CAMINHO_COMPLETO/backdrop4.jpg" 2>&1
				ffmpeg -ss "$TEMPO_DIV_FILME2" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$CAMINHO_COMPLETO/backdrop5.jpg" 2>&1
				ffmpeg -ss "$TEMPO_DIV_FILME3" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$CAMINHO_COMPLETO/backdrop6.jpg" 2>&1
				ffmpeg -ss "$TEMPO_DIV_FILME4" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$CAMINHO_COMPLETO/backdrop7.jpg" 2>&1
				else
					if [[ ! -f "$CAMINHO_COMPLETO/backdrop8.jpg" ]]; then
					DURACAO_FILME=( $(ffmpeg -i "$FILME" 2>&1 | sed -n "s/.* Duration: \([^,]*\), start: .*/\1/p") )
					TEMPO_TOT_FILME_SEG=( $(echo "$DURACAO_FILME" | awk -F':' '{ print $1*3600 + $2*60 + $3 }' | awk -F'.' '{print $1}'))
					TEMPO_DIV_FILME=( $(echo "$TEMPO_TOT_FILME_SEG" | awk '{ print $1 / 5 }' | awk -F'.' '{ print $1 }'))
					TEMPO_DIV_FILME4=( $(echo "$TEMPO_TOT_FILME_SEG" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
					TEMPO_DIV_FILME3=( $(echo "$TEMPO_DIV_FILME4" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
					TEMPO_DIV_FILME2=( $(echo "$TEMPO_DIV_FILME3" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
					TEMPO_DIV_FILME1=( $(echo "$TEMPO_DIV_FILME2" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
					echo "DURACAO_FILME $DURACAO_FILME"
					echo "TEMPO_TOT_FILME_SEG $TEMPO_TOT_FILME_SEG"
					echo "TEMPO_DIV_FILME $TEMPO_DIV_FILME"
					echo "nao existe backdrop.jpg aqui $CAMINHO_COMPLETO"
					echo "filme é $FILME"
					echo "TEMPO_DIV_FILME1: $TEMPO_DIV_FILME1 - TEMPO_DIV_FILME2: $TEMPO_DIV_FILME2- TEMPO_DIV_FILME3: $TEMPO_DIV_FILME3 - TEMPO_DIV_FILME4: $TEMPO_DIV_FILME4"
					ffmpeg -ss "$TEMPO_DIV_FILME1" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$CAMINHO_COMPLETO/backdrop8.jpg" 2>&1
					ffmpeg -ss "$TEMPO_DIV_FILME2" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$CAMINHO_COMPLETO/backdrop9.jpg" 2>&1
					ffmpeg -ss "$TEMPO_DIV_FILME3" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$CAMINHO_COMPLETO/backdrop10.jpg" 2>&1
					ffmpeg -ss "$TEMPO_DIV_FILME4" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$CAMINHO_COMPLETO/backdrop11.jpg" 2>&1
					else
						if [[ ! -f "$CAMINHO_COMPLETO/backdrop12.jpg" ]]; then
						DURACAO_FILME=( $(ffmpeg -i "$FILME" 2>&1 | sed -n "s/.* Duration: \([^,]*\), start: .*/\1/p") )
						TEMPO_TOT_FILME_SEG=( $(echo "$DURACAO_FILME" | awk -F':' '{ print $1*3600 + $2*60 + $3 }' | awk -F'.' '{print $1}'))
						TEMPO_DIV_FILME=( $(echo "$TEMPO_TOT_FILME_SEG" | awk '{ print $1 / 5 }' | awk -F'.' '{ print $1 }'))
						TEMPO_DIV_FILME4=( $(echo "$TEMPO_TOT_FILME_SEG" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
						TEMPO_DIV_FILME3=( $(echo "$TEMPO_DIV_FILME4" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
						TEMPO_DIV_FILME2=( $(echo "$TEMPO_DIV_FILME3" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
						TEMPO_DIV_FILME1=( $(echo "$TEMPO_DIV_FILME2" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
						echo "DURACAO_FILME $DURACAO_FILME"
						echo "TEMPO_TOT_FILME_SEG $TEMPO_TOT_FILME_SEG"
						echo "TEMPO_DIV_FILME $TEMPO_DIV_FILME"
						echo "nao existe backdrop.jpg aqui $CAMINHO_COMPLETO"
						echo "filme é $FILME"
						echo "TEMPO_DIV_FILME1: $TEMPO_DIV_FILME1 - TEMPO_DIV_FILME2: $TEMPO_DIV_FILME2- TEMPO_DIV_FILME3: $TEMPO_DIV_FILME3 - TEMPO_DIV_FILME4: $TEMPO_DIV_FILME4"
						ffmpeg -ss "$TEMPO_DIV_FILME1" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$CAMINHO_COMPLETO/backdrop12.jpg" 2>&1
						ffmpeg -ss "$TEMPO_DIV_FILME2" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$CAMINHO_COMPLETO/backdrop13.jpg" 2>&1
						ffmpeg -ss "$TEMPO_DIV_FILME3" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$CAMINHO_COMPLETO/backdrop14.jpg" 2>&1
						ffmpeg -ss "$TEMPO_DIV_FILME4" -i $FILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$CAMINHO_COMPLETO/backdrop15.jpg" 2>&1
						fi
					fi
				fi
			fi
		done
	else
	# Procura as pastas onde esta Presente
	echo "O ficheiro backdrop.jpg existe na pasta $CAMINHO_COMPLETO" > /dev/null
	if [[ ! -f "$CAMINHO_COMPLETO/fanart.jpg" ]]; then
		cp $CAMINHO_COMPLETO/backdrop.jpg $CAMINHO_COMPLETO/fanart.jpg
	fi

fi
done
}

MENSAGEM () {
echo "Formato: ./backdrop.sh {caminho} {niveis}"
echo "        {caminho} - Pasta Origem que deve ser considerada (Nivel 0)"
echo "        {niveis} - Numero de niveis (subpastas) consideradas apartir da Pasta Origem"
}


CAMINHO=$1
NIVEIS=$2

#Testa se foi indicada uma pasta
if [ -z "${CAMINHO}" ]   ; then
   exec >&2; MENSAGEM ; echo "Erro: Não foi indicada uma pasta" ; exit 1
fi

#Testa se foi indicado um valor de profundidade
if [ -z ${NIVEIS} ]   ; then
   exec >&2; MENSAGEM ; echo "Erro: Não foi indicado um valor para os niveis a pesquisar" ; exit 1
fi

#Testa se a variavel niveis é um numero
if ! [[ "$NIVEIS" =~ ^[0-9]+$ ]] ; then
   exec >&2; MENSAGEM ; echo "Erro: A variavel nivel não é um numero e tem de ser" ; exit 1
fi

CRIAR_BACKDROPS
