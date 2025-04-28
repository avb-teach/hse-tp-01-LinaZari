#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "нужно $0 /путь/к/input_dir /путь/к/output_dir"
    exit 1
fi

input_dir = "$1"
output_dir = "$2"

mkdir -p "$output_dir"
find "$input_dir" -type f -exec cp -- "{}" "$output_dir" \;
