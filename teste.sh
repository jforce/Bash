#!/bin/bash

PROCURA=$(find /media/DISC01 -maxdepth 2 -type d)

if [[ ! -f "$PROCURA" ]]; then
    echo "O ficheiro $PROCURA não existe"
else
	echo "O ficheiro $PROCURA existe"
fi

process_dir() {
    local -a subdirs=()
    echo "Scanning directory: $1"

    # Scan the directory, processing files and collecting subdirs
    for file in "$1"/*; do
        if [[ -f "$file" ]]; then
            echo "Processing file: $file"
            # actually deal with the file here...
        elif [[ -d "$file" ]]; then
            subdirs+=("$file")
            # If you don't care about processing all files before subfolders, just do:
            # process_dir "$file"
        fi
    done

    # Now go through the subdirs
    for d in "${subdirs[@]}"; do
        process_dir "$d"
    done
}

lixo () {
clear
if [[ -z "$1" ]]; then
    read -p "Please enter a directory for me to scan " dir
else
    dir="$1"
fi
process_dir "$dir"
}
