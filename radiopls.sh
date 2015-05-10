sudo apt-get install moc
mkdir -p ~/Music/internet_radio && cd ~/Music/internet_radio
wget http://listen.di.fm/public3/
cat index.html | sed -e 's/\"\:\"/\n/g' | sed -e 's/},{/\n{/g' | grep http | sed -e 's/"//g' > pls.txt
wget -i pls.txt
for file in *.pls; do mocp -a $file; done
mocp
