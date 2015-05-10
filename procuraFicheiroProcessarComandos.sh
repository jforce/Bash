#!/bin/bash
# j.francisco.o.rocha@gmail.com (2011)
#
# Procura se existe um ficheiro numa estructura de pastas
#

PROCURAR () {

IFS=$'\n'
for DIRECTORIA in $(find $PASTA -maxdepth $NIVEIS -type d)
do
  if [[ ! -f "$DIRECTORIA/$FICHEIRO" ]]; then
if [ "$TESTE" == "A" ]   ; then
    # Procura as directorias onde o ficheiro $FICHEIRO esta Ausente
    echo "$DIRECTORIA"
    for FILES in $(find $DIRECTORIA/*.jpg -maxdepth 1 -type f)
    do
	echo "cp $FILES $home/copia$FILES"
	done
	for FILES in $(find $DIRECTORIA/*.png -maxdepth 1 -type f)
    do
	cp "$FILES $HOME/copia$FILES"
	done
	for FILES in $(find $DIRECTORIA/*.tbn -maxdepth 1 -type f)
    do
	cp "$FILES $HOME/copia$FILES"
	done
fi
else
if [ "$TESTE" == "P" ]   ; then
	# Procura as directorias onde o ficheiro $FICHEIRO esta Presente
	echo "$DIRECTORIA"
	cp "$DIRECTORIA/movie.nfo $HOME/copia/$DIRECTORIA/movie.nfo"
	cp "$DIRECTORIA/mymovies.xml $HOME/copia/$DIRECTORIA/mymovies.xml"
	for FILESJ in $(find $DIRECTORIA/*.jpg -maxdepth 1 -type f)
    do
	cp "$FILESJ $HOME/copia$FILESJ"
	done
	for FILESP in $(find $DIRECTORIA/*.png -maxdepth 1 -type f)
    do
	cp "$FILESP $HOME/copia$FILESP"
	done
	for FILEST in $(find $DIRECTORIA/*.tbn -maxdepth 1 -type f)
    do
	cp "$FILEST $HOME/copia$FILEST"
	done
fi
fi
done
}

MENSAGEM () {
echo "Formato: ./procura.sh {P|A} {pasta_origem} {ficheiro} {niveis}"
echo "        {P|A} - P ficheiro Presente (testa se o ficheio existe)"
echo "                A ficheiro Ausente (testa se o ficheiro não existe)"
echo "        {pasta_origem} - Directorio que deve ser considerado como Nivel 0"
echo "        {ficheiro} - Ficheiro a testar"
echo "        {niveis} - Numero de niveis (subpastas) consideradas apartir da Pasta Origem"
}

TESTE=$1
PASTA=$2
FICHEIRO=$3
NIVEIS=$4

#Testa se foi indicado um tipo de teste
if [ -z ${TESTE} ]   ; then
   exec >&2; MENSAGEM ; echo "Erro: Não foi indicado um tipo de teste" ; exit 1
fi

#Testa se foi indicado um tipo de teste valido
if [ "$TESTE" != "A" ] && [ "$TESTE" != "P" ]   ; then
   exec >&2; MENSAGEM ; echo "Erro: Não foi indicado um tipo de teste valido" ; exit 1
fi

#Testa se foi indicada uma pasta
if [ -z ${PASTA} ]   ; then
   exec >&2; MENSAGEM ; echo "Erro: Não foi indicada uma pasta" ; exit 1
fi

#Testa se foi indicado um ficheiro
if [ -z ${FICHEIRO} ]   ; then
   exec >&2; MENSAGEM ; echo "Erro: Não foi indicado um ficheiro" ; exit 1
fi

#Testa se foi indicado um valor de profundidade
if [ -z ${NIVEIS} ]   ; then
   exec >&2; MENSAGEM ; echo "Erro: Não foi indicado um valor para os niveis a pesquisar" ; exit 1
fi

#Testa se a variavel niveis é um numero
if ! [[ "$NIVEIS" =~ ^[0-9]+$ ]] ; then
   exec >&2; MENSAGEM ; echo "Erro: A variavel nivel não é um numero e tem de ser" ; exit 1
fi

PROCURAR
