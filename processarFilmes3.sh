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
declare dirDiscos="/media"
declare dirNiveis=5
declare destinoHTML=""
declare aguardarTempo=0
# Coloque a variavel renovarHTML em 1 para que o HTML seja actualizado
# em 0 para que seja aproveitado o HTML ja existente.
declare renovarHTML=0
# Coloque a variavel renovarNFO em 1 para que os ficheiros movie.nfo sejam actualizados
# em 0 para que sejam aproveitados os ficheiros movie.nfo ja existentes.
declare renovarNFO=0
declare URL
declare codeIMDB=""
declare descricaoManual=""
declare URLIMDB
declare URLIMDBC
declare URLIMDBCREDIT
declare URLPTGATE=""
declare URLDVDPT=""
declare TITULO=""
declare TITULOMSDOS=""
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
declare FILME
declare filme
declare DIR
declare WRITER
declare GEN
declare xbmcCAST=""
declare xbmcACTOR=""
declare xbmcACTORROLE=""
declare xbmcTHUMB=""
declare xbmcURLACTORJPG=""
declare xbmcVideoCodec=0
declare xbmcVideoAspect=0
declare xbmcVideoWidth=0
declare xbmcVideoHeight=0
declare xbmcVideoDuration=0
declare xbmcAudioCodec=0
declare xbmcAudioChannels=0
declare xbmcActorChar
declare xbmcDestinoNfo
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
declare tnbProcessados
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
declare mudeiNomes
declare -rx CASTFILEIMDB=/tmp/movieImdbCast.$$
#declare -rx TMPFILEIMDB=/tmp/movieImdbFetcher.$$
#declare -rx TMPFILEIMDBC=/tmp/movieImdbcFetcher.$$
#declare -rx TMPFILEIMDBCREDIT=/tmp/movieImdbCredFetcher.$$
#declare -rx TMPFILEIMDBACTOR=/tmp/movieImdbActorFetcher.$$
#declare -rx TMPFILEPTGATE=/tmp/moviePtgateFetcher.$$
#declare -rx TMPFILEDVDPT=/tmp/movieDvdptFetcher.$$
#declare -rx PLOTFILEIMDB=/tmp/movieImdbPlot.$$
#declare -rx PLOTFILEIMDBC=/tmp/movieImdbcPlot.$$
#declare -rx PLOTFILEPTGATE=/tmp/moviePtgatePlot.$$
#declare -rx PLOTFILEDVDPT=/tmp/movieDvdptPlot.$$
declare -rx LYNX="/usr/bin/lynx"
declare -rx WGET="/usr/bin/wget"
declare -rx CAT="/bin/cat"
declare -rx SED="/bin/sed"
declare -rx EGREP="/bin/egrep"
declare -rx GREP="/bin/grep"
declare -rx UNIQ="/usr/bin/uniq"
declare -rx HEAD="/usr/bin/head"
declare -rx ICONV="/usr/bin/iconv"
declare -rx AWK="/usr/bin/awk"
declare -rx DIALOG="/usr/bin/dialog"
declare -rx FFMPEG="/usr/bin/ffmpeg"
declare -rx CONVERT="/usr/bin/convert"
declare -rx BC="/usr/bin/bc"
declare -rx FIND="/usr/bin/find"
declare -rx TR="/usr/bin/tr"
declare -rx PRINTF="/usr/bin/printf"
declare -rx SEQ="/usr/bin/seq"
declare -rx DATE="/usr/bin/date"
declare -rx OD="/usr/bin/od"
declare -rx PING="/bin/ping"
declare -rx RSYNC="/usr/bin/rsync"
declare -rx SSH="/usr/bin/ssh"
#								   #
# Global variable declarations END #
####################################

#################
# Functions INI #
#				#

function validacao () {
if [ -z "$BASH" ]
then
$PRINTF "This script is written for bash. Please run this under bash\n" >&2
exit 192
fi
if [ ! -x "$LYNX" ]
then
printnofound $LYNX >&2
exit 192
fi
if [ ! -x "$CAT" ]
then
printnofound $CAT >&2
exit 192
fi
if [ ! -x "$EGREP" ]
then
printnofound $EGREP >&2
exit 192
fi
if [ ! -x "$GREP" ]
then
printnofound $GREP >&2
exit 192
fi
if [ ! -x "$UNIQ" ]
then
printnofound $UNIQ >&2
exit 192
fi
if [ ! -x "$HEAD" ]
then
printnofound $HEAD >&2
exit 192
fi
if [ ! -x "$SED" ]
then
printnofound $SED >&2
exit 192
fi
if [ ! -x "$ICONV" ]
then
printnofound $ICONV >&2
exit 192
fi
if [ ! -x "$WGET" ]
then
printnofound $WGET >&2
exit 192
fi
if [ ! -x "$DIALOG" ]
then
printnofound $DIALOG >&2
exit 192
fi
if [ ! -x "$FFMPEG" ]
then
printnofound $FFMPEG >&2
exit 192
fi
if [ ! -x "$CONVERT" ]
then
printnofound $CONVERT >&2
exit 192
fi
if [ ! -x "$SEQ" ]
then
printnofound $SEQ >&2
exit 192
fi
if [ ! -x "$PRINTF" ]
then
printnofound $PRINTF >&2
exit 192
fi
if [ ! -x "$TR" ]
then
printnofound $TR >&2
exit 192
fi
if [ ! -x "$FIND" ]
then
printnofound $FIND >&2
exit 192
fi
if [ ! -x "$BC" ]
then
printnofound $BC >&2
exit 192
fi
if [ ! -x "$PING" ]
then
printnofound $PING >&2
exit 192
fi
if [ ! -x "$RSYNC" ]
then
printnofound $RSYNC >&2
exit 192
fi
if [ ! -x "$SSH" ]
then
printnofound $SSH >&2
exit 192
fi

}

function aguardarTempo () {
	# Coloca o scrip em espera entre 0 e 60 seg.
	aguardarTempo=$(echo $((`cat /dev/urandom|$OD -N1 -An -i` % 10)))
	echo "Processamento suspenso durante $aguardarTempo" seg. ...
	sleep $aguardarTempo
	}

function recolhaIMDB () {
if [[ $codeIMDB == "" ]]; then	
# echo -e '\E[1;37m\033[1mProcessar o filme '"$FILME"' no Google / IMDB ...\033[0m'
echo -e "Processar o filme \E[1;37m\033[1m"$FILME"\033[0m no Google / IMDB ..."
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
aguardarTempo
$LYNX -connect_timeout=10 --source "http://www.google.com/search?hl=en&q=$FILME+imdb" > $destinoHTML/google_imdb.html 2> /dev/null
else
	if [[ ! -f "$destinoHTML/google_imdb.html" ]]; then
	echo "Descarregando HTML de http://www.google.com/search?hl=en&q=$FILME+imdb ..."
	aguardarTempo
	$LYNX -connect_timeout=10 --source "http://www.google.com/search?hl=en&q=$FILME+imdb" > $destinoHTML/google_imdb.html 2> /dev/null
	fi
fi
	# Validar se a erro na ligação 
	if [ $? -ne 0 ]; then
	$PRINTF "A ligação ao servidor IMDB falhou. Verifique a sua ligação a internet!\n"; exit 192
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
URLIMDB=`$EGREP -o "http://www.imdb.com/title/tt[0-9]*/" $destinoHTML/google_imdb.html | $HEAD -1`
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
	aguardarTempo
	$LYNX --source ${URLIMDB} > $destinoHTML/imdb.html;
	echo "Descarregando HTML de $URLIMDBC ..."
	aguardarTempo
	$LYNX --source ${URLIMDBC} | $SED -e 's/<\/div>/<\/div>\n/g' -e 's/<\/li>/<\/li>\n/g' -e 's/<\/tr>/<\/tr>\n/g' -e 's/<\/table>/<\/table>\n/g' -e 's/\&nbsp\;/ /g' -e 's/\&raquo\;//g' -e 's/<br>/<br>\n/g'> $destinoHTML/imdb_combined.html;
	echo "Descarregando HTML de $URLIMDBCREDIT ..."
	aguardarTempo
	$LYNX --source ${URLIMDBCREDIT} | $SED 's/<\/tr>/<\/tr>\n/g' | $SED 's/<\/div>/<\/div>\n/g' | $SED 's/<a name="cast"/\n<a name="cast"/g' > $destinoHTML/imdb_credit.html;
else
	if [[ ! -f "$destinoHTML/imdb.html" ]]; then
	echo "Descarregando HTML de $URLIMDB ..."
	aguardarTempo
	$LYNX --source ${URLIMDB} > $destinoHTML/imdb.html;
	fi
	if [[ ! -f "$destinoHTML/imdb_combined.html" ]]; then
	echo "Descarregando HTML de $URLIMDBC ..."
	aguardarTempo
	$LYNX --source ${URLIMDBC} | $SED 's/<\/div>/<\/div>\n/g' | $SED 's/<\/li>/<\/li>\n/g' | $SED -e 's/<\/tr>/<\/tr>\n/g' | $SED -e 's/<\/table>/<\/table>\n/g' | $SED -e 's/\&nbsp\;/ /g' | $SED -e 's/\&raquo\;//g' | $SED -e 's/<br>/<br>\n/g'> $destinoHTML/imdb_combined.html;
	fi
	if [[ ! -f "$destinoHTML/imdb_credit.html" ]]; then
	echo "Descarregando HTML de $URLIMDBCREDIT ..."
	aguardarTempo
	$LYNX --source ${URLIMDBCREDIT} | $SED 's/<\/tr>/<\/tr>\n/g' | $SED 's/<\/div>/<\/div>\n/g' | $SED 's/<a name="cast"/\n<a name="cast"/g' > $destinoHTML/imdb_credit.html;
	fi
fi
#									#
# Guardar os detalhes do filme IMDB #
#####################################

##########################################
# Extrair informação (parse) CODIGO IMDB #
#										 #
echo "Extrair informação (parse) CODIGO IMDB..."
ImdbCode=$(echo ${URLIMDB} | $AWK -F/ '{print $5}')
#										 #
# Extrair informação (parse) CODIGO IMDB #
##########################################

#######################################
# Extrair informação (parse) ANO IMDB #
#									  #
#echo "Extrair informação (parse) ANO IMDB..."
#ANO=`$CAT $TMPFILEIMDBC | $GREP "<title>" | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba' | $SED -e 's/\///g' | $AWK -F'(' '{print $2}' | $EGREP -o "[0-9][0-9][0-9][0-9]"`
#ANO=`$CAT $destinoHTML/imdb_combined.html | $GREP "<title>" | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba' | $SED -e 's/\///g' | $SED -e 's/I)/)/g' | $SED -e 's/I)/)/g' | $SED -e 's/I)/)/g' | $SED -e 's/V)/)/g' | $SED -e 's/V)/)/g' | $SED -e 's/V)/)/g' | $SED -e 's/X)/)/g' | $SED -e 's/X)/)/g' | $SED -e 's/X)/)/g' | $SED -e 's/(..)//g' | $SED -e 's/(.)//g' | $SED -e 's/(//g' | $SED -e 's/)//g' | $SED -e 's/  / /g' | $SED -e 's/^\s*//;s/\s*$//g'| $EGREP -o "[0-9][0-9][0-9][0-9]$"`
ANO=`$CAT $destinoHTML/imdb_combined.html | $GREP "<title>" | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba' -e 's/\///g' -e 's/I)/)/g' -e 's/I)/)/g' -e 's/I)/)/g' -e 's/V)/)/g' -e 's/V)/)/g' -e 's/V)/)/g' -e 's/X)/)/g' -e 's/X)/)/g' -e 's/X)/)/g' -e 's/(..)//g' -e 's/(.)//g' -e 's/(//g' -e 's/)//g' -e 's/  / /g' -e 's/^\s*//;s/\s*$//g' | $EGREP -o "[0-9][0-9][0-9][0-9]$"`
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
#TITULO=`$CAT $destinoHTML/imdb_combined.html | $GREP "<title>" | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba' | $SED -e 's/\///g' | $SED -e 's/I)/)/g' | $SED -e 's/I)/)/g' | $SED -e 's/I)/)/g' | $SED -e 's/V)/)/g' | $SED -e 's/V)/)/g' | $SED -e 's/V)/)/g' | $SED -e 's/X)/)/g' | $SED -e 's/X)/)/g' | $SED -e 's/X)/)/g' | $SED -e 's/([0-9][0-9][0-9][0-9])//g' | $SED -e 's/(...)//g' | $SED -e 's/(..)//g' | $SED -e 's/(.)//g' | $SED -e 's/()//g'| $SED -e 's/^\s*//;s/\s*$//g'`
#TITULO=`$CAT $destinoHTML/imdb_combined.html | $GREP "<title>" | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba' | $SED -e 's/\///g' | $SED -e 's/I)/)/g' | $SED -e 's/I)/)/g' | $SED -e 's/I)/)/g' | $SED -e 's/V)/)/g' | $SED -e 's/V)/)/g' | $SED -e 's/V)/)/g' | $SED -e 's/X)/)/g' | $SED -e 's/X)/)/g' | $SED -e 's/X)/)/g' | $SED -e 's/([0-9][0-9][0-9][0-9])//g' | $SED -e 's/(..)//g' | $SED -e 's/(.)//g' | $SED -e 's/()//g' | $SED -e 's/()//g' | $SED -e 's/()//g' | $SED -e 's/  / /g' | $SED -e 's/^\s*//;s/\s*$//g'`
TITULO=`$CAT $destinoHTML/imdb_combined.html | $GREP "<title>" | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba' -e 's/\///g' -e 's/I)/)/g' -e 's/I)/)/g' -e 's/I)/)/g' -e 's/V)/)/g' -e 's/V)/)/g' -e 's/V)/)/g' -e 's/X)/)/g' -e 's/X)/)/g' -e 's/X)/)/g' -e 's/([0-9][0-9][0-9][0-9])//g' -e 's/(..)//g' -e 's/(.)//g' -e 's/()//g' -e 's/()//g' -e 's/()//g' -e 's/  / /g' -e 's/^\s*//;s/\s*$//g'`
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
RAT=`$CAT $destinoHTML/imdb_combined.html | $SED -n '/<div class="starbar-meta">/,/<\/b>/{s/<[^>]*>//g;p}' | $SED 's/ //g'| $SED '/^$/d' | $AWK -F'/' '{print $1}' | $SED 's/\./\,/g' | $SED -e 's/^\s*//;s/\s*$//g'`
limparCodeHTML "$RAT"
RAT="$limparCodeHTML"
if [[ $RAT == "" ]]; then
	RAT="Informação indisponivel"
else
RAT=$(printf "%f" ${RAT}) 
fi
RAT=$(echo "$RAT" | $SED 's/0\,000000//g')
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
VOTES=`$CAT $destinoHTML/imdb_combined.html | $SED -n '/<a href="ratings" class="tn15more">/,/<\/div>/{s/<[^>]*>//g;p;}'`
VOTES=$(echo $VOTES | $SED 's/\&nbsp;//g' | $SED 's/\&raquo;//g' | $SED 's/ //g' | $SED '/^$/d' | $SED 's/votes//g'| $SED 's/\,//g' | $SED -e 's/^\s*//;s/\s*$//g')
limparCodeHTML "$VOTES"
VOTES="$limparCodeHTML"
if [[ $VOTES == "" ]]; then
	VOTES="Informação indisponivel"
else
VOTES=$(echo -e $VOTES | $SED ':a  s/\([[:digit:]]\)\([[:digit:]]\{3\}\(,\|$\)\)/\1,\2/; t a')
fi
#										#
# Extrair informação (parse) VOTES IMDB #
#########################################

########################################
# Extrair informação (parse) MPAA IMDB #
#									   #
#echo "Extrair informação (parse) MPAA IMDB"
MPAA=`$CAT  $destinoHTML/imdb_combined.html | $SED -n '/MPAA.*/,/div/{p}' | $SED 's/MPAA//g' | $SED 's/\://g' | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba' | $SED 's/Additional Details//g' | $SED -e 's/^\s*//;s/\s*$//g'`
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
RUNTIME=`$CAT $destinoHTML/imdb_combined.html | $SED -n '/Runtime:/,/<\/div>/{s/<[^>]*>//g;s/ Runtime://;s/min /min/g;p}'`
limparCodeHTML "$RUNTIME"
RUNTIME="$limparCodeHTML"
#										  #
# Extrair informação (parse) RUNTIME IMDB #
###########################################

##########################################
# Extrair informação (parse) STUDIO IMDB #
#										 #
#echo "Extrair informação (parse) STUDIO IMDB..."
STUDIO=`$CAT $destinoHTML/imdb_combined.html | $SED -n '/Production Companies/,/<\/a>/{p}' | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba'| $SED 's/Production Companies//'| $SED '1q' | $SED -e 's/([^(]*)//g' | $SED -e 's/^\s*//;s/\s*$//g'`
limparCodeHTML "$STUDIO"
STUDIO="$limparCodeHTML"
#										 #
# Extrair informação (parse) STUDIO IMDB #
##########################################

###########################################
# Extrair informação (parse) COUNTRY IMDB #
#										  #
#echo "Extrair informação (parse) COUNTRY IMDB..."
COUNTRY=`$CAT  $destinoHTML/imdb_combined.html | $SED -n '/Country:/,/<\/div>/{s/<[^>]*>//g;s/Country://p}' | $SED -e 's/^\s*//;s/\s*$//g'`
limparCodeHTML "$COUNTRY"
COUNTRY="$limparCodeHTML"
#									  	  #
# Extrair informação (parse) COUNTRY IMDB #
###########################################

#############################################
# Extrair informação (parse) PREMIERED IMDB #
#											#
# echo "Extrair informação (parse) PREMIERED IMDB..."
PREMIERED=`$CAT $destinoHTML/imdb_combined.html | $SED -n '/Release Date:*/,/<\/div>/{s/<[^>]*>//g;s/Release Date://;/^$/d;s/ (/(/g;s/([^(]*)//g;p}'`
limparCodeHTML "$PREMIERED"
PREMIERED="$limparCodeHTML"
if [[ $PREMIERED != "" ]]; then
MES=$(echo $PREMIERED | $AWK -F' ' '{print $2}')
	if $DATE +%m -d"$MES 01 01" &> /dev/null
		then
		DIA=$(echo $PREMIERED | $AWK -F' ' '{print $1}')
		DIA=$($PRINTF "%02d" $DIA)
		MES=`$DATE +%m -d"$MES 01 01"`
		ANO=$(echo $PREMIERED | $AWK -F' ' '{print $3}')
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
DIR=`$CAT $destinoHTML/imdb_combined.html | $SED -n '/ *Director[s]*:.*/,/<\/div>/{ /<a *href="\/name\/nm[0-9][0-9]*\/"[^>]*>[^<]*<\/a>.*/p}' | $SED  's/<\/a>/<\/a>\n/g' | $SED -n 's/.*<a *href="\/name\/nm[0-9][0-9]*\/"[^>]*>\([^<]*\)<\/a>.*/\1/p;' | $SED '1q' | $SED -e 's/^\s*//;s/\s*$//g'`
limparCodeHTML "$DIR"
DIR="$limparCodeHTML"
#									  #
# Extrair informação (parse) DIR IMDB #
#######################################

##########################################
# Extrair informação (parse) WRITER IMDB #
#										 #
#echo "Extrair informação (parse) WRITER IMDB..."
WRITER=`$CAT $destinoHTML/imdb_combined.html | $SED -n '/Writing credits/,/<\/table>/{s/Writing credits//g;p}' | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba' | $SED 's/ (WGA)//g'  | $SED -e 's/([^(]*)//g' | $SED -e 's/^[ ]//g' | $SED -e 's/^\s*//;s/\s*$//g' | $SED '/^$/d'`
limparCodeHTML "$WRITER"
WRITER="$limparCodeHTML"
WRITER=$(echo "$WRITER" | $SED -e 's/&//g' | $SED -e 's/  / /g' | $SED -e 's/^\s*//;s/\s*$//g' | $TR '\n' ';' | $SED 's/;$//g' | $SED 's/;/ | /g')
#										 #
# Extrair informação (parse) WRITER IMDB #
##########################################

#######################################
# Extrair informação (parse) GEN IMDB #
#									  #
#echo "Extrair informação (parse) GEN IMDB..."
GEN=`$CAT $destinoHTML/imdb_combined.html | $SED -n '/Genre:/,/<\/div>/{s/Genre://;p}' | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba'| $SED 's/ See more //' | $SED '/^$/d'`
limparCodeHTML "$GEN"
GEN="$limparCodeHTML"
#									  #
# Extrair informação (parse) GEN IMDB #
#######################################

########################################
# Extrair informação (parse) CAST IMDB #
#									   #
#echo "Extrair informação (parse) CAST IMDB..."
#CAST=`$CAT $destinoHTML/imdb_credit.html | $SED -n '/> Cast</,/<\/table>/{p}' | $SED -e 's/<td class="nm">/\nActor:/g' | $SED -e 's/<td class="char">/\;Papel:/g' | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba' | $GREP "Actor:" | $SED 's/ ... //g' | $SED 's/\.\.\.//g'`
CAST=$($CAT $destinoHTML/imdb_credit.html | $SED -n '/> Cast</,/<\/table>/{p}' | $SED -e 's/<td class="nm">/\nActor:/g' | $SED -e 's/<td class="char">/\;Papel:/g' | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba' | $GREP "Actor:" | $SED 's/ ... //g' | $SED 's/\.\.\.//g')
limparCodeHTML "$CAST"
echo $limparCodeHTML | $SED 's/Actor/\nActor/g' > $CASTFILEIMDB
CAST=$($CAT $CASTFILEIMDB | $SED 's/`/ /g')
CAST=( `echo "$CAST" | $SED -e 's/  / /g;s/^\s*//;s/\s*$//g'` )
#limparCodeHTML "$CAST"
#CAST=$(echo "$limparCodeHTML" | $SED -e 's/^\s*//;s/\s*$//g' | $SED -e 's/`//g' )
#									   #
# Extrair informação (parse) CAST IMDB #
########################################

########################################
# Extrair informação (parse) PLOT IMDB #
#									   #
if [[ $descricaoManual == "" ]]; then
	#echo "Extrair informação (parse) PLOT IMDB..."
	PLOTIMDB=`$CAT $destinoHTML/imdb.html | $SED -n '/<h1.*>/,/<\/p>/p' | $SED -n '/<p>/,/<\/p>/{ s/<[^>]*>//g;p;}' | $SED 's/See full summary.*//g' | $SED '/^$/d' | $SED 's/^  *//g'`
	if [[ $PLOTIMDB != "" ]]; then
	limparCodeHTML "$PLOTIMDB"
	PLOTIMDB="$limparCodeHTML"
	PLOTIMDB=`echo $PLOTIMDB | $SED 's/See full synopsis »//g'`
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
		aguardarTempo
		$LYNX -connect_timeout=10 --source "http://www.google.com/search?q=site:cinema.ptgate.pt+$ImdbCode" > $destinoHTML/google_ptgate.html 2> /dev/null
	else
		if [[ ! -f "$destinoHTML/google_ptgate.html" ]]; then
		echo "Descarregando HTML de http://www.google.com/search?q=site:cinema.ptgate.pt+$ImdbCode ..."
		aguardarTempo
		$LYNX -connect_timeout=10 --source "http://www.google.com/search?q=site:cinema.ptgate.pt+$ImdbCode" > $destinoHTML/google_ptgate.html 2> /dev/null
		fi
	fi
	# Validar se a erro na ligação a PTGATE
	if [ $? -ne 0 ]; then
	$PRINTF "A ligação ao servidor PTGATE falhou... Verifique a sua ligação a internet!\n"; exit 192
	fi

	# Identificar o endereço PTGATE para o filme
	echo "Identificar o endereço PTGATE para o filme"
	URLPTGATE=`$CAT $destinoHTML/google_ptgate.html | $EGREP -o "http://cinema.ptgate.pt/filmes/[0-9]*" | $HEAD -1`
	# Identificar o endereço PTGATE para o filme

	# Guardar os detalhes do filme PTGATE
	if [[ $URLPTGATE != "" ]]; then
		echo "Guardar os detalhes do filme PTGATE"
		if [[ $renovarHTML == 1 ]]; then
			echo "Descarregando HTML de $URLPTGATE ..."
			aguardarTempo
			$LYNX --source ${URLPTGATE} > $destinoHTML/ptgate.html;
		else
			if [[ ! -f "$destinoHTML/ptgate.html" ]]; then
			echo "Descarregando HTML de $URLPTGATE ..."
			aguardarTempo
			$LYNX --source ${URLPTGATE} > $destinoHTML/ptgate.html;
			fi
		fi
		# Guardar os detalhes do filme PTGATE

		# Extrair informação (parse) CODIGO IMDB no PTGATE
		echo "Extrair informação (parse) CODIGO IMDB no PTGATE"
		ImdbCodePtgate=$($CAT $destinoHTML/ptgate.html | $EGREP -o "http://www.imdb.com/title/tt[0-9]*" | $AWK -F/ '{print $5}' | $SED 's/ //g')
		# echo ImdbCodePtgate:$ImdbCodePtgate
		# Extrair informação (parse) CODIGO IMDB no PTGATE


		# Extrair informação (parse) PLOT PTGATE
		#$CAT $destinoHTML/ptgate.html | $SED -n '/<h1.*>/,/<\/p>/p' | $SED -n '/<p>/,/<\/p>/{ s/<[^>]*>//g;p;}' | $SED 's/Sinopse.*//g' > $PLOTFILEPTGATE
		PLOTPTGATE=`$CAT $destinoHTML/ptgate.html | $SED -n '/.*Sinopse.*/,/<\/div>/{ s/<[^>]*>//g;s/Sinopse//g;p }' | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba' | $SED 's/^  *//g' | $SED '/^$/d'| $SED 's/\t//g' | $ICONV -f ISO8859-1 -t UTF8`
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
		aguardarTempo
		$LYNX -connect_timeout=10 --source "http://www.google.com/search?q=site:www.dvdpt.com+$TITULO" > $destinoHTML/google_dvdpt.html 2> /dev/null
	else
		if [[ ! -f "$destinoHTML/google_dvdpt.html" ]]; then
		echo "Descarregando HTML de http://www.google.com/search?q=site:www.dvdpt.com+$TITULO ..."
		aguardarTempo
		$LYNX -connect_timeout=10 --source "http://www.google.com/search?q=site:www.dvdpt.com+$TITULO" > $destinoHTML/google_dvdpt.html 2> /dev/null
		fi
	fi
	# Validar se a erro na ligação a DVDPT
	if [ $? -ne 0 ]; then
	$PRINTF "A ligação ao servidor DVDPT falhou... Verifique a sua ligação a internet!\n"; exit 192
	fi
	# Procurar o filme no Google DVDPT

	# Identificar o endereço DVDPT para o filme
	echo "Identificar o endereço DVDPT para o filme"
	URLDVDPT=`$CAT $destinoHTML/google_dvdpt.html | $EGREP -o "http://www.dvdpt.com/./[0-9a-Z][0-9a-Z_]*.php" | $HEAD -1 | $SED -e 's/\"//g'`
	# Identificar o endereço DVDPT para o filme

	# Guardar os detalhes do filme DVDPT
	if [[ $URLDVDPT != "" ]]; then
		echo "Guardar os detalhes do filme DVDPT"
		if [[ $renovarHTML == 1 ]]; then
			echo "Descarregando HTML de $URLDVDPT ..."
			aguardarTempo
			$LYNX --source ${URLDVDPT} | $SED 's/<font color=red face=arial size=-1>/<font color=red face=arial size=-1>\n/g' > $destinoHTML/dvdpt.html;
		else
			if [[ ! -f "$destinoHTML/dvdpt.html" ]]; then
			echo "Descarregando HTML de $URLDVDPT ..."
			aguardarTempo
			$LYNX --source ${URLDVDPT} | $SED 's/<font color=red face=arial size=-1>/<font color=red face=arial size=-1>\n/g' > $destinoHTML/dvdpt.html;
			fi
		fi
		# Guardar os detalhes do filme DVDPT

		# Extrair informação (parse) CODIGO IMDB no DVDPT
		echo "Extrair informação (parse) CODIGO IMDB no DVDPT"
		ImdbCodeTest=$($CAT $destinoHTML/dvdpt.html | $GREP imdb.com | $AWK -F? '{print $1}')
		if [[ $ImdbCodeTest == "<a href=\"http://www.imdb.com/Details" ]]; then
		ImdbCodeDvdpt=$($CAT $destinoHTML/dvdpt.html | $GREP imdb.com | $AWK -F/ '{print $4}' | $SED 's/Details?/tt/g' | $SED 's/\">//g' | $SED 's/ //g')
		else
		ImdbCodeDvdpt=$($CAT $destinoHTML/dvdpt.html | $GREP imdb.com | $AWK -F/ '{print $5}' | $SED 's/ //g')
		fi
		# echo ImdbCodeDvdpt:$ImdbCodeDvdpt
		# Extrair informação (parse) CODIGO IMDB no DVDPT

		# Extrair informação (parse) PLOT DVDPT
		#$CAT  $destinoHTML/dvdpt.html | $SED -n '/<h1.*>/,/<\/p>/p' | $SED -n '/<p>/,/<\/p>/{ s/<[^>]*>//g;p;}' | $SED 's/SINOPSE.*//g' > $PLOTFILEDVDPT
		PLOTDVDPT=`$CAT $destinoHTML/dvdpt.html | $SED -n '/SINOPSE/,/<font color=red face=arial size=-1>/{ s/<[^>]*>//g;s/SINOPSE//g;p }' | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba' | $SED 's/^  *//g' | $SED '/^$/d'| $SED 's/\t//g' | $ICONV -f ISO8859-1 -t UTF8`
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

function processarSINOPSE () {
# Determinar a sinopse a utilizar
if [[ $descricaoManual == "" ]]; then	
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
	#					echo -e "Descrição: $PLOT"
					else
	#					echo "PTGATE não tem descrição"
						echo "Escolhida sinopse IMDB"
						PLOT="$PLOTIMDB"
	#					echo -e "Descrição: $PLOT"
					fi
				else
	#			echo "ImdbCodePtgate e ImdbCode não são iguais"
				echo "Escolhida sinopse IMDB"
				PLOT="$PLOTIMDB"
	#			echo "Descrição: $PLOT"
				fi
			else
	#		echo "ImdbCodePtgate esta vazio"
			echo "Escolhida sinopse IMDB"
			PLOT="$PLOTIMDB"
	#		echo -e "Descrição: $PLOT"
			fi
		else
	#	echo "ImdbCodeDvdpt ImdbCode são iguais"
		echo "Escolhida sinopse DVD PT"
		PLOT=`echo -e "$PLOTDVDPT\nFonte:DVDPT"`
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
	#					echo -e "Descrição: $PLOT"
					else
	#					echo "PTGATE não tem descrição"
						echo "Escolhida sinopse IMDB"
						PLOT="$PLOTIMDB"
	#					echo -e "Descrição: $PLOT"
					fi
				else
	#			echo "ImdbCodePtgate e ImdbCode não são iguais"
				echo "Escolhida sinopse IMDB"
				PLOT="$PLOTIMDB"
	#			echo -e "Descrição: $PLOT"
				fi
		else
	#	echo "ImdbCodePtgate esta vazio"
		echo "Escolhida sinopse IMDB"
		PLOT="$PLOTIMDB"
	#	echo "Descrição: $PLOT"
		fi
	fi
	
else
echo "Escolhida Sinopse do ficheiro mymovies.xml"
PLOT="$descricaoManual"
fi
# Determinar a sinopse a utilizar
}

function printTitulo () {
$PRINTF "Titulo        : $TITULO\n"
}

function printAno () {
$PRINTF "Ano           : $ANO\n"
}

function printClassifica () {
$PRINTF "Classificação : $RAT\n"
}

function printVotos () {
$PRINTF "Votos         : $VOTES\n"
}

function printMPAA () {
$PRINTF "MPAA          : $MPAA\n"
}

function printPais () {
$PRINTF "Pais          : $COUNTRY\n"
}

function printRunTime () {
$PRINTF "Duração       : $RUNTIME\n"
}

function printStudio () {
$PRINTF "Studio        : $STUDIO\n"
}

function printPremiered () {
$PRINTF "Estreia       : $PREMIERED\n"
}

function printDirector () {
$PRINTF "Director      : $DIR\n"
}

function printWriter (){
$PRINTF "Escritores    : $WRITER\n"
	}

function printGeneros () {
$PRINTF "Generos       : $GEN\n"
}

function printActores () {
$PRINTF "Actores       :\n%s"
for CONTADOR in $($SEQ 0 $((${#CAST[*]} - 1)));do
	echo "${CAST[$CONTADOR]}" | $SED 's/Actor/Actor'$CONTADOR'/g' | $SED 's/Papel/Papel'$CONTADOR'/g'
done
}

function printSinopse () {
$PRINTF "Sinopse       :\n%s\n" "$PLOT"
}

function printURLS() {
if [[ $URLIMDB != "" ]];then
$PRINTF "IMDB movie URL   : ${URLIMDB}\n"
fi
if [[ $URLIMDBC != "" ]];then
$PRINTF "IMDB C movie URL : ${URLIMDBC}\n"
fi
if [[ $URLPTGATE != "" ]];then
$PRINTF "PtGate movie URL : ${URLPTGATE}\n"
fi
if [[ $URLDVDPT != "" ]];then
$PRINTF "DVDPT movie URL  : ${URLDVDPT}\n"
fi
}

function printnofound() {
$PRINTF "Não existe o utilitario $1. Porfavor instale.\n"
}

function limparCodeHTML () {
	limparCodeHTML=$(echo -e "$1" | $SED -e '{
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
	limparCodeInvalid=$(echo -e "$1" | $SED -r 's/  */\+/g;s/\&/%26/g;s/\++$//g')
	}

function limparCodeInvalidMSDOS () {
	limparCodeInvalidMSDOS=$(echo -e "$1" | $SED -e '{
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
#if [[ -f "$TMPFILEIMDB" ]]; then
#	rm $TMPFILEIMDB > /dev/null
#fi
#if [[ -f "$TMPFILEIMDBC" ]]; then
#	rm $TMPFILEIMDBC > /dev/null
#fi
#if [[ -f "$TMPFILEIMDBCREDIT" ]]; then
#	rm $TMPFILEIMDBCREDIT > /dev/null
#fi
#if [[ -f "$TMPFILEIMDBACTOR" ]]; then
#	rm $TMPFILEIMDBACTOR > /dev/null
#fi
#if [[ -f "$TMPFILEPTGATE" ]]; then
#	rm $TMPFILEPTGATE > /dev/null
#fi
#if [[ -f "$TMPFILEDVDPT" ]]; then
#	rm $TMPFILEDVDPT > /dev/null
#fi
#if [[ -f "$PLOTFILEIMDB" ]]; then
#	rm $PLOTFILEIMDB > /dev/null
#fi
#if [[ -f "$PLOTFILEIMDBC" ]]; then
#	rm $PLOTFILEIMDBC > /dev/null
#fi
#if [[ -f "$PLOTFILEPTGATE" ]]; then
#	rm $PLOTFILEPTGATE > /dev/null
#fi
#if [[ -f "$PLOTFILEDVDPT" ]]; then
#	rm $PLOTFILEDVDPT > /dev/null
#fi
if [[ -f "$CASTFILEIMDB" ]]; then
	rm $CASTFILEIMDB > /dev/null
fi

	}

function analizaFicheiro () {
	echo -e '\E[1;37m\033[1mValidando se o ficheiro '$ficheiro' existe em todas as pastas ...\033[0m'
	faltaFicheiro=0
	pastaSFicheiroAnt=0
	for caminhoCompleto in $($FIND "$dirDiscos" -mindepth 1 -maxdepth $dirNiveis -type f \
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
							   -iname "*.rmvb" \) | $GREP OsMeusFilmes | $SED -e '/OsMeusFilmesInfantis/ d')
	do
	pastaSFicheiro=$(echo "$caminhoCompleto" | $SED 's/\(.*\)./\1/' | $AWK -F'/' '{for(i=1;i<NF-1;++i)printf $i"/";print $i;}'| $SED -e 's/  //g' | $SED -e 's/\/VIDEO_TS//g')
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

function nfoArrumar () {
	echo -e '\E[1;37m\033[1mArrumando ficheiros nfo na pasta raiz do filme ...\033[0m'
	nfoProcessados=0
	for caminhoCompleto in $($FIND $dirDiscos -mindepth 1 -maxdepth $dirNiveis -type f -name "movie.nfo" | $GREP VIDEO_TS | $SED -e '/OsMeusFilmesInfantis/ d')
	do
	nfoProcessados=1
	caminhoDestino=$(echo "$caminhoCompleto" | $SED -e 's/\/VIDEO_TS\/movie.nfo//g')
	echo -e '\E[1;37m\033[1m##############\033[0m'
	echo -e '\E[1;37m\033[1m# Origem:'"$caminhoCompleto"'\033[0m'
	echo -e '\E[1;37m\033[1m# Destino:'"$caminhoDestino/movie.nfo"'\033[0m'
	echo -e '\E[1;37m\033[1m##############\033[0m'
	echo ""
	mv "$caminhoCompleto" "$caminhoDestino/movie.nfo"
	done
	if [ $nfoProcessados = 0 ]; then
		echo -e '\E[1;37m\033[1mNão foram processados ficheiros movie.nfo.\033[0m'
	fi
}

function nfoGerarData () {
ficheiro=mymovies.xml
analizaFicheiro
if [ $faltaFicheiro = 0 ] ; then
	echo -e '\E[1;37m\033[1mProcessando as pastas ...\033[0m'
	for caminhoCompleto in $($FIND $dirDiscos -mindepth 1 -maxdepth $dirNiveis -type f -name "mymovies.xml" | $GREP mymovies.xml | $SED -e 's/\/mymovies.xml//g' -e 's/  //g' )
	do	
	echo -e '\E[1;37m\033[1mA processar o conteudo da pasta: '"\n$caminhoCompleto"'\033[0m'

	#####################
	# INI Processamento #
	#					#
	#
	#
	# DECIDIR DESTINO DO NFO
	#
		#xbmcDestinoNfo=$(echo -e "$caminhoCompleto"/movie_teste.nfo)
		xbmcDestinoNfo=$(echo -e "$caminhoCompleto"/movie.nfo)
	# DECIDIR DESTINO DO NFO
	#
		if [[ ! -f "$xbmcDestinoNfo" ]]; then
	#
	# IDENTIFICAR CODIGO IMDB
		codeIMDB=$($CAT $caminhoCompleto/mymovies.xml | $GREP "<IMDbId>" | $SED -e 's/<IMDbId>//g' | $SED -e 's/<\/IMDbId>//g' | $SED -e 's/\t//g' | $SED -e 's/ //g')
	# IDENTIFICAR CODIGO IMDB
	#
	# IDENTIFICAR CODIGO IMDB
		descricaoManual=$($CAT $caminhoCompleto/mymovies.xml | $SED -s 's/<\/plot>/\n\t<\/plot>/g' | $SED -n '/<plot>/,/<\/plot>/p' | $SED -e 's/<.*>//g' -e 's/\t//g')
	# IDENTIFICAR CODIGO IMDB
	#
	# DECIDIR DESTINO DO HTML
		mkdir -p "$caminhoCompleto"/html
		destinoHTML=$(echo -e "$caminhoCompleto/html")
	# DECIDIR DESTINO DO HTML
	#
		recolhaIMDB
		recolhaDVDPT
		recolhaPTGATE
		processarSINOPSE
	#					#
	# END Processamento #
	#####################
		
		#################
		# INI Impressão #
		#				#
		#printTitulo
		#printAno
		#printClassifica
		#printVotos
		#printMPAA
		#printPais
		#printRunTime
		#printStudio
		#printPremiered
		#printDirector
		#printWriter
		#printGeneros
		#printActores
		#printSinopse
		#printURLS
		nfoGerarMovie
		#				#
		# END Impressão #
		#################
		
		removerTMP
		else
		echo "Já existe $xbmcDestinoNfo"
		fi
	done
else
echo -e '\E[1;37m\033[1mO ficheiro mymovies.xml não existe em algumas pastas.\033[0m'
echo -e '\E[1;37m\033[1mExecute a opção [V] para determinar onde esta ausente.\033[0m'
fi

}
	
function nfoGerarMovie () {
echo "A Gerar $xbmcDestinoNfo ..."
#echo "$caminhoCompleto" > $xbmcDestinoNfo
echo "<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>" > $xbmcDestinoNfo
echo "<movie>" >> $xbmcDestinoNfo
echo "	<title>$TITULO</title>" | $SED 's/ <\/title>/<\/title>/g' >> $xbmcDestinoNfo
echo "	<originaltitle>$TITULO ($ANO)</originaltitle>" | $SED 's/ <\/originaltitle>/<\/originaltitle>/g' >> $xbmcDestinoNfo
echo "	<sorttitle>$TITULO</sorttitle>" | $SED 's/ <\/sorttitle>/<\/sorttitle>/g' >> $xbmcDestinoNfo
echo "	<rating>$RAT</rating>" | $SED 's/ <\/rating>/<\/rating>/g' >> $xbmcDestinoNfo
echo "	<epbookmark>0,000000</epbookmark>" >> $xbmcDestinoNfo
echo "	<year>$ANO</year>" | $SED 's/ <\/year>/<\/year>/g' >> $xbmcDestinoNfo
echo "	<top250>0</top250>" >> $xbmcDestinoNfo
echo "	<votes>$VOTES</votes>" | $SED 's/ <\/votes>/<\/votes>/g' >> $xbmcDestinoNfo
echo "	<outline></outline>" | $SED 's/ <\/>/<\/>/g' >> $xbmcDestinoNfo
echo -e "	<plot>$PLOT</plot>" | $SED 's/ <\/plot>/<\/plot>/g' >> $xbmcDestinoNfo
echo "	<tagline></tagline>" >> $xbmcDestinoNfo
echo "	<runtime>$RUNTIME</runtime>" | $SED 's/ <\/runtime>/<\/runtime>/g' >> $xbmcDestinoNfo
echo "	<mpaa>$MPAA</mpaa>" | $SED 's/ <\/mpaa>/<\/mpaa>/g' >> $xbmcDestinoNfo
echo "	<watched></watched>" >> $xbmcDestinoNfo
echo "	<id>$ImdbCode</id>" | $SED 's/ <\/id>/<\/id>/g' >> $xbmcDestinoNfo
echo "	<id moviedb="imdb">$ImdbCode</id>" | $SED 's/ <\/id>/<\/id>/g' >> $xbmcDestinoNfo
echo "	<id moviedb="tmdb"></id>" >> $xbmcDestinoNfo
echo "	<id moviedb="themoviedb"></id>" >> $xbmcDestinoNfo
echo "	<filenameandpath></filenameandpath>" >> $xbmcDestinoNfo
echo "	<playcount>0</playcount>" >> $xbmcDestinoNfo
echo "	<lastplayed></lastplayed>" >> $xbmcDestinoNfo
echo -e "\t<genre>$GEN</genre>" | $SED -e 's/  / /g' | $SED -e 's/\ | /<\/genre>\n\t<genre>/g' >> $xbmcDestinoNfo
echo -e "\t<country>$COUNTRY</country>" | $SED -e 's/  / /g' | $SED  's/ | /<\/country>\n\t<country>/g' >> $xbmcDestinoNfo
echo "	<set></set>" >> $xbmcDestinoNfo
echo -e "\t<credits>$WRITER</credits>" | $SED -e 's/  / /g' | $SED -e 's/\ | /<\/credits>\n\t<credits>/g' >> $xbmcDestinoNfo
echo "	<director>$DIR</director>" | $SED 's/ <\/director>/<\/director>/g' >> $xbmcDestinoNfo
echo "	<premiered>$PREMIERED</premiered>" | $SED 's/ <\/>/<\/>/g' >> $xbmcDestinoNfo
echo "	<status></status>" | $SED 's/ <\/>/<\/>/g' >> $xbmcDestinoNfo
echo "	<code></code>" | $SED 's/ <\/>/<\/>/g' >> $xbmcDestinoNfo
echo "	<aired></aired>" | $SED 's/ <\/>/<\/>/g' >> $xbmcDestinoNfo
echo "	<studio>$STUDIO</studio>" | $SED 's/ <\/studio>/<\/studio>/g' >> $xbmcDestinoNfo
echo "	<trailer></trailer>" | $SED 's/ <\/>/<\/>/g' >> $xbmcDestinoNfo
echo "	<fileinfo>" >> $xbmcDestinoNfo
echo "		<streamdetails>" >> $xbmcDestinoNfo
for fileFILME in $(
$FIND "$caminhoCompleto/" -mindepth 1 -maxdepth 1 -type f \
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
xbmcVideoCodec=( $($FFMPEG -i $fileFILME 2>&1 | $GREP Video: | $SED -e 's/  / /g' | $AWK -F' ' '{print $4}' | $SED -e 's/,//g') )
xbmcVideoWidth=( $($FFMPEG -i $fileFILME 2>&1 | $GREP Video: | $SED -e 's/  / /g' | $AWK -F' ' '{print $6}' | $SED -e 's/,//g' | $AWK -F'x' '{print $1}') )
xbmcVideoHeight=( $($FFMPEG -i $fileFILME 2>&1 | $GREP Video: | $SED -e 's/  / /g' | $AWK -F' ' '{print $6}' | $SED -e 's/,//g' | $AWK -F'x' '{print $2}') )
xbmcVideoAspect=$(echo scale=6\; $xbmcVideoWidth '/' $xbmcVideoHeight | $BC)
xbmcVideoDuration=( $($FFMPEG -i "$fileFILME" 2>&1 | $SED -n "s/.* Duration: \([^,]*\), start: .*/\1/p" | $AWK -F':' '{ print $1*3600 + $2*60 + $3 }' | $AWK -F'.' '{print $1}'))
xbmcAudioCodec=( $($FFMPEG -i $fileFILME 2>&1 | $GREP Audio: | $SED -e 's/  / /g' | $AWK -F' ' '{print $4}' | $SED -e 's/,//g') )
xbmcAudioChannels=( $($FFMPEG -i $fileFILME 2>&1 | $GREP Audio: | $SED -e 's/  / /g' | $AWK -F' ' '{print $7}' | $SED -e 's/,//g' | $SED -e 's/mono/1/g' | $SED -e 's/stereo/2/g' | $SED -e 's/5\.1/6/g' | $SED -e 's/7\.1/8/g') )
done
echo "			<video>" >> $xbmcDestinoNfo
echo "				<codec>$xbmcVideoCodec</codec>" | $SED 's/ <\/>/<\/>/g' | $SED 's/<codec>0<\/codec>/<codec><\/codec>/g' >> $xbmcDestinoNfo
echo "				<aspect>$xbmcVideoAspect</aspect>" | $SED 's/ <\/>/<\/>/g' | $SED 's/<aspect>0<\/aspect>/<aspect><\/aspect>/g' >> $xbmcDestinoNfo
echo "				<width>$xbmcVideoWidth</width>" | $SED 's/ <\/>/<\/>/g' | $SED 's/<width>0<\/width>/<width><\/width>/g' >> $xbmcDestinoNfo
echo "				<height>$xbmcVideoHeight</height>" | $SED 's/ <\/>/<\/>/g' | $SED 's/<height>0<\/height>/<height><\/height>/g' >> $xbmcDestinoNfo
echo "				<durationinseconds>$xbmcVideoDuration</durationinseconds>" | $SED 's/ <\/>/<\/>/g' | $SED 's/<durationinseconds>0<\/durationinseconds>/<durationinseconds><\/durationinseconds>/g' >> $xbmcDestinoNfo
echo "			</video>" >> $xbmcDestinoNfo
echo "			<audio>" >> $xbmcDestinoNfo
echo "				<codec>$xbmcAudioCodec</codec>" | $SED 's/ <\/>/<\/>/g' | $SED 's/<codec>0<\/codec>/<codec><\/codec>/g' >> $xbmcDestinoNfo
echo "				<language></language>" | $SED 's/ <\/>/<\/>/g' >> $xbmcDestinoNfo
echo "				<channels>$xbmcAudioChannels</channels>" | $SED 's/ <\/>/<\/>/g' | $SED 's/<channels>0<\/channels>/<channels><\/channels>/g' >> $xbmcDestinoNfo
echo "			</audio>" >> $xbmcDestinoNfo
echo "		</streamdetails>" >> $xbmcDestinoNfo
echo "	</fileinfo>" >> $xbmcDestinoNfo
for CONTADOR in $($SEQ 0 $((${#CAST[*]} - 1))); do
	xbmcACTORROLE=$(echo "${CAST[$CONTADOR]}" | $SED 's/Actor:/\t<actor>/g' | $SED 's/\;Papel:/<\/actor>\n\t<role>/g' | $SED '/<role>/s/.*/&<\/role>/' | $SED -e 's/(/- /g' | $SED -e 's/)//g' | $SED -e 's/  / /g')
	echo -e "$xbmcACTORROLE" >> $xbmcDestinoNfo
	xbmcACTOR=$(echo -e $xbmcACTORROLE | $SED -e 's/\t<role.*role>//g' | $SED -e 's/\t<actor>//g' | $SED -e 's/<\/actor>//g' | $SED 's/\`/ /g' | $SED 's/  / /g' | $SED -e 's/^\s*//;s/\s*$//g')
	xbmcActorChar=$(echo -e $xbmcACTOR | $SED -e 's/^\(.\{1\}\).*$/\1/' | $TR '[:lower:]' '[:upper:]')
	if [[ ! -f $HOME/People/$xbmcActorChar/$xbmcACTOR/folder.jpg ]]; then
		mkdir -p $HOME/People/$xbmcActorChar/$xbmcACTOR
		if [[ $renovarHTML == 1 ]]; then
		aguardarTempo
		echo "Descarregando HTML de http://images.google.com/images?q=actor $xbmcACTOR&imgtype=face ..."
		$LYNX -connect_timeout=10 --source "http://images.google.com/images?q=actor $xbmcACTOR&imgtype=face" > $destinoHTML/google_$xbmcACTOR.html 2> /dev/null;
		else
			if [[ ! -f "$destinoHTML/google_$xbmcACTOR.html" ]]; then
			aguardarTempo
			echo "Descarregando HTML de http://images.google.com/images?q=actor $xbmcACTOR&imgtype=face ..."
			$LYNX -connect_timeout=10 --source "http://images.google.com/images?q=actor $xbmcACTOR&imgtype=face" > $destinoHTML/google_$xbmcACTOR.html 2> /dev/null;
			fi
		fi
		xbmcURLACTORJPG=$($CAT $destinoHTML/google_$xbmcACTOR.html | $SED 's/imgurl/\nimgurl/g' | $SED 's/\&imgrefurl/\n&imgrefurl/g' | $EGREP imgurl | $SED 's/imgurl\=//g' | $EGREP jpg | $HEAD -1 | $SED 's/<img/\n<img/g' | $SED 's/.jpg/.jpg\n/g' | $SED -n 1p)
		echo "Descarregando Imagem de $xbmcURLACTORJPG ..."
		$WGET --timeout 30 -t 1 -O - "$xbmcURLACTORJPG" > $HOME/People/$xbmcActorChar/$xbmcACTOR/folder.jpg 2> /dev/null;
		find $HOME/People/$xbmcActorChar/$xbmcACTOR/ -type f -empty -exec rm -f {} \;
	fi
if [[ -f "$HOME/People/$xbmcActorChar/$xbmcACTOR/folder.jpg" ]]; then
echo -e "\t<thumb>/home/xbmc/People/$xbmcActorChar/$xbmcACTOR/folder.jpg</thumb>" >> $xbmcDestinoNfo
else
echo -e "\t<thumb></thumb>" >> $xbmcDestinoNfo
fi

done
echo -e "\t<artist></artist>" >> $xbmcDestinoNfo
echo "</movie>" >> $xbmcDestinoNfo

}

function sincronizaActores () {
ENDERECODESTINO=192.168.1.158
USRDESTINO=xbmc
DIRDESTINO=/home/xbmc/
DIRORIGEM=$HOME/People

# Verifica se a máquina de destino está ligada
$PING -c 1 -W 2 $ENDERECODESTINO > /dev/null
if [ "$?" -ne 0 ];
then
	echo -e "\n$ENDERECODESTINO não responde."
	echo -e "O Backup não vai ser realizado.\n"
else
	echo -e "Backup iniciado...\n"
	HORA_INI=`date +%s`
	#$RSYNC -ah --delete --stats --progress -e ssh $DIRORIGEM $USRDESTINO@$ENDERECODESTINO:$DIRDESTINO
	$RSYNC -rvt --modify-window=1 --delete -e $SSH $DIRORIGEM $USRDESTINO@$ENDERECODESTINO:$DIRDESTINO
 	HORA_FIM=`date +%s`
	TEMPO=`expr $HORA_FIM - $HORA_INI`
	echo -e "\nBackup finalizado com sucesso!"
	echo -e "Duração: $TEMPO s\n"
fi

}

function sshNox () {
	ssh xbmc@192.168.1.158
	}

function pacoteMinimo () {
	echo -e '\E[1;37m\033[1mProcessando as pastas ...\033[0m'
	ficheiro1=folder.jpg
	ficheiro2=mymovies.xml
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

	for caminhoCompleto in $($FIND "$dirDiscos" -mindepth 1 -maxdepth $dirNiveis -type f \
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
							   -iname "*.rmvb" \) | $GREP OsMeusFilmes | $SED -e '/OsMeusFilmesInfantis/ d')
	do
	pastaSFicheiro=$(echo "$caminhoCompleto" | $SED 's/\(.*\)./\1/' | $AWK -F'/' '{for(i=1;i<NF-1;++i)printf $i"/";print $i;}'| $SED -e 's/  //g' | $SED -e 's/\/VIDEO_TS//g')
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
		fi
	done
	if [ $faltaFicheiros = 0 ]; then
		echo -e '\E[1;37m\033[1mOs conteudos importantes estão presentes em todas as pastas.\033[0m'
		else
		echo -e '\E[1;37m\033[1mExistem conteudos importantes em falta em algumas pastas.\033[0m'
	fi
	}

function dirName () {
	ficheiro=movie.nfo
	analizaFicheiro
	mudeiNomes=0
	if [ $faltaFicheiro = 0 ] ; then
		echo -e '\E[1;37m\033[1mProcessando as pastas ...\033[0m'
		for caminhoCompleto in $($FIND $dirDiscos -mindepth 1 -maxdepth $dirNiveis -type f -name "mymovies.xml" | $GREP mymovies.xml | $SED -e 's/\/mymovies.xml//g' -e 's/  //g' )
		do	
		#filme=$($CAT $caminhoCompleto/mymovies.xml | $GREP LocalTitle | $SED -e 's/<LocalTitle>//g' -e 's/<\/LocalTitle>//g' -e 's/.$//g' -e 's/://g'  -e 's/?//g' -e 's/\&amp\;/\&/'  -e 's/  //g')
		filme=$($CAT $caminhoCompleto/movie.nfo | $GREP "<title>" | $SED -e 's/<title>//g' -e 's/<\/title>//g' -e 's/\t//g')
		limparCodeInvalidMSDOS "$filme"
		filmeMSDOS="$limparCodeInvalidMSDOS"		
		#ano=$($CAT $caminhoCompleto/mymovies.xml | $GREP ProductionYear | $SED -e 's/<ProductionYear>//g' | $SED -e 's/<\/ProductionYear>//g' | $SED -e 's/.$//g' -e 's/^M//g' -e 's/  //g')
		ano=$($CAT $caminhoCompleto/movie.nfo | $GREP "<year>" | $SED -e 's/<year>//g' -e 's/<\/year>//g' -e 's/\t//g')
		pastaSFilme=$(echo "$caminhoCompleto" | $SED 's/\(.*\)./\1/' | $AWK -F'/' '{for(i=1;i<NF-1;++i)printf $i"/";print $i}'| $SED -e 's/  //g')
			if [ "$caminhoCompleto" != "$pastaSFilme/$filmeMSDOS ($ano)" ]; then
			mudeiNomes=1
			echo -e '\E[1;37m\033[1m##############\033[0m'
			echo -e '\E[1;37m\033[1m# Origem:'"$caminhoCompleto"'\033[0m'
			echo -e '\E[1;37m\033[1m# Destino:'"$pastaSFilme/$filmeMSDOS ($ano)"'\033[0m'
			echo -e '\E[1;37m\033[1m##############\033[0m'
			echo ""
			mv "$caminhoCompleto" "$pastaSFilme/$filmeMSDOS ($ano)"
			chown francisco:francisco "$pastaSFilme/$filmeMSDOS ($ano)"
			fi
		done
	else
		echo -e '\E[1;37m\033[1mO ficheiro movie.nfo não existe em algumas pastas.\033[0m'
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
	for caminhoCompleto in $($FIND "$dirDiscos" -maxdepth $dirNiveis -type d | $GREP OsMeusFilmes | $SED -e '/OsMeusFilmesInfantis/ d')
	do
			if [[ ! -f "$caminhoCompleto/backdrop.jpg" ]]; then
				for fileFILME in $(
					$FIND "$caminhoCompleto/" -mindepth 1 -maxdepth 1 -type f \
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
					DURACAO_FILME=( $($FFMPEG -i "$fileFILME" 2>&1 | $SED -n "s/.* Duration: \([^,]*\), start: .*/\1/p") )
					TEMPO_TOT_FILME_SEG=( $(echo "$DURACAO_FILME" | $AWK -F':' '{ print $1*3600 + $2*60 + $3 }' | $AWK -F'.' '{print $1}'))
					TEMPO_DIV_FILME=( $(echo "$TEMPO_TOT_FILME_SEG" | $AWK '{ print $1 / 5 }' | $AWK -F'.' '{ print $1 }'))
					TEMPO_DIV_FILME4=( $(echo "$TEMPO_TOT_FILME_SEG" | $AWK -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
					TEMPO_DIV_FILME3=( $(echo "$TEMPO_DIV_FILME4" | $AWK -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
					TEMPO_DIV_FILME2=( $(echo "$TEMPO_DIV_FILME3" | $AWK -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
					TEMPO_DIV_FILME1=( $(echo "$TEMPO_DIV_FILME2" | $AWK -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
					echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop.jpg ...\033[0m'
					$FFMPEG -ss "$TEMPO_DIV_FILME1" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop.jpg"  2>/dev/null
					chown francisco:francisco "$caminhoCompleto/backdrop.jpg"
					if [[ ! -f "$caminhoCompleto/fanart.jpg" ]]; then
						echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/fanart.jpg ...\033[0m'
						cp "$caminhoCompleto/backdrop.jpg" "$caminhoCompleto/fanart.jpg"
						chown francisco:francisco "$caminhoCompleto/fanart.jpg"
					fi
					echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop1.jpg ...\033[0m'
					$FFMPEG -ss "$TEMPO_DIV_FILME2" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop1.jpg"  2>/dev/null
					chown francisco:francisco "$caminhoCompleto/backdrop1.jpg"
					echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop2.jpg ...\033[0m'
					$FFMPEG -ss "$TEMPO_DIV_FILME3" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop2.jpg"  2>/dev/null
					chown francisco:francisco "$caminhoCompleto/backdrop2.jpg"
					echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop3.jpg ...\033[0m'
					$FFMPEG -ss "$TEMPO_DIV_FILME4" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop3.jpg"  2>/dev/null
					chown francisco:francisco "$caminhoCompleto/backdrop3.jpg"
					else
						if [[ ! -f "$caminhoCompleto/backdrop4.jpg" ]]; then
						processarBackdrops=1
						DURACAO_FILME=( $($FFMPEG -i "$fileFILME" 2>&1 | $SED -n "s/.* Duration: \([^,]*\), start: .*/\1/p") )
						TEMPO_TOT_FILME_SEG=( $(echo "$DURACAO_FILME" | $AWK -F':' '{ print $1*3600 + $2*60 + $3 }' | $AWK -F'.' '{print $1}'))
						TEMPO_DIV_FILME=( $(echo "$TEMPO_TOT_FILME_SEG" | $AWK '{ print $1 / 5 }' | $AWK -F'.' '{ print $1 }'))
						TEMPO_DIV_FILME4=( $(echo "$TEMPO_TOT_FILME_SEG" | $AWK -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
						TEMPO_DIV_FILME3=( $(echo "$TEMPO_DIV_FILME4" | $AWK -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
						TEMPO_DIV_FILME2=( $(echo "$TEMPO_DIV_FILME3" | $AWK -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
						TEMPO_DIV_FILME1=( $(echo "$TEMPO_DIV_FILME2" | $AWK -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
						echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop4.jpg ...\033[0m'
						$FFMPEG -ss "$TEMPO_DIV_FILME1" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop4.jpg" 2>/dev/null
						chown francisco:francisco "$caminhoCompleto/backdrop4.jpg"
						echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop5.jpg ...\033[0m'
						$FFMPEG -ss "$TEMPO_DIV_FILME2" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop5.jpg" 2>/dev/null
						chown francisco:francisco "$caminhoCompleto/backdrop5.jpg"
						echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop6.jpg ...\033[0m'
						$FFMPEG -ss "$TEMPO_DIV_FILME3" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop6.jpg" 2>/dev/null
						chown francisco:francisco "$caminhoCompleto/backdrop6.jpg"
						echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop7.jpg ...\033[0m'
						$FFMPEG -ss "$TEMPO_DIV_FILME4" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop7.jpg" 2>/dev/null
						chown francisco:francisco "$caminhoCompleto/backdrop7.jpg"
						else
							if [[ ! -f "$caminhoCompleto/backdrop8.jpg" ]]; then
							processarBackdrops=1
							DURACAO_FILME=( $($FFMPEG -i "$fileFILME" 2>&1 | $SED -n "s/.* Duration: \([^,]*\), start: .*/\1/p") )
							TEMPO_TOT_FILME_SEG=( $(echo "$DURACAO_FILME" | $AWK -F':' '{ print $1*3600 + $2*60 + $3 }' | $AWK -F'.' '{print $1}'))
							TEMPO_DIV_FILME=( $(echo "$TEMPO_TOT_FILME_SEG" | $AWK '{ print $1 / 5 }' | $AWK -F'.' '{ print $1 }'))
							TEMPO_DIV_FILME4=( $(echo "$TEMPO_TOT_FILME_SEG" | $AWK -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
							TEMPO_DIV_FILME3=( $(echo "$TEMPO_DIV_FILME4" | $AWK -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
							TEMPO_DIV_FILME2=( $(echo "$TEMPO_DIV_FILME3" | $AWK -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
							TEMPO_DIV_FILME1=( $(echo "$TEMPO_DIV_FILME2" | $AWK -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
							echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop8.jpg ...\033[0m'
							$FFMPEG -ss "$TEMPO_DIV_FILME1" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop8.jpg" 2>/dev/null
							chown francisco:francisco "$caminhoCompleto/backdrop8.jpg"
							echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop9.jpg ...\033[0m'
							$FFMPEG -ss "$TEMPO_DIV_FILME2" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop9.jpg" 2>/dev/null
							chown francisco:francisco "$caminhoCompleto/backdrop9.jpg"
							echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop10.jpg ...\033[0m'
							$FFMPEG -ss "$TEMPO_DIV_FILME3" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop10.jpg" 2>/dev/null
							chown francisco:francisco "$caminhoCompleto/backdrop10.jpg"
							echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop11.jpg ...\033[0m'
							$FFMPEG -ss "$TEMPO_DIV_FILME4" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop11.jpg" 2>/dev/null
							chown francisco:francisco "$caminhoCompleto/backdrop11.jpg"
							else
								if [[ ! -f "$caminhoCompleto/backdrop12.jpg" ]]; then
								processarBackdrops=1
								DURACAO_FILME=( $($FFMPEG -i "$fileFILME" 2>&1 | $SED -n "s/.* Duration: \([^,]*\), start: .*/\1/p") )
								TEMPO_TOT_FILME_SEG=( $(echo "$DURACAO_FILME" | $AWK -F':' '{ print $1*3600 + $2*60 + $3 }' | $AWK -F'.' '{print $1}'))
								TEMPO_DIV_FILME=( $(echo "$TEMPO_TOT_FILME_SEG" | $AWK '{ print $1 / 5 }' | $AWK -F'.' '{ print $1 }'))
								TEMPO_DIV_FILME4=( $(echo "$TEMPO_TOT_FILME_SEG" | $AWK -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
								TEMPO_DIV_FILME3=( $(echo "$TEMPO_DIV_FILME4" | $AWK -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
								TEMPO_DIV_FILME2=( $(echo "$TEMPO_DIV_FILME3" | $AWK -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
								TEMPO_DIV_FILME1=( $(echo "$TEMPO_DIV_FILME2" | $AWK -v TDF=${TEMPO_DIV_FILME} '{ print $1 - TDF }'))
								echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop12.jpg ...\033[0m'
								$FFMPEG -ss "$TEMPO_DIV_FILME1" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop12.jpg" 2>/dev/null
								chown francisco:francisco "$caminhoCompleto/backdrop12.jpg"
								echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop13.jpg ...\033[0m'
								$FFMPEG -ss "$TEMPO_DIV_FILME2" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop13.jpg" 2>/dev/null
								chown francisco:francisco "$caminhoCompleto/backdrop13.jpg"
								echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop14.jpg ...\033[0m'
								$FFMPEG -ss "$TEMPO_DIV_FILME3" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop14.jpg" 2>/dev/null
								chown francisco:francisco "$caminhoCompleto/backdrop14.jpg"
								echo -e '\E[1;37m\033[1mCriando ficheiro '"$caminhoCompleto"'/backdrop15.jpg ...\033[0m'
								$FFMPEG -ss "$TEMPO_DIV_FILME4" -i $fileFILME -y -f image2  -sameq -t 0.001 -s 1920x1080 "$caminhoCompleto/backdrop15.jpg" 2>/dev/null
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
	ficheiro=movie.nfo
	analizaFicheiro
	if [ $faltaFicheiro = 0 ] ; then
	ficheiro=folder.jpg
	analizaFicheiro
	fi
	tnbProcessados=0
	if [ $faltaFicheiro = 0 ] ; then
		echo -e '\E[1;37m\033[1mProcessando as pastas ...\033[0m'
		#for caminhoCompleto in $($FIND $dirDiscos -mindepth 1 -maxdepth $dirNiveis -type f -name "mymovies.xml" | $GREP mymovies.xml | $SED -e 's/\/mymovies.xml//g' -e 's/  //g' | $GREP OsMeusFilmes | $SED -e '/OsMeusFilmesInfantis/ d')
		for caminhoCompleto in $($FIND $dirDiscos -mindepth 1 -maxdepth $dirNiveis -type f -name "movie.nfo" | $GREP movie.nfo | $SED -e 's/\/movie.nfo//g' -e 's/  //g' | $GREP OsMeusFilmes | $SED -e '/OsMeusFilmesInfantis/ d')
		do
		#filme=$($CAT $caminhoCompleto/mymovies.xml | $GREP LocalTitle | $SED -e 's/<LocalTitle>//g' -e 's/<\/LocalTitle>//g' -e 's/.$//g' -e 's/://g'  -e 's/?//g' -e 's/\&amp\;/\&/'  -e 's/  //g')
		filme=$($CAT $caminhoCompleto/movie.nfo | $GREP "<title>" | $SED -e 's/<title>//g' -e 's/<\/title>//g' -e 's/\t//g')
		#ano=$($CAT $caminhoCompleto/mymovies.xml | $GREP ProductionYear | $SED -e 's/<ProductionYear>//g' | $SED -e 's/<\/ProductionYear>//g' | $SED -e 's/.$//g' -e 's/^M//g' -e 's/  //g')
		ano=$($CAT $caminhoCompleto/movie.nfo | $GREP "<year>" | $SED -e 's/<year>//g' -e 's/<\/year>//g' -e 's/\t//g')
		pastaSFilme=$(echo "$caminhoCompleto" | $SED 's/\(.*\)./\1/' | $AWK -F'/' '{for(i=1;i<NF-1;++i)printf $i"/";print $i}'| $SED -e 's/  //g')
		if [[ ! -f "$caminhoCompleto/movie.tbn" ]]; then
			tnbProcessados=1
			echo -e '\E[1;37m\033[1m##############\033[0m'
			echo -e '\E[1;37m\033[1m# Origem:'"$caminhoCompleto/folder.jpg"'\033[0m'
			echo -e '\E[1;37m\033[1m# Destino:'"$caminhoCompleto/movie.tbn"'\033[0m'
			echo -e '\E[1;37m\033[1m##############\033[0m'
			echo ""
			convert "$caminhoCompleto/folder.jpg" "$caminhoCompleto/movie.tbn"
		fi
		if [[ ! -f "$pastaSFilme/$filme ($ano).tbn" ]]; then
			tnbProcessados=1
			echo -e '\E[1;37m\033[1m##############\033[0m'
			echo -e '\E[1;37m\033[1m# Origem:'"$caminhoCompleto/movie.tbn"'\033[0m'
			echo -e '\E[1;37m\033[1m# Destino:'"$pastaSFilme/$filme ($ano).tbn"'\033[0m'
			echo -e '\E[1;37m\033[1m##############\033[0m'
			echo ""			
			cp "$caminhoCompleto/movie.tbn" "$pastaSFilme/$filme ($ano).tbn"
		fi
		done
		else
		echo -e '\E[1;37m\033[1mO ficheiro folder.jpg ou movies.nfo não existem em algumas pastas.\033[0m'
		echo -e '\E[1;37m\033[1mExecute a opção [V] para determinar onde estão ausentes.\033[0m'
	fi
	if [ $tnbProcessados = 0 ]; then
		echo -e '\E[1;37m\033[1mNão foram processados ficheiros TNB.\033[0m'
	fi	
}

function filmesFicheiros () {
	echo -e '\E[1;37m\033[1mProcessando as pastas ...\033[0m'
	caminhoCompleto=$($FIND "$dirDiscos" -mindepth 1 -maxdepth $dirNiveis -type f \
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
						   -iname "*.rmvb" \) | $GREP OsMeusFilmes | $SED -e '/OsMeusFilmesInfantis/ d')
	echo "$caminhoCompleto" | $AWK -F'/' '{if (x[$5]) { x_count[$5]++; print $0; if (x_count[$5] == 1) { print x[$5] } } x[$5] = $0}' | sort -d
#	caminhoProcessado=$(echo "$caminhoCompleto" | $AWK -F'/' '{if (x[$5]) { x_count[$5]++; print $0; if (x_count[$5] == 1) { print x[$5] } } x[$5] = $0}') | sort -d
##
#	for filmeMaisFicheiros in $caminhoProcessado
#	do
#	ficheiroFilme=$(echo $filmeMaisFicheiros | $SED )
#	nomeFicheiro=$(echo $ficheiroFilme | $SED )
#	extencaoFicheiro=$(echo $ficheiroFilme | $SED )
#	termFicheiroFilme=$(echo $ficheiroFilme | $SED )
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
echo "Será gerado o ficheiro $HOME/conteudo.csv"

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
awk -F "\t" '{printf "%s\t%s\t%s\t%s\n", $3,$4,$1,$2}' /tmp/lista_1.txt | awk 'NF > 3' | sort -d > $HOME/conteudo.csv
# Adicionar linha de cabeçalho
sed -i '1i\Categoria\tConteúdo a '$dia' de '$mes' de '$ano' às '$hora'.'$min'\tTamanho\tDisco' $HOME/conteudo.csv
# Remover ficheiros indesejados
rm /tmp/lista_*.txt

}

function filmesRepetidos () {
	echo "Gerando Relatorio de Filmes Repetidos ..."
	echo "Será gerado o ficheiro $HOME/conteudo_repetido.csv"
	awk -F"\t" '{if (x[$2]) { x_count[$2]++; print $0; if (x_count[$2] == 1) { print x[$2] } } x[$2] = $0}' $HOME/conteudo.csv | awk -F "\t" '{printf "%s\t%s\t%s\t%s\n", $2,$1,$3,$4}' | sort -d > $HOME/conteudo_repetido.csv
	cat $HOME/conteudo_repetido.csv
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
	B 'Analiza mymovies.xml'      \
	C 'Analiza disc.png'          \
	D 'Analiza backdrop.jpg'      \
	E 'Analiza fanart.jpg'        \
	F 'Analiza movie.nfo'         \
	G 'Analiza cover.jpg'         \
	H 'Filmes com + de 1 ficheiro'\
	I 'Relatorio Filmes'          \
	J 'Relatorio Filmes Repetidos'\
	V 'Voltar'   )

case $opcao in a|A)
ficheiro=folder.jpg
analizaFicheiro
read -p "Precione qualquer tecla para continuar"
esac
case $opcao in b|B)
ficheiro=mymovies.xml
analizaFicheiro
read -p "Precione qualquer tecla para continuar"
esac
case $opcao in c|C)
ficheiro=disc.png
analizaFicheiro
read -p "Precione qualquer tecla para continuar"
esac
case $opcao in d|D)
ficheiro=backdrop.jpg
analizaFicheiro
read -p "Precione qualquer tecla para continuar"
esac
case $opcao in e|E)
ficheiro=fanart.jpg
analizaFicheiro
read -p "Precione qualquer tecla para continuar"
esac
case $opcao in f|F)
ficheiro=movie.nfo
analizaFicheiro
read -p "Precione qualquer tecla para continuar"
esac
case $opcao in g|G)
ficheiro=cover.jpg
analizaFicheiro
read -p "Precione qualquer tecla para continuar"
esac
case $opcao in h|H)
filmesFicheiros
read -p "Precione qualquer tecla para continuar"
esac
case $opcao in i|I)
filmesCSV
read -p "Precione qualquer tecla para continuar"
esac
case $opcao in j|J)
filmesRepetidos
read -p "Precione qualquer tecla para continuar"
esac
case $opcao in v|V)
let "loop1f=1"
clear
esac

done
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
	T 'Processar ficheiros TNB'           \
	C 'Copia actores para o MediaCenter'  \
	G 'Executa todas as opções'           \
	X 'sshNox (Sala)'                     \
	S 'Sair'   )

case $opcao in a|A)
analizaConteudos
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
nfoArrumar
nfoGerarData
read -p "Precione qualquer tecla para continuar"
esac
case $opcao in t|T)
tbn
read -p "Precione qualquer tecla para continuar"
esac
case $opcao in c|C)
sincronizaActores
read -p "Precione qualquer tecla para continuar"
esac
case $opcao in g|G)
nfoArrumar
nfoGerarData
dirName
backdrop
tbn
read -p "Precione qualquer tecla para continuar"
esac
case $opcao in x|X)
sshNox
read -p "Precione qualquer tecla para continuar"
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
