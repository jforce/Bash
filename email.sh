#!/usr/bin/env bash
# ./executa.sh
#


function email () {
# Instalar dependencias
	sudo apt-get --yes install msmtp sharutils mutt
	mkdir -p $HOME/.mutt/cache/
	mkdir -p $HOME/.mutt/certificates
	sudo apt-get --yes install ca-certificates
	sudo update-ca-certificates

# Criar ficheiro .msmtprc na home
	echo -e "# config options: http://msmtp.sourceforge.net/doc/msmtp.html" > $HOME/.msmtprc
	echo -e "defaults" >> $HOME/.msmtprc
	echo -e "logfile /tmp/msmtp.log" >> $HOME/.msmtprc
	echo -e "" >> $HOME/.msmtprc
	echo -e "# radiopopular account" >> $HOME/.msmtprc
	echo -e "#account radiopopular" >> $HOME/.msmtprc
	echo -e "#host mail.radiopopular.pt" >> $HOME/.msmtprc
	echo -e "#port 25" >> $HOME/.msmtprc
	echo -e "#user franciscorocha@radiopopular.pt" >> $HOME/.msmtprc
	echo -e "#password d23m02" >> $HOME/.msmtprc
	echo -e "#from franciscorocha@radiopopular.pt" >> $HOME/.msmtprc
	echo -e "" >> $HOME/.msmtprc
	echo -e "# radiopopularssl account" >> $HOME/.msmtprc
	echo -e "account radiopopularssl" >> $HOME/.msmtprc
	echo -e "auth on" >> $HOME/.msmtprc
	echo -e "host mail.radiopopular.pt" >> $HOME/.msmtprc
	echo -e "port 587" >> $HOME/.msmtprc
	echo -e "user franciscorocha@radiopopular.pt" >> $HOME/.msmtprc
	echo -e "password d23m02" >> $HOME/.msmtprc
	echo -e "from franciscorocha@radiopopular.pt" >> $HOME/.msmtprc
	echo -e "tls on" >> $HOME/.msmtprc
	echo -e "tls_starttls on" >> $HOME/.msmtprc
	echo -e "tls_certcheck off" >> $HOME/.msmtprc
	echo -e "" >> $HOME/.msmtprc
	echo -e "# gmail account" >> $HOME/.msmtprc
	echo -e "account gmail" >> $HOME/.msmtprc
	echo -e "auth on" >> $HOME/.msmtprc
	echo -e "host smtp.gmail.com" >> $HOME/.msmtprc
	echo -e "port 587" >> $HOME/.msmtprc
	echo -e "user j.francisco.o.rocha@gmail.com" >> $HOME/.msmtprc
	echo -e "password dia19mes10jet" >> $HOME/.msmtprc
	echo -e "from j.francisco.o.rocha@gmail.com" >> $HOME/.msmtprc
	echo -e "tls on" >> $HOME/.msmtprc
	echo -e "tls_starttls on" >> $HOME/.msmtprc
	echo -e "tls_trust_file /etc/ssl/certs/ca-certificates.crt" >> $HOME/.msmtprc
	echo -e "" >> $HOME/.msmtprc
	echo -e "# set default account to use \(from above\)" >> $HOME/.msmtprc
	echo -e "account default : radiopopularssl" >> $HOME/.msmtprc
	sudo chmod 600 $HOME/.msmtprc
	sudo chown $USER:$(id -g -n $USER) $HOME/.msmtprc

# Criar o ficheiro .muttrc
	echo -e "# Configurar Mutt como cliente de email para Gmail" > $HOME/.muttrc
	echo -e "#set from = \"j.francisco.o.rocha@gmail.com\"" >> $HOME/.muttrc
	echo -e "#set realname = \"Francisco Rocha\"" >> $HOME/.muttrc
	echo -e "#set imap_user = \"j.francisco.o.rocha@gmail.com\"" >> $HOME/.muttrc
	echo -e "#set imap_pass = \"dia19mes10jet\"" >> $HOME/.muttrc
	echo -e "#set folder = \"imaps://imap.gmail.com:993\"" >> $HOME/.muttrc
	echo -e "#set spoolfile = \"+INBOX\"" >> $HOME/.muttrc
	echo -e "#set postponed =\"+[Gmail]/Drafts\"" >> $HOME/.muttrc
	echo -e "#set header_cache =~/.mutt/cache/headers" >> $HOME/.muttrc
	echo -e "#set message_cachedir =~/.mutt/cache/bodies" >> $HOME/.muttrc
	echo -e "#set certificate_file =~/.mutt/certificates" >> $HOME/.muttrc
	echo -e "#set smtp_url = \"smtp://j.francisco.o.rocha@smtp.gmail.com:587/\"" >> $HOME/.muttrc
	echo -e "#set smtp_pass = \"dia19mes10jet\"" >> $HOME/.muttrc
	echo -e "#set move = no" >> $HOME/.muttrc
	echo -e "#set imap_keepalive = 900" >> $HOME/.muttrc
	echo -e "#set editor = \"nano\"" >> $HOME/.muttrc
	echo -e "#set mail_check = 120" >> $HOME/.muttrc
	echo -e "#set timeout = 300" >> $HOME/.muttrc
	echo -e "#set auto_tag = yes" >> $HOME/.muttrc
	echo -e "" >> $HOME/.muttrc
	echo -e "# Configurar Mutt como cliente de email para Radio Popular" >> $HOME/.muttrc
	echo -e "#set from = \"franciscorocha@radiopopular.pt\"" >> $HOME/.muttrc
	echo -e "#set realname = \"Francisco Rocha\"" >> $HOME/.muttrc
	echo -e "#set imap_user = \"franciscorocha@radiopopular.pt\"" >> $HOME/.muttrc
	echo -e "#set imap_pass = \"d23m02\"" >> $HOME/.muttrc
	echo -e "#set folder = \"imaps://mail.radiopopular.pt:993\"" >> $HOME/.muttrc
	echo -e "#set spoolfile = \"+INBOX\"" >> $HOME/.muttrc
	echo -e "##set postponed =\"+[Gmail]/Drafts\"" >> $HOME/.muttrc
	echo -e "#set header_cache =~/.mutt/rp/cache/headers" >> $HOME/.muttrc
	echo -e "#set message_cachedir =~/.mutt/rp/cache/bodies" >> $HOME/.muttrc
	echo -e "#set certificate_file =~/.mutt/rp/certificates" >> $HOME/.muttrc
	echo -e "#set smtp_url = \"smtp://franciscorocha@mail.radiopopular.pt:25/\"" >> $HOME/.muttrc
	echo -e "#set smtp_pass = \"d23m02\"" >> $HOME/.muttrc
	echo -e "#set move = no" >> $HOME/.muttrc
	echo -e "#set imap_keepalive = 900" >> $HOME/.muttrc
	echo -e "#set editor = \"nano\"" >> $HOME/.muttrc
	echo -e "#set mail_check = 120" >> $HOME/.muttrc
	echo -e "#set timeout = 300" >> $HOME/.muttrc
	echo -e "#set auto_tag = yes" >> $HOME/.muttrc
	echo -e "" >> $HOME/.muttrc
	echo -e "# Se não identificada a conta a usar ira ser usada" >> $HOME/.muttrc
	echo -e "# a conta default configurada na aplicação msmtp \(.msmtprc\)" >> $HOME/.muttrc
	echo -e "# mutt -s \"assunto da mensagem\" -F $HOME/.mutt/mutt_g endereço@email.qq < /tmp/test_email" >> $HOME/.muttrc
	echo -e "set sendmail=\"/usr/bin/msmtp\"" >> $HOME/.muttrc
	sudo chmod 600 $HOME/.muttrc
	sudo chown $USER:$(id -g -n $USER) $HOME/.muttrc

# Criar ficheiro mutt_g (~/.mutt/)
	echo -e "set sendmail=\"/usr/bin/msmtp\"" > $HOME/.mutt/mutt_g
	echo -e "set use_from=yes" >> $HOME/.mutt/mutt_g
	echo -e "set from=\"Francisco Rocha <j.francisco.o.rocha@gmail.com>\"" >> $HOME/.mutt/mutt_g
	echo -e "set envelope_from=yes" >> $HOME/.mutt/mutt_g
	sudo chown $USER:$(id -g -n $USER) $HOME/.mutt/mutt_g

# Criar ficheiro mutt_r (~/.mutt/)
	echo -e "set sendmail=\"/usr/bin/msmtp\"" > $HOME/.mutt/mutt_r
	echo -e "set use_from=yes" >> $HOME/.mutt/mutt_r
	echo -e "set from=\"Francisco Rocha <franciscorocha@radiopopular.pt>\"" >> $HOME/.mutt/mutt_r
	echo -e "set envelope_from=yes" >> $HOME/.mutt/mutt_r
	sudo chown $USER:$(id -g -n $USER) $HOME/.mutt/mutt_r

	echo -e "Para enviar emails:"
	echo -e "$ echo -e \"testing email from the command line\" > /tmp/test_email"
	echo -e "#Formato generico"
	echo -e "mutt -a ficheiro_1 ficheiro_n -F ficheiro_mutt_rc -s \"assunto da mensagem\" -- endereço_email_1 endereço_email_n < /tmp/test_email"
	echo -e "# Conta Gmail"
	echo -e "$ mutt -s \"teste G\" -F $HOME/.mutt/mutt_g -- franciscorocha@radiopopular.pt < /tmp/test_email"
	echo -e "# Conta RP"
	echo -e "$ mutt -s \"teste R\" -F $HOME/.mutt/mutt_r -- franciscorocha@radiopopular.pt < /tmp/test_email"
	echo -e "# Conta default do msmtp"
	echo -e "$ mutt -s \"teste D\" -- franciscorocha@radiopopular.pt < /tmp/test_email"
	echo -e "# Mensagem com anexo"
	echo -e "$ mutt -a /caminho/ficheiro1.xex /caminho/ficheiro2.xex -s \"teste A\" -- franciscorocha@radiopopular.pt < /tmp/test_email"

	}


email
