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
rm -f "$output_dir"/*
find "$input_dir" -mindepth 1 -maxdepth 2 -type f -exec cp -n {} "$output_dir" \!


POSTFIX="--small"

#обрабаотываем дубл файлы

# идеи брала из https://devhops.ru/linux/bash/scripts/list_files/#small, https://collectingwisdom.com/bash-add-suffix-to-all-files/, https://translated.turbopages.org/proxy_u/en-ru.ru.20e000b7-6810156c-15a9caa3-74722d776562/https/unix.stackexchange.com/questions/468440/find-all-files-with-the-same-name


find "$output_dir" -type f -print0 | awk -v postfix="$POSTFIX" '
BEGIN { RS="\0" }
{
    filename = $NF;
    if (match(filename, /^(.*)\.[^.]+$/)) {
        base = substr(filename, RSTART, RLENGTH-1);
        ext = substr(filename, RSTART + RLENGTH - 1, RLENGTH);
    } else {
        base = filename;
        ext = "";
    }
    name_count[base]++;
    files[base] = files[base] "\0" filename;
}
END {
    for (b in name_count) {
        if (name_count[b] > 1) {
            n = split(files[b], arr, "\0");
            j=1;
            for (i=1; i<=n; i++) {
                f=arr[i];
                newname=b""postfix;
                if (match(f, /^(.*)(\.[^.]+)$/)) {
                    ext = substr(f, RSTART, RLENGTH);
                } else {
                    ext = "";
                }
                newname = b""postfix""ext;

                while (system("[ -e \"" newname "\" ]") == 0) {
                    newname=b""postfix"(" j ")""" ext;
                    j++;
                }
                system("mv -- \"" f "\" \"" newname "\"");
            }
        }
    }
}
'

for file in "$output_dir"/*.txt; do  #переименовываем и добавляем суффикс
  if [ -e "$file" ]; then
    mv "$file" "${file%.txt}_new.txt"
  fi
done