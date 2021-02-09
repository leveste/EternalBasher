#!/usr/bin/env bash

while [[ $# -gt 0 ]]
do
	first_line=$(head -n 1 "$1")
	if [[ $first_line == "Version 7" ]]
	then 
		wine "idFileDeCompressor.exe" "-c" "$1" "$1"
	else
		wine "idFileDeCompressor.exe" "-d" "$1" "$1"
	fi
	shift
done
