#!/usr/bin/env bash
#! autor: cfjrocha@gmail.com
#! 2008

clear
echo "  ____________________________________________________"
echo "||  A Criar Folha de Calculo com conteudo dos HD's... ||"
echo "||____________________________________________________||"
echo

dia="$(date +%d)"
mes="$(date +%B)"
ano="$(date +%Y)"
hora="$(date +%H)"
min="$(date +%M)"

echo "Processando DISC01..."
mkdir -p /media/DISC01/AMinhaMusica
mkdir -p /media/DISC01/AsMinhasSeries
mkdir -p /media/DISC01/OsMeusDocumentarios
mkdir -p /media/DISC01/OsMeusFilmes
mkdir -p /media/DISC01/OsMeusFilmesHD
mkdir -p /media/DISC01/OsMeusFilmesInfantis
mkdir -p /media/DISC01/OsMeusVideosMusicais
du --max-depth=2 /media/DISC01/ > /tmp/lista_.txt
sed -e 's/\/media\///g' -e 's/\//\t/g' /tmp/lista_.txt > /tmp/lista_0.txt

echo "Processando DISC02..."
mkdir -p /media/DISC02/AMinhaMusica
mkdir -p /media/DISC02/AsMinhasSeries
mkdir -p /media/DISC02/OsMeusDocumentarios
mkdir -p /media/DISC02/OsMeusFilmes
mkdir -p /media/DISC02/OsMeusFilmesHD
mkdir -p /media/DISC02/OsMeusFilmesInfantis
mkdir -p /media/DISC02/OsMeusVideosMusicais
du --max-depth=2 /media/DISC02/ > /tmp/lista_.txt
sed -e 's/\/media\///g' -e 's/\//\t/g' /tmp/lista_.txt >> /tmp/lista_0.txt

echo "Processando DISC03..."
mkdir -p /media/DISC03/AMinhaMusica
mkdir -p /media/DISC03/AsMinhasSeries
mkdir -p /media/DISC03/OsMeusDocumentarios
mkdir -p /media/DISC03/OsMeusFilmes
mkdir -p /media/DISC03/OsMeusFilmesHD
mkdir -p /media/DISC03/OsMeusFilmesInfantis
mkdir -p /media/DISC03/OsMeusVideosMusicais
du --max-depth=2 /media/DISC03/ > /tmp/lista_.txt
sed -e 's/\/media\///g' -e 's/\//\t/g' /tmp/lista_.txt >> /tmp/lista_0.txt


echo "Processando DISC04..."
mkdir -p /media/DISC04/AMinhaMusica
mkdir -p /media/DISC04/AsMinhasSeries
mkdir -p /media/DISC04/OsMeusDocumentarios
mkdir -p /media/DISC04/OsMeusFilmes
mkdir -p /media/DISC04/OsMeusFilmesHD
mkdir -p /media/DISC04/OsMeusFilmesInfantis
mkdir -p /media/DISC04/OsMeusVideosMusicais
du --max-depth=2 /media/DISC04/ > /tmp/lista_.txt
sed -e 's/\/media\///g' -e 's/\//\t/g' /tmp/lista_.txt >> /tmp/lista_0.txt


echo "Processando DISC05..."
mkdir -p /media/DISC05/AMinhaMusica
mkdir -p /media/DISC05/AsMinhasSeries
mkdir -p /media/DISC05/OsMeusDocumentarios
mkdir -p /media/DISC05/OsMeusFilmes
mkdir -p /media/DISC05/OsMeusFilmesHD
mkdir -p /media/DISC05/OsMeusFilmesInfantis
mkdir -p /media/DISC05/OsMeusVideosMusicais
du --max-depth=2 /media/DISC05/ > /tmp/lista_.txt
sed -e 's/\/media\///g' -e 's/\//\t/g' /tmp/lista_.txt >> /tmp/lista_0.txt


echo "Gerando Relatorio..."
# Remover pastas indesejadas
sed -e '/lost+found/ d' -e '/.Trash-1000/ d' -e '/AsMinhasImagens/ d' -e '/OutrosAssuntos/ d' -e '/AsMinhasFotos/ d' -e '/OsMeusVideosFamiliares/ d' /tmp/lista_0.txt > /tmp/lista_1.txt
# Ordenar colunas, remover niveis indesejados e ordenar linhas
awk -F "\t" '{printf "%s\t%s\t%s\t%s\n", $3,$4,$1,$2}' /tmp/lista_1.txt | awk 'NF > 3' | sort -d > $HOME/conteudo.csv
# Adicionar linha de cabeçalho
sed -i '1i\Categoria\tConteúdo a '$dia' de '$mes' de '$ano' às '$hora'.'$min'\tTamanho\tDisco' $HOME/conteudo.csv

echo "Gerando Relatorio de repetições"
awk -F"\t" '{if (x[$2]) { x_count[$2]++; print $0; if (x_count[$2] == 1) { print x[$2] } } x[$2] = $0}' $HOME/conteudo.csv | awk -F "\t" '{printf "%s\t%s\t%s\t%s\n", $2,$1,$3,$4}' | sort -d > $HOME/conteudo_repetido.csv

# Remover ficheiros indesejados
rm /tmp/lista_*.txt
