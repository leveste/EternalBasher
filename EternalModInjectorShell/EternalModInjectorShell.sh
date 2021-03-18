#!/usr/bin/env bash

#Script version
script_version="v5.0.1"

#Colors
if [ "$skip_debug_check" != "1" ]; then red=$'\e[1;31m'; fi
if [ "$skip_debug_check" != "1" ]; then grn=$'\e[1;32m'; fi
if [ "$skip_debug_check" != "1" ]; then blu=$'\e[1;34m'; fi
if [ "$skip_debug_check" != "1" ]; then end=$'\e[0m'; fi

#Functions
MissingGame() {
printf "%s\n" "
${red}Game Executable not found! Make sure you put this shell script in the DOOMEternal folder and try again.${end}
"
exit 1
}

MissingDEternalLoadMods() {
printf "%s\n" "
${red}DEternal_loadMods not found or corrupted! Re-extract the tool to the 'base' folder and try again.${end}
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
${red}EternalPatcher not found or corrupted! Re-extract the tool to the 'base' folder and try again.${end}
"
exit 1
}

MissingDEternalPatchManifest() {
printf "%s\n" "
${red}DEternal_patchManifest not found or corrupted! Re-extract the tool to the 'base' folder and try again.${end}
"
exit 1
}

CreateConfigFile() {
ASSET_VERSION="5.0"
echo ":ASSET_VERSION=5.0" >> "EternalModInjector Settings.txt"

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

echo >> "EternalModInjector Settings.txt"

find . -name "*.backup" -type f -delete

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
}

ResetBackups() {
read -r -p $'\e[34mReset backups now? [y/N] \e[0m' response
case "$response" in
    [yY][eE][sS]|[yY]) 
            for (( i = 0; i < ${#ResourceFilePaths[@]} ; i++ )); do
            line="${ResourceFilePaths[$i]#*=}"
            if [ -f "${line}.backup" ]; then rm "${line}.backup"; fi
        done
        ;;
    *)
sed -i 's/:RESET_BACKUPS=.*/:RESET_BACKUPS=0/' "EternalModInjector Settings.txt"
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

AskforAutoUpdate() {
read -r -p $'\e[34mDo you want this script to be automatically updated every time a new version comes out? [Y/n] \e[0m' response
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
link=$(curl -L -o /dev/null -w '%{url_effective}' https://github.com/leveste/EternalBasher/releases/latest)
version=$(basename "$link")
if [ "$version" == "$script_version" ] || [ "$version" == "latest" ]; then OUTDATED="0"; else OUTDATED="1"; fi

if [ "$OUTDATED" == "1" ]; then
    printf "%s\n" "
${blu}Updating script...${end}
"
    export skip="1"
    if [ -f EternalModInjectorShell.tar.gz ]; then rm EternalModInjectorShell.tar.gz; fi
    curl -s https://api.github.com/repos/leveste/EternalBasher/releases/latest \
    | grep browser_download_url \
    | grep "EternalModInjectorShell.tar.gz" \
    | cut -d '"' -f 4 \
    | wget -qi -
    if [ -d "tmp" ]; then
        rm -r "tmp"
    mkdir "tmp"
    else mkdir "tmp"; fi
    tar -xf "EternalModInjectorShell.tar.gz" --directory "tmp"
    (\cp -r -f tmp/* .
    rm -r tmp
    rm EternalModInjectorShell.tar.gz
    chmod +x EternalModInjectorShell.sh
    clear
    ./EternalModInjectorShell.sh)
    exit $?
fi
}

printf "%s\n" "${grn}EternalModInjector Shell Script
By Leveste and PowerBall253
Based on original batch file by Zwip-Zwap Zapony${end}
"

first_time="0"

#Debug mode
if [ "$ETERNALMODINJECTOR_DEBUG" == "1" ] && [ "$skip_debug_check" != "1" ]; then
    read -r -p $'\e[34mETERNALMODINJECTOR_DEBUG variable set to 1. Continue in debug mode? In this mode, full output for all tools will be shown and written to EternalModInjectorShell_log.txt. [y/N] \e[0m' response
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
        printf "%s\n" "
System info:
"
        inxi -Fxz
    fi

    printf "%s\n" "
glibc version:
"
    ldd --version
fi

#Config File check
printf "%s\n" "
${blu}Loading config file...${end}
"
CONFIG_FILE="EternalModInjector Settings.txt"
if ! [ -f "EternalModInjector Settings.txt" ]; then CreateConfigFile; else
    if grep -q ":ASSET_VERSION=5.0" "$CONFIG_FILE"; then ASSET_VERSION="5.0"; else ASSET_VERSION="0"; fi
    if grep -q ":RESET_BACKUPS=1" "$CONFIG_FILE"; then RESET_BACKUPS="1"; else RESET_BACKUPS="0"; fi
    if grep -q ":HAS_READ_FIRST_TIME=1" "$CONFIG_FILE"; then HAS_READ_FIRST_TIME="1"; else HAS_READ_FIRST_TIME="0"; fi
    if grep -q ":HAS_CHECKED_RESOURCES=1" "$CONFIG_FILE"; then HAS_CHECKED_RESOURCES="1"; else HAS_CHECKED_RESOURCES="0"; fi
    if grep -q ":HAS_CHECKED_RESOURCES=2" "$CONFIG_FILE"; then HAS_CHECKED_RESOURCES="1"; fi
    if grep -q ":AUTO_UPDATE" "$CONFIG_FILE"; then
        if grep -q ":AUTO_UPDATE=1" "$CONFIG_FILE"; then AUTO_UPDATE="1"; else AUTO_UPDATE="0"; fi
    else AskforAutoUpdate
    fi
fi

#Check for script updates
if [ "$skip" != "1" ] && [ "$AUTO_UPDATE" == "1" ]; then
    SelfUpdate
    export skip=""
fi

#Verify if tools exist
if ! [ -f DOOMEternalx64vk.exe ]; then MissingGame; fi

if ! [ -f base/DEternal_loadMods ]; then MissingDEternalLoadMods; fi

if ! [ -f base/idRehash ]; then MissingIdRehash; fi

if ! [ -f base/EternalPatcher ]; then MissingEternalPatcher; fi

if ! [ -f base/EternalPatcher.config ]; then
    printf "%s\n" "
${red}EternalPatcher Config file (EternalPatcher.config) not found! Re-extract the file to the 'base' folder and try again.${end}
"
fi

if ! [ -f base/liblinoodle.so ]; then 
    printf "%s\n" "
${red}liblinoodle.so not found! Re-extract the file to the 'base' folder and try again.${end}
"
fi

if ! [ -f base/DEternal_patchManifest ]; then MissingDEternalPatchManifest; fi

#Give executable permissions to the binaries
chmod +x base/EternalPatcher
chmod +x base/DEternal_loadMods
chmod +x base/idRehash
chmod +x base/DEternal_patchManifest

#Assign game hashes to variables
ASSET_VERSION="5.0"
DETERNAL_LOADMODS_MD5="59c7b430714fde0b954ac7c68a4ce64b"
ETERNALPATCHER_MD5="df04bd35aa8cbd071a2cb6fc81891f05"
IDREHASH_MD5="0e2925626c9923d63f1275b6776ea6b1"
DETERNAL_PATCHMANIFEST_MD5="76214a4d5f73aa8c96ba3713f71296bf"
PATCHED_GAME_MD5_A="6f295c4e8ca29d4054dae59b0f3fe3cb"
PATCHED_GAME_MD5_B="ff3e7af75e8a38165fc69e5302a7a6fc"
VANILLA_GAME_MD5_A="96556f8b0dfc56111090a6b663969b86"
VANILLA_GAME_MD5_B="b4eef9284826e5ffaedbcd73fe6d2ae6"
VANILLA_META_MD5="4f4deb1df8761dc8fd2d3b25a12d8d91"

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
e5m1_spear_path="./base/game/dlc2/e5m1_spear/e5m1_spear.resources"
e5m2_earth_path="./base/game/dlc2/e5m2_earth/e5m2_earth.resources"
e5m3_hell_path="./base/game/dlc2/e5m3_hell/e5m3_hell.resources"
e5m4_boss_path="./base/game/dlc2/e5m4_boss/e5m4_boss.resources"
)

#Verify tool hashes
printf "%s\n" "
${blu}Checking tools...${end}
"

DEternal_LoadModsMD5=$(md5sum "base/DEternal_loadMods" | awk '{ print $1 }')
idRehashMD5=$(md5sum "base/idRehash" | awk '{ print $1 }')
EternalPatcherMD5=$(md5sum "base/EternalPatcher" | awk '{ print $1 }')
DEternal_patchManifestMD5=$(md5sum "base/DEternal_patchManifest" | awk '{ print $1 }')

if [ "$DETERNAL_LOADMODS_MD5" != "$DEternal_LoadModsMD5" ]; then MissingDEternalLoadMods; fi
if [ "$IDREHASH_MD5" != "$idRehashMD5" ]; then MissingIdRehash; fi
if [ "$ETERNALPATCHER_MD5" != "$EternalPatcherMD5" ]; then MissingEternalPatcher; fi
if [ "$DETERNAL_PATCHMANIFEST_MD5" != "$DEternal_patchManifestMD5" ]; then MissingDEternalPatchManifest; fi

#Delete old tools
if [ -f base/EternalPatcher.exe ]; then rm base/EternalPatcher.exe; fi
if [ -f base/EternalPatcher.exe.config ]; then rm base/EternalPatcher.exe.config; fi
if [ -f base/DEternal_loadMods.exe ]; then rm base/DEternal_loadMods.exe; fi
if [ -f base/idRehash.exe ]; then rm base/idRehash.exe; fi
if [ -f base/DEternal_patchManifest.py ]; then rm base/DEternal_patchManifest.py; fi

if [ -f EternalPatcher.exe ]; then rm EternalPatcher.exe; fi
if [ -f EternalPatcher.exe.config ]; then rm EternalPatcher.exe.config; fi
if [ -f DEternal_loadMods.exe ]; then rm DEternal_loadMods.exe; fi
if [ -f DEternal_patchManifest.py ]; then rm DEternal_patchManifest.py; fi

#Check for Asset Version
if [ "$ASSET_VERSION" == "0" ]; then
    read -r -p $'\e[34mOld Doom Eternal backups detected! Make sure the game is updated to the latest version, then verify the game files through Steam/Bethesda.net then run this batch again to reset your backups.
If you have already done so, press Enter to continue.\e[0m:'
    ResetBackups
    ASSET_VERSION="5.0"
    HAS_CHECKED_RESOURCES="0"
fi

#Setup for ModLoader
if [ "$HAS_READ_FIRST_TIME" == "0" ]; then
    read -r -p $'\e[34mFirst-time information:

This batch file automatically...
- Makes backups of DOOM Eternal .resources archives the first time that they will be modified.
- Restores ones that were modified last time (to prevent uninstalled mods from lingering around) on subsequent uses.
- Runs DEternal_loadMods to load all mods in -/DOOMEternal/Mods/.
- Runs idRehash to rehash the modified resources hashes.
- Runs EternalPatcher to apply EXE patches to the DOOM Eternal game executable.

Press any key to continue...\e[0m'
echo	
    read -r -p $'\e[34mWe take no credit for the tools used in the mod loading, credits go to:
DEternal_loadMods: SutandoTsukai181 for making it in Python (based on a QuickBMS-based unpacker made for Wolfenstein II: The New Colossus by aluigi and edited for DOOM Eternal by one of infograms friends), proteh for remaking it in C#, and PowerBall253 for rewriting it on C++ for Linux users.
EternalPatcher: proteh for making it (based on EXE patches made by infogram that were based on Cheat Engine patches made by SunBeam, as well as based on EXE patches made by Visual Studio) and PowerBall253 for porting it to work on Linux.
idRehash: infogram for making it, proteh for updating it, and PowerBall253 for porting it to Linux.
DEternal_patchManifest: Visual Studio and SutandoTsukai181 for making it on Python, and PowerBall253 for rewriting it on Rust for Linux users.
DOOM Eternal: Bethesda Softworks, id Software, and everyone else involved, for making and updating it.

Press any key to continue...\e[0m'
echo
    read -r -p $'\e[34mIf any mods are currently installed and/or you have some outdated files when EternalModInjector makes .resources backups, the subsequent backups will contain those mods and/or be outdated.
Dont worry, though; If you ever mess up in a way that results in an already-modified/outdated backup, simply verify/repair DOOM Eternal installation through Steam or the Bethesda.net Launcher, open EternalModInjector Settings.txt in Notepad, change the :RESET_BACKUPS=0 line to :RESET_BACKUPS=1, and save the file.

Press any key to continue...\e[0m'
echo
read -r -p $'\e[34mNow, without further ado, press any key to continue one last time, and this batch file will initiate mod-loading mode.

Press any key to continue...\e[0m'
HAS_READ_FIRST_TIME="1"
fi

if [ "$RESET_BACKUPS" == "1" ]; then
    ResetBackups
    read -r -p $'\e[34mPress Enter to continue with mod loading.\e[0m:'
    HAS_CHECKED_RESOURCES="0"
fi

#Patch Game Executable
GameMD5=$(md5sum "DOOMEternalx64vk.exe" | awk '{ print $1 }')
if [ "$VANILLA_GAME_MD5_A" != "$GameMD5" ] && [ "$VANILLA_GAME_MD5_B" != "$GameMD5" ] && [ "$PATCHED_GAME_MD5_A" != "$GameMD5" ] && [ "$PATCHED_GAME_MD5_B" != "$GameMD5" ]; then CorruptedGameExecutable; fi

if [ "$VANILLA_GAME_MD5_A" == "$GameMD5" ] || [ "$VANILLA_GAME_MD5_B" == "$GameMD5" ]; then
    printf "%s\n" "
${blu}Patching game executable...${end}
"
    (cd base || return
    if [ "$ETERNALMODINJECTOR_DEBUG" == "1" ]; then ./EternalPatcher --update; else ./EternalPatcher --update > /dev/null; fi
    if [ "$ETERNALMODINJECTOR_DEBUG" == "1" ]; then ./EternalPatcher --patch "../DOOMEternalx64vk.exe"; else ./EternalPatcher --patch "../DOOMEternalx64vk.exe" > /dev/null; fi)

    if [ "$?" == "1" ]; then
        printf "%s\n" "
${red}EternalPatcher has failed! Verify game files through Steam/Bethesda.net, then open 'EternalModInjector Settings.txt' with a text editor and change RESET_BACKUPS value to 1, then try again.${end}
"
        exit 1
    fi
fi

GameMD5=$(md5sum "DOOMEternalx64vk.exe" | awk '{ print $1 }')
if [ "$PATCHED_GAME_MD5_A" != "$GameMD5" ] && [ "$PATCHED_GAME_MD5_B" != "$GameMD5" ]; then
    printf "%s\n" "
${red}Game patching failed! Verify the game executable isn't being used by any program, such as Steam, Bethesda.net, or DOOM Eternal itself, then try again.${end}
"
    exit 1
fi

#Check for all resources files
printf "%s\n" "
${blu}Checking resources files...${end}
"
if [ "$HAS_CHECKED_RESOURCES" == "0" ]; then
for (( i = 0; i < ${#ResourceFilePaths[@]} ; i++ )); do
    line="${ResourceFilePaths[$i]#*=}"
    if ! [ -f "$line" ]; then
        printf "%s\n" "
${red}Some .resources files are missing! Verify game files through Steam/Bethesda.net then try again.${end}
"
        exit 1
    fi
done
fi

#Execute each line of ResourceFilePaths
for (( i = 0; i < ${#ResourceFilePaths[@]} ; i++ )); do
    eval "${ResourceFilePaths[$i]}"
done

#Restore Backups
if [ "$RESET_BACKUPS" != "1" ] && [ "$first_time" != "1" ]; then
printf "%s\n" "
${blu}Restoring backups...${end}
"
while IFS= read -r filename; do
    if [[ "$filename" == *.resources ]] || [[ "$filename" == *.resources* ]]; then
        filename=${filename//[[:cntrl:]]/}
        filename_name=${filename%.resources*}
        path=${filename_name}_path
        path=${!path}
        if [[ "$filename" != dlc_* ]]; then
            printf "%s\n" "
                    ${blu}Restoring ${filename_name}.resources.backup...${end}
                    "
                if ! [ -f "$path" ]; then NoBackupFound ; fi
            \cp "${path}.backup" "$path"
        else
            printf "%s\n" "
                    ${blu}Restoring dlc_${filename_name}.resources.backup...${end}
                    "
            if ! [ -f "$path" ]; then NoBackupFound ; fi
            \cp "${path}.backup" "$path"

        fi		
    fi	
done < "EternalModInjector Settings.txt"
fi
RESET_BACKUPS="0"

#Check meta.resources
printf "%s\n" "
${blu}Checking meta.resources...${end}
"
if [ "$HAS_CHECKED_RESOURCES" == "0" ]; then
    if ! [ -f base/meta.resources ]; then MissingMeta; fi
    MetaMD5=$(md5sum "base/meta.resources" | awk '{ print $1 }')
    if [ "$VANILLA_META_MD5" != "$MetaMD5" ]; then MissingMeta; fi
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
if [ -z "$(ls -A "Mods")" ]; then
    printf "%s\n" "
${grn}No mods found! All .resources files have been restored to their vanilla state.${end}
"
    exit 1
fi

#Backup .resources
printf "%s\n" "
${blu}Backing up .resources...${end}
"
sed -i '/.resources$/d' "EternalModInjector Settings.txt"
sed -i '/.backup$/d' "EternalModInjector Settings.txt"
IFS=$'\n' read -r -d '' -a modloaderlist < <( base/DEternal_loadMods "." --list-res )
for (( i = 0; i < ${#modloaderlist[@]}; i++ )); do
    if [ "${modloaderlist[$i]}" == "" ]; then 
            printf "%s\n" "
${grn}No mods found! All .resources files have been restored to their vanilla state.${end}
"
        break
    fi
    filename="${modloaderlist[$i]#*=}"
    filename="${filename/$'\r'/}"
    if ! [ -f "${filename}.backup" ]; then
        \cp "$filename" "${filename}.backup"
        name=${filename##*/}
        printf "%s\n" "
                    ${blu}Backed up $name${end}
        "
    else
        name=${filename##*/}
    fi
    filename=${name%.resources}
    echo "${filename}.backup" >> "EternalModInjector Settings.txt"
    echo "${filename}.resources" >> "EternalModInjector Settings.txt"
done

#Backup meta.resources and add to the list
if ! [ -f "base/meta.resources.backup" ]; then 
    \cp "base/meta.resources" "base/meta.resources.backup"
    printf "%s\n" "
                    ${blu}Backed up meta.resources${end}
    "
fi
sed -i '/meta.backup$/d' "EternalModInjector Settings.txt"
echo meta.backup >> "EternalModInjector Settings.txt"
echo meta.resources >> "EternalModInjector Settings.txt"


#Get vanilla resource hash offsets (idRehash)
if [ "$HAS_CHECKED_RESOURCES" == "0" ]; then
    printf "%s\n" "
${blu}Getting vanilla resource hash offsets... (idRehash)${end}
"
    (cd base || return
    if [ "$ETERNALMODINJECTOR_DEBUG" == "1" ]; then ./idRehash --getoffsets; else ./idRehash --getoffsets > /dev/null; fi)
    
    if [ "$?" == "1" ]; then
    printf "%s\n" "
${red}idRehash has failed! Verify game files through Steam/Bethesda.net, then open 'EternalModInjector Settings.txt' with a text editor and change RESET_BACKUPS value to 1, then try again.${end}
"
    exit 1
    fi

    HAS_CHECKED_RESOURCES="1"
fi

#Load Mods (DEternal_loadMods)
printf "%s\n" "
${blu}Loading mods... (DEternal_loadMods)${end}
"
base/DEternal_loadMods "."

if [ "$?" == "1" ]; then
    printf "%s\n" "
${red}DEternal_loadMods has failed! Verify game files through Steam/Bethesda.net, then open 'EternalModInjector Settings.txt' with a text editor and change RESET_BACKUPS value to 1, then try again.${end}
"
    exit 1
fi

#Rehash resource hashes (idRehash)
printf "%s\n" "
${blu}Rehashing resource offsets... (idRehash)${end}
"
(cd base || return
if [ "$ETERNALMODINJECTOR_DEBUG" == "1" ]; then ./idRehash; else ./idRehash > /dev/null; fi)

if [ "$?" == "1" ]; then
    printf "%s\n" "
${red}idRehash has failed! Verify game files through Steam/Bethesda.net, then open 'EternalModInjector Settings.txt' with a text editor and change RESET_BACKUPS value to 1, then try again.${end}
"
    exit 1
fi

#Patch build manifest
printf "%s\n" "
${blu}Patching build manifest... (DEternal_patchManifest)${end}
"
(cd base || return
if [ "$ETERNALMODINJECTOR_DEBUG" == "1" ]; then ./DEternal_patchManifest 8B031F6A24C5C4F3950130C57EF660E9; else ./DEternal_patchManifest 8B031F6A24C5C4F3950130C57EF660E9 > /dev/null; fi)

if [ "$?" == "101" ]; then
    printf "%s\n" "
${red}DEternal_patchManifest has failed! Verify game files through Steam/Bethesda.net, then open 'EternalModInjector Settings.txt' with a text editor and change RESET_BACKUPS value to 1, then try again.${end}
"
    exit 1
fi

printf "%s\n" "
${grn}Mods have been loaded! You can now launch the game.${end}
"
exit 0
