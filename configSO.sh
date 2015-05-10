#!/usr/bin/env bash
#./config_xubuntu12.xx.sh
# http://www.wtfpl.net/showcase/


#Ubuntu Versions INI
#
#cat /etc/lsb-release
#lsb_release -d
#which should give you the the description including the OS name ("Ubuntu" on an Ubuntu system) and the release number.
#lsb_release -c
#will give you just the codename (e.g., "precise" for Ubuntu 12.04 LTS).
#lsb_release -r
#For the release number only, use
#lsb_release -a
#For all lsb version details, use
#
#2.01 Ubuntu 4.10 (Warty Warthog)
#2.02 Ubuntu 5.04 (Hoary Hedgehog)
#2.03 Ubuntu 5.10 (Breezy Badger)
#2.04 Ubuntu 6.06 LTS (Dapper Drake)
#2.05 Ubuntu 6.10 (Edgy Eft)
#2.06 Ubuntu 7.04 (Feisty Fawn)
#2.07 Ubuntu 7.10 (Gutsy Gibbon)
#2.08 Ubuntu 8.04 LTS (Hardy Heron)
#2.09 Ubuntu 8.10 (Intrepid Ibex)
#2.10 Ubuntu 9.04 (Jaunty Jackalope)
#2.11 Ubuntu 9.10 (Karmic Koala)
#2.12 Ubuntu 10.04 LTS (Lucid Lynx)
#2.13 Ubuntu 10.10 (Maverick Meerkat)
#2.14 Ubuntu 11.04 (Natty Narwhal)
#2.15 Ubuntu 11.10 (Oneiric Ocelot)
#2.16 Ubuntu 12.04 LTS (Precise Pangolin)
#2.20 Ubuntu 12.10 (Quantal Quetzal)
#2.20 Ubuntu 13.04 (Raring Ringtail)
#3.20 Ubuntu 13.10 (Saucy Salamander)
#Ubuntu Versions END


# MENU INI
	if [ "$1" == "" ]; then
		echo "Menu:"
		cat $0 | grep function | sed -e 's/function//g' | sed -e 's/ () {//g' | sed /grep/d | sed /__/d > /tmp/menu
		menu=(`cat /tmp/menu | sort -d`)
		for value in "${menu[@]}"; do
			printf "%-8s\n" "${value}"
		done | column
		echo ""
		exit 0
	fi
# MENU END

function __REQUISITOS () {
	if [ "$(id -u)" != "0" ]; then
		echo "Tem de executar este script como Super User!"
		exit 0
	fi
	if [[ ! -e $(which lynx) ]]; then
	apt-get --yes install lynx zenity
	fi
	if [[ ! -e $(which ppa-purge) ]]; then
	apt-get --yes install ppa-purge
	fi
	if [[ ! -e $(which zenity) ]]; then
	apt-get --yes install zenity
	fi

	}

function __DOWNLOAD {
	# Esta funcação descarrega ficheiros via wget com interface zenity deixando o ficheiro na pasta onde foi invocado o comando
	rand="$RANDOM `date`"
	pipe="/tmp/pipe.`echo '$rand' | md5sum | tr -d ' -'`"
	mkfifo $pipe
	cd ~/
	wget -c --output-document=$2 $1 2>&1 | while read data;do
		if [ "`echo $data | grep '^Length:'`" ]; then
			total_size=`echo $data | grep "^Length:" | sed 's/.*\((.*)\).*/\1/' |	tr -d '()'`
		fi
		if [ "`echo $data | grep '[0-9]*%' `" ];then
			percent=`echo $data | grep -o "[0-9]*%" | tr -d '%'`
			current=`echo $data | grep "[0-9]*%" | sed 's/\([0-9BKMG.]\+\).*/\1/' `
			speed=`echo $data | grep "[0-9]*%" | sed 's/.*\(% [0-9BKMG.]\+\).*/\1/' | tr -d ' %'`
			remain=`echo $data | grep -o "[0-9A-Za-z]*$" `
			echo $percent
			echo "# $1\n$current de $total_size ($percent%)\nVelocidade: $speed/Sec\nTempo restante: $remain"
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

function __WAITKEY () {
    read -t 10 -p "[Ctrl][C] Aborta, [ENTER] Continua, (10 seg Continua...)"
    echo -e "\nContinuando ..."
    }

function __USER () {

utilizador="francisco"
grupo="francisco"
echo -e "Para todos os efeitos este script vai considerar"
echo -e "como utilizador default: $utilizador"
echo -e "como grupo default: $grupo"
__WAITKEY

	}

function i_minitube () {
	if [[ ! -e $(which minitube) ]]; then
	__REQUISITOS
	add-apt-repository ppa:nilarimogard/webupd8 -y && apt-get --yes update
	apt-get --yes install minitube
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	echo "Aplicação para ver e descarregar do Youtube"
	}

function i_owncloud () {
	echo "http://software.opensuse.org/download/package?project=isv:ownCloud:community&package=owncloud"
	sh -c "echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/community/xUbuntu_12.04/ /' >> /etc/apt/sources.list.d/owncloud.list"
	wget http://download.opensuse.org/repositories/isv:ownCloud:community/xUbuntu_12.04/Release.key
	sudo apt-key add - < Release.key
	apt-get update
	apt-get --yes install owncloud
	}

function m_mp3splt () {
	if [[ ! -e $(which mp3splt) ]]; then
	__REQUISITOS
	apt-get --yes update
	apt-get --yes install mp3splt mp3splt-gtk
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	echo "Aplicação para ver e descarregar do Youtube"
	}


function i_torrent () {
	if [[ ! -e $(which transmission) ]]; then
	__REQUISITOS
	apt-get --yes install transmission
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	echo "Aplicação para ver e descarregar Torrents"
	}

function s_tuxonice () {
	if [[ ! -e $(which tuxonice-userui) ]]; then
	__REQUISITOS
	add-apt-repository ppa:tuxonice/ppa -y && apt-get --yes update
	apt-get --yes install tuxonice-userui linux-generic-tuxonice linux-headers-generic-tuxonice
	ln -s /usr/lib/tuxonice-userui/tuxoniceui /usr/local/sbin/tuxoniceui_text
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	echo "Aplicação para colocar o pc em hibernação e modo suspenso"
	}

function __off_m_picasa () {
	apt-get --yes install wine xscanimage cabextract
	zenity --info --text "We need to install some files and make some configurations for Picasa to work fine, ok?"
	__DOWNLOAD "http://dl.google.com/picasa/picasa39-setup.exe" picasa39-setup.exe
	zenity --info --text 'Now we are going fix enviroment.'

	env WINEARCH=win32 WINEPREFIX=~/.tmp winecfg | zenity --progress --auto-close --text="This is needed to login correctly at Google.\n\n This can take a few minutes, please be patient." --title="Run Wine CFG"
	env WINEARCH=win32 WINEPREFIX=~/.tmp winetricks wininet | zenity --progress --auto-close --text="This is needed to login correctly at Google.\n\n This can take a few minutes, please be patient." --title="Installing WinInet in wine"
	env WINEARCH=win32 WINEPREFIX=~/.tmp winetricks ie7 | zenity --progress --auto-close --text="This is needed to login correctly at Google.\n\n This can take a few minutes, please be patient." --title="Installing IE7 in wine"
	zenity --info --text 'Now we are going to install Picasa, please do UNCHECK "Run Picasa 3" at the end of this process.'
	wine ~/picasa39-setup.exe
	cp -r ~/.tmp/* ~/.wine/
	touch ~/.firstpicasarun
	zenity --question --text "Finished! Do you want to open Picasa now?" && wine ~/.wine/drive_c/Program\ Files\ \(x86\)/Google/Picasa3/Picasa3.exe
	exit 0
	}

function s_playonlinux () {

	if [[ ! -e $(which playonlinux) ]]; then
	__REQUISITOS

#2.12 Ubuntu 10.04 LTS (Lucid Lynx)
#2.13 Ubuntu 10.10 (Maverick Meerkat)
#2.14 Ubuntu 11.04 (Natty Narwhal)

	wget -q "http://deb.playonlinux.com/public.gpg" -O- | apt-key add -

	#For the Natty version
	wget http://deb.playonlinux.com/playonlinux_natty.list -O /etc/apt/sources.list.d/playonlinux.list

	#For the Maverick version
	wget http://deb.playonlinux.com/playonlinux_maverick.list -O /etc/apt/sources.list.d/playonlinux.list

	#For the Lucid version
	wget http://deb.playonlinux.com/playonlinux_lucid.list -O /etc/apt/sources.list.d/playonlinux.list

	apt-get update
	apt-get --yes install curl playonlinux
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	echo "Aplicação para ver executar aplicações Ms Windows"
	}

function m_cheese () {
	if [[ ! -e $(which cheese) ]]; then
	__REQUISITOS
	apt-get --yes install cheese
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	echo "Aplicação para usar a webcam"
	}

function m_ipod () {
	if [[ ! -e $(which gtkpod) ]]; then
	__REQUISITOS
	apt-get --yes install gtkpod gpixpod
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	echo "Aplicação para dar suporte ao iPod"
	}

function s_git () {
	__REQUISITOS
	apt-get --yes install git
	echo "Aplicação para usar os repositorios GIT"
	}

function s_samba () {
	__REQUISITOS
	apt-get --yes install system-config-samba
	gksudo system-config-samba
	echo "Aplicação para dar suporte a partilhas de rede do MS Windows"
	}

function s_shellcheck () {
	__REQUISITOS
	apt-get --yes install cabal-install
	cabal update
	cabal install cabal-install
	__DOWNLOAD https://github.com/koalaman/shellcheck/archive/master.zip shellcheck.zip
	unzip shellcheck.zip -d /home/$utilizador/
	echo "Aplicação para dar verificar Bash Scripts"
	}

function s_vim () {
	__REQUISITOS
	apt-get --yes install vim-nox vim-gtk vim-addon-manager vim-latexsuite vim-scripts vim-vimoutliner vim-common vim-doc vim-gui-common
	s_git
	echo "Execute ~/ownCloud/Linux/OsMeusScripts/sp13-vim.sm "
	echo "Para actualizar execute novamente o mesmo comando."
	echo "Aplicação para expandir as capacidades do vi"
	}

function s_ntp () {
	__REQUISITOS
	apt-get --yes install ntp
	echo -e "Vai ser aberto o ficheiro de configuração do NTP"
	echo -e "Depois de realizar as alterações necessárias, grave e saia da janela de edição"
	__WAITKEY
	nano /etc/ntp.conf
	service ntp restart
	ntpq -c lpeer
	}

function s_aptfast () {
	if [[ ! -e $(which apt-fast) ]]; then
	__REQUISITOS
	add-apt-repository ppa:apt-fast/stable -y && apt-get --yes update
	apt-get --yes install apt-fast
	echo "Para reconfigurar execute [sudo dpkg-reconfigure apt-fast]"
	echo "Utilização:"
	echo "apt-fast install package"
	echo "apt-fast remove package"
	echo "apt-fast update"
	echo "apt-fast upgrade"
	echo "apt-fast dist-upgrade"
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	echo "Aplicação para ver e descarregar Torrents"
	}

function s_vim_cobol () {
	if [ ! -e /home/$utilizador/.vim/bundle/cobol.vim ]; then
	mkdir -p /home/$utilizador/.vim/bundle/cobol.vim
	fi

	git clone https://github.com/fsouza/cobol.vim.git /home/$utilizador/.vim/bundle/cobol.vim
	echo Bundle \'color.vim\' >> ~/.vimrc.bundles.local
	echo "Aplicação para dar suporte a sintaxe COBOL no vim"
	}

function i_pidgin  () {
	if [[ ! -e $(which pidgin ) ]]; then
	__REQUISITOS
	add-apt-repository pidgin-developers/ppa -y && apt-get --yes update
	apt-get --yes install pidgin
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	echo "Aplicação para falar no Facebook"
	}

function i_popper () {
	if [[ ! -e $(which popper) ]]; then
	__REQUISITOS
	add-apt-repository ppa:ralf.hersel/rhersel-ppa -y && apt-get --yes update
	apt-get --yes install popper
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	echo "Aplicação para notificar novos emails"
	}

function s_qwbfsmanager () {
	if [[ ! -e $(which qwbfsmanager) ]]; then
	__REQUISITOS
	apt-get --yes install qwbfsmanager
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	echo "Aplicação para emular a Wii"
}

function s_dolphin () {
	if [[ ! -e $(which dolphin-emu) ]]; then
	__REQUISITOS
	# ubuntu > 12.04
	#add-apt-repository ppa:glennric/dolphin-emu -y && apt-get --yes update
	#apt-get --yes install dolphin-emu
	# INI ubuntu = 12.04
	add-apt-repository ppa:kalakris/cmake -y
	add-apt-repository ppa:ubuntu-toolchain-r/test -y && apt-get --yes update
	apt-get --yes install make cmake gcc-4.8 git g++-4.8 libgtk2.0-dev libsdl1.2-dev libxrandr-dev libxext-dev libao-dev libasound2-dev libpulse-dev libbluetooth-dev libreadline-gplv2-dev libavcodec-dev libavformat-dev libswscale-dev
	cd /usr/bin
	rm gcc
	rm g++
	sudo ln -s gcc-4.8 /usr/bin/gcc
	sudo ln -s g++-4.8 /usr/bin/g++
	cd /opt
	git clone https://code.google.com/p/dolphin-emu/ dolphin-emu
	cd dolphin-emu
	mkdir Build
	cd Build
	cmake ..
	make
	make install
	# END ubuntu = 12.04
	s_qwbfsmanager
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	echo "Aplicação para emular a Wii"
	}


function s_burg () {
	if [[ ! -e $(which burg) ]]; then
	__REQUISITOS
	add-apt-repository ppa:n-muench/burg -y && apt-get --yes update
	apt-get --yes install burg burg-themes
	burg-install "(hd0)"
	update-burg
	burg-emu
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	echo "Aplicação para subtituir o grub"
	}

function s_diskusage () {
	if [[ ! -e $(which xdiskusage) ]]; then
	__REQUISITOS
	apt-get --yes install xdiskusage baobab
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	echo "Aplicação para ver graficamente a utilização do disco"
	}

function i_ftpserver () {
	if [[ ! -e $(which proftpd) ]]; then
	__REQUISITOS
	apt-get --yes install proftpd
	sed -i 's/# DefaultRoot/DefaultRoot/g' /etc/proftpd/proftpd.conf
	/etc/init.d/proftpd stop
	/etc/init.d/proftpd start
	/etc/init.d/proftpd restart
	proftpd -td5
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	echo "Aplicação para emular sistemas operativos"
	}


function i_ftp_paparoka () {
	if mount | grep /media/ftp_paparoka > /dev/null; then
	__REQUISITOS
		umount /media/ftp_paparoka
	else
		if [[ ! -e $(which curlftpfs) ]]; then
		__REQUISITOS
		apt-get --yes install curlftpfs
		mkdir -p /media/ftp_paparoka
		chmod -R 777 /media/ftp_paparoka
		curlftpfs -o allow_other paparoka:3ci35mO4Im@ftp.paparoka.com /media/ftp_paparoka
		else
		mkdir -p /media/ftp_paparoka
		chmod -R 777 /media/ftp_paparoka
		curlftpfs -o allow_other paparoka:3ci35mO4Im@ftp.paparoka.com /media/ftp_paparoka
		fi
	fi
	echo "Aplicação para montar o ftp do paparoka"
	}

function s_qemu () {
	if [[ ! -e $(which burg) ]]; then
	__REQUISITOS
	apt-get --yes install qemu-system aqemu
	kvm-ok
	echo "Adicionar -usbdevice tablet a maquina se der problemas com o rato"
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	echo "Aplicação para emular sistemas operativos"
	}

function s_elementaryos () {
    __REQUISITOS
	sudo add-apt-repository ppa:versable/elementary-update -y && sudo apt-get --yes update
	sudo apt-get --yes upgrade
	sudo apt-get --yes install elementary-tweaks indicator-synapse elementary-blue-theme elementary-champagne-theme elementary-colors-theme elementary-dark-theme elementary-harvey-theme elementary-lion-theme elementary-milk-theme elementary-plastico-theme elementary-whit-e-theme elementary-elfaenza-icons elementary-emod-icons elementary-enumix-utouch-icons elementary-nitrux-icons elementary-taprevival-icons elementary-wallpaper-collection elementary-thirdparty-icons elementary-plank-themes
	}

function s_flash () {
	clear &&
	echo 'Installing Flash for Midori and Firefox' &&
	read -p 'Press Enter to continue, or abort by pressing CTRL+C' nothing &&
	mkdir -p ~/.mozilla/plugins &&
	wget http://fpdownload.macromedia.com/get/flashplayer/pdc/11.2.202.310/install_flash_player_11_linux.i386.tar.gz &&
	tar -zxvf install_flash_player_11_linux.i386.tar.gz libflashplayer.so &&
	rm install_flash_player_11_linux.i386.tar.gz &&
	if [ $(getconf LONG_BIT) = '64' ]
	then
		mv libflashplayer.so ~/.mozilla/plugins/libflashplayer.32.so &&
		sudo apt-get install nspluginwrapper ia32-libs
	else
		mv libflashplayer.so ~/.mozilla/plugins/libflashplayer.so &&
		sudo apt-get install nspluginwrapper
	fi &&
	nspluginwrapper -a -v -n -i
	firefox "https://www.adobe.com/software/flash/about/"
	}

function m_pinta () {
	if [[ ! -e $(which pinta) ]]; then
	__REQUISITOS
	add-apt-repository ppa:pinta-maintainers/pinta-stable -y && apt-get --yes update
	apt-get --yes upgrade
	apt-get --yes install pinta
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	echo "Aplicação para desenho alternativa ao simples ao Gimp"
	}

function m_soundconverter () {
	if [[ ! -e $(which soundconverter) ]]; then
	__REQUISITOS
	apt-get --yes install soundconverter
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	echo "Aplicação para converter ficheiros de audio"
	}

function m_mediaelch () {
	if [[ ! -e $(which mediaelch) ]]; then
	__REQUISITOS
	add-apt-repository ppa:kvibes/mediaelch -y && apt-get --yes update
	apt-get --yes install mediaelch
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	echo "Aplicação para converter ficheiros de audio"
	}

function m_canon () {
	__REQUISITOS
	apt-get --yes install gphoto2 gthumb gpicview
	echo "Detectar Camara"
	echo "gphoto2 --auto-detect"
	echo "Descarregar photos"
	echo "gphoto2 --get-all-files"
	echo "Aplicação para dar surporte as camaras da Canon"
	}

function s_inetutils () {
	__REQUISITOS
	apt-get --yes install inetutils*
	echo "Aplicação para instalar:"
	echo "inetutils-ftp inetutils-ftpd inetutils-inetd inetutils-ping"
	echo "inetutils-syslogd inetutils-talk inetutils-talkd inetutils-telnet"
	echo "inetutils-telnetd inetutils-tools inetutils-traceroute libshishi0"
	echo "shishi-common"
	}

function s_android () {
	__REQUISITOS
	echo "Verique que o MTP esta activo e ligue o seu android via USB ao PC"
	echo "antes de executar esta configuração"
	apt-get --yes install mtp-tools mtpfs

	VENDORID=` mtp-detect 2>1 | grep idVendor | awk -F':' '{ print $2}' | sed -e 's/ //g'`
	PRODUCTID=` mtp-detect 2>1 | grep idProduct  | awk -F':' '{ print $2}' | sed -e 's/ //g'`
	echo "SUBSYSTEM==\"usb\", ATTR{idVendor}==\"$VENDORID\", ATTR{idProduct}==\"$PRODUCTID\", MODE=\"0666\"" >> /etc/udev/rules.d/51-android.rules
	service udev restart
	mkdir -p /media/Android
	chmod a+rwx /media/Android
	adduser $utilizador fuse
	sed -i 's/#user_allow_other/user_allow_other/g' /etc/fuse.conf
	echo "alias android-connect=\"mtpfs -o allow_other /media/Android\"" >> ~/.bashrc
	echo "alias android-disconnect=\"fusermount -u /media/Android\"" >> ~/.bashrc
	URL=http://images2.wikia.nocookie.net/__cb20110814161053/ladygaga/images/c/cc/Android_logo.png
	#URL="http://www.userlogos.org/files/logos/Diabell/Android iPhone glass icon style cut.png"
	lynx -connect_timeout=10 --source ${URL} > /usr/share/pixmaps/android_logo.png 2> /dev/null
	mkdir -p /home/$utilizador/Scripts
	echo "[Desktop Entry]" > /home/$utilizador/Scripts/Montar\ Android.desktop
	echo "Version=1.0" >> /home/$utilizador/Scripts/Montar\ Android.desktop
	echo "Type=Application" >> /home/$utilizador/Scripts/Montar\ Android.desktop
	echo "Name=Montar Android" >> /home/$utilizador/Scripts/Montar\ Android.desktop
	echo "Comment=Montar Android" >> /home/$utilizador/Scripts/Montar\ Android.desktop
	echo "Exec=mtpfs -o allow_other /media/Android" >> /home/$utilizador/Scripts/Montar\ Android.desktop
	echo "Icon=/usr/share/pixmaps/android_logo.png" >> /home/$utilizador/Scripts/Montar\ Android.desktop
	echo "Path=" >> /home/$utilizador/Scripts/Montar\ Android.desktop
	echo "Terminal=false" >> /home/$utilizador/Scripts/Montar\ Android.desktop
	echo "StartupNotify=false" >> /home/$utilizador/Scripts/Montar\ Android.desktop
	echo "[Desktop Entry]" > /home/$utilizador/Scripts/Desmontar\ Android.desktop
	echo "Version=1.0" >> /home/$utilizador/Scripts/Desmontar\ Android.desktop
	echo "Type=Application" >> /home/$utilizador/Scripts/Desmontar\ Android.desktop
	echo "Name=Desmontar Android" >> /home/$utilizador/Scripts/Desmontar\ Android.desktop
	echo "Comment=Desmontar Android" >> /home/$utilizador/Scripts/Desmontar\ Android.desktop
	echo "Exec=fusermount -u /media/Android" >> /home/$utilizador/Scripts/Desmontar\ Android.desktop
	echo "Icon=/usr/share/pixmaps/android_logo.png" >> /home/$utilizador/Scripts/Desmontar\ Android.desktop
	echo "Path=" >> /home/$utilizador/Scripts/Desmontar\ Android.desktop
	echo "Terminal=false" >> /home/$utilizador/Scripts/Desmontar\ Android.desktop
	echo "StartupNotify=false" >> /home/$utilizador/Scripts/Desmontar\ Android.desktop
	chown $utilizador:$grupo /home/$utilizador/Scripts/Desmontar\ Android.desktop
	chown $utilizador:$grupo /home/$utilizador/Scripts/Montar\ Android.desktop
	echo ""
	echo "Na linha de comandos"
	echo "android-connect para montar"
	echo "android-disconnect para desmontar"
	echo "Tem de reiniciar para que a configuração fique activa"
	}

function s_androidsdk () {
	__REQUISITOS
	rm -f /etc/udev/rules.d/*android*
	echo "# Google Android Device" > /etc/udev/rules.d/99-android.rules
	echo "SUBSYSTEM==\"usb\", ATTR{idVendor}==\"20d1\", ATTR{idProduct}==\"4e42\", MODE=\"0666\", OWNER=\"$utilizador\"    # MTP mode with USB debug on" >> /etc/udev/rules.d/99-android.rules
	#add-apt-repository ppa:nilarimogard/webupd8 -y && apt-get update
	#apt-get --yes install android-tools-adb android-tools-fastboot
	__DOWNLOAD "http://dl.google.com/android/adt/adt-bundle-linux-x86-20130729.zip" adt-bundle-linux-x86-20130729.zip
	unzip adt-bundle-linux-x86-20130729.zip -d /home/$utilizador/
	mv /home/$utilizador/adt-bundle-linux-x86-20130729 /home/$utilizador/AndroidSDK
	rm -f adt-bundle-linux-x86-20130729.zip
	cd /home/$utilizador/AndroidSDK/sdk/tools
	./android sdk
	apt-get install libqtgui4 libqt4-network libqt4-declarative
	__DOWNLOAD "http://motyczko.pl/qtadb/QtADB_0.8.1_linux32.tar.gz" QtADB_0.8.1_linux32.tar.gz
	tar -vxf QtADB_0.8.1_linux32.tar.gz -C /home/$utilizador/AndroidSDK/
	cd /home/$utilizador/AndroidSDK/QtADB_0.8.1_linux32
	chmod +x *
	rm -f /home/$utilizador/AndroidSDK/sdk/tools/QtADB_0.8.1_linux32.tar.gz
	chown -R $utilizador:$grupo /home/$utilizador/AndroidSDK
	}

function s_radeon3xxx () {
	__REQUISITOS
	apt-get -yes purge fglrx-amdcccle-legacy fglrx-legacy-dev fglrx-legacy
	rm -R /usr/lib/fglrx
	rm -R /usr/share/ati
	add-apt-repository ppa:makson96/fglrx -y && apt-get update
	apt-get --yes upgrade
	apt-get --yes install fglrx-legacy
	}

function s_tmnZteMf200 () {
	__REQUISITOS
	echo "ACTION!=\"add\", GOTO=\"ZTE_End\"" > /etc/udev/rules.d/10-zte.rules
	echo "# Is this the ZeroCD device?" >> /etc/udev/rules.d/10-zte.rules
	echo "SUBSYSTEM==\"usb\", SYSFS{idProduct}=="2000"," >> /etc/udev/rules.d/10-zte.rules
	echo "SYSFS{idVendor}==\"20d2\", GOTO="ZTE_ZeroCD"" >> /etc/udev/rules.d/10-zte.rules
	echo "# Is this the actual modem?" >> /etc/udev/rules.d/10-zte.rules
	echo "SUBSYSTEM==\"usb\", SYSFS{idProduct}=="1000"," >> /etc/udev/rules.d/10-zte.rules
	echo "SYSFS{idVendor}==\"20d2\", GOTO="ZTE_Modem"" >> /etc/udev/rules.d/10-zte.rules
	echo "#LABEL=\"ZTE_ZeroCD\"" >> /etc/udev/rules.d/10-zte.rules
	echo "# This is the ZeroCD part of the card, remove" >> /etc/udev/rules.d/10-zte.rules
	echo "# the usb_storage kernel module so" >> /etc/udev/rules.d/10-zte.rules
	echo "# it does not get treated like a storage device" >> /etc/udev/rules.d/10-zte.rules
	echo "#RUN+=\"/sbin/rmmod usb_storage \"" >> /etc/udev/rules.d/10-zte.rules
	echo "LABEL=\"ZTE_Modem\"" >> /etc/udev/rules.d/10-zte.rules
	echo "# This is the Modem part of the card, let's" >> /etc/udev/rules.d/10-zte.rules
	echo "# load usbserial with the correct vendor" >> /etc/udev/rules.d/10-zte.rules
	echo "# and product ID's so we get our usb serial devices" >> /etc/udev/rules.d/10-zte.rules
	echo "RUN+=\"/sbin/modprobe usbserial vendor=0x20d2 product=0x0001\"," >> /etc/udev/rules.d/10-zte.rules
	echo "# Make users belonging to the dialout group" >> /etc/udev/rules.d/10-zte.rules
	echo "# able to use the usb serial devices." >> /etc/udev/rules.d/10-zte.rules
	echo "MODE=\"660\", GROUP=\dialout\"" >> /etc/udev/rules.d/10-zte.rules
	echo "RUN+=\"/usr/bin/fixUSB\"" >> /etc/udev/rules.d/10-zte.rules
	echo "LABEL="ZTE_End"" >> /etc/udev/rules.d/10-zte.rules

	echo "#!/bin/bash" > /usr/bin/fixUSB
	echo "sudo rm /dev/ttyUSB2" >> /usr/bin/fixUSB
	echo "sudo ln -s /dev/ttyUSB3 /dev/ttyUSB2" >> /usr/bin/fixUSB

	chmod +x /usr/bin/fixUSB

	restart udev
	}

function m_easytag () {
	if [[ ! -e $(which easytag) ]]; then
	__REQUISITOS
	apt-get --yes install easytag
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function p_netbeans () {
	__REQUISITOS
	echo "O script vai instalar a versão netbeans-7.2.1"
	s_java7
	URL=http://download.netbeans.org/netbeans/7.2.1/final/bundles/netbeans-7.2.1-ml-php-linux.sh
	lynx -connect_timeout=10 --source ${URL} > /tmp/netbeans-7.2.1-ml-php-linux.sh 2> /dev/null
	chmod +x /tmp/netbeans-7.2.1-ml-php-linux.sh
	/tmp/netbeans-7.2.1-ml-php-linux.sh
	}

function p_yii () {
	__REQUISITOS
	s_lamp
	URL="http://yii.googlecode.com/files/yii-1.1.12.b600af.tar.gz"
	lynx -connect_timeout=10 --source ${URL} > /home/$utilizador/www/yii.tar.gz 2> /dev/null
	tar -vxf /home/$utilizador/www/yii.tar.gz -C /home/$utilizador/www/
	rm -rf /home/$utilizador/www/yii.tar.gz
	mv yii* yii
	mkdir -p /home/$utilizador/bin
	homebin=""
	homebin=` cat /home/$utilizador/.profile | grep "\/home/$utilizador\/bin" `
	if [[ /home/$utilizadorbin == "" ]]; then
		echo "if [ -d \"\/home/$utilizador/bin\" ] ; then" >> /home/$utilizador/.profile
		echo "	PATH=\"\/home/$utilizador/bin:$PATH\"" >> /home/$utilizador/.profile
		echo "fi" >> /home/$utilizador/.profile
	fi
	cd /home/$utilizador/bin
	ln -s /home/$utilizador/www/yii/framework/yiic yiic

	chown -R $utilizador:$grupo /home/$utilizador/www*
	}

function p_codeigniter () {
	__REQUISITOS
	s_lamp
	URL="http://ellislab.com/codeigniter/download"
	lynx -connect_timeout=10 --source ${URL} > /home/$utilizador/www/codeigniter.zip 2> /dev/null
	unzip /home/$utilizador/www/codeigniter.zip -d /home/$utilizador/www
	rm -rf /home/$utilizador/www/codeigniter.zip
	mv CodeIgni* CodeIgniter

	#URL="http://gengo.com/string/p/codeigniter-2-1/export/language/pt/1ceff34310001dff5e4a5a8002a95f8c6431cf458207b3c22b344e5354ae58a3"
	#lynx -connect_timeout=10 --source ${URL} > /home/$utilizador/www/CodeIgniter/system/language/pt.zip 2> /dev/null
	#unzip /home/$utilizador/www/CodeIgniter/system/language/pt.zip -d /home/$utilizador/www/CodeIgniter/system/language/
	#rm /home/$utilizador/www/CodeIgniter/system/language/pt.zip
	#mv /home/$utilizador/www/CodeIgniter/system/language/pt /home/$utilizador/www/CodeIgniter/system/language/portuguese

	echo -n "Nome da DB (Nome da DB = Utilizador da DB) da aplicação? "
	read name
	echo -n "Password da DB da aplicação? "
	read password

	# config.php
	sed -i "s/$config\['base_url'\]\t= ''/$config\['base_url'\]\t= 'http\:\/\/localhost\/CodeIgniter'/g" /home/$utilizador/www/CodeIgniter/application/config/config.php
	sed -i "s/$config\['encryption_key'\] = ''/$config\['encryption_key'\] = '$password'/g" /home/$utilizador/www/CodeIgniter/application/config/config.php
	#sed -i "s/$config\['language'\]\t= 'english'\;/$config\['language'\]\t= 'portuguese'\;/g" /home/$utilizador/www/CodeIgniter/application/config/config.php
	# database.php
	sed -i "s/$db\['default'\]\['username'\] = ''/$db\['default'\]\['username'\] = '$name'/g" /home/$utilizador/www/CodeIgniter/application/config/database.php
	sed -i "s/$db\['default'\]\['password'\] = ''/$db\['default'\]\['password'\] = '$password'/g" /home/$utilizador/www/CodeIgniter/application/config/database.php
	sed -i "s/$db\['default'\]\['database'\] = ''/$db\['default'\]\['database'\] = '$name'/g" /home/$utilizador/www/CodeIgniter/application/config/database.php
	sed -i "s/$db\['default'\]\['dbprefix'\] = ''/$db\['default'\]\['dbprefix'\] = 'ci'/g" /home/$utilizador/www/CodeIgniter/application/config/database.php
	# mysql
	mysql -u root -pdia20mes10 -e "CREATE DATABASE IF NOT EXISTS $name";
	mysql -u root -pdia20mes10 -e "GRANT ALL ON $name.* TO '$name'@'localhost' IDENTIFIED BY '$password' WITH GRANT OPTION";
	mysql -u root -pdia20mes10 -e "SET PASSWORD FOR '$name'@'localhost' = PASSWORD('$password');"
	mysql -u root -pdia20mes10 -e "FLUSH PRIVILEGES";

	chown -R $utilizador:$grupo /home/$utilizador/www*
	}

function s_pimp_xubuntu () {
	__REQUISITOS
	mkdir -p /home/$utilizador/.icons
	mkdir -p /home/$utilizador/.themes
	#Add IconTheme Faenza
	apt-get --yes install gtk2-engines-pixbuf
	add-apt-repository ppa:tiheum/equinox -y && apt-get update
	apt-get --yes install faenza-icon-theme
	# Add Ravefinity Project PPA
	add-apt-repository ppa:ravefinity-project/ppa -y
	# Update package information and install ambiance and radiance themes
	apt-get update && apt-get --yes install ambiance-xfce-lxde radiance-xfce-lxde
	# Install other colors variations (blue, green, purple, ...):
	apt-get --yes install ambiance-colors-xfce-lxde radiance-colors-xfce-lxde
	# Add AwOken icons
	add-apt-repository ppa:alecive/antigone -y && \
	apt-get update && \
	apt-get install awoken-icon-theme -y
	echo "Customize AwOken"
	echo "awoken-icon-theme-customization"
	# Make icon text transparent
	echo -e 'style "xfdesktop-icon-view" {' > /home/$utilizador/.gtkrc-2.0
	echo -e 'XfdesktopIconView::label-alpha = 0' >> /home/$utilizador/.gtkrc-2.0
	echo -e '' >> /home/$utilizador/.gtkrc-2.0
	echo -e 'fg[NORMAL] = "#ffffff"' >> /home/$utilizador/.gtkrc-2.0
	echo -e 'fg[SELECTED] = "#ffffff"' >> /home/$utilizador/.gtkrc-2.0
	echo -e 'fg[ACTIVE] = "#ffffff"' >> /home/$utilizador/.gtkrc-2.0
	echo -e '}' >> /home/$utilizador/.gtkrc-2.0
	echo -e '' >> /home/$utilizador/.gtkrc-2.0
	echo -e '' >> /home/$utilizador/.gtkrc-2.0
	echo -e 'widget_class "*XfdesktopIconView*" style "xfdesktop-icon-view"' >> /home/$utilizador/.gtkrc-2.0
	chown -R $utilizador:$grupo /home/$utilizador/*
}

function s_ntfs () {
	if [[ ! -e $(which ntfs-config) ]]; then
	__REQUISITOS
	apt-get --yes install ntfs-config
	mkdir -p /etc/hal/fdi/policy
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function m_tuxguitar () {
	if [[ ! -e $(which tuxguitar) ]]; then
	__REQUISITOS
	apt-get --yes install timidity tuxguitar-jsa tuxguitar
	echo-e "Tools->Settings->Sound In the MIDI Sequencer drop down list, select ‘\nReal Time Sequencer’. In the MIDI Port field, select ‘Gervill’ and \nclick on Ok. Click on Yes when it asks for confirmation."
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}



function i_email () {
echo "Instalar dependencias"
	__REQUISITOS
	apt-get --yes install msmtp sharutils mutt
	mkdir -p /home/$utilizador/.mutt/cache/
	mkdir -p /home/$utilizador/.mutt/certificates
	apt-get --yes install ca-certificates
	update-ca-certificates

echo "Criar ficheiro .msmtprc na home"
	echo -e "# config options: http://msmtp.sourceforge.net/doc/msmtp.html" > /home/$utilizador/.msmtprc
	echo -e "defaults" >> /home/$utilizador/.msmtprc
	echo -e "logfile /tmp/msmtp.log" >> /home/$utilizador/.msmtprc
	echo -e "" >> /home/$utilizador/.msmtprc
	echo -e "# radiopopular account" >> /home/$utilizador/.msmtprc
	echo -e "#account radiopopular" >> /home/$utilizador/.msmtprc
	echo -e "#host mail.radiopopular.pt" >> /home/$utilizador/.msmtprc
	echo -e "#port 25" >> /home/$utilizador/.msmtprc
	echo -e "#user franciscorocha@radiopopular.pt" >> /home/$utilizador/.msmtprc
	echo -e "#password d23m02" >> /home/$utilizador/.msmtprc
	echo -e "#from franciscorocha@radiopopular.pt" >> /home/$utilizador/.msmtprc
	echo -e "" >> /home/$utilizador/.msmtprc
	echo -e "# radiopopularssl account" >> /home/$utilizador/.msmtprc
	echo -e "account radiopopularssl" >> /home/$utilizador/.msmtprc
	echo -e "auth on" >> /home/$utilizador/.msmtprc
	echo -e "host mail.radiopopular.pt" >> /home/$utilizador/.msmtprc
	echo -e "port 587" >> /home/$utilizador/.msmtprc
	echo -e "user franciscorocha@radiopopular.pt" >> /home/$utilizador/.msmtprc
	echo -e "password d23m02" >> /home/$utilizador/.msmtprc
	echo -e "from franciscorocha@radiopopular.pt" >> /home/$utilizador/.msmtprc
	echo -e "tls on" >> /home/$utilizador/.msmtprc
	echo -e "tls_starttls on" >> /home/$utilizador/.msmtprc
	echo -e "tls_certcheck off" >> /home/$utilizador/.msmtprc
	echo -e "" >> /home/$utilizador/.msmtprc
	echo -e "# gmail account" >> /home/$utilizador/.msmtprc
	echo -e "account gmail" >> /home/$utilizador/.msmtprc
	echo -e "auth on" >> /home/$utilizador/.msmtprc
	echo -e "host smtp.gmail.com" >> /home/$utilizador/.msmtprc
	echo -e "port 587" >> /home/$utilizador/.msmtprc
	echo -e "user j.francisco.o.rocha@gmail.com" >> /home/$utilizador/.msmtprc
	echo -e "password dia20mes10jet" >> /home/$utilizador/.msmtprc
	echo -e "from j.francisco.o.rocha@gmail.com" >> /home/$utilizador/.msmtprc
	echo -e "tls on" >> /home/$utilizador/.msmtprc
	echo -e "tls_starttls on" >> /home/$utilizador/.msmtprc
	echo -e "tls_trust_file /etc/ssl/certs/ca-certificates.crt" >> /home/$utilizador/.msmtprc
	echo -e "" >> /home/$utilizador/.msmtprc
	echo -e "# set default account to use \(from above\)" >> /home/$utilizador/.msmtprc
	echo -e "account default : radiopopularssl" >> /home/$utilizador/.msmtprc
	chmod 600 /home/$utilizador/.msmtprc
	#chown $USER:$(id -g -n $USER) /home/$utilizador/.msmtprc
	chown $utilizador:$grupo /home/$utilizador/.msmtprc

echo "Criar o ficheiro .muttrc"
	echo -e "# Configurar Mutt como cliente de email para Gmail" > /home/$utilizador/.muttrc
	echo -e "#set from = \"j.francisco.o.rocha@gmail.com\"" >> /home/$utilizador/.muttrc
	echo -e "#set realname = \"Francisco Rocha\"" >> /home/$utilizador/.muttrc
	echo -e "#set imap_user = \"j.francisco.o.rocha@gmail.com\"" >> /home/$utilizador/.muttrc
	echo -e "#set imap_pass = \"dia20mes10jet\"" >> /home/$utilizador/.muttrc
	echo -e "#set folder = \"imaps://imap.gmail.com:993\"" >> /home/$utilizador/.muttrc
	echo -e "#set spoolfile = \"+INBOX\"" >> /home/$utilizador/.muttrc
	echo -e "#set postponed =\"+[Gmail]/Drafts\"" >> /home/$utilizador/.muttrc
	echo -e "#set header_cache =~/.mutt/cache/headers" >> /home/$utilizador/.muttrc
	echo -e "#set message_cachedir =~/.mutt/cache/bodies" >> /home/$utilizador/.muttrc
	echo -e "#set certificate_file =~/.mutt/certificates" >> /home/$utilizador/.muttrc
	echo -e "#set smtp_url = \"smtp://j.francisco.o.rocha@smtp.gmail.com:587/\"" >> /home/$utilizador/.muttrc
	echo -e "#set smtp_pass = \"dia20mes10jet\"" >> /home/$utilizador/.muttrc
	echo -e "#set move = no" >> /home/$utilizador/.muttrc
	echo -e "#set imap_keepalive = 900" >> /home/$utilizador/.muttrc
	echo -e "#set editor = \"nano\"" >> /home/$utilizador/.muttrc
	echo -e "#set mail_check = 120" >> /home/$utilizador/.muttrc
	echo -e "#set timeout = 300" >> /home/$utilizador/.muttrc
	echo -e "#set auto_tag = yes" >> /home/$utilizador/.muttrc
	echo -e "" >> /home/$utilizador/.muttrc
	echo -e "# Configurar Mutt como cliente de email para Radio Popular" >> /home/$utilizador/.muttrc
	echo -e "#set from = \"franciscorocha@radiopopular.pt\"" >> /home/$utilizador/.muttrc
	echo -e "#set realname = \"Francisco Rocha\"" >> /home/$utilizador/.muttrc
	echo -e "#set imap_user = \"franciscorocha@radiopopular.pt\"" >> /home/$utilizador/.muttrc
	echo -e "#set imap_pass = \"d23m02\"" >> /home/$utilizador/.muttrc
	echo -e "#set folder = \"imaps://mail.radiopopular.pt:993\"" >> /home/$utilizador/.muttrc
	echo -e "#set spoolfile = \"+INBOX\"" >> /home/$utilizador/.muttrc
	echo -e "##set postponed =\"+[Gmail]/Drafts\"" >> /home/$utilizador/.muttrc
	echo -e "#set header_cache =~/.mutt/rp/cache/headers" >> /home/$utilizador/.muttrc
	echo -e "#set message_cachedir =~/.mutt/rp/cache/bodies" >> /home/$utilizador/.muttrc
	echo -e "#set certificate_file =~/.mutt/rp/certificates" >> /home/$utilizador/.muttrc
	echo -e "#set smtp_url = \"smtp://franciscorocha@mail.radiopopular.pt:25/\"" >> /home/$utilizador/.muttrc
	echo -e "#set smtp_pass = \"d23m02\"" >> /home/$utilizador/.muttrc
	echo -e "#set move = no" >> /home/$utilizador/.muttrc
	echo -e "#set imap_keepalive = 900" >> /home/$utilizador/.muttrc
	echo -e "#set editor = \"nano\"" >> /home/$utilizador/.muttrc
	echo -e "#set mail_check = 120" >> /home/$utilizador/.muttrc
	echo -e "#set timeout = 300" >> /home/$utilizador/.muttrc
	echo -e "#set auto_tag = yes" >> /home/$utilizador/.muttrc
	echo -e "" >> /home/$utilizador/.muttrc
	echo -e "# Se não identificada a conta a usar ira ser usada" >> /home/$utilizador/.muttrc
	echo -e "# a conta default configurada na aplicação msmtp \(.msmtprc\)" >> /home/$utilizador/.muttrc
	echo -e "# mutt -s \"assunto da mensagem\" -F /home/$utilizador/.mutt/mutt_g endereço@email.qq < /tmp/test_email" >> /home/$utilizador/.muttrc
	echo -e "set sendmail=\"/usr/bin/msmtp\"" >> /home/$utilizador/.muttrc
	chmod 600 /home/$utilizador/.muttrc
	#chown $USER:$(id -g -n $USER) /home/$utilizador/.muttrc
	chown $utilizador:$grupo /home/$utilizador/.muttrc

echo "Criar ficheiro mutt_g (~/.mutt/)"
	echo -e "set sendmail=\"/usr/bin/msmtp\"" > /home/$utilizador/.mutt/mutt_g
	echo -e "set use_from=yes" >> /home/$utilizador/.mutt/mutt_g
	echo -e "set from=\"Francisco Rocha <j.francisco.o.rocha@gmail.com>\"" >> /home/$utilizador/.mutt/mutt_g
	echo -e "set envelope_from=yes" >> /home/$utilizador/.mutt/mutt_g
	#chown $USER:$(id -g -n $USER) /home/$utilizador/.mutt/mutt_g
	chown $utilizador:$grupo /home/$utilizador/.mutt/mutt_g

echo "Criar ficheiro mutt_r (~/.mutt/)"
	echo -e "set sendmail=\"/usr/bin/msmtp\"" > /home/$utilizador/.mutt/mutt_r
	echo -e "set use_from=yes" >> /home/$utilizador/.mutt/mutt_r
	echo -e "set from=\"Francisco Rocha <franciscorocha@radiopopular.pt>\"" >> /home/$utilizador/.mutt/mutt_r
	echo -e "set envelope_from=yes" >> /home/$utilizador/.mutt/mutt_r
	#chown $USER:$(id -g -n $USER) /home/$utilizador/.mutt/mutt_r
	chown $utilizador:$grupo /home/$utilizador/.mutt/mutt_r

	chmod -R 755 /home/$utilizador/.mutt
	chown -R $utilizador:$grupo /home/$utilizador/.mutt

echo "Criar script de teste: /home/$utilizador/email_test.sh"
	echo "#!/usr/bin/env bash" > /home/$utilizador/email_test.sh
	echo "echo \"Se esta a ler esta mensagem e porque tudo foi correctamente configurado\" > /tmp/teste.txt" >> /home/$utilizador/email_test.sh
	echo "echo \"Comandos usados:\" >> /tmp/teste.txt" >> /home/$utilizador/email_test.sh
	echo "echo \"mutt -s \\\"Mensagem de teste usando mutt_g\\\" -F /home/$utilizador/.mutt/mutt_g -- j.francisco.o.rocha@gmail.com < /tmp/teste.txt\" >> /tmp/teste.txt" >> /home/$utilizador/email_test.sh
	echo "echo \"mutt -s \\\"Mensagem de teste usando mutt_g\\\" -F /home/$utilizador/.mutt/mutt_r -- franciscorocha@radiopopular.pt < /tmp/teste.txt\" >> /tmp/teste.txt" >> /home/$utilizador/email_test.sh
	echo -e "echo -e \"A enviar mensagem de teste para j.francisco.o.rocha@gmail.com a partir do SMTP do GMAIL\"" >> /home/$utilizador/email_test.sh
	echo "mutt -s \"Mensagem de teste usando mutt_g\" -F /home/$utilizador/.mutt/mutt_g -- j.francisco.o.rocha@gmail.com < /tmp/teste.txt" >> /home/$utilizador/email_test.sh
        echo -e "echo -e \"A enviar mensagem de teste para franciscorocha@radiopopular.pt a partir do SMTP de RADIOPOPULAR.PT\"" >> /home/$utilizador/email_test.sh
        echo "mutt -s \"Mensagem de teste usando mutt_r\" -F /home/$utilizador/.mutt/mutt_r -- franciscorocha@radiopopular.pt < /tmp/teste.txt" >> /home/$utilizador/email_test.sh

	chmod +x /home/$utilizador/email_test.sh
	chown -R $utilizador:$grupo /home/$utilizador/email_test.sh
# Ajuda
	echo ""
	echo -e "Para testar envio de email execute:"
	echo -e "$ /home/$utilizador/email_test.sh"
	echo ""
	echo -e "#Formato generico"
	echo -e "mutt -a ficheiro_1 ficheiro_n -F ficheiro_mutt_rc -s \"assunto da mensagem\" -- endereço_email_1 endereço_email_n < /tmp/test_email"
	echo ""
	echo -e "# Conta Gmail"
	echo -e "$ mutt -s \"teste G\" -F /home/$utilizador/.mutt/mutt_g -- franciscorocha@radiopopular.pt < /tmp/test_email"
	echo ""
	echo -e "# Conta RP"
	echo -e "$ mutt -s \"teste R\" -F /home/$utilizador/.mutt/mutt_r -- franciscorocha@radiopopular.pt < /tmp/test_email"
	echo ""
	echo -e "# Conta default do msmtp"
	echo -e "$ mutt -s \"teste D\" -- franciscorocha@radiopopular.pt < /tmp/test_email"
	echo ""
	echo -e "# Mensagem com anexo"
	echo -e "$ mutt -a /caminho/ficheiro1.xex /caminho/ficheiro2.xex -s \"teste A\" -- franciscorocha@radiopopular.pt < /tmp/test_email"

. /home/$utilizador/email_test.sh

	}

function s_cheroquee () {
	__REQUISITOS
	apt-get --yes install mysql-server mysql-client
	add-apt-repository ppa:cherokee-webserver/ppa -y && apt-get update
	apt-get --yes install cherokee cherokee-admin
	apt-get --yes install php5-cgi
	sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/g' /etc/php5/cgi/php.ini
	cheroquee-admin
	echo "<?" > /var/www/info.php
	echo "phpinfo();" >> /var/www/info.php
	echo "?>" >> /var/www/info.php
	apt-get --yes install php5-mysql php5-curl php5-gd php5-idn php-pear php-dev php5-imagick php5-imap php5-mcrypt php5-memcache php5-mhash php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl php5-json
	killall php-cgi
	/etc/init.d/cherokee restart
	}

function s_gparted () {
	if [[ ! -e $(which gparted) ]]; then
	__REQUISITOS
	apt-get --yes install gparted
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function s_gtkperf () {
	if [[ ! -e $(which gtkperf) ]]; then
		__REQUISITOS
		apt-get --yes install gtkperf
	else
		echo "A aplicação $1 já se encontra instalada"
	fi
	}

function s_cdemu-client () {
	if [[ ! -e $(which cdemu-client) ]]; then
		add-apt-repository ppa:cdemu/ppa -y && apt-get update
		apt-get --yes install gcdemu cdemu-client
	else
		echo "A aplicação $1 já se encontra instalada"
	fi
	}

function s_hardinfo () {
	if [[ ! -e $(which hardinfo) ]]; then
	__REQUISITOS
	apt-get --yes install hardinfo
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function s_ifstat () {
	if [[ ! -e $(which ifstat) ]]; then
	__REQUISITOS
	apt-get --yes install ifstat
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function p_komodo () {
	__REQUISITOS
	wget --timeout 30 -t 1 -O - http://downloads.activestate.com/Komodo/releases/7.1.3/Komodo-Edit-7.1.3-11027-linux-x86.tar.gz  > /tmp/Komodo-Edit-7.1.3-11027-linux-x86.tar.gz
	cd /tmp
	tar xzvf /tmp/Komodo-Edit-7.1.3-11027-linux-x86.tar.gz
	cd Komodo-Edit-7.1.3-11027-linux-x86
	./install.sh
	ln -s "/opt/Komodo-Edit-7/bin/komodo" /usr/local/bin/komodo
	cd ..
	rm -rf Komodo*
	}

function s_jnetmap () {
	__REQUISITOS
	__DOWNLOAD http://sourceforge.net/projects/jnetmap/files/jNetMap%200.5.3/jNetMap-0.5.3.deb/download jnetmap.deb
	#mv download jnetmap.deb
	s_java7
	dpkg -i jnetmap.deb
	rm -f jnetmap.deb
	}

function s_jdiskreport () {
	__REQUISITOS
	__DOWNLOAD "http://www.jgoodies.com/download/jdiskreport/jdiskreport-1_4_0.zip" jdiskreport-1_4_0.zip
	unzip jdiskreport-1_4_0.zip -d /home/$utilizador/
	mv /home/$utilizador/jdiskreport-1.4.0 /home/$utilizador/jdiskreport
	rm -f jdiskreport-1_4_0.zip
	mkdir -p /home/$utilizador/Scripts
	echo "java -jar /home/$utilizador/jdiskreport/jdiskreport-1.4.0.jar" > /home/$utilizador/Scripts/jdiskreport.sh
	chmod +x /home/$utilizador/Scripts/jdiskreport.sh
	chown $utilizador:$grupo /home/$utilizador/Scripts/jdiskreport.sh
	#s_java7

		}

function s_hplisp () {
	__REQUISITOS
	__DOWNLOAD "http://sourceforge.net/projects/hplip/files/latest/download?source=directory" hplip.run
	# mv download?source=directory hplip.run
	chmod +x hplip.run
	./hplip.run
	rm -f hplip.run
	}

function s_netramon () {
	__REQUISITOS
	__DOWNLOAD "http://sourceforge.net/projects/netramon/files/NTM/ntm-1.x/ntm-1.3.1.deb/download" netramon.deb
	#wget --timeout 30 -t 1 -O - http://sourceforge.net/projects/netramon/files/NTM/ntm-1.x/ntm-1.3.1.deb/download > /tmp/netramon.deb
	dpkg -i /tmp/netramon.deb
	rm -f netramon.deb
	}

function s_epsonv200 () {
	__REQUISITOS
	wget --timeout 30 -t 1 -O - http://a1227.g.akamai.net/f/1227/40484/1d/download.ebz.epson.net/dsc/f/01/00/01/58/37/ded8c1c031fd402e8f99f5ed9c8ca1cbefe1cdde/iscan-plugin-gt-f670_2.1.2-1_i386.deb > /tmp/iscan-plugin.deb
	wget --timeout 30 -t 1 -O - http://a1227.g.akamai.net/f/1227/40484/1d/download.ebz.epson.net/dsc/f/01/00/02/15/80/139994fc6afff8cc0eeed32a2008320220786cba/iscan_2.29.1-5~usb0.1.ltdl7_i386.deb > /tmp/iscan.deb
	wget --timeout 30 -t 1 -O - http://a1227.g.akamai.net/f/1227/40484/1d/download.ebz.epson.net/dsc/f/01/00/02/15/80/47d9593f94a207abc98bce8fdc76a78984e3cf1e/iscan-data_1.22.0-1_all.deb > /tmp/iscan-data.deb
	apt-get --yes install xsltproc
	apt-get --yes install libltdl7
	dpkg -i /tmp/iscan-data.deb
	dpkg -i /tmp/iscan.deb
	dpkg -i /tmp/iscan-plugin.deb
	apt-get --yes install sane
	sed -i 's/RUN=no/RUN=yes/g' /etc/default/sane
	if ! grep -q 'root:x:0:saned' "/etc/group"; then
		sed -i '$aroot:x:0:saned' /etc/group
	fi
	if ! grep -q '202.168.0.0/24' "/etc/sane.d/saned.conf"; then
		sed -i '$a202.168.0.0\/24' /etc/sane.d/saned.conf
	fi
	service saned restart

	#update-rc.d saned defaults
	echo "Linux Client-side Setup"
	echo "From the client, all you need to do is add server name or IP address"
	echo "of the scanner server to /etc/sane.d/net.conf:"
	echo "202.168.0.10"
	echo "Windows Client-side Setup"
	echo "Install Saned Twain software"
	echo "from http://sanetwain.ozuzo.net/downloads/setup136.exe"
	echo "Add host on config:"
	echo "202.168.0.10"

	}

function i_fing () {
	cpu64=` grep flags /proc/cpuinfo | grep " lm " `
	if [[ $cpu64 != "" ]]; then
		__DOWNLOAD "http://www.overlooksoft.com/packages/download?plat=lx32&ext=deb" ./fing32.deb
	else
		__DOWNLOAD "http://www.overlooksoft.com/packages/download?plat=lx64&ext=deb" ./fing64.deb
	fi

	}

function s_gdebi () {
	if [[ ! -e $(which gdebi) ]]; then
	__REQUISITOS
	apt-get --yes install gdebi
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function s_netdiscover () {
	if [[ ! -e $(which netdiscover) ]]; then
	__REQUISITOS
	apt-get --yes install netdiscover
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function i_wget () {
	if [[ ! -e $(which wget) ]]; then
	__REQUISITOS
	apt-get --yes install wget
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function s_minicom () {
	if [[ ! -e $(which minicom) ]]; then
	__REQUISITOS
	apt-get --yes install minicom
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function s_traceroute () {
	if [[ ! -e $(which traceroute) ]]; then
	__REQUISITOS
	apt-get --yes install traceroute
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function m_mediubuntu () {
	__REQUISITOS
	if [ $(lsb_release -cs) = "luna" ]
		then
	echo "elementary OS Luna, Installing as Precise" &&
	wget --output-document=/etc/apt/sources.list.d/medibuntu.list http://www.medibuntu.org/sources.list.d/precise.list
		else
	wget --output-document=/etc/apt/sources.list.d/medibuntu.list http://www.medibuntu.org/sources.list.d/$(lsb_release -cs).list
	fi
	 apt-get --quiet update && apt-get --yes --quiet --allow-unauthenticated install medibuntu-keyring && apt-get --quiet update
	}

function s_filesuport () {
	__REQUISITOS
	apt-get --yes install arj faac faad ffmpeg ffmpeg2theora flac flashplugin-installer gstreamer0.10-ffmpeg gstreamer0.10-plugins-bad gstreamer0.10-plugins-ugly icedax id3v2 lame lha libdvdcss2 libflac++6 libjpeg-progs libmpeg3-1 mencoder mjpegtools mp3gain mpeg2dec mpeg3-utils mpegdemux mpg123 mpg321 p7zip p7zip-full p7zip-rar regionset sox ubuntu-restricted-extras unace-nonfree unrar uudeview vorbis-tools x264 ubuntu-restricted-extras mkvtoolnix
	#non-free-codecs
	/usr/share/doc/libdvdread4/install-css.sh
	}


function s_lamp () {
	__REQUISITOS
	apt-get --yes install tasksel make
	tasksel install lamp-server
	apt-get --yes install php5-mysql php5-curl php5-gd php5-idn php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-mhash php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl php5-json php5-cgi libapache2-mod-php5 libapache2-mod-auth-mysql
	pecl install xdebug
	apt-get --yes install mysql-workbench
	echo "	<VirtualHost *:80>" > /etc/apache2/sites-available/default
	echo "	ServerAdmin webmaster@localhost" >> /etc/apache2/sites-available/default
	echo "" >> /etc/apache2/sites-available/default
	echo "	DocumentRoot /home/$utilizador/www" >> /etc/apache2/sites-available/default
	echo "	<Directory />" >> /etc/apache2/sites-available/default
	echo "		Options FollowSymLinks" >> /etc/apache2/sites-available/default
	echo "		AllowOverride None" >> /etc/apache2/sites-available/default
	echo "	</Directory>" >> /etc/apache2/sites-available/default
	echo "	<Directory /home/$utilizador/www/>" >> /etc/apache2/sites-available/default
	echo "		Options Indexes FollowSymLinks MultiViews" >> /etc/apache2/sites-available/default
	echo "		AllowOverride None" >> /etc/apache2/sites-available/default
	echo "		Order allow,deny" >> /etc/apache2/sites-available/default
	echo "		allow from all" >> /etc/apache2/sites-available/default
	echo "	</Directory>" >> /etc/apache2/sites-available/default
	echo "" >> /etc/apache2/sites-available/default
	echo "	ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/" >> /etc/apache2/sites-available/default
	echo "	<Directory "/usr/lib/cgi-bin">" >> /etc/apache2/sites-available/default
	echo "		AllowOverride None" >> /etc/apache2/sites-available/default
	echo "		Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch" >> /etc/apache2/sites-available/default
	echo "		Order allow,deny" >> /etc/apache2/sites-available/default
	echo "		Allow from all" >> /etc/apache2/sites-available/default
	echo "	</Directory>" >> /etc/apache2/sites-available/default
	echo "" >> /etc/apache2/sites-available/default
	echo "	ErrorLog ${APACHE_LOG_DIR}/error.log" >> /etc/apache2/sites-available/default
	echo "" >> /etc/apache2/sites-available/default
	echo "	# Possible values include: debug, info, notice, warn, error, crit," >> /etc/apache2/sites-available/default
	echo "	# alert, emerg." >> /etc/apache2/sites-available/default
	echo "	LogLevel warn" >> /etc/apache2/sites-available/default
	echo "" >> /etc/apache2/sites-available/default
	echo "	CustomLog ${APACHE_LOG_DIR}/access.log combined" >> /etc/apache2/sites-available/default
	echo "" >> /etc/apache2/sites-available/default
	echo "    Alias /doc/ "/usr/share/doc/"" >> /etc/apache2/sites-available/default
	echo "    <Directory "/usr/share/doc/">" >> /etc/apache2/sites-available/default
	echo "        Options Indexes MultiViews FollowSymLinks" >> /etc/apache2/sites-available/default
	echo "        AllowOverride None" >> /etc/apache2/sites-available/default
	echo "        Order deny,allow" >> /etc/apache2/sites-available/default
	echo "        Deny from all" >> /etc/apache2/sites-available/default
	echo "        Allow from 127.0.0.0/255.0.0.0 ::1/128" >> /etc/apache2/sites-available/default
	echo "    </Directory>" >> /etc/apache2/sites-available/default
	echo "" >> /etc/apache2/sites-available/default
	echo "</VirtualHost>" >> /etc/apache2/sites-available/default
	mkdir -p /home/$utilizador/www
	echo "<?" > /home/$utilizador/www/info.php
	echo "phpinfo();" >> /home/$utilizador/www/info.php
	echo "?>" >> /home/$utilizador/www/info.php
	chown -R $utilizador:$grupo /home/$utilizador/www*
	fqdn=""
	if [[ ! -f /etc/apache2/conf.d/fqdn ]]; then
	touch /etc/apache2/conf.d/fqdn
	fi
	fqdn=` cat /etc/apache2/conf.d/fqdn | grep localhost `
	if [[ $fqdn == "" ]]; then
		echo "ServerName localhost" >> /etc/apache2/conf.d/fqdn
	fi
	# php.ini
	sed -i "s/memory_limit = 128M/memory_limit = 512M/g" /etc/php5/apache2/php.ini
	debug=""
	debug=` cat /etc/php5/apache2/php.ini | grep "\[debug\]" `
	if [[ $debug == "" ]]; then
		sed -i 's/.*\[Date\].*/zend_extension=\/usr\/lib\/php5\/<DATE+lfs>\/xdebug\.so\n\n\[debug\]\n\; Remote settings\nxdebug\.remote_autostart=off\nxdebug\.remote_enable=on\nxdebug\.remote_handler=dbgp\nxdebug\.remote_mode=req\nxdebug\.remote_host=localhost\nxdebug\.remote_port=9000\n\n\; General\nxdebug\.auto_trace=off\nxdebug\.collect_includes=on\nxdebug\.collect_params=off\nxdebug\.collect_return=off\nxdebug\.default_enable=on\nxdebug\.extended_info=1\nxdebug\.manual_url=http\:\/\/www.php.net\nxdebug\.show_local_vars=0\nxdebug\.show_mem_delta=0\nxdebug\.max_nesting_level=100\n\;xdebug\.idekey=\n\n\; Trace options\nxdebug\.trace_format=0\nxdebug\.trace_output_dir=\/tmp\nxdebug\.trace_options=0\nxdebug\.trace_output_name=crc32\n\n\; Profiling\nxdebug\.profiler_append=0\nxdebug\.profiler_enable=0\nxdebug\.profiler_enable_trigger=0\nxdebug\.profiler_output_dir=\/tmp\nxdebug\.profiler_output_name=crc32\n\n&/' /etc/php5/apache2/php.ini
	fi
	# php.ini
	a2enmod php5
	apt-get --yes install phpmyadmin
	phpmyadmin=""
	phpmyadmin=` cat /etc/apache2/apache2.conf | grep phpmyadmin `
	if [[ $phpmyadmin == "" ]]; then
	echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf
	fi
	#dpkg-reconfigure -plow phpmyadmin
	service apache2 restart
	}

function m_handbrake () {
	__REQUISITOS
	add-apt-repository ppa:stebbins/handbrake-releases -y && apt-get update
	apt-get --yes install handbrake-gtk handbrake-cli
	}

function m_ffmulticonverter () {
	__REQUISITOS
	add-apt-repository ppa:ffmulticonverter/stable -y && apt-get update
	apt-get --yes install ffmulticonverter
	}

function m_formatjunkie () {
	__REQUISITOS
	add-apt-repository ppa:format-junkie-team/release -y && apt-get update
	apt-get --yes install formatjunkie mencoder
	}

function m_rtmpdumphdtv () {
	__REQUISITOS
	add-apt-repository ppa:trebelnik-stefina/tv-maxe -y && apt-get update
	apt-get --yes install rtmpdumphdtv
	}

function s_ubuntu-builder () {
	__REQUISITOS
	add-apt-repository ppa:f-muriana/ubuntu-builder -y && apt-get update
	apt-get --yes install ubuntu-builder
	}

function i_skype () {
	if [[ ! -e $(which skype) ]]; then
	__REQUISITOS
	apt-get --yes install libxss1 skype
	echo "Se o pacote não for encontrado faça o seguite:"
	echo "Descomente as 2 linhas relativas ao repositorio de extras"
	echo "localizado em /etc/apt/sources.list "
	echo "de seguida faça [apt-get update] e volte a executar o instalador"
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function s_nmap () {
	if [[ ! -e $(which nmap) ]]; then
	__REQUISITOS
	apt-get --yes install nmap
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function s_arp-scan () {
	if [[ ! -e $(which arp-scan) ]]; then
	__REQUISITOS
	apt-get --yes install arp-scan
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function s_preload () {
	if [[ ! -e $(which preload) ]]; then
	__REQUISITOS
	apt-get install --yes preload
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function s_dialog () {
	if [[ ! -e $(which dialog) ]]; then
	__REQUISITOS
	apt-get --yes install dialog
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function s_iotop () {
	if [[ ! -e $(which iotop) ]]; then
	__REQUISITOS
	apt-get --yes install iotop
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function s_iostat () {
	if [[ ! -e $(which iostat) ]]; then
	__REQUISITOS
	apt-get --yes install sysstat
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function m_radiotray () {
	if [[ ! -e $(which radiotray) ]]; then
	__REQUISITOS
	apt-get --yes install radiotray
	mkdir -p /home/$utilizador/.local/share/radiotray/
	echo -e "<bookmarks>" > /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t<group name=\"root\">" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t<group name=\"Jazz\">" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Smooth Jazz\" url=\"http://smoothjazz.com/streams/smoothjazz_128.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"SKY.fm Piano Jazz\" url=\"http://listen.sky.fm/public1/pianojazz.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"SKY.fm Smooth Jazz\" url=\"http://listen.sky.fm/public1/smoothjazz.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Sonic Universe\" url=\"http://somafm.com/sonicuniverse.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Blue FM\" url=\"http://bluefm.net/listen.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"The Breeze\" url=\"mmsh://wms-rly.201.fm/201-breeze?MSWMExt=.asf\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t</group>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t<group name=\"Latin\">" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Onda Tropical\" url=\"http://yp.shoutcast.com/sbin/tunein-station.pls?id=506392\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Top Latino Radio\" url=\"http://online.radiodifusion.net:8020/listen.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Salsa Stream\" url=\"http://listen.sky.fm/public3/salsa.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Reggaeton 24/7\" url=\"http://cc.net2streams.com/tunein.php/reggaeton/playlist.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Suave 107\" url=\"http://grupomedrano.com.do/suave107/suave107.m3u\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t</group>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t<group name=\"Classic Rock\">" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"201.FM Classic Hits\" url=\"http://sc-rly.201.fm:80/stream/1094\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\".977 Classic Rock\" url=\"http://www.977music.com/tunein/web/classicrock.asx\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"80s Sky.FM\" url=\"http://listen.sky.fm/public3/the80s.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Covers\" url=\"http://somafm.com/covers.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t</group>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t<group name=\"Classical\">" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"KDFC\" url=\"http://provisioning.streamtheworld.com/pls/KDFCFM.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Classic FM\" url=\"http://media-ice.musicradio.com/ClassicFMMP3.m3u\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"WCPE\" url=\"http://www.ibiblio.org/wcpe/wcpe.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"CINEMIX\" url=\"http://cinemix.us/cine.asx\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"SKY.fm Soundtracks\" url=\"http://listen.sky.fm/public1/soundtracks.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"SKY.fm Mostly Classical\" url=\"http://listen.sky.fm/public1/classical.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t</group>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t<group name=\"Pop / Rock\">" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Radio Paradise\" url=\"http://www.radioparadise.com/musiclinks/rp_128aac.m3u\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\".977 The Hitz Channel\" url=\"http://yp.shoutcast.com/sbin/tunein-station.pls?id=1280356\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Enjoy Station\" url=\"http://yp.shoutcast.com/sbin/tunein-station.pls?id=1377285\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"SKY.fm Top Hits\" url=\"http://listen.sky.fm/public1/tophits.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Indie Pop Rocks!\" url=\"http://somafm.com/indiepop.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"PopTron\" url=\"http://somafm.com/poptron.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t</group>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t<group name=\"Oldies\">" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"AM 2010\" url=\"http://lin2.ash.fast-serv.com:9022/listen.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"WNAR\" url=\"http://live.wnar-am.com:8500/listen.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"SKY.fm Oldies\" url=\"http://listen.sky.fm/public1/oldies.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t</group>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t<group name=\"Chill\">" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"201.FM\" url=\"http://yp.shoutcast.com/sbin/tunein-station.pls?id=1275050\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Lounge Radio\" url=\"http://yp.shoutcast.com/sbin/tunein-station.pls?id=1288934\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Beat Blender\" url=\"http://somafm.com/beatblender.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Secret Agent\" url=\"http://somafm.com/secretagent.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Groove Salad\" url=\"http://somafm.com/groovesalad.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Illinois Street Lounge\" url=\"http://somafm.com/illstreet.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t</group>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t<group name=\"Country\">" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"SKY.fm Country\" url=\"http://listen.sky.fm/public1/country.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Boot Liquor\" url=\"http://somafm.com/bootliquor.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"US 201\" url=\"mmsh://wms-rly.201.fm/201-us201?MSWMExt=.asf\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Real Country\" url=\"mmsh://wms-rly.201.fm/201-realcountry?MSWMExt=.asf\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Highway 201\" url=\"mmsh://wms-rly.201.fm/201-highway?MSWMExt=.asf\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Country 108\" url=\"http://www.country108.com/listen.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t</group>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t<group name=\"Techno / Electronic\">" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Drone Zone\" url=\"http://somafm.com/dronezone.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Space Station Soma\" url=\"http://somafm.com/spacestation.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"cliqhop idm\" url=\"http://somafm.com/cliqhop.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Black Rock FM\" url=\"http://somafm.com/brfm.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"New Dance Radio\" url=\"http://jbstream.net/tunein.php/blackoutworm/playlist.asx\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t</group>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t<group name=\"Community\">" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Jupiter Broadcast\" url=\"http://jblive.fm/\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"WCRS LPFM Columbus\" url=\"http://sh4.audio-stream.com/tunein.php/pleonard/playlist.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"WBEZ\" url=\"http://wbez.ic.llnwd.net/stream/wbez_91_5_fm.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t</group>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t<group name=\"Portugal Nacional\">" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Antena 1\" url=\"mms://205.245.168.21/antena1\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Antena 2\" url=\"mms://205.245.168.21/antena2\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Antena 3\" url=\"mms://205.245.168.21/antena3\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Cidade FM\" url=\"mms://205.23.102.206/cidadecbr96\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Comercial\" url=\"http://205.23.102.206/comercialcbr96\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Renascença\" url=\"http://provisioning.streamtheworld.com/pls/RADIO_RENASCENCAaac.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"RFM Oceano Pacifico\" url=\"http://provisioning.streamtheworld.com/pls/OCEANPACIFICaac.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"TSF\" url=\"http://directo.tsf.pt/tsfdirecto.aac.m3u\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Romantica FM\" url=\"mms://205.23.102.206/romanticacbr96\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"RFM\" url=\"http://provisioning.streamtheworld.com/pls/rfmaac.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"M80\" url=\"mms://205.23.102.206/m80cbr96\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t</group>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t<group name=\"Portugal Porto\">" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Festival\" url=\"mms://stream.radio.com.pt/roli-enc-520\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Nostalgia\" url=\"mms://stream.radio.com.pt/roli-enc-435\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Nova\" url=\"mms://stream.radio.com.pt/ROLI-ENC-528\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Radio 5 FM\" url=\"mms://stream.radio.com.pt/ROLI-ENC-438\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t</group>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t<group name=\"Portugal Algarve\">" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Total FM\" url=\"http://www.totalfm.pt:8000/listen.pls\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"TLA FM\" url=\"mms://stream.radio.com.pt/ROLI-ENC-545\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Radio Foia\" url=\"mms://stream.radio.com.pt/ROLI-ENC-163\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Gilão FM\" url=\"mms://stream.radio.com.pt/ROLI-ENC-440\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Alvor FM\" url=\"mms://stream.radio.com.pt/ROLI-ENC-469\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Algarve FM\" url=\"mms://stream.radio.com.pt/ROLI-ENC-455\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Kiss FM\" url=\"http://www.kissfmalgarve.com/project/internetradio/kissfm.m3u\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t\t<bookmark name=\"Costa D'Oiro FM\" url=\"mms://stream.radio.com.pt/ROLI-ENC-440\"/>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t\t</group>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "\t</group>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	echo -e "</bookmarks>" >> /home/$utilizador/.local/share/radiotray/bookmarks.xml
	chown -R $user:$user /home/$utilizador/.local/share/radiotray
	echo "Adicione a aplicação ao Startup do Xubuntu"
	echo "Gestor de Definições > Sistema > Sessão e arranque > Aplicações automáticas"
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function m_videoeditors () {
	__REQUISITOS
	add-apt-repository ppa:openshot.developers/ppa -y && add-apt-repository ppa:pitivi/stable -y && apt-get update
	apt-get --yes install pitivi openshot
	}

function p_glade () {
	if [[ ! -e $(which glade) ]]; then
	__REQUISITOS
	apt-get --yes install glade valac
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function m_shotwell () {
	if [[ ! -e $(which shotwell) ]]; then
	__REQUISITOS
	add-apt-repository ppa:yorba/ppa -y && apt-get update
	apt-get --yes install shotwell
	m_raw
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function p_yad () {
	if [[ ! -e $(which yad) ]]; then
	__REQUISITOS
	add-apt-repository ppa:webupd8team/y-ppa-manager -y && apt-get update
	apt-get --yes install yad
	yad --title="Desktop entry editor" --text="Simple desktop entry editor" --form --field="Type:CB" --field="Name" --field="Generic name" --field="Comment" --field="Command:FL" --field="Icon" --field="In terminal:CHK" --field="Startup notify:CHK" "Application" "Name" "Generic name" "This is the comment" "/usr/bin/yad" "yad" FALSE TRUE --button="WebUpd8:2" --button="gtk-ok:0" --button="gtk-cancel:1"
	else
	echo "A aplicação $1 já se encontra instalada"
	yad --title="Desktop entry editor" --text="Simple desktop entry editor" --form --field="Type:CB" --field="Name" --field="Generic name" --field="Comment" --field="Command:FL" --field="Icon" --field="In terminal:CHK" --field="Startup notify:CHK" "Application" "Name" "Generic name" "This is the comment" "/usr/bin/yad" "yad" FALSE TRUE --button="WebUpd8:2" --button="gtk-ok:0" --button="gtk-cancel:1"
	fi
}

function i_webmin () {
        if [[ ! -e $(which darktable) ]]; then
        __REQUISITOS
		apt-get update && apt-get install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python
		wget http://www.webmin.com/download/deb/webmin-current.deb
		dpkg -i webmin-current.deb
		rm webmin-current.deb
        else
	        echo "A aplicação $1 já se encontra instalada"
        fi
        }


function m_raw () {
	if [[ ! -e $(which darktable) ]]; then
	__REQUISITOS
	add-apt-repository ppa:pmjdebruijn/darktable-release-plus -y
	add-apt-repository ppa:dhor/myway -y
	add-apt-repository ppa:rawstudio/ppa -y
	apt-get update
	apt-get --yes install darktable photivo rawstudio ufraw fotoxx
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function m_gpicsync () {
	__REQUISITOS
	add-apt-repository ppa:tdomhan/ppa -y
	apt-get update
	apt-get --yes install gpicsync
	}


function m_exif () {
	__REQUISITOS
	apt-get --yes install phatch jhead pictag
	}

function m_xbmc () {
	if [[ ! -e $(which xbmc) ]]; then
		__REQUISITOS
		apt-get --yes install python-software-properties pkg-config
		apt-get --yes install software-properties-common
		add-apt-repository ppa:team-xbmc/ppa -y && apt-get update
		apt-get --yes install xbmc
		mkdir -p /home/$utilizador/.xbmc/userdata/
		echo -e "<sources>" > /home/$utilizador/.xbmc/userdata/sources.xml
		echo -e "\t<programs>" >> /home/$utilizador/.xbmc/userdata/sources.xml
		echo -e "\t\t<default pathversion=\"1\"></default>" >> /home/$utilizador/.xbmc/userdata/sources.xml
		echo -e "\t</programs>" >> /home/$utilizador/.xbmc/userdata/sources.xml
		echo -e "\t<video>" >> /home/$utilizador/.xbmc/userdata/sources.xml
		echo -e "\t\t<default pathversion=\"1\"></default>" >> /home/$utilizador/.xbmc/userdata/sources.xml
		echo -e "\t</video>" >> /home/$utilizador/.xbmc/userdata/sources.xml
		echo -e "\t<music>" >> /home/$utilizador/.xbmc/userdata/sources.xml
		echo -e "\t\t<default pathversion="1"></default>" >> /home/$utilizador/.xbmc/userdata/sources.xml
		echo -e "\t</music>" >> /home/$utilizador/.xbmc/userdata/sources.xml
		echo -e "\t<pictures>" >> /home/$utilizador/.xbmc/userdata/sources.xml
		echo -e "\t\t<default pathversion=\"1\"></default>" >> /home/$utilizador/.xbmc/userdata/sources.xml
		echo -e "\t</pictures>" >> /home/$utilizador/.xbmc/userdata/sources.xml
		echo -e "\t<files>" >> /home/$utilizador/.xbmc/userdata/sources.xml
		echo -e "\t\t<default pathversion=\"1\"></default>" >> /home/$utilizador/.xbmc/userdata/sources.xml
		echo -e "\t\t<source>" >> /home/$utilizador/.xbmc/userdata/sources.xml
		echo -e "\t\t\t<name>AMinhaCasaDigital</name>" >> /home/$utilizador/.xbmc/userdata/sources.xml
		echo -e "\t\t\t<path pathversion=\"1\">http://xbmc.aminhacasadigital.com/</path>" >> /home/$utilizador/.xbmc/userdata/sources.xml
		echo -e "\t\t</source>" >> /home/$utilizador/.xbmc/userdata/sources.xml
		echo -e "\t\t<source>" >> /home/$utilizador/.xbmc/userdata/sources.xml
		echo -e "\t\t\t<name>SuperRepo</name>" >> /home/$utilizador/.xbmc/userdata/sources.xml
		echo -e "\t\t\t<path pathversion=\"1\">http://use.superrepo.org/</path>" >> /home/$utilizador/.xbmc/userdata/sources.xml
		echo -e "\t\t</source>" >> /home/$utilizador/.xbmc/userdata/sources.xml
		echo -e "\t\t<source>" >> /home/$utilizador/.xbmc/userdata/sources.xml
		echo -e "\t\t\t<name>Fusion</name>" >> /home/$utilizador/.xbmc/userdata/sources.xml
		echo -e "\t\t\t<path pathversion=\"1\">http://fusion.xbmchub.com/</path>" >> /home/$utilizador/.xbmc/userdata/sources.xml
		echo -e "\t\t</source>" >> /home/$utilizador/.xbmc/userdata/sources.xml
		echo -e "\t</files>" >> /home/$utilizador/.xbmc/userdata/sources.xml
		echo -e "</sources>" >> /home/$utilizador/.xbmc/userdata/sources.xml
		chown -R $utilizador:$utilizador /home/$utilizador/.xbmc
		####
		cpu64=` grep flags /proc/cpuinfo | grep " lm " `
		if [[ $cpu64 != "" ]]; then
			__DOWNLOAD  "https://dl-web.dropbox.com/get/xbmc/librtmp.so.0/32_librtmp.so.0?w=AABvxj_8AQju5ZjGrsi2Zxr20NBEiQEj2ihrovq3_L85eQ&dl=1" librtmp.so.0
			# mv -f "32_librtmp.so.0?w=AABvxj_8AQju5ZjGrsi2Zxr20NBEiQEj2ihrovq3_L85eQ&dl=1" librtmp.so.0
			mv -f librtmp.so.0 /usr/lib/i386-linux-gnu/librtmp.so.0
		else
			__DOWNLOAD  "https://dl-web.dropbox.com/get/xbmc/librtmp.so.0/64_librtmp.so.0?w=AADKa3wDtx3ZRE7Sea4_LjswzPcSDxI8oYpE6P5Bvy8Xdw&dl=1" librtmp.so.0
			# mv -f "64_librtmp.so.0?w=AADKa3wDtx3ZRE7Sea4_LjswzPcSDxI8oYpE6P5Bvy8Xdw&dl=1" librtmp.so.0
			mv -f librtmp.so.0 /usr/lib/x86_64-linux-gnu/librtmp.so.0
			__DOWNLOAD  "https://dl-web.dropbox.com/get/xbmc/librtmp.so.0/32_librtmp.so.0?w=AABvxj_8AQju5ZjGrsi2Zxr20NBEiQEj2ihrovq3_L85eQ&dl=1" librtmp.so.0
			# mv -f "32_librtmp.so.0?w=AABvxj_8AQju5ZjGrsi2Zxr20NBEiQEj2ihrovq3_L85eQ&dl=1" librtmp.so.0
			mv -f librtmp.so.0 /usr/lib/i386-linux-gnu/librtmp.so.0
		fi
	####
	else
		echo "A aplicação $1 já se encontra instalada"
	fi
	}

function s_htop () {
	if [[ ! -e $(which htop) ]]; then
	__REQUISITOS
	apt-get --yes install htop
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function m_recordmydesktop () {
	if [[ ! -e $(which recordmydesktop) ]]; then
	__REQUISITOS
	apt-get --yes install gtk-recordmydesktop
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function s_ssh () {
	__REQUISITOS
	apt-get --yes install ssh sudo openssh-server openssh-client
	}

function m_vlc () {
	if [[ ! -e $(which vlc) ]]; then
	__REQUISITOS
	add-apt-repository ppa:videolan/stable-daily -y && apt-get --yes update
	apt-get --yes install vlc
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function p_geany () {
	if [[ ! -e $(which geany) ]]; then
	__REQUISITOS
	apt-get --yes install geany
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function s_multiget () {
	if [[ ! -e $(which multiget) ]]; then
	__REQUISITOS
	apt-get --yes install multiget
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function i_thunderbird () {
	__REQUISITOS
	apt-get --yes install thunderbird xul-ext-calendar-timezones xul-ext-lightning thunderbird-locale-pt
	}

function e_adobe_acrobat () {
	if [[ ! -e $(which acroread) ]]; then
	__REQUISITOS
	add-apt-repository "deb http://archive.canonical.com/ precise partner"
	apt-get --yes update
	apt-get --yes install acroread
	else
	echo "A aplicação $1 já se en.shcontra instalada"
	fi
	}

function i_jdownloader () {
	__REQUISITOS
	add-apt-repository ppa:jd-team/jdownloader -y && apt-get --yes update
	apt-get --yes install jdownloader
	}

function s_java7 () {
	__REQUISITOS
	apt-get --yes purge openjdk-7-jre icedtea-7-plugin
	add-apt-repository ppa:webupd8team/java -y && apt-get --yes update
	apt-get --yes install oracle-jdk7-installer
	update-alternatives --install /usr/lib/mozilla/plugins/libjavaplugin.so mozilla-javaplugin.so /usr/lib/jvm/java-7-oracle/jre/lib/i386/libnpjp2.so 1
	}

function i_geary () {
	__REQUISITOS
	apt-add-repository ppa:yorba/ppa -y && apt-get --yes update && apt-get --yes install geary
	}

function s_terra () {
	if [[ ! -e $(which terra) ]]; then
	__REQUISITOS
	add-apt-repository ppa:ozcanesen/terra-terminal -y && apt-get --yes update
	apt-get --yes install terra
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function s_codeblocks () {
	if [[ ! -e $(which codeblocks) ]]; then
	__REQUISITOS
	add-apt-repository ppa:pasgui/ppa -y && apt-get --yes update
	apt-get --yes install codeblocks
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function s_finalterm () {
	if [[ ! -e $(which finalterm) ]]; then
	__REQUISITOS
	add-apt-repository ppa:finalterm/daily -y && apt-get --yes update
	apt-get --yes install finalterm
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function s_java6 () {
	__REQUISITOS
	mkdir -p /home/$utilizador/java/javajre6
	cd /home/$utilizador/java/javajre6
		if [[ ! -e jre-6-linux-i586.bin ]]; then
		wget --timeout 30 -t 1 -O - http://javadl.sun.com/webapps/download/AutoDL?BundleId=63251 > /home/$utilizador/java/javajre6/jre-6-linux-i586.bin
		fi
	chmod u+x jre-6-linux-i586.bin
	./jre-6-linux-i586.bin
	pasta=$( ls --directory jre*/ | sed -e 's/\///g' )
		if [[ ! -e /usr/lib/jvm/$pasta ]]; then
		mv --force $pasta/ /usr/lib/jvm/
		else
		rm -rf $pasta
		fi
	update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/$pasta/bin/java" 1
	update-alternatives --install "/usr/lib/mozilla/plugins/libjavaplugin.so" "mozilla-javaplugin.so" "/usr/lib/jvm/$pasta/lib/i386/libnpjp2.so" 1
	update-alternatives --config java
	}

function e_libreoffice () {
	__REQUISITOS
	add-apt-repository ppa:libreoffice/ppa -y && apt-get update
	apt-get --yes purge openoffice* libreoffice*
	apt-get --yes dist-upgrade
	apt-get --yes install libreoffice libreoffice-l10n-pt libreoffice-help-pt libreoffice-pdfimport browser-plugin-libreoffice libreoffice-style-tango libreoffice-style-galaxy libreoffice-style-human libreoffice-style-oxygen libreoffice-style-sifr
	}
function e_openoffice () {
	__REQUISITOS
	__DOWNLOAD "http://sourceforge.net/projects/openofficeorg.mirror/files/4.0.0/binaries/pt/Apache_OpenOffice_4.0.0_Linux_x86_install-deb_pt.tar.gz" Apache_OpenOffice_4.0.0_Linux_x86_install-deb_pt.tar.gz
	__DOWNLOAD "http://sourceforge.net/projects/openofficeorg.mirror/files/4.0.0/binaries/pt/Apache_OpenOffice_4.0.0_Linux_x86_langpack-deb_pt.tar.gz" Apache_OpenOffice_4.0.0_Linux_x86_langpack-deb_pt.tar.gz
	apt-get --yes purge openoffice* libreoffice*
	apt-get update && apt-get autoremove
	apt-get --yes dist-upgrade
	mkdir -p OpenOffice
	tar -vxf Apache_OpenOffice_4.0.0_Linux_x86_install-deb_pt.tar.gz -C /home/$utilizador/OpenOffice/
	tar -vxf Apache_OpenOffice_4.0.0_Linux_x86_langpack-deb_pt.tar.gz -C /home/$utilizador/OpenOffice/
	dpkg -i OpenOffice/pt/DEBS/*.deb
	dpkg -i OpenOffice/pt/DEBS/desktop-integration/*.deb
	rm -rf /home/$utilizador/OpenOffice/
	rm -rf Apache_OpenOffice*
	echo "Ir a http://pt.libreoffice.org/dicionarios-extensoes-e-modelos/ para instalar o dicionario"
}

function s_wine () {
	if [[ ! -e $(which wine) ]]; then
	__REQUISITOS
		# add-apt-repository ppa:ubuntu-wine/ppa -y && apt-get --yes update
	# apt-get --yes install wine winetricks
	URL="http://www.playonlinux.com/script_files/PlayOnLinux/4.1.8/PlayOnLinux_4.1.8.deb"
	lynx -connect_timeout=10 --source ${URL} > /tmp/playonlinux.deb 2> /dev/null
	dpkg -i /tmp/playonlinux.deb
	rm /tmp/playonlinux.deb
	else
	echo "A aplicação $run já se encontra instalada"
	fi
	}

function s_remmina () {
	if [[ ! -e $(which remmina) ]]; then
	#add-apt-repository ppa:llyzs/ppa -y && apt-get --yes update
	__REQUISITOS
	apt-get --yes install remmina
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function s_unetbootin () {
	if [[ ! -e $(which unetbootin) ]]; then
	#add-apt-repository ppa:gezakovacs/ppa -y && apt-get --yes update
	__REQUISITOS
	apt-get --yes install unetbootin
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function m_gimp () {
	__REQUISITOS
	add-apt-repository ppa:otto-kesselgulasch/gimp -y && apt-get --yes update
	#add-apt-repository ppa:nilarimogard/webupd8 -y && apt-get --yes update
	#apt-get install --yes gmic gimp-gmic gimp-plugin-registry gimp-help gimp-data-extras icc-profiles glew-utils libtiff-opengl
	apt-get install --yes gimp gimp-plugin-registry gimp-help gimp-data-extras
	apt-get --yes dist-upgrade
	__DOWNLOAD "https://dl.dropboxusercontent.com/s/cfaa4nzcawz2960/brushes.zip?token_hash=AAFT6Top3P0AnqHfx5rCVPeNutV8gj8SdHJDojeXlhkFtA&dl=1" brushes.zip
	# mv "brushes.zip?token_hash=AAFT6Top3P0AnqHfx5rCVPeNutV8gj8SdHJDojeXlhkFtA&dl=1" brushes.zip
	unzip brushes.zip -d /home/$utilizador/.gimp*/brushes/
	chown -R $utilizador:$grupo /home/$utilizador/.gimp*/brushes/
	rm brushes.zip
	}


function s_teamviewer () {
	if [[ ! -e $(which _teamviewer) ]]; then
	__REQUISITOS
		if [ "$(uname -m)" == "x86_64" ]; then

			URL=http://www.teamviewer.com/download/version_8x/teamviewer_linux_x64.deb
			#URL=http://www.teamviewer.com/download/teamviewer_linux_x64.deb
		else
			#URL=http://www.teamviewer.com/download/teamviewer_linux.deb
			URL=http://www.teamviewer.com/download/version_8x/teamviewer_linux.deb
		fi
	lynx -connect_timeout=10 --source ${URL} > /tmp/teamviewer_linux.deb 2> /dev/null
	dpkg -i /tmp/teamviewer_linux.deb
	rm /tmp/teamviewer_linux.deb
	else
	echo "A aplicação $run já se encontra instalada"
	fi
	}

function e_pdf () {
	__REQUISITOS
	apt-get --yes install pdfmod pdfshuffler pdfchain pdfsam scantailor
	# http://code-industry.net/public/master-pdf-editor_2.1.81_i386.deb

	}


function p_sublimetext () {
	__REQUISITOS
	#mkdir -p /opt/sublimetext/
	#chmod 777 /opt/sublimetext/
	#cd /opt/sublimetext/
	#	if [[ ! -e "Sublime Text 2.0.1.tar.bz2" ]]; then
	#		lynx -connect_timeout=10 --source "http://c758482.r82.cf2.rackcdn.com/Sublime Text 2.0.1.tar.bz2" > /opt/sublimetext/"Sublime Text 2.0.1.tar.bz2" 2> /dev/null
	#	fi
	#tar vxjf /opt/sublimetext/"Sublime Text 2.0.1.tar.bz2"
	#destino=`find "/opt" -mindepth 1 -maxdepth 4 -type f -iname "sublime_text"`
	#ln -s "$destino" /usr/bin/sublime_text
	#rm /opt/sublimetext/"Sublime Text 2.0.1.tar.bz2"

	#lynx -connect_timeout=10 --source "http://c758482.r82.cf2.rackcdn.com/Sublime Text 2.0.1.tar.bz2" > /opt/"Sublime Text 2.0.1.tar.bz2" 2> /dev/null
	#cd /opt
	#tar xf "Sublime Text 2.0.1.tar.bz2"
	#ln -s "/opt/Sublime Text 2"/sublime_text /usr/bin/sublime-text-2
	#echo -e "#!/usr/bin/env xdg-open" > /usr/share/applications/sublime.desktop
	#echo -e "" >> /usr/share/applications/sublime.desktop
	#echo -e "[Desktop Entry]" >> /usr/share/applications/sublime.desktop
	#echo -e "Name=Sublime Text 2" >> /usr/share/applications/sublime.desktop
	#echo -e "GenericName=Text Editor" >> /usr/share/applications/sublime.desktop
	#echo -e "Comment=Sophisticated text editor for code, html and prose" >> /usr/share/applications/sublime.desktop
	#echo -e "Exec=/usr/bin/sublime-text-2 %F" >> /usr/share/applications/sublime.desktop
	#echo -e "Terminal=false" >> /usr/share/applications/sublime.desktop
	#echo -e "Type=Application" >> /usr/share/applications/sublime.desktop
	#echo -e "MimeType=text/plain;text/x-chdr;text/x-csrc;text/x-c++hdr;text/x-c++src;text/x-java;text/x-dsrc;text/x-pascal;text/x-p$" >> /usr/share/applications/sublime.desktop
	#echo -e "Icon=/opt/Sublime Text 2/Icon/48x48/sublime_text.png" >> /usr/share/applications/sublime.desktop
	#echo -e "Categories=TextEditor;Development;Utility;" >> /usr/share/applications/sublime.desktop
	#echo -e "Name[en_US]=Sublime Text 2" >> /usr/share/applications/sublime.desktop
	#echo -e "X-Ayatana-Desktop-Shortcuts=NewWindow;" >> /usr/share/applications/sublime.desktop
	#echo -e "" >> /usr/share/applications/sublime.desktop
	#echo -e "[NewWindow Shortcut Group]" >> /usr/share/applications/sublime.desktop
	#echo -e "Name=Open a New Window" >> /usr/share/applications/sublime.desktop
	#echo -e "Exec=/usr/bin/sublime-text-2 --new-window" >> /usr/share/applications/sublime.desktop
	#echo -e "TargetEnvironment=Unity" >> /usr/share/applications/sublime.desktop

	add-apt-repository ppa:webupd8team/sublime-text-2 -y && apt-get --yes update
	apt-get --yes install sublime-text
	}

function s_bleachbit () {
	if [[ ! -e $(which bleachbit) ]]; then
	__REQUISITOS
	apt-get --yes install bleachbit
	bleachbit
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function s_xfcethunarprint () {
	sed -i '/<\/actions>/d' /home/$utilizador/.config/Thunar/uca.xml
	echo -e "<action>" >> /home/$utilizador/.config/Thunar/uca.xml
	echo -e "\t<icon>printer</icon>" >> /home/$utilizador/.config/Thunar/uca.xml
	echo -e "\t<name>Imprimir ...</name>" >> /home/$utilizador/.config/Thunar/uca.xml
#	echo -e "\t<command>parallel xfprint4 &apos;{}&apos; -- %F</command>" >> /home/$utilizador/.config/Thunar/uca.xml
	echo -e "\t<command>gtklp %F</command>" >> /home/$utilizador/.config/Thunar/uca.xml
	echo -e "\t<description></description>" >> /home/$utilizador/.config/Thunar/uca.xml
	echo -e "\t<patterns>*.pdf;*.txt;*.doc</patterns>" >> /home/$utilizador/.config/Thunar/uca.xml
	echo -e "\t<other-files/>" >> /home/$utilizador/.config/Thunar/uca.xml
	echo -e "\t<text-files/>" >> /home/$utilizador/.config/Thunar/uca.xml
	echo -e "</action>" >> /home/$utilizador/.config/Thunar/uca.xml
	echo -e "</actions>" >> /home/$utilizador/.config/Thunar/uca.xml
#	apt-get --yes install parallel
	apt-get --yes install gtklp
	}

function s_remove_apport () {
	if [[ ! -e $(which apport) ]]; then
		__REQUISITOS
	apt-get --yes remove apport apport-symptoms
	else
	echo "A aplicação $1 já se encontra desinstalada"
	fi
	}

function s_furios_iso_mount () {
	if [[ ! -e $(which furiusisomount) ]]; then
	__REQUISITOS
	apt-get --yes install furiusisomount
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function i_filezilla () {
	if [[ ! -e $(which filezilla) ]]; then
	__REQUISITOS
	add-apt-repository ppa:n-muench/programs-ppa -y && apt-get --yes update
	apt-get --yes install filezilla filezilla-common
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function s_yppa () {
	if [[ ! -e $(which y-ppa-manager) ]]; then
	__REQUISITOS
	add-apt-repository ppa:webupd8team/y-ppa-manager -y && apt-get --yes update
	apt-get --yes install y-ppa-manager
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function i_chrome () {
	if [[ ! -e $(which google-chrome) ]]; then
	__REQUISITOS
	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
	sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list'
	apt-get update
	apt-get --yes install google-chrome-stable
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function s_terminator () {
	if [[ ! -e $(which terminator) ]]; then
	__REQUISITOS
	apt-get --yes install terminator
	else
	echo "A aplicação $1 já se encontra instalada"
	fi
	}

function s_limpar_maquina () {
	__REQUISITOS
	oldsize=`df -h | grep sda1`
	apt-get --yes update
	apt-get --yes install deborphan trash-cli
	apt-get --yes -f install
	rm /var/lib/apt/lists/*
	rm /var/lib/apt/lists/partial/*
	dpkg -l 'linux-image*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | xargs apt-get -y purge
	apt-get --yes upgrade
	apt-get --force-yes upgrade
	trash-empty
	apt-get --yes autoclean
	apt-get --yes clean
	apt-get --yes --purge autoremove
	deborphan --guess-all | xargs apt-get --yes remove --purge
	newsize=`df -h | grep sda1`
	echo -e "Erros nas fontes apt:"
	apt-get --yes update | grep Falhou
	echo -e "Sist.fichs      Tama  Ocup Livre Uso% Montado em"
	echo -e "$oldsize [antes]"
	echo -e "$newsize [depois]"

	}

__USER

$1 $2
