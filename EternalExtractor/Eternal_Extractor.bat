@ECHO OFF


SETLOCAL
SET ___BATCH_DATE=2020-11-22
TITLE Eternal Extractor.bat    (%___BATCH_DATE%)
ECHO/
ECHO 	[45;95m                                             [0m 
ECHO 	[45;95m  Eternal Extractor.bat                      [0m 
ECHO 	[45;95m      by Zwip-Zwap Zapony, dated %___BATCH_DATE%  [0m 
ECHO 	[45;95m                                             [0m 
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


SET ___GAME_DIRECTORY=
SET ___OUTPUT_DIRECTORY=
SET ___QUICKBMS_DIRECTORY=
SET ___QUICKBMS_SCRIPT=

SET CD=

2>NUL CD /D %~dp0





ECHO 	This batch file runs QuickBMS to extract the contents of all of DOOM Eternal's *.resources archives in one go.
ECHO/
ECHO 	If you only want to use others' DOOM Eternal mods, not make your own, this isn't useful for you; simply close this window now.
ECHO/
ECHO/
ECHO/
ECHO/
ECHO 	Otherwise, please input the full filepath to your DOOM Eternal installation:

CALL :FunctionAskForDirectory ___GAME_DIRECTORY

IF NOT EXIST "%___GAME_DIRECTORY%\DOOMEternalx64vk.exe" GOTO MissingDoomEternal
IF NOT EXIST "%___GAME_DIRECTORY%\base\gameresources.resources" GOTO MissingResources


ECHO/
ECHO 	DOOM Eternal found!
ECHO/
ECHO/
ECHO/
ECHO/
ECHO 	Please input the full filepath to your QuickBMS installation:

CALL :FunctionAskForDirectory ___QUICKBMS_DIRECTORY

IF NOT EXIST "%___QUICKBMS_DIRECTORY%\quickbms_4gb_files.exe" GOTO MissingQuickBMS
IF EXIST "%___QUICKBMS_DIRECTORY%\doometernal.txt"     SET ___QUICKBMS_SCRIPT=doometernal.txt
IF EXIST "%___QUICKBMS_DIRECTORY%\doometernal.bms.txt" SET ___QUICKBMS_SCRIPT=doometernal.bms.txt
IF EXIST "%___QUICKBMS_DIRECTORY%\doometernal.bms"     SET ___QUICKBMS_SCRIPT=doometernal.bms
IF NOT DEFINED ___QUICKBMS_SCRIPT GOTO MissingScript


ECHO/
ECHO 	QuickBMS found!
ECHO/
ECHO/
ECHO/
ECHO/
ECHO 	Please input the full filepath to where you want to extract resources to.
ECHO 	Make sure that this filepath leads to a folder that's either empty or nonexistent:

CALL :FunctionAskForDirectory ___OUTPUT_DIRECTORY

FOR %%A IN ("%___OUTPUT_DIRECTORY%\*") DO IF NOT "%%~nxA"=="Eternal Extractor.bat" IF NOT "%%~nxA"=="Eternal_Extractor.bat" GOTO OutputIsntEmpty
FOR /D %%A IN ("%___OUTPUT_DIRECTORY%\*") DO GOTO OutputIsntEmpty


ECHO/
ECHO 	Output directory set!
ECHO/
ECHO/
ECHO/
ECHO/
ECHO 	The expected filesize required to extract DOOM Eternal v3.1's resources is 12.2 gigabytes. (Expect more in later updates.)
ECHO/
ECHO 	[1mPlease note that extracting all *.resources archives [4mmight[0;1m take hours, depending on your CPU and storage speed![0m
ECHO/
ECHO 	And, just to make sure, does this look correct?
ECHO/
CALL :FunctionEchoPath "DOOM Eternal:" "%___GAME_DIRECTORY%"
CALL :FunctionEchoPath "QuickBMS:    " "%___QUICKBMS_DIRECTORY%"
CALL :FunctionEchoPath "Output:      " "%___OUTPUT_DIRECTORY%"
ECHO/
ECHO/
ECHO (Press [1m[Y][0m to extract *.resources archives to the output folder.)
<NUL SET /P ="(Press [1m[N][0m to abort and close this batch file.) "
CHOICE /C YN /N
ECHO/
ECHO/

IF NOT ERRORLEVEL 1 EXIT /B 1
IF ERRORLEVEL 2 EXIT /B 1

FOR %%A IN ("%___GAME_DIRECTORY%\base\*.resources") DO CALL :FunctionExtractResources "%%~fA"
IF NOT EXIST "%___OUTPUT_DIRECTORY%\gameresources\" GOTO MissingOutput
FOR /R "%___GAME_DIRECTORY%\base\game" %%A IN ("*.resources") DO CALL :FunctionExtractResources "%%~fA"

TITLE Eternal Extractor.bat    (%___BATCH_DATE%)
ECHO/
ECHO/
ECHO/
ECHO/
ECHO 	Finished extracting all *.resources archives!
CALL :FunctionEchoPath "You can find the output in" "%___OUTPUT_DIRECTORY%"
ECHO/
ECHO 	Do you want to open the output folder now?
ECHO/
ECHO/
ECHO (Press [1m[Y][0m to close this batch file and open File Explorer in the output folder.)
<NUL SET /P ="(Press [1m[N][0m to close this batch file without opening File Explorer.) "
CHOICE /C YN /N

IF NOT ERRORLEVEL 1 EXIT /B 0
IF ERRORLEVEL 2 EXIT /B 0

explorer "%___OUTPUT_DIRECTORY%"

EXIT /B 0





:MissingDoomEternal
CALL :FunctionEchoError "DOOMEternalx64vk.exe" not found!
ECHO/
ECHO 	Is your DOOM Eternal installation incomplete, or did you use a wrong path?
ECHO 	DOOMEternalx64vk.exe should be located at -/DOOMEternal/DOOMEternalx64vk.exe
CALL :FunctionEchoPath "The path that you gave to -/DOOMEternal/ was" "%___GAME_DIRECTORY%"
ECHO/
PAUSE
EXIT /B 1


:MissingOutput
TITLE Eternal Extractor.bat    (%___BATCH_DATE%)
ECHO/
ECHO/
CALL :FunctionEchoError Couldn't create output directory!
ECHO/
ECHO 	Are you out of space on your storage medium, or did you use an invalid output path?
CALL :FunctionEchoPath "The output directory path that you gave was" "%___OUTPUT_DIRECTORY%"
ECHO/
PAUSE
EXIT /B 1


:MissingResources
CALL :FunctionEchoError "gameresources.resources" not found!
ECHO/
ECHO 	Is your DOOM Eternal installation incomplete, or did you use a wrong path?
ECHO 	gameresources.resources should be located at -/DOOMEternal/base/gameresources.resources
CALL :FunctionEchoPath "The path that you gave to -/DOOMEternal/ was" "%___GAME_DIRECTORY%"
ECHO/
PAUSE
EXIT /B 1


:MissingQuickBMS
CALL :FunctionEchoError "quickbms_4gb_files.exe" not found!
ECHO/
ECHO 	Is your QuickBMS installation incomplete, or did you use a wrong path?
ECHO 	quickbms_4gb_files.exe should be located at -/QuickBMS/quickbms_4gb_files.exe
CALL :FunctionEchoPath "The path that you gave to -/QuickBMS/ was" "%___QUICKBMS_DIRECTORY%"
ECHO/
PAUSE
EXIT /B 1


:MissingScript
CALL :FunctionEchoError "doometernal.bms" not found!
ECHO/
ECHO 	Did you forget to make and save it manually?
ECHO 	doometernal.bms should be located at -/QuickBMS/doometernal.bms
CALL :FunctionEchoPath "The path that you gave to -/QuickBMS/ was" "%___QUICKBMS_DIRECTORY%"
ECHO/
ECHO 	You can find doometernal.bms at https://zenhax.com/viewtopic.php?p=54753&sid=3f95e61ed0a5ad86088eb53e66bbfbd2#p54753
ECHO 	You must copy and paste it into a raw text editor like Notepad, then save it as "doometernal.bms" in your QuickBMS installation.
ECHO/
PAUSE
EXIT /B 1


:OutputIsntEmpty
CALL :FunctionEchoError Output directory not empty!
ECHO/
ECHO 	To avoid inconveniencing you, this batch file won't extract to an output directory that already has files and/or folders in it.
CALL :FunctionEchoPath "The output directory path that you gave was" "%___OUTPUT_DIRECTORY%"
ECHO/
PAUSE
EXIT /B 1





:FunctionAskForDirectory
SET /P ___TEMP=
IF NOT DEFINED ___TEMP SET ___TEMP=.

SET ___TEMP=%___TEMP:"=%
IF NOT DEFINED ___TEMP SET ___TEMP=.
SET ___TEMP=%___TEMP:/=\%
IF NOT DEFINED ___TEMP SET ___TEMP=.

IF "%___TEMP:~-1%"=="\" SET ___TEMP=%___TEMP:~0,-1%

IF NOT DEFINED ___TEMP (
	SET %1=.
) ELSE SET %1=%___TEMP%

EXIT /B 0


:FunctionEchoError
ECHO/
ECHO/
ECHO 	[1;41;93mERROR: %*[0m 
EXIT /B 0


:FunctionEchoPath
SET ___TEMP=%~2
IF "%___TEMP:~0,2%"=="." GOTO FunctionEchoPathCD
ECHO 	%~1 %___TEMP:\=/%/
EXIT /B 0
:FunctionEchoPathCD
ECHO 	%~1 %CD:\=/%/
EXIT /B 0


:FunctionExtractResources
SET ___TEMP=%~p1

IF "%___TEMP:~-9%"=="\dlc\hub\" (
	SET ___TEMP=dlc_%~n1
) ELSE SET ___TEMP=%~n1

"%___QUICKBMS_DIRECTORY%\quickbms_4gb_files.exe" -o -Y "%___QUICKBMS_DIRECTORY%\%___QUICKBMS_SCRIPT%" "%~1" "%___OUTPUT_DIRECTORY%\%___TEMP%"
EXIT /B 0
