#!/bin/sh
#
# CALCULA O TAMAHO DAS PASTAS
# ./tamanho.sh

IFS="
"
for i in `find -maxdepth 1 -type d | sed "s/.//" | sed "s/\///"`
do
du -sh "$i"
sleep 5
done
exit 0
