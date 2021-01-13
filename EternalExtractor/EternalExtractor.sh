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


read gamedir

if ! [[ "$gamedir" == */ ]]; then gamedir="${gamedir}/"; fi

if ! [ -f "${gamedir}DOOMEternalx64vk.exe" ]; then MissingDoomEternal; fi
if ! [ -f "${gamedir}base/gameresources.resources" ]; then MissingResources; fi

#Ask for QuickBMS path

printf "How did you install QuickBMS?\n
		1 - Compiled the source code with 'make'\n
		2 - Installed from the Arch User Repository(AUR)\n
		3 - Exit\n\n"

while true
do
	read quickbms_source
	case "$quickbms_source" in
		"1")
			read -p "Please type the path to your QuickBMS directory: " quickbmsdir
			___QUICKBMS_INST=0
			break
			;;
		"2")
			quickbmsdir="/usr/bin/"
			___QUICKBMS_INST=1
			break
			;;
		"3")
			echo "Exiting script."
			exit 1
			;;
		*)
			read -p "Not a valid option. Please try again." quickbms_source
			;;
	esac
done
if ! [[ "$quickbmsdir" == */ ]]; then quickbmsdir="${quickbmsdir}/"; fi

if ! [ -f "${quickbmsdir}quickbms" ]; then MissingQuickBMS; fi
if [ -f "${quickbmsdir}doometernal.txt" ]; then quickbms_script="doometernal.txt"; fi
if [ -f "${quickbmsdir}doometernal.bms.txt" ]; then quickbms_script="doometernal.bms.txt"; fi
if [ -f "${quickbmsdir}doometernal.bms" ]; then quickbms_script="doometernal.bms"; fi
if [ -z ${quickbms_script+x} ]; then MissingScript; fi

#Ask for output path

read outputdir

if ! [[ "$outputdir" == */ ]]; then outputdir="${outputdir}/";fi
if ! ls -1qA "$outputdir" | grep -q .
then  OutputIsntEmpty
fi

#Prompt to start extraction


find .  -name '*.resources' -exec sh -c 'quickbms' sh {} \;

