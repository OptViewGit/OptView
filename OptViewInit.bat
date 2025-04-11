@echo off

:: Set the console window title
title OptView Initialization Script

:: self-elevating admin check & relaunch
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting admin privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: create "Temp" folder if it doesn’t exist & suppresses errors
mkdir "C:\Temp" 2>nul

:: set variable pointing to the log file path
set "LOGFILE=C:\Temp\OptViewSetup.log"

:: creates or clears the log file
echo. > "%LOGFILE%"
>>"%LOGFILE%" echo [%DATE% %TIME%] [info] Log File Created

:: set powershell execution policy to unrestricted for all users
>>"%LOGFILE%" echo [%DATE% %TIME%] [info] Setting PowerShell ExecutionPolicy to Unrestricted
powershell -Command "Set-ExecutionPolicy Unrestricted -Scope LocalMachine -Force"

setlocal

set "CFG_URL=https://raw.githubusercontent.com/OptViewGit/OptView/main/config.ps1"
set "CFG_DEST=C:\Temp\config.ps1"

set "PIC_URL=https://github.com/OptViewGit/OptView/blob/main/wallpaper.jpg?raw=true"
set "PIC_DEST=C:\Temp\wallpaper.jpg"

:: Check if the configuration file URL is reachable
echo [info] Checking if configuration file is online ...
>>"%LOGFILE%" echo [%DATE% %TIME%] [info] Checking if configuration file is online ...
powershell -Command ^
    "try { $r = Invoke-WebRequest -Uri '%CFG_URL%' -UseBasicParsing -Method Head; if ($r.StatusCode -eq 200) { exit 0 } else { exit 1 } } catch { exit 2 }"

if %errorlevel% neq 0 (
    echo [ERROR] Configuration file URL is not accessible: %CFG_URL%
    >>"%LOGFILE%" echo [%DATE% %TIME%] [err] Configuration file URL is not accessible: %CFG_URL%
    goto END
)
echo [info] Configuration file is online.

:: Download the configuration file
echo [info] Downloading configuration file ...
>>"%LOGFILE%" echo [%DATE% %TIME%] [info] Downloading configuration file ...
powershell -Command ^
    "try { Invoke-WebRequest -Uri '%CFG_URL%' -OutFile '%CFG_DEST%' -UseBasicParsing -ErrorAction Stop; exit 0 } catch { exit 1 }"

if %errorlevel% neq 0 (
    echo [ERROR] Failed to download configuration file: %CFG_URL%
    >>"%LOGFILE%" echo [%DATE% %TIME%] [err] Failed to download configuration file: %CFG_URL%
    goto END
)
echo [info] Configuration file downloaded successfully: %CFG_DEST%

:: Unblock the configuration file
echo [info] Unblocking configuration file ...
>>"%LOGFILE%" echo [%DATE% %TIME%] [info] Unblocking configuration file ...
powershell -Command "Unblock-File -Path '%CFG_DEST%'"
echo [info] Configuration file unblocked.

:: Check if the wallpaper URL is reachable
echo [info] Checking if wallpaper file is online ...
>>"%LOGFILE%" echo [%DATE% %TIME%] [info] Checking if wallpaper file is online ...
powershell -Command ^
    "try { $r = Invoke-WebRequest -Uri '%PIC_URL%' -UseBasicParsing -Method Head; if ($r.StatusCode -eq 200) { exit 0 } else { exit 1 } } catch { exit 2 }"

if %errorlevel% neq 0 (
    echo [ERROR] Wallpaper file URL is not accessible: %PIC_URL%
    >>"%LOGFILE%" echo [%DATE% %TIME%] [err] Wallpaper file URL is not accessible: %PIC_URL%
    goto END
)
echo [info] Wallpaper file is online.

:: Download the wallpaper file
echo [info] Downloading wallpaper file ...
>>"%LOGFILE%" echo [%DATE% %TIME%] [info] Downloading wallpaper file ...
powershell -Command ^
    "try { Invoke-WebRequest -Uri '%PIC_URL%' -OutFile '%PIC_DEST%' -UseBasicParsing -ErrorAction Stop; exit 0 } catch { exit 1 }"

if %errorlevel% neq 0 (
    echo [ERROR] Failed to download wallpaper file: %PIC_URL%
    >>"%LOGFILE%" echo [%DATE% %TIME%] [err] Failed to download wallpaper file: %PIC_URL%
    goto END
)
echo [info] Wallpaper file downloaded successfully: %PIC_DEST%

:: Unblock the wallpaper file
echo [info] Unblocking wallpaper file ...
>>"%LOGFILE%" echo [%DATE% %TIME%] [info] Unblocking wallpaper file ...
powershell -Command "Unblock-File -Path '%PIC_DEST%'"
echo [info] Wallpaper file unblocked.

:: Check if the downloaded configuration file exists before running it
if exist "%CFG_DEST%" (
    echo [info] Running configuration script with full privileges ...
    >>"%LOGFILE%" echo [%DATE% %TIME%] [info] Running configuration script with full privileges ...
    powershell -Command "Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass -File ""%CFG_DEST%""' -Verb RunAs"
) else (
    echo [ERROR] Configuration file not found: %CFG_DEST%
    >>"%LOGFILE%" echo [%DATE% %TIME%] [err] Configuration file not found: %CFG_DEST%
    goto END
)

:END
endlocal

echo [info] Init BAT Script Completed.
>>"%LOGFILE%" echo [%DATE% %TIME%] [END] Init BAT Script Completed

:: Wait 5 seconds before closing the console window
echo Closing the window in 5 seconds...
timeout /t 3 /nobreak >nul