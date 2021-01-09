printf "EternalModInjector Shell Script\n\n
		By Leveste and PowerBall253\n\n
		Based on original batch file by Zwip-Zwap Zapony\n\n\n"

#Verify if tools exist
if ! [ -f DOOMEternalx64vk.exe ]; then MissingGame; fi
if ! [ -f DEternal_loadMods.exe ]; then MissingDEternalLoadMods; fi
if ! [ -f base/idRehash.exe ]; then MissingIdRehash; fi

#Assign game hashes to variables
export ASSET_VERSION=4.1
export DETERNAL_LOADMODS_MD5="43c54928c12d5d72c32f563f01dc7aef"
export ETERNALPATCHER_MD5="8033260ff14c2ee441b81bbf8d3b2de0"
export IDREHASH_MD5="50747578b8e29c3da1aa5a3ac5d28cc7"
export PATCHED_GAME_MD5="3238e7a9277efc6a607b1b1615ebe79f 4acdaf89f30f178ba9594c0364b35a30"
export VANILLA_GAME_MD5="1ef861b693cdaa45eba891d084e5f3a3 c2b429b2eb398f836dd10d22944b9c76"
export VANILLA_META_MD5="4f4deb1df8761dc8fd2d3b25a12d8d91"

#Verify tool hashes
if ! [[ $DETERNAL_LOADMODS_MD5 == $(md5sum DEternal_loadMods.exe) ]]; then MissingDEternalLoadMods; fi
if ! [[ $IDREHASH_MD5 == $(md5sum base/idRehash.exe) ]]; then MissingDEternalLoadMods; fi

#Patch Game Executable
if [[ $VANILLA_GAME_MD5 == $(md5sum DOOMEternalx64vk.exe) ]]; then
  #Verify if EternalPatcher is present
  #Commands for EternalPatcher
fi

if ! [[ $PATCHED_GAME_MD5 == $(md5sum DOOMEternalx64vk.exe) ]]; then CorruptedGameExecutable; fi

#Config File check
if ! [ -f 'EternalModInjector Settings.txt' ]; then CreateConfigFile; fi
