#!/bin/bash

#Functions
MissingGame() {
read -p "
	Game Executable not found! Make sure you put this shell script in the DOOMEternal folder and try again.
	"
exit 1
}

MissingDEternalLoadMods() {
read -p "
	DEternal_loadMods not found or corrupted! Re-extract the tool to the DOOMEternal folder and try again.
	"
exit 1
}

MissingIdRehash() {
read -p "
	idRehash not found or corrupted! Re-extract the tool to the DOOMEternal/base folder and try again.
	"
exit 1
}

CorruptedGameExecutable() {
read -p "
	The game executable is corrupted! Verify game files through Steam/Bethesda.net and try again.
	"
exit 1
}

MissingEternalPatcher() {
read -p "
	EternalPatcher not found or corrupted! Re-extract the tool to the DOOMEternal folder and try again.
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
read -r -p "Reset backups now? [y/N] " response
case "$response" in
	[yY][eE][sS]|[yY]) 
       		find . -name "*.backup" -type f -delete
		;;
	*)
		read -p "
	Backups have not been reset.
			"
		exit 1
		;;
esac
}

NoBackupFound() {
read -p "
	Backup not found for some .resources files! Verify game files through Steam/Bethesda.net, then open 'EternalModInjector Settings.txt' with a text editor and change RESET_BACKUPS value to 1 and try again.
	"
exit 1
}

MissingMeta() {
read -p "
	meta.resources not found or corrupted! Verify game files through Steam/Bethesda.net, then open 'EternalModInjector Settings.txt' with a text editor and change RESET_BACKUPS value to 1, then try again.
"
exit 1
}

printf "EternalModInjector Shell Script\n\n
	By Leveste and PowerBall253\n\n
	Based on original batch file by Zwip-Zwap Zapony\n\n\n"

#Verify if tools exist
if ! [ -f DOOMEternalx64vk.exe ]; then MissingGame; fi
if ! [ -f DEternal_loadMods.exe ]; then MissingDEternalLoadMods; fi
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
printf "
Checking tools...
"

DEternal_LoadModsMD5=($(md5sum DEternal_loadMods.exe))
idRehashMD5=($(md5sum base/idRehash.exe))
if ! [ $DETERNAL_LOADMODS_MD5 == $DEternal_LoadModsMD5 ]; then MissingDEternalLoadMods; fi
if ! [ $IDREHASH_MD5 == $idRehashMD5 ]; then MissingDEternalLoadMods; fi

#Patch Game Executable
GameMD5=($(md5sum DOOMEternalx64vk.exe))
if ! ( [[ $VANILLA_GAME_MD5_A == $GameMD5 ]] || [[ $VANILLA_GAME_MD5_B == $GameMD5 ]] || [[ $PATCHED_GAME_MD5_A == $GameMD5 ]] || [[ $PATCHED_GAME_MD5_B == $GameMD5 ]] ); then CorruptedGameExecutable; fi

if [[ $VANILLA_GAME_MD5_A == $GameMD5 ]] || [[ $VANILLA_GAME_MD5_B == $GameMD5 ]]; then
	if ! [ -f EternalPatcher.exe ]; then MissingEternalPatcher; fi
	EternalPatcherMD5=($(md5sum EternalPatcher.exe))
	if ! [ $ETERNALPATCHER_MD5 == $EternalPatcherMD5 ]; then MissingEternalPatcher; fi
	chmod +x EternalPatcher.exe
	wine EternalPatcher.exe --patch DOOMEternalx64vk.exe
fi
GameMD5=($(md5sum DOOMEternalx64vk.exe))
if ! ( [[ $PATCHED_GAME_MD5_A == $GameMD5 ]] || [[ $PATCHED_GAME_MD5_B == $GameMD5 ]] ); then
	read -p "
	Game patching failed! Verify game files from Steam/Bethesda.net then try again.
	"
	exit 1
fi

#Config File check
printf "
Loading config file...
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
	read -p "
	Some first time message
	"
	HAS_READ_FIRST_TIME="1"
fi

if [ $ASSET_VERSION == "0" ]; then
	read -p "
	Old Doom Eternal backups detected! Verify the game files through Steam/Bethesda.net then run this batch again to reset your backups.
	"
	ResetBackups
	ASSET_VERSION="4.1"
fi

if [ $RESET_BACKUPS == "1" ]; then
	ResetBackups
	RESET_BACKUPS="0"
	read -p "Press Enter to continue with mod loading. "	
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
printf "
Checking resources files...
"
if [ $HAS_CHECKED_RESOURCES == "0" ]; then
for (( i = 0; i < ${#ResourceFilePaths[@]} ; i++ )); do
    line="${ResourceFilePaths[$i]#*=}"
    if ! [ -f $line ]; then
        read -p "
	Some .resources files are missing! Verify game files through Steam/Bethesda.net then try again.
	"
        exit 1
    fi
done
HAS_CHECKED_RESOURCES="1"
fi

#Set new values in config file
sed -i 's/:ASSET_VERSION=.*/:ASSET_VERSION=4.1/' "EternalModInjector Settings.txt" 
sed -i 's/:RESET_BACKUPS=.*/:RESET_BACKUPS=0/' "EternalModInjector Settings.txt" 
sed -i 's/:HAS_READ_FIRST_TIME=.*/:HAS_READ_FIRST_TIME=1/' "EternalModInjector Settings.txt"

#Execute each line of ResourceFilePaths
for (( i = 0; i < ${#ResourceFilePaths[@]} ; i++ )); do
	eval "${ResourceFilePaths[$i]}"
done

#Restore Backups
printf "
Restoring backups...
"
while IFS= read -r filename; do
	if [[ "$filename" == *.resources ]] || [[ "$filename" == *.resources* ]]; then
		filename=${filename//[[:cntrl:]]/}
		filename_name=${filename%.resources*}
		path=${filename_name}_path
		path=$(echo ${!path})
		if ! [[ "$filename" == dlc_* ]]; then
			printf "
                	Restoring ${filename_name}.resources.backup
                	"
        		if ! grep -q "${filename_name}.backup" "$CONFIG_FILE"; then NoBackupFound ; fi
			yes | cp "${path}.backup" "$path"
		else
			printf "
                	Restoring dlc_${filename_name}.resources.backup
                	"
			if ! grep -q "dlc_${filename_name}.backup" "$CONFIG_FILE"; then NoBackupFound ; fi
			yes | cp "${path}.backup" "$path"

		fi		
	fi	
done < "EternalModInjector Settings.txt"

#Check meta.resources
printf "
Checking meta.resources...
"
if ! [ $HAS_CHECKED_RESOURCES == "0" ]; then
	if ! [ -f base/meta.resources ]; then MissingMeta; fi
	MetaMD5=($(md5sum base/meta.resources))
	if ! [[ $VANILLA_META_MD5 == $MetaMD5 ]]; then MissingMeta; fi
fi

#Backup .resources
printf "
	Backing up .resources...
"
if [ -f modloaderlistdos.txt ]; then rm modloaderlistdos.txt; fi
if [ -f modloaderlist.txt ]; then rm modloaderlist.txt; fi
echo $(wine DEternal_loadMods.exe "." --list-res) >> modloaderlistdos.txt
perl -pe 's/\r\n|\n|\r/\n/g'   modloaderlistdos.txt > modloaderlist.txt
rm modloaderlistdos.txt
sed 's/\\/\//g' modloaderlist.txt
grep -v ".resources" "EternalModInjector Settings.txt" > noresources.txt; mv noresources.txt "EternalModInjector Settings.txt"
while IFS= read -r filename; do
    filename=$(echo $filename | sed 's/\\/\//g')
	if ! [ -f "${filename}.backup" ]; then cp "$filename" "${filename}.backup"; fi
	name=${filename##*/}
	if ! [ -f "${filename}.backup" ]; then	printf "
	Backed up $name
	"; fi
	filename=${name%.resources}
	grep -v "${filename}.backup" "EternalModInjector Settings.txt" > nobackups.txt; mv nobackups.txt "EternalModInjector Settings.txt"
	if ! grep -q "${filename}.backup" "$CONFIG_FILE"; then echo ${filename}.backup >> "EternalModInjector Settings.txt"; fi
	echo ${filename}.resources >> "EternalModInjector Settings.txt"
done < modloaderlist.txt
rm modloaderlist.txt

#Backup meta.resources and add to the list
if ! [ -f "base/meta.resources.backup" ]; then 
	cp "base/meta.resources" "base/meta.resources.backup"
	printf "
	Backed up meta.resources
	"
fi
echo meta.backup >> "EternalModInjector Settings.txt"
echo meta.resources >> "EternalModInjector Settings.txt"

#Get vanilla resource hash offsets (idRehash)
if ! [ $HAS_CHECKED_RESOURCES == "2" ]; then
	printf "
	Getting vanilla resource hash offsets... (idRehash)
	"
	wine base/idRehash.exe --getoffsets
	HAS_CHECKED_RESOURCES="2"
fi
sed -i 's/:HAS_CHECKED_RESOURCES=.*/:HAS_CHECKED_RESOURCES=2/' "EternalModInjector Settings.txt"

#Load Mods (DEternal_loadMods)
printf "
	Loading mods... (DEternal_loadMods)
	"
wine DEternal_loadMods.exe "."

#Rehash resource hashes (idRehash)
wine base/idRehash.exe

read -p "
	Mods have been loaded! Now you can launch the game.
	"
exit 1
