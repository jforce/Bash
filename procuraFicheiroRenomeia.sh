#!/bin/bash
# j.francisco.o.rocha@gmail.com (2011)
#
# Procura se existe um ficheiro numa estructura de pastas e muda o nome dele
#

PROCURAR () {

IFS=$'\\'
for DIRECTORIA in $(find $PASTA -maxdepth $NIVEIS -type d)
do
  if [ ! -f "$DIRECTORIA/$FICHEIRO" ] ; then
	# echo Procura as directorias onde o ficheiro $FICHEIRO esta Presente
	echo "mv" "$DIRECTORIA/$FICHEIRO" "$DIRECTORIA/$NOMENOVO"
  fi

done
}

MENSAGEM () {
echo "Formato: ./procura.sh  {niveis} {ficheiro} {ficheiroNomeNovo} {pasta_origem}"
echo "        {pasta_origem} - Directorio que deve ser considerado como Nivel 0"
echo "        {ficheiro} - Ficheiro a procurar"
echo "        {ficheiroNomeNovo}"
echo "        {niveis} - Numero de niveis (subpastas) consideradas apartir da Pasta Origem"
echo "Exp.:"
echo "./procuraFicheiroRenomeia.sh /media/DISC0*/ Folder.jpg folder.jpg 5"
}


NIVEIS=$1
FICHEIRO=$2
NOMENOVO=$3
PASTA=$4

#Testa se foi indicada uma pasta
if [ -z ${PASTA} ]   ; then
   exec >&2; MENSAGEM ; echo "Erro: Não foi indicada uma pasta" ; exit 1
fi

#Testa se foi indicado um ficheiro
if [ -z ${FICHEIRO} ]   ; then
   exec >&2; MENSAGEM ; echo "Erro: Não foi indicado um ficheiro" ; exit 1
fi

#Testa se foi indicado um ficheiro
if [ -z ${NOMENOVO} ]   ; then
   exec >&2; MENSAGEM ; echo "Erro: Não foi indicado um nome novo" ; exit 1
fi

#Testa se foi indicado um valor de profundidade
if [ -z ${NIVEIS} ]   ; then
   exec >&2; MENSAGEM ; echo "Erro: Não foi indicado um valor para os niveis a pesquisar" ; exit 1
fi

#Testa se a variavel niveis é um numero
#if ! [[ "$NIVEIS" =~ ^[0-9]+$ ]] ; then
#   exec >&2; MENSAGEM ; echo -e "Erro: A variavel nivel não é um numero e tem de ser\nNiveis=$NIVEIS" ; exit 1
#fi

PROCURAR
