#!/bin/bash

#Colors
red=$'\e[1;31m'
grn=$'\e[1;32m'
blu=$'\e[1;34m'
end=$'\e[0m'

#Functions
MissingGame() {
printf "%s\n" "
${red}Game Executable not found! Make sure you put this shell script in the DOOMEternal folder and try again.${end}
"
exit 1
}

MissingDEternalLoadMods() {
printf "%s\n" "
${red}DEternal_loadMods not found or corrupted! Re-extract the tool to the DOOMEternal folder and try again.${end}
"
exit 1
}

MissingIdRehash() {
printf "%s\n" "
${red}idRehash not found or corrupted! Re-extract the tool to the DOOMEternal/base folder and try again.${end}
"
exit 1
}

CorruptedGameExecutable() {
printf "%s\n" "
${red}The game executable is corrupted! Verify game files through Steam/Bethesda.net and try again.${end}
	"
exit 1
}

MissingEternalPatcher() {
printf "%s\n" "
${red}EternalPatcher not found or corrupted! Re-extract the tool to the DOOMEternal folder and try again.${end}
"
exit 1
}

CreateConfigFile() {
ASSET_VERSION="4.1"
echo ":ASSET_VERSION=4.1" >> "EternalModInjector Settings.txt"

echo ":AUTO_LAUNCH_GAME=1" >> "EternalModInjector Settings.txt"

echo ":GAME_PARAMETERS=" >> "EternalModInjector Settings.txt"

HAS_CHECKED_RESOURCES="0"
echo ":HAS_CHECKED_RESOURCES=0" >> "EternalModInjector Settings.txt"

HAS_READ_FIRST_TIME="0"
echo ":HAS_READ_FIRST_TIME=0" >> "EternalModInjector Settings.txt"

RESET_BACKUPS="0"
echo ":RESET_BACKUPS=0" >> "EternalModInjector Settings.txt"

echo >> "EternalModInjector Settings.txt"

find . -name "*.backup" -type f -delete
}

ResetBackups() {
read -r -p $'\e[34mReset backups now? [y/N] \e[0m' response
case "$response" in
	[yY][eE][sS]|[yY]) 
       		find . -name "*.backup" -type f -delete
		;;
	*)
		printf "%s\n" "
${blu}Backups have not been reset.${end}
"
		exit 1
		;;
esac
}

NoBackupFound() {
printf "%s\n" "
${red}Backup not found for some .resources files! Verify game files through Steam/Bethesda.net, then open 'EternalModInjector Settings.txt' with a text editor and change RESET_BACKUPS value to 1 and try again.${end}
	"
exit 1
}

MissingMeta() {
printf "%s\n" "
${red}meta.resources not found or corrupted! Verify game files through Steam/Bethesda.net, then open 'EternalModInjector Settings.txt' with a text editor and change RESET_BACKUPS value to 1, then try again.${end}
"
exit 1
}

printf "%s\n" "${grn}EternalModInjector Shell Script
By Leveste and PowerBall253
Based on original batch file by Zwip-Zwap Zapony${end}"

#Verify if tools exist
if ! [ -f DOOMEternalx64vk.exe ]; then MissingGame; fi
if ! [ -f DEternal_loadMods.exe ]; then MissingDEternalLoadMods; fi
#if ! [ -f base/DEternal_loadMods.exe ]; then MissingDEternalLoadMods; fi
if ! [ -f base/idRehash.exe ]; then MissingIdRehash; fi

#Give executable permissions to tools
chmod +x DEternal_loadMods.exe
chmod +x base/idRehash.exe

#Assign game hashes to variables
ASSET_VERSION="4.1"
DETERNAL_LOADMODS_MD5="43c54928c12d5d72c32f563f01dc7aef"
ETERNALPATCHER_MD5="8033260ff14c2ee441b81bbf8d3b2de0"
IDREHASH_MD5="50747578b8e29c3da1aa5a3ac5d28cc7"
PATCHED_GAME_MD5_A="3238e7a9277efc6a607b1b1615ebe79f"
PATCHED_GAME_MD5_B="4acdaf89f30f178ba9594c0364b35a30"
VANILLA_GAME_MD5_A="1ef861b693cdaa45eba891d084e5f3a3"
VANILLA_GAME_MD5_B="c2b429b2eb398f836dd10d22944b9c76"
VANILLA_META_MD5="4f4deb1df8761dc8fd2d3b25a12d8d91"

#Verify tool hashes
printf "%s\n" "
${blu}Checking tools...${end}
"

DEternal_LoadModsMD5=($(md5sum DEternal_loadMods.exe))
#DEternal_LoadModsMD5=($(md5sum base/DEternal_loadMods.exe))
idRehashMD5=($(md5sum base/idRehash.exe))
if ! [ $DETERNAL_LOADMODS_MD5 == $DEternal_LoadModsMD5 ]; then MissingDEternalLoadMods; fi
if ! [ $IDREHASH_MD5 == $idRehashMD5 ]; then MissingDEternalLoadMods; fi

#Patch Game Executable
GameMD5=($(md5sum DOOMEternalx64vk.exe))
if ! ( [[ $VANILLA_GAME_MD5_A == $GameMD5 ]] || [[ $VANILLA_GAME_MD5_B == $GameMD5 ]] || [[ $PATCHED_GAME_MD5_A == $GameMD5 ]] || [[ $PATCHED_GAME_MD5_B == $GameMD5 ]] ); then CorruptedGameExecutable; fi

if [[ $VANILLA_GAME_MD5_A == $GameMD5 ]] || [[ $VANILLA_GAME_MD5_B == $GameMD5 ]]; then
	if ! [ -f EternalPatcher.exe ]; then MissingEternalPatcher; fi
#	if ! [ -f base/EternalPatcher.exe ]; then MissingEternalPatcher; fi
	EternalPatcherMD5=($(md5sum EternalPatcher.exe))
#	EternalPatcherMD5=($(md5sum base/EternalPatcher.exe))
	if ! [ $ETERNALPATCHER_MD5 == $EternalPatcherMD5 ]; then MissingEternalPatcher; fi
	chmod +x EternalPatcher.exe
#	chmod +x base/EternalPatcher.exe
	( wine EternalPatcher.exe --patch DOOMEternalx64vk.exe ) > /dev/null 2>&1
#	cd base
#	( wine EternalPatcher.exe --patch ../DOOMEternalx64vk.exe ) > /dev/null 2>&1
#	cd ..

fi
GameMD5=($(md5sum DOOMEternalx64vk.exe))
if ! ( [[ $PATCHED_GAME_MD5_A == $GameMD5 ]] || [[ $PATCHED_GAME_MD5_B == $GameMD5 ]] ); then
	printf "%s\n" "
${red}Game patching failed! Verify game files from Steam/Bethesda.net then try again.${end}
"
	exit 1
fi

#Config File check
printf "%s\n" "
${blu}Loading config file...${end}
"
if ! [ -f "EternalModInjector Settings.txt" ]; then CreateConfigFile; else
	CONFIG_FILE="EternalModInjector Settings.txt"
	if grep -q ":ASSET_VERSION=4.1" "$CONFIG_FILE"; then ASSET_VERSION="4.1"; else ASSET_VERSION="0"; fi
	if grep -q ":RESET_BACKUPS=1" "$CONFIG_FILE"; then RESET_BACKUPS="1"; else RESET_BACKUPS="0"; fi
	if grep -q ":HAS_READ_FIRST_TIME=1" "$CONFIG_FILE"; then HAS_READ_FIRST_TIME="1"; else HAS_READ_FIRST_TIME="0"; fi
	if grep -q ":HAS_CHECKED_RESOURCES=2" "$CONFIG_FILE"; then HAS_CHECKED_RESOURCES="2"; else
		if grep -q ":HAS_CHECKED_RESOURCES=1" "$CONFIG_FILE"; then HAS_CHECKED_RESOURCES="1"; else HAS_CHECKED_RESOURCES="0"; fi
	fi
fi

#Setup for ModLoader
if [ $HAS_READ_FIRST_TIME == "0" ]; then
	read -p $'\e[34mFirst-time information:

This batch file automatically...
- Makes backups of DOOM Eternal .resources archives the first time that they will be modified.
- Restores ones that were modified last time (to prevent uninstalled mods from lingering around) on subsequent uses.
- Runs DEternal_loadMods to load all mods in -/DOOMEternal/Mods/.
- Runs idRehash to rehash the modified resources hashes.
- Runs EternalPatcher to apply EXE patches to the DOOM Eternal game executable.

Press any key to continue...\e[0m'
echo	
	read -p $'\e[34mWe take no credit for the tools used in the mod loading, credits go to:
DEternal_loadMods: SutandoTsukai181 for making it in Python (based on a QuickBMS-based unpacker made for Wolfenstein II: The New Colossus by aluigi and edited for DOOM Eternal by one of infograms friends), and proteh for remaking it in C#
EternalPatcher: proteh for making it (based on EXE patches made by infogram that were based on Cheat Engine patches made by SunBeam, as well as based on EXE patches made by Visual Studio)
idRehash: infogram for making it, and proteh for updating it
DOOM Eternal: Bethesda Softworks, id Software, and everyone else involved, for making and updating it.

Press any key to continue...\e[0m'
echo
	read -p $'\e[34mIf any mods are currently installed and/or you have some outdated files when EternalModInjector makes .resources backups, the subsequent backups will contain those mods and/or be outdated.
Dont worry, though; If you ever mess up in a way that results in an already-modified/outdated backup, simply verify/repair DOOM Eternal installation through Steam or the Bethesda.net Launcher, open EternalModInjector Settings.txt in Notepad, change the :RESET_BACKUPS=0 line to :RESET_BACKUPS=1, and save the file.

Press any key to continue...\e[0m'
echo
read -p $'\e[34mNow, without further ado, press any key to continue one last time, and this batch file will initiate mod-loading mode.

Press any key to continue...\e[0m'
HAS_READ_FIRST_TIME="1"
fi

if [ $ASSET_VERSION == "0" ]; then
	read -p $'\e[34mOld Doom Eternal backups detected! Verify the game files through Steam/Bethesda.net then run this batch again to reset your backups.
If you have already done so, press Enter to continue.\e[0m:'
	ResetBackups
	ASSET_VERSION="4.1"
	HAS_CHECKED_RESOURCES="1"
fi

if [ $RESET_BACKUPS == "1" ]; then
	ResetBackups
	read -p $'\e[34mPress Enter to continue with mod loading.\e[0m:'	
fi

ResourceFilePaths=(
hub_path="./base/game/hub/hub.resources"
hub_patch1_path="./base/game/hub/hub_patch1.resources"
e1m1_intro_patch2_path="./base/game/sp/e1m1_intro/e1m1_intro_patch2.resources"
e1m1_intro_patch1_path="./base/game/sp/e1m1_intro/e1m1_intro_patch1.resources"
e1m1_intro_path="./base/game/sp/e1m1_intro/e1m1_intro.resources"
e2m2_base_patch1_path="./base/game/sp/e2m2_base/e2m2_base_patch1.resources"
e2m2_base_path="./base/game/sp/e2m2_base/e2m2_base.resources"
e2m2_base_patch2_path="./base/game/sp/e2m2_base/e2m2_base_patch2.resources"
e1m3_cult_patch1_path="./base/game/sp/e1m3_cult/e1m3_cult_patch1.resources"
e1m3_cult_path="./base/game/sp/e1m3_cult/e1m3_cult.resources"
e1m3_cult_patch2_path="./base/game/sp/e1m3_cult/e1m3_cult_patch2.resources"
e1m4_boss_path="./base/game/sp/e1m4_boss/e1m4_boss.resources"
e1m4_boss_patch1_path="./base/game/sp/e1m4_boss/e1m4_boss_patch1.resources"
e1m4_boss_patch2_path="./base/game/sp/e1m4_boss/e1m4_boss_patch2.resources"
e3m2_hell_path="./base/game/sp/e3m2_hell/e3m2_hell.resources"
e3m2_hell_patch2_path="./base/game/sp/e3m2_hell/e3m2_hell_patch2.resources"
e3m2_hell_patch1_path="./base/game/sp/e3m2_hell/e3m2_hell_patch1.resources"
e3m1_slayer_patch1_path="./base/game/sp/e3m1_slayer/e3m1_slayer_patch1.resources"
e3m1_slayer_path="./base/game/sp/e3m1_slayer/e3m1_slayer.resources"
e3m1_slayer_patch2_path="./base/game/sp/e3m1_slayer/e3m1_slayer_patch2.resources"
e2m3_core_patch2_path="./base/game/sp/e2m3_core/e2m3_core_patch2.resources"
e2m3_core_path="./base/game/sp/e2m3_core/e2m3_core.resources"
e2m3_core_patch1_path="./base/game/sp/e2m3_core/e2m3_core_patch1.resources"
e3m2_hell_b_patch2_path="./base/game/sp/e3m2_hell_b/e3m2_hell_b_patch2.resources"
e3m2_hell_b_patch1_path="./base/game/sp/e3m2_hell_b/e3m2_hell_b_patch1.resources"
e3m2_hell_b_path="./base/game/sp/e3m2_hell_b/e3m2_hell_b.resources"
e3m3_maykr_patch1_path="./base/game/sp/e3m3_maykr/e3m3_maykr_patch1.resources"
e3m3_maykr_patch2_path="./base/game/sp/e3m3_maykr/e3m3_maykr_patch2.resources"
e3m3_maykr_path="./base/game/sp/e3m3_maykr/e3m3_maykr.resources"
e1m2_battle_patch1_path="./base/game/sp/e1m2_battle/e1m2_battle_patch1.resources"
e1m2_battle_path="./base/game/sp/e1m2_battle/e1m2_battle.resources"
e1m2_battle_patch2_path="./base/game/sp/e1m2_battle/e1m2_battle_patch2.resources"
e3m4_boss_patch1_path="./base/game/sp/e3m4_boss/e3m4_boss_patch1.resources"
e3m4_boss_path="./base/game/sp/e3m4_boss/e3m4_boss.resources"
e3m4_boss_patch2_path="./base/game/sp/e3m4_boss/e3m4_boss_patch2.resources"
e2m1_nest_patch1_path="./base/game/sp/e2m1_nest/e2m1_nest_patch1.resources"
e2m1_nest_path="./base/game/sp/e2m1_nest/e2m1_nest.resources"
e2m1_nest_patch2_path="./base/game/sp/e2m1_nest/e2m1_nest_patch2.resources"
e2m4_boss_path="./base/game/sp/e2m4_boss/e2m4_boss.resources"
e2m4_boss_patch1_path="./base/game/sp/e2m4_boss/e2m4_boss_patch1.resources"
e4m1_rig_patch1_path="./base/game/dlc/e4m1_rig/e4m1_rig_patch1.resources"
e4m1_rig_patch2_path="./base/game/dlc/e4m1_rig/e4m1_rig_patch2.resources"
e4m1_rig_path="./base/game/dlc/e4m1_rig/e4m1_rig.resources"
dlc_hub_path="./base/game/dlc/hub/hub.resources"
dlc_hub_patch1_path="./base/game/dlc/hub/hub_patch1.resources"
e4m3_mcity_patch1_path="./base/game/dlc/e4m3_mcity/e4m3_mcity_patch1.resources"
e4m3_mcity_path="./base/game/dlc/e4m3_mcity/e4m3_mcity.resources"
e4m2_swamp_patch2_path="./base/game/dlc/e4m2_swamp/e4m2_swamp_patch2.resources"
e4m2_swamp_patch1_path="./base/game/dlc/e4m2_swamp/e4m2_swamp_patch1.resources"
e4m2_swamp_path="./base/game/dlc/e4m2_swamp/e4m2_swamp.resources"
tutorial_demons_path="./base/game/tutorials/tutorial_demons.resources"
tutorial_sp_path="./base/game/tutorials/tutorial_sp.resources"
tutorial_pvp_laser_path="./base/game/tutorials/tutorial_pvp_laser/tutorial_pvp_laser.resources"
tutorial_pvp_laser_patch1_path="./base/game/tutorials/tutorial_pvp_laser/tutorial_pvp_laser_patch1.resources"
pvp_bronco_patch1_path="./base/game/pvp/pvp_bronco/pvp_bronco_patch1.resources"
pvp_bronco_path="./base/game/pvp/pvp_bronco/pvp_bronco.resources"
pvp_shrapnel_patch1_path="./base/game/pvp/pvp_shrapnel/pvp_shrapnel_patch1.resources"
pvp_shrapnel_path="./base/game/pvp/pvp_shrapnel/pvp_shrapnel.resources"
pvp_zap_patch1_path="./base/game/pvp/pvp_zap/pvp_zap_patch1.resources"
pvp_zap_path="./base/game/pvp/pvp_zap/pvp_zap.resources"
pvp_thunder_patch1_path="./base/game/pvp/pvp_thunder/pvp_thunder_patch1.resources"
pvp_thunder_path="./base/game/pvp/pvp_thunder/pvp_thunder.resources"
pvp_inferno_patch1_path="./base/game/pvp/pvp_inferno/pvp_inferno_patch1.resources"
pvp_inferno_path="./base/game/pvp/pvp_inferno/pvp_inferno.resources"
pvp_deathvalley_patch1_path="./base/game/pvp/pvp_deathvalley/pvp_deathvalley_patch1.resources"
pvp_deathvalley_path="./base/game/pvp/pvp_deathvalley/pvp_deathvalley.resources"
pvp_laser_patch1_path="./base/game/pvp/pvp_laser/pvp_laser_patch1.resources"
pvp_laser_path="./base/game/pvp/pvp_laser/pvp_laser.resources"
shell_patch1_path="./base/game/shell/shell_patch1.resources"
shell_path="./base/game/shell/shell.resources"
warehouse_path="./base/warehouse.resources"
gameresources_path="./base/gameresources.resources"
meta_path="./base/meta.resources"
gameresources_patch2_path="./base/gameresources_patch2.resources"
gameresources_patch1_path="./base/gameresources_patch1.resources"
)

#Check for all resources files
printf "%s\n" "
${blu}Checking resources files...${end}
"
if [ $HAS_CHECKED_RESOURCES == "0" ]; then
for (( i = 0; i < ${#ResourceFilePaths[@]} ; i++ )); do
    line="${ResourceFilePaths[$i]#*=}"
    if ! [ -f $line ]; then
        printf "%s\n" "
${red}Some .resources files are missing! Verify game files through Steam/Bethesda.net then try again.${end}
"
        exit 1
    fi
done
HAS_CHECKED_RESOURCES="1"
fi

#Set new values in config file
if grep -q ":ASSET_VERSION=" "$CONFIG_FILE"; then
	sed -i 's/:ASSET_VERSION=.*/:ASSET_VERSION=4.1/' "EternalModInjector Settings.txt"
else
	echo ":ASSET_VERSION=4.1" >> "EternalModInjector Settings.txt"
	echo >> "EternalModInjector Settings.txt"
	sed -i '0,/^[[:space:]]*$/{//d}' "EternalModInjector Settings.txt"
fi

if grep -q ":HAS_CHECKED_RESOURCES=" "$CONFIG_FILE"; then
	sed -i 's/:HAS_CHECKED_RESOURCES=.*/:HAS_CHECKED_RESOURCES=1/' "EternalModInjector Settings.txt"
else
	echo ":HAS_CHECKED_RESOURCES=1" >> "EternalModInjector Settings.txt"
	echo >> "EternalModInjector Settings.txt"
	sed -i '0,/^[[:space:]]*$/{//d}' "EternalModInjector Settings.txt"
fi

if grep -q ":HAS_READ_FIRST_TIME=" "$CONFIG_FILE"; then
	sed -i 's/:HAS_READ_FIRST_TIME=.*/:HAS_READ_FIRST_TIME=1/' "EternalModInjector Settings.txt"
else
	echo ":HAS_READ_FIRST_TIME=0" >> "EternalModInjector Settings.txt"
	echo >> "EternalModInjector Settings.txt"
	sed -i '0,/^[[:space:]]*$/{//d}' "EternalModInjector Settings.txt"
fi

if grep -q ":RESET_BACKUPS=" "$CONFIG_FILE"; then
	sed -i 's/:RESET_BACKUPS=.*/:RESET_BACKUPS=0/' "EternalModInjector Settings.txt"
else
	echo ":RESET_BACKUPS=0" >> "EternalModInjector Settings.txt"
	echo >> "EternalModInjector Settings.txt"
	sed -i '0,/^[[:space:]]*$/{//d}' "EternalModInjector Settings.txt"
fi

#Execute each line of ResourceFilePaths
for (( i = 0; i < ${#ResourceFilePaths[@]} ; i++ )); do
	eval "${ResourceFilePaths[$i]}"
done

#Restore Backups
if ! [ $RESET_BACKUPS == "1" ]; then
printf "
${blu}Restoring backups...${end}
"
while IFS= read -r filename; do
	if [[ "$filename" == *.resources ]] || [[ "$filename" == *.resources* ]]; then
		filename=${filename//[[:cntrl:]]/}
		filename_name=${filename%.resources*}
		path=${filename_name}_path
		path=${!path}
		if ! [[ "$filename" == dlc_* ]]; then
			printf "%s\n" "
                	${blu}Restoring ${filename_name}.resources.backup${end}
                	"
        		if ! [ -f "$path" ]; then NoBackupFound ; fi
			yes | cp "${path}.backup" "$path"
		else
			printf "%s\n" "
                	${blu}Restoring dlc_${filename_name}.resources.backup${end}
                	"
			if ! [ -f "$path" ]; then NoBackupFound ; fi
			yes | cp "${path}.backup" "$path"

		fi		
	fi	
done < "EternalModInjector Settings.txt"
fi
RESET_BACKUPS="0"

#Check meta.resources
printf "%s\n" "
${blu}Checking meta.resources...${end}
"
if [ $HAS_CHECKED_RESOURCES == "1" ]; then
	if ! [ -f base/meta.resources ]; then MissingMeta; fi
	MetaMD5=($(md5sum base/meta.resources))
	if ! [[ $VANILLA_META_MD5 == $MetaMD5 ]]; then MissingMeta; fi
fi

#Check if there are mods in "mods" folder
if [ -z "$(ls -A "Mods")" ]; then
	printf "
${grn}No mods found! All .resources files have been restored to their vanilla state.${end}
"
	exit 1
fi

#Backup .resources
printf "%s\n" "
${blu}Backing up .resources...${end}
"
if [ -f modloaderlistdos.txt ]; then rm modloaderlistdos.txt; fi
if [ -f modloaderlist.txt ]; then rm modloaderlist.txt; fi
echo $(wine DEternal_loadMods.exe "." --list-res) >> modloaderlistdos.txt
#echo $(wine base/DEternal_loadMods.exe "." --list-res) >> modloaderlistdos.txt
perl -pe 's/\r\n|\n|\r/\n/g'   modloaderlistdos.txt > modloaderlist.txt
rm modloaderlistdos.txt
( sed 's/\\/\//g' modloaderlist.txt ) > /dev/null 2>&1
sed -i '/.resources$/d' "EternalModInjector Settings.txt"
while IFS= read -r filename; do
    filename=$(echo $filename | sed 's/\\/\//g')
	if ! [ -f "${filename}.backup" ]; then
		cp "$filename" "${filename}.backup"
		name=${filename##*/}
		printf "%s\n" "
			${blu}Backed up $name${end}
		"
	else
		name=${filename##*/}
	fi
	filename=${name%.resources}
	grep -v "${filename}.backup" "EternalModInjector Settings.txt" > nobackups.txt; mv nobackups.txt "EternalModInjector Settings.txt"
	if ! grep -q "${filename}.backup" "$CONFIG_FILE"; then echo ${filename}.backup >> "EternalModInjector Settings.txt"; fi
	echo ${filename}.resources >> "EternalModInjector Settings.txt"
done < modloaderlist.txt
rm modloaderlist.txt

#Backup meta.resources and add to the list
if ! [ -f "base/meta.resources.backup" ]; then 
	cp "base/meta.resources" "base/meta.resources.backup"
	printf "%s\n" "
	${blu}Backed up meta.resources${end}
	"
fi
sed -i '/meta.backup$/d' "EternalModInjector Settings.txt"
echo meta.backup >> "EternalModInjector Settings.txt"
echo meta.resources >> "EternalModInjector Settings.txt"


#Get vanilla resource hash offsets (idRehash)
if ! [ $HAS_CHECKED_RESOURCES == "2" ]; then
	printf "%s\n" "
${blu}Getting vanilla resource hash offsets... (idRehash)${end}
"
	cd base
	wine idRehash.exe --getoffsets
	cd ..
	HAS_CHECKED_RESOURCES="2"
fi
sed -i 's/:HAS_CHECKED_RESOURCES=.*/:HAS_CHECKED_RESOURCES=2/' "EternalModInjector Settings.txt"

#Load Mods (DEternal_loadMods)
printf "%s\n" "
	${blu}Loading mods... (DEternal_loadMods)${end}
	"
wine DEternal_loadMods.exe "."
#wine base/DEternal_loadMods.exe "."

#Rehash resource hashes (idRehash)
cd base
wine idRehash.exe
cd ..

printf "%s\n" "
${grn}Mods have been loaded! You can now launch the game.${end}
"
exit 1
