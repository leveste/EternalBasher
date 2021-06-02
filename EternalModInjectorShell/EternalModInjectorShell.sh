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

#Script version
script_version="v5.1.0"

#Colors
if [ "$skip_debug_check" != "1" ]; then red=$'\e[1;31m'; fi
if [ "$skip_debug_check" != "1" ]; then grn=$'\e[1;32m'; fi
if [ "$skip_debug_check" != "1" ]; then blu=$'\e[1;34m'; fi
if [ "$skip_debug_check" != "1" ]; then end=$'\e[0m'; fi

#Functions
MissingGame() {
printf "\n%s\n\n" "${red}Game Executable not found! Make sure you put this shell script in the DOOMEternal folder and try again.${end}"
exit 1
}

MissingDEternalLoadMods() {
printf "\n%s\n\n" "${red}DEternal_loadMods not found or corrupted! Re-extract the tool to the 'base' folder and try again.${end}"
exit 1
}

MissingIdRehash() {
printf "\n%s\n\n" "${red}idRehash not found or corrupted! Re-extract the tool to the DOOMEternal/base folder and try again.${end}"
exit 1
}

CorruptedGameExecutable() {
printf "\n%s\n\n" "${red}The game executable is corrupted! Verify game files through Steam/Bethesda.net and try again.${end}"
exit 1
}

MissingEternalPatcher() {
printf "\n%s\n\n" "${red}EternalPatcher not found or corrupted! Re-extract the tool to the 'base' folder and try again.${end}"
exit 1
}

MissingDEternalPatchManifest() {
printf "\n%s\n\n" "${red}DEternal_patchManifest not found or corrupted! Re-extract the tool to the 'base' folder and try again.${end}"
exit 1
}

CreateConfigFile() {
ASSET_VERSION="5.1"
echo ":ASSET_VERSION=5.1" >> "EternalModInjector Settings.txt"

echo ":AUTO_LAUNCH_GAME=1" >> "EternalModInjector Settings.txt"

echo ":GAME_PARAMETERS=" >> "EternalModInjector Settings.txt"

HAS_CHECKED_RESOURCES="0"
echo ":HAS_CHECKED_RESOURCES=0" >> "EternalModInjector Settings.txt"

HAS_READ_FIRST_TIME="0"
echo ":HAS_READ_FIRST_TIME=0" >> "EternalModInjector Settings.txt"

RESET_BACKUPS="0"
echo ":RESET_BACKUPS=0" >> "EternalModInjector Settings.txt"

AskforAutoUpdate
echo ":AUTO_UPDATE=${AUTO_UPDATE}" >> "EternalModInjector Settings.txt"

VERBOSE="0"
echo ":VERBOSE=${VERBOSE}" >> "EternalModInjector Settings.txt"

echo >> "EternalModInjector Settings.txt"

first_time="1"
}

WriteIntoConfig() {
if grep -q ":ASSET_VERSION=" "$CONFIG_FILE"; then
    sed -i "s/:ASSET_VERSION=.*/:ASSET_VERSION=${ASSET_VERSION}/" "EternalModInjector Settings.txt"
else
    echo ":ASSET_VERSION=${ASSET_VERSION}" >> "EternalModInjector Settings.txt"
    echo >> "EternalModInjector Settings.txt"
    sed -i '0,/^[[:space:]]*$/{//d}' "EternalModInjector Settings.txt"
fi

if grep -q ":HAS_CHECKED_RESOURCES=" "$CONFIG_FILE"; then
    sed -i "s/:HAS_CHECKED_RESOURCES=.*/:HAS_CHECKED_RESOURCES=${HAS_CHECKED_RESOURCES}/" "EternalModInjector Settings.txt"
else
    echo ":HAS_CHECKED_RESOURCES=${HAS_CHECKED_RESOURCES}" >> "EternalModInjector Settings.txt"
    echo >> "EternalModInjector Settings.txt"
    sed -i '0,/^[[:space:]]*$/{//d}' "EternalModInjector Settings.txt"
fi

if grep -q ":HAS_READ_FIRST_TIME=" "$CONFIG_FILE"; then
    sed -i "s/:HAS_READ_FIRST_TIME=.*/:HAS_READ_FIRST_TIME=${HAS_READ_FIRST_TIME}/" "EternalModInjector Settings.txt"
else
    echo ":HAS_READ_FIRST_TIME=${HAS_READ_FIRST_TIME}" >> "EternalModInjector Settings.txt"
    echo >> "EternalModInjector Settings.txt"
    sed -i '0,/^[[:space:]]*$/{//d}' "EternalModInjector Settings.txt"
fi

if grep -q ":RESET_BACKUPS=" "$CONFIG_FILE"; then
    sed -i "s/:RESET_BACKUPS=.*/:RESET_BACKUPS=${RESET_BACKUPS}/" "EternalModInjector Settings.txt"
else
    echo ":RESET_BACKUPS=${RESET_BACKUPS}" >> "EternalModInjector Settings.txt"
    echo >> "EternalModInjector Settings.txt"
    sed -i '0,/^[[:space:]]*$/{//d}' "EternalModInjector Settings.txt"
fi

if ! grep -q ":AUTO_UPDATE" "$CONFIG_FILE"; then
    echo ":AUTO_UPDATE=${AUTO_UPDATE}" >> "EternalModInjector Settings.txt"
    echo >> "EternalModInjector Settings.txt"
    sed -i '0,/^[[:space:]]*$/{//d}' "EternalModInjector Settings.txt"
fi

if ! grep -q ":VERBOSE=" "$CONFIG_FILE"; then
    echo ":VERBOSE=0" >> "EternalModInjector Settings.txt"
    echo >> "EternalModInjector Settings.txt"
    sed -i '0,/^[[:space:]]*$/{//d}' "EternalModInjector Settings.txt"
fi
}

ResetBackups() {
printf "\n%s" "${blu}Reset backups now? [y/N] ${end}"
read -r -p '' response
case "$response" in
    [yY][eE][sS]|[yY]) 
        for resource_file_path in "${ResourceFilePaths[@]}"; do
            line="${resource_file_path#*=}"
            line="${line//'"'}"
            if [ -f "${line}.backup" ]; then rm "${line}.backup"; fi
        done

        for snd_file_path in "${SndFilePaths[@]}"; do
            line="${snd_file_path#*=}"
            line="${line//'"'}"
            if [ -f "${line}.backup" ]; then rm "${line}.backup"; fi
        done

        if [ -f "base/packagemapspec.json.backup" ]; then rm "base/packagemapspec.json.backup"; fi
        ;;
    *)
sed -i 's/:RESET_BACKUPS=.*/:RESET_BACKUPS=0/' "EternalModInjector Settings.txt"
printf "\n%s\n\n" "${blu}Backups have not been reset.${end}"
        exit 1
        ;;
esac
}

NoBackupFound() {
printf "\n%s\n\n" "${red}Backup not found for some .resources or .snd files! Verify game files through Steam/Bethesda.net, then open 'EternalModInjector Settings.txt' with a text editor and change RESET_BACKUPS value to 1 and try again.${end}"
exit 1
}

MissingMeta() {
printf "\n%s\n\n" "${red}meta.resources not found or corrupted! Verify game files through Steam/Bethesda.net, then open 'EternalModInjector Settings.txt' with a text editor and change RESET_BACKUPS value to 1, then try again.${end}"
exit 1
}

MissingPackageMapSpec() {
printf "\n%s\n\n" "${red}packagemapspec.json not found or corrupted! Verify game files through Steam/Bethesda.net, then open 'EternalModInjector Settings.txt' with a text editor and change RESET_BACKUPS value to 1, then try again.${end}"
exit 1
}

AskforAutoUpdate() {
printf "\n%s" "${blu}Do you want this script to be automatically updated every time a new version comes out? [Y/n]  ${end}"
read -r -p '' response
case "$response" in
    [nN][oO]|[nN]) 
        AUTO_UPDATE="0"
        ;;
    *)
        AUTO_UPDATE="1"
        ;;
esac
}

SelfUpdate() {
link=$(curl -L -o /dev/null -w '%{url_effective}' https://github.com/leveste/EternalBasher/releases/latest 2> /dev/null)
version=$(basename "$link")
if [ "$version" == "$script_version" ] || [ "$version" == "latest" ]; then OUTDATED="0"; else OUTDATED="1"; fi

if [ "$OUTDATED" == "1" ]; then
    printf "\n%s\n\n" "${blu}Updating script...${end}"
    export skip="1"
    if [ -f EternalModInjectorShell.tar.gz ]; then rm EternalModInjectorShell.tar.gz; fi
    curl -s https://api.github.com/repos/leveste/EternalBasher/releases/latest \
    | grep browser_download_url \
    | grep "EternalModInjectorShell.tar.gz" \
    | cut -d '"' -f 4 \
    | wget -qi -
    if [ -d "tmp" ]; then rm -rf "tmp"; fi
    mkdir "tmp"
    tar -xf "EternalModInjectorShell.tar.gz" --directory "tmp"
    (cp -rf tmp/* .
    rm -rf tmp
    rm EternalModInjectorShell.tar.gz
    chmod +x EternalModInjectorShell.sh
    clear
    ./EternalModInjectorShell.sh)
    exit $?
fi
}

printf "%s\n" "${grn}EternalModInjector Shell Script ${script_version}
By Leveste and PowerBall253
Based on original batch file by Zwip-Zwap Zapony${end}
"

first_time="0"

#Debug mode
if [ "$ETERNALMODINJECTOR_DEBUG" == "1" ] && [ "$skip_debug_check" != "1" ]; then
    printf "%s" "${blu}ETERNALMODINJECTOR_DEBUG variable set to 1. Continue in debug mode? In this mode, full output for all tools will be shown and written to EternalModInjectorShell_log.txt. [y/N] ${end}"
    read -r -p '' response
    case "$response" in
        [yY][eE][sS]|[yY]) 
              export ETERNALMODINJECTOR_DEBUG="1"
              export skip_debug_check="1"
              (if [ -f "EternalModInjectorShell_log.txt" ]; then rm "EternalModInjector_log.txt"; fi
              clear
              ./EternalModInjectorShell.sh 2>&1 | tee "EternalModInjectorShell_log.txt")
              exit $?
          ;;
        *)
     esac
fi

#Log system info
if [ "$skip_debug_check" == "1" ]; then
    if [ -n "$(command -v inxi)" ]; then
        printf "\n%s\n\n" "System info:"
        inxi -Fxz
    fi

    printf "\n%s\n\n" "glibc version:"
    ldd --version
    
    printf "\n%s\n\n" "OpenSSL version:"
    openssl version
fi

#Config File check
printf "\n%s\n\n" "${blu}Loading config file...${end}"
CONFIG_FILE="EternalModInjector Settings.txt"
if ! [ -f "EternalModInjector Settings.txt" ]; then CreateConfigFile; else
    if grep -q ":ASSET_VERSION=5.1" "$CONFIG_FILE"; then ASSET_VERSION="5.1"; else ASSET_VERSION="0"; fi
    if grep -q ":RESET_BACKUPS=1" "$CONFIG_FILE"; then RESET_BACKUPS="1"; else RESET_BACKUPS="0"; fi
    if grep -q ":HAS_READ_FIRST_TIME=1" "$CONFIG_FILE"; then HAS_READ_FIRST_TIME="1"; else HAS_READ_FIRST_TIME="0"; fi
    if grep -q ":HAS_CHECKED_RESOURCES=1" "$CONFIG_FILE"; then HAS_CHECKED_RESOURCES="1"; else HAS_CHECKED_RESOURCES="0"; fi
    if grep -q ":HAS_CHECKED_RESOURCES=2" "$CONFIG_FILE"; then HAS_CHECKED_RESOURCES="1"; fi
    if grep -q ":AUTO_UPDATE" "$CONFIG_FILE"; then
        if grep -q ":AUTO_UPDATE=1" "$CONFIG_FILE"; then AUTO_UPDATE="1"; else AUTO_UPDATE="0"; fi
    else AskforAutoUpdate
    if grep -q ":VERBOSE=1" "$CONFIG_FILE"; then VERBOSE="1"; else VERBOSE="0"; fi
    fi
fi

#Check for script updates
printf "\n%s\n\n" "${blu}Checking for updates...${end}"
if [ "$skip" != "1" ] && [ "$AUTO_UPDATE" == "1" ]; then
    SelfUpdate
    export skip=""
fi

#Assign game hashes to variables
DETERNAL_LOADMODS_MD5="8f6e6bba7f9498011c671936df94fd51"
ETERNALPATCHER_MD5="d6f76416d64599ea8e5867bd13f56381"
IDREHASH_MD5="ce105fa4787a5f922ef56827139f3f13"
DETERNAL_PATCHMANIFEST_MD5="ed45fc6a856093b2434920e8149fe083"
PATCHED_GAME_MD5_A="6980f0cd111fa463921e461ca4209aae"
PATCHED_GAME_MD5_B="067d39d6e3d63db3c2ba6f83aa5b8c67"
VANILLA_GAME_MD5_A="6ae01a116b0683443002f93b7f32ba73"
VANILLA_GAME_MD5_B="0eee313a618a74b1df9a83b983099d23"
VANILLA_META_MD5="08c058e04e753d2f45d335e8799d7194"
VANILLA_PACKAGEMAPSPEC_MD5="3e9db4e4c9e7fbc0dea7c1f8789ace46"

#Check tools' status
printf "\n%s\n\n" "${blu}Checking tools...${end}"

#Verify if tools exist
if ! [ -f DOOMEternalx64vk.exe ]; then MissingGame; fi

if ! [ -f base/DEternal_loadMods ]; then MissingDEternalLoadMods; fi

if ! [ -f base/idRehash ]; then MissingIdRehash; fi

if ! [ -f base/EternalPatcher ]; then MissingEternalPatcher; fi

if ! [ -f base/EternalPatcher.config ]; then
    printf "\n%s\n\n" "${red}EternalPatcher Config file (EternalPatcher.config) not found! Re-extract the file to the 'base' folder and try again.${end}"
    exit 1
fi

if ! [ -f base/liblinoodle.so ]; then 
    printf "\n%s\n\n" "${red}liblinoodle.so not found! Re-extract the file to the 'base' folder and try again.${end}"
    exit 1
fi

if ! [ -f base/DEternal_patchManifest ]; then MissingDEternalPatchManifest; fi

if ! command -v openssl &> /dev/null; then
    printf "\n%s\n\n" "${red}OpenSSL not found! Install OpenSSL using your distro's package manager or install from source, then try again.${end}"
    exit 1
fi

if ! command -v opusdec &> /dev/null; then
    printf "\n%s\n\n" "${red}opusdec not found! Install the opus-tools package from your distro's package manager or install from source, then try again.${end}"
    exit 1
fi

if ! command -v opusenc &> /dev/null; then
    printf "\n%s\n\n" "${red}opusenc not found! Install the opus-tools package from your distro's package manager or install from source, then try again.${end}"
    exit 1
fi

#Check tool hashes
DEternal_LoadModsMD5=$(md5sum "base/DEternal_loadMods" | awk '{ print $1 }')
idRehashMD5=$(md5sum "base/idRehash" | awk '{ print $1 }')
EternalPatcherMD5=$(md5sum "base/EternalPatcher" | awk '{ print $1 }')
DEternal_patchManifestMD5=$(md5sum "base/DEternal_patchManifest" | awk '{ print $1 }')

if [ "$DETERNAL_LOADMODS_MD5" != "$DEternal_LoadModsMD5" ]; then MissingDEternalLoadMods; fi
if [ "$IDREHASH_MD5" != "$idRehashMD5" ]; then MissingIdRehash; fi
if [ "$ETERNALPATCHER_MD5" != "$EternalPatcherMD5" ]; then MissingEternalPatcher; fi
if [ "$DETERNAL_PATCHMANIFEST_MD5" != "$DEternal_patchManifestMD5" ]; then MissingDEternalPatchManifest; fi

#Give executable permissions to the binaries
chmod +x base/EternalPatcher
chmod +x base/DEternal_loadMods
chmod +x base/idRehash
chmod +x base/DEternal_patchManifest

ResourceFilePaths=(
'gameresources_patch2_path="./base/gameresources_patch2.resources"'
'pvp_laser_patch1_path="./base/game/pvp/pvp_laser/pvp_laser_patch1.resources"'
'pvp_laser_path="./base/game/pvp/pvp_laser/pvp_laser.resources"'
'pvp_deathvalley_path="./base/game/pvp/pvp_deathvalley/pvp_deathvalley.resources"'
'pvp_deathvalley_patch1_path="./base/game/pvp/pvp_deathvalley/pvp_deathvalley_patch1.resources"'
'pvp_inferno_path="./base/game/pvp/pvp_inferno/pvp_inferno.resources"'
'pvp_inferno_patch1_path="./base/game/pvp/pvp_inferno/pvp_inferno_patch1.resources"'
'pvp_bronco_patch1_path="./base/game/pvp/pvp_bronco/pvp_bronco_patch1.resources"'
'pvp_bronco_path="./base/game/pvp/pvp_bronco/pvp_bronco.resources"'
'pvp_thunder_path="./base/game/pvp/pvp_thunder/pvp_thunder.resources"'
'pvp_thunder_patch1_path="./base/game/pvp/pvp_thunder/pvp_thunder_patch1.resources"'
'pvp_shrapnel_patch1_path="./base/game/pvp/pvp_shrapnel/pvp_shrapnel_patch1.resources"'
'pvp_shrapnel_path="./base/game/pvp/pvp_shrapnel/pvp_shrapnel.resources"'
'pvp_zap_path="./base/game/pvp/pvp_zap/pvp_zap.resources"'
'pvp_zap_patch1_path="./base/game/pvp/pvp_zap/pvp_zap_patch1.resources"'
'tutorial_sp_path="./base/game/tutorials/tutorial_sp.resources"'
'tutorial_pvp_laser_path="./base/game/tutorials/tutorial_pvp_laser/tutorial_pvp_laser.resources"'
'tutorial_pvp_laser_patch1_path="./base/game/tutorials/tutorial_pvp_laser/tutorial_pvp_laser_patch1.resources"'
'tutorial_demons_path="./base/game/tutorials/tutorial_demons.resources"'
'hub_patch1_path="./base/game/hub/hub_patch1.resources"'
'hub_path="./base/game/hub/hub.resources"'
'hub_patch2_path="./base/game/hub/hub_patch2.resources"'
'e4m1_rig_patch1_path="./base/game/dlc/e4m1_rig/e4m1_rig_patch1.resources"'
'e4m1_rig_path="./base/game/dlc/e4m1_rig/e4m1_rig.resources"'
'e4m1_rig_patch2_path="./base/game/dlc/e4m1_rig/e4m1_rig_patch2.resources"'
'dlc_hub_patch1_path="./base/game/dlc/hub/hub_patch1.resources"'
'dlc_hub_path="./base/game/dlc/hub/hub.resources"'
'e4m2_swamp_patch1_path="./base/game/dlc/e4m2_swamp/e4m2_swamp_patch1.resources"'
'e4m2_swamp_patch2_path="./base/game/dlc/e4m2_swamp/e4m2_swamp_patch2.resources"'
'e4m2_swamp_path="./base/game/dlc/e4m2_swamp/e4m2_swamp.resources"'
'e4m3_mcity_patch2_path="./base/game/dlc/e4m3_mcity/e4m3_mcity_patch2.resources"'
'e4m3_mcity_patch1_path="./base/game/dlc/e4m3_mcity/e4m3_mcity_patch1.resources"'
'e4m3_mcity_path="./base/game/dlc/e4m3_mcity/e4m3_mcity.resources"'
'e5m2_earth_path="./base/game/dlc2/e5m2_earth/e5m2_earth.resources"'
'e5m2_earth_patch1_path="./base/game/dlc2/e5m2_earth/e5m2_earth_patch1.resources"'
'e5m4_boss_patch1_path="./base/game/dlc2/e5m4_boss/e5m4_boss_patch1.resources"'
'e5m4_boss_path="./base/game/dlc2/e5m4_boss/e5m4_boss.resources"'
'e5m3_hell_path="./base/game/dlc2/e5m3_hell/e5m3_hell.resources"'
'e5m3_hell_patch1_path="./base/game/dlc2/e5m3_hell/e5m3_hell_patch1.resources"'
'e5m1_spear_path="./base/game/dlc2/e5m1_spear/e5m1_spear.resources"'
'e5m1_spear_patch1_path="./base/game/dlc2/e5m1_spear/e5m1_spear_patch1.resources"'
'e3m2_hell_patch2_path="./base/game/sp/e3m2_hell/e3m2_hell_patch2.resources"'
'e3m2_hell_path="./base/game/sp/e3m2_hell/e3m2_hell.resources"'
'e3m2_hell_patch1_path="./base/game/sp/e3m2_hell/e3m2_hell_patch1.resources"'
'e3m1_slayer_patch1_path="./base/game/sp/e3m1_slayer/e3m1_slayer_patch1.resources"'
'e3m1_slayer_patch2_path="./base/game/sp/e3m1_slayer/e3m1_slayer_patch2.resources"'
'e3m1_slayer_path="./base/game/sp/e3m1_slayer/e3m1_slayer.resources"'
'e1m2_battle_path="./base/game/sp/e1m2_battle/e1m2_battle.resources"'
'e1m2_battle_patch1_path="./base/game/sp/e1m2_battle/e1m2_battle_patch1.resources"'
'e1m2_battle_patch2_path="./base/game/sp/e1m2_battle/e1m2_battle_patch2.resources"'
'e3m2_hell_b_path="./base/game/sp/e3m2_hell_b/e3m2_hell_b.resources"'
'e3m2_hell_b_patch1_path="./base/game/sp/e3m2_hell_b/e3m2_hell_b_patch1.resources"'
'e3m2_hell_b_patch2_path="./base/game/sp/e3m2_hell_b/e3m2_hell_b_patch2.resources"'
'e1m1_intro_patch2_path="./base/game/sp/e1m1_intro/e1m1_intro_patch2.resources"'
'e1m1_intro_patch3_path="./base/game/sp/e1m1_intro/e1m1_intro_patch3.resources"'
'e1m1_intro_patch1_path="./base/game/sp/e1m1_intro/e1m1_intro_patch1.resources"'
'e1m1_intro_path="./base/game/sp/e1m1_intro/e1m1_intro.resources"'
'e3m3_maykr_patch2_path="./base/game/sp/e3m3_maykr/e3m3_maykr_patch2.resources"'
'e3m3_maykr_path="./base/game/sp/e3m3_maykr/e3m3_maykr.resources"'
'e3m3_maykr_patch1_path="./base/game/sp/e3m3_maykr/e3m3_maykr_patch1.resources"'
'e2m2_base_patch2_path="./base/game/sp/e2m2_base/e2m2_base_patch2.resources"'
'e2m2_base_patch1_path="./base/game/sp/e2m2_base/e2m2_base_patch1.resources"'
'e2m2_base_path="./base/game/sp/e2m2_base/e2m2_base.resources"'
'e2m1_nest_patch1_path="./base/game/sp/e2m1_nest/e2m1_nest_patch1.resources"'
'e2m1_nest_path="./base/game/sp/e2m1_nest/e2m1_nest.resources"'
'e2m1_nest_patch2_path="./base/game/sp/e2m1_nest/e2m1_nest_patch2.resources"'
'e3m4_boss_patch1_path="./base/game/sp/e3m4_boss/e3m4_boss_patch1.resources"'
'e3m4_boss_path="./base/game/sp/e3m4_boss/e3m4_boss.resources"'
'e3m4_boss_patch2_path="./base/game/sp/e3m4_boss/e3m4_boss_patch2.resources"'
'e3m4_boss_patch3_path="./base/game/sp/e3m4_boss/e3m4_boss_patch3.resources"'
'e2m4_boss_patch1_path="./base/game/sp/e2m4_boss/e2m4_boss_patch1.resources"'
'e2m4_boss_patch2_path="./base/game/sp/e2m4_boss/e2m4_boss_patch2.resources"'
'e2m4_boss_path="./base/game/sp/e2m4_boss/e2m4_boss.resources"'
'e1m4_boss_path="./base/game/sp/e1m4_boss/e1m4_boss.resources"'
'e1m4_boss_patch2_path="./base/game/sp/e1m4_boss/e1m4_boss_patch2.resources"'
'e1m4_boss_patch1_path="./base/game/sp/e1m4_boss/e1m4_boss_patch1.resources"'
'e2m3_core_patch1_path="./base/game/sp/e2m3_core/e2m3_core_patch1.resources"'
'e2m3_core_patch3_path="./base/game/sp/e2m3_core/e2m3_core_patch3.resources"'
'e2m3_core_patch2_path="./base/game/sp/e2m3_core/e2m3_core_patch2.resources"'
'e2m3_core_path="./base/game/sp/e2m3_core/e2m3_core.resources"'
'e1m3_cult_patch3_path="./base/game/sp/e1m3_cult/e1m3_cult_patch3.resources"'
'e1m3_cult_patch1_path="./base/game/sp/e1m3_cult/e1m3_cult_patch1.resources"'
'e1m3_cult_patch2_path="./base/game/sp/e1m3_cult/e1m3_cult_patch2.resources"'
'e1m3_cult_path="./base/game/sp/e1m3_cult/e1m3_cult.resources"'
'shell_patch1_path="./base/game/shell/shell_patch1.resources"'
'shell_path="./base/game/shell/shell.resources"'
'warehouse_path="./base/warehouse.resources"'
'meta_path="./base/meta.resources"'
'gameresources_path="./base/gameresources.resources"'
'gameresources_patch1_path="./base/gameresources_patch1.resources"'
)

SndFilePaths=(
'vo_Polish_patch_1_path="./base/sound/soundbanks/pc/vo_Polish_patch_1.snd"'
'vo_Italian_patch_1_path="./base/sound/soundbanks/pc/vo_Italian_patch_1.snd"'
'vo_French_France__patch_1_path="./base/sound/soundbanks/pc/vo_French(France)_patch_1.snd"'
'vo_Japanese_patch_1_path="./base/sound/soundbanks/pc/vo_Japanese_patch_1.snd"'
'vo_Polish_path="./base/sound/soundbanks/pc/vo_Polish.snd"'
'vo_German_path="./base/sound/soundbanks/pc/vo_German.snd"'
'vo_Spanish_Mexico__patch_1_path="./base/sound/soundbanks/pc/vo_Spanish(Mexico)_patch_1.snd"'
'sfx_path="./base/sound/soundbanks/pc/sfx.snd"'
'music_patch_1_path="./base/sound/soundbanks/pc/music_patch_1.snd"'
'vo_English_US__path="./base/sound/soundbanks/pc/vo_English(US).snd"'
'vo_Spanish_Spain__patch_1_path="./base/sound/soundbanks/pc/vo_Spanish(Spain)_patch_1.snd"'
'sfx_patch_3_path="./base/sound/soundbanks/pc/sfx_patch_3.snd"'
'sfx_patch_2_path="./base/sound/soundbanks/pc/sfx_patch_2.snd"'
'vo_Russian_path="./base/sound/soundbanks/pc/vo_Russian.snd"'
'vo_Spanish_Spain__path="./base/sound/soundbanks/pc/vo_Spanish(Spain).snd"'
'vo_Italian_path="./base/sound/soundbanks/pc/vo_Italian.snd"'
'vo_Portuguese_Brazil__patch_1_path="./base/sound/soundbanks/pc/vo_Portuguese(Brazil)_patch_1.snd"'
'vo_Russian_patch_1_path="./base/sound/soundbanks/pc/vo_Russian_patch_1.snd"'
'vo_English_US__patch_1_path="./base/sound/soundbanks/pc/vo_English(US)_patch_1.snd"'
'vo_Portuguese_Brazil__path="./base/sound/soundbanks/pc/vo_Portuguese(Brazil).snd"'
'vo_Spanish_Mexico__path="./base/sound/soundbanks/pc/vo_Spanish(Mexico).snd"'
'vo_French_France__path="./base/sound/soundbanks/pc/vo_French(France).snd"'
'music_path="./base/sound/soundbanks/pc/music.snd"'
'vo_German_patch_1_path="./base/sound/soundbanks/pc/vo_German_patch_1.snd"'
'sfx_patch_1_path="./base/sound/soundbanks/pc/sfx_patch_1.snd"'
'vo_Japanese_path="./base/sound/soundbanks/pc/vo_Japanese.snd"'
)

#Check for Asset Version
if [ "$ASSET_VERSION" == "0" ]; then

    printf "\n%s" "${blu}Old Doom Eternal backups detected! Make sure the game is updated to the latest version, then verify the game files through Steam/Bethesda.net then run this batch again to reset your backups.
If you have already done so, press Enter to continue: ${blu}"
    read -r -p ''
    ResetBackups
    ASSET_VERSION="5.1"
    HAS_CHECKED_RESOURCES="0"
    RESET_BACKUPS="1"
    skip_resetbackups="1"
fi

#Setup for ModLoader
if [ "$HAS_READ_FIRST_TIME" == "0" ]; then
    printf "%s" "${blu}First-time information:

This batch file automatically...
- Makes backups of DOOM Eternal .resources archives the first time that they will be modified.
- Restores ones that were modified last time (to prevent uninstalled mods from lingering around) on subsequent uses.
- Runs DEternal_loadMods to load all mods in -/DOOMEternal/Mods/.
- Runs idRehash to rehash the modified resources hashes.
- Runs EternalPatcher to apply EXE patches to the DOOM Eternal game executable.

Press any key to continue...${end}"
    read -r -p ''
    echo
	
    printf "%s" "${blu}We take no credit for the tools used in the mod loading, credits go to:
DEternal_loadMods: SutandoTsukai181 for making it in Python (based on a QuickBMS-based unpacker made for Wolfenstein II: The New Colossus by aluigi and edited for DOOM Eternal by one of infograms friends), proteh for remaking it in C#, and PowerBall253 for rewriting it in C for Linux.
EternalPatcher: proteh for making it (based on EXE patches made by infogram that were based on Cheat Engine patches made by SunBeam, as well as based on EXE patches made by Visual Studio) and PowerBall253 for rewriting it in C for Linux.
idRehash: infogram for making it, proteh for updating it, and PowerBall253 for rewriting it in C for Linux.
DEternal_patchManifest: Visual Studio and SutandoTsukai181 for making it on Python, and PowerBall253 for rewriting it in C for Linux.
DOOM Eternal: Bethesda Softworks, id Software, and everyone else involved, for making and updating it.

Press any key to continue...${end}"
    read -r -p ''
    echo

    printf "%s" "${blu}If any mods are currently installed and/or you have some outdated files when EternalModInjector makes .resources backups, the subsequent backups will contain those mods and/or be outdated.
Dont worry, though; If you ever mess up in a way that results in an already-modified/outdated backup, simply verify/repair DOOM Eternal installation through Steam or the Bethesda.net Launcher, open EternalModInjector Settings.txt in Notepad, change the :RESET_BACKUPS=0 line to :RESET_BACKUPS=1, and save the file.

Press any key to continue...${end}"
    read -r -p ''
    echo

printf "%s" "${blu}Now, without further ado, press any key to continue one last time, and this batch file will initiate mod-loading mode.

Press any key to continue...${end}"
    read -r -p ''
HAS_READ_FIRST_TIME="1"
fi

if [ "$RESET_BACKUPS" == "1" ] && [ "$skip_resetbackups" != "1" ]; then
    ResetBackups
    printf "\n%s" "${blu}Press enter to continue with mod loading: ${end}"
    read -r -p ''
    HAS_CHECKED_RESOURCES="0"
fi

#Patch Game Executable
GameMD5=$(md5sum "DOOMEternalx64vk.exe" | awk '{ print $1 }')

if [ "$VANILLA_GAME_MD5_A" != "$GameMD5" ] && [ "$VANILLA_GAME_MD5_B" != "$GameMD5" ] && [ "$PATCHED_GAME_MD5_A" != "$GameMD5" ] && [ "$PATCHED_GAME_MD5_B" != "$GameMD5" ]; then CorruptedGameExecutable; fi

if [ "$VANILLA_GAME_MD5_A" == "$GameMD5" ] || [ "$VANILLA_GAME_MD5_B" == "$GameMD5" ]; then
    printf "\n%s\n\n" "${blu}Patching game executable...${end}"
    (cd base || return
    if [ -f "EternalPatcher.def" ]; then cp EternalPatcher.def EternalPatcher.def.bck; fi
    if [ "$ETERNALMODINJECTOR_DEBUG" == "1" ]; then ETERNALPATCHER_NO_COLORS=1 ./EternalPatcher --update; else ./EternalPatcher --update > /dev/null; fi
    if [ "$?" != "0" ] && [ -f "EternalPatcher.def.bck" ]; then cp EternalPatcher.def.bck EternalPatcher.def; fi
    if [ "$ETERNALMODINJECTOR_DEBUG" == "1" ]; then ETERNALPATCHER_NO_COLORS=1 ./EternalPatcher --patch "../DOOMEternalx64vk.exe"; else ./EternalPatcher --patch "../DOOMEternalx64vk.exe" > /dev/null; fi)

    if [ "$?" != "0" ]; then
        printf "\n%s\n\n" "${red}EternalPatcher has failed! Verify game files through Steam/Bethesda.net, then open 'EternalModInjector Settings.txt' with a text editor and change RESET_BACKUPS value to 1, then try again.${end}"
        exit 1
    fi
fi

GameMD5=$(md5sum "DOOMEternalx64vk.exe" | awk '{ print $1 }')
if [ "$PATCHED_GAME_MD5_A" != "$GameMD5" ] && [ "$PATCHED_GAME_MD5_B" != "$GameMD5" ]; then
    printf "\n%s\n\n" "${red}Game patching failed! Verify the game executable isn't being used by any program, such as Steam, Bethesda.net, or DOOM Eternal itself, then try again.${end}"
    exit 1
fi

#Check for all .resources and .snd files
printf "\n%s\n\n" "${blu}Checking resources files...${end}"
if [ "$HAS_CHECKED_RESOURCES" == "0" ]; then

for resource_file_path in "${ResourceFilePaths[@]}"; do
    line="${resource_file_path#*=}"
    line="${line//'"'}"
    if ! [ -f "$line" ]; then
        printf "\n%s\n\n" "${red}Some .resources files are missing! Verify game files through Steam/Bethesda.net, then try again.${end}"
        exit 1
    fi
done

for snd_file_path in "${SndFilePaths[@]}"; do
    line="${snd_file_path#*=}"
    line="${line//'"'}"
    if ! [ -f "$line" ]; then
        printf "\n%s\n\n" "${red}Some .snd files are missing! Verify game files through Steam/Bethesda.net, then try again.${end}"
        exit 1
    fi
done

fi

#Execute each line of ResourceFilePaths
for resource_file_path in "${ResourceFilePaths[@]}"; do
    eval "$resource_file_path"
done

#Execute each line of SndFilePaths
for snd_file_path in "${SndFilePaths[@]}"; do
    eval "$snd_file_path"
done

#Restore Backups
if [ "$RESET_BACKUPS" != "1" ] && [ "$first_time" != "1" ]; then
printf "\n%s\n\n" "${blu}Restoring backups...${end}"
while IFS= read -r filename; do
    if [[ "$filename" == *.resources ]] || [[ "$filename" == *.resources* ]]; then
        filename=${filename//[[:cntrl:]]/}
        filename_name=${filename%.resources*}
        path=${filename_name}_path
        path=${!path}
        if [[ "$filename" != dlc_* ]]; then
            printf "\n\t\t%s\n\n" "${blu}Restoring ${filename_name}.resources.backup...${end}"
            if ! [ -f "$path" ]; then NoBackupFound; fi
            cp "${path}.backup" "$path"
        else
            printf "\n\t\t%s\n\n" "${blu}Restoring dlc_${filename_name}.resources.backup...${end}"
            if ! [ -f "$path" ]; then NoBackupFound; fi
            cp "${path}.backup" "$path"

        fi		
    fi

    if [[ "$filename" == *.snd ]] || [[ "$filename" == *.snd* ]]; then
        filename=${filename//[[:cntrl:]]/}
        filename_name=${filename%.snd*}
        filename_name=${filename_name//'('/_}
        filename_name=${filename_name//')'/_}
        path=${filename_name}_path
        path=${!path}

        printf "\n\t\t%s\n\n" "${blu}Restoring ${filename_name}.snd.backup...${end}"
        if ! [ -f "$path" ]; then NoBackupFound; fi
        cp "${path}.backup" "$path"
    fi	
done < "EternalModInjector Settings.txt"

printf "\n\t\t%s\n\n" "${blu}Restoring packagemapspec.json.backup...${end}"
if ! [ -f "base/packagemapspec.json.backup" ]; then NoBackupFound; fi
cp "base/packagemapspec.json.backup" "base/packagemapspec.json"

fi

RESET_BACKUPS="0"

#Check meta.resources
printf "\n%s\n\n" "${blu}Checking meta.resources...${end}"
if [ "$HAS_CHECKED_RESOURCES" == "0" ]; then
    if ! [ -f "base/meta.resources" ]; then MissingMeta; fi
    MetaMD5=$(md5sum "base/meta.resources" | awk '{ print $1 }')
    if [ "$VANILLA_META_MD5" != "$MetaMD5" ]; then MissingMeta; fi
fi

#Check packagemapspec.json
printf "\n%s\n\n" "${blu}Checking packagemapspec.json...${end}"
if [ "$HAS_CHECKED_RESOURCES" == "0" ]; then
    if ! [ -f "base/packagemapspec.json" ]; then MissingPackageMapSpec; fi
    PackageMapSpecMD5=$(md5sum "base/packagemapspec.json" | awk '{ print $1 }')
    if [ "$VANILLA_PACKAGEMAPSPEC_MD5" != "$PackageMapSpecMD5" ]; then MissingPackageMapSpec; fi
fi

#Set new values in config file
if [ "$HAS_CHECKED_RESOURCES" == "0" ]; then
    HAS_CHECKED_RESOURCES="1"
    WriteIntoConfig
    HAS_CHECKED_RESOURCES="0"
else
    WriteIntoConfig
fi

#Check if there are mods in "mods" folder
if ! [ -d "Mods" ] || [ -z "$(ls -A "Mods")" ]; then
    printf "\n%s\n\n" "${grn}No mods found! All .resources files have been restored to their vanilla state.${end}"
    sed -i "s/:HAS_CHECKED_RESOURCES=.*/:HAS_CHECKED_RESOURCES=0/" "EternalModInjector Settings.txt"
    exit 1
fi

#Backup .resources
printf "\n%s\n\n" "${blu}Backing up .resources...${end}"
sed -i '/.resources$/d' "EternalModInjector Settings.txt"
sed -i '/.snd$/d' "EternalModInjector Settings.txt"
sed -i '/.backup$/d' "EternalModInjector Settings.txt"
IFS=$'\n' read -r -d '' -a modloaderlist < <( base/DEternal_loadMods "." --list-res )
for (( i = 0; i < ${#modloaderlist[@]}; i++ )); do
    if [ "${modloaderlist[$i]}" == "" ]; then 
            printf "\n%s\n\n" "${grn}No mods found! All .resources files have been restored to their vanilla state.${end}"
        break
    fi
    filename="${modloaderlist[$i]#*=}"
    filename="${filename/$'\r'/}"
    if ! [ -f "${filename}.backup" ]; then
        cp "$filename" "${filename}.backup"
        name=${filename##*/}
        printf "\n\t\t%s\n\n" "${blu}Backed up $name${end}"
    else
        name=${filename##*/}
    fi

    extension="${name##*.}"
    filename="${name%.*}"
    echo "${filename}.backup" >> "EternalModInjector Settings.txt"
    if [ "$extension" == "resources" ]; then echo "${filename}.resources" >> "EternalModInjector Settings.txt"; fi
    if [ "$extension" == "snd" ]; then echo "${filename}.snd" >> "EternalModInjector Settings.txt"; fi
done

#Backup meta.resources and add to the list
if ! [ -f "base/meta.resources.backup" ]; then 
    cp "base/meta.resources" "base/meta.resources.backup"
    printf "\n\t\t%s\n\n" "${blu}Backed up meta.resources${end}"
fi
sed -i '/meta.backup$/d' "EternalModInjector Settings.txt"
echo meta.backup >> "EternalModInjector Settings.txt"
echo meta.resources >> "EternalModInjector Settings.txt"

#Backup packagemapspec.json
if ! [ -f "base/packagemapspec.json.backup" ]; then 
    cp "base/packagemapspec.json" "base/packagemapspec.json.backup"
    printf "\n\t\t%s\n\n" "${blu}Backed up packagemapspec.json${end}"
fi


#Get vanilla resource hash offsets (idRehash)
if [ "$HAS_CHECKED_RESOURCES" == "0" ]; then
    printf "\n%s\n\n" "${blu}Getting vanilla resource hash offsets... (idRehash)${end}"
    (cd base || return
    if [ "$ETERNALMODINJECTOR_DEBUG" == "1" ]; then ./idRehash --getoffsets; else ./idRehash --getoffsets > /dev/null; fi)
    
    if [ "$?" != "0" ]; then
    printf "\n%s\n\n" "${red}idRehash has failed! Verify game files through Steam/Bethesda.net, then open 'EternalModInjector Settings.txt' with a text editor and change RESET_BACKUPS value to 1, then try again.${end}"
    exit 1
    fi

    HAS_CHECKED_RESOURCES="1"
fi

#Load Mods (DEternal_loadMods)
printf "%s\n" "
${blu}Loading mods... (DEternal_loadMods)${end}
"

if [ "$VERBOSE" = "1" ]; then modloader_arguments=". --verbose"; else modloader_arguments="."; fi

if [ "$ETERNALMODINJECTOR_DEBUG" == "1" ]; then ETERNALMODLOADER_NO_COLORS=1 ./base/DEternal_loadMods ${modloader_arguments}; else ./base/DEternal_loadMods ${modloader_arguments}; fi

if [ "$?" != "0" ]; then
    printf "\n%s\n\n" "${red}DEternal_loadMods has failed! Verify game files through Steam/Bethesda.net, then open 'EternalModInjector Settings.txt' with a text editor and change RESET_BACKUPS value to 1, then try again.${end}"
    exit 1
fi

#Rehash resource hashes (idRehash)
printf "\n%s\n\n" "${blu}Rehashing resource offsets... (idRehash)${end}"
(cd base || return
if [ "$ETERNALMODINJECTOR_DEBUG" == "1" ]; then ./idRehash; else ./idRehash > /dev/null; fi)

if [ "$?" != "0" ]; then
    printf "\n%s\n\n" "${red}idRehash has failed! Verify game files through Steam/Bethesda.net, then open 'EternalModInjector Settings.txt' with a text editor and change RESET_BACKUPS value to 1, then try again.${end}"
    exit 1
fi

#Patch build manifest
printf "\n%s\n\n" "${blu}Patching build manifest... (DEternal_patchManifest)${end}"
(cd base || return
if [ "$ETERNALMODINJECTOR_DEBUG" == "1" ]; then ./DEternal_patchManifest 8B031F6A24C5C4F3950130C57EF660E9; else ./DEternal_patchManifest 8B031F6A24C5C4F3950130C57EF660E9 > /dev/null; fi)

if [ "$?" != "0" ]; then
    printf "\n%s\n\n" "${red}DEternal_patchManifest has failed! Verify game files through Steam/Bethesda.net, then open 'EternalModInjector Settings.txt' with a text editor and change RESET_BACKUPS value to 1, then try again.${end}"
    exit 1
fi

printf "\n%s\n\n" "${grn}Mods have been loaded! You can now launch the game.${end}"
exit 0