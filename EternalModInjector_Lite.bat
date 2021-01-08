@ECHO OFF


TITLE EternalModInjector - Lite    (2021-01-08)
ECHO/
ECHO 	[44;96m                                             [0m 
ECHO 	[44;96m  EternalModInjector - Lite Edition          [0m 
ECHO 	[44;96m      by Zwip-Zwap Zapony, dated 2021-01-08  [0m 
ECHO 	[44;96m          for DOOM Eternal Update 4.1        [0m 
ECHO 	[44;96m                                             [0m 
ECHO/
ECHO/
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


2>NUL CD /D %~dp0

IF NOT EXIST ".\DOOMEternalx64vk.exe" GOTO MissingGame
IF NOT EXIST ".\DEternal_loadMods.exe" GOTO MissingDEternalLoadMods
IF NOT EXIST ".\idRehash.exe" GOTO MissingIdRehash





ECHO 	Please choose what you want to do.
ECHO/
ECHO 	(Deleting backups is necessary after vanilla game updates, but should only be done after you've verified/repaired DOOM Eternal through Steam or the Bethesda.net Launcher first.)
ECHO/
ECHO/
ECHO (Press [1m[L][0m to load mods.)
ECHO (Press [1m[D][0m to delete .resources backups.)
ECHO (Press [1m[N][0m to close this batch file.)
CHOICE /C LDN /N
ECHO/
ECHO/

IF NOT ERRORLEVEL 1 EXIT /B 1
IF ERRORLEVEL 3 EXIT /B 1

IF ERRORLEVEL 2 GOTO DeleteBackups





:ModLoader
ECHO 	Restoring .resources archives...
CALL :FunctionCallForResources :FunctionBackUpOrRestoreArchive
IF ERRORLEVEL 1 EXIT /B 1

ECHO/
ECHO 	Getting vanilla resource hash offsets... (idRehash)
START "" /D ".\base" /MIN /WAIT ".\base\idRehash.exe" --getoffsets
IF ERRORLEVEL 1 (
	ECHO/
	ECHO/
	CALL :FunctionEchoError idRehash couldn't find the resource hash offsets!
	ECHO/
	PAUSE
	EXIT /B 1
)

ECHO/
ECHO 	Loading mods... (DEternal_loadMods)
.\DEternal_loadMods.exe "."
IF NOT ERRORLEVEL 0 (
	ECHO/
	ECHO/
	CALL :FunctionEchoError DEternal_loadMods didn't work!
	ECHO/
	PAUSE
	EXIT /B 1
)
IF ERRORLEVEL 1 (
	ECHO/
	ECHO/
	CALL :FunctionEchoError DEternal_loadMods didn't work!
	ECHO/
	PAUSE
	EXIT /B 1
)

ECHO/
ECHO 	Rehashing resource hashes... (idRehash)
START "" /D ".\base" /MIN /WAIT ".\base\idRehash.exe"
IF ERRORLEVEL 1 (
	ECHO/
	ECHO/
	CALL :FunctionEchoError idRehash couldn't generate new resource hashes!
	ECHO/
	PAUSE
	EXIT /B 1
)

ECHO/
ECHO/
ECHO/
ECHO/
ECHO 	Mods have been installed!
ECHO/
ECHO 	Please use EternalPatcher to patch DOOMEternalx64vk.exe if you haven't already.
ECHO/
ECHO 	After that, you may launch DOOM Eternal.
ECHO 	This Lite Edition of EternalModInjector won't auto-launch it for you.
ECHO/
ECHO/
PAUSE
EXIT /B 0





:DeleteBackups
ECHO 	Deleting backups...
CALL :FunctionCallForResources :FunctionDeleteBackup
ECHO 	The backups have been deleted.
ECHO/
ECHO/
ECHO 	Would you like to load mods now?
ECHO/
ECHO/
ECHO (Press [1m[Y][0m to load mods.)
ECHO (Press [1m[N][0m to close this batch file.)
CHOICE /C YN /N
ECHO/
ECHO/

IF NOT ERRORLEVEL 1 EXIT /B 1
IF ERRORLEVEL 2 EXIT /B 1

GOTO ModLoader





:MissingDEternalLoadMods
CALL :FunctionEchoError "DEternal_loadMods.exe" not found!
ECHO/
ECHO 	Did you misplace DEternal_loadMods or this batch file, or did you forget to install DEternal_loadMods?
ECHO 	DEternal_loadMods should be located at -/DOOMEternal/DEternal_loadMods.exe
ECHO 	This batch file should be located at -/DOOMEternal/EternalModInjector Lite.bat
ECHO/
PAUSE
EXIT /B 1


:MissingGame
CALL :FunctionEchoError "DOOMEternalx64vk.exe" not found!
ECHO/
ECHO 	Did you misplace this batch file, or is your DOOM Eternal installation incomplete?
ECHO 	DOOMEternalx64vk.exe should be located at -/DOOMEternal/DOOMEternalx64vk.exe
ECHO 	This batch file should be located at -/DOOMEternal/EternalModInjector Lite.bat
ECHO/
PAUSE
EXIT /B 1


:MissingIdRehash
CALL :FunctionEchoError "base/idRehash.exe" not found!
ECHO/
ECHO 	Did you misplace idRehash or this batch file, or did you forget to install idRehash?
ECHO 	idRehash should be located at -/DOOMEternal/base/idRehash.exe
ECHO 	This batch file should be located at -/DOOMEternal/EternalModInjector Lite.bat
ECHO/
PAUSE
EXIT /B 1





:FunctionBackUpOrRestoreArchive
IF EXIST ".\base\%~1.resources.backup" (
	ECHO 		Restoring "%~1.resources"...
	>NUL COPY /Y ".\base\%~1.resources.backup" ".\base\%~1.resources"
	IF NOT ERRORLEVEL 1 EXIT /B 0
	ECHO/
	ECHO/
	CALL :FunctionEchoError "%~n1.resources" couldn't be restored!
	ECHO/
	PAUSE
	EXIT /B 1
) ELSE IF EXIST ".\base\%~1.resources" (
	ECHO 		Backing up "%~1.resources"...
	>NUL COPY /Y ".\base\%~1.resources" ".\base\%~1.resources.backup"
	IF NOT ERRORLEVEL 1 EXIT /B 0
	ECHO/
	ECHO/
	CALL :FunctionEchoError "%~n1.resources" couldn't be backed up!
	ECHO/
	PAUSE
	EXIT /B 1
)
ECHO/
ECHO/
CALL :FunctionEchoError "%~n1.resources" not found!
ECHO/
PAUSE
EXIT /B 1


:FunctionCallForResources
CALL %1 game\sp\e1m1_intro\e1m1_intro
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e1m1_intro\e1m1_intro_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e1m1_intro\e1m1_intro_patch2
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e1m2_battle\e1m2_battle
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e1m2_battle\e1m2_battle_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e1m2_battle\e1m2_battle_patch2
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e1m3_cult\e1m3_cult
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e1m3_cult\e1m3_cult_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e1m3_cult\e1m3_cult_patch2
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e1m4_boss\e1m4_boss
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e1m4_boss\e1m4_boss_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e1m4_boss\e1m4_boss_patch2
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e2m1_nest\e2m1_nest
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e2m1_nest\e2m1_nest_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e2m1_nest\e2m1_nest_patch2
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e2m2_base\e2m2_base
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e2m2_base\e2m2_base_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e2m2_base\e2m2_base_patch2
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e2m3_core\e2m3_core
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e2m3_core\e2m3_core_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e2m3_core\e2m3_core_patch2
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e2m4_boss\e2m4_boss
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e2m4_boss\e2m4_boss_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m1_slayer\e3m1_slayer
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m1_slayer\e3m1_slayer_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m1_slayer\e3m1_slayer_patch2
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m2_hell\e3m2_hell
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m2_hell\e3m2_hell_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m2_hell\e3m2_hell_patch2
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m2_hell_b\e3m2_hell_b
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m2_hell_b\e3m2_hell_b_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m2_hell_b\e3m2_hell_b_patch2
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m3_maykr\e3m3_maykr
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m3_maykr\e3m3_maykr_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m3_maykr\e3m3_maykr_patch2
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m4_boss\e3m4_boss
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m4_boss\e3m4_boss_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\sp\e3m4_boss\e3m4_boss_patch2
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\dlc\e4m1_rig\e4m1_rig
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\dlc\e4m1_rig\e4m1_rig_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\dlc\e4m1_rig\e4m1_rig_patch2
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\dlc\e4m2_swamp\e4m2_swamp
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\dlc\e4m2_swamp\e4m2_swamp_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\dlc\e4m2_swamp\e4m2_swamp_patch2
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\dlc\e4m3_mcity\e4m3_mcity
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\dlc\e4m3_mcity\e4m3_mcity_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 gameresources
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 gameresources_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 gameresources_patch2
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\dlc\hub\hub
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\dlc\hub\hub_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\hub\hub
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\hub\hub_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 meta
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\pvp\pvp_bronco\pvp_bronco
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\pvp\pvp_bronco\pvp_bronco_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\pvp\pvp_deathvalley\pvp_deathvalley
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\pvp\pvp_deathvalley\pvp_deathvalley_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\pvp\pvp_inferno\pvp_inferno
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\pvp\pvp_inferno\pvp_inferno_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\pvp\pvp_laser\pvp_laser
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\pvp\pvp_laser\pvp_laser_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\pvp\pvp_shrapnel\pvp_shrapnel
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\pvp\pvp_shrapnel\pvp_shrapnel_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\pvp\pvp_thunder\pvp_thunder
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\pvp\pvp_thunder\pvp_thunder_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\pvp\pvp_zap\pvp_zap
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\pvp\pvp_zap\pvp_zap_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\shell\shell
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\shell\shell_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\tutorials\tutorial_demons
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\tutorials\tutorial_pvp_laser\tutorial_pvp_laser
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\tutorials\tutorial_pvp_laser\tutorial_pvp_laser_patch1
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 game\tutorials\tutorial_sp
IF ERRORLEVEL 1 EXIT /B 1
CALL %1 warehouse
IF ERRORLEVEL 1 EXIT /B 1

EXIT /B 0


:FunctionDeleteBackup
IF EXIST ".\base\%~1.resources.backup" (
	ECHO 		Deleting %~n1.resources.backup...
	>NUL DEL ".\base\%~1.resources.backup"
) ELSE (
	ECHO 		%~n1.resources.backup was already deleted...
)
EXIT /B 0


:FunctionEchoError
ECHO 	[1;41;93mERROR: %*[0m 
EXIT /B 0