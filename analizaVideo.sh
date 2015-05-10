#!/usr/bin/env bash
declare IFS=$'\n'
caminhoCompleto="/media/DISC*"

for fileFILME in $( find -L $caminhoCompleto -mindepth 1 -maxdepth 3 -type f \
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
	xbmcVideoCodec=( $(ffmpeg -i "$fileFILME" 2>&1 | grep Video: | sed -e 's/  / /g' | awk -F' ' '{print $4}' | sed -e 's/,//g') )
#	xbmcVideoWidth=( $(ffmpeg -i "$fileFILME" 2>&1 | grep Video: | sed -e 's/  / /g' | awk -F', ' '{print $3}' | sed -e 's/ //g;s/\[.*//g'| awk -F'x' '{print $1}') )
#	xbmcVideoHeight=( $(ffmpeg -i "$fileFILME" 2>&1 | grep Video: | sed -e 's/  / /g' | awk -F', ' '{print $3}' | sed -e 's/ //g;s/\[.*//g'| awk -F'x' '{print $2}') )
#	xbmcVideoAspect=$(echo scale=6\; $xbmcVideoWidth '/' $xbmcVideoHeight | bc)
#	xbmcVideoDuration=( $(ffmpeg -i "$fileFILME" 2>&1 | sed -n "s/.* Duration: \([^,]*\), start: .*/\1/p" | awk -F':' '{ print $1*3600 + $2*60 + $3 }' | awk -F'.' '{print $1}'))
#	xbmcAudioCodec=( $(ffmpeg -i "$fileFILME" 2>&1 | grep Audio: | sed -e 's/  / /g' | awk -F' ' '{print $4}' | sed -e 's/,//g') )
#	xbmcAudioChannels=( $(ffmpeg -i "$fileFILME" 2>&1 | grep Audio: | sed -e 's/  / /g' | awk -F' ' '{print $7}' | sed -e 's/,//g' | sed -e 's/mono/1/g' | sed -e 's/stereo/2/g' | sed -e 's/5\.1/6/g' | sed -e 's/7\.1/8/g') )
	filesize=` du -h "$fileFILME" | awk -F'\t' '{ print $1 }'`

if  [[ "$xbmcVideoCodec" != "h264" ]]; then
	echo -e "$fileFILME;$xbmcVideoCodec;$filesize"
fi

#echo -e "$fileFILME;$xbmcAudioCodec;$xbmcAudioChannels"
done
