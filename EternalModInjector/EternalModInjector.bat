@ECHO OFF


TITLE EternalModInjector.bat    (2020-12-24)
ECHO/
ECHO 	[44;96m                                             [0m 
ECHO 	[44;96m  EternalModInjector                         [0m 
ECHO 	[44;96m      by Zwip-Zwap Zapony, dated 2020-12-24  [0m 
ECHO 	[44;96m                                             [0m 
ECHO/
ECHO/


2>NUL VERIFY/
SETLOCAL ENABLEEXTENSIONS

IF ERRORLEVEL 1 (
	ECHO 	[1;41;93mERROR: Command Processor Extensions are unavailable![0m 
	ECHO/
	ECHO 	This batch file requires command extensions, but they seem to be unavailable on your system.
	ECHO/
	PAUSE
	EXIT /B 1
)
IF NOT CMDEXTVERSION 2 (
	ECHO 	[1;41;93mERROR: Command Processor Extensions are of version 1![0m 
	ECHO/
	ECHO 	Command extensions seem to be available on your system, but only of version 1. This batch file was designed for version 2.
	ECHO/
	PAUSE
	EXIT /B 1
)


SET ___CONFIGURATION_FILE=EternalModInjector Settings.txt
SET ___CONFIGURATION_FILE_OLD=EternalModInjector.dat
SET ___GAME_EXE=DOOMEternalx64vk.exe

SET ___ASSET_VERSION=4.1
SET ___DETERNAL_LOADMODS_MD5=43c54928c12d5d72c32f563f01dc7aef
SET ___ETERNALPATCHER_MD5=8033260ff14c2ee441b81bbf8d3b2de0
SET ___IDREHASH_MD5=50747578b8e29c3da1aa5a3ac5d28cc7
SET ___PATCHED_GAME_MD5=3238e7a9277efc6a607b1b1615ebe79f 4acdaf89f30f178ba9594c0364b35a30
SET ___VANILLA_GAME_MD5=1ef861b693cdaa45eba891d084e5f3a3 c2b429b2eb398f836dd10d22944b9c76
SET ___VANILLA_META_MD5=4f4deb1df8761dc8fd2d3b25a12d8d91

SET ___CERTUTIL_EXISTS=1
SET ___GAME_HAS_BEEN_PATCHED=
SET ___OWNS_ANCIENT_GODS_ONE=
SET ___OWNS_CAMPAIGN=

SET ___CONFIGURATION_EXISTS=
SET ___AUTO_LAUNCH_GAME=1
SET ___GAME_PARAMETERS=
SET ___HAS_CHECKED_RESOURCES=
SET ___HAS_READ_FIRST_TIME=
SET ___RESET_BACKUPS=

2>NUL CD /D %~dp0

IF EXIST ".\base\game\sp\e1m1_intro\e1m1_intro.resources" SET ___OWNS_CAMPAIGN=1
IF EXIST ".\base\game\dlc\e4m1_rig\e4m1_rig.resources"    SET ___OWNS_ANCIENT_GODS_ONE=1
IF EXIST ".\base\game\dlc\e5m1____\e5m1____.resources"    SET ___OWNS_ANCIENT_GODS_TWO=1

CALL :FunctionCallForResources :FunctionInitializeBackupVariable
CALL :FunctionCallForResources :FunctionInitializeModdedVariable

2>NUL WHERE /Q certutil
IF ERRORLEVEL 1 IF NOT ERRORLEVEL 9009 SET ___CERTUTIL_EXISTS=





IF EXIST ".\%___CONFIGURATION_FILE%" GOTO ConfigurationFile
IF EXIST ".\%___CONFIGURATION_FILE_OLD%" GOTO ConfigurationFileOld
:PostConfigurationFile


IF DEFINED ___RESET_BACKUPS GOTO ResetBackups
:PostResetBackups


GOTO CheckForNeededFiles
:PostCheckForNeededFiles


IF NOT DEFINED ___HAS_READ_FIRST_TIME GOTO FirstTimeInformation
:PostFirstTimeInformation


IF DEFINED ___CONFIGURATION_EXISTS GOTO RestoreArchives
:PostRestoreArchives


GOTO ModLoader





:ConfigurationFile
ECHO 	Loading configuration file... (%___CONFIGURATION_FILE:\=/%)
SET ___CONFIGURATION_EXISTS=1


>NUL 2>&1 FINDSTR /B /E /L ":ASSET_VERSION=%___ASSET_VERSION%" ".\%___CONFIGURATION_FILE%"
IF ERRORLEVEL 1 SET ___RESET_BACKUPS=AssetUpdate

>NUL 2>&1 FINDSTR /B /E /L ":AUTO_LAUNCH_GAME=0" ".\%___CONFIGURATION_FILE%"
IF NOT ERRORLEVEL 1 SET ___AUTO_LAUNCH_GAME=

SET ___TEMP=
FOR /F "delims=" %%A IN ('FINDSTR /B /L ":GAME_PARAMETERS=" ".\%___CONFIGURATION_FILE%"') DO SET ___TEMP=%%A
IF DEFINED ___TEMP SET ___GAME_PARAMETERS=%___TEMP:~17%

>NUL 2>&1 FINDSTR /B /E /L ":HAS_CHECKED_RESOURCES=2" ".\%___CONFIGURATION_FILE%"
IF NOT ERRORLEVEL 1 (
	SET ___HAS_CHECKED_RESOURCES=2
) ELSE (
	>NUL 2>&1 FINDSTR /B /E /L ":HAS_CHECKED_RESOURCES=1" ".\%___CONFIGURATION_FILE%"
	IF NOT ERRORLEVEL 1 SET ___HAS_CHECKED_RESOURCES=1
)

>NUL 2>&1 FINDSTR /B /E /L ":HAS_READ_FIRST_TIME=1" ".\%___CONFIGURATION_FILE%"
IF NOT ERRORLEVEL 1 SET ___HAS_READ_FIRST_TIME=1

>NUL 2>&1 FINDSTR /B /E /L ":RESET_BACKUPS=1" ".\%___CONFIGURATION_FILE%"
IF NOT ERRORLEVEL 1 IF NOT DEFINED ___RESET_BACKUPS SET ___RESET_BACKUPS=1

CALL :FunctionCallForResources :FunctionSetResourceVariable

GOTO PostConfigurationFile


:ConfigurationFileOld
>NUL MOVE /Y ".\%___CONFIGURATION_FILE_OLD%" ".\%___CONFIGURATION_FILE%"
IF EXIST ".\%___CONFIGURATION_FILE%" GOTO ConfigurationFile

CALL :FunctionEchoError "%___CONFIGURATION_FILE_OLD:\=/%" couldn't be renamed!
ECHO/
ECHO 	Please manually rename "%___CONFIGURATION_FILE_OLD:\=/%" to "%___CONFIGURATION_FILE:\=/%", then run this batch file again.
ECHO/
PAUSE
EXIT /B 1


:FunctionSetResourceVariable
>NUL 2>&1 FINDSTR /B /E /L "%~n2.backup" ".\%___CONFIGURATION_FILE%"
IF NOT ERRORLEVEL 1 SET ___BACKED_UP_%~n2=1

>NUL 2>&1 FINDSTR /B /E /L "%~n2.resources" ".\%___CONFIGURATION_FILE%"
IF NOT ERRORLEVEL 1 SET ___MODDED_%~n2=1

EXIT /B 0





:ResetBackups
IF "%___RESET_BACKUPS%"=="AssetUpdate" GOTO ResetBackupsAssetUpdate

ECHO/
ECHO/
ECHO 	":RESET_BACKUPS" is currently set to "1" in "%___CONFIGURATION_FILE:\=/%".
ECHO/
ECHO 	Do you want to delete the current .resources backups?
ECHO/
ECHO/
ECHO (Press [1m[Y][0m to delete the current backup files.)
ECHO (Press [1m[N][0m to keep the current backups.)
ECHO (Press [1m[I][0m for more information.)
<NUL SET /P ="(Press [1m[Ctrl+C][0m to close this batch file without changes.) "
CHOICE /C YNI /N
ECHO/
ECHO/

IF NOT ERRORLEVEL 1 EXIT /B 1
IF ERRORLEVEL 4 EXIT /B 1

IF ERRORLEVEL 3 GOTO ResetBackupsInformation
IF ERRORLEVEL 2 GOTO ResetBackupsNo

:ResetBackupsYes
ECHO 	Deleting backups...

SET ___HAS_CHECKED_RESOURCES=
CALL :FunctionCallForResources :FunctionDeleteBackup
CALL :FunctionWriteConfiguration

ECHO 	The backups have been deleted.

CALL :FunctionCheckIfModsExist
IF ERRORLEVEL 1 GOTO ResetBackupsYesY

ECHO 	No mods were found in the "Mods" folder, so this batch file will close now.
ECHO/
PAUSE
EXIT /B 1

:ResetBackupsYesY
ECHO 	Would you like to install mods now?
ECHO/
ECHO (Press [1m[Y][0m to install mods.)
:ResetBackupsYesN
<NUL SET /P ="(Press [1m[N][0m to close this batch file.) "
CHOICE /C YN /N
ECHO/
ECHO/

IF NOT ERRORLEVEL 1 EXIT /B 1
IF ERRORLEVEL 2 EXIT /B 1

GOTO PostResetBackups


:ResetBackupsNo
CALL :FunctionWriteConfiguration
ECHO 	The backups have been kept as they were.

CALL :FunctionCheckIfModsExist
IF ERRORLEVEL 1 GOTO ResetBackupsYesY

ECHO 	Would you like to uninstall mods now?
ECHO/
ECHO (Press [1m[Y][0m to uninstall mods.)
GOTO ResetBackupsYesN


:ResetBackupsInformation
ECHO/
ECHO/
ECHO 	More information:
ECHO/
ECHO 	DOOM Eternal mods are applied to the game's .resources files.
ECHO 	Since they're applied to existing .resources files, not brand-new files, it's necessary to have backups of the original/default/vanilla .resources files.
ECHO 	The backups are used to restore the vanilla .resources files, so that you can avoid unwanted mods' changes being kept when you try to uninstall a mod.
ECHO 	This batch file automatically handles the backup and restoration process for you, backing up .resources files the first time that they're about to be modified, and restoring them the next time that you run this batch file.
ECHO/
ECHO/
PAUSE

ECHO/
ECHO/
ECHO/
ECHO/
ECHO 	However, if the backups are outdated or already-modified, it's wise to delete them, in order to make new, up-to-date backups.
ECHO 	(This should only be done when the current .resources files are original/default/vanilla/non-modified, so make sure to verify/repair DOOM Eternal's installation through Steam or the Bethesda.net Launcher first.)
ECHO/
ECHO 	When the ":RESET_BACKUPS=0" line is changed from "0" to "1" in -/DOOMEternal/%___CONFIGURATION_FILE:\=/%, you will be asked if you'd like to delete this batch file's backups.
ECHO 	There are 3 options as to how to handle it:
ECHO/
ECHO/
PAUSE

ECHO/
ECHO/
ECHO/
ECHO/
ECHO 	With the [1m[Y][0m option, the backup files will be deleted from the disk, and then new backups will be made the next first time that you install a mod for a .resources file.
ECHO/
ECHO 	With the [1m[N][0m option, the current backup files will remain on the disk, and they will continue to be used (without updating them).
ECHO/
ECHO 	With the [1m[Ctrl+C][0m option, this batch file will close without doing any changes anywhere.
ECHO/
ECHO/
PAUSE

ECHO/
ECHO/
ECHO (Press [1m[Y][0m, [1m[N][0m, or [1m[Ctrl+C][0m.
CHOICE /C YN /N /M "See above for what the options do.)"
ECHO/
ECHO/

IF NOT ERRORLEVEL 1 EXIT /B 1
IF ERRORLEVEL 3 EXIT /B 1

IF ERRORLEVEL 2 GOTO ResetBackupsNo
GOTO ResetBackupsYes



:ResetBackupsAssetUpdate
ECHO/
ECHO/
ECHO 	This batch file has been updated for a new version of DOOM Eternal since you last used it.
ECHO 	By extension, this implies that DOOM Eternal has been updated, and so the .resources backups must be updated too.
ECHO/
ECHO 	Make sure to verify/repair DOOM Eternal's installation through Steam or the Bethesda.net Launcher before continuing.
ECHO/
ECHO/
ECHO (After verifying/repairing DOOM Eternal, press [1m[Y][0m to delete the current backup files.)
ECHO (Press [1m[I][0m for instructions on verifying/repairing DOOM Eternal.)
<NUL SET /P ="(Press [1m[Ctrl+C][0m to close this batch file without changes.) "
CHOICE /C YI /N
ECHO/
ECHO/

IF NOT ERRORLEVEL 1 EXIT /B 1
IF ERRORLEVEL 3 EXIT /B 1

IF NOT ERRORLEVEL 2 GOTO ResetBackupsYes

ECHO/
ECHO/
CALL :FunctionRedownloadInstructions 0
ECHO/
ECHO/
PAUSE

ECHO/
ECHO/
ECHO/
ECHO/
ECHO 	After having verified/repaired DOOM Eternal's installation, press [1m[Y][0m to delete the current backup files.
ECHO/
ECHO 	If you'd rather verify/repair DOOM Eternal later instead of now, you can instead press [1m[Ctrl+C][0m to close this batch file without changes.
ECHO/
ECHO/
ECHO (Press [1m[Y][0m or [1m[Ctrl+C][0m.
CHOICE /C Y /N /M "See above for what the options do.)"
ECHO/
ECHO/

IF NOT ERRORLEVEL 1 EXIT /B 1
IF ERRORLEVEL 2 EXIT /B 1

GOTO ResetBackupsYes


:FunctionDeleteBackup
SET ___MODDED_%~n2=
IF NOT DEFINED ___BACKED_UP_%~n2 EXIT /B 0

SET ___BACKED_UP_%~n2=
IF EXIST ".\base\%~1.resources.backup" (
	ECHO 	Deleting %~n1.resources.backup...
	>NUL DEL ".\base\%~1.resources.backup"
) ELSE (
	ECHO 	%~n1.resources.backup was already deleted...
)
EXIT /B 0





:CheckForNeededFiles
ECHO 	Checking for needed files, please be patient...

IF EXIST ".\Eternal Mod Loader.exe" GOTO CheckForNeededFilesNewModLoader

CALL :FunctionCheckForGameExe
IF ERRORLEVEL 1 EXIT /B 1

IF NOT DEFINED ___HAS_CHECKED_RESOURCES (
	CALL :FunctionCallForResources :FunctionCheckForResourceFile
	IF ERRORLEVEL 1 EXIT /B 1
	SET ___HAS_CHECKED_RESOURCES=1
)

CALL :FunctionCheckForMetaResource

CALL :FunctionCheckForToolFile "DEternal_loadMods.exe" "%___DETERNAL_LOADMODS_MD5%"
IF ERRORLEVEL 1 EXIT /B 1
CALL :FunctionCheckForToolFile "EternalPatcher.exe" "%___ETERNALPATCHER_MD5%"
IF ERRORLEVEL 1 EXIT /B 1
CALL :FunctionCheckForToolFile "base\idRehash.exe" "%___IDREHASH_MD5%"
IF ERRORLEVEL 1 EXIT /B 1
CALL :FunctionCheckForModsFolder
IF ERRORLEVEL 1 EXIT /B 1
CALL :FunctionCheckForGameBackupFolder
IF ERRORLEVEL 1 EXIT /B 1
CALL :FunctionCallForResources :FunctionCheckForBackupFile
IF ERRORLEVEL 1 EXIT /B 1

GOTO PostCheckForNeededFiles


:CheckForNeededFilesNewModLoader
ECHO/
ECHO/
ECHO 	[1;32;92mNOTE: You should use Eternal Mod Loader instead![0m 
ECHO/
ECHO 	You have an "Eternal Mod Loader.exe" file. That's the new mod-loading tool, so you should use it instead of this batch file.
ECHO/
ECHO/
CALL :FunctionCallForResources :FunctionIsThereAnyBackup
IF ERRORLEVEL 1 GOTO CheckForNeededFilesNewModLoaderBackups
PAUSE
EXIT /B 1

:CheckForNeededFilesNewModLoaderBackups
ECHO 	That said, Eternal Mod Loader doesn't use this batch file's .resources backups.
ECHO 	Do you want to uninstall mods and delete the current backups?
ECHO/
ECHO/
ECHO (Press [1m[Y][0m to uninstall mods and delete the backups.)
<NUL SET /P ="(Press [1m[N][0m to close this batch file.) "
CHOICE /C YN /N
ECHO/
ECHO/

IF NOT ERRORLEVEL 1 EXIT /B 1
IF ERRORLEVEL 2 EXIT /B 1

ECHO 	Uninstalling mods and deleting backups...

SET ___HAS_CHECKED_RESOURCES=
SET ___TEMP=
CALL :FunctionCallForResources :FunctionRestoreAndDeleteBackup
CALL :FunctionWriteConfiguration

ECHO/
ECHO/
ECHO 	The backups have been deleted.

IF NOT DEFINED ___TEMP GOTO CheckForNeededFilesNewModLoaderPostVerify

ECHO 	However, not all modded .resources archives could be restored.
ECHO 	Before using Eternal Mod Loader, please verify/repair DOOM Eternal's installation through Steam or the Bethesda.net Launcher, to ensure that this batch file's mods will be properly uninstalled.
ECHO/
ECHO/
CALL :FunctionRedownloadInstructions 0
ECHO/
ECHO/
PAUSE

ECHO/
ECHO/

:CheckForNeededFilesNewModLoaderPostVerify
ECHO 	This batch file will close now. Please use Eternal Mod Loader from now.
ECHO/
ECHO/
PAUSE
EXIT /B 1


:FunctionCheckForBackupFile
IF NOT DEFINED ___MODDED_%~n2 EXIT /B 0
IF NOT DEFINED ___BACKED_UP_%~n2 GOTO FunctionCheckForBackupFileUndefined %1
IF EXIST ".\base\%~1.resources.backup" EXIT /B 0

SET ___TEMP=%~1
CALL :FunctionEchoError "%~n1.resources.backup" not found!
ECHO/
ECHO 	%~n1.resources.backup should be located at -/DOOMEternal/base/%___TEMP:\=/%.resources.backup, but it's missing!
ECHO/
CALL :FunctionRedownloadInstructions 1
ECHO/
PAUSE
EXIT /B 1

:FunctionCheckForBackupFileUndefined
CALL :FunctionEchoError "%~n1.resources" is not backed up!
ECHO/
ECHO 	The last time that you ran EternalModInjector, "%~n1.resources" was marked as modified, but not marked as backed up. This should be impossible.
ECHO/
CALL :FunctionRedownloadInstructions 1
ECHO/
PAUSE
EXIT /B 1


:FunctionCheckForGameBackupFolder
IF NOT EXIST ".\base\game.backup\" EXIT /B 0
ECHO/
ECHO/
ECHO 	WARNING: "game.backup" found!
ECHO/
ECHO 	The "game.backup" folder is made by an outdated mod-loading tool, and causes problems for this batch file.
ECHO 	The "game.backup" folder is located at -/DOOMEternal/base/game.backup/
ECHO/
ECHO 	Do you want to delete that folder and its contents now?
ECHO 	If you've put any files there intentionally, they will be lost forever if you don't move them out first!
ECHO/
ECHO/
ECHO (Press [1m[Y][0m to delete the "game.backup" folder.)
<NUL SET /P ="(Press [1m[Ctrl+C][0m to close this batch file without changes.) "
CHOICE /C Y /N
ECHO/
ECHO/

IF NOT ERRORLEVEL 1 EXIT /B 1
IF ERRORLEVEL 2 EXIT /B 1

ECHO 	Deleting game.backup...
>NUL RMDIR /S /Q ".\base\game.backup"

IF NOT EXIST ".\base\game.backup\" EXIT /B 0
CALL :FunctionEchoError "game.backup" still exists!
ECHO/
ECHO 	Something went wrong while trying to delete -/DOOMEternal/base/game.backup/
ECHO/
ECHO 	Please make sure that none of the files in that folder are in use by another program (such as anti-virus programs or other software), then run this batch file again.
ECHO/
PAUSE
EXIT /B 1


:FunctionCheckForGameExe
IF NOT EXIST ".\%___GAME_EXE%" GOTO FunctionCheckForGameExeMissing
IF NOT DEFINED ___CERTUTIL_EXISTS EXIT /B 0

SETLOCAL ENABLEDELAYEDEXPANSION
SET ___TEMP=:
FOR /F "delims=" %%A IN ('certutil -hashfile ".\%___GAME_EXE%" MD5') DO SET ___TEMP=!___TEMP!%%A
ENDLOCAL & SET ___TEMP=%___TEMP%

ECHO %___TEMP: =%| >NUL 2>&1 FINDSTR /L /I "%___PATCHED_GAME_MD5%"
IF NOT ERRORLEVEL 1 (
	SET ___GAME_HAS_BEEN_PATCHED=1
	EXIT /B 0
)

ECHO %___TEMP: =%| >NUL 2>&1 FINDSTR /L /I "%___VANILLA_GAME_MD5%"
IF NOT ERRORLEVEL 1 EXIT /B 0

ECHO/
ECHO/
ECHO 	%___TEMP%
CALL :FunctionEchoError "%___GAME_EXE:\=/%" has a wrong MD5 hash!
ECHO/
ECHO 	This means that your copy of %___GAME_EXE:\=/% doesn't match the version that this batch file was made for.
ECHO/
ECHO 	Please update EternalModInjector and verify/repair DOOM Eternal's installation through Steam or the Bethesda.net Launcher.
ECHO 	This version of this batch file is designed for Update %___ASSET_VERSION% of DOOM Eternal.
ECHO/
CALL :FunctionRedownloadInstructions 0
ECHO/
PAUSE
EXIT /B 1

:FunctionCheckForGameExeMissing
CALL :FunctionEchoError "%___GAME_EXE:\=/%" not found!
ECHO/
ECHO 	Did you misplace this batch file, or is your DOOM Eternal installation incomplete?
ECHO 	%___GAME_EXE:\=/% should be located at -/DOOMEternal/%___GAME_EXE:\=/%
ECHO 	This batch file should be located at -/DOOMEternal/EternalModInjector.bat
ECHO/
PAUSE
EXIT /B 1


:FunctionCheckForMetaResource
IF NOT EXIST ".\base\meta.resources" GOTO FunctionCheckForMetaResourceMissing
IF NOT DEFINED ___CERTUTIL_EXISTS EXIT /B 0

IF DEFINED ___MODDED_meta (
	IF NOT DEFINED ___BACKED_UP_meta EXIT /B 0
	IF NOT EXIST ".\base\meta.resources.backup" EXIT /B 0
)

SETLOCAL ENABLEDELAYEDEXPANSION
SET ___TEMP=:
IF DEFINED ___MODDED_meta (
	FOR /F "delims=" %%A IN ('certutil -hashfile ".\base\meta.resources.backup" MD5') DO SET ___TEMP=!___TEMP!%%A
) ELSE FOR /F "delims=" %%A IN ('certutil -hashfile ".\base\meta.resources" MD5') DO SET ___TEMP=!___TEMP!%%A
ENDLOCAL & SET ___TEMP=%___TEMP%

ECHO %___TEMP: =%| >NUL 2>&1 FINDSTR /L /I "%___VANILLA_META_MD5%"
IF NOT ERRORLEVEL 1 EXIT /B 0

ECHO/
ECHO/
ECHO 	%___TEMP%
CALL :FunctionEchoError "meta.resources" has a wrong MD5 hash!
ECHO/
ECHO 	This means that your copy of meta.resources doesn't match the version that this batch file was made for, or is somehow pre-modded when it shouldn't be.
ECHO/
ECHO 	Please update EternalModInjector and verify/repair DOOM Eternal's installation through Steam or the Bethesda.net Launcher.
ECHO 	This version of this batch file is designed for Update %___ASSET_VERSION% of DOOM Eternal.
ECHO/
CALL :FunctionRedownloadInstructions 0
ECHO/
PAUSE
EXIT /B 1

:FunctionCheckForMetaResourceMissing
SET ___TEMP=%~1
CALL :FunctionEchoError "meta.resources" not found!
ECHO/
ECHO 	Did you misplace this batch file, or is your DOOM Eternal installation incomplete?
ECHO 	meta.resources should be located at -/DOOMEternal/base/meta.resources
ECHO 	This batch file should be located at -/DOOMEternal/EternalModInjector.bat
ECHO/
PAUSE
EXIT /B 1


:FunctionCheckForModsFolder
IF EXIST ".\Mods\" EXIT /B 0
CALL :FunctionEchoError "Mods" not found!
ECHO/
ECHO 	Did you misplace this batch file, or did you forget to make a "Mods" folder?
ECHO 	The "Mods" folder should be located at -/DOOMEternal/Mods/
ECHO 	This batch file should be located at -/DOOMEternal/EternalModInjector.bat
ECHO/
ECHO 	If you're trying to uninstall mods, just make an empty "Mods" folder, then run this batch file again.
ECHO/
PAUSE
EXIT /B 1


:FunctionCheckForResourceFile
IF EXIST ".\base\%~1.resources" EXIT /B 0
SET ___TEMP=%~1
CALL :FunctionEchoError "%~n1.resources" not found!
ECHO/
ECHO 	Did you misplace this batch file, or is your DOOM Eternal installation incomplete?
ECHO 	%~n1.resources should be located at -/DOOMEternal/base/%___TEMP:\=/%.resources
ECHO 	This batch file should be located at -/DOOMEternal/EternalModInjector.bat
ECHO/
PAUSE
EXIT /B 1


:FunctionCheckForToolFile
IF NOT EXIST ".\%~1" GOTO FunctionCheckForToolFileMissing
IF "%~2"=="" EXIT /B 0
IF NOT DEFINED ___CERTUTIL_EXISTS EXIT /B 0

SETLOCAL ENABLEDELAYEDEXPANSION
SET ___TEMP=:
FOR /F "delims=" %%A IN ('certutil -hashfile ".\%~1" MD5') DO SET ___TEMP=!___TEMP!%%A
ENDLOCAL & SET ___TEMP=%___TEMP%

ECHO %___TEMP: =%| >NUL 2>&1 FINDSTR /L /I "%~2"
IF NOT ERRORLEVEL 1 EXIT /B 0

ECHO/
ECHO/
ECHO 	%___TEMP%
CALL :FunctionEchoError "%~nx1" has a wrong MD5 hash!
ECHO/
ECHO 	This means that your copy of %~n1 doesn't match the version that this batch file was made for.
ECHO/
ECHO 	Make sure that your copies of %~n1 and of this batch file are both up-to-date.
ECHO/
PAUSE
EXIT /B 1

:FunctionCheckForToolFileMissing
SET ___TEMP=%~1
CALL :FunctionEchoError "%~nx1" not found!
ECHO/
ECHO 	Did you misplace %~n1 or this batch file, or did you forget to install %~n1?
ECHO 	%~nx1 should be located at -/DOOMEternal/%___TEMP:\=/%
ECHO 	This batch file should be located at -/DOOMEternal/EternalModInjector.bat
ECHO/
PAUSE
EXIT /B 1


:FunctionIsThereAnyBackup
IF DEFINED ___BACKED_UP_%~n2 EXIT /B 1
EXIT /B 0


:FunctionRestoreAndDeleteBackup
IF NOT DEFINED ___MODDED_%~n2 GOTO FunctionRestoreAndDeleteBackupDelete

SET ___BACKED_UP_%~n2=
SET ___MODDED_%~n2=
IF EXIST ".\base\%~1.resources.backup" (
	ECHO 		Restoring %~n1.resources...
	>NUL COPY /Y ".\base\%~1.resources.backup" ".\base\%~1.resources"
	IF ERRORLEVEL 1 SET ___TEMP=1
	ECHO 		Deleting %~n1.resources.backup...
	>NUL DEL ".\base\%~1.resources.backup"
) ELSE (
	ECHO 	Couldn't restore %~n1.resources, since %~n1.resources.backup was already deleted...
	SET ___TEMP=1
)
EXIT /B 0

:FunctionRestoreAndDeleteBackupDelete
IF NOT DEFINED ___BACKED_UP_%~n2 EXIT /B 0

SET ___BACKED_UP_%~n2=
IF EXIST ".\base\%~1.resources.backup" (
	ECHO 		Deleting %~n1.resources.backup...
	>NUL DEL ".\base\%~1.resources.backup"
) ELSE (
	ECHO 	%~n1.resources.backup was already deleted...
)
EXIT /B 0





:FirstTimeInformation
ECHO/
ECHO/
ECHO/
ECHO/
ECHO 	First-time information:
ECHO/
ECHO 	This batch file automatically...
ECHO 	- Makes backups of DOOM Eternal's .resources archives the first time that they will be modified.
ECHO 	- Restores ones that were modified last time (to prevent uninstalled mods from lingering around) on subsequent uses.
ECHO 	- Runs DEternal_loadMods to load all mods in -/DOOMEternal/Mods/.
ECHO 	- Runs idRehash to rehash the modified resources' hashes.
ECHO 	- Runs EternalPatcher to apply EXE patches to DOOM Eternal's game executable.
ECHO 	- Launches DOOM Eternal for you once that's all done.
ECHO/
ECHO/
PAUSE

ECHO/
ECHO/
ECHO/
ECHO/
ECHO 	I, Zwip-Zwap Zapony, take no credit for the creation of any of those things, only of this batch file that runs those things.
ECHO/
ECHO 	Full credits go to...
ECHO 	DEternal_loadMods: SutandoTsukai181 for making it in Python (based on a QuickBMS-based unpacker made for Wolfenstein II: The New Colossus by aluigi and edited for DOOM Eternal by one of infogram's friends), and proteh for remaking it in C#
ECHO 	EternalPatcher: proteh for making it (based on EXE patches made by infogram that were based on Cheat Engine patches made by SunBeam, as well as based on EXE patches made by Visual Studio)
ECHO 	idRehash: infogram for making it, and proteh for updating it
ECHO 	DOOM Eternal: Bethesda Softworks, id Software, and everyone else involved, for making and updating it
ECHO/
ECHO/
PAUSE

ECHO/
ECHO/
ECHO/
ECHO/
ECHO 	If any mods are currently installed and/or you have some outdated files when EternalModInjector makes .resources backups, the subsequent backups will contain those mods and/or be outdated.
ECHO/
ECHO 	Don't worry, though; If you ever mess up in a way that results in an already-modified/outdated backup, simply verify/repair DOOM Eternal's installation through Steam or the Bethesda.net Launcher, open "%___CONFIGURATION_FILE:\=/%" in Notepad, change the ":RESET_BACKUPS=0" line to ":RESET_BACKUPS=1", and save the file.
ECHO/
ECHO/
PAUSE

ECHO/
ECHO/
ECHO/
ECHO/
ECHO 	Now, without further ado, press any key to continue one last time, and this batch file will initiate mod-loading mode.
ECHO/
ECHO/
PAUSE

CALL :FunctionWriteConfiguration
ECHO/
ECHO/
GOTO PostFirstTimeInformation





:RestoreArchives
ECHO 	Restoring modified .resources archives...
CALL :FunctionCallForResources :FunctionRestoreArchive
IF ERRORLEVEL 1 EXIT /B 1
GOTO PostRestoreArchives


:FunctionRestoreArchive
IF NOT DEFINED ___MODDED_%~n2 EXIT /B 0

SET ___MODDED_%~n2=

IF NOT DEFINED ___BACKED_UP_%~n2 GOTO FunctionRestoreArchiveNoBackup

ECHO 		Restoring "%~n1.resources"...
>NUL COPY /Y ".\base\%~1.resources.backup" ".\base\%~1.resources"
IF NOT ERRORLEVEL 1 EXIT /B 0

SET ___MODDED_%~n2=1
CALL :FunctionWriteConfiguration

SET ___TEMP=%~1
CALL :FunctionEchoError "%~n1.resources" couldn't be restored!
ECHO/
ECHO 	Something went wrong while trying to copy -/DOOMEternal/base/%___TEMP:\=/%.resources.backup to -/DOOMEternal/base/%___TEMP:\=/%.resources
ECHO/
ECHO 	Please make sure that neither of the files are in use by another program (such as DOOM Eternal itself, Steam, the Bethesda.net Launcher, anti-virus programs, or other software), then run this batch file again.
ECHO/
PAUSE
EXIT /B 1


:FunctionRestoreArchiveNoBackup
CALL :FunctionEchoError "%~n1.resources" was modified last time, but is not backed up!
ECHO/
CALL :FunctionRedownloadInstructions 1
ECHO/
PAUSE
EXIT /B 1





:ModLoader
ECHO 	Checking for mods... (DEternal_loadMods)

SETLOCAL ENABLEDELAYEDEXPANSION
SET ___WILL_BE_MODDED=:
FOR /F "delims=" %%A IN ('.\DEternal_loadMods.exe "." --list-res') DO SET ___WILL_BE_MODDED=!___WILL_BE_MODDED!%%A:
ENDLOCAL & SET ___WILL_BE_MODDED=%___WILL_BE_MODDED:/=\%

IF "%___WILL_BE_MODDED%"==":" GOTO ModLoaderModsDontExist

SET ___WILL_BE_MODDED=%___WILL_BE_MODDED%.\base\meta.resources:
SET ___TEMP=
CALL :FunctionCallForResources :FunctionBackUpArchive
IF ERRORLEVEL 1 EXIT /B 1
CALL :FunctionWriteConfiguration

IF "%___HAS_CHECKED_RESOURCES%"=="2" GOTO ModLoaderLoadMods

ECHO 	Getting vanilla resource hash offsets... (idRehash)
START "" /D ".\base" /MIN /WAIT ".\base\idRehash.exe" --getoffsets
IF ERRORLEVEL 1 GOTO ModLoaderIdRehashGetError
SET ___HAS_CHECKED_RESOURCES=2

:ModLoaderLoadMods
ECHO 	Loading mods... (DEternal_loadMods)
.\DEternal_loadMods.exe "."
IF NOT ERRORLEVEL 0 GOTO ModLoaderLoadModsError
IF ERRORLEVEL 1 GOTO ModLoaderLoadModsError

ECHO 	Rehashing resource hashes... (idRehash)
START "" /D ".\base" /MIN /WAIT ".\base\idRehash.exe"
IF ERRORLEVEL 1 GOTO ModLoaderIdRehashSetError

GOTO ModLoaderPatchGame

:ModLoaderModsDontExist
ECHO 		No mods were found in the "Mods" folder...
ECHO 		The .resources archives were restored, so mods should be uninstalled now...

:ModLoaderPatchGame
IF DEFINED ___GAME_HAS_BEEN_PATCHED GOTO ModLoaderLaunchGame

ECHO 	Patching the game EXE... (EternalPatcher)
START "" /MIN /WAIT ".\EternalPatcher.exe" --patch ".\%___GAME_EXE%"

IF NOT DEFINED ___CERTUTIL_EXISTS GOTO ModLoaderLaunchGame

ECHO 	Verifying that EternalPatcher worked...

SETLOCAL ENABLEDELAYEDEXPANSION
SET ___TEMP=:
FOR /F "delims=" %%A IN ('certutil -hashfile ".\%___GAME_EXE%" MD5') DO SET ___TEMP=!___TEMP!%%A
ENDLOCAL & SET ___TEMP=%___TEMP%

ECHO %___TEMP: =%| >NUL 2>&1 FINDSTR /L /I "%___PATCHED_GAME_MD5%"
IF NOT ERRORLEVEL 1 GOTO ModLoaderLaunchGame

CALL :FunctionEchoError EternalPatcher didn't work!
ECHO/
ECHO 	Please make sure that %___GAME_EXE:\=/% is not in use by another program (such as DOOM Eternal itself, Steam, the Bethesda.net Launcher, anti-virus programs, or other software), then run this batch file again.
ECHO/
ECHO 	If that doesn't work, try rebooting your computer and running this batch file again afterwards.
ECHO/
PAUSE
EXIT /B 1

:ModLoaderLaunchGame
ECHO/
ECHO/

IF NOT DEFINED ___AUTO_LAUNCH_GAME GOTO ModLoaderDontLaunchGame

IF DEFINED ___GAME_PARAMETERS (
	START "DOOM Eternal" ".\%___GAME_EXE%" %* %___GAME_PARAMETERS%
) ELSE START "DOOM Eternal" ".\%___GAME_EXE%" %*

ECHO 	DOOM Eternal has been launched!
ECHO/
ECHO 	This batch file will auto-close in 5 seconds.
ECHO 	Press [Ctrl+C] to keep it open to view the batch output above.
ECHO/
ECHO/
>NUL TIMEOUT /T 5 /NOBREAK
EXIT /B 0

:ModLoaderDontLaunchGame
ECHO 	Mods have been installed!
ECHO/
ECHO 	However, DOOM Eternal has not been launched, as you've disabled that.
ECHO 	If you want to re-enable automatic game launching, open "%___CONFIGURATION_FILE:\=/%" in Notepad, change ":AUTO_LAUNCH_GAME=0" to ":AUTO_LAUNCH_GAME=1", and save the file.
ECHO/
ECHO/
PAUSE
EXIT /B 0


:ModLoaderIdRehashGetError
ECHO/
ECHO/
START "" /D ".\base" /MIN /WAIT /B ".\base\idRehash.exe" --getoffsets
CALL :FunctionEchoError idRehash couldn't find the resource hash offsets!
ECHO/
CALL :FunctionRedownloadInstructions 1
ECHO/
PAUSE
EXIT /B 1


:ModLoaderLoadModsError
CALL :FunctionEchoError DEternal_loadMods didn't work!
ECHO/
ECHO 	Make sure that you use -/DOOMEternal/Mods[1;4m/gameresources/[0m-, not just -/DOOMEternal/Mods[1;4m/[0m-, for loose/extracted mod files.
ECHO 	(Zip-archive mods should still just be in -/DOOMEternal/Mods/; only loose/extracted mods should be in a "gameresources" sub-folder.)
ECHO 	Additionally, please make sure that none of the .resources archives are in use by another program (such as DOOM Eternal itself, Steam, the Bethesda.net Launcher, anti-virus programs, or other software), then run this batch file again.
ECHO/
ECHO 	You may also run into other problems than that, which won't be covered here.
ECHO 	In such cases, try rebooting your computer and running this batch file again afterwards.
ECHO/
PAUSE
EXIT /B 1


:ModLoaderIdRehashSetError
CALL :FunctionEchoError idRehash couldn't generate new resource hashes!
ECHO/
ECHO 	Please make sure that none of the .resources archives are in use by another program (such as DOOM Eternal itself, Steam, the Bethesda.net Launcher, anti-virus programs, or other software), then run this batch file again.
ECHO/
ECHO 	If that doesn't work, try rebooting your computer and running this batch file again afterwards.
ECHO/
PAUSE
EXIT /B 1





:FunctionBackUpArchive
ECHO %___WILL_BE_MODDED%| >NUL 2>&1 FINDSTR /L ":.\base\%~1.resources:"
IF ERRORLEVEL 1 EXIT /B 0

SET ___MODDED_%~n2=1

IF DEFINED ___BACKED_UP_%~n2 EXIT /B 0

IF NOT DEFINED ___TEMP (
	ECHO 		Backing up .resources archives...
	SET ___TEMP=1
)

SET ___BACKED_UP_%~n2=1
ECHO 			Backing up "%~n1.resources"...
>NUL COPY /Y ".\base\%~1.resources" ".\base\%~1.resources.backup"
IF NOT ERRORLEVEL 1 EXIT /B 0

SET ___BACKED_UP_%~n2=
CALL :FunctionCallForResources :FunctionInitializeModdedVariable
CALL :FunctionWriteConfiguration

SET ___TEMP=%~1
CALL :FunctionEchoError "%~n1.resources" couldn't be backed up!
ECHO/
ECHO 	Something went wrong while trying to copy -/DOOMEternal/base/%___TEMP:\=/%.resources to -/DOOMEternal/base/%___TEMP:\=/%.resources.backup
ECHO/
ECHO 	Please make sure that neither of the files are in use by another program (such as DOOM Eternal itself, Steam, the Bethesda.net Launcher, anti-virus programs, or other software), then run this batch file again.
ECHO/
PAUSE
EXIT /B 1


:FunctionCallForResources
IF NOT DEFINED ___OWNS_CAMPAIGN GOTO FunctionCallForResourcesPostCampaignA

CALL %1 game\sp\e1m1_intro\e1m1_intro                               e1m1_intro
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e1m1_intro\e1m1_intro_patch1                        e1m1_intro_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e1m1_intro\e1m1_intro_patch2                        e1m1_intro_patch2
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e1m2_battle\e1m2_battle                             e1m2_battle
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e1m2_battle\e1m2_battle_patch1                      e1m2_battle_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e1m2_battle\e1m2_battle_patch2                      e1m2_battle_patch2
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e1m3_cult\e1m3_cult                                 e1m3_cult
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e1m3_cult\e1m3_cult_patch1                          e1m3_cult_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e1m3_cult\e1m3_cult_patch2                          e1m3_cult_patch2
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e1m4_boss\e1m4_boss                                 e1m4_boss
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e1m4_boss\e1m4_boss_patch1                          e1m4_boss_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e1m4_boss\e1m4_boss_patch2                          e1m4_boss_patch2
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e2m1_nest\e2m1_nest                                 e2m1_nest
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e2m1_nest\e2m1_nest_patch1                          e2m1_nest_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e2m1_nest\e2m1_nest_patch2                          e2m1_nest_patch2
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e2m2_base\e2m2_base                                 e2m2_base
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e2m2_base\e2m2_base_patch1                          e2m2_base_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e2m2_base\e2m2_base_patch2                          e2m2_base_patch2
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e2m3_core\e2m3_core                                 e2m3_core
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e2m3_core\e2m3_core_patch1                          e2m3_core_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e2m3_core\e2m3_core_patch2                          e2m3_core_patch2
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e2m4_boss\e2m4_boss                                 e2m4_boss
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e2m4_boss\e2m4_boss_patch1                          e2m4_boss_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m1_slayer\e3m1_slayer                             e3m1_slayer
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m1_slayer\e3m1_slayer_patch1                      e3m1_slayer_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m1_slayer\e3m1_slayer_patch2                      e3m1_slayer_patch2
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m2_hell\e3m2_hell                                 e3m2_hell
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m2_hell\e3m2_hell_patch1                          e3m2_hell_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m2_hell\e3m2_hell_patch2                          e3m2_hell_patch2
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m2_hell_b\e3m2_hell_b                             e3m2_hell_b
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m2_hell_b\e3m2_hell_b_patch1                      e3m2_hell_b_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m2_hell_b\e3m2_hell_b_patch2                      e3m2_hell_b_patch2
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m3_maykr\e3m3_maykr                               e3m3_maykr
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m3_maykr\e3m3_maykr_patch1                        e3m3_maykr_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m3_maykr\e3m3_maykr_patch2                        e3m3_maykr_patch2
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m4_boss\e3m4_boss                                 e3m4_boss
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m4_boss\e3m4_boss_patch1                          e3m4_boss_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m4_boss\e3m4_boss_patch2                          e3m4_boss_patch2
IF ERRORLEVEL 1 EXIT /B 1

:FunctionCallForResourcesPostCampaignA
IF NOT DEFINED ___OWNS_ANCIENT_GODS_ONE GOTO FunctionCallForResourcesPostAncientGodsOneA

CALL %1 game\dlc\e4m1_rig\e4m1_rig                                  e4m1_rig
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\dlc\e4m1_rig\e4m1_rig_patch1                           e4m1_rig_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\dlc\e4m1_rig\e4m1_rig_patch2                           e4m1_rig_patch2
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\dlc\e4m2_swamp\e4m2_swamp                              e4m2_swamp
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\dlc\e4m2_swamp\e4m2_swamp_patch1                       e4m2_swamp_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\dlc\e4m2_swamp\e4m2_swamp_patch2                       e4m2_swamp_patch2
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\dlc\e4m3_mcity\e4m3_mcity                              e4m3_mcity
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\dlc\e4m3_mcity\e4m3_mcity_patch1                       e4m3_mcity_patch1
IF ERRORLEVEL 1 EXIT /B 1

:FunctionCallForResourcesPostAncientGodsOneA
CALL %1 gameresources                                               gameresources
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 gameresources_patch1                                        gameresources_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 gameresources_patch2                                        gameresources_patch2
IF ERRORLEVEL 1 EXIT /B 1

IF NOT DEFINED ___OWNS_ANCIENT_GODS_ONE GOTO FunctionCallForResourcesPostAncientGodsOneB

CALL %1 game\dlc\hub\hub                                            dlc_hub
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\dlc\hub\hub_patch1                                     dlc_hub_patch1
IF ERRORLEVEL 1 EXIT /B 1

:FunctionCallForResourcesPostAncientGodsOneB
IF NOT DEFINED ___OWNS_CAMPAIGN GOTO FunctionCallForResourcesPostCampaignB

CALL %1 game\hub\hub                                                hub
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\hub\hub_patch1                                         hub_patch1
IF ERRORLEVEL 1 EXIT /B 1

:FunctionCallForResourcesPostCampaignB
CALL %1 meta                                                        meta
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\pvp\pvp_bronco\pvp_bronco                              pvp_bronco
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\pvp\pvp_bronco\pvp_bronco_patch1                       pvp_bronco_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\pvp\pvp_deathvalley\pvp_deathvalley                    pvp_deathvalley
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\pvp\pvp_deathvalley\pvp_deathvalley_patch1             pvp_deathvalley_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\pvp\pvp_inferno\pvp_inferno                            pvp_inferno
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\pvp\pvp_inferno\pvp_inferno_patch1                     pvp_inferno_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\pvp\pvp_laser\pvp_laser                                pvp_laser
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\pvp\pvp_laser\pvp_laser_patch1                         pvp_laser_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\pvp\pvp_shrapnel\pvp_shrapnel                          pvp_shrapnel
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\pvp\pvp_shrapnel\pvp_shrapnel_patch1                   pvp_shrapnel_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\pvp\pvp_thunder\pvp_thunder                            pvp_thunder
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\pvp\pvp_thunder\pvp_thunder_patch1                     pvp_thunder_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\pvp\pvp_zap\pvp_zap                                    pvp_zap
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\pvp\pvp_zap\pvp_zap_patch1                             pvp_zap_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\shell\shell                                            shell
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\shell\shell_patch1                                     shell_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\tutorials\tutorial_demons                              tutorial_demons
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\tutorials\tutorial_pvp_laser\tutorial_pvp_laser        tutorial_pvp_laser
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\tutorials\tutorial_pvp_laser\tutorial_pvp_laser_patch1 tutorial_pvp_laser_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\tutorials\tutorial_sp                                  tutorial_sp
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 warehouse                                                   warehouse
IF ERRORLEVEL 1 EXIT /B 1

EXIT /B 0


:FunctionCheckIfModsExist
FOR %%A IN (".\Mods\*.zip") DO EXIT /B 1
FOR /D %%A IN (".\Mods\*") DO EXIT /B 1
EXIT /B 0


:FunctionEchoError
ECHO/
ECHO/
ECHO 	[1;41;93mERROR: %*[0m 
EXIT /B 0


:FunctionInitializeBackupVariable
SET ___BACKED_UP_%~n2=
EXIT /B 0


:FunctionInitializeModdedVariable
SET ___MODDED_%~n2=
EXIT /B 0


:FunctionRedownloadInstructions
IF "%~1"=="1" (
	ECHO 	Please verify/repair DOOM Eternal's installation through Steam or the Bethesda.net Launcher, open "%___CONFIGURATION_FILE:\=/%" in Notepad, change ":RESET_BACKUPS=0" to ":RESET_BACKUPS=1", save the file, and choose to update the backup files the next time that you run this batch file.
	ECHO/
	ECHO/
)
IF EXIST ".\steam_api64.dll" (
	ECHO 	To verify DOOM Eternal's installation using Steam, right-click DOOM Eternal in your Steam library, choose "Properties..." ^> "Local Files" ^> "Verify Integrity of Game Files...", and wait for Steam to redownload the default files.
) ELSE ECHO 	To repair DOOM Eternal's installation using the Bethesda.net Launcher, click on DOOM Eternal's game icon in the launcher, click "Game Options" near the top-right, choose "Scan and Repair", and wait for the Bethesda.net Launcher to redownload the default files.
EXIT /B 0


:FunctionWriteConfiguration
>".\%___CONFIGURATION_FILE%" ECHO :ASSET_VERSION=%___ASSET_VERSION%
IF DEFINED ___AUTO_LAUNCH_GAME (
	>>".\%___CONFIGURATION_FILE%" ECHO :AUTO_LAUNCH_GAME=1
) ELSE (
	>>".\%___CONFIGURATION_FILE%" ECHO :AUTO_LAUNCH_GAME=0
)
IF DEFINED ___GAME_PARAMETERS (
	>>".\%___CONFIGURATION_FILE%" ECHO :GAME_PARAMETERS=%___GAME_PARAMETERS%
) ELSE (
	>>".\%___CONFIGURATION_FILE%" ECHO :GAME_PARAMETERS=
)
IF DEFINED ___HAS_CHECKED_RESOURCES (
	>>".\%___CONFIGURATION_FILE%" ECHO :HAS_CHECKED_RESOURCES=%___HAS_CHECKED_RESOURCES%
) ELSE (
	>>".\%___CONFIGURATION_FILE%" ECHO :HAS_CHECKED_RESOURCES=0
)
>>".\%___CONFIGURATION_FILE%" ECHO :HAS_READ_FIRST_TIME=1
>>".\%___CONFIGURATION_FILE%" ECHO :RESET_BACKUPS=0
>>".\%___CONFIGURATION_FILE%" ECHO/
CALL :FunctionCallForResources :FunctionWriteConfigurationResources
EXIT /B 0

:FunctionWriteConfigurationResources
IF DEFINED ___BACKED_UP_%~n2 >>".\%___CONFIGURATION_FILE%" ECHO %~n2.backup
IF DEFINED ___MODDED_%~n2    >>".\%___CONFIGURATION_FILE%" ECHO %~n2.resources
EXIT /B 0


TODO Instead of telling the user to set ":RESET_BACKUPS" to "1" manually, set it to a different number for them and have the batch file not let them say "no" to updating resources
TODO Get rid of ___HAS_CHECKED_RESOURCES 2, and only use 1? By putting the "idRehash get hashes" into the needed files check? Once DOOM Eternal v5.0 releases?