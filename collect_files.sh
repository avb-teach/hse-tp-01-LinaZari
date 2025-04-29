#!/bin/bash

if [ "$#" -ne 2 ]; then
  exit 1
fi

input_dir="$1"
output_dir="$2"

if [ ! -d "$input_dir" ]; then
  exit 1
fi

rm -f "$output_dir"/*
mkdir -p "$output_dir"

find "$input_dir" -type f -exec cp -n {} "$output_dir" \;





#идеи брала https://stackoverflow.com/questions/3129784/bash-script-e-not-detecting-filename-in-a-variable, https://devhops.ru/linux/bash/scripts/list_files/#small, https://translated.turbopages.org/proxy_u/en-ru.ru.20e000b7-6810156c-15a9caa3-74722d776562/https/unix.stackexchange.com/questions/468440/find-all-files-with-the-same-name