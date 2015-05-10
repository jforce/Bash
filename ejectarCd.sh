#! /bin/bash
#! autor: cfjrocha@gmail.com
#! 2008
clear
echo
echo "Pressione [ENTER] para Abrir a Gaveta ou outra tecla para Cancelar"
read resposta1
R1="$resposta1"
    if [ "$R1" = "" ]; then
        eject
        clear
        echo
        echo "Pressione [ENTER] para Fechar a Gaveta ou outra tecla para Cancelar"
        read resposta2
        R2="$resposta2"
        if [ "$R2" = "" ]; then
            eject -t
            clear
        else
	    exit
        fi
    else
        exit
    fi

