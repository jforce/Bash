#!/usr/bin/env bash
#! autor: j.francisco.o.rocha@gmail.com
#! sacarImpressoes.sh
#! 11/2011

####################################
# Global variable declarations INI #
#								   #
shopt -s -o nounset
declare -rx SCRIPT=${0##*/}
declare IFS=$'\n'
declare modelo=""
declare serial=""
declare contadorPB=""
declare contadorCOR=""
declare contadorTOTAL=""
declare aguardarTempo=0
declare tempoMax=9
declare local=""
declare sector=""
declare peso=""
declare IP=""
declare IPCheck=""
declare dataHoje=""
declare dataInstalacao=""
declare diasTrabalho=""
declare responsavel=""
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

function aguardarTempo () {
	# Coloca o scrip em espera entre 0 e 60 seg.
	tempoMax=$1
	aguardarTempo=$(echo $((`$CAT /dev/urandom|$OD -N1 -An -i` % $tempoMax)))
	echo "Processamento suspenso durante $aguardarTempo seg. (Max= $tempoMax seg.)"
	sleep $aguardarTempo
	}

function printnofound () {
	$PRINTF "Não existe o utilitario $1. Porfavor instale.\n"
}

function printfound () {
	if [[ $IPCheck == "1" ]]; then
	echo -e "$local;$peso;$sector;$IP;$modelo;$responsavel;$diasTrabalho;$serial;$contadorCOR;$contadorPB;$contadorTOTAL"
	else
	#echo -e "$local;$peso;$sector;$IP;$modelo;;Equipamento não responde"
	echo -e "$local;$peso;$sector;$IP;$modelo;$responsavel;$diasTrabalho;$serial;$contadorCOR;$contadorPB;$contadorTOTAL"
	fi
	}

function checkIP () {
	/bin/ping -c 2 -W 10 $IP > /dev/null
	if [ "$?" -ne 0 ];
	then
		#echo -e "\n$IP não responde."
		IPCheck="0"
	else
		#echo -e "\n$IP responde."
		IPCheck="1"
	fi
	}

function calculaDias () {
	ARGS=2                # Two command line parameters expected.
	E_PARAM_ERR=65        # Param error.
	REFYR=1600            # Reference year.
	CENTURY=100
	DIY=365
	ADJ_DIY=367           # Adjusted for leap year + fraction.
	MIY=12
	DIM=31
	LEAPCYCLE=4
	MAXRETVAL=255         #  Largest permissable
						  #+ positive return value from a function.
	diff=                 # Declare global variable for date difference.
	value=                # Declare global variable for absolute value.
	day=                  # Declare globals for day, month, year.
	month=
	year=

	Param_Error ()        # Command line parameters wrong.
	{
	  echo "Usage: `basename $0` [M]M/[D]D/YYYY [M]M/[D]D/YYYY"
	  echo "       (date must be after 1/3/1600)"
	  exit $E_PARAM_ERR
	}  

	Parse_Date ()                 # Parse date from command line params.
	{
	  month=${1%%/**}
	  dm=${1%/**}                 # Day and month.
	  day=${dm#*/}
	  let "year = `basename $1`"  # Not a filename, but works just the same.
	}  

	check_date ()                 # Checks for invalid date(s) passed.
	{
	  [ "$day" -gt "$DIM" ] || [ "$month" -gt "$MIY" ] || [ "$year" -lt "$REFYR" ] && Param_Error
	  # Exit script on bad value(s).
	  # Uses "or-list / and-list".
	  #
	  # Exercise: Implement more rigorous date checking.
	}

	strip_leading_zero () #  Better to strip possible leading zero(s)
	{                     #+ from day and/or month
	  return ${1#0}       #+ since otherwise Bash will interpret them
	}                     #+ as octal values (POSIX.2, sect 2.9.2.1).

	day_index ()          # Gauss' Formula:
	{                     # Days from Jan. 3, 1600 to date passed as param.

	  day=$1
	  month=$2
	  year=$3

	  let "month = $month - 2"
	  if [ "$month" -le 0 ]
	  then
		let "month += 12"
		let "year -= 1"
	  fi  
	  let "year -= $REFYR"
	  let "indexyr = $year / $CENTURY"
	  let "Days = $DIY*$year + $year/$LEAPCYCLE - $indexyr + $indexyr/$LEAPCYCLE + $ADJ_DIY*$month/$MIY + $day - $DIM"
	  #  For an in-depth explanation of this algorithm, see
	  #+ http://home.t-online.de/home/berndt.schwerdtfeger/cal.htm
	  echo $Days

	}  

	calculate_difference ()            # Difference between to day indices.
	{
	  let "diff = $1 - $2"             # Global variable.
	}  

	abs ()                             #  Absolute value
	{                                  #  Uses global "value" variable.
	  if [ "$1" -lt 0 ]                #  If negative
	  then                             #+ then
		let "value = 0 - $1"           #+ change sign,
	  else                             #+ else
		let "value = $1"               #+ leave it alone.
	  fi
	}

	if [ $# -ne "$ARGS" ]              # Require two command line params.
	then
	  Param_Error
	fi  

	Parse_Date $1
	check_date $day $month $year       #  See if valid date.

	strip_leading_zero $day            #  Remove any leading zeroes
	day=$?                             #+ on day and/or month.
	strip_leading_zero $month
	month=$?

	let "date1 = `day_index $day $month $year`"

	Parse_Date $2
	check_date $day $month $year
	strip_leading_zero $day
	day=$?
	strip_leading_zero $month
	month=$?
	date2=$(day_index $day $month $year) # Command substitution.
	calculate_difference $date1 $date2
	abs $diff                            # Make sure it's positive.
	diff=$value
	echo $diff
	# exit 0
	}

## INI IMPRESSORAS ##
function XeroxWorkCentre7232 () {
	checkIP
	contadorPB=""
	contadorCOR=""
	contadorTOTAL=""
	serial=""
	modelo="XeroxWorkCentre7232"
	if [[ $IPCheck == "1" ]]; then
		$WGET --timeout 30 -t 1 -O - "http://$IP/prbillinfo.htm" > $htmlDestino 2> /dev/null;
		contadorPB=$($CAT $htmlDestino | $GREP "var billInfo" | $AWK -F',' '{ print $2 }' | $SED -e 's/ //g')
		contadorCOR=$($CAT $htmlDestino | $GREP "var billInfo" | $AWK -F',' '{ print $4 }' | $SED -e 's/ //g')
		contadorTOTAL=$(($contadorCOR + $contadorPB))
		serial=$($CAT $htmlDestino | $GREP "nSrlNum =" | $SED -e "s/'"'/:/g' | $AWK -F ':' '{ print $2 }' )
		if [[ -f "$htmlDestino" ]]; then
			rm $htmlDestino > /dev/null
		fi
	fi
	printfound
	}

function XeroxWorkCentre7242 () {
	checkIP
	contadorPB=""
	contadorCOR=""
	contadorTOTAL=""
	serial=""
	modelo="XeroxWorkCentre7242"
	if [[ $IPCheck == "1" ]]; then
		$WGET --timeout 30 -t 1 -O - "http://$IP/prbillinfo.htm" > $htmlDestino 2> /dev/null;
		contadorPB=$($CAT $htmlDestino | $GREP "var billInfo" | $AWK -F',' '{ print $2 }' | $SED -e 's/ //g' | $TR -d '\015\032')
		contadorCOR=$($CAT $htmlDestino | $GREP "var billInfo" | $AWK -F',' '{ print $4 }' | $SED -e 's/ //g' | $TR -d '\015\032')
		contadorTOTAL=$(($contadorCOR + $contadorPB))
		serial=$($CAT $htmlDestino | $GREP "nSrlNum =" | $SED -e "s/'"'/:/g' | $AWK -F ':' '{ print $2 }' | $TR -d '\015\032')
		if [[ -f "$htmlDestino" ]]; then
			rm $htmlDestino > /dev/null
		fi
	fi
	printfound
	}

function XeroxPhaser4600 () {
	checkIP
	contadorPB=""
	contadorCOR=""
	contadorTOTAL=""
	serial=""
	modelo="XeroxPhaser4600"
	if [[ $IPCheck == "1" ]]; then
		contadorPB=$($SNMPWALK -c public -v 2c $IP iso.3.6.1.2.1.43.10.2.1.4.1.1 | $SED -e 's/ //g' | $AWK -F ':' '{ print $2}')
		contadorTOTAL=$contadorPB
		serial=$($SNMPWALK -c public -v 2c $IP iso.3.6.1.2.1.43.5.1.1.17.1 | $SED -e 's/ //g;s/"//g' | $AWK -F ':' '{ print $2}')
		if [[ -f "$htmlDestino" ]]; then
			rm $htmlDestino > /dev/null
		fi
	fi
	printfound
	}

function XeroxWorkCentre7345 () {
	checkIP
	contadorPB=""
	contadorCOR=""
	contadorTOTAL=""
	serial=""
	modelo="XeroxWorkCentre7345"
	if [[ $IPCheck == "1" ]]; then
		$WGET --timeout 30 -t 1 -O - "http://$IP/prbillinfo.htm" > $htmlDestino 2> /dev/null;
		contadorPB=$($CAT $htmlDestino | $GREP "var billInfo" | $AWK -F',' '{ print $2 }' | $SED -e 's/ //g')
		contadorCOR=$($CAT $htmlDestino | $GREP "var billInfo" | $AWK -F',' '{ print $4 }' | $SED -e 's/ //g')
		contadorTOTAL=$(($contadorCOR + $contadorPB))
		serial=$($SNMPWALK -c public -v 2c $IP iso.3.6.1.2.1.43.5.1.1.17.1 | $SED -e 's/ //g;s/"//g' | $AWK -F ':' '{ print $2}')
		if [[ -f "$htmlDestino" ]]; then
			rm $htmlDestino > /dev/null
		fi
	fi
	printfound
	}
	
function XeroxWorkCentre7530 () {
	checkIP
	contadorPB=""
	contadorCOR=""
	contadorTOTAL=""
	serial=""
	modelo="XeroxWorkCentre7530"
	if [[ $IPCheck == "1" ]]; then
		$WGET --timeout 30 -t 1 -O - "http://$IP/counters/billing_info.php" > $htmlDestino 2> /dev/null;
		contadorPB=$($CAT $htmlDestino | $GREP 'Black Impressions' | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba' | $AWK -F':' '{print $2}' | $SED -e 's/ //g')
		contadorCOR=$($CAT $htmlDestino | $GREP 'Color Impressions' | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba' | $AWK -F':' '{print $2}' | $SED -e 's/ //g')
		contadorTOTAL=$(($contadorCOR + $contadorPB))
		serial=$($SNMPWALK -c public -v 2c $IP iso.3.6.1.2.1.43.5.1.1.17.1 | $SED -e 's/ //g;s/"//g' | $AWK -F ':' '{ print $2}')
		if [[ -f "$htmlDestino" ]]; then
			rm $htmlDestino > /dev/null
		fi
	fi
	printfound
	}	

function XeroxWC7120 () {
	checkIP
	contadorPB=""
	contadorCOR=""
	contadorTOTAL=""
	serial=""
	modelo="XeroxWC7120"
	if [[ $IPCheck == "1" ]]; then
		$WGET --timeout 30 -t 1 -O - "http://$IP/prbillinfo.htm" > $htmlDestino 2> /dev/null;
		contadorPB=$($CAT $htmlDestino | $GREP "var billInfo" | $AWK -F',' '{ print $2 }' | $SED -e 's/ //g')
		contadorCOR=$($CAT $htmlDestino | $GREP "var billInfo" | $AWK -F',' '{ print $4 }' | $SED -e 's/ //g')
		contadorTOTAL=$(($contadorCOR + $contadorPB))
		serial=$($CAT $htmlDestino | $GREP "nSrlNum =" | $SED -e "s/'"'/:/g' | $AWK -F ':' '{ print $2 }' )
		if [[ -f "$htmlDestino" ]]; then
			rm $htmlDestino > /dev/null
		fi
	fi
	printfound
	}

function XeroxPhaser3635MFP () {
	checkIP
	contadorPB=""
	contadorCOR=""
	contadorTOTAL=""
	serial=""
	modelo="XeroxPhaser3635MFP"
	if [[ $IPCheck == "1" ]]; then
		contadorPB=$($SNMPWALK -c public -v 2c $IP iso.3.6.1.2.1.43.10.2.1.4.1.1 | $SED -e 's/ //g' | $AWK -F ':' '{ print $2}' | $TR -d '\015\032')
		contadorTOTAL=$contadorPB
		serial=$($SNMPWALK -c public -v 2c $IP iso.3.6.1.2.1.43.5.1.1.17.1 | $SED -e 's/ //g;s/"//g' | $AWK -F ':' '{ print $2}' | $TR -d '\015\032')
		if [[ -f "$htmlDestino" ]]; then
			rm $htmlDestino > /dev/null
		fi
	fi
	printfound
	}

function XeroxWorkCentreM118 () {
	checkIP
	contadorPB=""
	contadorCOR=""
	contadorTOTAL=""
	serial=""
	modelo="XeroxWorkCentreM118"
	if [[ $IPCheck == "1" ]]; then
		contadorPB=$($SNMPWALK -c public -v 2c $IP iso.3.6.1.2.1.43.10.2.1.4.1.1 | $SED -e 's/ //g' | $AWK -F ':' '{ print $2}')
		contadorTOTAL=$contadorPB
		serial=$($SNMPWALK -c public -v 2c $IP iso.3.6.1.2.1.43.5.1.1.17.1 | $SED -e 's/ //g;s/"//g' | $AWK -F ':' '{ print $2}')
		if [[ -f "$htmlDestino" ]]; then
			rm $htmlDestino > /dev/null
		fi
	fi
	printfound
	}

function XeroxPhaser6180MFP () {
	checkIP
	contadorPB=""
	contadorCOR=""
	contadorTOTAL=""
	serial=""
	modelo="XeroxPhaser6180MFP"
	if [[ $IPCheck == "1" ]]; then
		$WGET --timeout 30 -t 1 -O - "http://$IP/status/statgeneralx.htm" > $htmlDestino 2> /dev/null;
		contadorTOTAL=$($CAT $htmlDestino | $GREP -a "<td align=left>" | $SED '$!d' | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba;s/ //g' | $SED 's/\(.*\)./\1/')
		$WGET --timeout 30 -t 1 -O - "http://$IP/setting/prtinfo.htm" > $htmlDestino 2> /dev/null;
		serial=$($CAT $htmlDestino | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba' | $GREP -a Number | $AWK -F ':' '{ print $2}' | $SED 's/\(.*\)./\1/')
		if [[ -f "$htmlDestino" ]]; then
			rm $htmlDestino > /dev/null
		fi
	fi
	printfound
	}

function XeroxPhaser4510 () {
	checkIP
	contadorPB=""
	contadorCOR=""
	contadorTOTAL=""
	serial=""
	modelo="XeroxPhaser4510"
	if [[ $IPCheck == "1" ]]; then
		$WGET --timeout 30 -t 1 -O - "http://$IP/status.html" > $htmlDestino 2> /dev/null;
		contadorPB=$($CAT $htmlDestino | $GREP "<td>" | $GREP "</td>" | $GREP -v LABEL | $SED '$!d' | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba;s/ //g')
		contadorTOTAL=$contadorPB
		$WGET --timeout 30 -t 1 -O - "http://$IP/aboutprinter.html" > $htmlDestino 2> /dev/null;
		serial=$($CAT $htmlDestino | $GREP "<td>" | $GREP "</td>" | $SED -n '4p' | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba;s/ //g')
		if [[ -f "$htmlDestino" ]]; then
			rm $htmlDestino > /dev/null
		fi
	fi
	printfound
	}

function XeroxWorkCentrePro () {
	checkIP
	contadorPB=""
	contadorCOR=""
	contadorTOTAL=""
	serial=""
	modelo="XeroxWorkCentrePro"
	if [[ $IPCheck == "1" ]]; then
		$WGET --timeout 30 -t 1 -O - "http://$IP/properties/billingCounters.dhtml" > $htmlDestino 2> /dev/null;
		contadorPB=$($CAT $htmlDestino | $GREP "markedBWImages" | $AWK -F '"' '{ print $2 }' | $SED '/^$/d' | $SED -e 's/ //g')
		contadorCOR=$($CAT $htmlDestino | $GREP "markedColorImages" | $AWK -F '"' '{ print $2 }' | $SED '/^$/d' | $SED -e 's/ //g')
		contadorTOTAL=$(($contadorCOR + $contadorPB))
		serial=$($CAT $htmlDestino | $GREP "pro_code\[i\]" | awk -F "'" '{ print $2 }')
		if [[ -f "$htmlDestino" ]]; then
			rm $htmlDestino > /dev/null
		fi
	fi
	printfound
	}

function XeroxWorkCentreM24 () {
	checkIP
	contadorPB=""
	contadorCOR=""
	contadorTOTAL=""
	serial=""
	modelo="XeroxWorkCentreM24"	
	if [[ $IPCheck == "1" ]]; then
		$WGET --timeout 30 -t 1 -O - "http://$IP/prcnt.htm" > $htmlDestino 2> /dev/null;
		contadorPB=$($CAT $htmlDestino | $GREP "var info" | $AWK -F "," '{ print $4 }' | $SED -e 's/]//g;s/;//g;s/ //g' | $TR -d '\015\032')
		contadorCOR=$($CAT $htmlDestino | $GREP "var info" | $AWK -F "," '{ print $2 }' | $SED -e 's/ //g')
		contadorTOTAL=$(($contadorCOR + $contadorPB))
		$WGET --timeout 30 -t 1 -O - "http://$IP/prdsc.htm" > $htmlDestino 2> /dev/null;
		serial=$($CAT $htmlDestino | $GREP "var devDsc" | $AWK -F "'" '{ print $4 }')
		if [[ -f "$htmlDestino" ]]; then
			rm $htmlDestino > /dev/null
		fi
	fi
	printfound
	}

## END IMPRESSORAS ##

function getSNMP () {
	checkIP
	contadorPB=""
	contadorCOR=""
	if [[ $IPCheck == "1" ]]; then
		contadorPB=$($SNMPWALK -c public -v 2c $IP iso.3.6.1.2.1.43.10.2.1.4.1.1 | $SED -e 's/ //g' | $AWK -F ':' '{ print $2}')
		serial=$($SNMPWALK -c public -v 2c $IP iso.3.6.1.2.1.43.5.1.1.17.1 | $SED -e 's/ //g' | $AWK -F ':' '{ print $2}')
	fi
	printfound
	}

function getHoje () {
	dataHoje=$(date +"%m/%d/%Y")
	}

## INI LOCAIS ##

function getAlbufeira () {
	local="Albufeira"
	peso="2,21"
	IP="192.168.55.80"
	sector="Loja"
	dataInstalacao="01/19/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl055@radiopopular.pt"
	XeroxWC7120
	IP="192.168.55.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	XeroxWorkCentre7242
	}

function getAlfragide () {
	local="Alfragide"
	peso="2,49"
	IP="192.168.24.80"
	sector="Loja"
	dataInstalacao="01/19/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl132@radiopopular.pt"
	XeroxWC7120
	IP="192.168.24.81"
	sector="Armazém"
	dataInstalacao="12/11/2010"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl132@radiopopular.pt"
	XeroxPhaser3635MFP
	IP="192.168.24.83"
	sector="SPV"
	dataInstalacao="12/11/2010"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl132@radiopopular.pt"
	XeroxPhaser3635MFP
	}

function getAlverca () {
	local="Alverca"
	peso="1,47"
	IP="192.168.27.80"
	sector="Loja"
	dataInstalacao="05/27/2011"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl236@radiopopular.pt"
	XeroxWC7120
	IP="192.168.27.81"
	sector="Armazém"
	dataInstalacao="05/27/2011"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl236@radiopopular.pt"
	XeroxPhaser3635MFP
	}

function getArcozelo () {
	local="Arcozelo"
	peso=""
	
	IP="192.168.124.88"
	sector="Recepção"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="@radiopopular.pt"
	XeroxPhaser3635MFP

	IP="192.168.124.87"
	sector="DO"
	dataInstalacao="02/10/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="@radiopopular.pt"
	XeroxPhaser4600
	
	IP="192.168.125.92"
	sector="AUD/SPV-Sr.Lafayete"
	dataInstalacao="02/10/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="@radiopopular.pt"
	XeroxPhaser4600
	
	IP="192.168.125.93"
	sector="DAC/DAF"
	dataInstalacao="02/10/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="@radiopopular.pt"
	XeroxPhaser4600

#	IP="192.168.125.99"
#	sector="DAC/DAF"
#	dataInstalacao="01/01/2009"
#	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
#	responsavel="@radiopopular.pt"
#	XeroxPhaser4510
	
	IP="192.168.125.60"
	sector="Administração"
	dataInstalacao="02/10/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="@radiopopular.pt"
	XeroxPhaser4600
	
	IP="192.168.124.80"
	sector="PE"
	dataInstalacao="02/10/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="@radiopopular.pt"
	XeroxWorkCentre7530
	
	IP="192.168.124.83"
	sector="Contabilidade"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="@radiopopular.pt"
	XeroxWorkCentre7345
	
	IP="192.168.124.150"
	sector="Compras"
	dataInstalacao="02/10/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="@radiopopular.pt"
	XeroxWC7120
	
	IP="192.168.125.100"
	sector="RH"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="@radiopopular.pt"
	XeroxPhaser3635MFP
	
#	IP="192.168.125.180"
#	sector="Auditoria"
#	dataInstalacao="01/01/2009"
#	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
#	responsavel="@radiopopular.pt"
#	XeroxPhaser3635MFP
	
#	IP="192.168.125.90"
#	sector="DAC/DAF"
#	dataInstalacao="01/01/2009"
#	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
#	responsavel="@radiopopular.pt"
#	XeroxPhaser3635MFP
	
	IP="192.168.124.91"
	sector="DEP. JURIDICO"
	dataInstalacao="01/11/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="@radiopopular.pt"
	XeroxPhaser4600
	}

function getArmazemArcozelo () {
	local="Armazém Arcozelo"
	peso=""

#	IP="192.168.4.81"
#	sector="Armazém Central"
#	dataInstalacao="01/01/2009"
#	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
#	responsavel="@radiopopular.pt"
#	XeroxPhaser6180MFP

	IP="192.168.4.82"
	sector="Armazém Norte"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="@radiopopular.pt"
	XeroxPhaser3635MFP

	IP="192.168.4.83"
	sector="Economato"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="@radiopopular.pt"
	XeroxPhaser3635MFP

	IP="192.168.4.88"
	sector="SPV Norte"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="@radiopopular.pt"
	XeroxPhaser3635MFP

#	IP="192.168.4.91"
#	sector="SPV"
#	dataInstalacao="01/01/2009"
#	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
#	responsavel="@radiopopular.pt"
#	XeroxPhaser4510

#	IP="1.1.1.1"
#	sector="Segurança - ARU335131"
#	dataInstalacao="01/01/2009"
#	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
#	responsavel="@radiopopular.pt"
#	XeroxPhaser4510	
	}

function getArmazemCancela () {
	local="Armazém Cancela"
	peso=""
	IP="192.168.62.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="@radiopopular.pt"
	XeroxPhaser3635MFP
	}

function getArmazemLoures () {
	local="Armazém Loures"
	peso=""
	IP="192.168.26.82"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="@radiopopular.pt"
	XeroxPhaser3635MFP
	IP="192.168.26.169"
	sector="SPV"
	dataInstalacao="01/20/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="@radiopopular.pt"
	XeroxPhaser4600
	}

function getArmazemMarnosso () {
	local="Armazém Marnosso"
	peso=""
	IP="192.168.42.80"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="@radiopopular.pt"
	XeroxPhaser3635MFP
	}

function getAveiroII () {
	local="Aveiro II"
	peso="2,79"
	IP="192.168.52.80"
	sector="Loja"
	dataInstalacao="01/17/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl129@radiopopular.pt"
	XeroxWC7120
	IP="192.168.52.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl129@radiopopular.pt"
	XeroxWorkCentre7242
	}

function getBarreiro () {
	local="Barreiro"
	peso="2,87"
	IP="192.168.25.80"
	sector="Loja"
	dataInstalacao="03/01/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl232@radiopopular.pt"
	XeroxWC7120
	IP="192.168.25.81"
	sector="Armazém"
	dataInstalacao="03/01/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl232@radiopopular.pt"
	XeroxWorkCentre7242
	}

function getBraga () {
	local="Braga"
	peso="2,58"
	IP="192.168.70.80"
	sector="Loja"
	dataInstalacao="01/12/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl070@radiopopular.pt"
	XeroxWC7120
	IP="192.168.70.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl070@radiopopular.pt"
	XeroxWorkCentre7232
	}

function getCaldas () {
	local="Caldas"
	peso="2,45"
	IP="192.168.61.80"
	sector="Loja"
	dataInstalacao="01/17/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl148@radiopopular.pt"
	XeroxWC7120
	IP="192.168.61.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl148@radiopopular.pt"
	XeroxWorkCentre7242
	}

function getCarvalhos () {
	local="Carvalhos"
	peso="1,94"
	IP="192.168.58.80"
	sector="Loja"
	dataInstalacao="01/11/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl135@radiopopular.pt"
	XeroxWC7120
	IP="192.168.58.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl135@radiopopular.pt"
	XeroxWorkCentre7232
	}

function getCovilha () {
	local="Covilhã"
	peso="0,38"
	IP="192.168.29.80"
	sector="Loja"
	dataInstalacao="24/03/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl270@radiopopular.pt"
	XeroxWC7120
	IP="192.168.29.81"
	sector="Armazém"
	dataInstalacao="24/03/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl270@radiopopular.pt"
	XeroxPhaser3635MFP
	}

function getDragao () {
	local="Dragão"
	peso="3,96"
	IP="192.168.78.80"
	sector="Loja"
	dataInstalacao="01/11/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl078@radiopopular.pt"
	XeroxWC7120
	IP="192.168.78.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl078@radiopopular.pt"
	XeroxWorkCentre7242
	IP="192.168.78.82"
	sector="SPV"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl078@radiopopular.pt"
	XeroxPhaser3635MFP
	}

function getErmesinde () {
	local="Ermesinde"
	peso="1,98"
	IP="192.168.23.80"
	sector="Loja"
	dataInstalacao="10/27/2010"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl234@radiopopular.pt"
	XeroxWC7120
	IP="192.168.23.81"
	sector="Armazém"
	dataInstalacao="10/27/2010"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl234@radiopopular.pt"
	XeroxPhaser3635MFP
	}

function getFamalicao () {
	local="Famalicão"
	peso="2,27"
	IP="192.168.80.80"
	sector="Loja"
	dataInstalacao="01/12/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl080@radiopopular.pt"
	XeroxWC7120
	IP="192.168.80.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl080@radiopopular.pt"
	XeroxWorkCentre7232
	}

function getFaro () {
	local="Faro"
	peso="3,28"
	IP="192.168.127.80"
	sector="Loja"
	dataInstalacao="01/19/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl053@radiopopular.pt"
	XeroxWC7120
	IP="192.168.127.81"
	sector="Armazém"
	dataInstalacao="01/23/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl053@radiopopular.pt"
	XeroxWorkCentre7242
	IP="192.168.127.82"
	sector="SPV"
	dataInstalacao="01/23/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl053@radiopopular.pt"
	XeroxPhaser3635MFP
	}

function getForumCoimbra () {
	local="Fórum Coimbra"
	peso="2,58"
	IP="192.168.115.80"
	sector="Loja"
	dataInstalacao="01/13/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl115@radiopopular.pt"
	XeroxWC7120
	IP="192.168.115.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl115@radiopopular.pt"
	XeroxWorkCentre7242
	}

function getGaia () {
	local="Gaia"
	peso="2,65"
	IP="192.168.74.80"
	sector="Loja"
	dataInstalacao="01/11/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl073@radiopopular.pt"
	XeroxWC7120
	IP="192.168.74.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl073@radiopopular.pt"
	XeroxWorkCentre7242
	}

function getGranja () {
	local="Granja"
	peso=""
	IP="192.168.150.90"
	sector="EISA"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="@radiopopular.pt"
	XeroxWorkCentre7242	
	}

function getGuimaraes () {
	local="Guimarães"
	peso="2,35"
	IP="192.168.100.80"
	sector="Loja"
	dataInstalacao="01/12/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)	
	responsavel="egl100@radiopopular.pt"
	XeroxWC7120
	IP="192.168.100.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl100@radiopopular.pt"
	XeroxWorkCentre7232
	}

function getLeiria () {
	local="Leiria"
	peso="2,48"
	IP="192.168.16.80"
	sector="Loja"
	dataInstalacao="01/17/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl016@radiopopular.pt"
	XeroxWC7120
	IP="192.168.16.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl016@radiopopular.pt"
	XeroxWorkCentre7242
	}

function getLoures () {
	local="Loures"
	peso="2,86"
	IP="192.168.26.80"
	sector="Loja"
	dataInstalacao="01/20/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl026@radiopopular.pt"
	XeroxWC7120
	IP="192.168.26.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl026@radiopopular.pt"
	XeroxWorkCentre7242
	}

function getMadeiraCancela () {
	local="Madeira Cancela"
	peso="2,52"
	IP="192.168.60.80"
	sector="Loja"
	dataInstalacao="01/27/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl060@radiopopular.pt"
	XeroxWC7120
	IP="192.168.60.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl060@radiopopular.pt"
	XeroxPhaser3635MFP
	}

function getMadeiraForum () {
	local="Madeira Forum"
	peso="2,60"
	IP="192.168.65.80"
	sector="Loja"
	dataInstalacao="01/25/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl065@radiopopular.pt"
	XeroxWC7120
	IP="192.168.65.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl065@radiopopular.pt"
	XeroxWorkCentre7242
	}

function getMafra () {
	local="Mafra"
	peso="1,32"
	IP="192.168.28.80"
	sector="Loja"
	dataInstalacao="12/07/2011"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl238@radiopopular.pt"
	XeroxWC7120
	IP="192.168.28.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl238@radiopopular.pt"
	XeroxWorkCentre7232
	}

function getMaia () {
	local="Maia"
	peso="3,39"
	IP="192.168.73.80"
	sector="Loja"
	dataInstalacao="01/11/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl007@radiopopular.pt"
	XeroxWC7120
	IP="192.168.73.82"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl007@radiopopular.pt"
	XeroxWorkCentre7242
	IP="192.168.72.86"
	sector="TIC"
	dataInstalacao="01/11/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="suporte.tic@radiopopular.pt"
	XeroxWC7120
	}

function getMarshopping () {
	local="Marshopping"
	peso="5,34"
	IP="192.168.68.80"
	sector="Loja"
	dataInstalacao="01/11/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl144@radiopopular.pt"
	XeroxWC7120
	IP="192.168.69.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl144@radiopopular.pt"
	XeroxWorkCentre7242
	IP="192.168.69.132"
	sector="SPV"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl144@radiopopular.pt"
	XeroxPhaser3635MFP
	}

function getMondego () {
	local="Mondego"
	peso="2,64"
	IP="192.168.30.80"
	sector="Loja"
	dataInstalacao="01/11/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl030@radiopopular.pt"
	XeroxWC7120
	IP="192.168.30.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl030@radiopopular.pt"
	XeroxWorkCentre7242
	}

function getMontijo () {
	local="Montijo"
	peso="2,27"
	IP="192.168.35.80"
	sector="Loja"
	dataInstalacao="01/18/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl035@radiopopular.pt"
	XeroxWC7120
	IP="192.168.35.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl035@radiopopular.pt"
	XeroxWorkCentre7242
	}

function getNorteshopping () {
	local="NorteShopping"
	peso="2,47"
	IP="192.168.9.80"
	sector="Loja"
	dataInstalacao="01/11/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl009@radiopopular.pt"
	XeroxWC7120
	IP="192.168.9.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl009@radiopopular.pt"
	XeroxWorkCentre7242
	}

function getOlivais () {
	local="Olivais"
	peso="2,87"
	IP="192.168.59.80"
	sector="Loja"
	dataInstalacao="01/20/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl146@radiopopular.pt"
	XeroxWC7120
	IP="192.168.59.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl146@radiopopular.pt"
	XeroxWorkCentre7242
	}

function getOvar () {
	local="Ovar"
	peso="2,43"
	IP="192.168.122.80"
	sector="Loja"
	dataInstalacao="01/17/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl124@radiopopular.pt"
	XeroxWC7120
	IP="192.168.122.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl124@radiopopular.pt"
	XeroxWorkCentre7242
	}

function getPortimao () {
	local="Portimão"
	peso="2,60"
	IP="192.168.117.80"
	sector="Loja"
	dataInstalacao="01/19/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl117@radiopopular.pt"
	XeroxWC7120
	IP="192.168.117.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl117@radiopopular.pt"
	XeroxWorkCentre7242
	}

function getPortoDeMos () {
	local="Porto De Mos"
	peso="1,26"
	IP="192.168.22.80"
	sector="Loja"
	dataInstalacao="10/09/2010"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl230@radiopopular.pt"
	XeroxWC7120
	IP="192.168.22.81"
	sector="Armazém"
	dataInstalacao="10/09/2010"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl230@radiopopular.pt"
	XeroxPhaser3635MFP
	}

function getSMiguel () {
	local="S. Miguel"
	peso="3,55"
	IP="192.168.40.80"
	sector="Loja"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl040@radiopopular.pt"
	XeroxWorkCentre7242
	IP="192.168.40.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl040@radiopopular.pt"
	XeroxPhaser3635MFP
	}

function getSantarem () {
	local="Santarém"
	peso="2,11"
	IP="192.168.57.80"
	sector="Loja"
	dataInstalacao="01/18/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl141@radiopopular.pt"
	XeroxWC7120
	IP="192.168.57.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl141@radiopopular.pt"
	XeroxWorkCentre7242
	}

function getSetubal () {
	local="Setúbal"
	peso="2,54"
	IP="192.168.45.80"
	sector="Loja"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl045@radiopopular.pt"
	XeroxWorkCentre7242
	IP="192.168.45.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl045@radiopopular.pt"
	XeroxPhaser3635MFP
	}

function getSintra () {
	local="Sintra"
	peso="3,61"
	IP="192.168.11.80"
	sector="Loja"
	dataInstalacao="01/23/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl011@radiopopular.pt"
	XeroxWC7120
	IP="192.168.11.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl011@radiopopular.pt"
	XeroxWorkCentre7232
	IP="192.168.11.82"
	sector="SPV"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl011@radiopopular.pt"
	XeroxPhaser3635MFP
	}

function getTerceira () {
	local="Terceira"
	peso="1,95"
	IP="192.168.111.80"
	sector="Loja"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl115@radiopopular.pt"
	XeroxWorkCentre7232
	IP="192.168.111.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl115@radiopopular.pt"
	XeroxPhaser3635MFP
	}

function getTondela () {
	local="Tondela"
	peso="1,57"
	IP="192.168.105.80"
	sector="Loja"
	dataInstalacao="01/13/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	XeroxWC7120
	IP="192.168.105.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	XeroxWorkCentre7242
	}

function getTorresNovas () {
	local="Torres Novas"
	peso="1,58"
	IP="192.168.103.80"
	sector="Loja"
	dataInstalacao="01/18/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl103@radiopopular.pt"
	XeroxWC7120
	IP="192.168.103.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl103@radiopopular.pt"
	XeroxWorkCentre7232
	}

function getViana () {
	local="Viana"
	peso="2,45"
	IP="192.168.120.80"
	sector="Loja"
	dataInstalacao="01/12/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl121@radiopopular.pt"
	XeroxWC7120
	IP="192.168.120.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl121@radiopopular.pt"
	XeroxWorkCentre7232
	}

function getVilaReal () {
	local="Vila Real"
	peso="2,48"
	IP="192.168.75.80"
	sector="Loja"
	dataInstalacao="01/13/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl075@radiopopular.pt"
	XeroxWC7120
	IP="192.168.75.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl075@radiopopular.pt"
	XeroxWorkCentre7242
	}

function getViseu () {
	local="Viseu"
	peso="3,17"
	IP="192.168.56.80"
	sector="Loja"
	dataInstalacao="01/13/2012"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl138@radiopopular.pt"
	XeroxWC7120
	IP="192.168.56.81"
	sector="Armazém"
	dataInstalacao="01/01/2009"
	diasTrabalho=$(calculaDias $dataInstalacao $dataHoje)
	responsavel="egl138@radiopopular.pt"
	XeroxWorkCentre7242
	}

## END LOCAIS ##

#				#
# Functions END #
#################

validacao
getHoje
echo -e "Local;Peso;Sector;IP;Modelo;Responsavel;Dias Trabalho;Nº Serie;ContadorCOR;ContadorPB;ContadorTOTAL"
getAlbufeira
getAlfragide
getAlverca
getArcozelo
getArmazemArcozelo
getArmazemCancela
getArmazemLoures
getArmazemMarnosso
getAveiroII
getBarreiro
getBraga
getCaldas
getCarvalhos
getDragao
getErmesinde
getFamalicao
getFaro
#getForumCoimbra
getGaia
getGranja
getGuimaraes
getLeiria
getLoures
getMadeiraCancela
getMadeiraForum
getMafra
getMaia
getMarshopping
getMondego
getMontijo
getNorteshopping
getOlivais
getOvar
getPortimao
getPortoDeMos
getSMiguel
getSantarem
getSetubal
getSintra
getTerceira
getTondela
getTorresNovas
getViana
getVilaReal
getViseu
