#! /bin/bash
 
#   ****************************************************************************************
#      cieQemu - Script de criação, instalação e emulação de imagem   
#         do Qemu         
#   ****************************************************************************************
#      Este é meu primeiro script definitivo!      
#                  
#      Fiquei feliz com o resultado e estou postanto-o aqui em   
#   primeira-mão no Viva-o-Linux, em agradecimento e retribuição à    
#   esta comunidade que tem me ajudado muito com tutoriais, dicas e   
#   artigos!
#   ****************************************************************************************
#      Para o funcionamento deste script, é necessário que   
#   você tenha os pacotes bash e Xdialog --center  instalados no sistema e, claro,   
#   o pacote qemu. O pacote kqemu é opcional.         
#   ****************************************************************************************
#      Todo o script está muito bem comentado para que possa   
#   ser acompanhado passo-a-passo. Ideal para quem está inicializando   
#   em Shellscript e (X)Dialog!            
#   ****************************************************************************************
#      Comentários, críticas construtivas, correções e sugestões    
#   serão muito bem vindas! Reitero meus agradecimentos à comunidade!   
#   ****************************************************************************************
#      Por: Sedan75 - Guarulhos, SP - 14.09.2007      
#      e-mail/e-messenger: sedan75@linuxmail.org      
#   ****************************************************************************************
 
 
#============================#
# Apresentação  do QEMU e do script  #
#============================#
 
   Xdialog --center  --beep --title "Qemu" --msgbox "O QEMU é um emulador de sistemas, ou seja, \n
         ele cria uma máquina virtual dentro de um arquivo (imagem), \n
         com o tamanho limitado pelo usuário \n
         e instala um sistema operacional dentro dele. \n \n
         Uma imagem qemu possue extensão *qcow*. Veja o exemplo abaixo:\n
         imagem_qemu.qcow" 0 0
 
   Xdialog --center  --title "cieQemu" --msgbox "Este script irá auxilia-lo: \n\n
         * na criação de uma imagem qemu; \n
         * na instalação de um sistema operacional dentro de uma imagem qemu; \n
         * na emulação de uma imagem qemu finalizada. \n\n
         Requer pacotes Qemu, Bash, Xdialog --center  e Kqemu(opcional) instalados.\n\n
         Criado por: Sedan75 - sedan75@linuxmail.org" 0 0
 
while : ; do
 
#===============#
# Opções do Script   #
#===============#
 
opcao=$(
      Xdialog --center  --stdout               \
             --title 'cieQemu - Menu'  \
             --menu 'Selecione uma das opções abaixo:' \
            11 80 0                   \
            1 'Criar uma Imagem qemu' \
            2 'Instalar um Sistema Operacional dentro de uma Imagem qemu previamente criada' \
            3 'Emular uma imagem com um Sistema Operacional previamente criada' \
            0 'Cancelar/Sair' )
 
 
#====================================================#
# Se CANCELAR ou ESC for precionado a execução será interrompida  #
#====================================================#
 
    [ $? -ne 0 ] && Xdialog --center  --beep --title "Cancelado" --msgbox "Execução cancelada pelo usuário." 0 0 && exit
 
#===============================#
# Se opcao for = 0 (zero) cancela o script  #
#===============================#
 
if [ $opcao = 0 ]; then Xdialog --center  --beep --title "Cancelado" --msgbox "Execução cancelada pelo usuário." 0 0 && exit
fi
 
#============================#
# Se opcao for = 1 cria imagem qemu  #
#============================#
 
if [ $opcao = 1 ]; then Xdialog --center  --title "cieQemu - Criar imagem" --yesno "Você optou por criar uma imagem do qemu.\n \n
            Este script irá criar uma imagem dinâmica, ou seja, \n
            vai aumentando conforme são gravados dados até \n
            um limite máximo estipulado." 0 0
 
#====================================================#
# Se CANCELAR ou ESC for precionado a execução será interrompida #
#====================================================#
 
[ $? = 1 ] && Xdialog --center  --beep --title "Cancelado" --msgbox "Execução cancelada pelo usuário." 0 0 && exit
 
#============================#
# Criar um nome para a imagem qemu #
#============================#
 
nameimage=$( Xdialog --center  --title "cieQemu - Nome da imagem" --stdout --inputbox "Crie um nome para a imagem qemu: \n \n
               obs: não adicione a extensão *qcow* ao nome da imagem! \n
               Ela será criada automaticamente!" --center --textbox  "imagem" 0 0 )
 
#====================================================#
# Se CANCELAR ou ESC for precionado a execução será interrompida #
#====================================================#
 
[ $? = 1 ] && Xdialog --center  --beep --title "Cancelado" --msgbox "Execução cancelada pelo usuário." 0 0 && exit
 
#==============================================#
# Informa ao usuário o nome da imagem qemu que será criada #
#==============================================#
 
Xdialog --center  --title "cieQemu - Nome da imagem" --msgbox "Uma imagem qemu com o nome: $nameimage.qcow, será criada." 0 0
 
#==================================#
# Estipula o tamanho máximo da imagem qemu #
#==================================#
 
tamimage=$( Xdialog --center  --title "cieQemu - Tamanho da imagem" --stdout --inputbox 'Informe em MB o tamanho máximo para a imagem qemu \n
                  que será criada. \n \n
               (somente números)' --center --textbox  "1000" 0 0)
 
#====================================================#
# Se CANCELAR ou ESC for precionado a execução será interrompida #
#====================================================#
 
[ $? = 1 ] && Xdialog --center  --beep --title "Cancelado" --msgbox "Execução cancelada pelo usuário." 0 0 && exit
 
#=======================================================#
# Informa ao usuário o tamanho máximo da imagem qemu que será criada   #
#=======================================================#
 
Xdialog --center  --title "cieQemu - Tamanho da imagem" --msgbox "A imagem qemu: $nameimage, à ser criada terá o tamanho máximo de \n
                $tamimage MB." 0 0
 
m="M"
 
#============================================#
# Seleciona o diretório em que a imagem qemu será gravada #
#============================================#
 
dirimage=$( Xdialog --center  --title "cieQemu - Diretório da imagem" --stdout --inputbox "Informe o diretório onde a imagem $nameimage\n
               será criada."   --center --textbox  "/home/$USER/Desktop/" 0 0 )
 
#====================================================#
# Se CANCELAR ou ESC for precionado a execução será interrompida #
#====================================================#
 
[ $? = 1 ] && Xdialog --center  --beep --title "Cancelado" --msgbox "Execução cancelada pelo usuário." 0 0 && exit
 
#================================================#
# Informa ao usuário aonde a imagem qemu será criada/gravada   #
#================================================#
 
Xdialog --center  --title "cieQemu - Diretório da imagem" --msgbox "A imagem qemu: $nameimage, será criada no seguinte diretório: \n
                $dirimage" 0 0
 
#===========================================#
# Confirma ao usuário os dados para a criação de imagem #
#===========================================#
 
Xdialog --center  --title "cieQemu - Confirmação" --yesno \
"Nome da imagem qemu: $nameimage.qcow \n
Diretório de criação da imagem $nameimage: $dirimage \n
Tamanho máximo da imagem $nameimage: $tamimage MB" 0 0
 
#====================================================#
# Se CANCELAR ou ESC for precionado a execução será interrompida #
#====================================================#
  
[ $? = 1 ] && Xdialog --center  --beep --title "Cancelado" --msgbox "Execução cancelada pelo usuário." 0 0 && exit
 
#=======================#
# Aplicando as opções no qemu #
#=======================#
 
qemu-img create -f qcow $dirimage$nameimage.qcow $tamimage$m
 
#=================================#
# Informa ao usuario que a Imagem foi criada #
#=================================#
 
Xdialog --center  --title "cieQemu - Imagem criada" --msgbox "A criação da imagem $nameimage.qcow foi concluida.\n \n
            Verifique no diretório $dirimage \n
            se a imagem $nameimage.qcow foi criada \n
            com sucesso." 0 0
 
#================================#
# Fim do script de criação de imagem qemu #
#================================#
 
fi
 
#############################################################################################################
#############################################################################################################
 
#===================================================================================#
# Se opcao for = 2 inicia instalação do sistema operacional e/ou programas na imagem qemu previamente criada  #
#===================================================================================#
 
if [ $opcao = 2 ]; then Xdialog --center  --title "cieQemu - Instalação de S.O" --yesno "Voce optou por instalar um Sistema Operacional \n
               numa imagem qemu previamente criada." 0 0
 
#====================================================#
# Se CANCELAR ou ESC for precionado a execução será interrompida #
#====================================================#
 
[ $? = 1 ] && Xdialog --center  --beep --title "Cancelado" --msgbox "Execução cancelada pelo usuário." 0 0 && exit
 
#==============================================================#
# Definindo o dispositivo de boot para iniciar a instalação de um Sistema Operacional #
#==============================================================#
 
boot=$(
      Xdialog --center  --stdout               \
             --title 'cieQemu - Definindo dispositivo de boot'  \
             --menu 'Selecione o dispositivo que iniciará o CD ou DVD \n
   de instalação do Sistema Operacional que deseja instalar: \n \n
   obs: Lembre-se de que para instalar o Win98 ou Win98se, você deve \n
   primeiramente dar boot pelo floppy com o disquete de inicialização e, \n
   somente após formatar a máquina virtual (imagem qemu) com o fdisk, \n
   continuar a instalação dando boot pelo drive de CD/DVD.' \
            16 80 0                   \
            1 'Dispositivo de disquete (floppy)' \
            2 'Dispositivo de CD/DVD ' \
            0 'Cancelar/Sair' )
 
#====================================================#
# Se CANCELAR ou ESC for precionado a execução será interrompida  #
#====================================================#
 
    [ $? -ne 0 ] && Xdialog --center  --beep --title "Cancelado" --msgbox "Execução cancelada pelo usuário." 0 0 && exit
 
#===============================#
# Se opcao for = 0 (zero) cancela o script  #
#===============================#
 
if [ $boot = 0 ]; then Xdialog --center  --beep --title "Cancelado" --msgbox "Execução cancelada pelo usuário." 0 0 && exit
fi
 
#================================#
# Se opcao for = 1 variavel "bootini" = floppy #
#================================#
 
if [ $boot = 1 ]; then
 
      bootini="floppy/disquete"
      qemuboot="-boot a"
 
#====================================#
# Informa ao usuário a opcao de boot selecionada #
#====================================#
 
Xdialog --center  --title "cieQemu - Definindo dispositivo de boot" --msgbox "O dispositivo de boot selecionado foi o $bootini." 0 0
 
#===================================#
# Pede que o usuário informe dispositivo de boot #
#===================================#
 
      disquete=$( Xdialog --center  --title "cieQemu - Floppy" --stdout \
      --inputbox "Informe o caminho do dispositivo de $bootini:" --center --textbox  "/dev/fd0" 0 0)
      dev="-fda $disquete"
 
#====================================================#
# Se CANCELAR ou ESC for precionado a execução será interrompida  #
#====================================================#
 
    [ $? -ne 0 ] && Xdialog --center  --beep --title "Cancelado" --msgbox "Execução cancelada pelo usuário." 0 0 && exit
 
#=================================#
# Inserindo o disco de inicialização/instalação #
#=================================#
 
      Xdialog --center  --title "cieQemu - Disco de instalação" --msgbox "Insira agora o disco de inicialização/instalação\nno drive de $bootini." 0 0
fi
 
#==================================#
# Se opcao for = 2 variavel "bootini" = CD/DVD #
#==================================#
 
if [ $boot = 2 ]; then
 
      bootini="CD/DVD"
      qemuboot="-boot d"
 
#====================================#
# Informa ao usuário a opcao de boot selecionada #
#====================================#
 
Xdialog --center  --title "cieQemu - Definindo dispositivo de boot" --msgbox "O dispositivo de boot selecionado foi o $bootini." 0 0
 
#===================================#
# Pede que o usuário informe dispositivo de boot #
#===================================#
 
      cddvd=$( Xdialog --center  --title "cieQemu - CD/DVD" --stdout \
      --inputbox "Informe o caminho do dispositivo de $bootini:" --center --textbox  "/dev/hdc" 0 0)
      dev="-cdrom $cddvd"
 
#====================================================#
# Se CANCELAR ou ESC for precionado a execução será interrompida  #
#====================================================#
 
    [ $? -ne 0 ] && Xdialog --center  --beep --title "Cancelado" --msgbox "Execução cancelada pelo usuário." 0 0 && exit
 
#========================#
# Inserindo o disco de instalação #
#========================#
 
      eject $cddvd
      Xdialog --center  --title "cieQemu - Disco de instalação" --msgbox "Insira agora o disco de\ninstalação no drive de $bootini e clique em *OK*." 0 0 && eject -t $cddvd
 
fi
 
#======================================================================================#
# (1) Usar acelerador Kqemu? (S/N) | Informa que o Kqemu será utilizado | (2) Informa que o kqemu não será utilizado #
#======================================================================================#
 
Xdialog --center  --title "cieQemu - Acelerador Kqemu" --stdout --yesno "Habilitar acelerador Kqemu?\nRecomendado: NÃO" 6 45
 
#======================================================#
# Se ESC ou NAO for precionado o acelerador Kqemu não será habilitado #
#======================================================#
 
if [ $? = 1 ]; then
   kqemu="-no-kqemu"
   Xdialog --center  --title "cieQemu - Acelerador Kqemu" --msgbox "Acelerador Kqemu DESABILITADO." 6 35
else
 
#======================================#
# Informa ao usuário que o Kqemu estará habilitado  #
#======================================#
 
   kqemu=" "
   Xdialog --center  --title "cieQemu - Acelerador Kqemu" --msgbox "Acelerador Kqemu HABILITADO." 6 35
 
fi
 
#===========================================================================#
# Solicita ao usuário informar o valor de memória (somente números) à reservar para a máquina virtual #
#===========================================================================#
 
memoria=$( Xdialog --center  --title "cieQemu - Memória" --stdout --inputbox "Informe o valor de memória para o qemu.\n
         Recomendado: 128MB\n(Apenas números)" --center --textbox  "128" 10 45 )
 
#====================================================#
# Se CANCELAR ou ESC for precionado a execução será interrompida #
#====================================================#
 
   [ $? -eq 1 ] && Xdialog --center  --beep --title "Cancelado" --msgbox "Execução cancelada pelo usuário." 0 0 && exit
 
#======================================================#
# Informa ao usuário o valor de memória reservado para a máquina virtual #
#======================================================#
 
Xdialog --center  --title "cieQemu - Memória" --msgbox "Você reservou $memoria MB para o qemu." 5 40
 
#===============================================#
# Solicita ao usuário a indicar a imagem qemu que será emulada #
#===============================================#
 
imagem=$( Xdialog --center  --title "cieQemu - Selecionar imagem" --stdout --fselect "/home/$USER/Desktop/" 0 0 )
 
#====================================================#
# Se CANCELAR ou ESC for precionado a execução será interrompida #
#====================================================#
 
   [ $? -eq 1 ] && Xdialog --center  --beep --title "Cancelado" --msgbox "Execução cancelada pelo usuário." 0 0 && exit
 
#=========================================#
# Informa ao usuário o caminho e a imagem selecionada #
#=========================================#
    
Xdialog --center  --title "cieQemu - Selecionar imagem" --msgbox "Imagem selecionada: $imagem" 0 0
 
#==================================#
# Aplicando as opcoes de instalação no QEMU #
#==================================#
 
qemu $dev $qemuboot -m $memoria $kqemu $imagem
fi
 
#==============================================#
# Fim do script de instalação de sistema operacional na imagem #
#==============================================#
 
#========================================#
# Pergunta ao usuário se deseja voltar ao menu principal #
#========================================#
 
############################################################################################################
############################################################################################################
 
#==============================================#
# Se opcao for = 3 inicia script de emulacao de imagem pronta  #
#==============================================#
 
if [ $opcao = 3 ]; then
         
   Xdialog --center  --title "cieQemu - Emular imagem" --yesno "Voce optou por emular uma imagem qemu previamente criada." 0 0
 
#====================================================#
# Se CANCELAR ou ESC for precionado a execução será interrompida #
#====================================================#
 
[ $? = 1 ] && Xdialog --center  --beep --title "Cancelado" --msgbox "Execução cancelada pelo usuário." 0 0 && exit
 
#===========================#
# Inicio da configuração de emulação #
#===========================#
 
#==============================================================================================#
# (1) Compartilhar CD/DVD? (S/N) | Entrar com o path do CD/DVD | Exibir o path selecionado | (2) Não compartilhando CD/DVD #
#==============================================================================================#
 
Xdialog --center  --title "cieQemu - CD/DVD" --yesno "Compartilhar dispositivo de CD/DVD?" 5 40
   if [ $? = 0 ]; then
      cd=$( Xdialog --center  --title "cieQemu - CD/DVD" --stdout --inputbox "Informe o caminho do dispositivo do CD/DVD:" --center --textbox  "/dev/hdc" 10 45 ) \
         && eject $cd && Xdialog --center  --title "cieQemu - CD/DVD" --msgbox "Para compartilhar o dispositivo de CD/DVD,\n
         você deve inserir um disco no drive." 0 0 && eject -t $cd
 
#====================================================#
# Se CANCELAR ou ESC for precionado a execução será interrompida #
#====================================================#
 
   [ $? -eq 1 ] && Xdialog --center  --beep --title "Cancelado" --msgbox "Execução cancelada pelo usuário." 0 0 && exit
 
#============================================#
# Confirma ao usuário o caminho do dispositivo de CD/DVD  #
#============================================#
 
   cddvd="-cdrom $cd"
   Xdialog --center  --title "cieQemu - CD/DVD" --msgbox "Caminho do dispositivo do CD/DVD: $cd" 5 45
 
else
 
#=====================================================#
# Informa ao usuário que não será compartilhado dispositivo de CD/DVD #
#=====================================================#
 
   cddvd=" "
   Xdialog --center  --title "cieQemu" --msgbox "Ok, NÃO compartilhando CD/DVD."  5 35
 
fi
 
#===========================================================================================
# (1) Compartilhar o Floppy? (S/N) | Entrar com o path do Floppy | Exibir o path selecionado | (2) Não compartilhando Floppy #
#===========================================================================================
 
Xdialog --center  --title "cieQemu - Floppy" --yesno "Compartilhar dispositivo de Disquete?" 5 40
if [ $? = 0 ]; then
 
      floppy=$( Xdialog --center  --title "cieQemu - Floppy" --stdout --inputbox "Não se esqueça de inserir um Disquete\n
            no Drive! \n \n
            Informe o caminho do dispositivo do Disquete:" --center --textbox  "/dev/fd0" 10 45 )
 
#====================================================#
# Se CANCELAR ou ESC for precionado a execução será interrompida #
#====================================================#
 
   [ $? -eq 1 ] && Xdialog --center  --beep --title "Cancelado" --msgbox "Execução cancelada pelo usuário." 0 0 && exit
   disquete="-fda $floppy"
 
#============================================#
# Confirma ao usuário o caminho do dispositivo de disquete  #
#============================================#
 
Xdialog --center  --title "cieQemu - Floppy" --msgbox "Caminho do dispositivo do Disquete: $floppy" 5 45
 
else
 
#=====================================================#
# Informa ao usuário que não será compartilhado dispositivo de disquete  #
#=====================================================#
 
   disquete=" "
   Xdialog --center  --title "cieQemu" --msgbox "Ok, NÃO compartilhando o Disquete." 5 35
 
fi
 
#===========================================================================================================
# (1) Compartilhar som? (S/N) | "$soundhw"=opções de som do qemu | Exibe opcoes de som | Exibe opcao selecionada | (2) Não compartilha som #
#===========================================================================================================
 
Xdialog --center  --title "cieQemu - Cartão de Som" --yesno "Compartilhar dispositivo de Som?" 5 40
   if [ $? = 0 ]; then
 
#===========================================================================================#
# Insere o comando "qemu -soundhw ?" (Comando que exibe os cartões de som disponíveis no qemu) à variavel "$soundhw" #
#===========================================================================================#
 
   soundhw=$( qemu -soundhw ? )
 
#===================================================================#
# Exibe a lista de cartões de som disponíveis, e solicita ao usuário optar por um dos cartões #
#===================================================================#
 
   optsom=$( Xdialog --center  --title "cieQemu - Cartão de Som" \
   --stdout --inputbox "Selecione uma das opcoes de som:\n\n $soundhw" 15 50 )
 
#====================================================#
# Se CANCELAR ou ESC for precionado a execução será interrompida #
#====================================================#
 
   [ $? -eq 1 ] && Xdialog --center  --beep --title "Cancelado" --msgbox "Execução cancelada pelo usuário." 0 0 && exit
 
#======================================================================================================#
# Informa ao usuário o cartão de som selecionado e sugere reinicializar o script optando por outro cartão, caso haja problemas na emulação #
#======================================================================================================#
 
   som="-soundhw $optsom"
   Xdialog --center  --title "cieQemu - Cartão de Som" --msgbox "Cartão selecionado: $optsom \n \n
         obs: Se você tiver problemas na emulação do som, \n
         reinicie o script escolhendo outro cartão." 0 0
 
else
 
#===================================================#
# Informa ao usuário que o dispositivo de som não será compartilhado #
#===================================================#
 
   som=" "
   Xdialog --center  --title "cieQemu" --msgbox "Ok, NÃO compartilhando o Som." 5 35
 
fi
 
#======================================================================================#
# (1) Usar acelerador Kqemu? (S/N) | Informa que o Kqemu será utilizado | (2) Informa que o kqemu não será utilizado #
#======================================================================================#
 
Xdialog --center  --title "cieQemu - Acelerador Kqemu" --stdout --yesno "Habilitar acelerador Kqemu?\nRecomendado: NÃO" 6 45
 
#======================================================#
# Se ESC ou NAO for precionado o acelerador Kqemu não será habilitado #
#======================================================#
 
if [ $? = 1 ]; then
   kqemu="-no-kqemu"
   Xdialog --center  --title "cieQemu - Acelerador Kqemu" --msgbox "Acelerador Kqemu DESABILITADO." 6 35
 
else
 
#======================================#
# Informa ao usuário que o Kqemu estará habilitado  #
#======================================#
 
   kqemu=" "
   Xdialog --center  --title "cieQemu - Acelerador Kqemu" --msgbox "Acelerador Kqemu HABILITADO." 6 35
 
fi
 
#===========================================================================#
# Solicita ao usuário informar o valor de memória (somente números) à reservar para a máquina virtual #
#===========================================================================#
 
memoria=$( Xdialog --center  --title "cieQemu - Memória" --stdout --inputbox "Informe o valor de memória para o qemu.\n
         Recomendado: 128MB\n(Apenas números)" --center --textbox  "128" 10 45 )
 
#====================================================#
# Se CANCELAR ou ESC for precionado a execução será interrompida #
#====================================================#
 
   [ $? -eq 1 ] && Xdialog --center  --center  --beep --title "Cancelado" --msgbox "Execução cancelada pelo usuário." 0 0 && exit
 
#======================================================#
# Informa ao usuário o valor de memória reservado para a máquina virtual #
#======================================================#
 
Xdialog --center  --center  --title "cieQemu - Memória" --msgbox "Você reservou $memoria MB para o qemu." 5 40
 
#===============================================#
# Solicita ao usuário a indicar a imagem qemu que será emulada #
#===============================================#
 
imagem=$( Xdialog --center  --center  --title "cieQemu - Selecionar imagem" --stdout --fselect "/home/$USER/Desktop/" 0 0 )
 
#====================================================#
# Se CANCELAR ou ESC for precionado a execução será interrompida #
#====================================================#
 
   [ $? -eq 1 ] && Xdialog --center  --center  --beep --title "Cancelado" --msgbox "Execução cancelada pelo usuário." 0 0 && exit
 
#=========================================#
# Informa ao usuário o caminho e a imagem selecionada #
#=========================================#
    
Xdialog --center  --center  --title "cieQemu - Selecionar imagem" --msgbox "Imagem selecionada: $imagem" 0 0
 
#==========================#
# Confirmando opcões de emulação #
#==========================#
 
Xdialog --center  --center  --title "cieQemu - Confirmação" --yesno \
"Dispositivo CD/DVD: $cd \n
Dispositivo de disquete: $floppy \n
Cartão de som: $optsom \n
Memória reservada: $memoria MB \n
Kqemu: $kqemu \n
Imagem: $imagem" 0 0
 
#====================================================#
# Se CANCELAR ou ESC for precionado a execução será interrompida #
#====================================================#
 
   [ $? -eq 1 ] && Xdialog --center  --center  --beep --title "Cancelado" --msgbox "Execução cancelada pelo usuário." 0 0 && exit
 
#========================#
# Aplicando as opcoes no QEMU #
#========================#
 
qemu $cddvd $disquete $som -m $memoria $kqemu $imagem
 
#=======================================================#
# Fim do Script de emulação da imagem qemu (opção 3 do menu principal ) #
#=======================================================#
 
fi
 
#========================================#
# Pergunta ao usuário se deseja voltar ao menu principal #
#========================================#
 
Xdialog --center  --center  --title "cieQemu" --stdout --yesno "Deseja retornar ao menu principal?" 0 0
 
#=================================#
# Se opcao for diferente de SIM, sai do Script #
#=================================#
 
[ $? != 0 ] && Xdialog --center  --center  --title "cieQemu - Sair" --msgbox "Obrigado por utilizar meu Script!\n\n
         cieQemu - by Sedan75\n
         sedan75@linuxmail.org" 0 0 && exit
 
done
 
#================#
# Fim do script QEMU #
#================#
