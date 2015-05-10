#!/bin/bash
#
livre=` df -P "." | tail -1 | awk '{print $4}' `

echo "Livre= $livre"
#if [ $livre -le 1000 ]; then
if [ $livre -ge 1000 ]; then
	echo "mais que 1000"
	ls -rt1 "$destinoMusica"/*.m4a | head -4
# | xargs rm
fi

