@ECHO OFF
setlocal EnableDelayedExpansion

:: Auto elevation code taken from the following answer-
:: https://stackoverflow.com/a/28467343/14312937

:: net file to test privileges, 1>NUL redirects output, 2>NUL redirects errors
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto START ) else ( goto getPrivileges ) 

:getPrivileges
if '%1'=='ELEV' ( goto START )

set "batchPath=%~f0"
set "batchArgs=ELEV"

:: Add quotes to the batch path, if needed
set "script=%0"
set script=%script:"=%
IF '%0'=='!script!' ( GOTO PathQuotesDone )
    set "batchPath=""%batchPath%"""
:PathQuotesDone

:: Add quotes to the arguments, if needed
:ArgLoop
IF '%1'=='' ( GOTO EndArgLoop ) else ( GOTO AddArg )
    :AddArg
    set "arg=%1"
    set arg=%arg:"=%
    IF '%1'=='!arg!' ( GOTO NoQuotes )
        set "batchArgs=%batchArgs% "%1""
        GOTO QuotesDone
        :NoQuotes
        set "batchArgs=%batchArgs% %1"
    :QuotesDone
    shift
    GOTO ArgLoop
:EndArgLoop

:: Create and run the vb script to elevate the batch file
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs"
ECHO UAC.ShellExecute "cmd", "/c ""!batchPath! !batchArgs!""", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
"%temp%\OEgetPrivileges.vbs" 
exit /B

:START
:: Remove the elevation tag and set the correct working directory
IF '%1'=='ELEV' ( shift /1 )
cd /d %~dp0

:: Main script here

set "_onetitle=WinRAR Activation Script"

cls
mode 76, 30
title %_onetitle% by Brynner
echo %_onetitle%
echo Created by Brynner
echo https://bgamez23.github.io/WinRAR-Activation-Script
echo:

call :RARBIT
echo:
call :CLEANUP
echo:
echo ^- Starting WinRAR once to ensure file presence.
call :INITIATE
echo:
call :PAUSEWAIT
echo:
call :TERMINATE
echo:
call :SETKEY
echo:
echo ^- Registration complete. Starting WinRAR.
call :INITIATE
echo:
call :PAUSEWAIT
echo:
echo ^- This script will now end.
goto FINISH

:RARBIT
echo ^- Determining WinRAR location...
echo:
set "rarbit=unknown"
if exist "%SystemDrive%\Program Files (x86)\WinRAR\WinRAR.exe" set "rarbit=%SystemDrive%\Program Files (x86)\WinRAR"
if exist "%SystemDrive%\Program Files\WinRAR\WinRAR.exe" set "rarbit=%SystemDrive%\Program Files\WinRAR"
if "%rarbit%" EQU "unknown" (
  echo ^- WinRAR was not found in the default directories.
  echo:
  pause
  goto FINISH
) else (
  echo ^- WinRAR was found in "%rarbit%".
)
exit /b

:CLEANUP
echo ^- Cleaning up any existing registration keys.
if exist "%rarbit%\rarreg.key" (
  del /f /q "%rarbit%\rarreg.key" 1>nul
)
exit /b

:INITIATE
start /b "" "%rarbit%\WinRAR.exe"
exit /b

:TERMINATE
echo ^- Closing all open WinRAR processes.
taskkill /f /im WinRAR.exe /t
exit /b

:PAUSEWAIT
echo ^- Please wait a moment.
timeout /t 3 /nobreak > nul
exit /b

:SETKEY
echo ^- Registering your copy of WinRAR.
(
  echo RAR registration data
  echo Brynner
  echo Unlimited Company License
  echo UID=d059f600d3f412f9c88a
  echo 6412212250c88ae6ed9dc63c1ede5e69a366f655d72a5058b5681a
  echo 5ad83fe546a60a3419b0600f84aac07140ea2b918564d00522464e
  echo ad9b994561f2888fd619ed5b9ad232fda018c148989e4c03034429
  echo 62572582842acc4318e5dedf0ee5665acc609d61cd1d06d5e7b885
  echo 217469bd61052f8dc6bc3e16fae6a2dbefdef1080d32fda018c148
  echo 989e4c032ec8fcaaefb0eeeddfaa848469a917471b1d22dd6057d6
  echo 635a834e80e361e91ddeb634bf22ca210330af2a5bfa4069194333
  echo ------------------------------------------------------
) > "%rarbit%\rarreg.key"
exit /b

:FINISH
timeout /t 3 /nobreak > nul
exit
