#!/bin/bash
for i in *.png
# do convert -threshold 45000 "$i" "`basename "$i" .png`.png"
# do echo "$i" "`basename "$i" .png`.png"
# do echo "$i" "./BW/${i%.png}.png"
do convert -threshold 45000 "$i" "./BW/${i%.png}.png"
#read -p "Press any key to continue ..."
done 
