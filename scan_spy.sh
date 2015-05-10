#!/bin/bash
#autor j.francisco.o.rocha@gmail.com
# 2013/10

function video () {
maquina=` hotsname `
	if [[ ! -e $(which motion) ]]; then
	sudo apt-get --yes install motion
	mkdir .motion
	#sudo cp /etc/motion/motion.conf /home/francisco/.motion/motion.conf
	cd .motion
	wget --header='Host: dl.dropboxusercontent.com' --header='User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:24.0) Gecko/20100101 Firefox/24.0' --header='Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' --header='Accept-Language: pt-pt,pt;q=0.8,en;q=0.5,en-us;q=0.3' --header='Referer: https://www.dropbox.com/s/nbdn74nw0e1vvrf/motion.conf' --header='Connection: keep-alive' 'https://dl.dropboxusercontent.com/s/nbdn74nw0e1vvrf/motion.conf?token_hash=AAEcKHSfusSrEWCkMNjYvbQED755O3PR6b0y6jTHLQbRxg&dl=1' -O 'motion.conf' -c
	mkdir /home/francisco/Dropbox/ownCloud/$maquina
	sed -i 's/Motion\/1/Motion\/'$maquina'/g' /home/francisco/.motion/motion.conf
	cd ..
	sudo chown -R francisco:francisco /home/francisco/.motion
	sudo chown -R francisco:francisco /home/francisco/ownCloud/Motion
	sudo /etc/init.d/motion restart
	sudo sed -i '/exit 0/d' /etc/rc.local
	sudo echo "/usr/bin/motion" >> /etc/rc.local
	sudo echo "exit 0" >> /etc/rc.local
	fi

	if [[ ! -e $(which wxcam) ]]; then
	add-apt-repository ppa:upubuntu-com/multimedia -y && apt-get --yes update
	apt-get --yes install wxcam
	fi







	}


function audio () {
	rec -t wav - silence 1 0.1 3% -1 1.0 3% | lame - >record1.mp3

	}
