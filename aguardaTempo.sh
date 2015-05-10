#!/usr/bin/env bash
# ./aguardaTempo.sh
#

function erroAguardaTempo1 () {
	echo "Para executar tem de indicar um valor inicial e final (1 dia = 86400 segundos)"
	}

function countdown () {
        local OLD_IFS="${IFS}"
        IFS=":"
        local ARR=( $1 )
        local SECONDS=$((  (ARR[0] * 60 * 60) + (ARR[1] * 60) + ARR[2]  ))
        local START=$(date +%s)
        local END=$((START + SECONDS))
        local CUR=$START

        while [[ $CUR -lt $END ]]
        do
                CUR=$(date +%s)
                LEFT=$((END-CUR))

                printf "\r%02d:%02d:%02d" \
                        $((LEFT/3600)) $(( (LEFT/60)%60)) $((LEFT%60))
                sleep 1
        done
        IFS="${OLD_IFS}"
        echo "        "
}

function teste () {

for (( i=60; i>0; i--)); do
  sleep 1 &
  printf "  $i \r"
  wait
done
	}

function aguardarTempo () {
	ati=$1
	ate=$2
	if [[ "$ati" == "" ]]; then
		erroAguardaTempo1
		exit 0
	fi
	if [[ "$ate" == "" ]]; then
		erroAguardaTempo1
		exit 0
	fi
		if [[ "$ate" > 86400 ]]; then
		erroAguardaTempo1
		exit 0
	fi
	s=`shuf -i $ati-$ate -n 1`
	h=$((($s / 3600) | bc -l ))
	s=$(($s-($h * 3600) | bc -l ))
	m=$((($s / 60) | bc -l ))
	s=$(($s-($m * 60) | bc -l ))
	echo "Processamento suspenso durante: $(printf "\n%02d:%02d:%02d"  $h  $m  $s)"
	echo "Tempo em falta para retomar:"
	#countdown $(printf "%02d:%02d:%02d"  $h  $m  $s)
	teste
	}

aguardarTempo $1 $2
