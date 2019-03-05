rem Copyright 2019 DeadManWalking (DeadManWalkingTO-GitHub), <https://github.com/DeadManWalkingTO>, <deadmanwalkingto@gmail.com>

cls
rem ==================== Your Code Starts Here ====================
rem ==================== Your Code Starts Here ====================
rem ==================== Your Code Starts Here ====================

rem Set InputPath
set InputPath=C:\Docs

rem Set Output Filename
set OutputFilename=BackUp

rem ==================== Your Code Ends Here ====================
rem ==================== Your Code Ends Here ====================
rem ==================== Your Code Ends Here ====================
cls

rem ========== Pre ==========
cls
rem Don't echo to standard output
cls
@echo off
rem Set Version info
set V=1.4.5
rem Change colors
color 1F
rem Set Author
set Author=DeadManWalking (DeadManWalkingTO-GitHub)
Rem Set Program Name
set ProgramName=WindowsBackUpScriptDmW
rem Set title
title %ProgramName% By %Author%

Rem ========== Start ==========
cls
echo ###############################################################################
echo.
echo   %ProgramName% Version %V%
echo.
echo   AUTHOR: %Author%
echo.
echo ###############################################################################
echo.
echo %ProgramName%
echo 1. BackUp.
echo 2. Compress.
echo 3. Save.
echo.
echo Additional:
echo - Auto Invoking UAC for Privilege Escalation
echo.
timeout /T 1 /NOBREAK > nul

rem ========== Automatically Check & Get Admin Rights ==========

:init
setlocal DisableDelayedExpansion
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion

:checkPrivileges
NET FILE 1>nul 2>nul
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
echo.
echo ###############################################################################
echo #  Invoking UAC for Privilege Escalation                                      #
echo ###############################################################################

echo Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
echo args = "ELEV " >> "%vbsGetPrivileges%"
echo For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
echo args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
echo Next >> "%vbsGetPrivileges%"
echo UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
"%SystemRoot%\System32\WScript.exe" "%vbsGetPrivileges%" %*
exit /B

:gotPrivileges
setlocal & pushd .
cd /d %~dp0
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul & shift /1)


rem ========== Initializing ==========

rem Set RarPath
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT
rem if %OS%==32BIT echo This is a 32bit operating system
rem if %OS%==64BIT echo This is a 64bit operating system
set RarPath=.\System\Rar32.exe
if %OS%==64BIT set RarPath=.\System\Rar.exe

rem Set OutputPath
set OutputPath=.\BackUp\%OutputFilename%

rem Set BackUp Date
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set BackUpDate=%%c-%%a-%%b)

rem Set BackUp Rar Options
set RarOptions=a -m5

rem Set FullCommand
set FullCommand=%RarPath% %RarOptions% %OutputPath%---%BackUpDate% %InputPath%
rem echo %FullCommand%

rem ========== Run ==========

rem Change Directory
echo ==================================================
echo Change Directory
echo.
cd \
if %ERRORLEVEL%==0 (echo. & echo Done) else (echo. & echo Fail & pause & goto :eof) 
echo ==================================================
echo.
timeout 1 > nul

rem Make Directory
echo ==================================================
echo Make Directory
echo.
if not exist BackUp mkdir BackUp
if %ERRORLEVEL%==0 (echo. & echo Done) else (echo. & echo Fail & pause & goto :eof) 
echo ==================================================
echo.
timeout 1 > nul

rem Run BackUp
echo ==================================================
echo Run BackUp
echo.
%FullCommand%
if %ERRORLEVEL%==0 (echo. & echo Done) else (echo. & echo Fail & pause & goto :eof) 
echo ==================================================
echo.
timeout 1 > nul

rem ========== Finish ==========

:finish
echo.
echo ###############################################################################
echo.
echo   %ProgramName% Version %V%
echo.
echo   AUTHOR: %Author%
echo.
echo ###############################################################################
echo.
echo   BackUp stored to %OutputFilename%---%BackUpDate%.
echo.
echo ###############################################################################
echo.
echo   Press any key to exit.
echo ###############################################################################

pause > nul

rem ========== End ==========

rem ========== EoF ==========
