#!/bin/bash
#
#BleedingEdge.sh for Ubuntu Copyright (C) 2009-2011 Paul Fedele
#Works only with zenity and notify-osd Installed!
#
#To use this script graphically, make it executable (Right Click File, Permissions, Select Execute Checkbox)
#then double click the file and select "Run in Terminal"
#
#To use this script from the command prompt type "chmod u+x PATH/BleedingEdge_VERSION.sh" where PATH is the location of the script and VERSION is the appropriate version of the script
#
#Inquiries can be sent to fedele at rocketmail dot com
#
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#http://www.gnu.org/licenses/gpl-3.0.html
#
#This script adds software from repositories which are not under its control.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#No Warranty or guarantee of suitability exists for this software
#Use at your own risk. The author is not responsible if your system breaks.
#
#You should have received a copy of the GNU General Public License
#along with this program. If not, see <http://www.gnu.org/licenses/>.
#Adobe Flash, Adobe Reader, Arthos, Avant, Blueman, Boxee, Cinelerra, CLI Companion, Dock Bar X, Dolphin, Drop Box, Enlightenment, Epidermis, FreeTux TV, GetDeb, gImageReader, Gnome, GmapCatcher, Google Chrome, Google Earth, Google Picasa, Google Talk, Gtalx, GUFW, Hulu, Java, K3B, KDE, Lucidor, Libre Office, Linux, Linux Multimedia Studio, Microsoft, Mono, Mplayer, Octoshape, Open Office, OpenShot, Miro, Pandora, PDF, Pithos, PlayDeb, PlayOnLinux, Prey, Pulse, Remobo IPN, Sbackup, Skype, Ubuntu, Ubuntu Tweak, VirtualBox, VLC, Wii, Wine, Xine, and Y-PPA-Manager are trademarks of their respective owners.  No endorsement by any trademark holder is stated or implied.
VERSION="11_04_9"
DISTROBUTION="natty"
RED="\033[0;31m"
BLUE="\033[0;34m"
GREEN="\033[1;32m"
ENDCOLOR="\033[0m"
ARCHITECTURE=`uname -m`
ON_USER=`whoami`
CODENAME=$(lsb_release -cs)
RESTART="NO"
UPDATEREQUIRED="NO"
function CinelerraPrep()
{
	if [ -f /etc/apt/sources.list.d/cinelerra-ppa-cinelerra-exp-$CODENAME.list ]
	then
		echo -e $GREEN"*Cinelerra Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "Cinelerra Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding The Cinelerra Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding The Cinelerra Repository"
		sudo add-apt-repository ppa:cinelerra-ppa/cinelerra-exp
	fi
	UPDATEREQUIRED="YES"
	return
}
function DockBarXPrep()
{
	if [ -f /etc/apt/sources.list.d/nilarimogard-webupd8-$CODENAME.list ]
	then
		echo -e $GREEN"*DockBarX Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "DockBarX Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding The DockBarX Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding The DockBarX Repository"
		sudo add-apt-repository ppa:nilarimogard/webupd8
	fi
	UPDATEREQUIRED="YES"
	return
}
function DolphinPrep()
{
	if [ -f /etc/apt/sources.list.d/glennric-dolphin-emu-$CODENAME.list ]
	then
		echo -e $GREEN"*Dolphin Wii Emulator Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "Dolhpin Wii Emulator Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding The Dolhpin Wii Emulator Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding The Dolhpiin Wii Emulator Repository"
		sudo add-apt-repository ppa:glennric/dolphin-emu
	fi
	UPDATEREQUIRED="YES"
	return
}
function FlashPrep()
{
	if [ $ARCHITECTURE = "i686" ]
	then
		if [ -f /etc/apt/sources.list.d/partner.list ]
		then
			if [ 2 = $(cat /etc/apt/sources.list | grep partner | grep deb | wc -l) ]
			then
				echo -e $GREEN"*Ubuntu Partner Repository Found*"$ENDCOLOR
				/usr/bin/notify-send "Ubuntu Partner Repository Found"
			else
				echo "=================================================="
				echo -e $BLUE"Adding Ubuntu Partner Repository"$ENDCOLOR
				/usr/bin/notify-send "Adding Ubuntu Partner Repository"
				sudo echo "deb http://archive.canonical.com/ubuntu $CODENAME partner" > ./partner.list
				sudo echo "deb-src http://archive.canonical.com/ubuntu $CODENAME partner" >> ./partner.list
				sudo mv ./partner.list /etc/apt/sources.list.d/partner.list
			fi
		fi
	fi
	if [ $ARCHITECTURE = "x86_64" ]
	then
		if [ -f /etc/apt/sources.list.d/sevenmachines-flash-$CODENAME.list ]
		then
			echo -e $GREEN"*SevenMachines Flash Repository Found*"$ENDCOLOR
			/usr/bin/notify-send "SevenMachines Flash Repository Found"
		else
			echo "=================================================="
			echo -e $BLUE"Adding SevenMachines Flash Repository"$ENDCOLOR
			/usr/bin/notify-send "Adding SevenMachines Flash Repository"
			sudo add-apt-repository ppa:sevenmachines/flash
		fi
		UPDATEREQUIRED="YES"
	fi
	return
}
function GetdebPrep()
{
	if [ -f /etc/apt/sources.list.d/getdeb.list ]
	then
		echo -e $GREEN"*Getdeb Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "Getdeb Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding Getdeb Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding Getdeb Repository"
		sudo echo "deb http://archive.getdeb.net/ubuntu $CODENAME-getdeb apps" > ./getdeb.list
		sudo echo "deb http://archive.getdeb.net/ubuntu $CODENAME-getdeb games" >> ./getdeb.list
		sudo mv ./getdeb.list /etc/apt/sources.list.d/getdeb.list
		wget -q -O- http://archive.getdeb.net/getdeb-archive.key | sudo apt-key add -
	fi
	UPDATEREQUIRED="YES"
		echo -e $BLUE"After this program completes you may add additional software from your package manager or www.getdeb.net"$ENDCOLOR
		/usr/bin/notify-send "After this program completes you may add additional software from your package manager or www.getdeb.net"
	return
}
function gImageReaderPrep()
{
		if [ -f /etc/apt/sources.list.d/alex-p-notesalexp-$CODENAME.list ]
		then
			echo -e $GREEN"*gImageReader Repository Found*"$ENDCOLOR
			/usr/bin/notify-send "gImageReader Repository Found"
		else
			echo "=================================================="
			echo -e $BLUE"Adding The gImageReader Repository"$ENDCOLOR
			/usr/bin/notify-send "Adding The gImageReader Repository"
			sudo add-apt-repository ppa:alex-p/notesalexp
		fi
		UPDATEREQUIRED="YES"
	return
}
function KDEPrep()
{
	if [ -f /etc/apt/sources.list.d/kde35.list ]
	then
		echo -e $GREEN"*KDE 3.5 Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "KDE 3.5 Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding The KDE 3.5 Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding The KDE 3.5 Repository"
		sudo echo "deb http://ppa.quickbuild.pearsoncomputing.net/trinity/trinity/ubuntu $CODENAME main" > ./kde35.list
		sudo echo "deb-src http://ppa.quickbuild.pearsoncomputing.net/trinity/trinity/ubuntu $CODENAME main" >> ./kde35.list
		sudo echo "deb http://ppa.quickbuild.pearsoncomputing.net/trinity/trinity-builddeps/ubuntu $CODENAME main" >> ./kde35.list
		sudo echo "deb-src http://ppa.quickbuild.pearsoncomputing.net/trinity/trinity-builddeps/ubuntu $CODENAME main" >> ./kde35.list
		sudo mv ./kde35.list /etc/apt/sources.list.d/kde35.list
		sudo apt-key adv --keyserver keyserver.quickbuild.pearsoncomputing.net --recv-keys 2B8638D0
	fi
	UPDATEREQUIRED="YES"
	return
}
function KDE46Prep()
{
	if [ -f /etc/apt/sources.list.d/kubuntu-ppa-backports-$CODENAME.list ]
	then
		echo -e $GREEN"*KDE 4.6 Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "KDE 4.6 Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding The KDE 4.6 Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding The KDE 4.6 Repository"
		sudo add-apt-repository ppa:kubuntu-ppa/ppa
	fi
	UPDATEREQUIRED="YES"
	return
}
function FontsPrep()
{
	if [ -f /etc/apt/sources.list.d/medibuntu.list ]
	then
		echo -e $GREEN"*Medibuntu Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "Medibuntu Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding The Medibuntu Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding The Medibuntu Repository"
		sudo wget --output-document=/etc/apt/sources.list.d/medibuntu.list http://www.medibuntu.org/sources.list.d/$CODENAME.list
		sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 2EBC26B60C5A2783
	fi
	UPDATEREQUIRED="YES"
	return
}
function OpenShotPrep()
{
	if [ -f /etc/apt/sources.list.d/jonoomph-openshot-edge-$CODENAME.list ]
	then
		echo -e $GREEN"*OpenShot Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "OpenShot Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding The OpenShot Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding The OpenShot Repository"
		sudo add-apt-repository ppa:jonoomph/openshot-edge
	fi
	UPDATEREQUIRED="YES"
	return
}
function StudioPrep()
{
	if [ -f /etc/apt/sources.list.d/dns-sound-$CODENAME.list ]
	then
		echo -e $GREEN"*Linux Multimedia Studio Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "Linux Multimedia Studio Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding The Linux Multimedia Studio Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding The Linux Multimedia Studio Repository"
		sudo apt-add-repository ppa:dns/sound
	fi
	UPDATEREQUIRED="YES"
	return
}
function PithosPrep()
{
	if [ -f /etc/apt/sources.list.d/kevin-mehall-pithos-daily-$CODENAME.list ]
	then
		echo -e $GREEN"*Pithos Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "Pithos Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding The Pithos Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding The Pithos Repository"
		sudo add-apt-repository ppa:kevin-mehall/pithos-daily
	fi
	UPDATEREQUIRED="YES"
	return
}
function PPAPrep()
{
	if [ -f /etc/apt/sources.list.d/webupd8team-y-ppa-manager-$CODENAME.list ]
	then
		echo -e $GREEN"*Y PPA Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "Y PPA Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding The Y PPA Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding The Y PPA Repository"
		sudo add-apt-repository ppa:webupd8team/y-ppa-manager
	fi
	UPDATEREQUIRED="YES"
	return
}
function RepositoriesPrep()
{
		echo "=================================================="
		echo -e $BLUE"Opening your local package manager to add more repositories"$ENDCOLOR
		/usr/bin/notify-send "Opening your local package manager to add more repositories"
		sudo software-properties-gtk
	return
}
function RestrictedPrep()
{
	if [ -f /etc/apt/sources.list.d/medibuntu.list ]
	then
		echo -e $GREEN"*Medibuntu Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "Medibuntu Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding The Medibuntu Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding The Medibuntu Repository"
		sudo wget --output-document=/etc/apt/sources.list.d/medibuntu.list http://www.medibuntu.org/sources.list.d/$CODENAME.list
		sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 2EBC26B60C5A2783
		wget -q http://medibuntu.sos-sts.com/repo/medibuntu-key.gpg -O- | sudo apt-key add -
	fi
	echo "=================================================="
	echo -e $BLUE"Adding The FreeTuxTV Repository"$ENDCOLOR
	/usr/bin/notify-send "Adding The FreeTuxTV Repository"
	sudo add-apt-repository ppa:freetuxtv/freetuxtv
	echo "=================================================="
	echo -e $BLUE"Adding The Miro Repository"$ENDCOLOR
	/usr/bin/notify-send "Adding The Miro Repository"
	sudo add-apt-repository ppa:pcf/miro-releases
	UPDATEREQUIRED="YES"
	return
}
function SkypePrep()
{
	if [ -f /etc/apt/sources.list.d/medibuntu.list ]
	then
		echo -e $GREEN"*Medibuntu Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "Medibuntu Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding The Medibuntu Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding The Medibuntu Repository"
		sudo wget --output-document=/etc/apt/sources.list.d/medibuntu.list http://www.medibuntu.org/sources.list.d/$CODENAME.list
		sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 2EBC26B60C5A2783
	fi
	UPDATEREQUIRED="YES"
	return
}
function TweakPrep()
{
	if [ -f /etc/apt/sources.list.d/tweak.list ]
	then
		echo -e $GREEN"*Tweak Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "Tweak Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding the Ubuntu Tweak Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding the Ubuntu Tweak Repository"
		sudo echo "deb http://ppa.launchpad.net/tualatrix/ppa/ubuntu $CODENAME main" > ./tweak.list
		sudo echo "deb-src http://ppa.launchpad.net/tualatrix/ppa/ubuntu $CODENAME main" >> ./tweak.list
		sudo mv ./tweak.list /etc/apt/sources.list.d/tweak.list
		sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 6AF0E1940624A220
	fi
	UPDATEREQUIRED="YES"
	return
}
function WinePrep()
{
	if [ -f /etc/apt/sources.list.d/alexandre-montplaisir-winepulse-$CODENAME.list ]
	then
		echo -e $GREEN"*Wine Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "Wine Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding the Wine PPA"$ENDCOLOR
		/usr/bin/notify-send "Adding the Wine PPA"
		sudo add-apt-repository ppa:alexandre-montplaisir/winepulse
	fi
	UPDATEREQUIRED="YES"
	return
}
function Hardware()
{
	echo "=================================================="
	echo -e $RED"Proprietary Hardware Installation..."$ENDCOLOR
	/usr/bin/notify-send "Proprietary Hardware Installation..."
	sudo apt-get -y install linux-firmware-nonfree
	jockey-gtk
	RESTART="YES"
	return
}
function Acrobat()
{
	if [ $ARCHITECTURE = "i686" ]
	then
		echo "=================================================="
		echo -e $RED"Installing Adobe Acrobat Reader"$ENDCOLOR
		/usr/bin/notify-send "Installing Adobe Acrobat Reader"
		/usr/bin/notify-send "Displaying Adobe end user license agreements.  Opening Firefox"
		firefox http://www.adobe.com/products/eulas/&
		zenity --question --text="Do you agree to the terms of end user license agreement (EULA) of Adobe Acrobat Reader?"
		if [ $? == 0 ]
		then
			/usr/bin/notify-send "Installing Adobe Acrobat Reader"
			wget -nc http://ardownload.adobe.com/pub/adobe/reader/unix/9.x/9.4.2/enu/AdbeRdr9.4.2-1_i486linux_enu.bin
			chmod a+x ./AdbeRdr*	
			sudo ./AdbeRdr*
			rm ./AdbeRdr*
		fi
	fi
	if [ $ARCHITECTURE = "x86_64" ]
	then
		echo -e $RED"Sorry - Adobe Acrobat not yet implemented for x86_64"$ENDCOLOR
		/usr/bin/notify-send "Sorry - Adobe Acrobat not yet implemented for x86_64"
	fi
	return
}
function Artha()
{
	echo "=================================================="
	echo -e $RED"Installing Artha Dictionary"$ENDCOLOR
	/usr/bin/notify-send "Installing Artha Dictionary"
	sudo apt-get -y install tcl8.5 tk8.5 wordnet wordnet-base wordnet-gui
	if [ $ARCHITECTURE = "i686" ]
	then
		wget -nc http://downloads.sourceforge.net/project/artha/artha/1.0.2/artha_1.0.2-1_i386.deb
	fi
	if [ $ARCHITECTURE = "x86_64" ]
	then
		wget -nc http://downloads.sourceforge.net/project/artha/artha/1.0.2/artha_1.0.2-1_amd64.deb
	fi
	sudo dpkg -i ./artha*
	rm ./artha*
	return
}
function Blueman()
{
	echo -e $GREEN"Waiting for Blueman BlueTooth Manager to release a package for $DISTROBUTION"$ENDCOLOR
	/usr/bin/notify-send "Waiting for Blueman BlueTooth Manager to release a package for $DISTROBUTION"
#	echo "=================================================="
#	echo -e $RED"Installing Bluetooth Manager"$ENDCOLOR
#	/usr/bin/notify-send "Installing Bluetooth Manager"
#	sudo apt-get -y install blueman
	return
}
function Boxee()
{
	echo "=================================================="
	/usr/bin/notify-send "Displaying Boxee terms of use and privacy policy.  Starting Firefox"
	firefox http://www.boxee.tv/tou http://www.boxee.tv/privacy&
	zenity --question --text="Do you agree to the terms of use and privacy policy of Boxee?"
	if [ $? == 0 ]
	then
		echo -e $RED"Installing Boxee Internet TV"$ENDCOLOR
		/usr/bin/notify-send "Installing Boxee Internet TV"
		sudo apt-get --force-yes -y install screen libxmlrpc-c3-0 libdirectfb-1.2-9 libsdl-gfx1.2-4 libtre5 xsel liblzo2-2 libsdl-image1.2 libhal1 libhal-storage1 libmysqlclient16 mysql-common
		if [ $ARCHITECTURE = "i686" ]
		then
			wget -nc http://dl.boxee.tv/boxee-0.9.22.13692.i486.modfied.deb
		fi
		if [ $ARCHITECTURE = "x86_64" ]
		then
			wget -nc http://dl.boxee.tv/boxee-0.9.22.13692.x86_64.modfied.deb
		fi
		sudo dpkg -i --force-all ./boxee*
		rm ./boxee*
		sudo sed 's/Depends: libasound2 (>> 1.0.14), libc6 (>= 2.6-1), libcurl3, libfreetype6 (>= 2.3.5), libfribidi0 (>= 0.10.7), libgcc1 (>= 1:4.2.1), libglew1.5, libglu1-mesa | libglu1, liblzo2-2, libsdl-image1.2 (>= 1.2.5), libsdl1.2debian (>= 1.2.10-1), libsmbclient (>= 3.0.2a-1), libsqlite3-0 (>= 3.4.2), libstdc++6 (>= 4.2.1), libx11-6, libxinerama1, zlib1g (>= 1:1.2.3.3.dfsg-1), libsdl-gfx1.2-4, libogg0, libvorbis0a, libvorbisenc2, libvorbisfile3, libmad0, libtre4 | libtre5, libdbus-1-3, libhal1, libhal-storage1, libjasper1, libfontconfig1, libbz2-1.0, screen, libmysqlclient16, libxmlrpc-c3, libatk1.0-0, libcairo2, libcomerr2, libcurl3, libdirectfb-1.0-0 | libdirectfb-1.2-0 | libdirectfb-1.2-9, libexpat1, libfontconfig1, libfreetype6, libgcrypt11, libglib2.0-0, libgpg-error0, libgtk2.0-0, libice6, libidl0, libidn11, libkeyutils1, libkrb53 | libkrb5-3, libldap-2.4-2, libnspr4-0d, libnss3-1d, libpango1.0-0, libpcre3, libpixman-1-0, libpng12-0, libsasl2-2, libselinux1, libsm6, libssl0.9.8, libtasn1-3, libuuid1, libxau6, libxcb1, libxcb-render0, libxcomposite1, libxcursor1, libxdamage1, libxdmcp6, libxext6, libxfixes3, libxft2, libxi6, libxrandr2, libxrender1, libxt6, xsel, libsamplerate0, libenca0, libavahi-client3, libpulse0, libmms0, flashplugin-nonfree/Depends: libasound2 (>> 1.0.14), libc6 (>= 2.6-1), libcurl3, libfreetype6 (>= 2.3.5), libfribidi0 (>= 0.10.7), libgcc1 (>= 1:4.2.1), libglew1.5, libglu1-mesa | libglu1, liblzo2-2, libsdl-image1.2 (>= 1.2.5), libsdl1.2debian (>= 1.2.10-1), libsmbclient (>= 3.0.2a-1), libsqlite3-0 (>= 3.4.2), libstdc++6 (>= 4.2.1), libx11-6, libxinerama1, zlib1g (>= 1:1.2.3.3.dfsg-1), libsdl-gfx1.2-4, libogg0, libvorbis0a, libvorbisenc2, libvorbisfile3, libmad0, libtre4 | libtre5, libdbus-1-3, libhal1, libhal-storage1, libjasper1, libfontconfig1, libbz2-1.0, screen, libmysqlclient16, libxmlrpc-c3-0, libatk1.0-0, libcairo2, libcomerr2, libcurl3, libdirectfb-1.0-0 | libdirectfb-1.2-0 | libdirectfb-1.2-9, libexpat1, libfontconfig1, libfreetype6, libgcrypt11, libglib2.0-0, libgpg-error0, libgtk2.0-0, libice6, libidl0, libidn11, libkeyutils1, libkrb53 | libkrb5-3, libldap-2.4-2, libnspr4-0d, libnss3-1d, libpango1.0-0, libpcre3, libpixman-1-0, libpng12-0, libsasl2-2, libselinux1, libsm6, libssl0.9.8, libtasn1-3, libuuid1, libxau6, libxcb1, libxcb-render0, libxcomposite1, libxcursor1, libxdamage1, libxdmcp6, libxext6, libxfixes3, libxft2, libxi6, libxrandr2, libxrender1, libxt6, xsel, libsamplerate0, libenca0, libavahi-client3, libpulse0, libmms0, flashplugin-nonfree/g' /var/lib/dpkg/status > ./status
		sudo cp /var/lib/dpkg/status /var/lib/dpkg/status.bak
		sudo mv ./status /var/lib/dpkg/status
	fi
	return
}
function Cinelerra()
{
	echo "=================================================="
	echo -e $RED"Installing Cinelerra"$ENDCOLOR
	/usr/bin/notify-send "Installing Cinelerra"
	sudo apt-get -y install cinelerra libguicast1 libmpeg3cine libquicktimecine mjpegtools sox twolame mpeg2dec a52dec
	return
}
function Companion()
{
	echo "=================================================="
	echo -e $RED"Installing CLI Companion"$ENDCOLOR
	/usr/bin/notify-send "Installing CLI Companion"
	wget -nc http://launchpad.net/clicompanion/1.0/1.0rc2/+download/clicompanion_1.0-3.1_all.deb
	sudo apt-get -y install most
	sudo dpkg -i clicompanion_1.0-3.1_all.deb
	rm ./clicompanion*
	return
}
function DockBarX()
{
	echo "=================================================="
	echo -e $RED"Installing DockBarX and Avant Window Navigator"$ENDCOLOR
	/usr/bin/notify-send "Installing DockBarX and Avant Window Navigator"
	sudo apt-get -y install dockbarx dockbarx-themes-extra awn-applet-dockbarx
	return
}
function Dolphin()
{
	echo "=================================================="
	echo -e $RED"Installing Dolphin Wii Emulator"$ENDCOLOR
	/usr/bin/notify-send "Installing Dolphin Wii Emulator"
	sudo apt-get -y install dolphin-emu
	return
}
function Dropbox()
{
	echo "=================================================="
	echo -e $RED"Installing Dropbox"$ENDCOLOR
	/usr/bin/notify-send "Installing Dropbox"
#	sudo apt-get -y install nautilus-dropbox
	if [ $ARCHITECTURE = "i686" ]
	then
		wget -nc http://linux.dropbox.com/packages/nautilus-dropbox_0.6.7_i386.deb
	fi
	if [ $ARCHITECTURE = "x86_64" ]
	then
		wget -nc http://linux.dropbox.com/packages/nautilus-dropbox_0.6.7_amd64.deb
	fi
	sudo dpkg -i ./nautilus-dropbox*
	rm ./nautilus-dropbox*
	echo -e $RED"Installing Dropbox Icons"$ENDCOLOR
	/usr/bin/notify-send "Installing Dropbox Icons"
	wget -nc http://dl.dropbox.com/u/209989/mono-icons/dropbox-icons-mono_0.2_all.deb
	sudo dpkg -i ./dropbox-icons*
	rm ./dropbox-icons*
	return
}
function Epidermis()
{
	echo "=================================================="
	echo -e $RED"Waiting for a package that depends on Python 2.7"$ENDCOLOR
#	echo "=================================================="
#	echo -e $RED"Installing Epidermis"$ENDCOLOR
#	/usr/bin/notify-send "Installing Epidermis"
#	wget -nc http://launchpad.net/epidermis/0.x/0.6.1/+download/epidermis-0.6.1.tar.gz
#	sudo apt-get -y install libblas3gf libgfortran3 liblapack3gf python-numpy
#	mkdir ./epidermis-0.6.1
#	tar -xvf ./epidermis-0.6.1.tar.gz
#	cd ./epidermis-0.6.1
#	sudo python setup.py install
#	cd ..
#	rm ./epidermis-0.6.1.tar.gz
	return
}
function Flash()
{
	echo "=================================================="
	echo -e $RED"Installing Adobe Flash Player"$ENDCOLOR
	/usr/bin/notify-send "Installing Adobe Flash Player"
	/usr/bin/notify-send "Displaying Adobe end user license agreements.  Opening Firefox"
	firefox http://www.adobe.com/products/eulas/&
	zenity --question --text="Do you agree to the terms of end user license agreement (EULA) of Adobe Flash Player?"
	if [ $? == 0 ]
	then
		if [ $ARCHITECTURE = "i686" ]
		then
			sudo apt-get -y install flashplugin-installer
		fi
		if [ $ARCHITECTURE = "x86_64" ]
		then
			sudo mkdir /usr/lib/kde4/
			sudo apt-get install flashplugin64-installer
		fi
	fi
	return
}
function gImageReader()
{
	echo "=================================================="
	echo -e $RED"Installing gImageReader"$ENDCOLOR
	/usr/bin/notify-send "Installing gImageReader"
	sudo apt-get -y install tesseract-ocr tesseract-ocr-eng python-enchant python-enchant python-poppler apt-file python-imaging-sane
	wget -nc http://downloads.sourceforge.net/project/gimagereader/0.9/gimagereader_0.9-1_all.deb
	sudo dpkg -i ./gimagereader*
	rm ./gimagereader*
	return
}
function GMapCatcher()
{
	echo "=================================================="
	echo -e $RED"Installing GMapCatcher"$ENDCOLOR
	/usr/bin/notify-send "Installing GMapCatcher"
	wget -nc http://gmapcatcher.googlecode.com/files/mapcatcher_0.7.5.0-1_all.deb
	sudo dpkg -i ./mapcatcher*
	rm ./mapcatcher*
	return
}
function Chrome()
{
	echo "=================================================="
	echo -e $RED"Installing Google Chrome"$ENDCOLOR
	CHROMEINSTALLED=$(dpkg -l | grep google-chrome-beta | awk '{print $2}')
	if  [ $CHROMEINSTALLED = "google-chrome-beta" ]
	then
		zenity --question --text="Google Chrome Stable conflicts with Google Chrome Beta.  Do you wish to replace the beta version with the stable?"
		if [ $? == 0 ]
		then
			echo -e $RED"Google Chrome Beta will be removed during this installation."$ENDCOLOR
		else
			return
		fi
	fi

	/usr/bin/notify-send "Displaying Google Chrome terms of service and privacy policy.  Starting Firefox"
	firefox http://www.google.com/chrome/intl/en/eula_text.html http://www.google.com/chrome/intl/en/privacy.html?platform=linux&
	zenity --question --text="Do you agree to the terms of service and privacy policy of Google Chrome?"
	if [ $? == 0 ]
	then
		/usr/bin/notify-send "Installing Google Chrome"
		if [ $ARCHITECTURE = "i686" ]
		then
			wget -nc http://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb
		fi
		if [ $ARCHITECTURE = "x86_64" ]
		then
			wget -nc http://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
		fi
		sudo apt-get -f remove google-chrome-beta
		sudo apt-get -y install libcurl3 libnspr4-0d libnss3-1d 
		sudo dpkg -i ./google-chrome*
		rm ./google-chrome*
		echo "Acquire::http::Pipeline-Depth "0";" | sudo tee -a /etc/apt/apt.conf.d/90localsettings
	fi
	return
}
function Earth()
{
	echo "=================================================="
	echo -e $RED"Installing Google Earth"$ENDCOLOR
	/usr/bin/notify-send "Installing Google Earth"
	/usr/bin/notify-send "Displaying Google Earth terms of service and privacy policy.  Starting Firefox"
	firefox http://www.google.com/intl/en/help/terms_maps_earth.html http://www.google.com/privacy.html&
	zenity --question --text="Do you agree to the terms of service and privacy policy of Google Earth?"
	if [ $? == 0 ]
	then
		if [ $ARCHITECTURE = "i686" ]
		then
			wget -nc https://dl-ssl.google.com/linux/direct/google-earth-stable_current_i386.deb
			sudo apt-get -y install lsb-core ttf-dejavu ttf-bitstream-vera xfonts-cyrillic
		fi
		if [ $ARCHITECTURE = "x86_64" ]
		then
			wget -nc https://dl-ssl.google.com/linux/direct/google-earth-stable_current_amd64.deb
			sudo apt-get -y install lsb-core ia32-libs ttf-dejavu ttf-bitstream-vera xfonts-cyrillic
		fi
		sudo dpkg -i ./google-earth*
		rm ./google-earth*
	fi
	return
}
function Picasa()
{
	echo "=================================================="
	echo -e $RED"Installing Google Picasa"$ENDCOLOR
	/usr/bin/notify-send "Installing Google Picasa"
	/usr/bin/notify-send "Displaying Google Picasa terms.  Starting Firefox"
	firefox http://picasa.google.com/terms.html&
	zenity --question --text="Do you agree to the terms of Google Picasa?"
	if [ $? == 0 ]
	then
		if [ $ARCHITECTURE = "i686" ]
		then
			wget -nc http://dl.google.com/linux/deb/pool/non-free/p/picasa/picasa_3.0-current_i386.deb
		fi
		if [ $ARCHITECTURE = "x86_64" ]
		then
			wget -nc http://dl.google.com/linux/deb/pool/non-free/p/picasa/picasa_3.0-current_amd64.deb
		fi
		sudo dpkg -i ./picasa*
		rm ./picasa*
	fi
	return
}
function Voice()
{
	echo "=================================================="
	echo -e $RED"Installing Google Voice and Video Chat Plugin"$ENDCOLOR
	/usr/bin/notify-send "Displaying Google Voice and Video Chat Plugin terms of service and privacy policy.  Starting Firefox"
	firefox http://www.google.com/talk/intl/en/terms.html http://www.google.com/talk/intl/en/privacy.html&
	zenity --question --text="Do you agree to the terms of service and privacy policy of Google Voice and Video Chat Plugin?"
	if [ $? == 0 ]
	then
		/usr/bin/notify-send "Installing Google Voice and Video Chat Plugin"
		if [ $ARCHITECTURE = "i686" ]
		then
			wget -nc http://dl.google.com/linux/direct/google-talkplugin_current_i386.deb
		fi
		if [ $ARCHITECTURE = "x86_64" ]
		then
			wget -nc http://dl.google.com/linux/direct/google-talkplugin_current_amd64.deb
		fi
		sudo dpkg -i ./google-talkplugin*
		rm ./google-talkplugin*
	fi
	return
}
function Gtalx()
{
	echo "=================================================="
	echo -e $RED"Installing GtalX"$ENDCOLOR
	/usr/bin/notify-send "Installing GtalX"
	if [ $ARCHITECTURE = "i686" ]
	then
		wget -nc http://sites.google.com/site/jozsefbekes/Home/gtalx/gtalx_0.0.5_i386.deb
	fi
	if [ $ARCHITECTURE = "x86_64" ]
	then
		wget -nc http://sites.google.com/site/jozsefbekes/Home/gtalx/gtalx_0.0.5_amd64.deb
	fi
	sudo apt-get -y install libqt4-gui libmediastreamer0 libortp8
	sudo dpkg -i ./gtalx*
	rm ./gtalx*
	return
}
function GUFW()
{
	echo "=================================================="
	echo -e $RED"Installing GUFW"$ENDCOLOR
	/usr/bin/notify-send "Installing GUFW"
	sudo apt-get -y install gufw
	sudo ufw enable
	echo -e $RED"Starting firewall GUI.  Typically, the firwall is enabled with incoming traffic denied."$ENDCOLOR
	/usr/bin/notify-send "Starting firewall GUI.  Typically, the firwall is enabled with incoming traffic denied."
	sudo gufw
       read -sn 1 -p "Press any key to continue…
"
	return
}
function Hulu()
{
	echo "=================================================="
	echo -e $RED"Installing Hulu"$ENDCOLOR
	/usr/bin/notify-send "Installing Hulu"
	/usr/bin/notify-send "Displaying Hulu terms of service and privacy policy.  Starting Firefox"
	firefox http://www.hulu.com/terms http://www.hulu.com/privacy&
	zenity --question --text="Do you agree to the terms of service and privacy policy of Hulu?"
	if [ $? == 0 ]
	then
		if [ $ARCHITECTURE = "i686" ]
		then
			wget -nc http://download.hulu.com/huludesktop_i386.deb
		fi
		if [ $ARCHITECTURE = "x86_64" ]
		then
			wget -nc http://download.hulu.com/huludesktop_amd64.deb
		fi
		sudo dpkg -i ./huludesktop*
		rm ./huludesktop*
		cat ~/.huludesktop | sed 's/adobe-flashplugin/flashplugin-installer/g' > ./huluconfig
		mv ./huluconfig ~/.huludesktop
	fi
	return
}
function Java()
{
	echo "=================================================="
	echo -e $RED"Installing Java 6"$ENDCOLOR
	/usr/bin/notify-send "Installing Java 6"
	sudo apt-get -y install sun-java6-jre sun-java6-plugin
	return
}
function Burner()
{
	echo "=================================================="
	echo -e $RED"Installing K3B"$ENDCOLOR
	/usr/bin/notify-send "Installing K3B"
	sudo apt-get -y install k3b
	return
}
function KDE()
{
	echo "=================================================="
	echo -e $RED"Installing KDE 3.5"$ENDCOLOR
	/usr/bin/notify-send "Installing KDE 3.5"
	sudo apt-get -y install kubuntu-desktop-kde3
	return
}
function KDE46()
{
	echo "=================================================="
	echo -e $RED"Installing KDE 4.6"$ENDCOLOR
	/usr/bin/notify-send "Installing KDE 4.6"
	sudo apt-get -y install kubuntu-desktop
	return
}
function Libre()
{
	echo "=================================================="
	echo -e $RED"Installing Libre Office Grammar and PDF Import Extensions"$ENDCOLOR
	/usr/bin/notify-send "Installing Libre Office Grammar and PDF Import Extensions"
	wget -nc http://openatd.svn.wordpress.org/atd-openoffice/release/atd-openoffice-0.3.oxt
	if [ $ARCHITECTURE = "i686" ]
	then
		wget -nc http://extensions.services.openoffice.org/e-files/874/29/oracle-pdfimport.oxt
	fi
	if [ $ARCHITECTURE = "x86_64" ]
	then
		wget -nc http://extensions.services.openoffice.org/e-files/874/30/oracle-pdfimport.oxt
	fi
	libreoffice ./atd-openoffice-0.3.oxt ./oracle-pdfimport.oxt
        read -sn 1 -p "Waiting for LibreOffice extension installation. Press any key to continue…
"
	rm ./atd-openoffice*
	rm ./oracle-pdfimport*
	return
}
function Studio()
{
	echo "=================================================="
	echo -e $RED"Installing Linux Multimedia Studio"$ENDCOLOR
	/usr/bin/notify-send "Installing Linux Multimedia Studio"
	sudo apt-get -y install lmms
	return
}
function Lucidor()
{
	echo "=================================================="
	echo -e $RED"Installing Lucidor E-Book Reader"$ENDCOLOR
	/usr/bin/notify-send "Installing Lucidor E-Book Reader"
	wget -nc http://lucidor.org/lucidor/lucidor_0.9.3-1_all.deb
	sudo apt-get -y install xulrunner-1.9.2
	sudo dpkg -i lucidor*
	rm ./lucidor*
	return
}
function Restricted()
{
	echo "=================================================="
	echo -e $RED"Installing Media Players, Codecs & Restricted Extras"$ENDCOLOR
	/usr/bin/notify-send "Installing Restricted Extras & Codecs"
	if [ $ARCHITECTURE = "i686" ]
	then
		sudo apt-get --force-yes install ubuntu-restricted-extras non-free-codecs libdvdcss2 && sudo apt-get -y install w32codecs libdvdcss2 freepats app-install-data-medibuntu apport-hooks-medibuntu vlc vlc-plugin-pulse gxine libvlc5 libvlccore4 vlc-data libxine1 libxine1-bin libxine1-console libxine1-ffmpeg libxine1-misc-plugins libxine1-plugins libxine1-x mplayer smplayer minitube miro mencoder gthumb mozilla-plugin-vlc freetuxtv totem-plugins-extra exaile
	fi
	if [ $ARCHITECTURE = "x86_64" ]
	then
		sudo apt-get --force-yes install ubuntu-restricted-extras non-free-codecs libdvdcss2 && sudo apt-get -y install w64codecs libdvdcss2 freepats app-install-data-medibuntu apport-hooks-medibuntu vlc vlc-plugin-pulse gxine libvlc5 libvlccore4 vlc-data libxine1 libxine1-bin libxine1-console libxine1-ffmpeg libxine1-misc-plugins libxine1-plugins libxine1-x mplayer smplayer minitube miro mencoder gthumb mozilla-plugin-vlc freetuxtv totem totem-common totem-mozilla totem-plugins-extra exaile
	fi
	mkdir -p ~/.local/share/totem/plugins/airplay
#	git clone http://git.sukimashita.com/totem-plugin-airplay.git
	wget -nc http://cgit.sukimashita.com/totem-plugin-airplay.git/snapshot/totem-plugin-airplay-1.0.2.tar.gz
	tar -xvf ./totem-plugin-airplay-1.0.2.tar.gz
	mv ./totem-plugin-airplay*/* ~/.local/share/totem/plugins/airplay/
	rm -rf ./totem-plugin-airplay
	echo -e $RED"Airplay support can be enabled in Totem (Movie Player) under the Edit -> Plugins... menu"$ENDCOLOR
	/usr/bin/notify-send "Airplay support can be enabled in Totem (Movie Player) under the Edit -> Plugins... menu"
	return
}
function Move()
{
	echo "=================================================="
	echo -e $RED"Moving Window Buttons to the Right"$ENDCOLOR
	/usr/bin/notify-send "Moving Window Buttons to the Right"
	sudo -u $ON_USER "DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS gconftool-2 --type string --set /apps/metacity/general/button_layout ":minimize,maximize,close"
	return
}
function Fonts()
{
	echo "=================================================="
	echo -e $RED"Installing MS Fonts and NTFS Support"$ENDCOLOR
	/usr/bin/notify-send "Installing MS Fonts and NTFS Support"
	sudo apt-get -y --force-yes install ttf-mscorefonts-installer ntfsprogs gparted app-install-data-medibuntu apport-hooks-medibuntu && sudo fc-cache -fv
	return
}
function Octoshape()
{
	echo "=================================================="
	echo -e $RED"Installing Octoshape"$ENDCOLOR
	/usr/bin/notify-send "Installing Octoshape"
	if [ -e /usr/lib/libcrypto.so.0.9.8 ]
	then
		echo -e $GREEN"libssl0.9.8 (libcrypto) Verified"$ENDCOLOR
	else
		echo -e $RED"libssl0.9.8 (libcrypto) is needed for Octoshape to run properly.  Installing libssl0.9.8 (libcrypto) "$ENDCOLOR
		sudo apt-get -y install libssl0.9.8
	fi
	if [ -e /usr/bin/mplayer ]
	then
		echo -e $GREEN"mplayer Verified"$ENDCOLOR
	else
		echo -e $RED"mplayer is needed for Octoshape to run properly.  Installing mplayer "$ENDCOLOR
		sudo apt-get -y install mplayer
	fi
	wget -nc http://www.octoshape.com/files/octosetup-linux_i386.bin
	mv ./octosetup-linux_i386.bin ~/octosetup-linux_i386.bin
	cd ~
	chmod a+x ~/octosetup-linux_i386.bin
	~/octosetup-linux_i386.bin
	rm ~/octosetup-linux_i386.bin
	echo "=================================================="
	echo -e $RED"Creating Desktop Icon"$ENDCOLOR
	rm ~/Desktop/Octoshape.sh
	echo -e "~/octoshape/OctoshapeClient&" > ~/Desktop/Octoshape.sh
	echo "zenity --info --text=\"Octoshape Player - Keep window open while streaming.\"" >> ~/Desktop/Octoshape.sh
	chmod a+x ~/Desktop/Octoshape.sh
	return
}
function OpenShot()
{
	echo "=================================================="
	echo -e $RED"Installing OpenShot"$ENDCOLOR
	/usr/bin/notify-send "Installing OpenShot"
	sudo apt-get --force-yes install openshot melt libmlt3
	return
}
function Pithos()
{
	echo "=================================================="
	echo -e $RED"Installing Pithos"$ENDCOLOR
	/usr/bin/notify-send "Installing Pithos"
	sudo apt-get --force-yes install pithos
	return
}
function PPA()
{
	echo "=================================================="
	echo -e $RED"Installing Y PPA Manager"$ENDCOLOR
	/usr/bin/notify-send "Installing Y PPA Manager"
	sudo apt-get --force-yes install y-ppa-manager aptitude launchpad-getkeys libboost-iostreams1.42.0 libcwidget3 ppa-purge yad
	return
}
function Prey()
{
	echo "=================================================="
	echo -e $RED"Installing Prey"$ENDCOLOR
	/usr/bin/notify-send "Installing Prey"
	sudo apt-get -y install scrot streamer libio-socket-ssl-perl libnet-ssleay-perl mpg123 festival traceroute curl
	wget -nc http://preyproject.com/releases/0.5.1/prey_0.5.1-ubuntu2_all.deb
	sudo dpkg -i prey*
	rm ./prey*
	return
}
function Remobo()
{
	echo "=================================================="
	echo -e $RED"Installing Remobo IPN"$ENDCOLOR
	/usr/bin/notify-send "Installing Remobo IPN"
	if [ $ARCHITECTURE = "i686" ]
	then
		wget -nc http://download.remobo.com/debs/i386/remobo_0.50.3-1_i386.deb
	fi
	if [ $ARCHITECTURE = "x86_64" ]
	then
		wget -nc http://download.remobo.com/debs/x86_64/remobo_0.50.3-1_x86_64.deb
	fi
	sudo apt-get -y install chkconfig
	sudo dpkg -i remobo*
	rm ./remobo*
	return
}
function SBackup()
{
	echo "=================================================="
	echo -e $RED"Installing SBackup"$ENDCOLOR
	/usr/bin/notify-send "Installing SBackup"
	sudo apt-get -y install sbackup sbackup-gtk
	return
}
function Skype()
{
	echo "=================================================="
	echo -e $RED"Installing Skype"$ENDCOLOR
	/usr/bin/notify-send "Installing Skype"
	sudo apt-get -y install skype app-install-data-medibuntu apport-hooks-medibuntu
	return
}
function Terminal()
{
	echo "=================================================="
	echo -e $RED"Installing Terminal from Gnome Right Click"$ENDCOLOR
	/usr/bin/notify-send "Installing Terminal from Gnome Right Click"
	sudo apt-get -y install nautilus-open-terminal
	return
}
function Tweak()
{
	echo "=================================================="
	echo -e $RED"Installing Ubuntu Tweak"$ENDCOLOR
	/usr/bin/notify-send "Installing Ubuntu Tweak"
	sudo apt-get -y install ubuntu-tweak
	return
}
function VirtualBox()
{
	echo "=================================================="
	echo -e $RED"Installing VirtualBox"$ENDCOLOR
	/usr/bin/notify-send "Installing VirtualBox"
	if [ $ARCHITECTURE = "i686" ]
	then
		wget -nc http://dlc.sun.com.edgesuite.net/virtualbox/4.1.0/virtualbox-4.1_4.1.0-73009~Ubuntu~$CODENAME\_i386.deb
	fi
	if [ $ARCHITECTURE = "x86_64" ]
	then
		wget -nc http://dlc.sun.com.edgesuite.net/virtualbox/4.1.0/virtualbox-4.1_4.1.0-73009~Ubuntu~$CODENAME\_amd64.deb
	fi
	sudo apt-get -y install libqt4-network libqt4-opengl libqtcore4 libqtgui4 libsdl-ttf2.0-0 libaudio2 libmng1 libqt4-dbus libqt4-xml
	echo -e $RED"Removing Previous VirtualBox Versions"$ENDCOLOR
	/usr/bin/notify-send "Removing Previous VirtualBox Versions"
	sudo apt-get -y remove virtualbox
	sudo dpkg -i virtualbox*
	rm ./virtualbox*
	RESTART="YES"
	echo "=================================================="
	echo -e $RED"Downloading VirtualBox Extensions"$ENDCOLOR
	/usr/bin/notify-send "Downloading VirtualBox Extensions"
	wget -nc http://dlc.sun.com.edgesuite.net/virtualbox/4.1.0/Oracle_VM_VirtualBox_Extension_Pack-4.1.0-73009.vbox-extpack
	echo "=================================================="
	sudo /etc/init.d/vboxdrv setup
	virtualbox&
	echo -e $RED"Starting VirtualBox"$ENDCOLOR
	/usr/bin/notify-send "Starting VirtualBox"
	echo -e $RED"To Add Extensions, Select File -> Preferences -> Extensions, Click on the blue diamond and select the file"$ENDCOLOR
	/usr/bin/notify-send "To Add Extensions, Select File -> Preferences -> Extensions, Click on the blue diamond and select the file"
	read -sn 1 -p "Press any key to continue…"
	return
}
function Mono()
{
	echo "=================================================="
	echo -e $RED"Uninstalling Mono"$ENDCOLOR
	/usr/bin/notify-send "Uninstalling Mono..."
	sudo apt-get purge cli-common mono-runtime libmono*
	echo "Package: cli-common mono-runtime" > ./preferences
	echo "Pin: version *" >> ./preferences
	echo "Pin-Priority: -100" >> ./preferences
	sudo mv ./preferences /etc/apt/preferences
	return
}
function Wine()
{
	echo "=================================================="
	echo -e $RED"Installing Wine with Pulse Patch"$ENDCOLOR
	/usr/bin/notify-send "Installing Wine with Pulse Patch"
	sudo apt-get -y install wine
	return
}
echo -e  $GREEN"BleedingEdge for Ubuntu version $VERSION\n\nCopyright 2009-2011 Paul Fedele.\n\nGPLv3 Licensed.\n\nRun this script in a terminal.\n\nThis script adds software from sources which are not under its control.\n\nNo warranty or guarantee of suitability exists for this software.\n\nUse at your own risk.\n\n"$ENDCOLOR
if [ $CODENAME != $DISTROBUTION ]
then
	echo -e  $RED"Sorry, you are using $CODENAME.  Only Ubuntu $DISTROBUTION is supported.\n\nPlease check the files listed at http://sourceforge.net/projects/bleedingedge/files/ for your distrobution.\n\nAlternately, you can edit line 33 of this script to reflect your distrobution."$ENDCOLOR
	/usr/bin/notify-send "Sorry, you are using Ubuntu $CODENAME.  Only Ubuntu $DISTROBUTION is supported."
	/usr/bin/notify-send "Please check the files listed at http://sourceforge.net/projects/bleedingedge/files/ for your distrobution."
	/usr/bin/notify-send "Alternately, you can edit line 33 of this script to reflect your distrobution."
	read -sn 1 -p "Press any key to terminate."
	echo -e "\n"
	exit 1
fi
if [ $ARCHITECTURE != "i686" ]
then
	if [ $ARCHITECTURE != "x86_64" ]
	then
	echo -e  $RED"Sorry, only i686 and x86_64 architectures are supported."$ENDCOLOR
	sleep 5
	exit 1
	fi
fi
while ps -U root -u root u | grep "synaptic" | grep -v grep > /dev/null;
       do 
       echo -e $RED"Installation can't continue. Please close Synaptic first then try again."$ENDCOLOR
       read -sn 1 -p "Press any key to continue…
"
done
while ps -e | grep "update-manager" | grep -v grep > /dev/null;
       do
       echo -e $RED"Installation can't continue. Please close Update Manager first then try again."$ENDCOLOR
       read -sn 1 -p "Press any key to continue…
"
done
while ps -U root -u root u | grep "software-center" | grep -v grep > /dev/null;
       do 
       echo -e $RED"Installation can't continue. Please close Software Center first then try again."$ENDCOLOR
       read -sn 1 -p "Press any key to continue…
"
done 
while ps -U root -u root u | grep "apt-get" | grep -v grep > /dev/null;
       do
       echo -e $RED"Installation can't continue. Please wait for apt-get to finish running, or terminate the process, then try again."$ENDCOLOR
       read -sn 1 -p "Press any key to continue…
"
done       
while ps -U root -u root u | grep "dpkg" | grep -v grep > /dev/null;
       do 
       echo -e $RED"Installation can't continue. Wait for dpkg to finish running, or exit it, then try again."$ENDCOLOR
       read -sn 1 -p "Press any key to continue…
"
done       
TESTCONNECTION=`wget --tries=3 --timeout=15 www.google.com -O /tmp/testinternet &>/dev/null 2>&1`
if [ $? != 0 ]
then
	echo -e $RED"You are not connected to the Internet. Please check your Internet connection and try again."$ENDCOLOR
else
	echo -e $GREEN"Internet Connection Verified"$ENDCOLOR
fi
if [ -e /usr/bin/wget ]
then
	echo -e $GREEN"Wget Verified"$ENDCOLOR
else
	echo -e $RED"Wget is needed for this script to run properly.  Installing wget"$ENDCOLOR
	sudo apt-get -y install wget
fi
if [ -e /usr/bin/zenity ]
then
	echo -e $GREEN"Zenity Verified"$ENDCOLOR
else
	echo -e $RED"Zenity is needed for this script to run properly.  Installing Zenity"$ENDCOLOR
	sudo apt-get -y install zenity
fi
if [ -e /usr/bin/notify-send ]
then
	echo -e  $GREEN"Notify-osd Verified"$ENDCOLOR
else
	echo -e  $RED"notify-osd is needed for this script to run properly.  Installing notify-osd"$ENDCOLOR
	sudo apt-get -y install notify-osd libnotify-bin
fi
echo -e  $BLUE"Checking for Latest Version"$ENDCOLOR
wget -nc http://sourceforge.net/projects/bleedingedge/files/index.html
LATEST=$(cat ./index.html | grep "Click to download" | head -n 1 | tail -n 1 | awk '{sub("title=\"Click to download BleedingEdge", ""); sub(".sh\"", ""); print $1}')
LAT_MAJ=$(echo $LATEST | awk -F"_" '{print $1}')
LAT_MIN=$(echo $LATEST | awk -F"_" '{print $2}')
VER_MAJ=$(echo $VERSION | awk -F"_" '{print $1}')
VER_MIN=$(echo $VERSION | awk -F"_" '{print $2}')
rm ./index.html
if [ $VER_MAJ = $LAT_MAJ ] && [ $VER_MIN = $LAT_MIN ]
then
	if [ $VERSION = $LATEST ]
	then
		echo -e  $GREEN"Latest Version Verified"$ENDCOLOR
	else
		echo -e  $RED"BleedingEdge Version $VERSION is obsolete.  Latest version available is $LATEST"$ENDCOLOR
		zenity --question --text="You are using BleedingEdge $VERSION .\n\nThe latest version available is $LATEST .\n\nDo you wish to download version $LATEST ?"
		if [ $? == 0 ]
		then
			wget -nc http://downloads.sourceforge.net/project/bleedingedge/BleedingEdge$LATEST.sh
			chmod u+x ./BleedingEdge$LATEST.sh
	        	exec ./BleedingEdge$LATEST.sh&
			exit 0
		fi
	fi
else
	echo -e  $RED"Updates to older versions of Ubuntu are available for manual download at http://sourceforge.net/projects/bleedingedge/files/"$ENDCOLOR
	/usr/bin/notify-send "Updates to older versions of Ubuntu are available for manual download at http://sourceforge.net/projects/bleedingedge/files/"
fi
zenity --question --text="BleedingEdge for Ubuntu version $VERSION\n\nCopyright 2009-2011 Paul Fedele.\n\nGPLv3 Licensed.\n\nRun this script in a terminal.\n\nThis script adds software from sources which are not under its control.\n\nNo warranty or guarantee of suitability exists for this software.\n\nUse at your own risk.\n\nAre you sure you wish to proceed?"
if [ $? == 1 ]
then
	/usr/bin/notify-send "Program Terminated"
	exit 0
fi
/usr/bin/notify-send "Making sure that packages are up to date before installing anything."
zenity --question --text="Updates may be required before continuing\n\nDo you wish to update?"
if [ $? == 0 ]
then
	sudo apt-get update
	zenity --info --text="If the update software pops up, use it before continuing with this script."
fi
ans=$(zenity  --list  --width=600 --height=670 --text "BleedingEdge Ubuntu $CODENAME Installations and Modifications" --checklist  --column "Select" --column "Options" FALSE "Acrobat Reader" FALSE "Additional Repositories" FALSE "Artha Dictionary" FALSE "Boxee" FALSE "Cinelerra video editor" FALSE "CLI Companion" FALSE "DockBarX and Avant Window Navigator" FALSE "Dolphin Wii Emulator" FALSE "Dropbox" FALSE "Epidermis" FALSE "Flash Player" FALSE "Getdeb & Playdeb Repos" FALSE "gImageReader (OCR)" FALSE "GMapCatcher" FALSE "Google Chrome 10" FALSE "Google Earth" FALSE "Google Picasa" FALSE "Google Voice and Video Chat Plugin" FALSE "GUFW Firewall" FALSE "Hulu - Flash Required" FALSE "Java 6" FALSE "K3B CD and DVD Burner" FALSE "KDE 4.6" FALSE "Libre Office Grammar and PDF Import Extensions" FALSE "Lucidor E-book Reader" FALSE "Linux Multimedia Studio" FALSE "Media Players, Codecs, and Restricted Extras" FALSE "Move window buttons to the right" FALSE "MS Core Fonts & NTFS" FALSE "Octoshape Player" FALSE "OpenShot Video Editor" FALSE "Pithos (Pandora App)" FALSE "Prey PC Tracker" FALSE "Proprietary Hardware Drivers" FALSE "Remobo IPN" FALSE "SBackup" FALSE "Skype" FALSE "Terminal from Gnome Right Click" FALSE "Ubuntu Tweak" FALSE "VirtualBox 4.1" FALSE "Wine with Pulse Patch" FALSE "Y PPA Manager" FALSE "Uninstall Mono" --separator=":")
if [ $? == 1 ]
then
	/usr/bin/notify-send "Program Terminated"
	exit 0
fi
arr=$(echo $ans | tr "\:" "\n")
clear
for x in $arr
do
	if [ $x = "Cinelerra" ]
	then
		CinelerraPrep
	fi
	if [ $x = "DockBarX" ]
	then
		DockBarXPrep
	fi
	if [ $x = "Dolphin" ]
	then
		DolphinPrep
	fi
	if [ $x = "Enlightenment" ]
	then
		EnlightenmentPrep
	fi
	if [ $x = "Flash" ]
	then
		FlashPrep
	fi
	if [ $x = "Getdeb" ]
	then
		GetdebPrep
	fi
	if [ $x = "gImageReader" ]
	then
		gImageReaderPrep
	fi
	if [ $x = "3.5" ]
	then
		KDEPrep
	fi
	if [ $x = "4.6" ]
	then
		KDE46Prep
	fi
	if [ $x = "Fonts" ]
	then
		FontsPrep
	fi
	if [ $x = "OpenShot" ]
	then
		OpenShotPrep
	fi
	if [ $x = "Studio" ]
	then
		StudioPrep
	fi
	if [ $x = "Pithos" ]
	then
		PithosPrep
	fi
	if [ $x = "PPA" ]
	then
		PPAPrep
	fi
	if [ $x = "Repositories" ]
	then
		RepositoriesPrep
	fi
	if [ $x = "Restricted" ]
	then
		RestrictedPrep
	fi
	if [ $x = "Skype" ]
	then
		SkypePrep
	fi
	if [ $x = "Tweak" ]
	then
		TweakPrep
	fi
	if [ $x = "Wine" ]
	then
		WinePrep
	fi
done
if [ $UPDATEREQUIRED = "YES" ]
then
	sudo apt-get -q update
fi
for x in $arr
do
	if [ $x = "Hardware" ]
	then
		Hardware
	fi
	if [ $x = "Acrobat" ]
	then
		Acrobat
	fi
	if [ $x = "Artha" ]
	then
		Artha
	fi
	if [ $x = "Blueman" ]
	then
		Blueman
	fi
	if [ $x = "Boxee" ]
	then
		Boxee
	fi
	if [ $x = "Cinelerra" ]
	then
		Cinelerra
	fi
	if [ $x = "Companion" ]
	then
		Companion
	fi
	if [ $x = "DockBarX" ]
	then
		DockBarX
	fi
	if [ $x = "Dolphin" ]
	then
		Dolphin
	fi
	if [ $x = "Dropbox" ]
	then
		Dropbox
	fi
	if [ $x = "Enlightenment" ]
	then
		Enlightenment
	fi
	if [ $x = "Epidermis" ]
	then
		Epidermis
	fi
	if [ $x = "Flash" ]
	then
		Flash
	fi
	if [ $x = "gImageReader" ]
	then
		gImageReader
	fi
	if [ $x = "GMapCatcher" ]
	then
		GMapCatcher
	fi
	if [ $x = "Chrome" ]
	then
		Chrome
	fi
	if [ $x = "Earth" ]
	then
		Earth
	fi
	if [ $x = "Picasa" ]
	then
		Picasa
	fi
	if [ $x = "Voice" ]
	then
		Voice
	fi
	if [ $x = "GtalX" ]
	then
		Gtalx
	fi
	if [ $x = "GUFW" ]
	then
		GUFW
	fi
	if [ $x = "Hulu" ]
	then
		Hulu
	fi
	if [ $x = "Java" ]
	then
		Java
	fi
	if [ $x = "Burner" ]
	then
		Burner
	fi
	if [ $x = "3.5" ]
	then
		KDE
	fi
	if [ $x = "4.6" ]
	then
		KDE46
	fi
	if [ $x = "Libre" ]
	then
		Libre
	fi
	if [ $x = "Studio" ]
	then
		Studio
	fi
	if [ $x = "Lucidor" ]
	then
		Lucidor
	fi
	if [ $x = "PPA" ]
	then
		PPA
	fi
	if [ $x = "Restricted" ]
	then
		Restricted
	fi
	if [ $x = "Move" ]
	then
		Move
	fi
	if [ $x = "Fonts" ]
	then
		Fonts
	fi
	if [ $x = "Octoshape" ]
	then
		Octoshape
	fi
	if [ $x = "OpenShot" ]
	then
		OpenShot
	fi
	if [ $x = "Pithos" ]
	then
		Pithos
	fi
	if [ $x = "Prey" ]
	then
		Prey
	fi
	if [ $x = "Remobo" ]
	then
		Remobo
	fi
	if [ $x = "SBackup" ]
	then
		SBackup
	fi
	if [ $x = "Skype" ]
	then
		Skype
	fi
	if [ $x = "Terminal" ]
	then
		Terminal
	fi
	if [ $x = "Tweak" ]
	then
		Tweak
	fi
	if [ $x = "VirtualBox" ]
	then
		VirtualBox
	fi
	if [ $x = "Wine" ]
	then
		Wine
	fi
	if [ $x = "Mono" ]
	then
		Mono
	fi
done
zenity --question --text="Would you like this program to tidy up\n\nThis involves removing locales (language files).\n\nRemoving old kernels.\n\nRemoving apt cache.\n\nRemoving config files for unused .deb packages.\n\nEmptying the trash."
if [ $? == 0 ]
then
	echo -e $BLUE"\n=================================================="$ENDCOLOR
	echo -e $BLUE"                 Cleaning Up"$ENDCOLOR
	echo -e $BLUE""$ENDCOLOR
	echo -e $BLUE"LocalePurge will remove language files that you do not need"$ENDCOLOR
	echo -e $BLUE"     Use the arrows, space bar, and tab if prompted"$ENDCOLOR
	echo -e $BLUE"=================================================="$ENDCOLOR
	if [ -f /usr/sbin/localepurge ]
		then
			sudo localepurge
		else
			/usr/bin/notify-send "LocalePurge will remove language files that you do not need"
			/usr/bin/notify-send "Use the arrows, space bar, and tab if prompted"
			sudo apt-get -y install localepurge
	fi
	sudo apt-get install
#	sudo apt-get autoremove --purge
	sudo apt-get clean
	sudo updatedb
#	OLDCONF=$(dpkg -l|grep "^rc"|awk '{print $2}')
	CURKERNEL=$(uname -r|sed 's/-*[a-z]//g'|sed 's/-386//g')
	LINUXPKG="linux-(image|headers|ubuntu-modules|restricted-modules)"
	METALINUXPKG="linux-(image|headers|restricted-modules)-(generic|i386|server|common|rt|xen)"
	OLDKERNELS=$(dpkg -l|awk '{print $2}'|grep -E $LINUXPKG |grep -vE $METALINUXPKG|grep -v $CURKERNEL)
	echo -e $RED"Cleaning apt cache..."$ENDCOLOR
#	sudo apt-get clean
#	echo -e $RED"Removing old config files..."$ENDCOLOR
#	sudo apt-get purge $OLDCONF
	if [ -z $OLDKERNELS ]
	then
		echo -e $BLUE"No old kernels found..."$ENDCOLOR
	else
		if [ $RESTART = "YES" ]
		then
			echo -e $RED"You may be using an old kernel.  Reboot on new kernel before removing older versions.."$ENDCOLOR
		else
			echo -e $RED"Removing old kernels..."$ENDCOLOR
			sudo apt-get purge $OLDKERNELS
			RESTART="YES"
		fi
	fi
	echo -e $RED"Emptying the trash..."$ENDCOLOR
	rm -rf /home/*/.local/share/Trash/*/** &> /dev/null
	rm -rf /root/.local/share/Trash/*/** &> /dev/null
fi
zenity --question --text="Would you like to remove repositories that were added while using this program?\n\nYes - Software installed by BleedingEdge will not be updated.\n\nNo - 3rd party repositories can be fickle and mess with DPKG."
if [ $? == 0 ]
then
	echo -e $BLUE"=================================================="$ENDCOLOR
	echo -e $BLUE"                 Removing Repositories"$ENDCOLOR
	echo -e $BLUE"=================================================="$ENDCOLOR
	if [ -f /etc/apt/sources.list.d/alex-p-notesalexp-$CODENAME.list ]
	then
		echo "Removing alex-p-notesalexp-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/alex-p-notesalexp-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/alex-p-notesalexp-$CODENAME.list.save ]
	then
		echo "Removing alex-p-notesalexp-$CODENAME.list.save"
		sudo rm /etc/apt/sources.list.d/alex-p-notesalexp-$CODENAME.list.save
	fi
	if [ -f /etc/apt/sources.list.d/blueman.list ]
	then
		echo "Removing blueman.list"
		sudo rm /etc/apt/sources.list.d/blueman.list
	fi
	if [ -f /etc/apt/sources.list.d/boxee.list ]
	then
		echo "Removing boxee.list"
		sudo rm /etc/apt/sources.list.d/boxee.list
	fi
	if [ -f /etc/apt/sources.list.d/boxee.list.save ]
	then
		echo "Removing boxee.list.save"
		sudo rm /etc/apt/sources.list.d/boxee.list.save
	fi
	if [ -f /etc/apt/sources.list.d/cinelerra-ppa-cinelerra-exp-$CODENAME.list ]
	then
		echo "Removing cinelerra-ppa-cinelerra-exp-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/cinelerra-ppa-cinelerra-exp-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/cinelerra-ppa-cinelerra-exp-$CODENAME.list.save ]
	then
		echo "Removing cinelerra-ppa-cinelerra-exp-$CODENAME.list.save"
		sudo rm /etc/apt/sources.list.d/cinelerra-ppa-cinelerra-exp-$CODENAME.list.save
	fi
	if [ -f /etc/apt/sources.list.d/clicompanion-devs-clicompanion-nightlies-$CODENAME.list ]
	then
		echo "Removing clicompanion-devs-clicompanion-nightlies-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/clicompanion-devs-clicompanion-nightlies-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/nilarimogard-webupd8-$CODENAME.list ]
	then
		echo "Removing nilarimogard-webupd8-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/nilarimogard-webupd8-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/glennric-dolphin-emu-$CODENAME.list ]
	then
		echo "Removing glennric-dolphin-emu-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/glennric-dolphin-emu-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/glennric-dolphin-emu-$CODENAME.list.save ]
	then
		echo "Removing glennric-dolphin-emu-$CODENAME.list.save"
		sudo rm /etc/apt/sources.list.d/glennric-dolphin-emu-$CODENAME.list.save
	fi
	if [ -f /etc/apt/sources.list.d/dropbox.list ]
	then
		echo "Removing dropbox.list"
		sudo rm /etc/apt/sources.list.d/dropbox.list
	fi
	if [ -f /etc/apt/sources.list.d/dropbox.list.save ]
	then
		echo "Removing dropbox.list.save"
		sudo rm /etc/apt/sources.list.d/dropbox.list.save
	fi
	if [ -f /etc/apt/sources.list.d/enlightenment.list ]
	then
		echo "Removing enlightenment.list"
		sudo rm /etc/apt/sources.list.d/enlightenment.list
	fi
	if [ -f /etc/apt/sources.list.d/ubuntu-mozilla-daily-ppa-$CODENAME.list ]
	then
		echo "Removing ubuntu-mozilla-daily-ppa-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/ubuntu-mozilla-daily-ppa-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/ubuntu-mozilla-daily-ppa-$CODENAME.list.save ]
	then
		echo "Removing ubuntu-mozilla-daily-ppa-$CODENAME.list.save"
		sudo rm /etc/apt/sources.list.d/ubuntu-mozilla-daily-ppa-$CODENAME.list.save
	fi
	if [ -f /etc/apt/sources.list.d/freenx.list ]
	then
		echo "Removing freenx.list"
		sudo rm /etc/apt/sources.list.d/freenx.list
	fi
	if [ -f /etc/apt/sources.list.d/freetuxtv-freetuxtv-$CODENAME.list ]
	then
		echo "Removing freetuxtv-freetuxtv-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/freetuxtv-freetuxtv-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/freetuxtv-freetuxtv-$CODENAME.list.save ]
	then
		echo "Removing freetuxtv-freetuxtv-$CODENAME.list.save"
		sudo rm /etc/apt/sources.list.d/freetuxtv-freetuxtv-$CODENAME.list.save
	fi
	if [ -f /etc/apt/sources.list.d/getdeb.list ]
	then
		echo "Removing getdeb.list"
		sudo rm /etc/apt/sources.list.d/getdeb.list
	fi
	if [ -f /etc/apt/sources.list.d/getdeb.list.save ]
	then
		echo "Removing getdeb.list.save"
		sudo rm /etc/apt/sources.list.d/getdeb.list.save
	fi
	if [ -f /etc/apt/sources.list.d/ubuntuzilla-4.7.4-0ubuntu1-i386.deb ]
	then
		echo "Removing ubuntuzilla-4.7.4-0ubuntu1-i386.deb"
		sudo rm /etc/apt/sources.list.d/ubuntuzilla-4.7.4-0ubuntu1-i386.deb
	fi
	if [ -f /etc/apt/sources.list.d/gnumed.list ]
	then
		echo "Removing gnumed.list"
		sudo rm /etc/apt/sources.list.d/gnumed.list
	fi
	if [ -f /etc/apt/sources.list.d/nanny.list ]
	then
		echo "Removing nanny.list"zenity --info --text="If the update software pops up, use it before continuing with this script."
		sudo rm /etc/apt/sources.list.d/nanny.list
	fi
	if [ -f /etc/apt/sources.list.d/google-chrome.list ]
	then
		echo "Removing google-chrome.list"
		sudo rm /etc/apt/sources.list.d/google-chrome.list
	fi
	if [ -f /etc/apt/sources.list.d/google-chrome.list.save ]
	then
		echo "Removing google-chrome.list.save"
		sudo rm /etc/apt/sources.list.d/google-chrome.list.save
	fi
	if [ -f /etc/apt/sources.list.d/google-earth.list ]
	then
		echo "Removing google-earth.list"
		sudo rm /etc/apt/sources.list.d/google-earth.list
	fi
	if [ -f /etc/apt/sources.list.d/google-earth.list.save ]
	then
		echo "Removing google-earth.list.save"
		sudo rm /etc/apt/sources.list.d/google-earth.list.save
	fi
	if [ -f /etc/apt/sources.list.d/google-talkplugin.list ]
	then
		echo "Removing google-talkplugin.list"
		sudo rm /etc/apt/sources.list.d/google-talkplugin.list
	fi
	if [ -f /etc/apt/sources.list.d/google-talkplugin.list.save ]
	then
		echo "Removing google-talkplugin.list.save"
		sudo rm /etc/apt/sources.list.d/google-talkplugin.list.save
	fi
	if [ -f /etc/apt/sources.list.d/dns-sound-$CODENAME.list ]
	then
		echo "Removing dns-sound-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/dns-sound-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/dns-sound-$CODENAME.list.save ]
	then
		echo "Removing dns-sound-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/dns-sound-$CODENAME.list.save
	fi
	if [ -f /etc/apt/sources.list.d/picasa.list ]
	then
		echo "Removing picasa.list"
		sudo rm /etc/apt/sources.list.d/picasa.list
	fi
	if [ -f /etc/apt/sources.list.d/picasa.list.save ]
	then
		echo "Removing picasa.list.save"
		sudo rm /etc/apt/sources.list.d/picasa.list.save
	fi
	if [ -f /etc/apt/sources.list.d/kde35.list ]
	then
		echo "Removing kde35.list"
		sudo rm /etc/apt/sources.list.d/kde35.list
	fi
	if [ -f /etc/apt/sources.list.d/kubuntu-ppa-backports-$CODENAME.list ]
	then
		echo "Removing ./kubuntu-ppa-backports-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/kubuntu-ppa-backports-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/kubuntu-ppa-backports-$CODENAME.list.save ]
	then
		echo "Removing ./kubuntu-ppa-backports-$CODENAME.list.save"
		sudo rm /etc/apt/sources.list.d/kubuntu-ppa-backports-$CODENAME.list.save
	fi
	if [ -f /etc/apt/sources.list.d/kubuntu-ppa-ppa-$CODENAME.list ]
	then
		echo "Removing ./kubuntu-ppa-ppa-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/kubuntu-ppa-ppa-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/kubuntu-ppa-ppa-$CODENAME.list.save ]
	then
		echo "Removing ./kubuntu-ppa-ppa-$CODENAME.list.save"
		sudo rm /etc/apt/sources.list.d/kubuntu-ppa-ppa-$CODENAME.list.save
	fi
	if [ -f /etc/apt/sources.list.d/medibuntu.list ]
	then
		echo "Removing medibuntu.list"
		sudo rm /etc/apt/sources.list.d/medibuntu.list
	fi
	if [ -f /etc/apt/sources.list.d/medibuntu.list.save ]
	then
		echo "Removing medibuntu.list.save"
		sudo rm /etc/apt/sources.list.d/medibuntu.list.save
	fi
	if [ -f /apt/sources.list.d/pcf-miro-releases-$CODENAME.list ]
	then
		echo "Removing pcf-miro-releases-$CODENAME.list"
		sudo rm /apt/sources.list.d/pcf-miro-releases-$CODENAME.list
	fi
	if [ -f /apt/sources.list.d/pcf-miro-releases-$CODENAME.list.save ]
	then
		echo "Removing pcf-miro-releases-$CODENAME.list.save"
		sudo rm /apt/sources.list.d/pcf-miro-releases-$CODENAME.list.save
	fi
	if [ -f /etc/apt/sources.list.d/nvidia.list ]
	then
		echo "Removing nvidia.list"
		sudo rm /etc/apt/sources.list.d/nvidia.list
	fi
	if [ -f /etc/apt/sources.list.d/jonoomph-openshot-edge-$CODENAME.list ]
	then
		echo "Removing ./jonoomph-openshot-edge-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/jonoomph-openshot-edge-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/jonoomph-openshot-edge-$CODENAME.list.save ]
	then
		echo "Removing ./jonoomph-openshot-edge-$CODENAME.list.save"
		sudo rm /etc/apt/sources.list.d/jonoomph-openshot-edge-$CODENAME.list.save
	fi
	if [ -f /etc/apt/sources.list.d/kevin-mehall-pithos-daily-$CODENAME.list ]
	then
		echo "Removing kevin-mehall-pithos-daily-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/kevin-mehall-pithos-daily-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/kevin-mehall-pithos-daily-$CODENAME.list.save ]
	then
		echo "Removing kevin-mehall-pithos-daily-$CODENAME.list.save"
		sudo rm /etc/apt/sources.list.d/kevin-mehall-pithos-daily-$CODENAME.list.save
	fi
	if [ -f /etc/apt/sources.list.d/webupd8team-y-ppa-manager-$CODENAME.list ]
	then
		echo "Removing webupd8team-y-ppa-manager-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/webupd8team-y-ppa-manager-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/webupd8team-y-ppa-manager-$CODENAME.list.save ]
	then
		echo "Removing webupd8team-y-ppa-manager-$CODENAME.list.save"
		sudo rm /etc/apt/sources.list.d/webupd8team-y-ppa-manager-$CODENAME.list.save
	fi
	if [ -f /etc/apt/sources.list.d/pcf-miro-releases-$CODENAME.list ]
	then
		echo "Removing pcf-miro-releases-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/pcf-miro-releases-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/pcf-miro-releases-$CODENAME.list.save ]
	then
		echo "Removing pcf-miro-releases-$CODENAME.list.save"
		sudo rm /etc/apt/sources.list.d/pcf-miro-releases-$CODENAME.list.save
	fi
	if [ -f /etc/apt/sources.list.d/playonlinux.list ]
	then
		echo "Removing playonlinux.list"
		sudo rm /etc/apt/sources.list.d/playonlinux.list
	fi
	if [ -f /etc/apt/sources.list.d/remobo.list ]
	then
		echo "Removing remobo.list"
		sudo rm /etc/apt/sources.list.d/remobo.list
	fi
	if [ -f /etc/apt/sources.list.d/remobo.list.save ]
	then
		echo "Removing remobo.list.save"
		sudo rm /etc/apt/sources.list.d/remobo.list.save
	fi
	if [ -f /etc/apt/sources.list.d/sevenmachines-flash-$CODENAME.list ]
	then
		echo "Removing sevenmachines-flash-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/sevenmachines-flash-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/skype.list ]
	then
		echo "Removing skype.list"
		sudo rm /etc/apt/sources.list.d/skype.list
	fi
	if [ -f /etc/apt/sources.list.d/tualatrix-ppa-$CODENAME.list ]
	then
		echo "Removing tualatrix-ppa-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/tualatrix-ppa-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/tualatrix.list-ppa-$CODENAME.list.save ]
	then
		echo "Removing tualatrix.list-ppa-$CODENAME.list.save"
		sudo rm /etc/apt/sources.list.d/tualatrix-ppa-$CODENAME.list.save
	fi
	if [ -f /etc/apt/sources.list.d/tweak.list ]
	then
		echo "Removing tweak.list"
		sudo rm /etc/apt/sources.list.d/tweak.list
	fi
	if [ -f /etc/apt/sources.list.d/tweak.list.save ]
	then
		echo "Removing tweak.list.save"
		sudo rm /etc/apt/sources.list.d/tweak.list.save
	fi
	if [ -f /etc/apt/sources.list.d/virtualbox.list ]
	then
		echo "Removing virtualbox.list"
		sudo rm /etc/apt/sources.list.d/virtualbox.list
	fi
	if [ -f /etc/apt/sources.list.d/virtualbox.list.save ]
	then
		echo "Removing virtualbox.list.save"
		sudo rm /etc/apt/sources.list.d/virtualbox.list.save
	fi
	if [ -f /etc/apt/sources.list.d/nilarimogard-webupd8-$CODENAME.list ]
	then
		echo "Removing nilarimogard-webupd8-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/nilarimogard-webupd8-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/nilarimogard-webupd8-$CODENAME.list.save ]
	then
		echo "Removing nilarimogard-webupd8-$CODENAME.list.save"
		sudo rm /etc/apt/sources.list.d/nilarimogard-webupd8-$CODENAME.list.save
	fi
	if [ -f /etc/apt/sources.list.d/alexandre-montplaisir-winepulse-$CODENAME.list ]
	then
		echo "Removing alexandre-montplaisir-winepulse-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/alexandre-montplaisir-winepulse-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/alexandre-montplaisir-winepulse-$CODENAME.list.save ]
	then
		echo "Removing alexandre-montplaisir-winepulse-$CODENAME.list.save"
		sudo rm /etc/apt/sources.list.d/alexandre-montplaisir-winepulse-$CODENAME.list.save
	fi
fi
if [ -f /etc/apt/sources.list.d/partner.list ]
then
	echo "Removing partner.list as it may conflict with /etc/apt/sources.list"
	sudo rm /etc/apt/sources.list.d/partner.list
fi
if [ -f /etc/apt/sources.list.d/partner.list.save ]
then
	echo "Removing partner.list.save as it may conflict with /etc/apt/sources.list"
	sudo rm /etc/apt/sources.list.d/partner.list.save
fi
unset CODENAME
unset ARCHITECTURE
unset OLDCONF
unset CURKERNEL
unset LAT_MAJ
unset LAT_MIN
unset LINUXPKG
unset METALINUXPKG
unset OLDKERNELS
unset RED
unset BLUE
unset GREEN
unset ENDCOLOR
unset x
unset y
unset TESTCONNECTION
unset VER_MAJ
unset VER_MIN
unset VERSION
unset LATEST
unset UPDATEREQUIRED
if [ $RESTART = "YES" ]
then
	echo -e $BLUE"\nDone! Restart your computer to apply the changes."$ENDCOLOR
	/usr/bin/notify-send "Done! Restart your computer to apply the changes."
else
	echo -e $GREEN"\nDone!  This program will end in 5 seconds."$ENDCOLOR
	/usr/bin/notify-send "Done!  This program will end in 5 seconds."
fi
unset RESTART
sleep 5
exit 0
