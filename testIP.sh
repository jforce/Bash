#!/usr/bin/env bash
 #
 #      testIP.sh
 #
 #      Copyright 2012 Francisco Rocha <j.francisco.o.rocha@gmail.com>
 #
 #      This program is free software; you can redistribute it and/or modify
 #      it under the terms of the GNU General Public License as published by
 #      the Free Software Foundation; either version 2 of the License, or
 #      (at your option) any later version.
 #
 #      This program is distributed in the hope that it will be useful,
 #      but WITHOUT ANY WARRANTY; without even the implied warranty of
 #      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 #      GNU General Public License for more details.
 #
 #      You should have received a copy of the GNU General Public License
 #      along with this program; if not, write to the Free Software
 #      Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 #      MA 02110-1301, USA.
 #
 #
 #

######################
# tput capabilities: #
######################
#
#*** tput Colour Capabilities ***
# tput setab [1-7]	Set a background colour using ANSI escape
# tput setb [1-7]		Set a background colour
# tput setaf [1-7]	Set a foreground colour using ANSI escape
# tput setf [1-7]		Set a foreground colour

#*** tput Text Mode Capabilities ***
# tput bold		Set bold mode
# tput dim		Turn on half-bright mode
# tput smul		Begin underline mode
# tput rmul		exit underline mode
# tput rev		Turn on reverse mode
# tput smso		Enter standout mode (bold on rxvt)
# tput rmso		Exit standout mode
# tput sgr0		Turn off all attributes (doesn't work quite as expected)

#*** tput Cursor Movement Capabilities ***
# tput cup Y X	Move cursor to screen location X,Y (top left is 0,0)
# tput sc			Save the cursor position
# tput rc			Restore the cursor position
# tput lines		Output the number of lines of the terminal
# tput cols		Output the number of columns of the terminal
# tput cub N		Move N characters left
# tput cuf N		Move N characters right
# tput cub1		Move left one space
# tput cuf1		Non-destructive space (move right one space)
# tput ll			Last line, first column (if no cup)
# tput cuu1		Up one line

#*** tput Clear and Insert Capabilities ***
# tput ech N		Erase N characters
# tput clear		Clear screen and home cursor
# tput el1		Clear to beginning of line
# tput el			Clear to end of line
# tput ed			Clear to end of screen
# tput ich N		Insert N characters (moves rest of line forward!)
# tput il N		Insert N lines
################################################

# EXISTE IP?
function ip_not_null () {
	local  ip=$1
	local  stat=1

	if [[ $ip != "" ]]; then
	stat=$?
	fi
	return $stat
	}

# IP VALIDO?
function ip_valid () {
	local  ip=$1
	local  stat=1

	if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
		OIFS=$IFS
		IFS='.'
		ip=($ip)
		IFS=$OIFS
		[[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
			&& ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
		stat=$?
	fi
	return $stat
}

# IP ON OU OFF?
ip_on_off () {
	local  ip=$1
	local  stat=1

	ping -c 1 -W 2 $ip &> /dev/null
	stat=$?
	return $stat
}

ip_test () {
	#ips='
		#4.2.2.2
		#a.b.c.d
		#192.168.1.1
		#0.0.0.0
		#255.255.255.255
		#255.255.255.256
		#192.168.0.1
		#192.168.0
		#1234.123.123.123
		#'
	ips=( `echo "$@"`)

	for ip in ${ips[@]}
	do
	if ip_valid $ip; then
		if ip_on_off $ip; then
		#echo -e '\E[0;32m\033[1m'" ON:$ip"'\033[0m'
		#echo -e " ON:$ip"
		echo "`tput setaf 2;tput smso` ON:$ip `tput rmso;tput setaf 7`"
		else
		#echo -e '\E[0;31m\033[1m'"OFF:$ip"'\033[0m'
		#echo -e "OFF:$ip"
		echo "`tput setaf 1;tput smso` OFF:$ip `tput rmso;tput setaf 7`"
		fi
	else
	#echo -e '\E[0;33m\033[1m'"BAD:$ip"'\033[0m'
	echo -e "BAD:$ip"
	fi
	done
}

ip_test "$@"
