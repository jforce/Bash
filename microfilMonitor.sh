#!/bin/bash

# Ciclo
# Impressora -> salamadra (scan-docs/..\mtiff) -> portal > salamandra (documentos/..\gz) -> microfil (/ \gz)

dadosRP () {
servidor="192.168.7.181"
utilizador="ftpuser"
chave="grym0l4u"
pasta1="/scan-docs"
file1="mtiff"
pasta2="/documentos"
file2="gz"

}

dadosMicrofil () {
servidor="172.28.1.10"
utilizador="ftpmicrofil"
chave="microfil.2008"
pasta="/"
file="gz"
}

function verifica () {
ftp -in <<EOF | grep $pasta
open $servidor
user $utilizador $chave
ls -lR
close
bye
EOF
}


dadosRP
verifica
dadosMicrofil
verifica
