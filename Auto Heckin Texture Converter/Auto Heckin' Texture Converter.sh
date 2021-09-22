#!/usr/bin/env bash

# This file is part of EternalBasher (https://github.com/leveste/EternalBasher).
# Copyright (C) 2021 leveste and PowerBall253
#
# EternalBasher is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# EternalBasher is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of  
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the  
# GNU General Public License for more details.  
#
# You should have received a copy of the GNU General Public License  
# along with EternalBasher. If not, see <https://www.gnu.org/licenses/>.

# Check for required tools
if [[ ! -f "./tools/DivinityMachine" ]]
then
	echo "'./tools/DivinityMachine' not found! Did you extract everything in the tools folder?"
	exit 1
fi

if [[ ! -f "./tools/EternalTextureCompressor" ]]
then
	echo "'./tools/EternalTextureCompressor' not found! Did you extract everything in the tools folder?"
	exit 1
fi

if [[ ! -f "./tools/nvcompress" ]]
then
	echo "'./tools/nvcompress' not found! Did you extract everything in the tools folder?"
	exit 1
fi

# Give executable permissions to tools
chmod +x "tools/nvcompress"
chmod +x "tools/DivinityMachine"
chmod +x "tools/EternalTextureCompressor"


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

	filepath="$(readlink -f "$1")"

	if [[ ! -f "$filepath" ]]
	then
		echo "'$1' not found!"
		shift
		continue
	fi

	filename="$(basename "${filepath}")"
	dirpath="$(dirname "${filepath}")"

	stem="${filename%%.*}"
	stem="${stem%%\$*}"

	if [[ "$stem" == *_n ]] || [[ "$stem" == *_Normal ]]; then
		./tools/nvcompress -bc5 -fast "$filepath" "${filepath}.tmp" > /dev/null
	else
		./tools/nvcompress -bc1a -fast -srgb "$filepath" "${filepath}.tmp" > /dev/null
	fi

	./tools/DivinityMachine "${filepath}.tmp" > /dev/null
	./tools/EternalTextureCompressor "${filepath}.tga" > /dev/null

	mv "${filepath}.tga" "${dirpath}/${filename%.*}.tga"
	rm "${filepath}.tmp"

	shift
done