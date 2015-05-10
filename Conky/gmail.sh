#!/usr/bin/env bash
#------------------------------------------
# j.francisco.o.rocha@gmail.com
# gmail.sh
# 03/2012
#------------------------------------------

wget -q -O - https://mail.google.com/a/domain/feed/atom --http-user=$1 --http-password=$2 --no-check-certificate | grep fullcount | sed 's/<[^0-9]*>//g'
