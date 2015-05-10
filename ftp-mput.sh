##!/bin/bash
#ftp_site=192.168.71.213
#username=cd
#passwd=qweasd
#remote=/Centro_de_Desenvolvimento/cobol
#pasta1=usr2
#pasta1a=fontes
#pasta2=usr3
#cd /home/cobol/$pasta1/$pasta1a
#pwd
#ncftp -in <<EOF
#open $ftp_site
#user $username $passwd
#mkdir $remote/$pasta1
#cd $remote/$pasta1
#mkdir $remote/$pasta1/$pasta1a
#cd $remote/$pasta1/$pasta1a
#put -R *
#close
#bye
#EOF

#cd /home/cobol/$pasta2
#pwd
#ftp -in <<EOF
#open $ftp_site
#user $username $passwd
#mkdir $remote/$pasta2
#cd $remote/$pasta2
#put -R *
#close
#bye
#EOF

#!/bin/bash
ftp_site=192.168.71.213
username=cd
passwd=qweasd
remote=/Centro_de_Desenvolvimento/cobol/
pasta1=usr2
pasta1a=fontes
pasta2=usr3
ftp -in <<EOF
open $ftp_site
user $username $passwd
mkdir $remote/$pasta1
mkdir $remote/$pasta1/$pasta1a
mkdir $remote/$pasta2
close
bye
EOF
cd /home/cobol/$pasta1/$pasta1a
ncftpput -R -u $username -p $passwd $ftp_site $remote/$pasta1/$pasta1a/ * >/dev/null 2>/dev/null
cd /home/cobol/$pasta2
ncftpput -R -u $username -p $passwd $ftp_site $remote/$pasta2/ * >/dev/null 2>/dev/null

#!/bin/bash
ftp_site=192.168.71.213
username=cd
passwd=qweasd
remote=/Centro_de_Desenvolvimento/cobol/
pasta1=home2
pasta1a=copias
ftp -in <<EOF
open $ftp_site
user $username $passwd
mkdir $remote/$pasta1
mkdir $remote/$pasta1/$pasta1a
close
bye
EOF
cd /$pasta1/$pasta1a
ncftpput -R -u $username -p $passwd $ftp_site $remote/$pasta1/$pasta1a/ * >/dev/null 2>/dev/null



#!/bin/bash
echo "INICIO da shell  : `date` "
echo "           "
ftp_site=192.168.71.213
username=cd
passwd=qweasd
remote=/Centro_de_Desenvolvimento/cobol
pasta1=home2
pasta1a=copias
pasta1b=logins
ARRAY=(`find -L /home2/copias/logins -type d`)




ftp -in <<EOF
open $ftp_site
user $username $passwd
mkdir $remote/$pasta1
mkdir $remote/$pasta1/$pasta1a
mkdir $remote/$pasta1/$pasta1a/$pasta1b
close
bye
EOF
cd /$pasta1/$pasta1a/$pasta1b
ncftpput -R -u $username -p $passwd $ftp_site $remote/$pasta1/$pasta1a/$pasta1b SITIO >/dev/null 2>/dev/null

SITIO
SITIO.idx
GSITIPO
.bash_profile
IMNTERM
SITIO
SITIO.idx
GSITIPO
.bash_profile
IMNTERM

echo "FIM    da shell  : `date` "
echo "           "

