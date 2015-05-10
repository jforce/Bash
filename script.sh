#!/usr/bin/env bash

function __DOWNLOAD {
	# Esta funcação descarrega ficheiros via wget com interface zenity deixando o ficheiro na pasta onde foi invocado o comando
	rand="$RANDOM `date`"
	pipe="/tmp/pipe.`echo '$rand' | md5sum | tr -d ' -'`"
	mkfifo $pipe
	cd ~/
	wget -c $1 2>&1 | while read data;do
		if [ "`echo $data | grep '^Length:'`" ]; then
			total_size=`echo $data | grep "^Length:" | sed 's/.*\((.*)\).*/\1/' |	tr -d '()'`
		fi
		if [ "`echo $data | grep '[0-9]*%' `" ];then
			percent=`echo $data | grep -o "[0-9]*%" | tr -d '%'`
			current=`echo $data | grep "[0-9]*%" | sed 's/\([0-9BKMG.]\+\).*/\1/' `
			speed=`echo $data | grep "[0-9]*%" | sed 's/.*\(% [0-9BKMG.]\+\).*/\1/' | tr -d ' %'`
			remain=`echo $data | grep -o "[0-9A-Za-z]*$" `
			echo $percent
			echo "# $2\n$current de $total_size ($percent%)\nVelocidade: $speed/Sec\nTempo restante: $remain"
		fi
	done > $pipe &
	wget_info=`ps ax |grep "wget.*$1" |awk '{print $1"|"$2}'`
	wget_pid=`echo $wget_info|cut -d'|' -f1 `
	zenity --progress --auto-close --text="Ligando...\n\n\n" --width="350" --title="Descarregando"< $pipe
	if [ "`ps -A |grep "$wget_pid"`" ];then
		kill $wget_pid
	fi
	rm -f $pipe
	}


		cpu64=` grep flags /proc/cpuinfo | grep " lm " `
		echo $cpu64
		if [[ $cpu64 == "" ]]; then
			__DOWNLOAD "https://dl.dropboxusercontent.com/s/2wxpbn9yvupfhnh/32_librtmp.so.0?dl=1&token_hash=AAHVkKlCKBzPY9MmnAqJR8CTM3Hd_kAJCrha3Vsnj0wZwQ" librtmp.so.0
			exit 0
			mv -f "32_librtmp.so.0?w=AABvxj_8AQju5ZjGrsi2Zxr17NBEiQEj2ihrovq3_L85eQ&dl=1" librtmp.so.0
			mv -f librtmp.so.0 /usr/lib/i386-linux-gnu/librtmp.so.0
		else
			__DOWNLOAD "https://dl.dropboxusercontent.com/s/na5291nnbjswjn6/64_librtmp.so.0?dl=1&token_hash=AAE31sqosAUMt3bmsUqn0pi512hzSRZA2Z2-6lMYZcQaOg" librtmp.so.0
			exit 0
			mv -f "64_librtmp.so.0?w=AADKa3wDtx3ZRE7Sea4_LjswzPcSDxI8oYpE6P5Bvy8Xdw&dl=1" librtmp.so.0
			mv -f librtmp.so.0 /usr/lib/x86_64-linux-gnu/librtmp.so.0
			__DOWNLOAD "https://dl.dropboxusercontent.com/s/2wxpbn9yvupfhnh/32_librtmp.so.0?dl=1&token_hash=AAHVkKlCKBzPY9MmnAqJR8CTM3Hd_kAJCrha3Vsnj0wZwQ" librtmp.so.0
			mv -f "32_librtmp.so.0?w=AABvxj_8AQju5ZjGrsi2Zxr17NBEiQEj2ihrovq3_L85eQ&dl=1" librtmp.so.0
			mv -f librtmp.so.0 /usr/lib/i386-linux-gnu/librtmp.so.0
		fi
