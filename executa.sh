#!/usr/bin/env bash
# ./executa.sh
#

dirDestMsg="/usr1/sms"
dirDestWorten="/home/francisco/websites/worten/www.worten.pt"
dirProcesWorten="/home/francisco/websites/worten"

mirror=ok

function wortenProductDetail () {
	if [[ "$mirror" == "ok" ]]; then
		#ProductDetail541d.html
		#ProductDetail21f2.html
		#ProductDetail2144.html
		OLD_IFS="${IFS}"
		IFS=$' '
		#ARRAY=(`find $dirDestWorten/ProductDetail* -printf "%f "`)
		#IFS=$'\n'
		ARRAY=(`ls -t $dirDestWorten/ProductDetail* | xargs -n1 basename | tr '\n' ' '`)
		COUNT=${#ARRAY[@]}
		volta=1
		csv=""
		df=""
		file=""
		umalinha=""
		sku=""
		name=""
		brand=""
		descLonga=""
		url=""
		categorias=""
		price=""
		availa=""
		echo ${ARRAY[2]}
		echo "Numero de ficheiros processar:$COUNT"
		for i in ${ARRAY[*]}; do
			file="$i"
			if [[ "$df" == "" ]]; then
				df=$(date -r $dirDestWorten/$file +%F)
				csv="precos_$df.csv"
				echo "Processamento INI "$(date +%Y-%m-%d_%H:%M) >> "$dirProcesWorten"/precos.log
				if [[ -f "$dirProcesWorten/$csv" ]]; then
					echo "O ficheiro $dirProcesWorten/$csv ja existe o processamento não precisa ser executado" >> "$dirProcesWorten"/precos.log
					echo "O ficheiro $dirProcesWorten/$csv ja existe o processamento não precisa ser executado"
					ARRAY=""
					i=""
				else
					echo "Ficheiro;Cod.;Nome;Marca;Descrição;PVP;Stock;Link;Familias" > "$dirProcesWorten/$csv"
					umalinha=$(cat $dirDestWorten/$file | tr -d "\015" | tr -d '\n')
					sku=$(echo $umalinha | sed -e 's/sku/\\nsku/g' | sed -e 's/sku/\nsku/g' | grep sku | sed -n '1p' | sed -e 's/\".*//g' | sed -e 's/=/:/g' | awk -F':' '{ print $2 }')
					name=$(echo $umalinha | sed -e 's/name=\"title\"\ content=/\nname:/g' | grep "name:" | sed -n '1p' | sed -e 's/\"//g' | sed -e 's/>.*//g' | sed -e 's/  / /g;s/  / /g;s/  / /g;s/  / /g;s/  / /g;s/  / /g;s/  / /g;s/  / /g;s/  / /g'| sed -e 's/ $//g' | awk -F':' '{ print $2 }')
					#limparCodeHTML "$name"
					name=$(echo "$limparCodeHTML" | sed -e 's/\;//g')
					brand=$(echo $umalinha | sed -e 's/class=\"brand\">/\nbrand:/g' | grep "brand:" | sed -n '1p' | sed -e 's/\"//g' | sed -e 's/<.*//g' | sed -e 's/  / /g;s/  / /g;s/  / /g;s/  / /g;s/  / /g;s/  / /g;s/  / /g;s/  / /g;s/  / /g'| sed -e 's/ $//g' | awk -F':' '{ print $2 }')
					#limparCodeHTML "$brand"
					brand=$(echo "$limparCodeHTML" | sed -e 's/\;//g')
					descLonga=$(echo $umalinha | sed -e 's/class=\"long-desc\">/\ndescLonga:/g' | grep "descLonga:" | sed -n '1p' | sed -e 's/\"//g' | sed -e 's/<.*//g' |sed -e 's/  / /g;s/  / /g;s/  / /g;s/  / /g;s/  / /g;s/  / /g;s/  / /g;s/  / /g;s/  / /g'| sed -e 's/ $//g' | awk -F':' '{ print $2 }')
					#limparCodeHTML "$descLonga"
					descLonga=$(echo "$limparCodeHTML" | sed -e 's/\;//g')
					url=$(echo $umalinha | sed -e 's/Mirrored\ from\ /\nurl:/g' | grep "url:" | sed -n '1p' | sed -e 's/\"//g' | sed -e 's/ .*//g' | awk -F':' '{ print $2 }')
					categorias=$(echo $umalinha | sed -e 's/class=\"breadcrumb\">/\ncategorias:/g' | grep "categorias:" | sed -n '1p' | sed -e 's/\"//g' | sed -e 's/<\/ul>.*//g' | sed -e 's/<\/li>/§/g' | sed -e :a -e 's/<[^>]*>/ /g;/</N;//ba;s/  / /g;s/  / /g;s/  / /g;s/\t//g;s/ Home //g;s/ § /;/g;s/§ //g;s/..$//;s/\n//g' | sed -e 's/  / /g;s/  / /g;s/  / /g;s/  / /g;s/  / /g;s/  / /g;s/  / /g;s/  / /g;s/  / /g'| sed -e 's/ $//g' | awk -F':' '{ print $2 }')
					#limparCodeHTML $categorias
					categorias="$limparCodeHTML"
					price=$(echo $umalinha | sed -e 's/strong class=\"price\">/\nprice:/g' | grep "price:" | sed -n '1p' | sed -e 's/\"//g' | sed -e 's/<\/strong>.*//g' | sed -e 's/\&euro\; //g;s/ //g;s/\t//g' | awk -F':' '{ print $2 }')
					availa=$(echo $umalinha | sed -e 's/em class=\"availability\">/\navaila:/g' | grep "availa:" | sed -n '1p' | sed -e 's/\"//g' | sed -e 's/<\/em>.*//g' | sed -e 's/\t//g' | awk -F':' '{ print $2 }')
					if [[ "$volta" == "2" ]]; then
						echo "$file;$sku;$name;$brand;$descLonga;$price;$availa;$url;$categorias" >> "$dirProcesWorten/$csv"
					fi
					if [[ "$volta" == "1" ]]; then
						echo "$file;$sku;$name;$brand;$descLonga;$price;$availa;$url;$categorias"
						#waitKey
						echo "$file;$sku;$name;$brand;$descLonga;$price;$availa;$url;$categorias" >> "$dirProcesWorten/$csv"
						volta=2
					fi
					printf "$COUNT     $i     \r"
					COUNT=$((COUNT-1))
				IFS="${OLD_IFS}"
				echo -e "\nFim de processamento"
				echo "Foi criado na pasta $dirProcesWorten o ficheiro $csv" >> "$dirProcesWorten"/precos.log
				echo "Processamento END "$(date +%Y-%m-%d_%H:%M) >> "$dirProcesWorten"/precos.log
				chown francisco:francisco "$dirProcesWorten"/precos.log
				chown francisco:francisco "$dirProcesWorten/$csv"
				echo "END--------------------------------------">> "$dirProcesWorten"/precos.log
				fi				
			fi
		done
	else
		echo "O mirror não foi realizado pelo que não vai ser executado o processamento" >> "$dirProcesWorten"/precos.log
		echo "O mirror não foi realizado pelo que não vai ser executado o processamento"
		echo "END--------------------------------------">> "$dirProcesWorten"/precos.log
	fi
}
wortenProductDetail
