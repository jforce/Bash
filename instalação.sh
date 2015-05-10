#!/usr/bin/env bash
#! autor: cfjrocha@gmail.com
#! instalação.sh
#! 10/2008

function xerox {
clear
rede=$(                                   \
 dialog                                   \
    --title 'Instalação de Impressora'    \
    --stdout                              \
    --inputbox 'Indique a rede:'          \
    0 0                                   \
      )
echo "A rede indicada foi: $rede"

}


let "loop1=0"
while test $loop1 == 0
do
opcao=$( dialog                          \
	--stdout                         \
	--menu 'MENU'                    \
	0 0 0                            \
	I 'Instalar impressoras Xerox'   \
	O 'Opção O'                      \
	T 'Executa todas as opções'      \
	S 'Sair'   )


case $opcao in i|I)
xerox
read -p "Precione alguma tecla para continuar"
esac
case $opcao in o|O)
echo 'Opção O'
read -p "Precione alguma tecla para continuar"
esac
case $opcao in t|T)
echo 'Opção T'
read -p "Precione alguma tecla para continuar"
esac
case $opcao in s|S)
let "loop1=1"
clear
esac
done





