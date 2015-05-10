#!/usr/bin/env bash
#! autor: j.francisco.o.rocha@gmail.com
#! FilmesScan.sh
#! 04/2010

####################################
# Global variable declarations INI #
#								   #
shopt -s -o nounset
declare -rx SCRIPT=${0##*/}
declare IFS=$'\n'
declare dirDiscos="/media/DISC*"
#declare dirDiscos="/media/DISC06/OsMeusFilmesHD/"
#declare dirDiscos="/home/francisco/Área de Trabalho/Movies"
declare dirNiveis=5
declare xbmcDestinoHtml=""
declare aguardarTempo=0
declare tempoMax=9
# Coloque a variavel renovarHTML em 1 para que o HTML seja actualizado
# em 0 para que seja aproveitado o HTML ja existente.
declare renovarHTML=0
# Coloque a variavel renovarNFO em 1 para que os ficheiros movie.nfo sejam actualizados
# em 0 para que sejam aproveitados os ficheiros movie.nfo ja existentes.
declare renovarNFO=0
# Coloque a variavel renovarNFO em 1 para que os ficheiros movie.nfo sejam colocados na pasta raiz do filme
# em 0 para que esta acção nao seja realizada
declare arrumarNFO=0
declare USERNAME=francisco
declare PASSWORD=dia19mes10
declare MASTERIP=192.168.0.10
declare URL
declare APITMDB="2139fe2ff8e32e6081db53edaf2b18af"
declare idTMDB
declare movieTime
declare codeIMDB=""
declare codeTMDB=""
declare encontraTMDB
declare descricaoManual=""
declare URLIMDB
declare URLIMDBC
declare URLIMDBCREDIT
declare URLPTGATE=""
declare URLDVDPT=""
declare ptTMDB=""
declare TITULO=""
declare TITULOMSDOS=""
declare imgUrlBACKDROP=""
declare imgUrlPOSTER=""
declare ANO
declare ano
declare RAT
declare VOTES
declare MPAA
declare COUNTRY
declare RUNTIME
declare STUDIO
declare PREMIERED
declare PLOT
declare PLOTPTGATE
declare PLOTDVDPT
declare PLOTIMDB
declare PLOTIMDBC
declare PLOTTMDB=""
declare testeFontePLOT
declare plotXml
declare FILME
declare filme
declare fileFILMEsEXT
declare fileFILME
declare DIR
declare WRITER
declare GEN
declare xbmcCAST=""
declare xbmcACTOR=""
declare xbmcACTORROLE=""
declare xbmcTHUMB=""
declare xbmcURLACTORJPG=""
declare xbmcVideoCodec=""
declare xbmcVideoAspect=""
declare xbmcVideoWidth=""
declare xbmcVideoHeight=""
declare xbmcVideoDuration=""
declare xbmcAudioCodec=""
declare xbmcAudioChannels=""
declare xbmcActorChar
declare xbmcDestinoNfo
declare xbmcDestinoXml
declare xbmcDestino
declare xbmcDestinoSMedia
declare xbmcDestinoActor
declare CAST
declare CONTADOR
declare ImdbCode=""
declare ImdbCodeTest=""
declare ImdbCodePtgate=""
declare ImdbCodeDvdpt=""
declare DURACAO_FILME
declare TEMPO_TOT_FILME_SEG
declare TEMPO_DIV_FILME
declare TEMPO_DIV_FILME1
declare TEMPO_DIV_FILME2
declare TEMPO_DIV_FILME3
declare TEMPO_DIV_FILME4
declare ficheiro
declare ficheiro1
declare ficheiro2
declare ficheiro3
declare ficheiro4
declare ficheiro5
declare loop1f
declare opcao
declare tbnProcessados
declare nfoProcessados
declare processarBackdrops
declare faltaFicheiro
declare pastaSFilme
declare pastaSFicheiro
declare pastaSFicheiroAnt
declare faltaFicheiros
declare faltaFicheiro1
declare faltaFicheiro2
declare faltaFicheiro3
declare faltaFicheiro4
declare faltaFicheiro5
declare caminhoCompleto
declare caminhoDestino
declare faltaFicheiro
declare trailer
declare mudeiNomes
declare BARRELA=0
declare -rx CASTFILEIMDB=/tmp/movieImdbCast.$$
declare LYNX=""
declare WGET=""
declare CAT=""
declare SED=""
declare EGREP=""
declare GREP=""
declare UNIQ=""
declare HEAD=""
declare ICONV=""
declare AWK=""
declare DIALOG=""
declare FFMPEG=""
declare CONVERT=""
declare BC=""
declare FIND=""
declare TR=""
declare PRINTF=""
declare SEQ=""
declare DATE=""
declare OD=""
declare PING=""
declare RSYNC=""
declare SSH=""
declare count=0
declare BAR=""
#								   #
# Global variable declarations END #
####################################

#################
# Functions INI #
#				#

function validacao () {
if [ -z "$BASH" ]
then
printf "This script is written for bash. Please run this under bash\n" >&2
exit 192
fi

LYNX=`which lynx`
if [ "$LYNX" = "" ] ; then
	echo "Porfavor instale lynx.";
	exit 0;
fi

EGREP=`which egrep`
if [ "$EGREP" = "" ] ; then
	echo "Porfavor instale egrep.";
	exit 0;
fi

UNIQ=`which uniq`
if [ "$UNIQ" = "" ] ; then
	echo "Porfavor instale uniq.";
	exit 0;
fi

ICONV=`which iconv`
if [ "$ICONV" = "" ] ; then
	echo "Porfavor instale iconv.";
	exit 0;
fi

WGET=`which wget`
if [ "$WGET" = "" ] ; then
	echo "Porfavor instale wget.";
	exit 0;
fi

DIALOG=`which dialog`
if [ "$DIALOG" = "" ] ; then
	echo "Porfavor instale dialog.";
	exit 0;
fi

FFMPEG=`which ffmpeg`
if [ "$FFMPEG" = "" ] ; then
	echo "Porfavor instale ffmpeg.";
	exit 0;
fi

CONVERT=`which convert`
if [ "$CONVERT" = "" ] ; then
	echo "Porfavor instale imagemagick.";
	exit 0;
fi
}

function aguardarTempo () {
	# Coloca o scrip em espera entre 0 e 60 seg.
	tempoMax=$1
	aguardarTempo=$(echo $((`cat /dev/urandom|od -N1 -An -i` % $tempoMax)))
	echo "Processamento suspenso durante $aguardarTempo seg."
	sleep $aguardarTempo
	}

function progressBarOld () {
	count=0
	BAR=""
	until [ $count -eq 10 ]
	do
		echo -n -e "\r[            ]"
		echo -n -e "\r[ "
		echo -n -e "$BAR▌"
		BAR="${BAR}▌"
		sleep 0.02
		count=`expr $count + 1`
	done
#	echo -n -e "\r[            ]"
	sleep 0.05
	}

function progressBar () {
	if [ $count -le 30 ]; then
		echo -n -e "\r[                                ]"
		echo -n -e "\r[ "
		echo -n -e "$BAR▌"
		BAR="${BAR}▌"
		count=`expr $count + 1`
	else
	BAR=""
	count=0
	fi
	
	}

function recolhaIMDB () {
if [[ $codeIMDB == "" ]]; then
echo -e '\E[32;40m\033[1mO processo foi cancelado porque é desconhecido o codigo IMDB de:\033[0m'
echo -e '\E[32;40m\033[1m'$caminhoCompleto'\033[0m'
exit 0
else
# echo -e '\E[1;37m\033[1mProcessar o filme '"$codeIMDB"' no Google / IMDB ...\033[0m'
echo -e "Processar o filme \E[1;37m\033[1m"$codeIMDB"\033[0m no Google / IMDB ..."
fi

###################################
# Procurar o filme no Google IMDB #
#								  #
if [[ $codeIMDB == "" ]]; then
echo "Procurar o filme no Google IMDB ..."
if [[ $renovarHTML == 1 ]]; then
echo "Descarregando HTML de http://www.google.com/search?hl=en&q=$FILME+imdb ..."
aguardarTempo 5
lynx -connect_timeout=10 --source "http://www.google.com/search?hl=en&q=$FILME+imdb" > $xbmcDestinoHtml/google_imdb.html 2> /dev/null
else
	if [[ ! -f "$xbmcDestinoHtml/google_imdb.html" ]]; then
	echo "Descarregando HTML de http://www.google.com/search?hl=en&q=$FILME+imdb ..."
	aguardarTempo 5
	lynx -connect_timeout=10 --source "http://www.google.com/search?hl=en&q=$FILME+imdb" > $xbmcDestinoHtml/google_imdb.html 2> /dev/null
	fi
fi
	# Validar se a erro na ligação
	if [ $? -ne 0 ]; then
	printf "A ligação ao servidor IMDB falhou. Verifique a sua ligação a internet!\n"; exit 192
	fi
fi
#								  #
# Procurar o filme no Google IMDB #
###################################

#############################################
# Identificar o endereços IMDB para o filme #
#											#
echo "Identificar o endereços IMDB para o filme..."
if [[ $codeIMDB == "" ]]; then
URLIMDB=`egrep -o "http://www.imdb.com/title/tt[0-9]*/" $xbmcDestinoHtml/google_imdb.html | head -1`
else
URLIMDB=$(echo -e "http://www.imdb.com/title/$codeIMDB/")
echo $URLIMDB
fi
URLIMDBC="${URLIMDB}combined"
URLIMDBCREDIT="${URLIMDB}fullcredits#writers"
#											#
# Identificar o endereços IMDB para o filme #
#############################################

#####################################
# Guardar os detalhes do filme IMDB #
#									#
echo "Guardar os detalhes do filme IMDB ..."
if [[ $renovarHTML == 1 ]]; then
	echo "Descarregando HTML de $URLIMDB ..."
	aguardarTempo 5
	lynx --source ${URLIMDB} > $xbmcDestinoHtml/imdb.html;
	echo "Descarregando HTML de $URLIMDBC ..."
	aguardarTempo 5
	lynx --source ${URLIMDBC} | sed -e 's/<\/div>/<\/div>\n/g' -e 's/<\/li>/<\/li>\n/g' -e 's/<\/tr>/<\/tr>\n/g' -e 's/<\/table>/<\/table>\n/g' -e 's/\&nbsp\;/ /g' -e 's/\&raquo\;//g' -e 's/<br>/<br>\n/g'> $xbmcDestinoHtml/imdb_combined.html;
	echo "Descarregando HTML de $URLIMDBCREDIT ..."
	aguardarTempo 5
	lynx --source ${URLIMDBCREDIT} | sed 's/<\/tr>/<\/tr>\n/g' | sed 's/<\/div>/<\/div>\n/g' | sed 's/<a name="cast"/\n<a name="cast"/g' > $xbmcDestinoHtml/imdb_credit.html;
else
	if [[ ! -f "$xbmcDestinoHtml/imdb.html" ]]; then
	echo "Descarregando HTML de $URLIMDB ..."
	aguardarTempo 5
	lynx --source ${URLIMDB} > $xbmcDestinoHtml/imdb.html;
	fi
	if [[ ! -f "$xbmcDestinoHtml/imdb_combined.html" ]]; then
	echo "Descarregando HTML de $URLIMDBC ..."
	aguardarTempo 5
	lynx --source ${URLIMDBC} | sed 's/<\/div>/<\/div>\n/g' | sed 's/<\/li>/<\/li>\n/g' | sed -e 's/<\/tr>/<\/tr>\n/g' | sed -e 's/<\/table>/<\/table>\n/g' | sed -e 's/\&nbsp\;/ /g' | sed -e 's/\&raquo\;//g' | sed -e 's/<br>/<br>\n/g'> $xbmcDestinoHtml/imdb_combined.html;
	fi
	if [[ ! -f "$xbmcDestinoHtml/imdb_credit.html" ]]; then
	echo "Descarregando HTML de $URLIMDBCREDIT ..."
	aguardarTempo 5
	lynx --source ${URLIMDBCREDIT} | sed 's/<\/tr>/<\/tr>\n/g' | sed 's/<\/div>/<\/div>\n/g' | sed 's/<a name="cast"/\n<a name="cast"/g' > $xbmcDestinoHtml/imdb_credit.html;
	fi
fi
#									#
# Guardar os detalhes do filme IMDB #
#####################################

##########################################
# Extrair informação (parse) CODIGO IMDB #
#										 #
echo "Extrair informação (parse) CODIGO IMDB..."
ImdbCode=$(echo ${URLIMDB} | awk -F/ '{print $5}')
#										 #
# Extrair informação (parse) CODIGO IMDB #
##########################################

#######################################
# Extrair informação (parse) ANO IMDB #
#									  #
#echo "Extrair informação (parse) ANO IMDB..."
#ANO=`cat $TMPFILEIMDBC | grep "<title>" | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | sed -e 's/\///g' | awk -F'(' '{print $2}' | egrep -o "[0-9][0-9][0-9][0-9]"`
#ANO=`cat $xbmcDestinoHtml/imdb_combined.html | grep "<title>" | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | sed -e 's/\///g' | sed -e 's/I)/)/g' | sed -e 's/I)/)/g' | sed -e 's/I)/)/g' | sed -e 's/V)/)/g' | sed -e 's/V)/)/g' | sed -e 's/V)/)/g' | sed -e 's/X)/)/g' | sed -e 's/X)/)/g' | sed -e 's/X)/)/g' | sed -e 's/(..)//g' | sed -e 's/(.)//g' | sed -e 's/(//g' | sed -e 's/)//g' | sed -e 's/  / /g' | sed -e 's/^\s*//;s/\s*$//g'| egrep -o "[0-9][0-9][0-9][0-9]$"`
ANO=`cat $xbmcDestinoHtml/imdb_combined.html | grep "<title>" | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' -e 's/\///g' -e 's/I)/)/g' -e 's/I)/)/g' -e 's/I)/)/g' -e 's/V)/)/g' -e 's/V)/)/g' -e 's/V)/)/g' -e 's/X)/)/g' -e 's/X)/)/g' -e 's/X)/)/g' -e 's/(..)//g' -e 's/(.)//g' -e 's/(//g' -e 's/)//g' -e 's/  / /g' -e 's/^\s*//;s/\s*$//g' | egrep -o "[0-9][0-9][0-9][0-9]$"`
limparCodeHTML "$ANO"
ANO="$limparCodeHTML"
#									  #
# Extrair informação (parse) ANO IMDB #
#######################################

##########################################
# Extrair informação (parse) TITULO IMDB #
#										 #
# esta a dar erro em tt0432373
#echo "Extrair informação (parse) TITULO IMDB..."
#TITULO=`cat $xbmcDestinoHtml/imdb_combined.html | grep "<title>" | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | sed -e 's/\///g' | sed -e 's/I)/)/g' | sed -e 's/I)/)/g' | sed -e 's/I)/)/g' | sed -e 's/V)/)/g' | sed -e 's/V)/)/g' | sed -e 's/V)/)/g' | sed -e 's/X)/)/g' | sed -e 's/X)/)/g' | sed -e 's/X)/)/g' | sed -e 's/([0-9][0-9][0-9][0-9])//g' | sed -e 's/(...)//g' | sed -e 's/(..)//g' | sed -e 's/(.)//g' | sed -e 's/()//g'| sed -e 's/^\s*//;s/\s*$//g'`
#TITULO=`cat $xbmcDestinoHtml/imdb_combined.html | grep "<title>" | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | sed -e 's/\///g' | sed -e 's/I)/)/g' | sed -e 's/I)/)/g' | sed -e 's/I)/)/g' | sed -e 's/V)/)/g' | sed -e 's/V)/)/g' | sed -e 's/V)/)/g' | sed -e 's/X)/)/g' | sed -e 's/X)/)/g' | sed -e 's/X)/)/g' | sed -e 's/([0-9][0-9][0-9][0-9])//g' | sed -e 's/(..)//g' | sed -e 's/(.)//g' | sed -e 's/()//g' | sed -e 's/()//g' | sed -e 's/()//g' | sed -e 's/  / /g' | sed -e 's/^\s*//;s/\s*$//g'`
TITULO=`cat $xbmcDestinoHtml/imdb_combined.html | grep "<title>" | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' -e 's/\///g' -e 's/I)/)/g' -e 's/I)/)/g' -e 's/I)/)/g' -e 's/V)/)/g' -e 's/V)/)/g' -e 's/V)/)/g' -e 's/X)/)/g' -e 's/X)/)/g' -e 's/X)/)/g' -e 's/([0-9][0-9][0-9][0-9])//g' -e 's/(..)//g' -e 's/(.)//g' -e 's/()//g' -e 's/()//g' -e 's/()//g' -e 's/  / /g' -e 's/^\s*//;s/\s*$//g'`
limparCodeHTML "$TITULO"
TITULO="$limparCodeHTML"
limparCodeInvalidMSDOS "$TITULO"
TITULOMSDOS="$limparCodeInvalidMSDOS"
#										 #
# Extrair informação (parse) TITULO IMDB #
##########################################


#######################################
# Extrair informação (parse) RAT IMDB #
#									  #
#echo "Extrair informação (parse) RAT IMDB..."
RAT=`cat $xbmcDestinoHtml/imdb_combined.html | sed -n '/<div class="starbar-meta">/,/<\/b>/{s/<[^>]*>//g;p}' | sed 's/ //g'| sed '/^$/d' | awk -F'/' '{print $1}' | sed 's/\./\,/g' | sed -e 's/^\s*//;s/\s*$//g'`
limparCodeHTML "$RAT"
RAT="$limparCodeHTML"
if [[ $RAT == "" ]]; then
	RAT="Informação indisponivel"
else
RAT=$(printf "%f" ${RAT})
fi
RAT=$(echo "$RAT" | sed 's/0\,000000//g')
if [[ $RAT == "" ]]; then
	RAT="Informação indisponivel"
fi
#									  #
# Extrair informação (parse) RAT IMDB #
#######################################

#########################################
# Extrair informação (parse) VOTES IMDB #
#										#
#echo "Extrair informação (parse) VOTES IMDB ..."
VOTES=`cat $xbmcDestinoHtml/imdb_combined.html | sed -n '/<a href="ratings" class="tn15more">/,/<\/div>/{s/<[^>]*>//g;p;}'`
VOTES=$(echo $VOTES | sed 's/\&nbsp;//g' | sed 's/\&raquo;//g' | sed 's/ //g' | sed '/^$/d' | sed 's/votes//g'| sed 's/\,//g' | sed -e 's/^\s*//;s/\s*$//g')
limparCodeHTML "$VOTES"
VOTES="$limparCodeHTML"
if [[ $VOTES == "" ]]; then
	VOTES="Informação indisponivel"
else
VOTES=$(echo -e $VOTES | sed ':a  s/\([[:digit:]]\)\([[:digit:]]\{3\}\(,\|$\)\)/\1,\2/; t a')
fi
#										#
# Extrair informação (parse) VOTES IMDB #
#########################################

########################################
# Extrair informação (parse) MPAA IMDB #
#									   #
#echo "Extrair informação (parse) MPAA IMDB"
MPAA=`cat  $xbmcDestinoHtml/imdb_combined.html | sed -n '/MPAA.*/,/div/{p}' | sed 's/MPAA//g' | sed 's/\://g' | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | sed 's/Additional Details//g' | sed -e 's/^\s*//;s/\s*$//g'`
limparCodeHTML "$MPAA"
MPAA="$limparCodeHTML"
if [[ $MPAA == "" ]]; then
	MPAA="Informação indisponivel"
fi
#									   #
# Extrair informação (parse) MPAA IMDB #
########################################

###########################################
# Extrair informação (parse) RUNTIME IMDB #
#										  #
#echo "Extrair informação (parse) RUNTIME IMDB..."
RUNTIME=`cat $xbmcDestinoHtml/imdb_combined.html | sed -n '/Runtime:/,/<\/div>/{s/<[^>]*>//g;s/ Runtime://;s/min /min/g;p}'`
limparCodeHTML "$RUNTIME"
RUNTIME="$limparCodeHTML"
#										  #
# Extrair informação (parse) RUNTIME IMDB #
###########################################

##########################################
# Extrair informação (parse) STUDIO IMDB #
#										 #
#echo "Extrair informação (parse) STUDIO IMDB..."
STUDIO=`cat $xbmcDestinoHtml/imdb_combined.html | sed -n '/Production Companies/,/<\/a>/{p}' | sed -e :a -e 's/<[^>]*>//g;/</N;//ba'| sed 's/Production Companies//'| sed '1q' | sed -e 's/([^(]*)//g' | sed -e 's/^\s*//;s/\s*$//g'`
limparCodeHTML "$STUDIO"
STUDIO="$limparCodeHTML"
#										 #
# Extrair informação (parse) STUDIO IMDB #
##########################################

###########################################
# Extrair informação (parse) COUNTRY IMDB #
#										  #
#echo "Extrair informação (parse) COUNTRY IMDB..."
COUNTRY=`cat  $xbmcDestinoHtml/imdb_combined.html | sed -n '/Country:/,/<\/div>/{s/<[^>]*>//g;s/Country://p}' | sed -e 's/^\s*//;s/\s*$//g'`
limparCodeHTML "$COUNTRY"
COUNTRY="$limparCodeHTML"
#									  	  #
# Extrair informação (parse) COUNTRY IMDB #
###########################################

#############################################
# Extrair informação (parse) PREMIERED IMDB #
#											#
# echo "Extrair informação (parse) PREMIERED IMDB..."
PREMIERED=`cat $xbmcDestinoHtml/imdb_combined.html | sed -n '/Release Date:*/,/<\/div>/{s/<[^>]*>//g;s/Release Date://;/^$/d;s/ (/(/g;s/([^(]*)//g;p}'`
limparCodeHTML "$PREMIERED"
PREMIERED="$limparCodeHTML"
if [[ $PREMIERED != "" ]]; then
MES=$(echo $PREMIERED | awk -F' ' '{print $2}')
	if date +%m -d"$MES 01 01" &> /dev/null
		then
		DIA=$(echo $PREMIERED | awk -F' ' '{print $1}')
		DIA=$(printf "%02d" $DIA)
		MES=`date +%m -d"$MES 01 01"`
		ANO=$(echo $PREMIERED | awk -F' ' '{print $3}')
		PREMIERED=$(echo "$ANO-$MES-$DIA")
		else
		PREMIERED="Informação indisponivel"
	fi
fi
#											#
# Extrair informação (parse) PREMIERED IMDB #
#############################################

#######################################
# Extrair informação (parse) DIR IMDB #
#									  #
#echo "Extrair informação (parse) DIR IMDB..."
DIR=`cat $xbmcDestinoHtml/imdb_combined.html | sed -n '/ *Director[s]*:.*/,/<\/div>/{ /<a *href="\/name\/nm[0-9][0-9]*\/"[^>]*>[^<]*<\/a>.*/p}' | sed  's/<\/a>/<\/a>\n/g' | sed -n 's/.*<a *href="\/name\/nm[0-9][0-9]*\/"[^>]*>\([^<]*\)<\/a>.*/\1/p;' | sed '1q' | sed -e 's/^\s*//;s/\s*$//g'`
limparCodeHTML "$DIR"
DIR="$limparCodeHTML"
#									  #
# Extrair informação (parse) DIR IMDB #
#######################################

##########################################
# Extrair informação (parse) WRITER IMDB #
#										 #
#echo "Extrair informação (parse) WRITER IMDB..."
WRITER=`cat $xbmcDestinoHtml/imdb_combined.html | sed -n '/Writing credits/,/<\/table>/{s/Writing credits//g;p}' | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | sed 's/ (WGA)//g'  | sed -e 's/([^(]*)//g' | sed -e 's/^[ ]//g' | sed -e 's/^\s*//;s/\s*$//g' | sed '/^$/d'`
limparCodeHTML "$WRITER"
WRITER="$limparCodeHTML"
WRITER=$(echo "$WRITER" | sed -e 's/&//g' | sed -e 's/  / /g' | sed -e 's/^\s*//;s/\s*$//g' | tr '\n' ';' | sed 's/;$//g' | sed 's/;/ | /g')
#										 #
# Extrair informação (parse) WRITER IMDB #
##########################################

#######################################
# Extrair informação (parse) GEN IMDB #
#									  #
#echo "Extrair informação (parse) GEN IMDB..."
GEN=`cat $xbmcDestinoHtml/imdb_combined.html | sed -n '/Genre:/,/<\/div>/{s/Genre://;p}' | sed -e :a -e 's/<[^>]*>//g;/</N;//ba'| sed 's/ See more //' | sed '/^$/d'`
limparCodeHTML "$GEN"
GEN="$limparCodeHTML"
#									  #
# Extrair informação (parse) GEN IMDB #
#######################################

########################################
# Extrair informação (parse) CAST IMDB #
#									   #
#echo "Extrair informação (parse) CAST IMDB..."
#CAST=`cat $xbmcDestinoHtml/imdb_credit.html | sed -n '/> Cast</,/<\/table>/{p}' | sed -e 's/<td class="nm">/\nActor:/g' | sed -e 's/<td class="char">/\;Papel:/g' | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | grep "Actor:" | sed 's/ ... //g' | sed 's/\.\.\.//g'`
CAST=$(cat $xbmcDestinoHtml/imdb_credit.html | sed -n '/> Cast</,/<\/table>/{p}' | sed -e 's/<td class="nm">/\nActor:/g' | sed -e 's/<td class="char">/\;Papel:/g' | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | grep "Actor:" | sed 's/ ... //g' | sed 's/\.\.\.//g')
limparCodeHTML "$CAST"
echo $limparCodeHTML | sed 's/Actor/\nActor/g' > $CASTFILEIMDB
CAST=$(cat $CASTFILEIMDB | sed 's/`/ /g')
CAST=( `echo "$CAST" | sed -e 's/  / /g;s/^\s*//;s/\s*$//g'` )
#limparCodeHTML "$CAST"
#CAST=$(echo "$limparCodeHTML" | sed -e 's/^\s*//;s/\s*$//g' | sed -e 's/`//g' )
#									   #
# Extrair informação (parse) CAST IMDB #
########################################

########################################
# Extrair informação (parse) PLOT IMDB #
#									   #
if [[ $descricaoManual == "" ]]; then
	#echo "Extrair informação (parse) PLOT IMDB..."
	PLOTIMDB=`cat $xbmcDestinoHtml/imdb.html | sed -n '/<h1.*>/,/<\/p>/p' | sed -n '/<p>/,/<\/p>/{ s/<[^>]*>//g;p;}' | sed 's/See full summary.*//g' | sed '/^$/d' | sed 's/^  *//g'`
	if [[ $PLOTIMDB != "" ]]; then
	limparCodeHTML "$PLOTIMDB"
	PLOTIMDB="$limparCodeHTML"
	PLOTIMDB=`echo $PLOTIMDB | sed 's/See full synopsis »//g'`
	PLOTIMDB=`echo -e "$PLOTIMDB\nFonte:IMDB"`
	else
	PLOTIMDB=$(echo -e "Informação indisponivel\nFonte:IMDB")
	fi
fi
#									   #
# Extrair informação (parse) PLOT IMDB #
########################################
}

function recolhaPTGATE () {
if [[ $descricaoManual == "" ]]; then
	echo -e "Processar o filme \E[1;37m\033[1m"$TITULO"\033[0m no PT GATE ..."
	# Procurar o filme no Google PTGATE
	if [[ $renovarHTML == 1 ]]; then
		echo "Descarregando HTML de http://www.google.com/search?q=site:cinema.ptgate.pt+$ImdbCode ..."
		aguardarTempo 5
		lynx -connect_timeout=10 --source "http://www.google.com/search?q=site:cinema.ptgate.pt+$ImdbCode" > $xbmcDestinoHtml/google_ptgate.html 2> /dev/null
	else
		if [[ ! -f "$xbmcDestinoHtml/google_ptgate.html" ]]; then
		echo "Descarregando HTML de http://www.google.com/search?q=site:cinema.ptgate.pt+$ImdbCode ..."
		aguardarTempo 5
		lynx -connect_timeout=10 --source "http://www.google.com/search?q=site:cinema.ptgate.pt+$ImdbCode" > $xbmcDestinoHtml/google_ptgate.html 2> /dev/null
		fi
	fi
	# Validar se a erro na ligação a PTGATE
	if [ $? -ne 0 ]; then
	printf "A ligação ao servidor PTGATE falhou... Verifique a sua ligação a internet!\n"; exit 192
	fi

	# Identificar o endereço PTGATE para o filme
	echo "Identificar o endereço PTGATE para o filme"
	URLPTGATE=`cat $xbmcDestinoHtml/google_ptgate.html | egrep -o "http://cinema.ptgate.pt/filmes/[0-9]*" | head -1`
	# Identificar o endereço PTGATE para o filme

	# Guardar os detalhes do filme PTGATE
	if [[ $URLPTGATE != "" ]]; then
		echo "Guardar os detalhes do filme PTGATE"
		if [[ $renovarHTML == 1 ]]; then
			echo "Descarregando HTML de $URLPTGATE ..."
			aguardarTempo 5
			lynx --source ${URLPTGATE} > $xbmcDestinoHtml/ptgate.html;
		else
			if [[ ! -f "$xbmcDestinoHtml/ptgate.html" ]]; then
			echo "Descarregando HTML de $URLPTGATE ..."
			aguardarTempo 5
			lynx --source ${URLPTGATE} > $xbmcDestinoHtml/ptgate.html;
			fi
		fi
		# Guardar os detalhes do filme PTGATE

		# Extrair informação (parse) CODIGO IMDB no PTGATE
		echo "Extrair informação (parse) CODIGO IMDB no PTGATE"
		ImdbCodePtgate=$(cat $xbmcDestinoHtml/ptgate.html | egrep -o "http://www.imdb.com/title/tt[0-9]*" | awk -F/ '{print $5}' | sed 's/ //g')
		# echo ImdbCodePtgate:$ImdbCodePtgate
		# Extrair informação (parse) CODIGO IMDB no PTGATE


		# Extrair informação (parse) PLOT PTGATE
		#cat $xbmcDestinoHtml/ptgate.html | sed -n '/<h1.*>/,/<\/p>/p' | sed -n '/<p>/,/<\/p>/{ s/<[^>]*>//g;p;}' | sed 's/Sinopse.*//g' > $PLOTFILEPTGATE
		PLOTPTGATE=`cat $xbmcDestinoHtml/ptgate.html | sed -n '/.*Sinopse.*/,/<\/div>/{ s/<[^>]*>//g;s/Sinopse//g;p }' | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | sed 's/^  *//g' | sed '/^$/d'| sed 's/\t//g' | iconv -f ISO8859-1 -t UTF8`
		if [[ $PLOTPTGATE != "" ]]; then
			limparCodeHTML "$PLOTPTGATE"
			PLOTPTGATE="$limparCodeHTML"
		fi
	else
	echo "A perquisa no Google não encontrou resultados no PT Gate"
	fi
fi
}

function recolhaDVDPT () {
if [[ $descricaoManual == "" ]]; then
	# Procurar o filme no Google DVDPT
	echo -e "Processar o filme \E[1;37m\033[1m"$TITULO"\033[0m no DVDPT ..."
	if [[ $renovarHTML == 1 ]]; then
		echo "Descarregando HTML de http://www.google.com/search?q=site:www.dvdpt.com+$TITULO ..."
		aguardarTempo 5
		lynx -connect_timeout=10 --source "http://www.google.com/search?q=site:www.dvdpt.com+$TITULO" > $xbmcDestinoHtml/google_dvdpt.html 2> /dev/null
	else
		if [[ ! -f "$xbmcDestinoHtml/google_dvdpt.html" ]]; then
		echo "Descarregando HTML de http://www.google.com/search?q=site:www.dvdpt.com+$TITULO ..."
		aguardarTempo 5
		lynx -connect_timeout=10 --source "http://www.google.com/search?q=site:www.dvdpt.com+$TITULO" > $xbmcDestinoHtml/google_dvdpt.html 2> /dev/null
		fi
	fi
	# Validar se a erro na ligação a DVDPT
	if [ $? -ne 0 ]; then
	printf "A ligação ao servidor DVDPT falhou... Verifique a sua ligação a internet!\n"; exit 192
	fi
	# Procurar o filme no Google DVDPT

	# Identificar o endereço DVDPT para o filme
	echo "Identificar o endereço DVDPT para o filme"
	URLDVDPT=`cat $xbmcDestinoHtml/google_dvdpt.html | egrep -o "http://www.dvdpt.com/./[0-9a-Z][0-9a-Z_]*.php" | head -1 | sed -e 's/\"//g'`
	# Identificar o endereço DVDPT para o filme

	# Guardar os detalhes do filme DVDPT
	if [[ $URLDVDPT != "" ]]; then
		echo "Guardar os detalhes do filme DVDPT"
		if [[ $renovarHTML == 1 ]]; then
			echo "Descarregando HTML de $URLDVDPT ..."
			aguardarTempo 5
			lynx --source ${URLDVDPT} | sed 's/<font color=red face=arial size=-1>/<font color=red face=arial size=-1>\n/g' > $xbmcDestinoHtml/dvdpt.html;
		else
			if [[ ! -f "$xbmcDestinoHtml/dvdpt.html" ]]; then
			echo "Descarregando HTML de $URLDVDPT ..."
			aguardarTempo 5
			lynx --source ${URLDVDPT} | sed 's/<font color=red face=arial size=-1>/<font color=red face=arial size=-1>\n/g' > $xbmcDestinoHtml/dvdpt.html;
			fi
		fi
		# Guardar os detalhes do filme DVDPT

		# Extrair informação (parse) CODIGO IMDB no DVDPT
		echo "Extrair informação (parse) CODIGO IMDB no DVDPT"
		ImdbCodeTest=$(cat $xbmcDestinoHtml/dvdpt.html | grep imdb.com | awk -F? '{print $1}')
		if [[ $ImdbCodeTest == "<a href=\"http://www.imdb.com/Details" ]]; then
		ImdbCodeDvdpt=$(cat $xbmcDestinoHtml/dvdpt.html | grep imdb.com | awk -F/ '{print $4}' | sed 's/Details?/tt/g' | sed 's/\">//g' | sed 's/ //g')
		else
		ImdbCodeDvdpt=$(cat $xbmcDestinoHtml/dvdpt.html | grep imdb.com | awk -F/ '{print $5}' | sed 's/ //g')
		fi
		# echo ImdbCodeDvdpt:$ImdbCodeDvdpt
		# Extrair informação (parse) CODIGO IMDB no DVDPT

		# Extrair informação (parse) PLOT DVDPT
		#cat  $xbmcDestinoHtml/dvdpt.html | sed -n '/<h1.*>/,/<\/p>/p' | sed -n '/<p>/,/<\/p>/{ s/<[^>]*>//g;p;}' | sed 's/SINOPSE.*//g' > $PLOTFILEDVDPT
		PLOTDVDPT=`cat $xbmcDestinoHtml/dvdpt.html | sed -n '/SINOPSE/,/<font color=red face=arial size=-1>/{ s/<[^>]*>//g;s/SINOPSE//g;p }' | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | sed 's/^  *//g' | sed '/^$/d'| sed 's/\t//g' | iconv -f ISO8859-1 -t UTF8`
		if [[ $PLOTDVDPT != "" ]]; then
		limparCodeHTML "$PLOTDVDPT"
		PLOTDVDPT="$limparCodeHTML"
		fi
		# Extrair informação (parse) PLOT DVDPT
	else
	echo "A perquisa no Google não encontrou resultados no DVDPT"
	fi
fi
}

function waitKey () {
    read -t 10 -p "[Ctrl][C] Aborta, [ENTER] Continua, (10 seg Continua...)"
    echo -e "\nContinuando ..."
    }

function recolhaTMDB () {
echo -e "Iniciar Recolha TMDB"
echo "Guardar XML do TMDB"
if [[ $codeTMDB == "" ]]; then
	if [[ $renovarHTML == 1 ]]; then
		echo "Descarregando JSON de http://api.themoviedb.org/3/movie/$codeIMDB?api_key=$APITMDB ..."
		curl -s --request GET 'http://api.themoviedb.org/3/movie/'$codeIMDB'?api_key='$APITMDB'' > $xbmcDestinoHtml/tmdb.json 2> /dev/null
		curl -s --request GET 'http://api.themoviedb.org/3/movie/'$codeIMDB'?api_key='$APITMDB'&language=pt' > $xbmcDestinoHtml/tmdb_pt.json 2> /dev/null
		curl -s --request GET 'http://api.themoviedb.org/3/movie/'$codeIMDB'/images?api_key='$APITMDB'' > $xbmcDestinoHtml/tmdb_images.json 2> /dev/null
		curl -s --request GET 'http://api.themoviedb.org/3/configuration?api_key='$APITMDB'' > $xbmcDestinoHtml/tmdb_config.json 2> /dev/null
	else
		if [[ ! -f "$xbmcDestinoHtml/tmdb.json" ]]; then
			echo "Descarregando JSON de http://api.themoviedb.org/3/movie/$codeIMDB?api_key=$APITMDB ..."
			curl -s --request GET 'http://api.themoviedb.org/3/movie/'$codeIMDB'?api_key='$APITMDB'' > $xbmcDestinoHtml/tmdb.json 2> /dev/null
			curl -s --request GET 'http://api.themoviedb.org/3/movie/'$codeIMDB'?api_key='$APITMDB'&language=pt' > $xbmcDestinoHtml/tmdb_pt.json 2> /dev/null
			curl -s --request GET 'http://api.themoviedb.org/3/movie/'$codeIMDB'/images?api_key='$APITMDB'' > $xbmcDestinoHtml/tmdb_images.json 2> /dev/null
			curl -s --request GET 'http://api.themoviedb.org/3/configuration?api_key='$APITMDB'' > $xbmcDestinoHtml/tmdb_config.json 2> /dev/null
		fi
	fi
else
	if [[ $renovarHTML == 1 ]]; then
		echo "Descarregando JSON de http://api.themoviedb.org/3/movie/$codeTMDB?api_key=$APITMDB ..."
		curl -s --request GET 'http://api.themoviedb.org/3/movie/'$codeTMDB'?api_key='$APITMDB'' > $xbmcDestinoHtml/tmdb.json 2> /dev/null
		curl -s --request GET 'http://api.themoviedb.org/3/movie/'$codeTMDB'?api_key='$APITMDB'&language=pt' > $xbmcDestinoHtml/tmdb_pt.json 2> /dev/null
		curl -s --request GET 'http://api.themoviedb.org/3/movie/'$codeTMDB'/images?api_key='$APITMDB'' > $xbmcDestinoHtml/tmdb_images.json 2> /dev/null
		curl -s --request GET 'http://api.themoviedb.org/3/configuration?api_key='$APITMDB'' > $xbmcDestinoHtml/tmdb_config.json 2> /dev/null
	else
		if [[ ! -f "$xbmcDestinoHtml/tmdb.json" ]]; then
			echo "Descarregando JSON de http://api.themoviedb.org/3/movie/$codeTMDB?api_key=$APITMDB ..."
			curl -s --request GET 'http://api.themoviedb.org/3/movie/'$codeTMDB'?api_key='$APITMDB'' > $xbmcDestinoHtml/tmdb.json 2> /dev/null
			curl -s --request GET 'http://api.themoviedb.org/3/movie/'$codeTMDB'?api_key='$APITMDB'&language=pt' > $xbmcDestinoHtml/tmdb_pt.json 2> /dev/null
			curl -s --request GET 'http://api.themoviedb.org/3/movie/'$codeTMDB'/images?api_key='$APITMDB'' > $xbmcDestinoHtml/tmdb_images.json 2> /dev/null
			curl -s --request GET 'http://api.themoviedb.org/3/configuration?api_key='$APITMDB'' > $xbmcDestinoHtml/tmdb_config.json 2> /dev/null
		fi
	fi
fi


echo " Identificar codeTMDB caso nao exista"
if [[ $codeTMDB == "" ]]; then
	codeTMDB=$(cat $xbmcDestinoHtml/tmdb.json | json.sh -b | grep "\[\"id\"\]" | grep -o [0-9].*.[0-9])
fi

echo " Extrair informação (parse) PLOT TMDB"
	ptTMDB=$(cat $xbmcDestinoHtml/tmdb_pt.json | json.sh -b | grep "\[\"overview\"\]" | grep -o null)
	if [[ $ptTMDB != "null" ]]; then
		PLOTTMDB=`cat $xbmcDestinoHtml/tmdb_pt.json | json.sh -b | grep "\[\"overview\"\]" | awk -F'\t' '{ print $2 }'`
		limparCodeHTML "$PLOTTMDB"
		PLOTTMDB="$limparCodeHTML"
	fi


echo "Processar Posters do TMDB"
if [[ -f $caminhoCompleto/poster.jpg ]]; then
mv "$caminhoCompleto/poster.jpg" "$caminhoCompleto/poster0.jpg"
fi

fileURL=$(cat $xbmcDestinoHtml/tmdb_config.json | json.sh -b |  grep -o "http:.*/")
echo fileURL="$fileURL"

imgPOSTER=( `cat $xbmcDestinoHtml/tmdb_images.json | json.sh -b | grep file_path | grep posters | awk -F'\t' '{ print $2 }' | sed -e 's/"//g;s/\///g'` )
CONTADOR=""
if [[ $imgPOSTER != "" ]]; then
	for CONTADOR in $(seq 0 $((${#imgPOSTER[*]} - 1))); do
		if [[ ! -f "$caminhoCompleto/poster$CONTADOR.jpg" ]]; then
		aguardarTempo 5
		echo "$caminhoCompleto/poster$CONTADOR.jpg"
		wget --timeout 30 -t 1 -O - "$fileURL""original/${imgPOSTER[$CONTADOR]}" > $caminhoCompleto/poster$CONTADOR.jpg 2> /dev/null
		fi
	done
fi
if [[ -f $caminhoCompleto/poster0.jpg ]]; then
	if [[ ! -f $caminhoCompleto/folder.jpg ]]; then
	cp "$caminhoCompleto/poster0.jpg" "$caminhoCompleto/folder.jpg"
	fi
fi
if [[ -f $caminhoCompleto/poster0.jpg ]]; then
mv "$caminhoCompleto/poster0.jpg" "$caminhoCompleto/poster.jpg"
fi

echo "Processar Backdrops do TMDB"
if [[ -f $caminhoCompleto/backdrop.jpg ]]; then
mv "$caminhoCompleto/backdrop.jpg" "$caminhoCompleto/backdrop0.jpg"
fi

imgBACKDROP=( `cat $xbmcDestinoHtml/tmdb_images.json | json.sh -b | grep file_path | grep backdrops | awk -F'\t' '{ print $2 }' | sed -e 's/"//g;s/\///g'` )
CONTADOR=""
if [[ $imgBACKDROP != "" ]]; then
	for CONTADOR in $(seq 0 $((${#imgBACKDROP[*]} - 1))); do
		if [[ ! -f "$caminhoCompleto/backdrop$CONTADOR.jpg" ]]; then
		aguardarTempo 5
		echo "$caminhoCompleto/backdrop$CONTADOR.jpg"
		wget --timeout 30 -t 1 -O - "$fileURL""original/${imgBACKDROP[$CONTADOR]}" > $caminhoCompleto/backdrop$CONTADOR.jpg 2> /dev/null
		fi
	done
fi
if [[ -f $caminhoCompleto/backdrop0.jpg ]]; then
	if [[ ! -f $caminhoCompleto/fanart.jpg ]]; then
	cp "$caminhoCompleto/backdrop0.jpg" "$caminhoCompleto/fanart.jpg"
	fi
fi

if [[ -f $caminhoCompleto/backdrop0.jpg ]]; then
mv "$caminhoCompleto/backdrop0.jpg" "$caminhoCompleto/backdrop.jpg"
fi



}

function processarSINOPSE () {
if [[ $ImdbCodeDvdpt != "" ]]; then
#echo "ImdbCodeDvdpt não esta vazio (1)"
	if [[ $ImdbCodeDvdpt != $ImdbCode ]]; then
#		echo "ImdbCodeDvdpt sao diferentes"
		if [[ $ImdbCodePtgate != "" ]]; then
#			echo "ImdbCodePtgate não esta vazio"
			if [[ $ImdbCodePtgate == $ImdbCode ]]; then
#				echo "ImdbCodePtgate e ImdbCode sao iguais"
				if [[ $PLOTPTGATE != "Não existe uma sinopse para este filme. Adicionar uma sinopse." ]]; then
#					echo "PTGATE tem descrição"
					echo "Escolhida sinopse PT GATE"
					# PLOT=`echo -e "$PLOTPTGATE\n$URLIMDB\n$URLPTGATE"`
					PLOT=`echo -e "$PLOTPTGATE\nFonte:PTGATE"`
					testeFontePLOT=PTGATE
#					echo -e "Descrição: $PLOT"
				else
#					echo "PTGATE não tem descrição"
					echo "Escolhida sinopse IMDB"
					PLOT="$PLOTIMDB"
					testeFontePLOT=IMDB
#					echo -e "Descrição: $PLOT"
				fi
			else
#			echo "ImdbCodePtgate e ImdbCode não são iguais"
			echo "Escolhida sinopse IMDB"
			PLOT="$PLOTIMDB"
			testeFontePLOT=IMDB
#			echo "Descrição: $PLOT"
			fi
		else
#		echo "ImdbCodePtgate esta vazio"
		echo "Escolhida sinopse IMDB"
		PLOT="$PLOTIMDB"
		testeFontePLOT=IMDB
#		echo -e "Descrição: $PLOT"
		fi
	else
#	echo "ImdbCodeDvdpt ImdbCode são iguais"
	echo "Escolhida sinopse DVD PT"
	PLOT=`echo -e "$PLOTDVDPT\nFonte:DVDPT"`
	testeFontePLOT=DVDPT
#	echo -e "Descrição: $PLOT"
	fi
else
#	echo Fase2
	if [[ $ImdbCodePtgate != "" ]]; then
#	echo "ImdbCodePtgate não esta vazio(2)"
			if [[ $ImdbCodePtgate == $ImdbCode ]]; then
#			echo "ImdbCodePtgate e ImdbCode sao iguais"
				if [[ $PLOTPTGATE != "Não existe uma sinopse para este filme. Adicionar uma sinopse." ]]; then
#					echo "PTGATE tem descrição"
					echo "Escolhida sinopse PT GATE"
					PLOT=`echo -e "$PLOTPTGATE\nFonte:PTGATE"`
					testeFontePLOT=PTGATE
#					echo -e "Descrição: $PLOT"
				else
#					echo "PTGATE não tem descrição"
					echo "Escolhida sinopse IMDB"
					PLOT="$PLOTIMDB"
					testeFontePLOT=IMDB
#					echo -e "Descrição: $PLOT"
				fi
			else
#			echo "ImdbCodePtgate e ImdbCode não são iguais"
			echo "Escolhida sinopse IMDB"
			PLOT="$PLOTIMDB"
			testeFontePLOT=IMDB
#			echo -e "Descrição: $PLOT"
			fi
	else
#	echo "ImdbCodePtgate esta vazio"
	echo "Escolhida sinopse IMDB"
	PLOT="$PLOTIMDB"
	testeFontePLOT=IMDB
#	echo "Descrição: $PLOT"
	fi
fi


if [[ $testeFontePLOT == "Fonte:IMDB" ]]; then
	echo "A Sinopse utilizada passa a ser a do TMDB!"
	PLOT=$(echo -e "$PLOTTMDB\nFonte:TMDB")
fi
}

function limparCodeHTML () {
	limparCodeHTML=$(echo -e "$1" | sed -e '{
						s/\/\…/g
						s/\/\`/g
						s/\/\"/g
						s/\&#x96\;/–/g
						s/\&#x92\;/\̒/g
						s/\&rdquo\;/\”/g
						s/\&#xFB\;/\û/g
						s/\&#xF4\;/\ô/g
						s/\&#8221\;/\”/g
						s/\&#x201D\;/\”/g
						s/\&quot\;/\"/g
						s/\&#34\;/\"/g
						s/\&#x22\;/\"/g
						s/\&#39\;/\`/g
						s/\&#x27\;/\`/g
						s/\&#176\;/\°/g
						s/\&deg\;/\°/g
						s/\&#43\;/\0/g
						s/\&#177\;/\±/g
						s/\&plusmn\;/\±/g
						s/\&#247\;/\÷/g
						s/\&divide\;/\÷/g
						s/\&#215\;/\×/g
						s/\&times\;/\×/g
						s/\&#60\;/\</g
						s/\&lt\;/\</g
						s/\&#61\;/\=/g
						s/\&#62\;/\>/g
						s/\&gt\;/\>/g
						s/\&#172\;/\¬/g
						s/\&not\;/\¬/g
						s/\&#124\;/\|/g
						s/\&#166\;/\¦/g
						s/\&brvbar\;/\¦/g
						s/\&#126\;/\~/g
						s/\&#164\;/\¤/g
						s/\&curren\;/\¤/g
						s/\&#162\;/\¢/g
						s/\&cent\;/\¢/g
						s/\&#36\;/\$/g
						s/\&#163\;/\£/g
						s/\&pound\;/\£/g
						s/\&#165\;/\¥/g
						s/\&yen\;/\¥/g
						s/\&#185\;/\¹/g
						s/\&sup1\;/\¹/g
						s/\&#189\;/\½/g
						s/\&frac12\;/\½/g
						s/\&#188\;/\¼/g
						s/\&frac14\;/\¼/g
						s/\&#178\;/\²/g
						s/\&sup2\;/\²/g
						s/\&#179\;/\³/g
						s/\&sup3\;/\³/g
						s/\&#190\;/\¾/g
						s/\&frac34\;/\¾/g
						s/\&#65\;/\A/g
						s/\&#97\;/\a/g
						s/\&#170\;/\ª/g
						s/\&ordf\;/\ª/g
						s/\&#193\;/\Á/g
						s/\&#225\;/\á/g
						s/\&Aacute\;/\Á/g
						s/\&aacute\;/\á/g
						s/\&#192\;/\À/g
						s/\&#224\;/\à/g
						s/\&Agrave\;/\À/g
						s/\&agrave\;/\à/g
						s/\&#194\;/\Â/g
						s/\&#226\;/\â/g
						s/\&Acirc\;/\Â/g
						s/\&acirc\;/\â/g
						s/\&#197\;/\Å/g
						s/\&#229\;/\å/g
						s/\&Aring\;/\Å/g
						s/\&aring\;/\å/g
						s/\&#196\;/\Ä/g
						s/\&#228\;/\ä/g
						s/\&Auml\;/\Ä/g
						s/\&auml\;/\ä/g
						s/\&#195\;/\Ã/g
						s/\&#227\;/\ã/g
						s/\&Atilde\;/\Ã/g
						s/\&atilde\;/\ã/g
						s/\&#198\;/\Æ/g
						s/\&#230\;/\æ/g
						s/\&AElig\;/\Æ/g
						s/\&aelig\;/\æ/g
						s/\&#66\;/\B/g
						s/\&#98\;/\b/g
						s/\&#67\;/\C/g
						s/\&#99\;/\c/g
						s/\&#199\;/\Ç/g
						s/\&#231\;/\ç/g
						s/\&Ccedil\;/\Ç/g
						s/\&ccedil\;/\ç/g
						s/\&#68\;/\D/g
						s/\&#100\;/\d/g
						s/\&#208\;/\Ð/g
						s/\&#240\;/\ð/g
						s/\&ETH\;/\Ð/g
						s/\&eth\;/\ð/g
						s/\&#69\;/\E/g
						s/\&#101\;/\e/g
						s/\&#201\;/\É/g
						s/\&#233\;/\é/g
						s/\&Eacute\;/\É/g
						s/\&eacute\;/\é/g
						s/\&#200\;/\È/g
						s/\&#232\;/\è/g
						s/\&Egrave\;/\È/g
						s/\&egrave\;/\è/g
						s/\&#202\;/\Ê/g
						s/\&#234\;/\ê/g
						s/\&Ecirc\;/\Ê/g
						s/\&ecirc\;/\ê/g
						s/\&#203\;/\Ë/g
						s/\&#235\;/\ë/g
						s/\&Euml\;/\Ë/g
						s/\&euml\;/\ë/g
						s/\&#70\;/\F/g
						s/\&#102\;/\f/g
						s/\&#71\;/\ /g
						s/\&#103\;/\ /g
						s/\&#72\;/\H/g
						s/\&#104\;/\h/g
						s/\&#73\;/\I/g
						s/\&#105\;/\i/g
						s/\&#205\;/\Í/g
						s/\&#237\;/\í/g
						s/\&Iacute\;/\Í/g
						s/\&iacute\;/\í/g
						s/\&#204\;/\Ì/g
						s/\&#236\;/\ì/g
						s/\&Igrave\;/\Ì/g
						s/\&igrave\;/\ì/g
						s/\&#206\;/\Î/g
						s/\&#238\;/\î/g
						s/\&Icirc\;/\Î/g
						s/\&icirc\;/\î/g
						s/\&#207\;/\Ï/g
						s/\&#239\;/\ï/g
						s/\&Iuml\;/\Ï/g
						s/\&iuml\;/\ï/g
						s/\&#74\;/\J/g
						s/\&#106\;/\j/g
						s/\&#75\;/\K/g
						s/\&#107\;/\k/g
						s/\&#76\;/\L/g
						s/\&#108\;/\l/g
						s/\&#77\;/\M/g
						s/\&#109\;/\m/g
						s/\&#78\;/\N/g
						s/\&#110\;/\n/g
						s/\&#209\;/\Ñ/g
						s/\&#241\;/\ñ/g
						s/\&Ntilde\;/\Ñ/g
						s/\&ntilde\;/\ñ/g
						s/\&#79\;/\O/g
						s/\&#111\;/\o/g
						s/\&#186\;/\º/g
						s/\&ordm\;/\º/g
						s/\&#211\;/\Ó/g
						s/\&#243\;/\ó/g
						s/\&Oacute\;/\Ó/g
						s/\&oacute\;/\ó/g
						s/\&#210\;/\Ò/g
						s/\&#242\;/\ò/g
						s/\&Ograve\;/\Ò/g
						s/\&ograve\;/\ò/g
						s/\&#212\;/\Ô/g
						s/\&#244\;/\ô/g
						s/\&Ocirc\;/\Ô/g
						s/\&ocirc\;/\ô/g
						s/\&#214\;/\Ö/g
						s/\&#246\;/\ö/g
						s/\&Ouml\;/\Ö/g
						s/\&ouml\;/\ö/g
						s/\&#213\;/\Õ/g
						s/\&#245\;/\õ/g
						s/\&Otilde\;/\Õ/g
						s/\&otilde\;/\õ/g
						s/\&#216\;/\Ø/g
						s/\&#248\;/\ø/g
						s/\&Oslash\;/\Ø/g
						s/\&oslash\;/\ø/g
						s/\&#80\;/\P/g
						s/\&#112\;/\p/g
						s/\&#81\;/\Q/g
						s/\&#113\;/\q/g
						s/\&#82\;/\R/g
						s/\&#114\;/\r/g
						s/\&#83\;/\ /g
						s/\&#115\;/\ /g
						s/\&#223\;/\ß/g
						s/\&szlig\;/\ß/g
						s/\&#84\;/\T/g
						s/\&#116\;/\t/g
						s/\&#85\;/\U/g
						s/\&#117\;/\u/g
						s/\&#218\;/\Ú/g
						s/\&#250\;/\ú/g
						s/\&Uacute\;/\Ú/g
						s/\&uacute\;/\ú/g
						s/\&#48\;/0/g
						s/\&#49\;/1/g
						s/\&#50\;/2/g
						s/\&#51\;/3/g
						s/\&#52\;/4/g
						s/\&#53\;/5/g
						s/\&#54\;/6/g
						s/\&#55\;/7/g
						s/\&#56\;/8/g
						s/\&#57\;/9/g
						s/\&#32\;/\ /g
						s/\#96\;/\`/g
						s/\&#180\;/\´/g
						s/\&acute\;/\´/g
						s/\&#94\;/\^/g
						s/\&#175\;/\¯/g
						s/\&macr\;/\¯/g
						s/\&#168\;/\¨/g
						s/\&uml\;/\¨/g
						s/\&#184\;/\¸/g
						s/\&cedil\;/\¸/g
						s/\&#95\;/\_/g
						s/\&#173\;/\ /g
						s/\&shy\;/\ /g
						s/\&#45\;/\0/g
						s/\&#44\;/\0/g
						s/\&#59\;/\;/g
						s/\&#58\;/\:/g
						s/\&#33\;/\!/g
						s/\&#161\;/\¡/g
						s/\&iexcl\;/\¡/g
						s/\&#63\;/\?/g
						s/\&#191\;/\¿/g
						s/\&iquest\;/\¿/g
						s/\&#46\;/\./g
						s/\&#183\;/\·/g
						s/\&middot\;/\·/g
						s/\&#171\;/\«/g
						s/\&laquo\;/\«/g
						s/\&#187\;/\»/g
						s/\&raquo\;/\»/g
						s/\&#40\;/\(/g
						s/\&#41\;/\)/g
						s/\&#91\;/\[/g
						s/\&#93\;/\]/g
						s/\&#123\;/\{/g
						s/\&#125\;/\}/g
						s/\&#167\;/\§/g
						s/\&sect\;/\§/g
						s/\&#182\;/\¶/g
						s/\&para\;/\¶/g
						s/\&#169\;/\©/g
						s/\&copy\;/\©/g
						s/\&#174\;/\®/g
						s/\&reg\;/\®/g
						s/\&#64\;/\@/g
						s/\&#42\;/\*/g
						s/\&#47\;/\//g
						s/\&#92\;/\\/g
						s/\&#38\;/\&/g
						s/\&amp\;/\&/g
						s/\&amp/\&/g
						s/\&#35\;/\#/g
						s/\&#37\;/\%/g
						s/\&#217\;/\Ù/g
						s/\&#249\;/\ù/g
						s/\&Ugrave\;/\Ù/g
						s/\&ugrave\;/\ù/g
						s/\&#219\;/\Û/g
						s/\&#251\;/\û/g
						s/\&Ucirc\;/\Û/g
						s/\&ucirc\;/\û/g
						s/\&#220\;/\Ü/g
						s/\&#252\;/\ü/g
						s/\&Uuml\;/\Ü/g
						s/\&uuml\;/\ü/g
						s/\&#86\;/\V/g
						s/\&#118\;/\v/g
						s/\&#87\;/\W/g
						s/\&#119\;/\w/g
						s/\&#88\;/\X/g
						s/\&#120\;/\x/g
						s/\&#89\;/\Y/g
						s/\&#121\;/\y/g
						s/\&#221\;/\Ý/g
						s/\&#253\;/\ý/g
						s/\&Yacute\;/\Ý/g
						s/\&yacute\;/\ý/g
						s/\&#255\;/\ÿ/g
						s/\&yuml\;/\ÿ/g
						s/\&#90\;/\Z/g
						s/\&#122\;/\z/g
						s/\&#222\;/\Þ/g
						s/\&#254\;/\þ/g
						s/\&THORN\;/\Þ/g
						s/\&thorn\;/\þ/g
						s/\&#181\;/\µ/g
						s/\&micro\;/\µ/g
						s/\&#160\;/\ /g
						s/\&nbsp\;/\ /g
						s/\&shy\;/\ /g
						s/\&fnof\;/\ƒ/g
						s/\&Alpha\;/\Α/g
						s/\&Beta\;/\Β/g
						s/\&Gamma\;/\Γ/g
						s/\&Delta\;/\Δ/g
						s/\&Epsilon\;/\Ε/g
						s/\&Zeta\;/\Ζ/g
						s/\&Eta\;/\Η/g
						s/\&Theta\;/\Θ/g
						s/\&Iota\;/\Ι/g
						s/\&Kappa\;/\Κ/g
						s/\&Lambda\;/\Λ/g
						s/\&Mu\;/\Μ/g
						s/\&Nu\;/\Ν/g
						s/\&Xi\;/\Ξ/g
						s/\&Omicron\;/\Ο/g
						s/\&Pi\;/\Π/g
						s/\&Rho\;/\Ρ/g
						s/\&Sigma\;/\Σ/g
						s/\&Tau\;/\Τ/g
						s/\&Upsilon\;/\Υ/g
						s/\&Phi\;/\Φ/g
						s/\&Chi\;/\Χ/g
						s/\&Psi\;/\Ψ/g
						s/\&Omega\;/\Ω/g
						s/\&alpha\;/\α/g
						s/\&beta\;/\β/g
						s/\&gamma\;/\γ/g
						s/\&delta\;/\δ/g
						s/\&epsilon\;/\ε/g
						s/\&zeta\;/\ζ/g
						s/\&eta\;/\η/g
						s/\&theta\;/\θ/g
						s/\&iota\;/\ι/g
						s/\&kappa\;/\κ/g
						s/\&lambda\;/\λ/g
						s/\&mu\;/\μ/g
						s/\&nu\;/\ν/g
						s/\&xi\;/\ξ/g
						s/\&omicron\;/\ο/g
						s/\&pi\;/\π/g
						s/\&rho\;/\ρ/g
						s/\&sigmaf\;/\ς/g
						s/\&sigma\;/\σ/g
						s/\&tau\;/\τ/g
						s/\&upsilon\;/\υ/g
						s/\&phi\;/\φ/g
						s/\&chi\;/\χ/g
						s/\&psi\;/\ψ/g
						s/\&omega\;/\ω/g
						s/\&thetasym\;/\ϑ/g
						s/\&upsih\;/\ϒ/g
						s/\&piv\;/\ϖ/g
						s/\&bull\;/\•/g
						s/\&hellip\;/\…/g
						s/\&prime\;/\′/g
						s/\&Prime\;/\″/g
						s/\&oline\;/\‾/g
						s/\&frasl\;/\⁄/g
						s/\&weierp\;/\℘/g
						s/\&image\;/\ℑ/g
						s/\&real\;/\ℜ/g
						s/\&trade\;/\™/g
						s/\&alefsym\;/\ℵ/g
						s/\&larr\;/\←/g
						s/\&uarr\;/\↑/g
						s/\&rarr\;/\→/g
						s/\&darr\;/\↓/g
						s/\&harr\;/\↔/g
						s/\&crarr\;/\↵/g
						s/\&lArr\;/\⇐/g
						s/\&uArr\;/\⇑/g
						s/\&rArr\;/\⇒/g
						s/\&dArr\;/\⇓/g
						s/\&hArr\;/\⇔/g
						s/\&forall\;/\∀/g
						s/\&part\;/\∂/g
						s/\&exist\;/\∃/g
						s/\&empty\;/\∅/g
						s/\&nabla\;/\∇/g
						s/\&isin\;/\∈/g
						s/\&notin\;/\∉/g
						s/\&ni\;/\∋/g
						s/\&prod\;/\∏/g
						s/\&sum\;/\∑/g
						s/\&minus\;/\−/g
						s/\&lowast\;/\∗/g
						s/\&radic\;/\√/g
						s/\&prop\;/\∝/g
						s/\&infin\;/\∞/g
						s/\&ang\;/\∠/g
						s/\&and\;/\∧/g
						s/\&or\;/\∨/g
						s/\&cap\;/\∩/g
						s/\&cup\;/\∪/g
						s/\&int\;/\∫/g
						s/\&there4\;/\∴/g
						s/\&sim\;/\∼/g
						s/\&cong\;/\≅/g
						s/\&asymp\;/\≈/g
						s/\&ne\;/\≠/g
						s/\&equiv\;/\≡/g
						s/\&le\;/\≤/g
						s/\&ge\;/\≥/g
						s/\&sub\;/\⊂/g
						s/\&sup\;/\⊃/g
						s/\&nsub\;/\⊄/g
						s/\&sube\;/\⊆/g
						s/\&supe\;/\⊇/g
						s/\&oplus\;/\⊕/g
						s/\&otimes\;/\⊗/g
						s/\&perp\;/\⊥/g
						s/\&sdot\;/\⋅/g
						s/\&lceil\;/\⌈/g
						s/\&rceil\;/\⌉/g
						s/\&lfloor\;/\⌊/g
						s/\&rfloor\;/\⌋/g
						s/\&lang\;/\〈/g
						s/\&rang\;/\〉/g
						s/\&loz\;/\◊/g
						s/\&spades\;/\♠/g
						s/\&clubs\;/\♣/g
						s/\&hearts\;/\♥/g
						s/\&diams\;/\♦/g
						s/\&OElig\;/\Œ/g
						s/\&oelig\;/\œ/g
						s/\&Scaron\;/\Š/g
						s/\&scaron\;/\š/g
						s/\&Yuml\;/\Ÿ/g
						s/\&circ\;/\ˆ/g
						s/\&tilde\;/\˜/g
						s/\&ensp\;/\ /g
						s/\&emsp\;/\ /g
						s/\&thinsp\;/\ /g
						s/\&zwnj\;/\‌/g
						s/\&zwj\;/\‍/g
						s/\&lrm\;/\‎/g
						s/\&rlm\;/\‏/g
						s/\&ndash\;/\–/g
						s/\&mdash\;/\—/g
						s/\&lsquo\;/\‘/g
						s/\&rsquo\;/\’/g
						s/\&sbquo\;/\‚/g
						s/\&ldquo\;/\“/g
						s/\&bdquo\;/\„/g
						s/\&dagger\;/\†/g
						s/\&Dagger\;/\‡/g
						s/\&permil\;/\‰/g
						s/\&lsaquo\;/\‹/g
						s/\&rsaquo\;/\›/g
						s/\&euro\;/\€/g
						s/\&#xA0\;/\ /g
						s/\&#xA1\;/\¡/g
						s/\&#xA2\;/\¢/g
						s/\&#xA3\;/\£/g
						s/\&#xA4\;/\¤/g
						s/\&#xA5\;/\¥/g
						s/\&#xA6\;/\¦/g
						s/\&#xA7\;/\§/g
						s/\&#xA8\;/\¨/g
						s/\&#xA9\;/\©/g
						s/\&#xAA\;/\ª/g
						s/\&#xAB\;/\«/g
						s/\&#xAC\;/\¬/g
						s/\&#xAD\;/\­/g
						s/\&#xAE\;/\®/g
						s/\&#xAF\;/\¯/g
						s/\&#xB0\;/\°/g
						s/\&#xB1\;/\±/g
						s/\&#xB2\;/\²/g
						s/\&#xB3\;/\³/g
						s/\&#xB4\;/\´/g
						s/\&#xB5\;/\µ/g
						s/\&#xB6\;/\¶/g
						s/\&#xB7\;/\·/g
						s/\&#xB8\;/\¸/g
						s/\&#xB9\;/\¹/g
						s/\&#xBA\;/\º/g
						s/\&#xBB\;/\»/g
						s/\&#xBC\;/\¼/g
						s/\&#xBD\;/\½/g
						s/\&#xBE\;/\¾/g
						s/\&#xBF\;/\¿/g
						s/\&#xC0\;/\À/g
						s/\&#xC1\;/\Á/g
						s/\&#xC2\;/\Â/g
						s/\&#xC3\;/\Ã/g
						s/\&#xC4\;/\Ä/g
						s/\&#xC5\;/\Å/g
						s/\&#xC6\;/\Æ/g
						s/\&#xC7\;/\Ç/g
						s/\&#xC8\;/\È/g
						s/\&#xC9\;/\É/g
						s/\&#xCA\;/\Ê/g
						s/\&#xCB\;/\Ë/g
						s/\&#xCC\;/\Ì/g
						s/\&#xCD\;/\Í/g
						s/\&#xCE\;/\Î/g
						s/\&#xCF\;/\Ï/g
						s/\&#xD0\;/\Ð/g
						s/\&#xD1\;/\Ñ/g
						s/\&#xD2\;/\Ò/g
						s/\&#xD3\;/\Ó/g
						s/\&#xD4\;/\Ô/g
						s/\&#xD5\;/\Õ/g
						s/\&#xD6\;/\Ö/g
						s/\&#xD7\;/\×/g
						s/\&#xD8\;/\Ø/g
						s/\&#xD9\;/\Ù/g
						s/\&#xDA\;/\Ú/g
						s/\&#xDB\;/\Û/g
						s/\&#xDC\;/\Ü/g
						s/\&#xDD\;/\Ý/g
						s/\&#xDE\;/\Þ/g
						s/\&#xDF\;/\ß/g
						s/\&#xE0\;/\à/g
						s/\&#xE1\;/\á/g
						s/\&#xE2\;/\â/g
						s/\&#xE3\;/\ã/g
						s/\&#xE4\;/\ä/g
						s/\&#xE5\;/\å/g
						s/\&#xE6\;/\æ/g
						s/\&#xE7\;/\ç/g
						s/\&#xE8\;/\è/g
						s/\&#xE9\;/\é/g
						s/\&#xEA\;/\ê/g
						s/\&#xEB\;/\ë/g
						s/\&#xEC\;/\ì/g
						s/\&#xED\;/\í/g
						s/\&#xEE\;/\î/g
						s/\&#xEF\;/\ï/g
						s/\&#xF0\;/\ð/g
						s/\&#xF1\;/\ñ/g
						s/\&#xF2\;/\ò/g
						s/\&#xF3\;/\ó/g
						s/\&#xF5\;/\õ/g
						s/\&#xF6\;/\ö/g
						s/\&#xF7\;/\÷/g
						s/\&#xF8\;/\ø/g
						s/\&#xF9\;/\ù/g
						s/\&#xFA\;/\ú/g
						s/\&#xFC\;/\ü/g
						s/\&#xFD\;/\ý/g
						s/\&#xFE\;/\þ/g
						s/\&#xFF\;/\ÿ/g
						s/\&#x192\;/\ƒ/g
						s/\&#x391\;/\Α/g
						s/\&#x392\;/\Β/g
						s/\&#x393\;/\Γ/g
						s/\&#x394\;/\Δ/g
						s/\&#x395\;/\Ε/g
						s/\&#x396\;/\Ζ/g
						s/\&#x397\;/\Η/g
						s/\&#x398\;/\Θ/g
						s/\&#x399\;/\Ι/g
						s/\&#x39A\;/\Κ/g
						s/\&#x39B\;/\Λ/g
						s/\&#x39C\;/\Μ/g
						s/\&#x39D\;/\Ν/g
						s/\&#x39E\;/\Ξ/g
						s/\&#x39F\;/\Ο/g
						s/\&#x3A0\;/\Π/g
						s/\&#x3A1\;/\Ρ/g
						s/\&#x3A3\;/\Σ/g
						s/\&#x3A4\;/\Τ/g
						s/\&#x3A5\;/\Υ/g
						s/\&#x3A6\;/\Φ/g
						s/\&#x3A7\;/\Χ/g
						s/\&#x3A8\;/\Ψ/g
						s/\&#x3A9\;/\Ω/g
						s/\&#x3B1\;/\α/g
						s/\&#x3B2\;/\β/g
						s/\&#x3B3\;/\γ/g
						s/\&#x3B4\;/\δ/g
						s/\&#x3B5\;/\ε/g
						s/\&#x3B6\;/\ζ/g
						s/\&#x3B7\;/\η/g
						s/\&#x3B8\;/\θ/g
						s/\&#x3B9\;/\ι/g
						s/\&#x3BA\;/\κ/g
						s/\&#x3BB\;/\λ/g
						s/\&#x3BC\;/\μ/g
						s/\&#x3BD\;/\ν/g
						s/\&#x3BE\;/\ξ/g
						s/\&#x3BF\;/\ο/g
						s/\&#x3C0\;/\π/g
						s/\&#x3C1\;/\ρ/g
						s/\&#x3C2\;/\ς/g
						s/\&#x3C3\;/\σ/g
						s/\&#x3C4\;/\τ/g
						s/\&#x3C5\;/\υ/g
						s/\&#x3C6\;/\φ/g
						s/\&#x3C7\;/\χ/g
						s/\&#x3C8\;/\ψ/g
						s/\&#x3C9\;/\ω/g
						s/\&#x3D1\;/\ϑ/g
						s/\&#x3D2\;/\ϒ/g
						s/\&#x3D6\;/\ϖ/g
						s/\&#x2022\;/\•/g
						s/\&#x2026\;/\…/g
						s/\&#x2032\;/\′/g
						s/\&#x2033\;/\″/g
						s/\&#x203E\;/\‾/g
						s/\&#x2044\;/\⁄/g
						s/\&#x2118\;/\℘/g
						s/\&#x2111\;/\ℑ/g
						s/\&#x211C\;/\ℜ/g
						s/\&#x2122\;/\™/g
						s/\&#x2135\;/\ℵ/g
						s/\&#x2190\;/\←/g
						s/\&#x2191\;/\↑/g
						s/\&#x2192\;/\→/g
						s/\&#x2193\;/\↓/g
						s/\&#x2194\;/\↔/g
						s/\&#x21B5\;/\↵/g
						s/\&#x21D0\;/\⇐/g
						s/\&#x21D1\;/\⇑/g
						s/\&#x21D2\;/\⇒/g
						s/\&#x21D3\;/\⇓/g
						s/\&#x21D4\;/\⇔/g
						s/\&#x2200\;/\∀/g
						s/\&#x2202\;/\∂/g
						s/\&#x2203\;/\∃/g
						s/\&#x2205\;/\∅/g
						s/\&#x2207\;/\∇/g
						s/\&#x2208\;/\∈/g
						s/\&#x2209\;/\∉/g
						s/\&#x220B\;/\∋/g
						s/\&#x220F\;/\∏/g
						s/\&#x2211\;/\∑/g
						s/\&#x2212\;/\−/g
						s/\&#x2217\;/\∗/g
						s/\&#x221A\;/\√/g
						s/\&#x221D\;/\∝/g
						s/\&#x221E\;/\∞/g
						s/\&#x2220\;/\∠/g
						s/\&#x2227\;/\∧/g
						s/\&#x2228\;/\∨/g
						s/\&#x2229\;/\∩/g
						s/\&#x222A\;/\∪/g
						s/\&#x222B\;/\∫/g
						s/\&#x2234\;/\∴/g
						s/\&#x223C\;/\∼/g
						s/\&#x2245\;/\≅/g
						s/\&#x2248\;/\≈/g
						s/\&#x2260\;/\≠/g
						s/\&#x2261\;/\≡/g
						s/\&#x2264\;/\≤/g
						s/\&#x2265\;/\≥/g
						s/\&#x2282\;/\⊂/g
						s/\&#x2283\;/\⊃/g
						s/\&#x2284\;/\⊄/g
						s/\&#x2286\;/\⊆/g
						s/\&#x2287\;/\⊇/g
						s/\&#x2295\;/\⊕/g
						s/\&#x2297\;/\⊗/g
						s/\&#x22A5\;/\⊥/g
						s/\&#x22C5\;/\⋅/g
						s/\&#x2308\;/\⌈/g
						s/\&#x2309\;/\⌉/g
						s/\&#x230A\;/\⌊/g
						s/\&#x230B\;/\⌋/g
						s/\&#x2329\;/\⟨/g
						s/\&#x232A\;/\⟩/g
						s/\&#x25CA\;/\◊/g
						s/\&#x2660\;/\♠/g
						s/\&#x2663\;/\♣/g
						s/\&#x2665\;/\♥/g
						s/\&#x2666\;/\♦/g
						s/\&#x26\;/\&/g
						s/\&#x3C\;/\</g
						s/\&#x3E\;/\>/g
						s/\&#x152\;/\Œ/g
						s/\&#x153\;/\œ/g
						s/\&#x160\;/\Š/g
						s/\&#x161\;/\š/g
						s/\&#x178\;/\Ÿ/g
						s/\&#x2C6\;/\ˆ/g
						s/\&#x2DC\;/\˜/g
						s/\&#x2002\;/\ /g
						s/\&#x2003\;/\ /g
						s/\&#x2009\;/\ /g
						s/\&#x200C\;/\‌/g
						s/\&#x200D\;/\‍/g
						s/\&#x200E\;/\‎/g
						s/\&#x200F\;/\‏/g
						s/\&#x2013\;/\–/g
						s/\&#x2014\;/\—/g
						s/\&#x2018\;/\‘/g
						s/\&#x2019\;/\’/g
						s/\&#x201A\;/\‚/g
						s/\&#x201C\;/\“/g
						s/\&#x201E\;/\„/g
						s/\&#x2020\;/\†/g
						s/\&#x2021\;/\‡/g
						s/\&#x2030\;/\‰/g
						s/\&#x2039\;/\‹/g
						s/\&#x203A\;/\›/g
						s/\&#x20AC\;/\€/g
						s/\&#160\;/\ /g
						s/\&#173\;/\­/g
						s/\&#402\;/\ƒ/g
						s/\&#913\;/\Α/g
						s/\&#914\;/\Β/g
						s/\&#915\;/\Γ/g
						s/\&#916\;/\Δ/g
						s/\&#917\;/\Ε/g
						s/\&#918\;/\Ζ/g
						s/\&#919\;/\Η/g
						s/\&#920\;/\Θ/g
						s/\&#921\;/\Ι/g
						s/\&#922\;/\Κ/g
						s/\&#923\;/\Λ/g
						s/\&#924\;/\Μ/g
						s/\&#925\;/\Ν/g
						s/\&#926\;/\Ξ/g
						s/\&#927\;/\Ο/g
						s/\&#928\;/\Π/g
						s/\&#929\;/\Ρ/g
						s/\&#931\;/\Σ/g
						s/\&#932\;/\Τ/g
						s/\&#933\;/\Υ/g
						s/\&#934\;/\Φ/g
						s/\&#935\;/\Χ/g
						s/\&#936\;/\Ψ/g
						s/\&#937\;/\Ω/g
						s/\&#945\;/\α/g
						s/\&#946\;/\β/g
						s/\&#947\;/\γ/g
						s/\&#948\;/\δ/g
						s/\&#949\;/\ε/g
						s/\&#950\;/\ζ/g
						s/\&#951\;/\η/g
						s/\&#952\;/\θ/g
						s/\&#953\;/\ι/g
						s/\&#954\;/\κ/g
						s/\&#955\;/\λ/g
						s/\&#956\;/\μ/g
						s/\&#957\;/\ν/g
						s/\&#958\;/\ξ/g
						s/\&#959\;/\ο/g
						s/\&#960\;/\π/g
						s/\&#961\;/\ρ/g
						s/\&#962\;/\ς/g
						s/\&#963\;/\σ/g
						s/\&#964\;/\τ/g
						s/\&#965\;/\υ/g
						s/\&#966\;/\φ/g
						s/\&#967\;/\χ/g
						s/\&#968\;/\ψ/g
						s/\&#969\;/\ω/g
						s/\&#977\;/\ϑ/g
						s/\&#978\;/\ϒ/g
						s/\&#982\;/\ϖ/g
						s/\&#8226\;/\•/g
						s/\&#8230\;/\…/g
						s/\&#8242\;/\′/g
						s/\&#8243\;/\″/g
						s/\&#8254\;/\‾/g
						s/\&#8260\;/\⁄/g
						s/\&#8472\;/\℘/g
						s/\&#8465\;/\ℑ/g
						s/\&#8476\;/\ℜ/g
						s/\&#8482\;/\™/g
						s/\&#8501\;/\ℵ/g
						s/\&#8592\;/\←/g
						s/\&#8593\;/\↑/g
						s/\&#8594\;/\→/g
						s/\&#8595\;/\↓/g
						s/\&#8596\;/\↔/g
						s/\&#8629\;/\↵/g
						s/\&#8656\;/\⇐/g
						s/\&#8657\;/\⇑/g
						s/\&#8658\;/\⇒/g
						s/\&#8659\;/\⇓/g
						s/\&#8660\;/\⇔/g
						s/\&#8704\;/\∀/g
						s/\&#8706\;/\∂/g
						s/\&#8707\;/\∃/g
						s/\&#8709\;/\∅/g
						s/\&#8711\;/\∇/g
						s/\&#8712\;/\∈/g
						s/\&#8713\;/\∉/g
						s/\&#8715\;/\∋/g
						s/\&#8719\;/\∏/g
						s/\&#8721\;/\∑/g
						s/\&#8722\;/\−/g
						s/\&#8727\;/\∗/g
						s/\&#8730\;/\√/g
						s/\&#8733\;/\∝/g
						s/\&#8734\;/\∞/g
						s/\&#8736\;/\∠/g
						s/\&#8743\;/\∧/g
						s/\&#8744\;/\∨/g
						s/\&#8745\;/\∩/g
						s/\&#8746\;/\∪/g
						s/\&#8747\;/\∫/g
						s/\&#8756\;/\∴/g
						s/\&#8764\;/\∼/g
						s/\&#8773\;/\≅/g
						s/\&#8776\;/\≈/g
						s/\&#8800\;/\≠/g
						s/\&#8801\;/\≡/g
						s/\&#8804\;/\≤/g
						s/\&#8805\;/\≥/g
						s/\&#8834\;/\⊂/g
						s/\&#8835\;/\⊃/g
						s/\&#8836\;/\⊄/g
						s/\&#8838\;/\⊆/g
						s/\&#8839\;/\⊇/g
						s/\&#8853\;/\⊕/g
						s/\&#8855\;/\⊗/g
						s/\&#8869\;/\⊥/g
						s/\&#8901\;/\⋅/g
						s/\&#8968\;/\⌈/g
						s/\&#8969\;/\⌉/g
						s/\&#8970\;/\⌊/g
						s/\&#8971\;/\⌋/g
						s/\&#9001\;/\〈/g
						s/\&#9002\;/\〉/g
						s/\&#9674\;/\◊/g
						s/\&#9824\;/\♠/g
						s/\&#9827\;/\♣/g
						s/\&#9829\;/\♥/g
						s/\&#9830\;/\♦/g
						s/\&#338\;/\Œ/g
						s/\&#339\;/\œ/g
						s/\&#352\;/\Š/g
						s/\&#353\;/\š/g
						s/\&#376\;/\Ÿ/g
						s/\&#710\;/\ˆ/g
						s/\&#732\;/\˜/g
						s/\&#8194\;/\ /g
						s/\&#8195\;/\ /g
						s/\&#8201\;/\ /g
						s/\&#8204\;/\‌/g
						s/\&#8205\;/\‍/g
						s/\&#8206\;/\‎/g
						s/\&#8207\;/\‏/g
						s/\&#8211\;/\–/g
						s/\&#8212\;/\—/g
						s/\&#8216\;/\‘/g
						s/\&#8217\;/\’/g
						s/\&#146\;/\’/g
						s/\&#8218\;/\‚/g
						s/\&#8220\;/\“/g
						s/\&#8222\;/\„/g
						s/\&#8224\;/\†/g
						s/\&#8225\;/\‡/g
						s/\&#8240\;/\‰/g
						s/\&#8249\;/\‹/g
						s/\&#8250\;/\›/g
						s/\&#8364\;/\€/g}')
	}

function limparCodeInvalid () {
	limparCodeInvalid=$(echo -e "$1" | sed -r 's/  */\+/g;s/\&/%26/g;s/\++$//g')
	}

function limparCodeInvalidMSDOS () {
	limparCodeInvalidMSDOS=$(echo -e "$1" | sed -e '{
							s/\://g
							s/\;//g
							s/\\//g
							s/\///g
							s/\?//g
							s/"//g
							s/\<//g
							s/\>//g
							s/\[//g
							s/\]//g
							s/\|//g}')
	}

function removerTMP () {
if [[ -f "$CASTFILEIMDB" ]]; then
	rm $CASTFILEIMDB > /dev/null
fi
	}

function analizaFicheiro () {
	echo -e '\E[1;37m\033[1mValidando se o ficheiro '$ficheiro' existe em todas as pastas ...\033[0m'
	faltaFicheiro=0
	pastaSFicheiroAnt=0
	for caminhoCompleto in $(find -L $dirDiscos -mindepth 1 -maxdepth $dirNiveis -type f \
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
							   -iname "*.rmvb" \) | grep OsMeusFilmes | sed -e '/OsMeusFilmesInfantis/ d' | sed -e '/movie\-trailer/ d')
	do
	pastaSFicheiro=$(echo "$caminhoCompleto" | sed 's/\(.*\)./\1/' | awk -F'/' '{for(i=1;i<NF-1;++i)printf $i"/";print $i;}'| sed -e 's/  //g' | sed -e 's/\/VIDEO_TS//g')
		if [[ "$pastaSFicheiro" != "$pastaSFicheiroAnt" ]]; then
			if [[ ! -e $pastaSFicheiro/$ficheiro ]]; then
			echo -e "O ficheiro $pastaSFicheiro/$ficheiro não existe\n"
			faltaFicheiro=1
			else
			tput civis # hide cursor
			progressBar
			fi
			tput cnorm # unhide cursor
			pastaSFicheiroAnt=$pastaSFicheiro		
		fi
	done
	if [ $faltaFicheiro = 0 ]; then
		echo -e '\E[1;37m\033[1mO ficheiro '"$ficheiro"' esta presente em todas as pastas.\033[0m'
		else
		echo -e '\E[31;40m\033[1mO ficheiro '"$ficheiro"' não esta presente em todas as pastas.\033[0m'
	fi
	}

function analizarVideo () {
for fileFILME in $( find -L "$caminhoCompleto/" -mindepth 1 -maxdepth 1 -type f \
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
			-iname "*.rmvb" \) | grep OsMeusFilmes | sed -e '/OsMeusFilmesInfantis/ d' | sed -e '/movie\-trailer/ d')
do
	xbmcVideoCodec=( $(ffmpeg -i $fileFILME 2>&1 | grep Video: | sed -e 's/  / /g' | awk -F' ' '{print $4}' | sed -e 's/,//g') )
	
	xbmcVideoWidth=( $(ffmpeg -i $fileFILME 2>&1 | grep Video: | sed -e 's/  / /g' | awk -F', ' '{print $3}' | sed -e 's/ //g;s/\[.*//g'| awk -F'x' '{print $1}') )
	xbmcVideoHeight=( $(ffmpeg -i $fileFILME 2>&1 | grep Video: | sed -e 's/  / /g' | awk -F', ' '{print $3}' | sed -e 's/ //g;s/\[.*//g'| awk -F'x' '{print $2}') )
	xbmcVideoAspect=$(echo scale=6\; $xbmcVideoWidth '/' $xbmcVideoHeight | bc)
	xbmcVideoDuration=( $(ffmpeg -i "$fileFILME" 2>&1 | sed -n "s/.* Duration: \([^,]*\), start: .*/\1/p" | awk -F':' '{ print $1*3600 + $2*60 + $3 }' | awk -F'.' '{print $1}'))
	xbmcAudioCodec=( $(ffmpeg -i $fileFILME 2>&1 | grep Audio: | sed -e 's/  / /g' | awk -F' ' '{print $4}' | sed -e 's/,//g') )
	xbmcAudioChannels=( $(ffmpeg -i $fileFILME 2>&1 | grep Audio: | sed -e 's/  / /g' | awk -F' ' '{print $7}' | sed -e 's/,//g' | sed -e 's/mono/1/g' | sed -e 's/stereo/2/g' | sed -e 's/5\.1/6/g' | sed -e 's/7\.1/8/g') )
done
	}

function nfoArrumar () {

echo -e '\E[32;40m\033[1mA executar opção:[N] Processar ficheiros movie.nfo\033[0m'

if [ $arrumarNFO = 1 ]; then
	echo -e '\E[1;37m\033[1mProcessando as pastas ...\033[0m'
	nfoProcessados=0
	for caminhoCompleto in $(find -L $dirDiscos -mindepth 1 -maxdepth $dirNiveis -type f -name "movie.nfo" | grep VIDEO_TS | sed -e '/OsMeusFilmesInfantis/ d' | sed -e '/movie-trailer/ d')
	do
	nfoProcessados=1
	caminhoDestino=$(echo "$caminhoCompleto" | sed -e 's/\/VIDEO_TS\/movie.nfo//g')
	echo -e '\E[1;37m\033[1m##############\033[0m'
	echo -e '\E[1;37m\033[1m# Origem:'"$caminhoCompleto"'\033[0m'
	echo -e '\E[1;37m\033[1m# Destino:'"$caminhoDestino/movie.nfo"'\033[0m'
	echo ""
	mv "$caminhoCompleto" "$caminhoDestino/movie.nfo"
	done
	if [ $nfoProcessados = 0 ]; then
		echo -e '\E[1;37m\033[1mNão foram processados ficheiros movie.nfo.\033[0m'
	fi
	else
	echo -e '\E[1;37m\033[1mFunção Arrumar ficheiros NFO inactiva.\nPara activar coloque variavel arrumarNFO no valor 1\033[0m'
fi
}

function gerarNfoData () {
echo -e '\E[1;37m\033[1mProcessando as pastas que têm ficheiro filme.txt ...\033[0m'
echo -e '\E[1;37m\033[1mUtilize o menu "Analiza Ficheiros/Analiza movie.nfo" para saber se todas as pastas contêm o filme.txt ...\033[0m'

for caminhoCompleto in $(find -L $dirDiscos -mindepth 1 -maxdepth $dirNiveis -type f -name "filme.txt" | grep filme.txt | sed -e 's/\/filme.txt//g' -e 's/  //g' )
do

# INI CAMINHOS
	xbmcDestino=$(echo -e "$caminhoCompleto")
	xbmcDestinoNfo=$(echo -e "$caminhoCompleto"/movie.nfo)
	xbmcDestinoXml=$(echo -e "$caminhoCompleto"/filme.txt)
	mkdir -p "$caminhoCompleto"/html
	xbmcDestinoHtml=$(echo -e "$caminhoCompleto/html")
	mkdir -p "$caminhoCompleto"/people/
	xbmcDestinoActor=$(echo -e "$caminhoCompleto/people")
# END CAMINHOS

	if [[ ! -f "$xbmcDestinoNfo" ]]; then

# INI RECOLHER DADOS DO MYMOVIES.XML
		codeIMDB=$(cat $caminhoCompleto/filme.txt | grep "<id moviedb=imdb>" | sed -e :a -e 's/<[^>]*>//g;s/ //g;s/\t//g')
		codeTMDB=$(cat $caminhoCompleto/filme.txt | grep "<id moviedb=tmdb>" | sed -e :a -e 's/<[^>]*>//g;s/ //g;s/\t//g')
		descricaoManual=$(cat $caminhoCompleto/filme.txt | sed -s 's/<\/plot>/\n\t<\/plot>/g' | sed -n '/<plot>/,/<\/plot>/p' | sed -e 's/<.*>//g' -e 's/\t//g')
		if [[ $codeIMDB == "" ]]; then
			if [[ ! -f $xbmcDestinoHtml/tmdb.xml ]] ; then
			lynx -connect_timeout=10 --source "http://api.themoviedb.org/2.1/Movie.getInfo/pt/xml/$APITMDB/$codeTMDB" > $xbmcDestinoHtml/tmdb.xml 2> /dev/null
			fi
			codeIMDB=$(cat $xbmcDestinoHtml/tmdb.xml | grep "<imdb_id>" | sed -e 's/<imdb_id>//g' | sed -e 's/<\/imdb_id>//g' | sed -e 's/\t//g' | sed -e 's/ //g')
		fi
# END RECOLHER DADOS DO MYMOVIES.XML

# INI PROCESSAMENTO

		recolhaIMDB

		if [[ $descricaoManual == "" ]]; then
		recolhaDVDPT
		fi

		if [[ $descricaoManual == "" ]]; then
		recolhaPTGATE
		fi

		recolhaTMDB

		if [[ $descricaoManual == "" ]]; then
		processarSINOPSE
		else
		PLOT="$descricaoManual"
		fi

		analizarVideo
		gerarNfoFile
		removerTMP
# END PROCESSAMENTO

	else
	tput civis # hide cursor
	progressBar
	fi
	tput cnorm # unhide cursor
done
}

function gerarNfoFile () {
echo -e "A Gerar $xbmcDestinoNfo ..."
echo -e "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\" ?>" > $xbmcDestinoNfo
echo -e "<movie>" >> $xbmcDestinoNfo
echo -e "\t<title>$TITULO</title>" | sed 's/ <\/title>/<\/title>/g' >> $xbmcDestinoNfo
echo -e "\t<originaltitle>$TITULO ($ANO)</originaltitle>" | sed 's/ <\/originaltitle>/<\/originaltitle>/g' >> $xbmcDestinoNfo
echo -e "\t<sorttitle>$TITULO</sorttitle>" | sed 's/ <\/sorttitle>/<\/sorttitle>/g' >> $xbmcDestinoNfo
echo -e "\t<rating>$RAT</rating>" | sed 's/ <\/rating>/<\/rating>/g' >> $xbmcDestinoNfo
echo -e "\t<epbookmark>0,000000</epbookmark>" >> $xbmcDestinoNfo
echo -e "\t<year>$ANO</year>" | sed 's/ <\/year>/<\/year>/g' >> $xbmcDestinoNfo
echo -e "\t<top250>0</top250>" >> $xbmcDestinoNfo
echo -e "\t<votes>$VOTES</votes>" | sed 's/ <\/votes>/<\/votes>/g' >> $xbmcDestinoNfo
echo -e "\t<outline></outline>" | sed 's/ <\/>/<\/>/g' >> $xbmcDestinoNfo
echo -e "\t<plot>$PLOT</plot>" | sed 's/ <\/plot>/<\/plot>/g' >> $xbmcDestinoNfo
echo -e "\t<tagline></tagline>" >> $xbmcDestinoNfo
echo -e "\t<runtime>$RUNTIME</runtime>" | sed 's/ <\/runtime>/<\/runtime>/g' >> $xbmcDestinoNfo
echo -e "\t<mpaa>$MPAA</mpaa>" | sed 's/ <\/mpaa>/<\/mpaa>/g' >> $xbmcDestinoNfo
echo -e "\t<watched></watched>" >> $xbmcDestinoNfo
echo -e "\t<id>$codeIMDB</id>" | sed 's/ <\/id>/<\/id>/g' >> $xbmcDestinoNfo
echo -e "\t<id moviedb=\"imdb\">$codeIMDB</id>" | sed 's/ <\/id>/<\/id>/g' >> $xbmcDestinoNfo
echo -e "\t<id moviedb=\"tmdb\">$codeTMDB</id>" >> $xbmcDestinoNfo
echo -e "\t<id moviedb=\"themoviedb\"></id>" >> $xbmcDestinoNfo
echo -e "\t<filenameandpath></filenameandpath>" >> $xbmcDestinoNfo
echo -e "\t<playcount>0</playcount>" >> $xbmcDestinoNfo
echo -e "\t<lastplayed></lastplayed>" >> $xbmcDestinoNfo
echo -e "\t<genre>$GEN</genre>" | sed -e 's/  / /g' | sed -e 's/\ | /<\/genre>\n\t<genre>/g' >> $xbmcDestinoNfo
echo -e "\t<country>$COUNTRY</country>" | sed -e 's/  / /g' | sed  's/ | /<\/country>\n\t<country>/g' >> $xbmcDestinoNfo
echo -e "\t<set></set>" >> $xbmcDestinoNfo
echo -e "\t<credits>$WRITER</credits>" | sed -e 's/  / /g' | sed -e 's/\ | /<\/credits>\n\t<credits>/g' >> $xbmcDestinoNfo
echo -e "\t<director>$DIR</director>" | sed 's/ <\/director>/<\/director>/g' >> $xbmcDestinoNfo
echo -e "\t<premiered>$PREMIERED</premiered>" | sed 's/ <\/>/<\/>/g' >> $xbmcDestinoNfo
echo -e "\t<status></status>" | sed 's/ <\/>/<\/>/g' >> $xbmcDestinoNfo
echo -e "\t<code></code>" | sed 's/ <\/>/<\/>/g' >> $xbmcDestinoNfo
echo -e "\t<aired></aired>" | sed 's/ <\/>/<\/>/g' >> $xbmcDestinoNfo
echo -e "\t<studio>$STUDIO</studio>" | sed 's/ <\/studio>/<\/studio>/g' >> $xbmcDestinoNfo
trailer=$(find -L $xbmcDestino -mindepth 1 -maxdepth 1 -type f \
                        \(\
                        -iname "movie-trailer.rm" -o \
                        -iname "movie-trailer.asf" -o \
                        -iname "movie-trailer.mp4" -o \
                        -iname "movie-trailer.wmv" -o \
                        -iname "movie-trailer.avi" -o \
                        -iname "movie-trailer.flv" -o \
                        -iname "movie-trailer.mkv" -o \
                        -iname "movie-trailer.m4u" -o \
                        -iname "movie-trailer.mpg" -o \
                        -iname "movie-trailer.mpeg" -o \
                        -iname "movie-trailer.rmvb" \))
if [[ $trailer != "" ]]; then
	echo -e "\t<trailer>smb://""$USERNAME"":""$PASSWORD""@""$MASTERIP""$trailer""</trailer>" | sed 's/ <\/>/<\/>/g' >> $xbmcDestinoNfo
	else
	echo -e "\t<trailer></trailer>" | sed 's/ <\/>/<\/>/g' >> $xbmcDestinoNfo
fi
echo -e "\t<fileinfo>" >> $xbmcDestinoNfo
echo -e "\t\t<streamdetails>" >> $xbmcDestinoNfo
echo -e "\t\t\t<video>" >> $xbmcDestinoNfo
echo -e "\t\t\t\t<codec>$xbmcVideoCodec</codec>" | sed 's/ <\/>/<\/>/g' | sed 's/<codec>0<\/codec>/<codec><\/codec>/g' >> $xbmcDestinoNfo
echo -e "\t\t\t\t<aspect>$xbmcVideoAspect</aspect>" | sed 's/ <\/>/<\/>/g' | sed 's/<aspect>0<\/aspect>/<aspect><\/aspect>/g' >> $xbmcDestinoNfo
echo -e "\t\t\t\t<width>$xbmcVideoWidth</width>" | sed 's/ <\/>/<\/>/g' | sed 's/<width>0<\/width>/<width><\/width>/g' >> $xbmcDestinoNfo
echo -e "\t\t\t\t<height>$xbmcVideoHeight</height>" | sed 's/ <\/>/<\/>/g' | sed 's/<height>0<\/height>/<height><\/height>/g' >> $xbmcDestinoNfo
echo -e "\t\t\t\t<durationinseconds>$xbmcVideoDuration</durationinseconds>" | sed 's/ <\/>/<\/>/g' | sed 's/<durationinseconds>0<\/durationinseconds>/<durationinseconds><\/durationinseconds>/g' >> $xbmcDestinoNfo
echo -e "\t\t\t</video>" >> $xbmcDestinoNfo
echo -e "\t\t\t<audio>" >> $xbmcDestinoNfo
echo -e "\t\t\t\t<codec>$xbmcAudioCodec</codec>" | sed 's/ <\/>/<\/>/g' | sed 's/<codec>0<\/codec>/<codec><\/codec>/g' >> $xbmcDestinoNfo
echo -e "\t\t\t\t<language></language>" | sed 's/ <\/>/<\/>/g' >> $xbmcDestinoNfo
echo -e "\t\t\t\t<channels>$xbmcAudioChannels</channels>" | sed 's/ <\/>/<\/>/g' | sed 's/<channels>0<\/channels>/<channels><\/channels>/g' >> $xbmcDestinoNfo
echo -e "\t\t\t</audio>" >> $xbmcDestinoNfo
echo -e "\t\t</streamdetails>" >> $xbmcDestinoNfo
echo -e "\t</fileinfo>" >> $xbmcDestinoNfo
for CONTADOR in $(seq 0 $((${#CAST[*]} - 1))); do
	echo -e "\t<actor>" >> $xbmcDestinoNfo
	xbmcACTORROLE=$(echo "${CAST[$CONTADOR]}" | sed 's/Actor:/\t\t<name>/g' | sed 's/\;Papel:/<\/name>\n\t\t<role>/g' | sed '/<role>/s/.*/&<\/role>/' | sed -e 's/(/- /g' | sed -e 's/)//g' | sed -e 's/  / /g')
	echo -e "$xbmcACTORROLE" >> $xbmcDestinoNfo
	xbmcACTOR=$(echo -e $xbmcACTORROLE | sed -e 's/\t<role.*role>//g' | sed -e 's/\t<name>//g' | sed -e 's/<\/name>//g' | sed 's/\`/ /g' | sed 's/  / /g' | sed 's/\t//g' | sed -e 's/^\s*//;s/\s*$//g')
# INI OBTER FOTO DO ACTOR
	if [[ $renovarHTML == 1 ]]; then
		aguardarTempo 5
		lynx -connect_timeout=10 --source "http://images.google.com/images?q=actor $xbmcACTOR&imgtype=face" > $xbmcDestinoHtml/google_$xbmcACTOR.html 2> /dev/null;
	else
		if [[ ! -f "$xbmcDestinoHtml/google_$xbmcACTOR.html" ]]; then
			aguardarTempo 5
			lynx -connect_timeout=10 --source "http://images.google.com/images?q=actor $xbmcACTOR&imgtype=face" > $xbmcDestinoHtml/google_$xbmcACTOR.html 2> /dev/null;
		fi
	fi
	xbmcURLACTORJPG=$(cat $xbmcDestinoHtml/google_$xbmcACTOR.html | sed 's/imgurl/\nimgurl/g' | sed 's/\&imgrefurl/\n&imgrefurl/g' | egrep imgurl | sed 's/imgurl\=//g' | egrep jpg | head -1 | sed 's/<img/\n<img/g' | sed 's/.jpg/.jpg\n/g' | sed -n 1p)
	if [[ ! -f "$xbmcDestinoActor/$xbmcACTOR.jpg" ]]; then
		echo "Descarregando foto de $xbmcACTOR ..."
		wget --timeout 30 -t 1 -O - "$xbmcURLACTORJPG" > $xbmcDestinoActor/$xbmcACTOR.jpg 2> /dev/null;
		find -L $xbmcDestinoActor/ -type f -empty -exec rm -f {} \;
	fi
# END OBTER FOTO DO ACTOR

# INI USAR FOTO DO ACTOR
	if [[ -f "$xbmcDestinoActor/$xbmcACTOR.jpg" ]]; then
		xbmcDestinoSMedia=$(echo -e $xbmcDestino | sed 's/\/media//g' )
		echo -e "\t\t<thumb>smb://$USERNAME:""$PASSWORD@""$MASTERIP""$xbmcDestinoSMedia""/people/$xbmcACTOR.jpg</thumb>" >> $xbmcDestinoNfo
		echo -e "\t</actor>" >> $xbmcDestinoNfo
	else
		echo -e "\t\t<thumb></thumb>" >> $xbmcDestinoNfo
		echo -e "\t</actor>" >> $xbmcDestinoNfo
	fi
# INI USAR FOTO DO ACTOR

# INI NAO USAR FOTO DO ACTOR
#		echo -e "\t\t<thumb></thumb>" >> $xbmcDestinoNfo
#		echo -e "\t</actor>" >> $xbmcDestinoNfo
# END NAO USAR FOTO DO ACTOR

done
echo -e "\t<artist></artist>" >> $xbmcDestinoNfo
echo -e "</movie>" >> $xbmcDestinoNfo


cp "$xbmcDestinoNfo" "$xbmcDestinoXml"
testeFontePLOT=$(echo $PLOT | grep -o IMDB)
if [[ $testeFontePLOT == "IMDB" ]]; then
cat "$xbmcDestinoXml" | sed -e '/<plot>/,/plot>/s/.*/\t<plot><\/plot>/' | uniq > lixo
cp lixo "$xbmcDestinoXml"
rm lixo
fi
#if [[ $trailer != "" ]]; then
#nano "$xbmcDestinoXml"
#read -p "Esta tudo bem com o movie trailer?"
#fi
}

function sincronizaActores () {
ENDERECODESTINO=$MASTERIP
USRDESTINO=xbmc
DIRDESTINO=/home/xbmc/
DIRORIGEM=$HOME/People

# Verifica se a máquina de destino está ligada
ping -c 1 -W 2 $ENDERECODESTINO > /dev/null
if [ "$?" -ne 0 ];
then
	echo -e "\n$ENDERECODESTINO não responde."
	echo -e "O Backup não vai ser realizado.\n"
else
	echo -e "Backup iniciado...\n"
	HORA_INI=`date +%s`
	#rsync -ah --delete --stats --progress -e ssh $DIRORIGEM $USRDESTINO@$ENDERECODESTINO:$DIRDESTINO
	rsync -rvt --modify-window=1 --delete -e ssh $DIRORIGEM $USRDESTINO@$ENDERECODESTINO:$DIRDESTINO
 	HORA_FIM=`date +%s`
	TEMPO=`expr $HORA_FIM - $HORA_INI`
	echo -e "\nBackup finalizado com sucesso!"
	echo -e "Duração: $TEMPO s\n"
fi

}

function sshNox () {
	ssh xbmc@$MASTERIP
	}

function pacoteMinimo () {
	echo -e '\E[1;37m\033[1mProcessando as pastas ...\033[0m'
	ficheiro1=folder.jpg
	ficheiro2=filme.txt
	ficheiro3=disc.png
	ficheiro4=backdrop.jpg
	ficheiro5=fanart.jpg
	ficheiro6=movie.nfo
	faltaFicheiros=0
	faltaFicheiro1=0
	faltaFicheiro2=0
	faltaFicheiro3=0
	faltaFicheiro4=0
	faltaFicheiro5=0
	faltaFicheiro6=0
	pastaSFicheiroAnt=0

	for caminhoCompleto in $(find -L $dirDiscos -mindepth 1 -maxdepth $dirNiveis -type f \
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
							   -iname "*.rmvb" \) | grep OsMeusFilmes | sed -e '/OsMeusFilmesInfantis/ d' | sed -e '/movie\-trailer/ d')
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
			if [[ ! -f "$pastaSFicheiro/$ficheiro6" ]]; then
			echo "O ficheiro $pastaSFicheiro/$ficheiro6 não existe"
			faltaFicheiro6=1
			fi
			pastaSFicheiroAnt=$pastaSFicheiro
		else
		tput civis # hide cursor
		progressBar
		fi
		tput cnorm # unhide cursor
	done
	if [ $faltaFicheiros = 0 ]; then
		echo -e '\E[1;37m\033[1mOs conteudos importantes estão presentes em todas as pastas.\033[0m'
		else
		echo -e '\E[31;40m\033[1mExistem conteudos importantes em falta em algumas pastas.\033[0m'
	fi
	}

function dirName () {
echo -e '\E[32;40m\033[1mA executar opção:[F] Nome das pastas = Nome do filme nas pastas que contêm o filme.txt\033[0m'
echo -e '\E[1;37m\033[1mUtilize o menu "Analiza Ficheiros/Analiza filme.txt" para saber se todas as pastas contêm o filme.txt ...\033[0m'

mudeiNomes=0

for caminhoCompleto in $(find -L $dirDiscos -mindepth 1 -maxdepth $dirNiveis -type f -name "filme.txt" | grep filme.txt | sed -e '/OsMeusFilmesInfantis/ d' | sed -e '/OsMeusDocumentarios/ d' | sed -e '/AsMinhasSeries/ d' | sed -e 's/\/filme.txt//g' -e 's/  //g' )
do

# INI CAMINHOS
	xbmcDestino=$(echo -e "$caminhoCompleto")
	xbmcDestinoNfo=$(echo -e "$caminhoCompleto"/movie.nfo)
	xbmcDestinoXml=$(echo -e "$caminhoCompleto"/datMovie.xml)
	mkdir -p "$caminhoCompleto"/html
	xbmcDestinoHtml=$(echo -e "$caminhoCompleto/html")
	mkdir -p "$caminhoCompleto"/people/
	xbmcDestinoActor=$(echo -e "$caminhoCompleto/people")
# END CAMINHOS

# INI RECOLHER DADOS
	TITULO=$(cat $caminhoCompleto/filme.txt | grep "<title>" | sed -e :a -e 's/<[^>]*>//g;s/  //g;s/\t//g')
	limparCodeInvalidMSDOS "$TITULO"
	TITULOMSDOS="$limparCodeInvalidMSDOS"
	ANO=$(cat $caminhoCompleto/filme.txt | grep "<year>" | sed -e :a -e 's/<[^>]*>//g;s/ //g;s/\t//g')
	if [[ $TITULOMSDOS == "" ]]; then
		codeIMDB=$(cat $caminhoCompleto/filme.txt | grep "<id moviedb=imdb>" | sed -e :a -e 's/<[^>]*>//g;s/ //g;s/\t//g')
		if [[ $codeIMDB == "" ]]; then
			codeTMDB=$(cat $caminhoCompleto/filme.txt | grep "<id moviedb=tmdb>" | sed -e :a -e 's/<[^>]*>//g;s/ //g;s/\t//g')
			if [[ ! -f $xbmcDestinoHtml/tmdb.xml ]] ; then
			lynx -connect_timeout=10 --source "http://api.themoviedb.org/2.1/Movie.getInfo/pt/xml/$APITMDB/$codeTMDB" > $xbmcDestinoHtml/tmdb.xml 2> /dev/null
			fi
			codeIMDB=$(cat $xbmcDestinoHtml/tmdb.xml | grep "<imdb_id>" | sed -e 's/<imdb_id>//g' | sed -e 's/<\/imdb_id>//g' | sed -e 's/\t//g' | sed -e 's/ //g')
		fi
		if [[ $codeIMDB == "" ]]; then
			echo -e "Não encontrei codigo IMDB para:"
			echo -e "$caminhoCompleto"
			echo -e "Porfavor corrija e volte a executar a opção."
			read -p "Precione CTRL + C para abortar ou outra tecla para continuar"
		fi
		recolhaIMDB
	fi
# END RECOLHER DADOS

pastaSFilme=$(echo "$caminhoCompleto" | sed 's/\(.*\)./\1/' | awk -F'/' '{for(i=1;i<NF-1;++i)printf $i"/";print $i}'| sed -e 's/  //g')
	if [ "$caminhoCompleto" != "$pastaSFilme/$TITULOMSDOS ($ANO)" ]; then
	mudeiNomes=1
	echo -e '\E[1;37m\033[1m##############\033[0m'
	echo -e '\E[1;37m\033[1m#  Origem:'"$caminhoCompleto"'\033[0m'
	echo -e '\E[1;37m\033[1m# Destino:'"$pastaSFilme/$TITULOMSDOS ($ANO)"'\033[0m'
	echo ""
	mv "$caminhoCompleto" "$pastaSFilme/$TITULOMSDOS ($ANO)"
	chown francisco:francisco "$pastaSFilme/$TITULOMSDOS ($ANO)"
	else
	tput civis # hide cursor
	progressBar
	fi
	tput cnorm # unhide cursor
done

if [ $mudeiNomes = 0 ]; then
echo -e '\E[1;37m\033[1mNão foram feitas alterações nos nomes dos filmes.\033[0m'
fi
	}

function backdrop () {
	echo -e '\E[32;40m\033[1mA executar opção:[B] Criar ficheiros backdrop e fanart\033[0m'
	echo -e '\E[1;37m\033[1mFilmes com estructura ISO ou VIDEO_TS não são processados.\033[0m'
	echo -e '\E[1;37m\033[1mProcessando as pastas ...\033[0m'
	processarBackdrops=0
	for caminhoCompleto in $(find -L $dirDiscos -mindepth 1 -maxdepth $dirNiveis -type d | grep OsMeusFilmes | sed -e '/OsMeusFilmesInfantis/ d' | sed -e '/movie\-trailer/ d')
	do
	echo -e "$caminhoCompleto/backdrop.jpg"
			if [[ ! -f "$caminhoCompleto/backdrop.jpg" ]]; then
				for fileFILME in $(
					find -L "$caminhoCompleto/" -mindepth 1 -maxdepth 1 -type f \
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
					DURACAO_FILME=( $(ffmpeg -i "$fileFILME" 2>&1 | sed -n "s/.* Duration: \([^,]*\), start: .*/\1/p") )
					TEMPO_TOT_FILME_SEG=( $(echo "$DURACAO_FILME" | awk -F':' '{ print $1*3600 + $2*60 + $3 }' | awk -F'.' '{print $1}'))
					TEMPO_DIV_FILME=( $(echo "$TEMPO_TOT_FILME_SEG" | awk '{ print $1 / 5 }' | awk -F'.' '{ print $1 }'))
					TEMPO_DIV_FILME4=( $(echo "$TEMPO_TOT_FILME_SEG" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
					TEMPO_DIV_FILME3=( $(echo "$TEMPO_DIV_FILME4" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
					TEMPO_DIV_FILME2=( $(echo "$TEMPO_DIV_FILME3" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
					TEMPO_DIV_FILME1=( $(echo "$TEMPO_DIV_FILME2" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
					echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop.jpg ...\033[0m'
					ffmpeg -ss "$TEMPO_DIV_FILME1" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop.jpg"  2>/dev/null
					chown francisco:francisco "$caminhoCompleto/backdrop.jpg"
					if [[ ! -f "$caminhoCompleto/fanart.jpg" ]]; then
						echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/fanart.jpg ...\033[0m'
						cp "$caminhoCompleto/backdrop.jpg" "$caminhoCompleto/fanart.jpg"
						chown francisco:francisco "$caminhoCompleto/fanart.jpg"
					fi
					echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop1.jpg ...\033[0m'
					ffmpeg -ss "$TEMPO_DIV_FILME2" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop1.jpg"  2>/dev/null
					chown francisco:francisco "$caminhoCompleto/backdrop1.jpg"
					echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop2.jpg ...\033[0m'
					ffmpeg -ss "$TEMPO_DIV_FILME3" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop2.jpg"  2>/dev/null
					chown francisco:francisco "$caminhoCompleto/backdrop2.jpg"
					echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop3.jpg ...\033[0m'
					ffmpeg -ss "$TEMPO_DIV_FILME4" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop3.jpg"  2>/dev/null
					chown francisco:francisco "$caminhoCompleto/backdrop3.jpg"
					else
						if [[ ! -f "$caminhoCompleto/backdrop4.jpg" ]]; then
						processarBackdrops=1
						DURACAO_FILME=( $(ffmpeg -i "$fileFILME" 2>&1 | sed -n "s/.* Duration: \([^,]*\), start: .*/\1/p") )
						TEMPO_TOT_FILME_SEG=( $(echo "$DURACAO_FILME" | awk -F':' '{ print $1*3600 + $2*60 + $3 }' | awk -F'.' '{print $1}'))
						TEMPO_DIV_FILME=( $(echo "$TEMPO_TOT_FILME_SEG" | awk '{ print $1 / 5 }' | awk -F'.' '{ print $1 }'))
						TEMPO_DIV_FILME4=( $(echo "$TEMPO_TOT_FILME_SEG" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
						TEMPO_DIV_FILME3=( $(echo "$TEMPO_DIV_FILME4" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
						TEMPO_DIV_FILME2=( $(echo "$TEMPO_DIV_FILME3" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
						TEMPO_DIV_FILME1=( $(echo "$TEMPO_DIV_FILME2" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
						echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop4.jpg ...\033[0m'
						ffmpeg -ss "$TEMPO_DIV_FILME1" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop4.jpg" 2>/dev/null
						chown francisco:francisco "$caminhoCompleto/backdrop4.jpg"
						echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop5.jpg ...\033[0m'
						ffmpeg -ss "$TEMPO_DIV_FILME2" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop5.jpg" 2>/dev/null
						chown francisco:francisco "$caminhoCompleto/backdrop5.jpg"
						echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop6.jpg ...\033[0m'
						ffmpeg -ss "$TEMPO_DIV_FILME3" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop6.jpg" 2>/dev/null
						chown francisco:francisco "$caminhoCompleto/backdrop6.jpg"
						echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop7.jpg ...\033[0m'
						ffmpeg -ss "$TEMPO_DIV_FILME4" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop7.jpg" 2>/dev/null
						chown francisco:francisco "$caminhoCompleto/backdrop7.jpg"
						else
							if [[ ! -f "$caminhoCompleto/backdrop8.jpg" ]]; then
							processarBackdrops=1
							DURACAO_FILME=( $(ffmpeg -i "$fileFILME" 2>&1 | sed -n "s/.* Duration: \([^,]*\), start: .*/\1/p") )
							TEMPO_TOT_FILME_SEG=( $(echo "$DURACAO_FILME" | awk -F':' '{ print $1*3600 + $2*60 + $3 }' | awk -F'.' '{print $1}'))
							TEMPO_DIV_FILME=( $(echo "$TEMPO_TOT_FILME_SEG" | awk '{ print $1 / 5 }' | awk -F'.' '{ print $1 }'))
							TEMPO_DIV_FILME4=( $(echo "$TEMPO_TOT_FILME_SEG" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
							TEMPO_DIV_FILME3=( $(echo "$TEMPO_DIV_FILME4" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
							TEMPO_DIV_FILME2=( $(echo "$TEMPO_DIV_FILME3" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
							TEMPO_DIV_FILME1=( $(echo "$TEMPO_DIV_FILME2" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
							echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop8.jpg ...\033[0m'
							ffmpeg -ss "$TEMPO_DIV_FILME1" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop8.jpg" 2>/dev/null
							chown francisco:francisco "$caminhoCompleto/backdrop8.jpg"
							echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop9.jpg ...\033[0m'
							ffmpeg -ss "$TEMPO_DIV_FILME2" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop9.jpg" 2>/dev/null
							chown francisco:francisco "$caminhoCompleto/backdrop9.jpg"
							echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop10.jpg ...\033[0m'
							ffmpeg -ss "$TEMPO_DIV_FILME3" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop10.jpg" 2>/dev/null
							chown francisco:francisco "$caminhoCompleto/backdrop10.jpg"
							echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop11.jpg ...\033[0m'
							ffmpeg -ss "$TEMPO_DIV_FILME4" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop11.jpg" 2>/dev/null
							chown francisco:francisco "$caminhoCompleto/backdrop11.jpg"
							else
								if [[ ! -f "$caminhoCompleto/backdrop12.jpg" ]]; then
								processarBackdrops=1
								DURACAO_FILME=( $(ffmpeg -i "$fileFILME" 2>&1 | sed -n "s/.* Duration: \([^,]*\), start: .*/\1/p") )
								TEMPO_TOT_FILME_SEG=( $(echo "$DURACAO_FILME" | awk -F':' '{ print $1*3600 + $2*60 + $3 }' | awk -F'.' '{print $1}'))
								TEMPO_DIV_FILME=( $(echo "$TEMPO_TOT_FILME_SEG" | awk '{ print $1 / 5 }' | awk -F'.' '{ print $1 }'))
								TEMPO_DIV_FILME4=( $(echo "$TEMPO_TOT_FILME_SEG" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
								TEMPO_DIV_FILME3=( $(echo "$TEMPO_DIV_FILME4" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
								TEMPO_DIV_FILME2=( $(echo "$TEMPO_DIV_FILME3" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
								TEMPO_DIV_FILME1=( $(echo "$TEMPO_DIV_FILME2" | awk -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
								echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop12.jpg ...\033[0m'
								ffmpeg -ss "$TEMPO_DIV_FILME1" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop12.jpg" 2>/dev/null
								chown francisco:francisco "$caminhoCompleto/backdrop12.jpg"
								echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop13.jpg ...\033[0m'
								ffmpeg -ss "$TEMPO_DIV_FILME2" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop13.jpg" 2>/dev/null
								chown francisco:francisco "$caminhoCompleto/backdrop13.jpg"
								echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop14.jpg ...\033[0m'
								ffmpeg -ss "$TEMPO_DIV_FILME3" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop14.jpg" 2>/dev/null
								chown francisco:francisco "$caminhoCompleto/backdrop14.jpg"
								echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop15.jpg ...\033[0m'
								ffmpeg -ss "$TEMPO_DIV_FILME4" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop15.jpg" 2>/dev/null
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

function tbn () {
	echo -e '\E[32;40m\033[1mA executar opção:[T] Processar ficheiros TBN\033[0m'
	ficheiro=movie.nfo
	if [ $BARRELA = 0 ] ; then
		analizaFicheiro
	fi
	if [ $BARRELA = 1 ] ; then
		faltaFicheiro=0
	fi
	if [ $faltaFicheiro = 0 ] ; then
	ficheiro=folder.jpg
	analizaFicheiro
	fi
	tbnProcessados=0
	if [ $faltaFicheiro = 0 ] ; then
		echo -e '\E[1;37m\033[1mNão faltam ficheiros ...\033[0m'
		echo -e '\E[1;37m\033[1mProcessando as pastas ...\033[0m'
		# for caminhoCompleto in $(find -L $dirDiscos -mindepth 1 -maxdepth $dirNiveis -type f -name "filme.txt" | grep filme.txt | sed -e 's/\/filme.txt//g' -e 's/  //g' | grep OsMeusFilmes | sed -e '/OsMeusFilmesInfantis/ d' | sed -e '/movie\-trailer/ d')
		for caminhoCompleto in $(find -L $dirDiscos -mindepth 1 -maxdepth $dirNiveis -type f -name "movie.nfo" | grep movie.nfo | sed -e 's/\/movie.nfo//g' | sed -e 's/  //g' | grep OsMeusFilmes | sed -e '/OsMeusFilmesInfantis/ d' | sed -e '/movie\-trailer/ d')
		do
#echo -e "caminhoCompleto:$caminhoCompleto/"
		# filme=$(cat $caminhoCompleto/filme.txt | grep LocalTitle | sed -e 's/<LocalTitle>//g' -e 's/<\/LocalTitle>//g' -e 's/.$//g' -e 's/://g'  -e 's/?//g' -e 's/\&amp\;/\&/'  -e 's/  //g')
		filme=$(cat $caminhoCompleto/movie.nfo | grep "<title>" | sed -e 's/<title>//g' | sed -e 's/<\/title>//g' | sed -e 's/\t//g')
#echo -e "filme:$filme"
		# ano=$(cat $caminhoCompleto/filme.txt | grep ProductionYear | sed -e 's/<ProductionYear>//g' | sed -e 's/<\/ProductionYear>//g' | sed -e 's/.$//g' -e 's/^M//g' -e 's/  //g')
		ano=$(cat $caminhoCompleto/movie.nfo | grep "<year>" | sed -e 's/<year>//g' -e 's/<\/year>//g' -e 's/\t//g')
#echo -e "ano:$ano"
		pastaSFilme=$(echo "$caminhoCompleto" | sed 's/\(.*\)./\1/' | awk -F'/' '{for(i=1;i<NF-1;++i)printf $i"/";print $i}'| sed -e 's/  //g')
#echo -e "pastaSFilme:$pastaSFilme"
			if [[ ! -f "$caminhoCompleto/movie.tbn" ]]; then
				tbnProcessados=1
				echo -e '\E[1;37m\033[1m##############\033[0m'
				echo -e '\E[1;37m\033[1m# Origem:'"$caminhoCompleto/folder.jpg"'\033[0m'
				echo -e '\E[1;37m\033[1m# Destino:'"$caminhoCompleto/movie.tbn"'\033[0m'
				echo ""
				convert "$caminhoCompleto/folder.jpg" "$caminhoCompleto/movie.tbn"
			fi
			#if [[ ! -f "$pastaSFilme/$filme ($ano).tbn" ]]; then
			#	tbnProcessados=1
			#	echo -e '\E[1;37m\033[1m##############\033[0m'
			#	echo -e '\E[1;37m\033[1m# Origem:'"$caminhoCompleto/movie.tbn"'\033[0m'
			#	echo -e '\E[1;37m\033[1m# Destino:'"$pastaSFilme/$filme ($ano).tbn"'\033[0m'
			#	echo -e '\E[1;37m\033[1m##############\033[0m'
			#	echo ""
			#	cp "$caminhoCompleto/movie.tbn" "$pastaSFilme/$filme ($ano).tbn"
			#fi
			for fileFILME in $(
						find -L "$caminhoCompleto/" -mindepth 1 -maxdepth 1 -type f \
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
			fileFILMEsEXT=$(echo $fileFILME | sed 's/\.rm//g;s/\.asf//g;s/\.mp4//g;s/\.wmv//g;s/\.avi//g;s/\.flv//g;s/\.mkv//g;s/\.m4u//g;s/\.mpg//;s/\.mpeg//g;s/\.rmvb//g')
			#echo "fileFILME=$fileFILME"
			#echo "fileFILMEsEXT=$fileFILMEsEXT"
			if [[ ! -f "$fileFILMEsEXT.tbn" ]]; then
			tbnProcessados=1
			echo -e '\E[1;37m\033[1m##############\033[0m'
			echo -e '\E[1;37m\033[1m# Origem:'"$caminhoCompleto/movie.tbn"'\033[0m'
			echo -e '\E[1;37m\033[1m# Destino:'"$fileFILMEsEXT.tbn"'\033[0m'
			echo ""
			cp "$caminhoCompleto/movie.tbn" "$fileFILMEsEXT.tbn"
			fi
			done
		done
		else
		echo -e '\E[31;40m\033[1mO ficheiro folder.jpg ou movies.nfo não existem em algumas pastas.\033[0m'
		echo -e '\E[1;37m\033[1mExecute a opção [V] para determinar onde estão ausentes.\033[0m'
	fi
	if [ $tbnProcessados = 0 ]; then
		echo -e '\E[1;37m\033[1mNão foram processados ficheiros TBN.\033[0m'
	fi
}

function filmesFicheiros () {
	echo -e '\E[1;37m\033[1mProcessando as pastas ...\033[0m'
	caminhoCompleto=$(find -L $dirDiscos -mindepth 1 -maxdepth $dirNiveis -type f \
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
						   -iname "*.rmvb" \) | grep OsMeusFilmes | sed -e '/OsMeusFilmesInfantis/ d' | sed -e '/movie\-trailer/ d')
	echo "$caminhoCompleto" | awk -F'/' '{if (x[$5]) { x_count[$5]++; print $0; if (x_count[$5] == 1) { print x[$5] } } x[$5] = $0}' | sort -d > $HOME/filmes_com_ficheiros.txt
	nano $HOME/filmes_com_ficheiros.txt
	echo "Para consultar posteriormente o relatorio abra o ficheiro:"
	echo $HOME/filmes_com_ficheiros.txt
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

function filmesCSV {
clear
echo "  ____________________________________________________"
echo "||  A Criar Folha de Calculo com conteudo dos HD's... ||"
echo "||____________________________________________________||"
echo
echo "Será gerado o ficheiro $HOME/ownCloud/Linux/OsMeusScripts/conteudo.csv"

dia="$(date +%d)"
mes="$(date +%B)"
ano="$(date +%Y)"
hora="$(date +%H)"
min="$(date +%M)"

echo "Processando DISC01..."
if [[ -d /media/DISC01 ]]; then
	mkdir -p /media/DISC01/AMinhaMusica
	mkdir -p /media/DISC01/AsMinhasSeries
	mkdir -p /media/DISC01/OsMeusDocumentarios
	mkdir -p /media/DISC01/OsMeusFilmes
	mkdir -p /media/DISC01/OsMeusFilmesHD
	mkdir -p /media/DISC01/OsMeusFilmesInfantis
	mkdir -p /media/DISC01/OsMeusVideosMusicais
	du --max-depth=2 /media/DISC01/ > /tmp/lista_.txt
	sed -e 's/\/media\///g' -e 's/\//\t/g' /tmp/lista_.txt > /tmp/lista_0.txt
else
	echo "DISC01 não esta presente"
fi

echo "Processando DISC02..."
if [[ -d /media/DISC02 ]]; then
	mkdir -p /media/DISC02/AMinhaMusica
	mkdir -p /media/DISC02/AsMinhasSeries
	mkdir -p /media/DISC02/OsMeusDocumentarios
	mkdir -p /media/DISC02/OsMeusFilmes
	mkdir -p /media/DISC02/OsMeusFilmesHD
	mkdir -p /media/DISC02/OsMeusFilmesInfantis
	mkdir -p /media/DISC02/OsMeusVideosMusicais
	du --max-depth=2 /media/DISC02/ > /tmp/lista_.txt
	sed -e 's/\/media\///g' -e 's/\//\t/g' /tmp/lista_.txt >> /tmp/lista_0.txt
else
	echo "DISC02 não esta presente"
fi

echo "Processando DISC03..."
if [[ -d /media/DISC03 ]]; then
	mkdir -p /media/DISC03/AMinhaMusica
	mkdir -p /media/DISC03/AsMinhasSeries
	mkdir -p /media/DISC03/OsMeusDocumentarios
	mkdir -p /media/DISC03/OsMeusFilmes
	mkdir -p /media/DISC03/OsMeusFilmesHD
	mkdir -p /media/DISC03/OsMeusFilmesInfantis
	mkdir -p /media/DISC03/OsMeusVideosMusicais
	du --max-depth=2 /media/DISC03/ > /tmp/lista_.txt
	sed -e 's/\/media\///g' -e 's/\//\t/g' /tmp/lista_.txt >> /tmp/lista_0.txt
else
	echo "DISC03 não esta presente"
fi

echo "Processando DISC04..."
if [[ -d /media/DISC04 ]]; then
	mkdir -p /media/DISC04/AMinhaMusica
	mkdir -p /media/DISC04/AsMinhasSeries
	mkdir -p /media/DISC04/OsMeusDocumentarios
	mkdir -p /media/DISC04/OsMeusFilmes
	mkdir -p /media/DISC04/OsMeusFilmesHD
	mkdir -p /media/DISC04/OsMeusFilmesInfantis
	mkdir -p /media/DISC04/OsMeusVideosMusicais
	du --max-depth=2 /media/DISC04/ > /tmp/lista_.txt
	sed -e 's/\/media\///g' -e 's/\//\t/g' /tmp/lista_.txt >> /tmp/lista_0.txt
else
	echo "DISC04 não esta presente"
fi

echo "Processando DISC05..."
if [[ -d /media/DISC05 ]]; then
	mkdir -p /media/DISC05/AMinhaMusica
	mkdir -p /media/DISC05/AsMinhasSeries
	mkdir -p /media/DISC05/OsMeusDocumentarios
	mkdir -p /media/DISC05/OsMeusFilmes
	mkdir -p /media/DISC05/OsMeusFilmesHD
	mkdir -p /media/DISC05/OsMeusFilmesInfantis
	mkdir -p /media/DISC05/OsMeusVideosMusicais
	du --max-depth=2 /media/DISC05/ > /tmp/lista_.txt
	sed -e 's/\/media\///g' -e 's/\//\t/g' /tmp/lista_.txt >> /tmp/lista_0.txt
else
	echo "DISC05 não esta presente"
fi

echo "Processando DISC06..."
if [[ -d /media/DISC06 ]]; then
	mkdir -p /media/DISC06/AMinhaMusica
	mkdir -p /media/DISC06/AsMinhasSeries
	mkdir -p /media/DISC06/OsMeusDocumentarios
	mkdir -p /media/DISC06/OsMeusFilmes
	mkdir -p /media/DISC06/OsMeusFilmesHD
	mkdir -p /media/DISC06/OsMeusFilmesInfantis
	mkdir -p /media/DISC06/OsMeusVideosMusicais
	du --max-depth=2 /media/DISC06/ > /tmp/lista_.txt
	sed -e 's/\/media\///g' -e 's/\//\t/g' /tmp/lista_.txt >> /tmp/lista_0.txt
else
	echo "DISC06 não esta presente"
fi
echo "Gerando Relatorio de Filmes ..."
# Remover pastas indesejadas
sed -e '/lost+found/ d' -e '/.Trash-1000/ d' -e '/AsMinhasImagens/ d' -e '/OutrosAssuntos/ d' -e '/AsMinhasFotos/ d' -e '/OsMeusVideosFamiliares/ d' /tmp/lista_0.txt > /tmp/lista_1.txt
# Ordenar colunas, remover niveis indesejados e ordenar linhas
awk -F "\t" '{printf "%s\t%s\t%s\t%s\n", $3,$4,$1,$2}' /tmp/lista_1.txt | awk 'NF > 3' | sort -d > $HOME/ownCloud/Linux/OsMeusScripts/conteudo.csv
# Adicionar linha de cabeçalho
sed -i '1i\Categoria\tConteúdo a '$dia' de '$mes' de '$ano' às '$hora'.'$min'\tTamanho\tDisco' $HOME/ownCloud/Linux/OsMeusScripts/conteudo.csv
# Remover ficheiros indesejados
rm /tmp/lista_*.txt

}

function filmesRepetidos () {
	echo "Gerando Relatorio de Filmes Repetidos ..."
	echo "Será gerado o ficheiro $HOME/conteudo_repetido.csv"
	echo "A informação apresentada resulta da analize do ficheiro conteudo.csv actual !"
	if [[ -e $HOME/ownCloud/Linux/OsMeusScripts/conteudo.csv ]]; then
		awk -F"\t" '{if (x[$2]) { x_count[$2]++; print $0; if (x_count[$2] == 1) { print x[$2] } } x[$2] = $0}' $HOME/ownCloud/Linux/OsMeusScripts/conteudo.csv | awk -F "\t" '{printf "%s\t%s\t%s\t%s\n", $2,$1,$3,$4}' | sort -d > $HOME/ownCloud/Linux/OsMeusScripts/conteudo_repetido.csv
		cat $HOME/ownCloud/Linux/OsMeusScripts/conteudo_repetido.csv
		else
		echo "O ficheiro $HOME/ownCloud/Linux/OsMeusScripts/conteudo.csv não existe."
	fi
	}

function analizaConteudos () {
let "loop1f=0"
while test $loop1f == 0
do
opcao=$( dialog                   \
	--stdout                      \
	--menu 'Analizar ficheiros'   \
	0 0 0                         \
	A 'Analiza folder.jpg'        \
	B 'Analiza filme.txt'      \
	C 'Analiza disc.png'          \
	D 'Analiza backdrop.jpg'      \
	E 'Analiza fanart.jpg'        \
	F 'Analiza movie.nfo'         \
	G 'Analiza cover.jpg'         \
	T 'Analiza movie-trailer.*   '\
	H 'Filmes com + de 1 ficheiro'\
	I 'Relatorio Filmes'          \
	J 'Relatorio Filmes Repetidos'\
	V 'Voltar'   )

case $opcao in a|A)
ficheiro=folder.jpg
analizaFicheiro
read -p "Precione CTRL + C para abortar ou outra tecla para continuar"
esac
case $opcao in b|B)
ficheiro=filme.txt
analizaFicheiro
read -p "Precione CTRL + C para abortar ou outra tecla para continuar"
esac
case $opcao in c|C)
ficheiro=disc.png
analizaFicheiro
read -p "Precione CTRL + C para abortar ou outra tecla para continuar"
esac
case $opcao in d|D)
ficheiro=backdrop.jpg
analizaFicheiro
read -p "Precione CTRL + C para abortar ou outra tecla para continuar"
esac
case $opcao in e|E)
ficheiro=fanart.jpg
analizaFicheiro
read -p "Precione CTRL + C para abortar ou outra tecla para continuar"
esac
case $opcao in f|F)
ficheiro=movie.nfo
analizaFicheiro
read -p "Precione CTRL + C para abortar ou outra tecla para continuar"
esac
case $opcao in g|G)
ficheiro=cover.jpg
analizaFicheiro
read -p "Precione CTRL + C para abortar ou outra tecla para continuar"
esac
case $opcao in t|T)
ficheiro=movie-trailer.*
analizaFicheiro
read -p "Precione CTRL + C para abortar ou outra tecla para continuar"
esac
case $opcao in h|H)
filmesFicheiros
read -p "Precione CTRL + C para abortar ou outra tecla para continuar"
esac
case $opcao in i|I)
filmesCSV
read -p "Precione CTRL + C para abortar ou outra tecla para continuar"
esac
case $opcao in j|J)
filmesRepetidos
read -p "Precione CTRL + C para abortar ou outra tecla para continuar"
esac
case $opcao in v|V)
let "loop1f=1"
clear
esac

done
	}

function movieTime () {
	echo -e '\E[32;40m\033[1mA executar opção:[?] Criar ficheiros movieTime\033[0m'
	echo -e '\E[1;37m\033[1mFilmes com estructura ISO ou VIDEO_TS não são processados.\033[0m'
	echo -e '\E[1;37m\033[1mProcessando as pastas ...\033[0m'
	processarBackdrops=0
	for caminhoCompleto in $(find -L $dirDiscos -mindepth 1 -maxdepth $dirNiveis -type d | grep OsMeusFilmes | sed -e '/OsMeusFilmesInfantis/ d' | sed -e '/movie\-trailer/ d')
	do
				for fileFILME in $(
					find -L "$caminhoCompleto/" -mindepth 1 -maxdepth 1 -type f \
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
				movieTime=` stat "$fileFILME" | grep Modificar | awk -F' ' '{ print $2 }' | sed -e 's/\-//g' `
				if [[ ! -f $caminhoCompleto/$movieTime.txt ]]; then
				echo "time=$movieTime""0000.00" > $caminhoCompleto/$movieTime.txt
				touch -t "$movieTime"0000.00 $caminhoCompleto
				touch -t "$movieTime"0000.00 $caminhoCompleto/*
				touch -t "$movieTime"0000.00 $caminhoCompleto/html/*
				touch -t "$movieTime"0000.00 $caminhoCompleto/people/*
				fi
				#echo $fileFILME
				#echo $movieTime
				#read -p "touch"
				tput civis # hide cursor
				progressBar
				done
	done
	tput cnorm # unhide cursor
	}

#				#
# Functions END #
#################

validacao

###############################
#           MENU              #
###############################

let "loop1=0"
while test $loop1 == 0
do
opcao=$( dialog                           \
	--stdout                              \
	--menu 'Processar filmes'             \
	0 0 0                                 \
	A 'Analizar conteudos'                \
	N 'Processar ficheiros movie.nfo'     \
	F 'Nome das pastas = Nome do filme'   \
	B 'Criar ficheiros backdrop e fanart' \
	T 'Processar ficheiros TBN'           \
	M 'Processar ficheiros movieTime'     \
	G 'Executar opções N F B T M'         \
	C 'Copia actores para o MediaCenter'  \
	X 'sshNox (Sala)'                     \
	S 'Sair'   )

case $opcao in a|A)
analizaConteudos
esac
case $opcao in f|F)
dirName
read -p "Precione CTRL + C para abortar ou outra tecla para continuar"
esac
case $opcao in b|B)
backdrop
read -p "Precione CTRL + C para abortar ou outra tecla para continuar"
esac
case $opcao in n|N)
dirName
nfoArrumar
gerarNfoData
read -p "Precione CTRL + C para abortar ou outra tecla para continuar"
esac
case $opcao in t|T)
tbn
read -p "Precione CTRL + C para abortar ou outra tecla para continuar"
esac
case $opcao in m|M)
movieTime
read -p "Precione CTRL + C para abortar ou outra tecla para continuar"
esac
case $opcao in c|C)
sincronizaActores
read -p "Precione CTRL + C para abortar ou outra tecla para continuar"
esac
case $opcao in g|G)
echo -e '\E[32;40m\033[1mA executar opção:[G] Executar opções N F B T M\033[0m'
BARRELA=1
dirName
nfoArrumar
gerarNfoData
backdrop
tbn
movieTime
BARRELA=0
read -p "Precione CTRL + C para abortar ou outra tecla para continuar"
esac
case $opcao in x|X)
sshNox
read -p "Precione CTRL + C para abortar ou outra tecla para continuar"
esac
#case $opcao in *)
#let "loop1=1"
#clear
#esac
case $opcao in s|S)
let "loop1=1"
clear
esac

done

###############################
#           MENU              #
###############################

exit 0
