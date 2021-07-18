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
if [[ ! -f "./tools/DivinityMashine" ]]
then
	echo "'./tools/DivinityMashine' not found! Did you extract everything in the tools folder?"
	exit 1
fi

if [[ ! -f "./tools/EternalTextureCompressor" ]]
then
	echo "'./tools/EternalTextureCompressor' not found! Did you extract everything in the tools folder?"
	exit 1
fi

if ! command -v nvcompress &> /dev/null
then
	echo "nvcompress not found! Did you install the Nvidia Texture Tools?"
	exit 1
fi


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

	path=$(readlink -f "$1")
	#use subshell for cd operation
	(
	cd tools
	nvcompress -bcla -fast "$path" "${path}.dds" > /dev/null
	)
	./tools/DivinityMashine "${1}.dds" > /dev/null
	./tools/EternalTextureCompressor "${1}.dds" > /dev/null

	# remove file extensions
	filename="${i}"
	filename="${filename%%.*}" > /dev/null

	name="${1}.dds"
	tga_name="${name//dds/tga}"

	mv "$tga_name" "${filename}.tga" > /dev/null
	rm "${1}.dds" > /dev/null

	shift
done