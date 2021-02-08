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

	exit
fi

while [ $# -ne 0 ]
do
	echo "Converting '$1'..."

	#use subshell for cd operation
	(
	cd tools
	wine nvcompress.exe -bcla -fast "$1" "${1}.dds" > /dev/null
	)
	wine ./tools/DivinityMashine.exe "${1}.dds" > /dev/null

	# remove file extensions
	filename="${i}"
	filename="${filename%%.*}" > /dev/null

	name="${1}.dds"
	tga_name="${name//dds/tga}"

	mv "$tga_name" "${filename}.tga" > /dev/null
	rm "${1}.dds" > /dev/null

	shift
done
