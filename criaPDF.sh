#!/usr/bin/env bash
# j.francisco.o.rocha@gmail.com
# @11.2014
# http://www.wtfpl.net/showcase/

folders=""

IFS=$'\n'
folders=(`find . -type f | grep jpg | awk -F'/' '{ print $2 }' | uniq`)

for f in $(find . -type f | grep jpg | awk -F'/' '{ print $2 }' | uniq); do
	fBom=` echo $f | sed -e 's/ /_/g' `
	convert "./$f/"*.jpg $fBom.pdf
	echo $fBom.pdf pronto!
done
echo -e "Operação concluida com sucesso."