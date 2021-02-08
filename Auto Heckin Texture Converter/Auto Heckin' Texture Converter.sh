#!/bin/bash


# Check for required tools
file_arr=( "./tools/nvcompress.exe" "./tools/nvtt.dll" "./tools/DivinityMashine.exe" )

for i in "${file_arr[@]}"
do
	if [[ ! -f $i ]]
	then
		echo "'$i' not found! Did you extract everything in the tools folder?"
	fi
done


# Check for arguments
if [ "$#" -eq 0 ]
then
	printf "\n\nNo arguments found. Please pass the files you wish to convert as arguments, as shown below.\n
	./\"Auto Heckin' Texture Converter.sh\" [texture1] [texture2] [...]\n\n"
fi


