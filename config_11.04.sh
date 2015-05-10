#!/bin/bash

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Invoque este Script em root!"
    exit
fi

echo Update INI
sudo rm /var/lib/apt/lists/*
sudo rm /var/lib/apt/lists/partial/*
sudo dpkg --configure -a
sudo apt-get --yes update
sudo apt-get --yes upgrade
echo Update END

echo Reset Unity INI
unity --reset
gconftool-2 --recursive-unset /apps/compiz-1
unity --reset
echo Reset Unity END

echo Activar Fontes restrited INI
sudo echo "# deb cdrom:[Ubuntu 10.04.1 LTS _Lucid Lynx_ - Release i386 (20100816.1)]/ lucid main restricted" > /etc/apt/sources.list
sudo echo "# See http://help.ubuntu.com/community/UpgradeNotes for how to upgrade to" >> /etc/apt/sources.list
sudo echo "# newer versions of the distribution." >> /etc/apt/sources.list
sudo echo "" >> /etc/apt/sources.list
sudo echo "deb http://pt.archive.ubuntu.com/ubuntu/ natty main restricted" >> /etc/apt/sources.list
sudo echo "deb-src http://pt.archive.ubuntu.com/ubuntu/ natty main restricted" >> /etc/apt/sources.list
sudo echo "" >> /etc/apt/sources.list
sudo echo "## Major bug fix updates produced after the final release of the" >> /etc/apt/sources.list
sudo echo "## distribution." >> /etc/apt/sources.list
sudo echo "deb http://pt.archive.ubuntu.com/ubuntu/ natty-updates main restricted" >> /etc/apt/sources.list
sudo echo "deb-src http://pt.archive.ubuntu.com/ubuntu/ natty-updates main restricted" >> /etc/apt/sources.list
sudo echo "" >> /etc/apt/sources.list
sudo echo "## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu" >> /etc/apt/sources.list
sudo echo "## team. Also, please note that software in universe WILL NOT receive any" >> /etc/apt/sources.list
sudo echo "## review or updates from the Ubuntu security team." >> /etc/apt/sources.list
sudo echo "deb http://pt.archive.ubuntu.com/ubuntu/ natty universe" >> /etc/apt/sources.list
sudo echo "deb-src http://pt.archive.ubuntu.com/ubuntu/ natty universe" >> /etc/apt/sources.list
sudo echo "deb http://pt.archive.ubuntu.com/ubuntu/ natty-updates universe" >> /etc/apt/sources.list
sudo echo "deb-src http://pt.archive.ubuntu.com/ubuntu/ natty-updates universe" >> /etc/apt/sources.list
sudo echo "" >> /etc/apt/sources.list
sudo echo "## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu" >> /etc/apt/sources.list
sudo echo "## team, and may not be under a free licence. Please satisfy yourself as to" >> /etc/apt/sources.list
sudo echo "## your rights to use the software. Also, please note that software in" >> /etc/apt/sources.list
sudo echo "## multiverse WILL NOT receive any review or updates from the Ubuntu" >> /etc/apt/sources.list
sudo echo "## security team." >> /etc/apt/sources.list
sudo echo "deb http://pt.archive.ubuntu.com/ubuntu/ natty multiverse" >> /etc/apt/sources.list
sudo echo "deb-src http://pt.archive.ubuntu.com/ubuntu/ natty multiverse" >> /etc/apt/sources.list
sudo echo "deb http://pt.archive.ubuntu.com/ubuntu/ natty-updates multiverse" >> /etc/apt/sources.list
sudo echo "deb-src http://pt.archive.ubuntu.com/ubuntu/ natty-updates multiverse" >> /etc/apt/sources.list
sudo echo "" >> /etc/apt/sources.list
sudo echo "## Uncomment the following two lines to add software from the 'backports'" >> /etc/apt/sources.list
sudo echo "## repository." >> /etc/apt/sources.list
sudo echo "## N.B. software from this repository may not have been tested as" >> /etc/apt/sources.list
sudo echo "## extensively as that contained in the main release, although it includes" >> /etc/apt/sources.list
sudo echo "## newer versions of some applications which may provide useful features." >> /etc/apt/sources.list
sudo echo "## Also, please note that software in backports WILL NOT receive any review" >> /etc/apt/sources.list
sudo echo "## or updates from the Ubuntu security team." >> /etc/apt/sources.list
sudo echo "deb http://pt.archive.ubuntu.com/ubuntu/ natty-backports main restricted universe multiverse" >> /etc/apt/sources.list
sudo echo "# deb-src http://pt.archive.ubuntu.com/ubuntu/ lucid-backports main restricted universe multiverse" >> /etc/apt/sources.list
sudo echo "" >> /etc/apt/sources.list
sudo echo "## Uncomment the following two lines to add software from Canonical's" >> /etc/apt/sources.list
sudo echo "## 'partner' repository." >> /etc/apt/sources.list
sudo echo "## This software is not part of Ubuntu, but is offered by Canonical and the" >> /etc/apt/sources.list
sudo echo "## respective vendors as a service to Ubuntu users." >> /etc/apt/sources.list
sudo echo "deb http://archive.canonical.com/ubuntu natty partner" >> /etc/apt/sources.list
sudo echo "deb-src http://archive.canonical.com/ubuntu natty partner" >> /etc/apt/sources.list
sudo echo "" >> /etc/apt/sources.list
sudo echo "deb http://security.ubuntu.com/ubuntu natty-security main restricted" >> /etc/apt/sources.list
sudo echo "deb-src http://security.ubuntu.com/ubuntu natty-security main restricted2" >> /etc/apt/sources.list
sudo echo "deb http://security.ubuntu.com/ubuntu natty-security universe" >> /etc/apt/sources.list
sudo echo "deb-src http://security.ubuntu.com/ubuntu natty-security universe" >> /etc/apt/sources.list
sudo echo "deb http://security.ubuntu.com/ubuntu natty-security multiverse" >> /etc/apt/sources.list
sudo echo "deb-src http://security.ubuntu.com/ubuntu natty-security multiverse" >> /etc/apt/sources.list
sudo echo "deb http://extras.ubuntu.com/ubuntu natty main #Third party developers repository" >> /etc/apt/sources.list
sudo apt-get --yes update
echo Activar Fontes restrited END

echo Restricted Extras Install
sudo apt-get --yes install ubuntu-restricted-extras
sudo apt-get --yes install gstreamer0.10-plugins-good gstreamer0.10-plugins-bad gstreamer0.10-plugins-bad-multiverse gstreamer0.10-plugins-ugly gstreamer0.10-plugins-ugly-multiverse gstreamer0.10-ffmpeg ffmpeg libavcodec-extra-52 libavdevice-extra-52 libavfilter-extra-0 libavformat-extra-52 libavutil-extra-49 libavswscale-extra-0 libpostproc-extra-51 flac faac faad lame twolame vorbis-tools mpeg2dec mjpegtools transcode transcode-utils mplayer mencoder x264
echo Restricted Extras Install

echo Mediubuntu INI
sudo wget --output-document=/etc/apt/sources.list.d/medibuntu.list http://www.medibuntu.org/sources.list.d/$(lsb_release -cs).list && 
sudo apt-get --yes --quiet update
sudo apt-get --yes --quiet --allow-unauthenticated install medibuntu-keyring
sudo apt-get --yes --quiet update
sudo apt-get --yes install app-install-data-medibuntu apport-hooks-medibuntu
echo Mediubuntu END

echo UbuntuTweak INI
sudo add-apt-repository ppa:tualatrix/ppa 
sudo apt-get --yes update
sudo apt-get --yes install ubuntu-tweak
echo UbuntuTweak END

echo Samba INI
sudo apt-get --yes install samba smbfs system-config-samba
echo Samba END

echo Vlc INI
sudo apt-get --yes install vlc
echo Vlc END

echo Codecs INI
sudo  apt-get --yes install non-free-codecs libxine1-ffmpeg gxine mencoder libquicktime1 flac faac faad sox ffmpeg2theora libmpeg2-4 uudeview flac libmpeg3-1 mpeg3-utils mpegdemux liba52-dev mpeg2dec  vorbis-tools id3v2 mpg321 mpg123 libflac++6 ffmpeg libmp4v2-0 totem-mozilla icedax tagtool easytag id3tool lame  nautilus-script-audio-convert libmad0 libjpeg-progs
echo Codecs END

echo DVD INI
sudo apt-get --yes install libdvdcss2 && sudo /usr/share/doc/libdvdread4/./install-css.sh
echo DVD END

echo Flash INI
sudo apt-get --yes remove flashplugin-* --purge
sudo apt-get --yes install flashplugin-nonfree
echo Flash END

echo DejaDump INI
sudo apt-get --yes install deja-dup
echo DejaDump END

echo FileZilla INI
sudo apt-get --yes install filezilla
echo FileZilla END

echo Java INI
sudo add-apt-repository ppa:ferramroberto/java
sudo apt-get --yes update
sudo apt-get --yes install sun-java6-jre sun-java6-plugin sun-java6-fonts
echo Java END

echo Gimp INI
sudo add-apt-repository ppa:matthaeus123/mrw-gimp-svn
sudo apt-get --yes update
sudo apt-get --yes install gimp gimp-data gimp-plugin-registry gimp-data-extras
echo Gimp END

echo Screenlets INI
sudo apt-add-repository ppa:screenlets/ppa 
sudo apt-get --yes update 
sudo apt-get --yes install screenlets
echo Screenlets END

echo IOTOP INI
sudo apt-get --yes install iotop
echo IOTOP END

echo Compress INI
sudo apt-get --yes install unace unrar zip unzip p7zip-full p7zip-rar sharutils rar uudeview mpack lha arj cabextract file-roller
echo Compress END

echo PPA INI
sudo add-apt-repository ppa:webupd8team/y-ppa-manager
sudo apt-get --yes update
sudo apt-get --yes install y-ppa-manager
echo PPA END

echo UNetbootin INI
sudo add-apt-repository ppa:gezakovacs/ppa
sudo apt-get --yes update
sudo apt-get --yes install unetbootin
sudo apt-get --yes install syslinux
sudo apt-get --yes install extlinux
echo UNetbootin END

echo Webmin INI
wget http://ftp.debian.org/pool/main/libm/libmd5-perl/libmd5-perl_2.03-1_all.deb
wget http://prdownloads.sourceforge.net/webadmin/webmin_1.510-2_all.deb
sudo dpkg -i libmd5-perl_2.03-1_all.deb
dpkg -i webmin_1.510-2_all.deb
sudo /etc/init.d/webmin  start
echo "Para usar webmin visite https://localhost:10000"
echo Webmin END

echo Xbmc INI
sudo add-apt-repository ppa:team-xbmc
sudo echo "deb http://ppa.launchpad.net/team-xbmc/ppa/ubuntu maverick main" > /etc/apt/sources.list.d/team-xbmc-ppa-natty.list
sudo echo "deb-src http://ppa.launchpad.net/team-xbmc/ppa/ubuntu maverick main" >> /etc/apt/sources.list.d/team-xbmc-ppa-natty.list
sudo echo "deb http://ppa.launchpad.net/team-xbmc/ppa/ubuntu maverick main" > /etc/apt/sources.list.d/team-xbmc-ppa-natty.list.save
sudo echo "deb-src http://ppa.launchpad.net/team-xbmc/ppa/ubuntu maverick main" >> /etc/apt/sources.list.d/team-xbmc-ppa-natty.list.save
sudo apt-get --yes update
sudo apt-get --yes install xbmc
echo Xbmc END

echo Geany INI
sudo add-apt-repository ppa:geany-dev/ppa
sudo apt-get --yes update
sudo apt-get --yes install geany geany-plugins
echo Geany END

echo Puddletag INI
sudo add-apt-repository ppa:webupd8team/puddletag
sudo apt-get --yes update
sudo apt-get --yes install puddletag
echo Puddletag END

echo EasyTAG INI
sudo apt-get --yes install easytag-aac
echo EasyTAG END

echo GtkPod INI
sudo apt-get --yes install gtkpod
echo GtkPod END

echo Kid3 INI
sudo apt-get --yes install kid3
echo Kid3 END

echo Picard INI
sudo apt-get --yes install picard
echo Picard END

echo Chrome INI
sudo echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
sudo echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list.distUpgrade
sudo echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list.save
sudo apt-get update
sudo apt-get --yes install google-chrome-stable
echo Chrome END

echo Terminator INI
sudo add-apt-repository ppa:gnome-terminator/ppa
sudo apt-get --yes update
sudo apt-get --yes install terminator
echo Terminator END

echo Webcam Sony Vaio VGN-FE41E INI
sudo add-apt-repository ppa:r5u87x-loader/ppa
sudo apt-get --yes update
sudo apt-get --yes install r5u87x
sudo /usr/share/r5u87x/r5u87x-download-firmware.sh
echo Webcam Sony Vaio VGN-FE41E END

echo Jdowloader INI
sudo add-apt-repository ppa:jd-team/jdownloader
sudo apt-get --yes update
sudo apt-get --yes install jdownloader
echo Jdowloader END

echo Applet Battery Status INI
sudo add-apt-repository ppa:iaz/battery-status
sudo apt-get --yes update
sudo apt-get --yes install battery-status
echo Applet Battery Status END

echo Applet Touchpad INI
sudo add-apt-repository ppa:lorenzo-carbonell/atareao
sudo apt-get --yes update
sudo apt-get --yes install touchpad-indicator
echo Applet Touchpad END

echo Applet Weather INI
sudo add-apt-repository ppa:lorenzo-carbonell/atareao
sudo apt-get --yes update
sudo apt-get --yes install my-weather-indicator
echo Applet Weather END

echo Applet CPU INI
sudo add-apt-repository ppa:artfwo/ppa
sudo apt-get --yes update
sudo apt-get --yes install indicator-cpufreq
echo Applet CPU END

echo Applet Lookit INI
sudo add-apt-repository ppa:lookit/ppa
sudo apt-get --yes update
sudo apt-get --yes install lookit
echo Applet Lookit END

echo Applet VirtualBox INI
sudo add-apt-repository ppa:michael-astrapi/ppa
sudo apt-get --yes update
sudo apt-get --yes install indicator-virtualbox
echo Applet VirtualBox END

echo Applet My Wheater Indicator INI
sudo add-apt-repository ppa:atareao/atareao
sudo apt-get --yes update
sudo apt-get --yes install my-weather-indicator
echo Applet My Wheater Indicator END

echo Applet WallpaperChange INI
sudo add-apt-repository ppa:michael-astrapi/ppa
sudo apt-get --yes update
sudo apt-get --yes install desktopnova indicator-desktopnova
echo Applet WallpaperChange END

echo BleachBit INI
sudo apt-get --yes install bleachbit
echo BleachBit END

echo BleedingEdge INI
wget http://sourceforge.net/projects/bleedingedge/files/BleedingEdge11_04_7.sh/download
mv download BleedingEdge11_04_7.sh
chmod +x BleedingEdge11_04_7.sh
./BleedingEdge11_04_7.sh
echo BleedingEdge END

echo Clean INI
sudo apt-get --yes -f install
sudo rm /var/lib/apt/lists/*
sudo rm /var/lib/apt/lists/partial/*
sudo apt-get --yes update
sudo apt-get --yes upgrade
rm libmd5-perl_2.03-1_all.deb
rm webmin_1.510-2_all.deb
sudo apt-get --yes clean
sudo apt-get --yes autoremove

echo Clean END
