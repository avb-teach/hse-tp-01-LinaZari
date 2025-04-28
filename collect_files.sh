#!/bin/bash

if [ "$#" -ne 2 ]; then
  exit 1
fi

input_dir="$1"
output_dir="$2"

if [ ! -d "$input_dir" ]; then #проверим существует ли входная директория 
  exit 1
fi

mkdir -p "$output_dir" #создание входной директории (если нет) смотрела тут https://github.com/google/deepvariant/blob/r1.8/docs/deepvariant-training-case-study.md?ysclid=ma1pzyk3dq606955235 как правильно создать директорию

find "$input_dir" -mindepth 1 -maxdepth 2 -type f -exec cp -n {} "$output_dir" \!