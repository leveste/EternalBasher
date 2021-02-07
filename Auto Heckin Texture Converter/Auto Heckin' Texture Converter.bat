@echo off
cd /d "%~dp0"

rem Verify Command Extensions
2>nul verify/
setlocal enableextensions

if errorlevel 1 (
	echo ERROR: Command Processor Extensions are unavailable!
	echo.
	echo 	This batch file requires command extensions, but they seem to be unavailable on your system.
	echo.
	pause
	exit /b 1
)
if not cmdextversion 2 (
	echo ERROR: Command Processor Extensions are of version 1!
	echo.
	echo Command extensions seem to be available on your system, but only of version 1. This batch file was designed for version 2.
	echo.
	pause
	exit /b 1
)

rem Verify all tools
if not exist ".\tools\nvcompress.exe" (
	echo.
	echo 'nvcompress.exe' not found! Did you extract everything in the tools folder?
	echo.
	pause
	exit /b
)

if not exist ".\tools\cudart64_30_14.dll" (
	echo.
	echo 'cudart64_30_14.dll' not found! Did you extract everything in the tools folder?
	echo.
	pause
	exit /b
)

if not exist ".\tools\nvtt.dll" (
	echo.
	echo 'nvtt.dll' not found! Did you extract everything in the tools folder?
	echo.
	pause
	exit /b
)

if not exist ".\tools\DivinityMashine.exe" (
	echo.
	echo 'DivinityMashine.exe' not found! Did you extract everything in the tools folder?
	echo.
	pause
	exit /b
)

if not "%~1" == "" goto StartLoop
echo.
echo Usage:
echo   "~nx0" [texture1] [texture2] [...]
echo.
echo Alternatively, drag files onto this batch.
echo.
pause
exit /b

:StartLoop
if "%~1" == "" goto Exit
echo.
echo|set /p="Converting '%~nx1'..."
echo.
.\tools\nvcompress.exe -bc1a -fast "%~1" "%~1.dds" >nul
.\tools\DivinityMashine.exe "%~1.dds" >nul
for /f "tokens=1 delims=." %%a in ("%~1") do (set "filename=%%a") >nul
set "name=%~1.dds"
set "tga_name=%name:.dds=.tga%"
move /y "%tga_name%" "%filename%.tga" >nul
del "%~1.dds" >nul
shift
goto StartLoop

:Exit
pause
exit /b