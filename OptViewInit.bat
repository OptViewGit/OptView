@echo off

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
echo [begin] Log File Created
>>"%LOGFILE%" echo [%DATE% %TIME%] [begin] Log File Created

:: set powershell execution policy to unrestricted for all users
>>"%LOGFILE%" echo [%DATE% %TIME%] [info] Setting PowerShell ExecutionPolicy to Unrestricted
>>"%LOGFILE%" echo [%DATE% %TIME%] [cmmd] powershell -Command "Set-ExecutionPolicy Unrestricted -Scope LocalMachine -Force"
powershell -Command "Set-ExecutionPolicy Unrestricted -Scope LocalMachine -Force"

:: start the script to download the config.ps1 file
setlocal

set "URL=https://raw.githubusercontent.com/OptViewGit/OptView/main/config.ps1"
set "DEST=C:\Temp\config.ps1"
>>"%LOGFILE%" echo [%DATE% %TIME%] [info] URL = %URL%
>>"%LOGFILE%" echo [%DATE% %TIME%] [info] DEST = %DEST%

:: Check if the URL is reachable
echo [info] Checking if configuration file is online ...
>>"%LOGFILE%" echo [%DATE% %TIME%] [info] Checking if configuration file is online ...

powershell -Command ^
    "try { $r = Invoke-WebRequest -Uri '%URL%' -UseBasicParsing -Method Head; if ($r.StatusCode -eq 200) { exit 0 } else { exit 1 } } catch { exit 2 }"

if %errorlevel% neq 0 (
    echo [ERROR] URL is not accessible: %URL%
    >>"%LOGFILE%" echo [%DATE% %TIME%] [ERROR] URL is not accessible: %URL%
    goto END
)

:: Download the file and overwrite
echo [info] Downloading file ...
>>"%LOGFILE%" echo [%DATE% %TIME%] [info] Downloading file ...
>>"%LOGFILE%" echo [%DATE% %TIME%] [cmmd] powershell -Command "Invoke-WebRequest -Uri '%URL%' -OutFile '%DEST%' -UseBasicParsing -ErrorAction Stop"
powershell -Command "Invoke-WebRequest -Uri '%URL%' -OutFile '%DEST%' -UseBasicParsing -ErrorAction Stop"

:: Unblock the file
echo [info] Unblocking downloaded file ...
>>"%LOGFILE%" echo [%DATE% %TIME%] [info] Unblocking downloaded file ...
>>"%LOGFILE%" echo [%DATE% %TIME%] [cmmd] powershell -Command "Unblock-File -Path '%DEST%'"
powershell -Command "Unblock-File -Path '%DEST%'"

:: Check if the downloaded file exists before running it
if exist "%DEST%" (
    echo [info] Running configuration with full privileges ...
    >>"%LOGFILE%" echo [%DATE% %TIME%] [info] Running configuration script with full privileges ...
    >>"%LOGFILE%" echo [%DATE% %TIME%] [cmmd] powershell -Command "Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass -File ""%DEST%""' -Verb RunAs"
    powershell -Command "Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass -File ""%DEST%""' -Verb RunAs"
) else (
    echo [ERROR] Configuration not found: %DEST%
    >>"%LOGFILE%" echo [%DATE% %TIME%] [ERROR] Configuration not found: %DEST%
    goto END
)

:END
endlocal
echo [info] Configuration file download script END
>>"%LOGFILE%" echo [%DATE% %TIME%] [info] Configuration file download script END
:: end of script to download the config.ps1 file

echo [end] BAT_Script completed
>>"%LOGFILE%" echo [%DATE% %TIME%] [end] BAT_Script completed
timeout /t 2 /nobreak >nul