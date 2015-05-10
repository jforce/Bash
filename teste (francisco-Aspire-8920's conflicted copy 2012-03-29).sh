#!/usr/bin/env bash
declare IFS=$'\n'

echo "Insere a primeira nota:"
read nota01
echo "Insere a segunda nota:"
read nota02
echo "Insere a terceira nota:"
read nota03
echo "As notas introduzidas foram (apresentação ordenada):"
echo "$nota01\n$nota02\n$nota03" | sort -k1,1n
notas=`expr $nota01 + $nota02 + $nota03`
echo "A média final é:" 
expr $notas / 3
