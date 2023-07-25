#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 name_list surname_list"
    exit 1
fi

names_file="$1"
surnames_file="$2"

rm -rf ./Wordlists/
mkdir ./Wordlists/

if [ ! -f "$names_file" ]; then
    echo "Error: The name list file '$names_file' does not exist."
    exit 1
fi

if [ ! -f "$surnames_file" ]; then
    echo "Error: The surname list file '$surnames_file' does not exist."
    exit 1
fi

declare -a files=(name.surname n.surname name.s namesurname nsurname names surnamen sname surnamename s.name surname.n surname.name)

# Create temporary files for each wordlist.
for f in "${files[@]}"; do
    touch "Wordlists/${f}_tmp"
done

while IFS= read -r name; do
    while IFS= read -r surname; do
        echo "${name}.${surname}" >> "Wordlists/name.surname_tmp"
        echo "${name:0:1}.${surname}" >> "Wordlists/n.surname_tmp"
        echo "${name}.${surname:0:1}" >> "Wordlists/name.s_tmp"
        echo "${name}${surname}" >> "Wordlists/namesurname_tmp"
        echo "${name:0:1}${surname}" >> "Wordlists/nsurname_tmp"
        echo "${name}${surname:0:1}" >> "Wordlists/names_tmp"
        echo "${surname}${name:0:1}" >> "Wordlists/surnamen_tmp"
        echo "${surname:0:1}${name}" >> "Wordlists/sname_tmp"
        echo "${surname}${name}" >> "Wordlists/surnamename_tmp"
        echo "${surname:0:1}.${name}" >> "Wordlists/s.name_tmp"
        echo "${surname}.${name:0:1}" >> "Wordlists/surname.n_tmp"
        echo "${surname}.${name}" >> "Wordlists/surname.name_tmp"
    done < "$surnames_file"
done < "$names_file"

# Merge temporary files into final files and delete temporary files.
for f in "${files[@]}"; do
    cat "Wordlists/${f}_tmp" > "Wordlists/${f}"
    rm "Wordlists/${f}_tmp"
done
