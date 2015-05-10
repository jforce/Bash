#!/bin/bash
mpg123 -b 10000 -s "$1" | sox -t raw -r 44100 -s -w -c2 - "temp.wav"
oggenc -o "$2" "temp.wav"
rm temp.wav
