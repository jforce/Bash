#!/usr/bin/env bash
declare IFS=$'\n'
caminhoCompleto="/media/DISC*"
#caminhoCompleto="/media/DISC01"
#caminhoCompleto="."



for file in $( find -L $caminhoCompleto -mindepth 1 -maxdepth 3 -type f \
			\(\
			-iname "*.aqt" -o \
			-iname "*.htm" -o \
			-iname "*.html" -o \
			-iname "*.nfo" -o \
			-iname "*.dks" -o \
			-iname "*.jss" -o \
			-iname "*.sub" -o \
			-iname "*.ttxt" -o \
			-iname "*.mpl" -o \
			-iname "*.sub" -o \
			-iname "*.pjs" -o \
			-iname "*.psb" -o \
			-iname "*.rt" -o \
			-iname "*.smi" -o \
			-iname "*.ssf" -o \
			-iname "*.srt" -o \
			-iname "*.ssa" -o \
			-iname "*.sub" -o \
			-iname "*.usf" -o \
			-iname "*.txt" \) )
do

if [[ $(file $file) =~ text ]]; then
	if [[ $(file $file) =~ CRLF ]]; then
		caractersetold=` file -i $file | awk -F'=' '{ print $2  }' `
		echo -e "Old;$file;$caractersetold"
		cat "$file" | iconv --verbose -f $caractersetold -t utf-8 | tr -d '\n' > "$file".newfilecs
		cp --force "$file" "$file".oldfilecs
		cp --force "$file".newfilecs $file
		caractersetnew=` file -i "$file" | awk -F'=' '{ print $2  }' `
		echo -e "New;$file;$caractersetnew"
		read -p "Pensa e decide ..."
	fi
fi
done


