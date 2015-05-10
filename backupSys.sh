#!/bin/bash
#
# Author: Martin Matusiak <numerodix@gmail.com>
# Licensed under the GNU Public License, version 3.

backup_dir=/backup
num_backups=1


verbose="$@"
lists=$backup_dir/*.lst
ext=tgz
date_params="%Y-%m-%d-%H%M"
nice_val="nice -n20"

# colors
wh="\e[1;37m"
pl="\e[m"
ye="\e[1;33m"
cy="\e[1;36m"
re="\e[1;31m"

if [[ "$verbose" && "$verbose" != "-v" ]]; then
	echo "Usage:  $0 [-v]"
	exit 1
fi

if [ ! -d $backup_dir ]; then
	echo -e "${re}Backup dir $backup_dir does not exist.${pl}"; exit 1
fi


for list in $(ls $lists); do
	name=$(basename $list .lst)
	file_root=$backup_dir/$name.$(date +$date_params)
	
	stdout="1> /dev/null"
	stderr="2> $file_root.$ext.err"
	if [ "$verbose" ]; then
		stdout=""
	fi

	cmd="cat $list | $nice_val xargs tar zlcfv \
		$file_root.$ext $stderr | tee $file_root.$ext.log $stdout"

	trap 'echo -e "${re}Received exit signal${pl}"; exit 1' INT TERM

	echo " * Running \`$name\` job..."
	if [ "$verbose" ]; then echo -e ${ye}$cmd${pl}; fi
	echo -en $cy; bash -c "$cmd" ; echo -en $pl
	status_code=$?

	if [ $status_code -gt 0 ]; then
		# Dump error log
		echo -en $re ; cat $file_root.$ext.err
		echo -en $pl ; echo "Tar exit code: $status_code"
	else
		# Kill error file
		rm $file_root.$ext.err
	fi

	# Evict old backups we don't want to keep
	num=$num_backups
	for evict in $(ls -t $backup_dir/$name.*.$ext); do
		if [ $num -le 0 ]; then 
			rm -f "$evict"
		else
			num=$(($num-1))
		fi
	done

	# Report number of files in backup
	echo -n "$(wc -l < $file_root.$ext.log) files"
	echo ", $(ls -l $file_root.$ext | awk '{ print $5 }') bytes"

done
