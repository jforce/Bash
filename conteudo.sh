#!/bin/bash
#

clear

#data="$(date +%d%m%y)"
dia="$(date +%d)"
mes="$(date +%B)"
ano="$(date +%Y)"
hora="$(date +%H)"
min="$(date +%M)"

echo "Processando DISC01..."
cd /media/DISC01
mkdir -p AMinhaMusica
mkdir -p AsMinhasSeries
mkdir -p OsMeusDocumentarios
mkdir -p OsMeusFilmes
mkdir -p OsMeusFilmesHD
mkdir -p OsMeusFilmesInfantis
mkdir -p OsMeusVideosMusicais
find -maxdepth 2 -type d | sort > /tmp/listaA.txt
sed -e 's/^.\{1\}//g' -e '/^$/d' -e 's/^.\{1\}//g' -e 's/\(.*\)/\1@DISC01/' /tmp/listaA.txt > /tmp/lista_A.txt

echo "Processando DISC02..."
cd /media/DISC02
mkdir -p AMinhaMusica
mkdir -p AsMinhasSeries
mkdir -p OsMeusDocumentarios
mkdir -p OsMeusFilmes
mkdir -p OsMeusFilmesHD
mkdir -p OsMeusFilmesInfantis
mkdir -p OsMeusVideosMusicais
find -maxdepth 2 -type d | sort > /tmp/listaB.txt
sed -e 's/^.\{1\}//g' -e '/^$/d' -e 's/^.\{1\}//g' -e 's/\(.*\)/\1@DISC02/' /tmp/listaB.txt > /tmp/lista_B.txt

echo "Processando DISC03..."
cd /media/DISC03
mkdir -p AMinhaMusica
mkdir -p AsMinhasSeries
mkdir -p OsMeusDocumentarios
mkdir -p OsMeusFilmes
mkdir -p OsMeusFilmesHD
mkdir -p OsMeusFilmesInfantis
mkdir -p OsMeusVideosMusicais
find -maxdepth 2 -type d | sort > /tmp/listaC.txt
sed -e 's/^.\{1\}//g' -e '/^$/d' -e 's/^.\{1\}//g' -e 's/\(.*\)/\1@DISC03/' /tmp/listaC.txt > /tmp/lista_C.txt

echo "Processando DISC04..."
cd /media/DISC04
mkdir -p AMinhaMusica
mkdir -p AsMinhasSeries
mkdir -p OsMeusDocumentarios
mkdir -p OsMeusFilmes
mkdir -p OsMeusFilmesHD
mkdir -p OsMeusFilmesInfantis
mkdir -p OsMeusVideosMusicais
find -maxdepth 2 -type d | sort > /tmp/listaD.txt
sed -e 's/^.\{1\}//g' -e '/^$/d' -e 's/^.\{1\}//g' -e 's/\(.*\)/\1@DISC04/' /tmp/listaD.txt > /tmp/lista_D.txt

echo "Processando DISC05..."
cd /media/DISC05
mkdir -p AMinhaMusica
mkdir -p AsMinhasSeries
mkdir -p OsMeusDocumentarios
mkdir -p OsMeusFilmes
mkdir -p OsMeusFilmesHD
mkdir -p OsMeusFilmesInfantis
mkdir -p OsMeusVideosMusicais
find -maxdepth 2 -type d | sort > /tmp/listaE.txt
sed -e 's/^.\{1\}//g' -e '/^$/d' -e 's/^.\{1\}//g' -e 's/\(.*\)/\1@DISC05/' /tmp/listaE.txt > /tmp/lista_E.txt

echo "Gerando Relatorio..."
cat /tmp/lista_*.txt > /tmp/lista_.txt
cat /tmp/lista_.txt | sort -d  | column -t -s"/" > /tmp/lista_1.txt
sed -e 's/\(.*\@\)\(.*\)/\2 \1/' -e 's/\@//' -e '/lost+found/ d' -e '/.Trash-1000/ d' -e '/AsMinhasImagens/ d' -e '/OutrosAssuntos/ d' -e '/AsMinhasSeries/ d' -e '/AsMinhasFotos/ d' -e '/OsMeusVideosFamiliares/ d' /tmp/lista_1.txt > $HOME/conteudo.csv
sed -i 's/ AMinhaMusica                   /;AMinhaMusica;/g' $HOME/conteudo.csv
sed -i 's/ AsMinhasSeries                 /;AsMinhasSeries;/g' $HOME/conteudo.csv
sed -i 's/ OsMeusDocumentarios            /;OsMeusDocumentarios;/g' $HOME/conteudo.csv
sed -i 's/ OsMeusFilmes                   /;OsMeusFilmes;/g' $HOME/conteudo.csv
sed -i 's/ OsMeusFilmesHD                 /;OsMeusFilmesHD;/g' $HOME/conteudo.csv
sed -i 's/ OsMeusFilmesInfantis           /;OsMeusFilmesInfantis;/g' $HOME/conteudo.csv
sed -i 's/ OsMeusVideosMusicais           /;OsMeusVideosMusicais;/g' $HOME/conteudo.csv

sed -i '/ AMinhaMusica/ d' $HOME/conteudo.csv
sed -i '/ AsMinhasSeries/ d' $HOME/conteudo.csv
sed -i '/ OsMeusDocumentarios/ d' $HOME/conteudo.csv
sed -i '/ OsMeusFilmes/ d' $HOME/conteudo.csv
sed -i '/ OsMeusFilmesHD/ d' $HOME/conteudo.csv
sed -i '/ OsMeusFilmesInfantis/ d' $HOME/conteudo.csv
sed -i '/ OsMeusVideosMusicais/ d' $HOME/conteudo.csv

sed -i '1i\Disco;Categoria;Conteúdo a '$dia' de '$mes' de '$ano' às '$hora'.'$min'' $HOME/conteudo.csv

rm /tmp/lista*.txt



