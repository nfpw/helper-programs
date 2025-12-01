@echo off
setlocal enabledelayedexpansion

:: Get the directory where this batch file is located
set "SCRIPT_DIR=%~dp0"

:menu
cls
echo ========================================
echo    Bunni multi inject made by @nfpw
echo ========================================
echo.
echo Select an option:
echo.
echo 1. RobloxPlayerBeta.exe
echo 2. Exit
echo.
set /p choice="Enter your choice (1-2): "

if "%choice%"=="1" goto roblox
if "%choice%"=="2" goto end
echo Invalid choice! Please try again.
timeout /t 2 >nul
goto menu

:roblox
cls
echo Searching for RobloxPlayerBeta.exe instances...
echo.

:: Count and list all RobloxPlayerBeta.exe processes
set count=0
for /f "tokens=2" %%i in ('tasklist /FI "IMAGENAME eq RobloxPlayerBeta.exe" /FO LIST ^| find "PID:"') do (
    set /a count+=1
    set PID!count!=%%i
)

if %count%==0 (
    echo Error: No RobloxPlayerBeta.exe processes found!
    echo.
    pause
    goto menu
)

echo Found %count% RobloxPlayerBeta.exe instance(s):
echo.
for /l %%i in (1,1,%count%) do (
    echo %%i. PID: !PID%%i!
)
echo.
echo A. Inject into ALL instances
echo 0. Back to menu
echo.

set /p selection="Select which instance to inject (0-%count% or A for all): "

if /i "%selection%"=="0" goto menu
if /i "%selection%"=="A" goto inject_all

if %selection% lss 1 goto invalid_selection
if %selection% gtr %count% goto invalid_selection

set PID=!PID%selection%!
set TARGET=RobloxPlayerBeta.exe
goto inject

:inject_all
echo.
echo Injecting into all %count% instances...
echo.
for /l %%i in (1,1,%count%) do (
    set CURRENT_PID=!PID%%i!
    echo Injecting into PID: !CURRENT_PID!
    
    if not exist "%SCRIPT_DIR%Loader.exe" (
        echo Error: Loader.exe not found!
        pause
        goto menu
    )
    
    "%SCRIPT_DIR%Loader.exe" !CURRENT_PID!
    echo Done with PID: !CURRENT_PID!
    echo.
)
echo.
echo All injections completed!
pause
goto menu

:invalid_selection
echo Invalid selection!
timeout /t 2 >nul
goto roblox

:custom
cls
set /p TARGET="Enter process name (e.g., notepad.exe): "
echo Searching for %TARGET%...
goto findpid

:findpid
:: Find the PID of the target process
set PID=
for /f "tokens=2" %%i in ('tasklist /FI "IMAGENAME eq %TARGET%" /FO LIST ^| find "PID:"') do (
    set PID=%%i
)

:: Check if PID was found
if not defined PID (
    echo.
    echo Error: %TARGET% is not running!
    echo.
    pause
    goto menu
)

set PID=%PID%
goto inject

:inject
echo Found %TARGET% with PID: %PID%

:: Check if Loader.exe exists in the script directory
if not exist "%SCRIPT_DIR%Loader.exe" (
    echo.
    echo Error: Loader.exe not found in script directory!
    echo Looking in: %SCRIPT_DIR%
    echo.
    pause
    goto menu
)

echo.
echo Running Loader.exe with PID %PID%...
"%SCRIPT_DIR%Loader.exe" %PID%

echo.
echo Done!
echo.
pause
goto menu

:end
echo Exiting...
exit /b 0