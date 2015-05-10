#!/usr/bin/env bash
#! autor: j.francisco.o.rocha@gmail.com
#! sacarImpressoes_v2.sh
#! 08/2012

####################################
# Global variable declarations INI #
#								   #
IP=$1
shopt -s -o nounset
declare -rx SCRIPT=${0##*/}
declare IFS=$'\n'
declare modelo=""
declare modelotest
declare serial=""
declare contadorPB=""
declare contadorCOR=""
declare contadorTOTAL=""
declare IP
declare ipLive=""
declare ipValido=""
declare nixID=""
declare -rx htmlDestino=/tmp/HTML.$$
declare -rx WGET="/usr/bin/wget"
declare -rx CAT="/bin/cat"
declare -rx SED="/bin/sed"
declare -rx GREP="/bin/grep"
declare -rx AWK="/usr/bin/awk"
declare -rx FIND="/usr/bin/find"
declare -rx TR="/usr/bin/tr"
declare -rx PRINTF="/usr/bin/printf"
declare -rx PING="/bin/ping"
declare -rx SNMPWALK="/usr/bin/snmpwalk"
#								   #
# Global variable declarations END #
####################################

#################
# Functions INI #
#				#

function nixID () {
release=`ls /etc/*release`
if [ "$release" == "/etc/lsb-release" ] ; then
	nixID=Ubuntu
	else
	nixID=SuSE
fi
	}

function validacao () {
	if [ -z "$BASH" ]
	then
	$PRINTF "This script is written for bash. Please run this under bash\n" >&2
	exit 192
	fi
	if [ ! -x "$CAT" ]
	then
	printnofound $CAT >&2
	exit 192
	fi
	if [ ! -x "$GREP" ]
	then
	printnofound $GREP >&2
	exit 192
	fi
	if [ ! -x "$SED" ]
	then
	printnofound $SED >&2
	exit 192
	fi
	if [ ! -x "$WGET" ]
	then
	printnofound $WGET >&2
	exit 192
	fi
	if [ ! -x "$PRINTF" ]
	then
	printnofound $PRINTF >&2
	exit 192
	fi
	if [ ! -x "$TR" ]
	then
	printnofound $TR >&2
	exit 192
	fi
	if [ ! -x "$FIND" ]
	then
	printnofound $FIND >&2
	exit 192
	fi
	if [ ! -x "$PING" ]
	then
	printnofound $PING >&2
	exit 192
	fi
	}

function ipExiste () {
	if [[ $IP == "" ]] ; then
	echo "Não indicou um IP"
	exit 0
	fi
	}

function ipValido () {
ipValido=$(echo $IP | egrep '^[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}$')
if [ ! -n "$ipValido" ]; then
   echo "O IP não é valido."
   exit 0
fi
}

function ipLive () {
	/bin/ping -c 2 -W 10 $IP > /dev/null
	if [ "$?" -ne 0 ];
	then
		#echo -e "\n$IP não responde."
		echo A impressora não responde.
		ipLive="0"
		exit 0
	else
		#echo -e "\n$IP responde."
		ipLive="1"
	fi
	}

function printnofound () {
	$PRINTF "Não existe o utilitario $1. Porfavor instale.\n"
}

function processaImp () {
	if [[ $ipLive == "1" ]]; then
		if [[ $modelo == XeroxWorkCentre7232 ]]; then
		#echo -e "A usar driver $modelo"
		XeroxWorkCentre7232
		else
			if [[ $modelo == XeroxWorkCentre7242 ]]; then
			#echo -e "A usar driver $modelo"
			XeroxWorkCentre7242
				else
				if [[ $modelo == "XeroxPhaser4600" ]]; then
				#echo "A usar driver $modelo"
				XeroxPhaser4600
					else
					if [[ $modelo == "XeroxWorkCentre7345" ]]; then
					#echo "A usar driver $modelo"
					XeroxWorkCentre7345
						else
						if [[ $modelo == "XeroxWorkCentre7530" ]]; then
						#echo "A usar driver $modelo"
						XeroxWorkCentre7530
							else
							if [[ $modelo == "XeroxWorkCentre7120" ]]; then
							#echo "A usar driver $modelo"
							XeroxWorkCentre7120
								else
								if [[ $modelo == "XeroxPhaser3635MFP" ]]; then
								#echo "A usar driver $modelo"
								XeroxPhaser3635MFP
								else
									if [[ $modelo == "XeroxPhaser4510N" ]]; then
									#echo "A usar driver $modelo"
									XeroxPhaser4510N
									else
									echo "Não tenho driver para esta Impressora"
									echo "Modelo: $modelo"
									exit 0
									fi
								fi
							fi
						fi
					fi
				fi
			fi
		fi
	fi
	echo -e "$IP;$modelo;$serial;$contadorCOR;$contadorPB;$contadorTOTAL"
	}

## INI IMPRESSORAS ##
function XeroxWorkCentre7232 () {
	contadorPB=""
	contadorCOR=""
	contadorTOTAL=""
	$WGET --timeout 30 -t 1 -O - "http://$IP/prbillinfo.htm" > $htmlDestino 2> /dev/null;
	contadorPB=$($CAT $htmlDestino | $GREP "var billInfo" | $AWK -F',' '{ print $2 }' | $SED -e 's/ //g')
	contadorCOR=$($CAT $htmlDestino | $GREP "var billInfo" | $AWK -F',' '{ print $4 }' | $SED -e 's/ //g')
	contadorTOTAL=$(($contadorCOR + $contadorPB))
	if [[ -f "$htmlDestino" ]]; then
		rm $htmlDestino > /dev/null
	fi
	}

function XeroxWorkCentre7242 () {
	contadorPB=""
	contadorCOR=""
	contadorTOTAL=""
	$WGET --timeout 30 -t 1 -O - "http://$IP/prbillinfo.htm" > $htmlDestino 2> /dev/null;
	contadorPB=$($CAT $htmlDestino | $GREP "var billInfo" | $AWK -F',' '{ print $2 }' | $SED -e 's/ //g' | $TR -d '\015\032')
	contadorCOR=$($CAT $htmlDestino | $GREP "var billInfo" | $AWK -F',' '{ print $4 }' | $SED -e 's/ //g' | $TR -d '\015\032')
	contadorTOTAL=$(($contadorCOR + $contadorPB))
	if [[ -f "$htmlDestino" ]]; then
		rm $htmlDestino > /dev/null
	fi
	}

function XeroxPhaser4600 () {
	contadorPB=""
	contadorCOR=""
	contadorTOTAL=""
	if [[ $nixID == Ubuntu ]]; then
		contadorPB=$($SNMPWALK -c public -v 2c $IP iso.3.6.1.2.1.43.10.2.1.4.1.1 | $SED -e 's/ //g' | $AWK -F ':' '{ print $2}' | $TR -d '\015\032')
	else
		contadorPB=$($SNMPWALK -c public -v 2c $IP iso.3.6.1.2.1.43.10.2.1.4.1.1 | $SED -e 's/ //g' | $AWK -F '=' '{ print $2}' | $TR -d '\015\032')
	fi
	contadorTOTAL=$contadorPB
	if [[ -f "$htmlDestino" ]]; then
		rm $htmlDestino > /dev/null
	fi
	}

function XeroxWorkCentre7345 () {
	contadorPB=""
	contadorCOR=""
	contadorTOTAL=""
	$WGET --timeout 30 -t 1 -O - "http://$IP/prbillinfo.htm" > $htmlDestino 2> /dev/null;
	contadorPB=$($CAT $htmlDestino | $GREP "var billInfo" | $AWK -F',' '{ print $2 }' | $SED -e 's/ //g')
	contadorCOR=$($CAT $htmlDestino | $GREP "var billInfo" | $AWK -F',' '{ print $4 }' | $SED -e 's/ //g')
	contadorTOTAL=$(($contadorCOR + $contadorPB))
	if [[ -f "$htmlDestino" ]]; then
		rm $htmlDestino > /dev/null
	fi
	}

function XeroxWorkCentre7530 () {
	contadorPB=""
	contadorCOR=""
	contadorTOTAL=""
	$WGET --timeout 30 -t 1 -O - "http://$IP/counters/billing_info.php" > $htmlDestino 2> /dev/null;
	contadorPB=$($CAT $htmlDestino | $GREP 'Black Impressions' | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba' | $AWK -F':' '{print $2}' | $SED -e 's/ //g')
	contadorCOR=$($CAT $htmlDestino | $GREP 'Color Impressions' | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba' | $AWK -F':' '{print $2}' | $SED -e 's/ //g')
	contadorTOTAL=$(($contadorCOR + $contadorPB))
	if [[ -f "$htmlDestino" ]]; then
		rm $htmlDestino > /dev/null
	fi
	}

function XeroxWorkCentre7120 () {
	contadorPB=""
	contadorCOR=""
	contadorTOTAL=""
	$WGET --timeout 30 -t 1 -O - "http://$IP/prbillinfo.htm" > $htmlDestino 2> /dev/null;
	contadorPB=$($CAT $htmlDestino | $GREP "var billInfo" | $AWK -F',' '{ print $2 }' | $SED -e 's/ //g')
	contadorCOR=$($CAT $htmlDestino | $GREP "var billInfo" | $AWK -F',' '{ print $4 }' | $SED -e 's/ //g')
	contadorTOTAL=$(($contadorCOR + $contadorPB))
	if [[ -f "$htmlDestino" ]]; then
		rm $htmlDestino > /dev/null
	fi
	}

function XeroxPhaser3635MFP () {
	contadorPB=""
	contadorCOR=""
	contadorTOTAL=""
	if [[ $nixID == Ubuntu ]]; then
		contadorPB=$($SNMPWALK -c public -v 2c $IP iso.3.6.1.2.1.43.10.2.1.4.1.1 | $SED -e 's/ //g' | $AWK -F ':' '{ print $2}' | $TR -d '\015\032')
	else
		contadorPB=$($SNMPWALK -c public -v 2c $IP iso.3.6.1.2.1.43.10.2.1.4.1.1 | $SED -e 's/ //g' | $AWK -F '=' '{ print $2}' | $TR -d '\015\032')
	fi
	contadorTOTAL=$contadorPB
	if [[ -f "$htmlDestino" ]]; then
		rm $htmlDestino > /dev/null
	fi
	}

function XeroxPhaser4510N () {
	contadorPB=""
	contadorCOR=""
	contadorTOTAL=""
	if [[ $nixID == Ubuntu ]]; then
		contadorPB=$($SNMPWALK -c public -v 2c $IP iso.3.6.1.2.1.43.10.2.1.4.1.1 | $SED -e 's/ //g' | $AWK -F ':' '{ print $2}' | $TR -d '\015\032')
	else
		contadorPB=$($SNMPWALK -c public -v 2c $IP iso.3.6.1.2.1.43.10.2.1.4.1.1 | $SED -e 's/ //g' | $AWK -F '=' '{ print $2}' | $TR -d '\015\032')
	fi
	contadorTOTAL=$contadorPB
	if [[ -f "$htmlDestino" ]]; then
		rm $htmlDestino > /dev/null
	fi
	}


## END IMPRESSORAS ##

function idImpressora () {
	if [[ $ipLive == "1" ]]; then
		if [[ $nixID == Ubuntu ]]; then
			serial=$($SNMPWALK -c public -v 2c $IP iso.3.6.1.2.1.43.5.1.1.17.1 | $SED -e 's/ //g;s/"//g' | $AWK -F ':' '{ print $2}')
			modelo=$($SNMPWALK -c public -v 2c $IP iso.3.6.1.2.1.1.1.0 | $AWK -F';' '{ print $1 }' | $AWK -F'"' '{ print $2}' | $AWK -F' ' '{ print $1 $2 $3 }' | $SED -e 's/"//g')
		else
			serial=$($SNMPWALK -c public -v 2c $IP iso.3.6.1.2.1.43.5.1.1.17.1 | $SED -e 's/ //g;s/"//g' | $AWK -F '=' '{ print $2}')
			modelo=$($SNMPWALK -c public -v 2c $IP iso.3.6.1.2.1.1.1.0 | $AWK -F';' '{ print $1 }' | $AWK -F': ' '{ print $2}' | $AWK -F' ' '{ print $1 $2 $3 }' | $SED -e 's/"//g')
		fi
	fi
	processaImp
	}

#				#
# Functions END #
#################

validacao
nixID
ipExiste
ipValido
ipLive
#echo -e "IP;Modelo;Nº Serie;ContadorCOR;ContadorPB;ContadorTOTAL"
idImpressora
