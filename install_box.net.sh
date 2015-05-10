#!/usr/bin/env bash
# autor: j.francisco.o.rocha@gmail.com
# 2012

CHAVE="dia19mes10"
EMAIL="paparoka@gmail.com"
USER=$(whoami)
PASTA=$(echo $EMAIL | awk -F@ '{print $1}')

declare -rx SCRIPT=${0##*/}
declare IFS=$'\n'

echo "Durante a execução de este script vão ser usados os seguintes dados:"
echo "Chave: $CHAVE"
echo "Email: $EMAIL"
echo "Utilizador: $USER"
echo "Pasta: $PASTA"
echo ""
echo -e "Para executar este script tem de previamente atribuir password ao root (sudo su -> passwd)"
echo -e "Durante a execução do script essa password será solicitada 5x"
read -p "Precione qualquer tecla para continuar ou faça [CTRL]+[C] para abortar..." -n1 -s
echo -e ""

# As myuser:
echo -e "Criando a Pasta ~/Box.Net/$PASTA"
mkdir -p ~/Box.Net/$PASTA
echo -e "Criando a Pasta ~/.davfs2"
mkdir ~/.davfs2 
echo -e "Adicionando o comando use_locks 0 em ~/.davfs2/davfs2.conf"
echo "use_locks 0" > ~/.davfs2/davfs2.conf
echo -e "Adicionando o o email e a password a ~/.davfs2/secrets"
echo "https://www.box.net/dav $EMAIL $CHAVE" > ~/.davfs2/secrets
echo -e "Alterando atributos de ~/.davfs2/secrets para 600"
chmod 600 ~/.davfs2/secrets

# As root:
echo "Instalar davfs2 ..."
su - root -c "apt-get install -y davfs2"
echo "Adicionar utlizador $USER a davfs2 ..."
su - root -c "adduser $USER davfs2"
echo "Adicionar ponto de montagem /home/$USER/Box.Net/$PASTA no fstab ..."
su - root -c "echo 'https://www.box.net/dav /home/$USER/Box.Net/$PASTA davfs rw,user,noauto 0 0' >> /etc/fstab"
echo "Atribuir permissões u+s a mount.davfs ..."
su - root -c "chmod u+s /usr/sbin/mount.davfs"
echo "Agora tem montada na pasta /home/$USER/Box.Net/$PASTA a sua conta BOx.Net!"
mount /home/$USER/Box.Net/$PASTA
