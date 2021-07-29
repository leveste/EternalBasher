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


# Functions

MissingDoomEternal(){
	printf "'DOOMEternalx64vk.exe' not found!
	
	Is your DOOM Eternal installation incomplete, or did you use a wrong path?
	DOOMEternalx64vk.exe should be located at -/DOOMEternal/DOOMEternalx64vk.exe
	The path that you gave to -/DOOMEternal/ was %s" "$___GAMEDIR"
	exit
}

MissingResources(){
	printf "gameresources.resources not found!
	Is your DOOM Eternal installation incomplete, or did you use a wrong path?
	gameresources.resources should be located at -/DOOMEternal/base/gameresources.resources
	The path that you gave to -/DOOMEternal/ was %s" "$___GAMEDIR"
	exit
}

MissingQuickBMS(){
	printf "QuickBMS not found!
	Is your QuickBMS installation incomplete, or did you use a wrong path?
	The path that you gave was %s" "$___EXTRACTOR_DIR"
	exit
}

MissingEternalResourceExtractor(){
	printf "EternalResourceExtractor not found!
	Did you make sure to download the executable or did you use a wrong path?
	The path that you gave was %s" "$___EXTRACTOR_DIR"
	exit
}

MissingScript(){
	printf "doometernal.bms not found
	Did you forget to make and save it manually?
	You can find doometernal.bms at https://zenhax.com/viewtopic.php?p=54753&sid=3f95e61ed0a5ad86088eb53e66bbfbd2#p54753
 	You must copy and paste it into a raw text editor, then save it as 'doometernal.bms' in your DOOM Eternal folder."
	exit
}

OutputIsntEmpty(){
	printf "To avoid inconveniencing you, this batch file won't extract to an output directory that already has files and/or folders in it.
	The output directory path that you gave was %s" "$___OUTPUT_DIR"
	exit
}

# Ask for QuickBMS path

QuickBMSPath(){
	printf "How did you install QuickBMS?\n
			1 - Compiled the source code with 'make'/Downloaded the Linux standalone binaries.\n
			2 - Installed from the Arch User Repository(AUR)\n
			3 - WINE version\n
			4 - Exit\n\n"
	
	while true
	do
		read -r ___QUICKBMS_SOURCE
		case "$___QUICKBMS_SOURCE" in
			"1")
				read -rp "Please type the path to your QuickBMS directory: " inp
				___EXTRACTOR_DIR="$inp"
				break
				;;
			"2")
				___EXTRACTOR_DIR="/usr/bin/"
				break
				;;
			"3")
				read -rp "Please type the path to your QuickBMS directory: " inp
				___EXTRACTOR_DIR="$inp"
				break
				;;
			"4")
				echo "Exiting script."
				exit 1
				;;
			*)
				read -rp "Not a valid option. Please try again." ___QUICKBMS_SOURCE
				;;
		esac
	done

	if ! [[ "$___EXTRACTOR_DIR" == */ ]]; then ___EXTRACTOR_DIR="${___EXTRACTOR_DIR}/"; fi
}

# Start script

printf "Eternal Extractor Bash script\n
by Leveste and PowerBall253\n
based on the original file by Zwip-Zwap Zapony\n\n\n"

export ___GAMEDIR="$HOME/.local/share/Steam/steamapps/common/DOOMEternal/"
export ___OUTPUT_DIR=""
export ___EXTRACTOR_DIR=""
export ___QUICKBMS_SCRIPT=""




printf "This shell script will help run QuickBMS or EternalResourceExtractor to extract the contents of all of DOOM Eternal's *.resources archives in one go.\n\n
If you only want to use others' DOOM Eternal mods, not make your own, this isn't useful for you; simply close this window now.\n\n
			The default location for your game directory is set to %s.\n
			Press 'Y' if you wish to change it. Press any other key to continue with this setting." "$___GAMEDIR"

read -r y

if [[ $y == [yY] ]]
then
	read -rp "Please type the path for your game directory: " ___GAMEDIR
fi

if ! [[ "$___GAMEDIR" == */ ]]; then ___GAMEDIR="${___GAMEDIR}/"; fi

if ! [ -f "${___GAMEDIR}DOOMEternalx64vk.exe" ]; then MissingDoomEternal; fi
if ! [ -f "${___GAMEDIR}base/gameresources.resources" ]; then MissingResources; fi

#Ask for output path

printf "Please input the full filepath to where you want to extract resources to.
Make sure that this filepath leads to a folder that's either empty or nonexistent:\n"

read -r inp
___OUTPUT_DIR="$inp"

if ! [[ "$___OUTPUT_DIR" == */ ]]; then ___OUTPUT_DIR="${___OUTPUT_DIR}/";fi
if [ -n "$(ls -A "$___OUTPUT_DIR" &> /dev/null)" ] 
then  OutputIsntEmpty
fi

if ! [ -d "$___OUTPUT_DIR" ]; then mkdir "$___OUTPUT_DIR"; fi


# Ask for which extractor tool to use

printf "Which extractor are you using? \n
		1 - QuickBMS\n
		2 - EternalResourceExtractor\n\n"


while true
do
	read -r inp
	case "$inp" in
		"1")
			QuickBMSPath
			
			if ! ([ -f "${___EXTRACTOR_DIR}quickbms" ] || [ -f "${___EXTRACTOR_DIR}quickbms_4gb_files.exe" ]); then MissingQuickBMS; fi
			if [ -f "${___GAMEDIR}doometernal.txt" ]; then ___QUICKBMS_SCRIPT="${___GAMEDIR}doometernal.txt"; fi
			if [ -f "${___GAMEDIR}doometernal.bms.txt" ]; then ___QUICKBMS_SCRIPT="${___GAMEDIR}doometernal.bms.txt"; fi
			if [ -f "${___GAMEDIR}doometernal.bms" ]; then ___QUICKBMS_SCRIPT="${___GAMEDIR}doometernal.bms"; fi
			if [ -z ${___QUICKBMS_SCRIPT+x} ]; then MissingScript; fi
			#Prompt to start extraction
			
			
			case "$___QUICKBMS_SOURCE" in
				[12])
					print "Linux version of quickbms does not work with the current 'doometernal.bms' script due to the 'oodle' library's open source alternative not being implemented yet. Please use the WINE version instead. The script will be updated when it's been implemented."
					#cp "${___EXTRACTOR_DIR}quickbms" .
					#find "$___GAMEDIR" -name "*.resources" -exec sh -c './quickbms -o -Y "$___QUICKBMS_SCRIPT" "$1" "$___OUTPUT_DIR"' sh {} \;
					#rm quickbms
					;;
				"3")
					if [ -f "quickbms_4gb_files.exe" ]
					then
						find "$___GAMEDIR" -name "*.resources" -exec sh -c 'wine quickbms_4gb_files.exe -o -Y "$___QUICKBMS_SCRIPT" "$1" "$___OUTPUT_DIR"' sh {} \;
					else
						cp "${___EXTRACTOR_DIR}quickbms_4gb_files.exe" .
						find "$___GAMEDIR" -name "*.resources" -exec sh -c 'wine quickbms_4gb_files.exe -o -Y "$___QUICKBMS_SCRIPT" "$1" "$___OUTPUT_DIR"' sh {} \;
						rm quickbms_4gb_files.exe
					fi
			esac

			break
			;;
		"2")
			if [ -f "EternalResourceExtractor" ]
			then
				chmod +x "EternalResourceExtractor"
				find "$___GAMEDIR" -name "*.resources" -exec sh -c './EternalResourceExtractor "$1" "$___OUTPUT_DIR"' sh {} \;
			else
				read -rp "Please type the path to your EternalResourceExtractor directory: " inp
				___EXTRACTOR_DIR="$inp"
				if ! [[ "$___EXTRACTOR_DIR" == */ ]]; then ___EXTRACTOR_DIR="${___EXTRACTOR_DIR}/"; fi

				if ! [[ -f "${___EXTRACTOR_DIR}EternalResourceExtractor" ]]; then MissingEternalResourceExtractor; fi
				chmod +x "${___EXTRACTOR_DIR}EternalResourceExtractor"

				cp "${___EXTRACTOR_DIR}EternalResourceExtractor" .
				chmod +x "EternalResourceExtractor"
				find "$___GAMEDIR" -name "*.resources" -exec sh -c '___RESOURCE_DIR="$(basename $1)"; ___RESOURCE_DIR=${___RESOURCE_DIR%.*}; ./EternalResourceExtractor "$1" "${___OUTPUT_DIR}${___RESOURCE_DIR}"' sh {} \;
				rm EternalResourceExtractor
			fi
			break
			;;
		"*")
			read -rp "Not a valid option. Please try again." inp
			;;
	esac
done
