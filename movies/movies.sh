#!/bin/bash
#########################
folder="/mnt/filmer/" 	# The folder you want the script to parse trough (will -not- work recursive)
html_folder="html/"	# The folder where you want the output. (default html/) use a trailing /
die="yes"		# Set this to "no" to make the script run.
#########################


# do not edit anything below this line unless you *know* what you are doing.
function imdb_found() {
GENRE=""
grep "/Sections/Genres/" index.html|grep \| |grep Horror 1>/dev/null 2>/dev/null
if [ "$?" = "0" ]; then
GENRE="Horror"
else
wait
fi
grep "/Sections/Genres/" index.html|grep \| |grep Action 1>/dev/null 2>/dev/null 
if [ "$?" = "0" ]; then
GENRE="$GENRE Action"
else
wait
fi
grep "/Sections/Genres/" index.html|grep \| |grep Drama 1> /dev/null 2>/dev/null
if [ "$?" = "0" ];then
GENRE="$GENRE Drama"
else
wait
fi
grep "/Sections/Genres/" index.html|grep \| |grep Adventure 1> /dev/null 2>/dev/null
if [ "$?" = "0" ];then
GENRE="$GENRE Adventure"
else
wait
fi
grep "/Sections/Genres/" index.html|grep \| |grep Thriller 1>/dev/null 2>/dev/null
if [ "$?" = "0" ]; then
GENRE="$GENRE Thriller"
else
wait
fi
grep "/Sections/Genres/" index.html|grep \| |grep Mystery 1>/dev/null 2>/dev/null
if [ "$?" = "0" ]; then
GENRE="$GENRE Mystery"
else
wait
fi
grep "/Sections/Genres/" index.html|grep \| |grep Comedy 1>/dev/null 2>/dev/null
if [ "$?" = "0" ]; then
GENRE="$GENRE Comedy"
else
wait
fi
grep "/Sections/Genres/" index.html|grep \| |grep Crime 1>/dev/null 2>/dev/null
if [ "$?" = "0" ]; then
GENRE="$GENRE Crime"
else
wait
fi
grep "/Sections/Genres/" index.html|grep \| |grep Documentary 1>/dev/null 2>/dev/null
if [ "$?" = "0" ]; then
GENRE="$GENRE Documentary"
else
wait
fi
grep "/Sections/Genres/" index.html|grep \| |grep Fantasy 1>/dev/null 2>/dev/null
if [ "$?" = "0" ]; then
GENRE="$GENRE Fantasy"
else
wait
fi
grep "/Sections/Genres/" index.html|grep \| |grep Animation 1>/dev/null 2>/dev/null
if [ "$?" = "0" ]; then
GENRE="$GENRE Animation"
else
wait
fi
grep "/Sections/Genres/" index.html|grep \| |grep Biography 1>/dev/null 2>/dev/null
if [ "$?" = "0" ]; then
GENRE="$GENRE Biography"
else
wait
fi
grep "/Sections/Genres/" index.html|grep \| |grep Family 1>/dev/null 2>/dev/null
if [ "$?" = "0" ]; then
GENRE="$GENRE Family"
else
wait
fi
grep "/Sections/Genres/" index.html|grep \| |grep Film-Noir 1>/dev/null 2>/dev/null
if [ "$?" = "0" ]; then
GENRE="$GENRE Family"
else
wait
fi
grep "/Sections/Genres/" index.html|grep \| |grep History 1>/dev/null 2>/dev/null
if [ "$?" = "0" ];then
GENRE="$GENRE History" 
else
wait
fi
grep "/Sections/Genres/" index.html|grep \| |grep Independent 1>/dev/null 2>/dev/null
if [ "$?" = "0" ]; then
GENRE="$GENRE Independent"
else
wait
fi
grep "/Sections/Genres/" index.html|grep \| |grep Music 1>/dev/null 2>/dev/null
if [ "$?" = "0" ]; then
GENRE="$GENRE Music"
else
wait
fi
grep "/Sections/Genres/" index.html|grep \| |grep Musical 1>/dev/null 2>/dev/null
if [ "$?" = "0" ]; then
GENRE="$GENRE Musical"
else
wait
fi
grep "/Sections/Genres/" index.html|grep \| |grep Romance 1>/dev/null 2>/dev/null
if [ "$?" = "0" ]; then
GENRE="$GENRE Romance"
else
wait
fi
grep "/Sections/Genres/" index.html|grep \| |grep Short 1>/dev/null 2>/dev/null
if [ "$?" = "0" ]; then
GENRE="$GENRE Short" 
else
wait
fi
grep "/Sections/Genres/" index.html|grep \| |grep Sport 1>/dev/null 2>/dev/null
if [ "$?" = "0" ]; then
GENRE="$GENRE Sport"
else
wait
fi
grep "/Sections/Genres/" index.html|grep \| |grep War 1>/dev/null 2>/dev/null
if [ "$?" = "0" ]; then
GENRE="$GENRE War"
else
wait
fi
grep "/Sections/Genres/" index.html|grep \| |grep mini-series 1>/dev/null 2>/dev/null
if [ "$?" = "0" ]; then
GENRE="$GENRE Mini-series"
else
wait
fi
grep "/Sections/Genres/" index.html|grep \| |grep Western 1>/dev/null 2>/dev/null
if [ "$?" = "0" ]; then
GENRE="$GENRE War"
else
wait
fi
URL="www.imdb.com"
cat index.html |grep "<b>" |grep 10 |awk '{print $1}' |sed "s,<b>,,g" |sed "s,<\/b>,,g" |sed "s,<span,,g" |sed "s,<div,,g" |grep \/10 > tmplol
rating=`cat tmplol |grep \/10`
rm tmplol 2>/dev/null
URL=`cat index.html |grep canonical  | awk -F = '{print $3}' |sed -e "s,/>,,g" |sed -e s,\",,g`
imdb_id="`echo $URL |awk -F \/ '{print $5}'`"
imdb_name="`cat index.html |grep "<title>" |awk -F "<title>" '{print $2}' |awk -F "</title>" '{print $1}'`"
plot_outline="`cat index.html |grep "Plot" |grep "content" |awk -F \= '{print $3}' |awk -F "Visit IMDb" '{print $1}' | cut -c 2-9999`"
poster="`cat index.html |grep $imdb_id |grep media |grep poster |awk -F \"src=\\"\" '{print $2}' |rev |awk -F \\" '{print $2}' |rev`"
posterget="`echo $i |sed "s/ /_/g"`"
posterget="`echo $posterget.jpg`"
wget -q  -O $html_folder$posterget $poster 2>/dev/null 1>/dev/null

if [ -e "html/$posterget" ]; then
wait
else
posterget="notfound.png height=140 width=99"
fi
rm .wat 1>/dev/null 2>/dev/null
pattern="`echo \"$folder$i\"`"
if [ "`ls "$pattern" |awk -F . '{print $NF}' |grep avi 2>/dev/null`" = "avi" ]; then
form="`ls "$pattern" |grep avi`"
elif [ "`ls "$pattern" |awk -F . '{print $NF}' |grep mkv 2>/dev/null`" = "mkv" ]; then
form="`ls "$pattern" |grep mkv`"
elif [ "`ls "$pattern" |awk -F . '{print $NF}' |grep iso 2>/dev/null`" = "iso" ]; then
form="`ls "$pattern" |grep iso`"
elif [ "`ls "$pattern" |awk -F . '{print $NF}' |grep mpeg 2>/dev/null`" = "mpeg" ]; then
form="`ls "$pattern" |grep mpeg`"
elif [ "`ls "$pattern" |awk -F . '{print $NF}' |grep mp4 2>/dev/null`" = "mp4" ]; then
form="`ls "$pattern" |grep mp4`"
elif [ "`ls "$pattern" |awk -F . '{print $NF}' |grep asf 2>/dev/null`" = "asf" ]; then
form="`ls "$pattern" |grep asf`"
elif [ "`ls "$pattern" |awk -F . '{print $NF}' |grep vob 2>/dev/null`" = "vob" ]; then
form="`ls "$pattern" |grep vob`"
else
wat="y"
fi

if [ "$wat" = "y" ]; then
wait
else

ffmpeg -i "$folder$i/$form" 1>.wat 2> .wat
duration="`cat .wat |awk -F Duration: '{print $2}' |awk -F , '{print $1}' | grep :`"
video_file="`cat .wat |grep Input | rev | awk -F / '{print $1}' |rev |awk -F "':" '{print $1}'`"
bitrate="`cat .wat |grep bitrate |awk -F bitrate: '{print $2}'`"
h="`cat .wat |grep Video |awk -F x '{print $1}' |rev | awk -F " " '{print $1}' |rev`"
w="`cat .wat |grep Video |awk -F x '{print $2}' | awk -F " " '{print $1}'`"
film_info="Movie: $i\nDuration: $duration\nVideo file: <a href="\"$pattern/$video_file\"">$video_file</a>\nBitrate: $bitrate\nResolution: $h x $w"
rm .wat 1>/dev/null 2>/dev/null
fi

if [ "$wat" = "y" ]; then
echo "
    <div class="release"> 
      <img class="cover" src="$posterget" alt="$URL" /> 
      Movie:<a href="$URL">$imdb_name</a> <br /> 
      Release: $i <br /> 
      <br /> 
      Rating: $rating <br /> 
      Genre: $GENRE <br /> 
      Plot: $plot_outline <br /> 
      <br /> 
      Path: $folder$i <br /> 
      <br /> 
    </div> " >> "$html_folder"index.html
else
echo -e "
    <div class="release"> 
      <img class="cover" src="$posterget" alt="$URL" /> 
      Movie:<a href="$URL">$imdb_name</a> <br /> 
      Release: $i <br /> 
      <br /> 
      Rating: $rating <br /> 
      Genre: $GENRE <br /> 
      Plot: $plot_outline <br /> 
      <br /> 
      Path: $folder$i <br /> 
      <br /><pre>$film_info</pre> </div> " >> "$html_folder"index.html
fi



rm index*
# terminate the variables, preventing them to reflect on the next result.
GENRE=""
posterget=""
URL=""
imdb_id=""
plot_outline=""
rating=""
poster=""
}

function imdb_notfound() {
rm search* 2>/dev/null
echo -e "
    <div class="release"> 
      <img class="cover" heigt="140" width="99" src="notfound.png" alt="http://www.imdb.com" /> 
      Movie:N/A - No matches found.</a> <br /> 
      Release: $i <br /> 
      <br /> 
      Path: $folder$i <br /> 
      <br /> 
    </div>"  >> "$html_folder"index.html
}

function imdb_check() {
nfo_check=""
i="`echo \"$i\" |sed -e \"s/_/ /g\"`"
of="`cat .fm.tmp |wc -l`"
echo -n "-> (`cat .calc`/$of): "
plus="`cat .calc` + 1"
if="`echo $plus |bc`"
echo $if > .calc
pattern="`echo $folder$i`"
nfo_check="`ls \"$pattern\"/*.nfo  2>/dev/null`"

#ugly hack to get the imdb ID, instead of the whole url, due to the caracter encoding used in nfos.
imdb_nfo="`egrep "(*/title/tt[0-9]*|Title[0-9]*)" \"$pattern\"/*.nfo 2>/dev/null | awk -F "http://" '{print $2}' | awk -F " " '{print $1}' | sed -e \"s/\r$//\" | sed -e \"s/\r$//\" 2>/dev/null `"
echo $imdb_nfo > .dos2unix
dos2unix .dos2unix

case `cat .dos2unix |grep imdb` in
        *imdb*)
wget `cat .dos2unix |grep imdb` --user-agent="Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6" 2>> .log 1>> /dev/null
rm .dos2unix
imdb_nfo="" #terminate variable
	;;
        *)
wget "http://www.google.com/search?ie=UTF-8&oe=UTF-8&sourceid=navclient&gfns=1&q=imdb+\"$i\"&btnI=745"  --user-agent="Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6" 2>> .log 1>> /dev/null
	;;
esac
cat index.html 1>/dev/null 2>/dev/null
wat="`echo $?`"
case $wat in
	'0')
imdb_name="`cat index.html |grep "<title>" |awk -F "<title>" '{print $2}' |awk -F "</title>" '{print $1}'`"
echo -e "\033[1;32m Found\033[0m - $imdb_name - $i."
if [ -e "\"$html_folder\"index.html" ]; then
wait
else
#
wait
fi
imdb_found
	;;

        *)

echo -e "\033[1;31m Not found\033[0m - $i."
if [ -e "\"$html_folder\"index.html" ]; then
wait
else
#
wait
fi
imdb_notfound
	;;

esac
}


if [ -e "`which wget`" ]; then
wait
else
echo "wget not present on system. add wget to \$PATH before you continue"
exit 2
fi
if [ -e "`which dos2unix`" ]; then
wait
else
echo "dos2unix is not in your \$PATH -please install dos2unix before you run this script"
exit 2
fi
if [ ! -d "$html_folder" ]; then
echo "Directory $html_folder - which you specified doesnt exist. Please ensure you typed it correctly and create the directory."
exit 2
fi
if [ -e "`which ffmpeg`" ]; then
echo "ffmpeg is not in your \$PATH - please install it before you run this script"
exit 2
else
wait
fi

if [ "$die" = "no" ]; then
wait
else
echo "Please configure the script before you run it."
exit 2
fi

ls "$folder" | sed -e "s/ /_/g"  > .fm.tmp 
echo "--> IMDb/bash movie collection by langvann@EFnet. "
echo "--> Scanning $folder for potential matches on IMDb.com -->"
#cleaning up the mess from last run, leaving notfound.png intact.
rm -rf html/*.jpg 1>/dev/null 2>/dev/null 
rm -rf html/*.html 1>/dev/null 2>/dev/null 
echo "1"> .calc
cat etc/css 1> "$html_folder"index.html
cp etc/css "$html_folder"
for i in `cat .fm.tmp`; do imdb_check ; done 
echo "--> All results have been added to "$html_folder"index.html"
echo -n "--> finishing up - "
space_used="`df -h $folder |grep \`echo $folder |rev | cut -c 2-9999 |rev\` |awk '{print $3}'`"
total_entries="`ls -l $folder |wc -l`"
echo "<br><br><br>" >> "$folder_html"index.html
echo "Total space used: $space_used<br>" >> "$folder_html"index.html
echo "Total entries in $folder: $total_entries<br><br>" >> "$folder_html"index.html
echo "<center>IMDb/bash Movie Collection script by langvann@EFnet</font></center>" >> "$folder_html"index.html
echo -n "entries - "
#clean up any residual files.
rm index* 1>/dev/null 2>/dev/null
rm search* 1>/dev/null 2>/dev/null
rm .calc 1>/dev/null 2>/dev/null
rm .fm.tmp 1>/dev/null 2>/dev/null
rm .lol 1>/dev/null 2>/dev/null
rm .wat 1>/dev/null 2>/dev/null
rm $(ls $PWD | grep -v '^README' | grep -v '^movies.sh' | grep -v '^html' | grep -v '^etc') # delete any mismatches the googlesearch did.
echo " temprarily files "
echo "--> Done!:)"
echo "IMDb/bash Movie Collection script by langvann@EFnet"
exit 0
# Thank you! come again.
