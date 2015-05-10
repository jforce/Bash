#!/bin/bash
echo "fakap mp3-to-flv converter http://blog.fakap.net/mp3toflv/"
echo "Copyright (c) mypapit 2007"
echo ""
if (($# ==0))
then
	echo "Usage: flvto3gp [flv files] ..."
	exit
fi

while (($# !=0 ))
do 
        ffmpeg -i $1 -vcodec h263 $1.3gp
	shift
done
echo "Finished fakaping with flv-to-3gp converter"
echo "\"fakap all those nonsense!\""
echo ""

