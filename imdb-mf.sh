#!/bin/bash

shopt -s -o nounset
#Global variable declarations
declare -rx MYSITE="http://imdbmoviefetche.sourceforge.net/"
declare -rx MYMAIL="unnikrishnan.a@gmail.com"
declare -rx SCRIPT=${0##*/}
declare -rx VERSION="3.1"
declare URL
declare TITLE
declare YEAR
declare RAT
declare PLOT
declare MOVIE
declare DIR
declare GEN
declare CAST
declare -rx TMPFILE=/tmp/imdbmoviefetcher.$$
declare -rx PLOTFILE=/tmp/plot.$$.html
declare -rx LYNX="/usr/bin/lynx"
declare -rx CAT="/bin/cat"
declare -rx SED="/bin/sed"
declare -rx EGREP="/bin/egrep"
declare -rx GREP="/bin/grep"
declare -rx UNIQ="/usr/bin/uniq"
declare -rx HEAD="/usr/bin/head"
declare SWITCH
declare -r OPTSTRING=":hvt:"
#check the input arguments/ parametrs
if [ $# -eq 0 ];then
printf "%s -h for more information\n" "$SCRIPT"
exit 192
fi
while getopts "$OPTSTRING" SWITCH;do
case "$SWITCH" in
h) cat << EOF
   $SCRIPT [option] [arg]

   Options : 
   -v : gives the version of the script
   -h : shows the help page
   -t [arg] : Pass the movie title as argument. It is recommended to quote the name as shown in the example below 

   Example : 
   $SCRIPT -t "startship troopers"
 
   Send your feedback to $MYMAIL
   Visit: $MYSITE

EOF
   exit 0
   ;;
t) MOVIE="$OPTARG"
   ;;
v) printf "IMDB movie fetcher version %s.\nSend your feedbacks to %s\nVisit: %s\n" "$VERSION" "$MYMAIL" "$MYSITE"
   exit 0
   ;;
\?) printf "%s\n" "Invalid option. use $SCRIPT -h for more information"
    exit 192
    ;;
*) printf "%s\n" "Invalid argument. use $SCRIPT -h for more information"
   exit 192
    ;;
esac
done
[[ -z $MOVIE ]] && { printf "%s -h for more information\n" "$SCRIPT";exit 192;}
#functions
printnofound() {
printf "There is no $1 command. Please install it\n"
}
#Sanity checks
if [ -z "$BASH" ]
then
printf "This script is written for bash. Please run this under bash\n" >&2
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
#sanity check finished
#replace special characters in the movie name argument
MOVIE=`echo $MOVIE | sed -r 's/  */\+/g;s/\&/%26/g;s/\++$//g'`
#search the title in google
$LYNX -connect_timeout=10 --source "http://www.google.com/search?hl=en&q=$MOVIE+imdb" > $TMPFILE 2> /dev/null
#Check if lynx is successful
if [ $? -ne 0 ]
then 
printf "Connection to site failed...Please check your internet connection\n"
exit 192
fi
#Get IMDB URL for the film
URL=`$EGREP -o "http://www.imdb.com/title/tt[0-9]*/" $TMPFILE | $HEAD -1`
#get the details from movie page
$LYNX --source ${URL} > $TMPFILE;
#extract data
YEAR=`$CAT $TMPFILE | $SED -n '/<h1.*>/,/<\/h1>/p' | $SED '1d;$d;/^$/d;s/<[^>]*>//g;s/(//g;s/)//g' | $EGREP -o "[0-9][0-9][0-9][0-9]"`
TITLE=`$CAT $TMPFILE | $SED -n '/<h1.*>/,/<\/h1>/p' | $SED '1d;$d;/^$/d;s/<[^>]*>//g;s/(//g;s/)//g' | $HEAD -1 | $SED "s/\&#x27\;/\'/g"`
$SED -n '/<h1.*>/,/<\/p>/p' $TMPFILE | $SED -n '/<p>/,/<\/p>/{ s/<[^>]*>//g;p;}' | $SED 's/See full summary.*//g' > $PLOTFILE 
PLOT=`lynx --dump $PLOTFILE | sed 's/^  *//g'`
RAT=`$SED -n '/<span class="rating-rating">/{ s/<[^>]*>//g;p;}' $TMPFILE`;
DIR=`$SED -n '/ *Director[s]*:.*/,/ *Writer[s]*:.*/{ /<a *href="\/name\/nm[0-9][0-9]*\/"[^>]*>[^<]*<\/a>.*/p;}' $TMPFILE | $SED  's/<\/a>/<\/a>\n/g' | $SED -n 's/.*<a *href="\/name\/nm[0-9][0-9]*\/"[^>]*>\([^<]*\)<\/a>.*/\1/p;' | tr '\n' ';' | $SED 's/\;*$//g'`
GEN=`$SED -n '/genre/p' $TMPFILE | $EGREP -o '<a  *.*href="/genre/[a-zA-Z][a-z]*"[^>]*>[^<]*</a>' | $SED 's/<[^>]*>//g;s/&nbsp\;//g;s/ *Genres *[0-9][0-9]* *min-//g;s/|/,/g' | $SED 's/[gG]enres//g;s/^  *//g' | $UNIQ | $HEAD -1`
CAST=`$SED -n '/.*Cast overview, first billed only:.*/,/<div class=\"see-more\">/{ s/<[^>]*>//g;s/Cast overview, first billed only://g;p }' $TMPFILE | $SED -n '{/^ *$/d;s/, /\t /g;s/ and /\t /g;p}' | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba' | $SED '/        \.\.\./d;s/                //g;s/          /Papel:/g;s/        /Actor:/g'`
#print everything
texto=$(echo -e "\nTitulo        : $TITLE\n\Ano           : $YEAR\nClassificação : $RAT\nDirectores    : $DIR\nGeneros       : $GEN\nActores       : $CAST\n""Sinopse       : ""$PLOT\n\n""IMDB movie URL : ${URL}\n\n")
function processar () {
	textoLimpo=$(echo $texto | sed -e '{s/&#x27\;/&/g;s/\&#176\;/\°/g;s/&deg\;/\°/g;s/\&#43\;/\+/g;s/\&#177\;/\±/g;s/&plusmn\;/\±/g;s/\&#247\;/\÷/g;s/&divide\;/\÷/g;s/\&#215\;/\×/g;s/&times\;/\×/g;s/\&#60\;/\</g;s/&lt\;/\</g;s/\&#61\;/\=/g;s/\&#62\;/\>/g;s/&gt\;/\>/g;s/\&#172\;/\¬/g;s/&not\;/\¬/g;s/\&#124\;/\|/g;s/\&#166\;/\¦/g;s/&brvbar\;/\¦/g;s/\&#126\;/\~/g;s/\&#164\;/\¤/g;s/&curren\;/\¤/g;s/\&#162\;/\¢/g;s/&cent\;/\¢/g;s/\&#36\;/\$/g;s/\&#163\;/\£/g;s/&pound\;/\£/g;s/\&#165\;/\¥/g;s/&yen\;/\¥/g;s/\&#185\;/\¹/g;s/&sup1\;/\¹/g;s/\&#189\;/\½/g;s/&frac12\;/\½/g;s/\&#188\;/\¼/g;s/&frac14\;/\¼/g;s/\&#178\;/\²/g;s/&sup2\;/\²/g;s/\&#179\;/\³/g;s/&sup3\;/\³/g;s/\&#190\;/\¾/g;s/&frac34\;/\¾/g;s/\&#65\;/\A/g;s/\&#97\;/\a/g;s/\&#170\;/\ª/g;s/&ordf\;/\ª/g;s/\&#193\;/\Á/g;s/\&#225\;/\á/g;s/&Aacute\;/\Á/g;s/&aacute\;/\á/g;s/\&#192\;/\À/g;s/\&#224\;/\à/g;s/&Agrave\;/\À/g;s/&agrave\;/\à/g;s/\&#194\;/\Â/g;s/\&#226\;/\â/g;s/&Acirc\;/\Â/g;s/&acirc\;/\â/g;s/\&#197\;/\Å/g;s/\&#229\;/\å/g;s/&Aring\;/\Å/g;s/&aring\;/\å/g;s/\&#196\;/\Ä/g;s/\&#228\;/\ä/g;s/&Auml\;/\Ä/g;s/&auml\;/\ä/g;s/\&#195\;/\Ã/g;s/\&#227\;/\ã/g;s/&Atilde\;/\Ã/g;s/&atilde\;/\ã/g;s/\&#198\;/\Æ/g;s/\&#230\;/\æ/g;s/&AElig\;/\Æ/g;s/&aelig\;/\æ/g;s/\&#66\;/\B/g;s/\&#98\;/\b/g;s/\&#67\;/\C/g;s/\&#99\;/\c/g;s/\&#199\;/\Ç/g;s/\&#231\;/\ç/g;s/&Ccedil\;/\Ç/g;s/&ccedil\;/\ç/g;s/\&#68\;/\D/g;s/\&#100\;/\d/g;s/\&#208\;/\Ð/g;s/\&#240\;/\ð/g;s/&ETH\;/\Ð/g;s/&eth\;/\ð/g;s/\&#69\;/\E/g;s/\&#101\;/\e/g;s/\&#201\;/\É/g;s/\&#233\;/\é/g;s/&Eacute\;/\É/g;s/&eacute\;/\é/g;s/\&#200\;/\È/g;s/\&#232\;/\è/g;s/&Egrave\;/\È/g;s/&egrave\;/\è/g;s/\&#202\;/\Ê/g;s/\&#234\;/\ê/g;s/&Ecirc\;/\Ê/g;s/&ecirc\;/\ê/g;s/\&#203\;/\Ë/g;s/\&#235\;/\ë/g;s/&Euml\;/\Ë/g;s/&euml\;/\ë/g;s/\&#70\;/\F/g;s/\&#102\;/\f/g;s/\&#71\;/\G/g;s/\&#103\;/\g/g;s/\&#72\;/\H/g;s/\&#104\;/\h/g;s/\&#73\;/\I/g;s/\&#105\;/\i/g;s/\&#205\;/\Í/g;s/\&#237\;/\í/g;s/&Iacute\;/\Í/g;s/&iacute\;/\í/g;s/\&#204\;/\Ì/g;s/\&#236\;/\ì/g;s/&Igrave\;/\Ì/g;s/&igrave\;/\ì/g;s/\&#206\;/\Î/g;s/\&#238\;/\î/g;s/&Icirc\;/\Î/g;s/&icirc\;/\î/g;s/\&#207\;/\Ï/g;s/\&#239\;/\ï/g;s/&Iuml\;/\Ï/g;s/&iuml\;/\ï/g;s/\&#74\;/\J/g;s/\&#106\;/\j/g;s/\&#75\;/\K/g;s/\&#107\;/\k/g;s/\&#76\;/\L/g;s/\&#108\;/\l/g;s/\&#77\;/\M/g;s/\&#109\;/\m/g;s/\&#78\;/\N/g;s/\&#110\;/\n/g;s/\&#209\;/\Ñ/g;s/\&#241\;/\ñ/g;s/&Ntilde\;/\Ñ/g;s/&ntilde\;/\ñ/g;s/\&#79\;/\O/g;s/\&#111\;/\o/g;s/\&#186\;/\º/g;s/&ordm\;/\º/g;s/\&#211\;/\Ó/g;s/\&#243\;/\ó/g;s/&Oacute\;/\Ó/g;s/&oacute\;/\ó/g;s/\&#210\;/\Ò/g;s/\&#242\;/\ò/g;s/&Ograve\;/\Ò/g;s/&ograve\;/\ò/g;s/\&#212\;/\Ô/g;s/\&#244\;/\ô/g;s/&Ocirc\;/\Ô/g;s/&ocirc\;/\ô/g;s/\&#214\;/\Ö/g;s/\&#246\;/\ö/g;s/&Ouml\;/\Ö/g;s/&ouml\;/\ö/g;s/\&#213\;/\Õ/g;s/\&#245\;/\õ/g;s/&Otilde\;/\Õ/g;s/&otilde\;/\õ/g;s/\&#216\;/\Ø/g;s/\&#248\;/\ø/g;s/&Oslash\;/\Ø/g;s/&oslash\;/\ø/g;s/\&#80\;/\P/g;s/\&#112\;/\p/g;s/\&#81\;/\Q/g;s/\&#113\;/\q/g;s/\&#82\;/\R/g;s/\&#114\;/\r/g;s/\&#83\;/\S/g;s/\&#115\;/\s/g;s/\&#223\;/\ß/g;s/&szlig\;/\ß/g;s/\&#84\;/\T/g;s/\&#116\;/\t/g;s/\&#85\;/\U/g;s/\&#117\;/\u/g;s/\&#218\;/\Ú/g;s/\&#250\;/\ú/g;s/&Uacute\;/\Ú/g;s/&uacute\;/\ú/g;s/\&#48\;/0/g;s/\&#49\;/1/g;s/\&#50\;/2/g;s/\&#51\;/3/g;s/\&#52\;/4/g;s/\&#53\;/5/g;s/\&#54\;/6/g;s/\&#55\;/7/g;s/\&#56\;/8/g;s/\&#57\;/9/g;s/\&#32\;/\ /g;s/#96\;/\`/g;s/\&#180\;/\´/g;s/&acute\;/\´/g;s/\&#94\;/\^/g;s/\&#175\;/\¯/g;s/&macr\;/\¯/g;s/\&#168\;/\¨/g;s/&uml\;/\¨/g;s/\&#184\;/\¸/g;s/&cedil\;/\¸/g;s/\&#95\;/\_/g;s/\&#173\;//g;s/&shy\;//g;s/\&#45\;/\-/g;s/\&#44\;/\,/g;s/\&#59\;/\\;/g;s/\&#58\;/\:/g;s/\&#33\;/\!/g;s/\&#161\;/\¡/g;s/&iexcl\;/\¡/g;s/\&#63\;/\?/g;s/\&#191\;/\¿/g;s/&iquest\;/\¿/g;s/\&#46\;/\./g;s/\&#183\;/\·/g;s/&middot\;/\·/g;s/\&#171\;/\«/g;s/&laquo\;/\«/g;s/\&#187\;/\»/g;s/&raquo\;/\»/g;s/\&#40\;/\(/g;s/\&#41\;/\)/g;s/\&#91\;/\[/g;s/\&#93\;/\]/g;s/\&#123\;/\{/g;s/\&#125\;/\}/g;s/\&#167\;/\§/g;s/&sect\;/\§/g;s/\&#182\;/\¶/g;s/&para\;/\¶/g;s/\&#169\;/\©/g;s/&copy\;/\©/g;s/\&#174\;/\®/g;s/&reg\;/\®/g;s/\&#64\;/\@/g;s/\&#42\;/\*/g;s/\&#47\;/\//g;s/\&#92\;/\\/g;s/\&#38\;/\&/g;s/&amp\;/\&/g;s/\&#35\;/\#/g;s/\&#37\;/\%/g;s/\&#217\;/\Ù/g;s/\&#249\;/\ù/g;s/&Ugrave\;/\Ù/g;s/&ugrave\;/\ù/g;s/\&#219\;/\Û/g;s/\&#251\;/\û/g;s/&Ucirc\;/\Û/g;s/&ucirc\;/\û/g;s/\&#220\;/\Ü/g;s/\&#252\;/\ü/g;s/&Uuml\;/\Ü/g;s/&uuml\;/\ü/g;s/\&#86\;/\V/g;s/\&#118\;/\v/g;s/\&#87\;/\W/g;s/\&#119\;/\w/g;s/\&#88\;/\X/g;s/\&#120\;/\x/g;s/\&#89\;/\Y/g;s/\&#121\;/\y/g;s/\&#221\;/\Ý/g;s/\&#253\;/\ý/g;s/&Yacute\;/\Ý/g;s/&yacute\;/\ý/g;s/\&#255\;/\ÿ/g;s/&yuml\;/\ÿ/g;s/\&#90\;/\Z/g;s/\&#122\;/\z/g;s/\&#222\;/\Þ/g;s/\&#254\;/\þ/g;s/&THORN\;/\Þ/g;s/&thorn\;/\þ/g;s/\&#181\;/\µ/g;s/&micro\;/\µ/g;s/\&#160\;//g;s/&nbsp\;//g}')
	}

processar

echo -e $textoLimpo

#printf "\nTitulo        : $TITLE\n"
#printf "Ano           : $YEAR\n"
#printf "Classificação : $RAT\n"
#printf "Directores    : $DIR\n"
#printf "Generos       : $GEN\n"
#printf "Actores       : $CAST\n"
#printf "Sinopse       :\n\n%s\n\n" "$PLOT"
#printf "IMDB movie URL : ${URL}\n\n"
rm $TMPFILE > /dev/null
rm $PLOTFILE > /dev/null
exit 0
