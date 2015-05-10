#!/usr/bin/env bash
# autor: j.francisco.o.rocha@gmail.com
# 2010

function ecran () {
	clear
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	}


function f_recolha {
	if (-z $n) then
		n=0
		f_recolhaq
		else
		f_recolhaq
	fi
	}

function f_recolhaq {
	clear
	f_familia
	f_marca
	f_modelo
	f_nserie
	let "looprq=0"
	while test $looprq == 0
	do
	opcaorq=
	while [ -z $opcaorq ]
	do
	clear
	echo "|Juntar N. Serie?   |"
	echo "|              (S/N)|"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                  M|" && read -e -n 1 opcaorq
	done
	case $opcaorq in s|S)
	f_nserie
	linhas[$n]="$familia $marca Modelo: $modelo Nº Serie: $nserie,"
	n=$[n+1]
	esac
	case $opcaorq in n|N)
	linhas[$n]="$familia $marca Modelo: $modelo Nº Serie: $nserie,"
	n=$[n+1]
	f_recolhan
	let "looprq=1"
	esac
#	case $opcaorq in m|M)
#	opcaorq=
#	f_menu
#	let "looprq=1"
#	esac
	done
	}

function f_recolhan {
	let "looprn=0"
	while test $looprn == 0
	do
	opcaorn=
	while [ -z $opcaorn ]
	do
	clear
	echo "|Juntar + artigos?  |"
	echo "|              (S/N)|"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                  M|" && read -e -n 1 opcaorn
	done
	case $opcaorn in s|S)
	f_recolha
	esac
	case $opcaorn in n|N)
	let "looprn=1"
	esac
	case $opcaorn in m|M)
	opcaorn=
	f_menu
	let "looprn=1"
	esac
	done
	}

function f_enviardados {
	echo -e "- P.I.: $pi\n- Região: $regiao\n- Local: $local\n- Forma de Envio: $transporte\n- Artigos:\n ${linhas[*]}" | sed 's/,/\n/g ' | sed 's/.*/\L&/; s/[a-z]*/\u&/g' | mutt -s "[P.I.#$pi] - $assunto de $local" suporte.tic@radiopopular.pt
	#clear
	#echo -e "[P.I.#$pi] - $assunto de $loja, suporte.tic@radiopopular.pt,- P.I.: $pi\n- Região: $regiao\n- Loja: $loja\n- Forma de Envio: $transporte\n- Artigos:\n ${linhas[*]}" | sed 's/,/\n/g ' | sed 's/.*/\L&/; s/[a-z]*/\u&/g'
	#read -p "Precione alguma tecla para continuar"
	}

function f_pi {
	pi=
	while [ -z $pi ]
	do
	clear
	echo "|N. P.I.?           |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                  M|" && read -e -n 9 pi
	done
	if [ "$pi" = "M"  -o "$pi" = "m" ]
		then
		pi=
		f_menu
		else
		echo ""
	fi
	}

function f_nserie {
	nserie=
	while [ -z $nserie ]
	do
	clear
	echo "|N. Serie?          |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                  M|" && read -e -n 128 nserie
	done
#	if [ "$nserie" = "M" -o "$nserie" = "m" ]
#		then
#		nserie=
#		f_menu
#		else
#		echo ""
#	fi
	}

function f_familia {
	let "loopf=0"
	while test $loopf == 0
	do
	clear
	opcaof=
	echo "|Familia?           |"
	echo "|01] IMPRESSORA     |"
	echo "|02] DISCO DURO     |"
	echo "|03] MONITOR        |"
	echo "|04] PC             |"
	echo "|05] TERMINAL       |"
	echo "|06] RATO           |"
	echo "|07] TECLADO        |"
	echo "|08] MEMORIA        |"
	echo "|09] CPU            |"
	echo "|10] CDROM/DVD      |"
	echo "|11] PDT            |"
	echo "|12] FAX            |"
	echo "|13] SCANNER        |"
	echo "|14] OUTRO         M|" && read -e -n 2 opcaof
	case $opcaof in 01)
	familia='Impressora'
	let "loopf=1"
	esac
	case $opcaof in 02)
	familia="Disco Duro"
	let "loopf=1"
	esac
	case $opcaof in 03)
	familia="Monitor"
	let "loopf=1"
	esac
	case $opcaof in 04)
	familia="PC"
	let "loopf=1"
	esac
	case $opcaof in 05)
	familia="Terminal"
	let "loopf=1"
	esac
	case $opcaof in 06)
	familia="Rato"
	let "loopf=1"
	esac
	case $opcaof in 07)
	familia="Teclado"
	let "loopf=1"
	esac
	case $opcaof in 08)
	familia="Memoria"
	let "loopf=1"
	esac
	case $opcaof in 09)
	familia="Cpu"
	let "loopf=1"
	esac
	case $opcaof in 10)
	familia="Cdrom / DVD"
	let "loopf=1"
	esac
	case $opcaof in 11)
	familia="PDT"
	let "loopf=1"
	esac
	case $opcaof in 12)
	familia="Fax"
	let "loopf=1"
	esac
	case $opcaof in 13)
	familia="Scanner"
	let "loopf=1"
	esac
	case $opcaof in 14)
	familia=
		while [ -z $familia ]
			do
			clear
			echo "|Familia?           |"
			echo "|                   |"
			echo "|                   |"
			echo "|                   |"
			echo "|                   |"
			echo "|                   |"
			echo "|                   |"
			echo "|                   |"
			echo "|                   |"
			echo "|                   |"
			echo "|                   |"
			echo "|                   |"
			echo "|                   |"
			echo "|                   |"
			echo "|                   |" && read -e -n 128 familia
			let "loopf=1"
		done
	esac
	case $opcaof in m|M)
	familia=
	f_menu
	esac
	done
	}

function f_marca {
	let "loopm=0"
	while test $loopm == 0
	do
	clear
	opcaom=
	echo "|Marca?             |"
	echo "|01] ASUS           |"
	echo "|02] COMPAQ         |"
	echo "|03] EPSON          |"
	echo "|04] HP             |"
	echo "|05] LEXMARK        |"
	echo "|06] LG             |"
	echo "|07] MAXTOR         |"
	echo "|08] SAMTRON        |"
	echo "|09] SEAGATE        |"
	echo "|10] SONY           |"
	echo "|11] TOSHIBA        |"
	echo "|12] ELTRON         |"
	echo "|13] SAMSUNG        |"
	echo "|14] OUTRA         M|" && read -e -n 2 opcaom
	case $opcaom in 01)
	marca='Asus'
	let "loopm=1"
	esac
	case $opcaom in 02)
	marca="Compaq"
	let "loopm=1"
	esac
	case $opcaom in 03)
	marca="Epson"
	let "loopm=1"
	esac
	case $opcaom in 04)
	marca="HP"
	let "loopm=1"
	esac
	case $opcaom in 05)
	marca="Lexmark"
	let "loopm=1"
	esac
	case $opcaom in 06)
	marca="LG"
	let "loopm=1"
	esac
	case $opcaom in 07)
	marca="Maxtor"
	let "loopm=1"
	esac
	case $opcaom in 08)
	marca="Samtron"
	let "loopm=1"
	esac
	case $opcaom in 09)
	marca="Seagate"
	let "loopm=1"
	esac
	case $opcaom in 10)
	marca="Sony"
	let "loopm=1"
	esac
	case $opcaom in 11)
	marca="Toshiba"
	let "loopm=1"
	esac
	case $opcaom in 12)
	marca="Eltron"
	let "loopm=1"
	esac
	case $opcaom in 13)
	marca="Samsung"
	let "loopm=1"
	esac

	case $opcaom in 14)
	marca=
		while [ -z $marca ]
			do
			clear
			echo "|Digite a Marca     |"
			echo "|                   |"
			echo "|                   |"
			echo "|                   |"
			echo "|                   |"
			echo "|                   |"
			echo "|                   |"
			echo "|                   |"
			echo "|                   |"
			echo "|                   |"
			echo "|                   |"
			echo "|                   |"
			echo "|                   |"
			echo "|                   |"
			echo "|                   |" && read -e -n 128 marca
			let "loopm=1"
		done
	esac
	case $opcaom in m|M)
	marca=
	f_menu
	esac
	done
	}

function f_modelo {
	modelo=
	while [ -z $modelo ]
	do
	clear
	echo "|Modelo?            |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                  M|" && read -e -n 128 modelo
	done
	if [ "$modelo" = "M" -o "$modelo" = "m" ]
		then
		modelo=
		f_menu
		else
		echo ""
	fi
	}

function f_lojasnorte {
	let "loopln=0"
	while test $loopln == 0
	do
	clear
	opcaoln=
	echo "|Loja?              |"
	echo "|01] BRAGA          |"
	echo "|02] CARVALHOS      |"
	echo "|03] DRAGAO         |"
	echo "|04] FAMALICAO      |"
	echo "|05] GAIA           |"
	echo "|06] GUIMARAES      |"
	echo "|07] MAIA           |"
	echo "|08] MAR SHOPPING   |"
	echo "|09] NORTESHOPPING  |"
	echo "|10] OVAR           |"
	echo "|11] TONDELA        |"
	echo "|12] VIANA CASTELO  |"
	echo "|13] VILA REAL      |"
	echo "|14] VISEU         M|" && read -e -n 2 opcaoln
	case $opcaoln in 01)
	local="Loja de Braga"
	let "loopln=1"
	esac
	case $opcaoln in 02)
	local="Loja dos Carvalhos"
	let "loopln=1"
	esac
	case $opcaoln in 03)
	local="Loja do Dragao"
	let "loopln=1"
	esac
	case $opcaoln in 04)
	local="Loja de Famalicao"
	let "loopln=1"
	esac
	case $opcaoln in 05)
	local="Loja de Gaia"
	let "loopln=1"
	esac
	case $opcaoln in 06)
	local="Loja de Guimaraes"
	let "loopln=1"
	esac
	case $opcaoln in 07)
	local="Loja da Maia"
	let "loopln=1"
	esac
	case $opcaoln in 08)
	local="Loja do Mar Shoping"
	let "loopln=1"
	esac
	case $opcaoln in 09)
	local="Loja do Norteshopping"
	let "loopln=1"
	esac
	case $opcaoln in 10)
	local="Loja de Ovar"
	let "loopln=1"
	esac
	case $opcaoln in 11)
	local="Loja de Tondela"
	let "loopln=1"
	esac
	case $opcaoln in 12)
	local="Loja de Viana do Castelo"
	let "loopln=1"
	esac
	case $opcaoln in 13)
	local="Loja de Vila Real"
	let "loopln=1"
	esac
	case $opcaoln in 14)
	local="Loja de Viseu"
	let "loopln=1"
	esac
	case $opcaoln in m|M)
	opcaoln=
	f_menu
	esac
	done
	}

function f_lojascentro {
	let "looplc=0"
	while test $looplc == 0
	do
	clear
	opcaolc=
	echo "|Loja?              |"
	echo "|01] AVEIRO         |"
	echo "|02] CALDAS RAINHA  |"
	echo "|03] COIMBRA        |"
	echo "|04] FORUM COIMBRA  |"
	echo "|05] LEIRIA         |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                  M|" && read -e -n 2 opcaolc
	case $opcaolc in 1)
	local="Loja de Aveiro"
	let "looplc=1"
	esac
	case $opcaolc in 2)
	local="Loja de Caldas da Rainha"
	let "looplc=1"
	esac
	case $opcaolc in 3)
	local="Loja de Coimbra"
	let "looplc=1"
	esac
	case $opcaolc in 4)
	local="Loja do Forum Coimbra"
	let "looplc=1"
	esac
	case $opcaolc in 5)
	local="Loja de Leiria"
	let "looplc=1"
	esac
	case $opcaolc in m|M)
	opcaolc=
	f_menu
	esac
	done
	}

function f_lojassul {
	let "loopls=0"
	while test $loopls == 0
	do
	clear
	opcaols=
	echo "|Loja?              |"
	echo "|01] ALBUFEIRA      |"
	echo "|02] FARO           |"
	echo "|03] LOURES         |"
	echo "|04] MONTIJO        |"
	echo "|05] OLIVAIS        |"
	echo "|06] PORTIMAO       |"
	echo "|07] SANTAREM       |"
	echo "|08] SETUBAL        |"
	echo "|09] SINTRA         |"
	echo "|10] TORRES NOVAS   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                  M|" && read -e -n 2 opcaols
	case $opcaols in 01)
	local="Loja de Albufeira"
	let "loopls=1"
	esac
	case $opcaols in 02)
	local="Loja de Faro"
	let "loopls=1"
	esac
	case $opcaols in 03)
	local="Loures"
	let "loopls=1"
	esac
	case $opcaols in 04)
	local="Loja do Montijo"
	let "loopls=1"
	esac
	case $opcaols in 05)
	local="Loja dos Olivais"
	let "loopls=1"
	esac
	case $opcaols in 06)
	local="Loja de Portimao"
	let "loopls=1"
	esac
	case $opcaols in 07)
	local="Loja de Santarem"
	let "loopls=1"
	esac
	case $opcaols in 08)
	local="Loja de Setubal"
	let "loopls=1"
	esac
	case $opcaols in 09)
	local="Loja de Sintra"
	let "loopls=1"
	esac
	case $opcaols in 10)
	local="Loja de Torres Novas"
	let "loopls=1"
	esac
	case $opcaols in m|M)
	opcaols=
	f_menu
	esac
	done
	}

function f_lojasilhas {
	let "loopli=0"
	while test $loopli == 0
	do
	clear
	opcaoli=
	echo "|Loja?              |"
	echo "|01] ACORES S.MIGUE.|"
	echo "|02] ACORES TERCEIR.|"
	echo "|03] MADEIRA CANCEL.|"
	echo "|04] MADEIRA FUNCHA.|"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                  M|" && read -e -n 2 opcaoli
	case $opcaoli in 01)
	loja="Loja dos Acores - S. Miguel"
	let "loopli=1"
	esac
	case $opcaoli in 02)
	local="Loja dos Acores - Terceira"
	let "loopli=1"
	esac
	case $opcaoli in 03)
	local="Loja da Madeira - Cancela"
	let "loopli=1"
	esac
	case $opcaoli in 04)
	local="Loja da Madeira - Funchal"
	let "loopli=1"
	esac
	case $opcaoli in m|M)
	opcaoli=
	f_menu
	esac
	done
	}

function f_regiao {
	let "loopr=0"
	while test $loopr == 0
	do
	clear
	opcaor=
	echo "|Região/Local?      |"
	echo "|01]NORTE           |"
	echo "|02]CENTRO          |"
	echo "|03]SUL             |"
	echo "|04]ILHAS           |"
	echo "|05]ARCOZELO ESCRIT |"
	echo "|06]ARM CENTRAL ARC |"
	echo "|07]CT              |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                  M|" && read -e -n 2 opcaor
	case $opcaor in 01)
	regiao="Norte"
	f_lojasnorte
	let "loopr=1"
	esac
	case $opcaor in 02)
	regiao="Centro"
	f_lojascentro
	let "loopr=1"
	esac
	case $opcaor in 03)
	regiao="Sul"
	f_lojassul
	let "loopr=1"
	esac
	case $opcaor in 04)
	regiao="Ilhas"
	f_lojasilhas
	let "loopr=1"
	esac
	case $opcaor in 05)
	regiao="Norte"
	local="Escritorios Arcozelo"
	let "loopr=1"
	esac
	case $opcaor in 06)
	regiao="Norte"
	local="Armazem Central"
	let "loopr=1"
	esac
	case $opcaor in 07)
	regiao="Norte"
	local="Centro de Tecnologia"
	let "loopr=1"
	esac
	case $opcaor in m|M)
	opcaor=
	f_menu
	esac
	done
	}

function f_transporte {
	let "loopt=0"
	while test $loopt == 0
	do
	clear
	opcaot=
	echo "|Transporte?        |"
	echo "|01] CORREIO INTERNO|"
	echo "|02] CTT            |"
	echo "|03] TRANSPORTADORA |"
	echo "|04] TRANSFERENCIAS |"
	echo "|05] OUTRO          |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                  M|" && read -e -n 2 opcaot
	case $opcaot in 01)
	transporte="Correio Interno"
	let "loopt=1"
	esac
	case $opcaot in 02)
	transporte="CTT"
	let "loopt=1"
	esac
	case $opcaot in 03)
	transporte="Transportadora"
	let "loopt=1"
	esac
	case $opcaot in 04)
	transporte="Transferencias"
	let "loopt=1"
	esac
	case $opcaot in 05)
	clear
	echo "|Transporte?        |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |" && read -e -n 128 transporte
	let "loopt=1"
	esac
	case $opcaot in m|M)
	opcaot=
	f_menu
	esac
	done
	}

function f_inventario {
	assunto="Inventário"
	f_pi
	f_recolha
	f_regiao
	f_enviardados
	}

function f_envio {
	assunto="Envio"
	f_pi
	f_recolha
	f_regiao
	f_transporte
	f_enviardados
	}

function f_recepcao {
	assunto="Recepção"
	f_pi
	f_recolha
	f_regiao
	f_enviardados
	}

function f_menu {
	let "loop=0"
	while test $loop == 0
	do
	clear
	pi=
	unset linhas
	regiao=
	loja=
	transporte=
	assunto=
	echo "|MENU PRINCIPAL     |"
	echo "|                   |"
	echo "| 01] Recepcao      |"
	echo "| 02] Envio         |"
	echo "| 03] Inventario    |"
	echo "| 99] Sair          |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |"
	echo "|                   |" && read -e -n 2 opcao
	case $opcao in m|M)
	let "loop=1"
	esac
	case $opcao in 01)
	f_recepcao
	esac
	case $opcao in 02)
	f_envio
	esac
	case $opcao in 03)
	f_inventario
	esac
	case $opcao in 99)
	exit
	esac
	done
	}

f_menu
