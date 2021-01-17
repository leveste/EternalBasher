@echo off
setlocal enableextensions
cd /d "%~dp0"

:: Set scriptdir and make sure it ends with \
set "scriptdir=%~dp0"
if not "%scriptdir:~-1%"=="\" set "scriptdir=%scriptdir%\"

:: Check for config file
if not exist "%scriptdir%ModLoader_to_Meathook.cfg" goto CreateConfig

:: Make sure the config file is valid
:ConfigVerification
(
	set /p gamedir=
	set /p replace=
) <"%scriptdir%ModLoader_to_Meathook.cfg"
echo.%gamedir%|findstr /C:"GAMEDIR" >nul 2>&1
if errorlevel 1 goto CreateConfig
echo.%replace%|findstr /C:"REPLACE" >nul 2>&1
if errorlevel 1 goto CreateConfig
set "gamedir=%gamedir:GAMEDIR =%"
if not "%gamedir:~-1%"=="\" set "gamedir=%gamedir%\"
if not exist "%gamedir%DOOMEternalx64vk.exe" goto CreateConfig
set "replace=%replace:REPLACE =%"
set "replace=%replace: =%"
goto Verification

:: Creates the config file
:CreateConfig
set /p "gamedir=Input your DOOMEternal directory (e.g.: C:\Program Files (x86)\Steam\steamapps\common\DOOMEternal): "
if not "%gamedir:~-1%"=="\" set "gamedir=%gamedir%\"
if not exist "%gamedir%DOOMEternalx64vk.exe" (
	echo DOOM Eternal not found! Make sure you have the correct game path and try again.
	goto Exit
)
echo GAMEDIR %gamedir%> "%scriptdir%ModLoader_to_Meathook.cfg"
echo/
echo/
choice /c YN /m "Would you like this batch to automatically overwrite files when copying the overrides folder every time you use it?"
echo/
echo/
if errorlevel 1 (
	set replace=1
) else (
	set replace=0
)
echo REPLACE %replace% >> "%scriptdir%ModLoader_to_Meathook.cfg"


:Verification
:: Check if idFileDeCompressor is present
if not exist "%scriptdir%idFileDeCompressor.exe" (
	echo/
	echo/
	echo idFileDeCompressor was not found! Put idFileDecompressor.exe in the same folder as this batch, then try again.
	echo/
	echo/
	goto Exit
)

:: Check if oo2core_8_win64.dll is present
if not exist "%scriptdir%oo2core_8_win64.dll" (
	echo/
	echo/
	echo oo2core_8_win64.dll was not found! Put oo2core_8_win64.dll in the same folder as this batch, then try again.
	echo/
	echo/
	goto Exit
)

:: Remove previous overrides folder
rmdir /s /q "%scriptdir%overrides"

:: Check for PowerShell
2>nul where /Q powershell
if errorlevel 1 if not errorlevel 9009 goto 7zip

:: Unzip all mods to overrides folder using PowerShell
:StartLoop1
if "%~1" == "" goto PostExtraction
powershell Expand-Archive '%~1' -DestinationPath '%scriptdir%overrides'
shift
goto StartLoop1

:7zip
:: Check if 7zip is installed
reg query HKLM\SOFTWARE\7-zip /v "Path"
if not errorlevel 0 (
	echo/
	echo/
	echo 7zip not found! Install 7zip, then try again.
	echo/
	echo/
	goto Exit
)

:: Read 7zip path from Registry and make sure it ends with \
for /F "tokens=2* skip=2" %%a in (
	'reg query "HKLM\SOFTWARE\7-zip" /v "Path"'
) do set "unzipperPath=%%b"
if not "%unzipperPath:~-1%"=="\" set "unzipperPath=%unzipperPath%\"

:: Unzip all mods to overrides folder using 7zip
:StartLoop2
if "%~1" == "" goto PostExtraction
"%unzipperPath%7z.exe" x -y -o"%scriptdir%overrides" "%~1"
shift
goto StartLoop2

:PostExtraction
:: Delete any files in overrides directory like READMEs (to avoid errors with robocopy)
del "%scriptdir%overrides\*.*" /q

:: Check for texture and blang files and delete them
del "%scriptdir%overrides\*.tga" /q /s
del "%scriptdir%overrides\*.png" /q /s
del "%scriptdir%overrides\*.blang" /q /s

:: Copy all subfolders one dir up to delete .resources directories
cd "%scriptdir%overrides"
for /f "tokens=*" %%a in ('dir /b') do robocopy %%a . /S /IS /IT /IM /MOVE

:: Decompress .entities
for /R "%scriptdir%overrides\maps\game" %%I in ("*.entities") do (
	"%scriptdir%idFileDeCompressor.exe" -d "%%~fI" "%%~fI"
)

:: Go back to scriptdir
cd "%scriptdir%"

:: Ask if script should move the overrides folder
echo/
echo/
choice /c YN /m "Would you like to move the overrides folder to the DOOMEternal folder?"
echo/
echo/
if errorlevel 2 (
	echo/
	echo/
	echo Overrides folder was created succesfully, you can find it on %scriptdir%.
	echo/
	echo/
	goto Exit
)

:: Backup previous overrides folder
rmdir /s /q "%gamedir%overridesbackup"
xcopy /i /s "%gamedir%overrides" "%gamedir%overridesbackup"

:: Moves overrides folder to the game folder.
echo/
echo/
if "%replace%"=="1" (
	xcopy /i /s /y "%scriptdir%overrides" "%gamedir%overrides"
) else (
	xcopy /i /s "%scriptdir%overrides" "%gamedir%overrides"
)
rmdir /s /q "%scriptdir%overrides"
echo/
echo/
echo The overrides folder has been created and moved successfully.
echo/
echo/

:: Pause to show result in console and then exit
:Exit
pause
exit
