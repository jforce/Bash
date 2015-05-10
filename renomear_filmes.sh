#!/bin/bash
# j.francisco.o.rocha@gmail.com (2011)
#
# MUDA O NOME DA PASTA PARA O NOME DO FILME (ANO)
#

IFS=$'\n'
CAMINHO=$1
NIVEIS=$2

for CAMINHO_COMPLETO in $(find $CAMINHO -mindepth 1 -maxdepth $NIVEIS -type f -name "mymovies.xml" | grep mymovies.xml | sed -e 's/\/mymovies.xml//g' -e 's/  //g' )

do

FILME=$(cat $CAMINHO_COMPLETO/mymovies.xml | grep LocalTitle | sed -e 's/<LocalTitle>//g' -e 's/<\/LocalTitle>//g' -e 's/.$//g' -e 's/://g'  -e 's/?//g' -e 's/\&amp\;/\&/'  -e 's/  //g')
ANO=$(cat $CAMINHO_COMPLETO/mymovies.xml | grep ProductionYear | sed -e 's/<ProductionYear>//g' | sed -e 's/<\/ProductionYear>//g' | sed -e 's/.$//g' -e 's/^M//g' -e 's/  //g')
pastaSFilme=$(echo "$CAMINHO_COMPLETO" | sed 's/\(.*\)./\1/' | awk -F'/' '{for(i=1;i<NF-1;++i)printf $i"/";print $i}'| sed -e 's/  //g')


#echo "FILME: $FILME"
#echo "  ANO: $ANO"
#echo ""
#echo "   PASTA_S_FILME= $pastaSFilme"
#echo "     NOME ANTIGO= $CAMINHO_COMPLETO"
#echo "       NOME NOVO= $pastaSFilme/$FILME ($ANO)"
#echo "--------------------------------"
#echo -e "$CAMINHO_COMPLETO/\t$pastaSFilme/$FILME ($ANO)/"
#echo "mv \"$CAMINHO_COMPLETO/\" \"$pastaSFilme/$FILME ($ANO)/\""
#mv "$CAMINHO_COMPLETO" "$pastaSFilme/$FILME ($ANO)"
#convert "$CAMINHO_COMPLETO/Folder.jpg" "$CAMINHO_COMPLETO/movie.tbn"
#cp "$CAMINHO_COMPLETO/movie.tbn" "$pastaSFilme/$FILME ($ANO).tbn"
sed -i -e 's/C:\\Users\\Francisco\\Pictures\\ImagesByName\\People\\/\/home\/xbmc\/People\//' -e 's/\\folder.jpg/\/folder.jpg/' "$CAMINHO_COMPLETO/movie.nfo"
#echo ""

done
