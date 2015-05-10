#!/usr/bin/env bash
# j.francisco.o.rocha@gmail.com (2011)
#
# Escreve a dados existentes no ficheiro movie.nfo
# no ficheiro mymovies.xml de cada filme
#
#shopt -s -o nounset
#declare -rx SCRIPT=${0##*/}
declare IFS=$'\n'
declare PASTA=/media/DISC*
#declare DESCRICAO="DVDPT"
#declare DESCRICAO="PTGATE"
#declare DESCRICAO="CliqueDicas"
#declare DESCRICAO="CliqueDicas"
#declare DESCRICAO="AdoroCinema"
#declare DESCRICAO="Baixatorrent"
#declare DESCRICAO="BestCine"
#declare DESCRICAO="Cinema-em-casa.blogs.sapo.pt"
#declare DESCRICAO="Cinema.Sapo.pt"
#declare DESCRICAO="cinema.sapo.pt"
#declare DESCRICAO="CinemaSapo"
#declare DESCRICAO="CinePlayers"
#declare DESCRICAO="DownupUpdown"
#declare DESCRICAO="FilmesDeCinema"
#declare DESCRICAO="Filmesdomegavideo"
#declare DESCRICAO="Interfilmes"
#declare DESCRICAO="JomirifeCinema"
#declare DESCRICAO="ListadeFilmes"
#declare DESCRICAO="NaoDiga"
#declare DESCRICAO="Piratamania"
#declare DESCRICAO="Prseyer"
#declare DESCRICAO="SAPO"
#declare DESCRICAO="SeriesTvMp3"
#declare DESCRICAO="SinopsesDeFilmes"
#declare DESCRICAO="Wikipedia"
declare DIRECTORIA
declare DIRECTORIA_SNFO
declare IMDBcode
declare TMDBcode
#declare FILE=movie.nfo
#declare FILE=mymovies.xml
declare FILE=filme.txt

PROCURAR () {

#IFS=$'\n'
#read -p "Avansar1 ..."
#for DIRECTORIA in $(find $PASTA -name "*.nfo" -exec grep -l $DESCRICAO {} \;)
for DIRECTORIA in $(find -L /media/DISC* -mindepth 1 -maxdepth 5 -type f -name $FILE)
	do
	#plotNfo=$(cat "$DIRECTORIA" | sed -n '/<plot>/,/plot>/p' | sed -e 's/<plot>//g' | sed -e 's/<\/plot>//g' | sed -e 's/\t//g' | sed '/^$/d' | tr '\n' '\. ' | sed -e 's/\.\./\. /g' | sed -e 's/\./\. /' | sed -e 's/  / /g' | sed -e 's/Fonte\: /Fonte\:/g' | sed -e 's/\. Fonte\:/\.Fonte\:/g')
	DIRECTORIA_SFILE=$(echo -e "$DIRECTORIA" | sed -e "s/\/$FILE//g")
	#IMDBcode=$(cat "$DIRECTORIASFILE/movie.nfo" | grep "<id moviedb=imdb>" | sed -e 's/<id\ moviedb=imdb>//g' | sed -e 's/\t//g' | sed -e 's/<\/id>//g')
	#TMDBcode=$(cat "$DIRECTORIA/movie.nfo" | grep "<id moviedb=tmdb>" | sed -e 's/<id\ moviedb=tmdb>//g' | sed -e 's/\t//g' | sed -e 's/<\/id>//g')
	#nano $DIRECTORIA_SNFO/mymovies.xml
	#cat $DIRECTORIA_SNFO/mymovies.xml | sed -e "s/<plot><\/plot>/<plot>$plotNfo<\/plot>/g" | sed -e "s/Fonte\:$DESCRICAO/\nFonte\:$DESCRICAO/g" | sed -e 's/\.<\/plot>/<\/plot>/g' > $DIRECTORIA_SNFO/mymovies_temp.xml
	#cat $DIRECTORIA_SNFO/mymovies_temp.xml | sed -e "s/<IMDbId><\/IMDbId>/<IMDbId>$IMDBcode<\/IMDbId>/g" > $DIRECTORIA_SNFO/mymovies.xml
	#cat $DIRECTORIA_SNFO/mymovies.xml | sed -e "s/<TMDbId><\/TMDbId>/<TMDbId>$TMDBcode<\/TMDbId>/g" > $DIRECTORIA_SNFO/mymovies_temp.xml
	#cp -f $DIRECTORIA_SNFO/mymovies_temp.xml $DIRECTORIA_SNFO/mymovies.xml
	#nano $DIRECTORIA_SNFO/mymovies.xml
	#read -p "Esta tudo bem?"
	#echo -e "$DIRECTORIA"
	#echo -e "$DIRECTORIA_SFILE"
	#echo -e "$IMDBcode"
	#echo -e "$TMDBcode"
	#if [[ $TMDBcode == "" ]]; then
	#	if [[ $IMDBcode != "" ]]; then
	#	lynx -connect_timeout=10 --source "http://api.themoviedb.org/2.1/Movie.imdbLookup/pt/xml/2139fe2ff8e32e6081db53edaf2b18af/$IMDBcode" > lixo
	#	TMDBcode=$(cat lixo | grep "<id>" | sed -e :a -e 's/<[^>]*>//g;s/ //g;s/\t//g')
	#	rm lixo
	#	#nano $DIRECTORIA_SFILE/mymovies.xml
	#	sed -i "s/<id moviedb=tmdb><\/id>/<id moviedb=tmdb>$TMDBcode<\/id>/g" $DIRECTORIA_SFILE/movie.nfo
	#	#read -p "Verificou? !!!"
	#	fi
	#fi
	echo -e "rm" "$DIRECTORIA_SFILE/mymovies.xml"
	rm "$DIRECTORIA_SFILE/mymovies.xml"
	done
}

PROCURAR
