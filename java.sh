#!/usr/bin/env bash
#
# Oracle java installer
# j.francisco.o.rocha@gmail.com
# ./java.sh
#

function escolherJava () {
	sudo update-alternatives --config java
	}

function javaFireTest () {
	if [[ -e $HOME/.mozilla/plugins/libnpjp2.so ]]; then
	echo -e "O ficheiro $HOME/.mozilla/plugins/libnpjp2.so existe."
	fireTestF=0
	firefox http://java.com/pt_BR/download/installed.jsp?detect=jre&try=1 &
	else
	echo -e "O ficheiro $HOME/.mozilla/plugins/libnpjp2.so não existe."
	fireTestF=1

	fi
	}

function javajre6 () {
	escolherJava
	mkdir -p $HOME/java/javajre6
	cd $HOME/java/javajre6
	if [[ ! -e jre-6-linux-i586.bin ]]; then
	wget --timeout 30 -t 1 -O - http://javadl.sun.com/webapps/download/AutoDL?BundleId=63251 > $HOME/java/javajre6/jre-6-linux-i586.bin
	fi
	chmod u+x jre-6-linux-i586.bin
	./jre-6-linux-i586.bin
	pasta=$( ls --directory jre*/ | sed -e 's/\///g' )
	if [[ ! -e /usr/lib/jvm/$pasta ]]; then
	sudo mv --force $pasta/ /usr/lib/jvm/
	else
	rm -rf $pasta
	fi
	sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/$pasta/bin/java" 1
	sudo update-alternatives --install "/usr/lib/mozilla/plugins/libjavaplugin.so" "mozilla-javaplugin.so" "/usr/lib/jvm/$pasta/lib/i386/libnpjp2.so" 1
	read -p "Precione [ENTER] para continuar ou [CTRL]+[C] para abortar"
	escolherJava
	}

function javajdk6 () {
	escolherJava
	mkdir -p $HOME/java/javajdk6
	cd $HOME/java/javajdk6
	wget http://download.oracle.com/otn-pub/java/jdk/6u31-b04/jdk-6u31-linux-i586.bin
	chmod u+x jdk-6u31-linux-i586.bin
	./jdk-6u31-linux-i586.bin
	mv jdk1.6.0_31 /usr/lib/jvm/
	sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.6.0_31/bin/java" 1
	sudo update-alternatives --install "/usr/lib/mozilla/plugins/libjavaplugin.so" "mozilla-javaplugin.so" "/usr/lib/jvm/jdk1.6.0_31/jre/lib/i386/libnpjp2.so" 1
	escolherJava
}

function javajre7 () {
	escolherJava
	mkdir -p $HOME/java/javajre7
	cd $HOME/java/javajre7
	wget http://download.oracle.com/otn-pub/java/jdk/7u4-b20/jre-7u4-linux-i586.tar.gz
	tar -xvf jre-7u4-linux-i586.tar.gz
	sudo mv ./jre1.7.0* /usr/lib/jvm/jre1.7.0
	update-alternatives --install /usr/bin/java java /usr/lib/jvm/jre1.7.0/bin/java 3
	escolherJava
	}

function javajdk7 () {
	escolherJava
	sudo add-apt-repository ppa:webupd8team/java && sudo apt-get update
	sudo apt-get install oracle-jdk7-installer
#	mkdir -p $HOME/java/javajdk7
#	cd $HOME/java/javajdk7
#	wget http://download.oracle.com/otn-pub/java/jdk/7/jdk-7-linux-i586.tar.gz
#	tar -xvf jdk-7-linux-i586.tar.gz
#	sudo mv ./jdk1.7.0* /usr/lib/jvm/jdk1.7.0
#	sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.7.0/bin/java" 1
#	sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk1.7.0/bin/javac" 1
#	sudo update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/jvm/jdk1.7.0/bin/javaws" 1
	escolherJava
	}

function javajre7Fire () {
		pasta=$( ls --directory /usr/lib/jvm/jre1.7*/ | awk -F'/' '{ print $5 }' )
	if [[ -e /usr/lib/jvm/$pasta/lib/i386/libnpjp2.so ]]; then
		if [[ -e $HOME/.mozilla/plugins/libnpjp2.so ]]; then
		rm $HOME/.mozilla/plugins/libnpjp2.so
		else
		mkdir $HOME/.mozilla/plugins
		fi
	sudo apt-get remove icedtea-plugin
	ln -s /usr/lib/jvm/$pasta/lib/i386/libnpjp2.so $HOME/.mozilla/plugins/
	else
	echo -e "O ficheiro /usr/lib/jvm/$pasta/lib/i386/libnpjp2.so não existe"
	echo -e "O plugin não foi instalado"
	fi
	}

function javajre6Fire () {
	pasta=$( ls --directory /usr/lib/jvm/jre1.6*/ | awk -F'/' '{ print $5 }' )
	if [[ -e /usr/lib/jvm/$pasta/lib/i386/libnpjp2.so ]]; then
		if [[ -e $HOME/.mozilla/plugins/libnpjp2.so ]]; then
		rm $HOME/.mozilla/plugins/libnpjp2.so
		else
		mkdir $HOME/.mozilla/plugins
		fi
	sudo apt-get remove icedtea-plugin
	ln -s /usr/lib/jvm/$pasta/lib/i386/libnpjp2.so $HOME/.mozilla/plugins/
	else
	echo -e "O ficheiro /usr/lib/jvm/$pasta/lib/i386/libnpjp2.so não existe"
	echo -e "O plugin não foi instalado"
	fi
	}

function menu () {
	let "loop=0"
	while test $loop == 0
	do
	opcao=$( dialog                        \
		--stdout                           \
		--menu 'Oracle - Java'             \
		0 0 0                              \
		A 'Instalar Java jre 6'            \
		B 'Instalar Java jre 7'            \
		C 'Instalar Java jdk 6'            \
		D 'Instalar Java jdk 7'            \
		E 'Instalar Firefox Java 6 plugin' \
		F 'Instalar Firefox Java 7 plugin' \
		G 'Escolher versão  de Java'       \
		H 'Testar Firefox Plugin Java'     \
		0 'Sair'   )

	case $opcao in a|A)
	javajre6
	read -p "Precione [CTRL]+[C] para abortar ou [ENTER] para continuar"
	esac
	case $opcao in b|B)
	javajre7
	read -p "Precione [CTRL]+[C] para abortar ou [ENTER] para continuar"
	esac
	case $opcao in c|C)
	javajdk6
	read -p "Precione [CTRL]+[C] para abortar ou [ENTER] para continuar"
	esac
	case $opcao in d|D)
	javajdk7
	read -p "Precione [CTRL]+[C] para abortar ou [ENTER] para continuar"
	esac
	case $opcao in e|E)
	javajre6Fire
	read -p "Precione [CTRL]+[C] para abortar ou [ENTER] para continuar"
	esac
	case $opcao in f|F)
	javajre7Fire
	read -p "Precione [CTRL]+[C] para abortar ou [ENTER] para continuar"
	esac
	case $opcao in g|G)
	escolherJava
	read -p "Precione [CTRL]+[C] para abortar ou [ENTER] para continuar"
	esac
	case $opcao in h|H)
	javaFireTest
	read -p "Precione [CTRL]+[C] para abortar ou [ENTER] para continuar"
	esac
	case $opcao in 0)
	let "loop=1"
	clear
	esac

	done
	}

menu
