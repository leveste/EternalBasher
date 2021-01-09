printf "EternalModInjector Shell Script\n\n
		By Leveste and PowerBall253\n\n
		Based on original batch file by Zwip-Zwap Zapony\n\n\n"


export ___CONFIGURATION_FILE="EternalModInjector Settings.txt"
export ___CONFIGURATION_FILE_OLD="EternalModInjector.dat"
export ___GAME_EXE="DOOMEternalx64vk.exe"

export ___ASSET_VERSION=4.1
export ___DETERNAL_LOADMODS_MD5="43c54928c12d5d72c32f563f01dc7aef"
export ___ETERNALPATCHER_MD5="8033260ff14c2ee441b81bbf8d3b2de0"
export ___IDREHASH_MD5="50747578b8e29c3da1aa5a3ac5d28cc7"
export ___PATCHED_GAME_MD5="3238e7a9277efc6a607b1b1615ebe79f 4acdaf89f30f178ba9594c0364b35a30"
export ___VANILLA_GAME_MD5="1ef861b693cdaa45eba891d084e5f3a3 c2b429b2eb398f836dd10d22944b9c76"
export ___VANILLA_META_MD5="4f4deb1df8761dc8fd2d3b25a12d8d91"

export ___GAME_HAS_BEEN_PATCHED=""
export ___OWNS_ANCIENT_GODS_ONE=false
export ___OWNS_CAMPAIGN=false
 
export ___CONFIGURATION_EXISTS=""
export ___AUTO_LAUNCH_GAME=1
export ___GAME_PARAMETERS=""
export ___HAS_CHECKED_RESOURCES=""
export ___HAS_READ_FIRST_TIME=""
export ___RESET_BACKUPS=""



if [ -f base/game/sp/e1m1_intro/e1m1_intro.resources ]; then export ___OWNS_CAMPAIGN=true; fi
if [ -f base/game/dlc/e4m1_rig/e4m1_rig.resources ]; then export ___OWNS_ANCIENT_GODS_ONE=true; fi

FunctionCallForResources FunctionInitializeBackupVariable
FunctionCallForResources FunctionInitializeModdedVariable

if [ -f ./$___CONFIGURATION_FILE ]; then goto ConfigurationFile; fi
if [ -f ./$___CONFIGURATION_FILE_OLD ]; then goto ConfigurationFileOld; fi

: PostConfigurationFile

if ! [ -z ${___RESET_BACKUPS+x} ]; then goto "ResetBackups"; fi

: PostResetBackups

goto "CheckForNeededFiles"

: PostCheckForNeededFiles

if [ -z ${___HAS_READ_FIRST_TIME+x} ]; then goto "FirstTimeInformation"; fi

: PostFirstTimeInformation

if ! [ -z ${___CONFIGURATION_EXISTS+x} ]; then goto "RestoreArchives"; fi

: PostRestoreArchives

goto "ModLoader"