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
			# Procura se o ficheiro $FICHEIRO as pastas onde esta Ausente
			echo "$DIRECTORIA"
		fi
	else
		if [ "$TESTE" == "P" ]   ; then
			# Procura as pastas onde esta Presente
			echo "$DIRECTORIA"
			codeIMDB=$(cat $DIRECTORIA/$FICHEIRO | grep "<IMDbId>" |sed -e 's/<IMDbId>//g' -e 's/<\/IMDbId>//g' -e 's/\t//g' -e 's/ //g' | tr -d "\015")
			echo $codeIMDB
			GERARMYMOVIESXML
		fi
	fi
done
}

GERARMYMOVIESXML () {
	echo -e "<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>" > $DIRECTORIA/$FICHEIRO
	echo -e "<movie>" >> $DIRECTORIA/$FICHEIRO
	echo -e "\t<title></title>" >> $DIRECTORIA/$FICHEIRO
	echo -e "\t<originaltitle></originaltitle>" >> $DIRECTORIA/$FICHEIRO
	echo -e "\t<IMDbId>$codeIMDB</IMDbId>" >> $DIRECTORIA/$FICHEIRO
	echo -e "\t<TMDbId></TMDbId>" >> $DIRECTORIA/$FICHEIRO
	echo -e "\t<mpaa></mpaa>" >> $DIRECTORIA/$FICHEIRO	
	echo -e "\t<rating></rating>" >> $DIRECTORIA/$FICHEIRO
	echo -e "\t<year></year>" >> $DIRECTORIA/$FICHEIRO
	echo -e "\t<votes></votes>" >> $DIRECTORIA/$FICHEIRO
	echo -e "\t<outline></outline>" >> $DIRECTORIA/$FICHEIRO
	echo -e "\t<plot></plot>" >> $DIRECTORIA/$FICHEIRO
	echo -e "\t<genre></genre>" >> $DIRECTORIA/$FICHEIRO
	echo -e "\t<country></country>" >> $DIRECTORIA/$FICHEIRO
	echo -e "</movie>" >> $DIRECTORIA/$FICHEIRO

#	echo -e "<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>"
#	echo -e "<movie>"
#	echo -e "\t<title></title>"
#	echo -e "\t<originaltitle></originaltitle>"
#	echo -e "\t<TMDbId></TMDbId>"
#	echo -e "\t<mpaa></mpaa>"
#	echo -e "\t<rating></rating>"
#	echo -e "\t<year></year>"
#	echo -e "\t<votes></votes>"
#	echo -e "\t<outline></outline>"
#	echo -e "\t<plot></plot>"
#	echo -e "\t<genre></genre>"
#	echo -e "\t<country></country>"
#	echo -e "</movie>"
}


MENSAGEM () {
echo "Formato: ./procura.sh {P|A} {pasta_origem} {ficheiro} {niveis}"
echo "        {P|A} - P ficheiro Presente (testa se o ficheio existe)"
echo "                A ficheiro Ausente (testa se o ficheiro não existe)"
echo "        {pasta_origem} - Directorio que deve ser considerado como Nivel 0"
echo "        {ficheiro} - Ficheiro a testar"
echo "        {niveis} - Numero de niveis (subpastas) consideradas apartir da Pasta Origem"
}

#TESTE=$1
TESTE="P"
#PASTA=$2
PASTA="/media"
#FICHEIRO=$3
FICHEIRO="mymovies.xml"
#NIVEIS=$4
NIVEIS=5
codeIMDB=""

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
