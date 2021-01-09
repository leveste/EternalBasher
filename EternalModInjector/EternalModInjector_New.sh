printf "EternalModInjector Shell Script\n\n
		By Leveste and PowerBall253\n\n
		Based on original batch file by Zwip-Zwap Zapony\n\n\n"

#Verify if tools exist
if ! [ -f DOOMEternalx64vk.exe ]; then MissingGame; fi
if ! [ -f DEternal_loadMods.exe ]; then MissingDEternalLoadMods; fi
if ! [ -f base/idRehash.exe ]; then MissingIdRehash; fi

#Give executable permissions to tools
chmod +x DEternal_loadMods.exe
chmod +x idRehash.exe

#Assign game hashes to variables
ASSET_VERSION=4.1
DETERNAL_LOADMODS_MD5="43c54928c12d5d72c32f563f01dc7aef"
ETERNALPATCHER_MD5="8033260ff14c2ee441b81bbf8d3b2de0"
IDREHASH_MD5="50747578b8e29c3da1aa5a3ac5d28cc7"
PATCHED_GAME_MD5="3238e7a9277efc6a607b1b1615ebe79f 4acdaf89f30f178ba9594c0364b35a30"
VANILLA_GAME_MD5="1ef861b693cdaa45eba891d084e5f3a3 c2b429b2eb398f836dd10d22944b9c76"
VANILLA_META_MD5="4f4deb1df8761dc8fd2d3b25a12d8d91"

#Verify tool hashes
DEternal_LoadModsMD5=($(md5sum DEternal_loadMods.exe))
idRehashMD5=($(md5sum base/idRehash.exe))
if ! [ $DETERNAL_LOADMODS_MD5 == $DEternal_LoadModsMD5 ]; then MissingDEternalLoadMods; fi
if ! [ $IDREHASH_MD5 == $idRehashMD5 ]; then MissingDEternalLoadMods; fi

#Patch Game Executable
GameMD5=($(md5sum DOOMEternalx64vk.exe))
if ! [ $VANILLA_GAME_MD5 == $GameMD5 ] || [ $VANILLA_GAME_MD5 == $GameMD5 ] ; then CorruptedGameExecutable; fi

if [ $VANILLA_GAME_MD5 == $GameMD5 ]
then
  if ! [ -f EternalPatcher.exe ]; then MissingEternalPatcher; fi
  chmod +x EternalPatcher.exe
  wine EternalPatcher.exe --patch DOOMEternalx64vk.exe
fi

#Config File check
if ! [ -f 'EternalModInjector Settings.txt' ]; then CreateConfigFile; else
	cat 'EternalModInjector Settings.txt'
	TXT='EternalModInjector Settings.txt'
	if grep -q "ASSET_VERSION=4.1" "$File"; then ASSET_VERSION="4.1" else ASSET_VERSION="0" fi
	HAS_CHECKED_RESOURCES=$(sed -n 2p $TXT); HAS_CHECKED_RESOURCES=${HAS_CHECKED_RESOURCES#$HAS_CHECKED_RESOURCES=}
	if grep -q "RESET_BACKUPS=1" "$File"; then RESET_BACKUPS="1"; else RESET_BACKUPS="0"; fi
	if grep -q "HAS_READ_FIRST_TIME=1" "$File"; then HAS_READ_FIRST_TIME="1"; else HAS_READ_FIRST_TIME="0"; fi
	if grep -q "RESET_BACKUPS=1" "$File"; then RESET_BACKUPS="1"; else RESET_BACKUPS="0"; fi
fi

#Setup for ModLoader
if [ $HAS_READ_FIRST_TIME == "0" ]
then
	read -p "Some first time message"
	HAS_READ_FIRST_TIME="1"
fi

if [ $ASSET_VERSION == "0" ]
then
	read -p "Old Doom Eternal backups detected! Verify the game files through Steam/Bethesda.net then run this batch again to reset your backups."
	ResetBackups
	ASSET_VERSION="4.1"
fi

if [ $RESET_BACKUPS == "1" ]
then
	ResetBackups
	RESET_BACKUPS="0"
fi

#Restore Backups

	

#Functions
MissingGame() {
read -p "Game Executable not found! Make sure you put this shell script in the DOOMEternal folder and try again."
exit 1
}

ResetBackups() {
read -r -p "Reset backups now? [y/N] " response
case "$response" in
	[yY][eE][sS]|[yY]) 
       		find . -name "*.backup" -type f -delete
		;;
	*)
		read -p "Backups have not been reset."
		exit 1
		;;
esac
}
