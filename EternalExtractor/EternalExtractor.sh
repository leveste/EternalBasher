#!/bin/bash

printf "Eternal Extractor Bash script\n
			by Leveste and PowerBall253\n
			based on the original file by Zwip-Zwap Zapony\n\n\n"

___GAME_DIRECTORY=""
___OUTPUT_DIRECTORY=""
___QUICKBMS_DIRECTORY=""
___QUICKBMS_SCRIPT=""

CD=""


printf "This batch file runs QuickBMS to extract the contents of all of DOOM Eternal's *.resources archives in one go.\n\n
If you only want to use others' DOOM Eternal mods, not make your own, this isn't useful for you; simply close this window now.\n\n
Otherwise, please input the full filepath to your DOOM Eternal installation:\n\n
"

read gamedir

if ! [ $gamedir == */ ]; then gamedir="${gamedir}/"

if ! [ -f "${gamedir}DOOMEternalx64vk.exe" ]; then MissingDoomEternal; fi
if ! [ -f "${gamedir}base/gameresources.resources" ]; then MissingResources; fi

#Ask for QuickBMS path

read quickbmsdir

if ! [ $quickbmsdir == */ ]; then gamedir="${gamedir}/"

if ! [ -f "${quickbmsdir}quickbms_4gb_files.exe" ]; then MissingQuickBMS; fi
if [ -f "${quickbmsdir}doometernal.txt" ]; then quickbms_script = "doometernal.txt"; fi
if [ -f "${quickbmsdir}doometernal.txt" ]; then quickbms_script = "doometernal.bms.txt"; fi
if [ -f "${quickbmsdir}doometernal.txt" ]; then quickbms_script = "doometernal.bms"; fi
if [ -z ${quickbms_script+x} ]; then MissingScript; fi
