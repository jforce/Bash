#!/bin/sh

# spkweather.sh
# Written by:
# Brandt Daniels
# December 2010

LAT=41.236944
LON=-8.604722

# RAW=$(curl -s "http://forecast.weather.gov/MapClick.php?site=SGX&lat=$LAT&lon=$LON&TextType=1")
RAW=$(curl -s "http://weather.yahooapis.com/forecastrss?w=743017&u=c")
echo "$RAW" | grep "yweather:" | sed -e 's/<yweather://g;s/\/>//g'
# sed 's/\(.*\)<\/b>\(.*\).*/\1\2/;s/.*<.*//g;/^$/d'
# | head -$1


