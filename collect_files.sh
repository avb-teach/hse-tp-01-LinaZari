#!/bin/bash

if [ "$#" -ne 2 ]; then
  exit 1
fi

input_dir="$1"
output_dir="$2"

if [ ! -d "$input_dir" ]; then
  exit 1
fi

mkdir -p "$output_dir"
rm -f "$output_dir"/*

# Копируем только файлы с глубиной ровно 2 
find "$input_dir" -mindepth 2 -maxdepth 2 -type f -exec cp -n {} "$output_dir" \;


declare -A name_counts

for file in "$output_dir"/*; do
  if [ -e "$file" ]; then
    filename=$(basename "$file")
    if [[ $filename == *.txt ]]; then
      newname="${filename%.txt}_new.txt"
      mv "$file" "$output_dir/$newname"
    else
      base="${filename%.*}"
      ext="${filename##*.}"
      
      if [ -z "$base" ]; then
        base="$filename"
        ext=""
      fi
      
      if [ -n "${name_counts[$base]}" ]; then
        newname="${base}_small${name_counts[$base]}"
        if [ -n "$ext" ]; then
          newname="$newname.$ext"
        fi
        mv "$file" "$output_dir/$newname"
        ((name_counts[$base]++))
      else
        name_counts[$base]=1
      fi
    fi
  fi
done




#идеи брала https://stackoverflow.com/questions/3129784/bash-script-e-not-detecting-filename-in-a-variable, https://devhops.ru/linux/bash/scripts/list_files/#small, https://translated.turbopages.org/proxy_u/en-ru.ru.20e000b7-6810156c-15a9caa3-74722d776562/https/unix.stackexchange.com/questions/468440/find-all-files-with-the-same-name