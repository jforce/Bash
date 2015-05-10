#!/bin/bash
mkdir GS
# mkdir BW
for i in *.png
do convert $i -colorspace Gray GS/$i
# do convert -threshold 45000 BW/$i
# read -p "Press any key to continue ..."
echo "Ficheiro $i processado"
done
