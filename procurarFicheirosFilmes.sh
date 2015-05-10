#!/bin/bash
# j.francisco.o.rocha@gmail.com (2011)
#
# PROCURA FILMES COM MAIS DE UM FICHEIRO
# CAMINHO RECOMENDADO /MEDIA
# NIVEIS RECOMENDADO 5
#

IFS=$'\n'
CAMINHO=$1
NIVEIS=$2
CAMINHO_COMPLETO=$(
			find "$CAMINHO/" -mindepth 1 -maxdepth $NIVEIS -type f \
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
echo "Filmes com mais de um ficheiro:"				   
echo "$CAMINHO_COMPLETO" | awk -F'/' '{if (x[$5]) { x_count[$5]++; print $0; if (x_count[$5] == 1) { print x[$5] } } x[$5] = $0}'
