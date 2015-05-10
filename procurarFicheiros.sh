#!/bin/bash
# j.francisco.o.rocha@gmail.com (2011)
#
# PROCURA FICHEIROS COM A EXTENÇAO MULTIPLAS
#

CAMINHO=$1
EXTENSAO1=$2
EXTENSAO2=$3
EXTENSAO3=$4

# find "$CAMINHO" -mindepth 1 -maxdepth 2 -type f \( -name "*.$EXTENSAO1" \)

find "$CAMINHO" -mindepth 1 -maxdepth 2 -type f \( -name "*.$EXTENSAO1" -o -name "*.$EXTENSAO2" -o -name "*.$EXTENSAO3" \)

