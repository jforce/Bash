#!/bin/bash
echo "mp4-to-3gp converter"
echo "Copyright (c) 2007"
echo ""
if (($# ==0))
then
	echo "Usage: mp4to3gp [mp4 files] ..."
	exit
fi

while (($# !=0 ))
do 
		ffmpeg -i $1 -s 240×320 -vcodec h263 -r 25 -b 200 -ab 64 -acodec mp3  -ac 1 -ar 8000 $1.3gp
	shift
done
echo "Finished with mp4-to-3gp converter"
echo ""

