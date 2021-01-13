#!/bin/bash

printf "Eternal Extractor Bash script\n
			by Leveste and PowerBall253\n
			based on the original file by Zwip-Zwap Zapony\n\n\n"

___GAME_DIRECTORY=""
___OUTPUT_DIRECTORY=""
___QUICKBMS_DIRECTORY=""
___QUICKBMS_SCRIPT=""

___QUICKBMS_INST=""

CD=""


printf "This batch file runs QuickBMS to extract the contents of all of DOOM Eternal's *.resources archives in one go.\n\n
If you only want to use others' DOOM Eternal mods, not make your own, this isn't useful for you; simply close this window now.\n\n
Otherwise, please input the full filepath to your DOOM Eternal installation:\n\n
			This script assumes that you have placed the 'doometernal.bms' file in your game directory. If you haven't, please move or copy it over."


read ___GAMEDIR

if ! [[ "$___GAMEDIR" == */ ]]; then ___GAMEDIR="${___GAMEDIR}/"; fi

if ! [ -f "${___GAMEDIR}DOOMEternalx64vk.exe" ]; then MissingDoomEternal; fi
if ! [ -f "${___GAMEDIR}base/gameresources.resources" ]; then MissingResources; fi

#Ask for QuickBMS path

printf "How did you install QuickBMS?\n
		1 - Compiled the source code with 'make'\n
		2 - Installed from the Arch User Repository(AUR)\n
		3 - Exit\n\n"

while true
do
	read ___QUICKBMS_SOURCE
	case "$___QUICKBMS_SOURCE" in
		"1")
			read -p "Please type the path to your QuickBMS directory: " ___QUICKBMS_DIRdir
			___QUICKBMS_INST=0
			break
			;;
		"2")
			___QUICKBMS_DIRdir="/usr/bin/"
			___QUICKBMS_INST=1
			break
			;;
		"3")
			echo "Exiting script."
			exit 1
			;;
		*)
			read -p "Not a valid option. Please try again." ___QUICKBMS_SOURCE
			;;
	esac
done
if ! [[ "$___QUICKBMS_DIRdir" == */ ]]; then ___QUICKBMS_DIRdir="${___QUICKBMS_DIRdir}/"; fi

if ! [ -f "${___QUICKBMS_DIRdir}___QUICKBMS_DIR" ]; then MissingQuickBMS; fi
if [ -f "${___GAMEDIR}doometernal.txt" ]; then ___QUICKBMS_DIR_script="doometernal.txt"; fi
if [ -f "${___GAMEDIR}doometernal.bms.txt" ]; then ___QUICKBMS_DIR_script="doometernal.bms.txt"; fi
if [ -f "${___GAMEDIR}doometernal.bms" ]; then ___QUICKBMS_DIR_script="doometernal.bms"; fi
if [ -z ${___QUICKBMS_DIR_script+x} ]; then MissingScript; fi

#Ask for output path

printf "Please input the full filepath to where you want to extract resources to.
Make sure that this filepath leads to a folder that's either empty or nonexistent:\n"

read ___OUTPUT_DIR

if ! [[ "$___OUTPUT_DIR" == */ ]]; then ___OUTPUT_DIR="${___OUTPUT_DIR}/";fi
if ! ls -1qA "$___OUTPUT_DIR" | grep -q .
then  OutputIsntEmpty
fi

#Prompt to start extraction


find .  -name '*.resources' -exec sh -c '___QUICKBMS_DIR' sh {} \;

