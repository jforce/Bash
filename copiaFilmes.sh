echo "filmes2012" >> copia.log
find /media/DIS*/OsMeusFilmes/ -maxdepth 1 -type d -iname "*(2012)*" -exec cp -R {} . \;
echo "filmeshd2012" >> copia.log
find /media/DIS*/OsMeusFilmesHD/ -maxdepth 1 -type d -iname "*(2012)*" -exec cp -R {} . \;
echo "filmes2011" >> copia.log
find /media/DIS*/OsMeusFilmes/ -maxdepth 1 -type d -iname "*(2011)*" -exec cp -R {} . \;
echo "filmeshd2011" >> copia.log
find /media/DIS*/OsMeusFilmesHD/ -maxdepth 1 -type d -iname "*(2011)*" -exec cp -R {} . \;
echo "fim" >> copia.log
