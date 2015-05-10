#! /bin/bash
#! autor: j.francisco.o.rocha@zoho.com
#! 2015

if [ "$1" == "" ] ; then
	echo "Ajuda: Gerador de codigos EAN 128 em formato PDF (barcode.pdf)"
	echo "Formato: ./barcode [string]"
	exit 0
fi

if [[ ! -e $(which barcode) ]]; then
	[ "$(whoami)" != "root" ] && exec sudo -- "$0" "$@"
	sudo apt-get --yes install barcode
fi

function gerar () {
barcode -o barcode.ps -b $1 -e code128 -t 1x2 -m 100x100
ps2pdf barcode.ps
rm barcode.ps
ls -lai barcode.*
}

gerar $1
