#!/bin/bash

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
	printf "quickbms not found!
	Is your QuickBMS installation incomplete, or did you use a wrong path?
	The path that you gave was %s" "$___QUICKBMS_DIR"
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

printf "Eternal Extractor Bash script\n
			by Leveste and PowerBall253\n
			based on the original file by Zwip-Zwap Zapony\n\n\n"

___GAMEDIR="$HOME/.local/share/Steam/steamapps/common/DOOMEternal/"
___OUTPUT_DIR=""
___QUICKBMS_DIR=""
___QUICKBMS_SCRIPT=""




printf "This batch file runs QuickBMS to extract the contents of all of DOOM Eternal's *.resources archives in one go.\n\n
If you only want to use others' DOOM Eternal mods, not make your own, this isn't useful for you; simply close this window now.\n\n
Otherwise, please input the full filepath to your DOOM Eternal installation:\n\n
			This script assumes that you have placed the 'doometernal.bms' file in your game directory. If you haven't, please move or copy it over.\n\n
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

#Ask for QuickBMS path

printf "How did you install QuickBMS?\n
		1 - Compiled the source code with 'make'\n
		2 - Installed from the Arch User Repository(AUR)\n
		3 - Exit\n\n"

while true
do
	read -r ___QUICKBMS_SOURCE
	case "$___QUICKBMS_SOURCE" in
		"1")
			read -rp "Please type the path to your QuickBMS directory: " ___QUICKBMS_DIR
			break
			;;
		"2")
			___QUICKBMS_DIR="/usr/bin/"
			break
			;;
		"3")
			echo "Exiting script."
			exit 1
			;;
		*)
			read -rp "Not a valid option. Please try again." ___QUICKBMS_SOURCE
			;;
	esac
done
if ! [[ "$___QUICKBMS_DIR" == */ ]]; then ___QUICKBMS_DIR="${___QUICKBMS_DIR}/"; fi

if ! [ -f "${___QUICKBMS_DIR}quickbms" ]; then MissingQuickBMS; fi
if [ -f "${___GAMEDIR}doometernal.txt" ]; then ___QUICKBMS_SCRIPT="${___GAMEDIR}doometernal.txt"; fi
if [ -f "${___GAMEDIR}doometernal.bms.txt" ]; then ___QUICKBMS_SCRIPT="${___GAMEDIR}doometernal.bms.txt"; fi
if [ -f "${___GAMEDIR}doometernal.bms" ]; then ___QUICKBMS_SCRIPT="${___GAMEDIR}doometernal.bms"; fi
if [ -z ${___QUICKBMS_SCRIPT+x} ]; then MissingScript; fi

#Ask for output path

printf "Please input the full filepath to where you want to extract resources to.
Make sure that this filepath leads to a folder that's either empty or nonexistent:\n"

read -r ___OUTPUT_DIR

if ! [[ "$___OUTPUT_DIR" == */ ]]; then ___OUTPUT_DIR="${___OUTPUT_DIR}/";fi
if [ -n "$(ls -A "$___OUTPUT_DIR")" ] 
then  OutputIsntEmpty
fi

printf "The expected filesize required to extract DOOM Eternal v3.1's resources is 12.2 gigabytes. (Expect more in later updates.)\n
	Please note that extracting all *.resources archives might take hours, depending on your CPU and storage speed!\n\n
	And, just to make sure, does this look correct?

	DOOM Eternal: %s
	QuickBMS: %s
	Output: %s
	" "$___GAMEDIR" "$___QUICKBMS_DIR" "$___OUTPUT_DIR"

#Prompt to start extraction


if [[ "$___QUICKBMS_SOURCE" == "2" ]]
then
	find .  -name "*.resources" -exec sh -c "quickbms -o -Y '$___GAMEDIR/$___QUICKBMS_SCRIPT' '$1' '$___OUTPUT_DIR'" sh {} \;
else
	#alt command
	true
fi
