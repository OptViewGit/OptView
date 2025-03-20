mkdir "C:\Temp"  2>nul
set LOGFILE=C:\Temp\setup.log
echo. > "%LOGFILE%"

:WAIT_LOOP
if exist "%LOGFILE%" (
    echo ========================= >> %LOGFILE%
	echo ===   SETUP STAGE 1   === >> %LOGFILE%
	echo ========================= >> %LOGFILE%
	echo [%DATE% %TIME%] [INF001] Folder Temp Created >> %LOGFILE%
	echo [%DATE% %TIME%] [INF002] Log File Created >> %LOGFILE%
) else (
    timeout /t 2 /nobreak >nul
    goto WAIT_LOOP
)

:: 03 - Rename Local Disk
label C: OS
if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF003] Successfully changed volume label to OS >> %LOGFILE% )
else ( echo [%DATE% %TIME%] [ERROR003] Failed to change volume label >> %LOGFILE% )

:: 04 - Rename PC
wmic computersystem where name="%computername%" rename "OptView"
if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF004] Successfully renamed computer to OptView >> %LOGFILE% )
else ( echo [%DATE% %TIME%] [ERROR004] Failed to rename computer >> %LOGFILE% )

:: 05 - Force Powershell Scripts
powershell -Command "Set-ExecutionPolicy Unrestricted -Scope LocalMachine -Force"
if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF005] Successfully changed PowerShell Execution Policy to Unrestricted >> %LOGFILE% )
else ( echo [%DATE% %TIME%] [ERROR005] Failed to change PowerShell Execution Policy >> %LOGFILE% )

:: 06-07-08 Download Files
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/OptViewGit/OptView/main/wallpaper.jpg', 'C:\Temp\wallpaper.jpg')"
if exist "C:\Temp\wallpaper.jpg" ( echo [%DATE% %TIME%] [INF006] Successfully downloaded wallpaper.jpg >> %LOGFILE% ) else ( echo [%DATE% %TIME%] [ERROR006] Failed to download wallpaper.jpg >> %LOGFILE% )

powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/OptViewGit/OptView/main/config.ps1', 'C:\Temp\config.ps1')"
if exist "C:\Temp\config.ps1" ( echo [%DATE% %TIME%] [INF007] Successfully downloaded config.ps1 >> %LOGFILE% ) else ( echo [%DATE% %TIME%] [ERROR007] Failed to download config.ps1 >> %LOGFILE% )

powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/OptViewGit/OptView/main/config.vbs', 'C:\Temp\config.vbs')"
if exist "C:\Temp\config.vbs" ( echo [%DATE% %TIME%] [INF008] Successfully downloaded config.vbs >> %LOGFILE% ) else ( echo [%DATE% %TIME%] [ERROR008] Failed to download config.vbs >> %LOGFILE% )

:: 09 - Set system-wide default input language and keyboard layout
reg add "HKEY_USERS\.DEFAULT\Keyboard Layout\Preload" /v 1 /t REG_SZ /d 00000409 /f >nul 2>&1
if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF009] Successfully updated keyboard layout in registry >> %LOGFILE% )
else ( echo [%DATE% %TIME%] [ERROR009] Failed to update keyboard layout in registry >> %LOGFILE% )

:: 10 - Disable First-Time Windows Welcome Experience
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableFirstLogonAnimation /t REG_DWORD /d 0 /f >nul 2>&1
if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF010] Successfully disabled First-Time Windows Welcome Experience >> %LOGFILE% )
else ( echo [%DATE% %TIME%] [ERROR010] Failed to disable First-Time Windows Welcome Experience >> %LOGFILE% )

:: 11 - Load Default User Registry Hive
reg load HKU\Default_User "C:\Users\Default\NTUSER.DAT" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo [%DATE% %TIME%] [INF011] Successfully loaded Default User registry hive >> %LOGFILE%
	
    reg add "HKU\Default_User\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f >nul 2>&1
    if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF012] Successfully disabled Advertising ID >> %LOGFILE% )
	else ( echo [%DATE% %TIME%] [ERROR012] Failed to disable Advertising ID >> %LOGFILE% )
    
	reg add "HKU\Default_User\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul 2>&1
    if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF013] Successfully disabled Background App Access >> %LOGFILE% )
	else ( echo [%DATE% %TIME%] [ERROR013] Failed to disable Background App Access >> %LOGFILE% )
    
	reg add "HKU\Default_User\Software\Microsoft\Siuf\Rules" /v NumberOfSIUFInPeriod /t REG_DWORD /d 0 /f >nul 2>&1
    if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF014] Successfully disabled Feedback Data Collection >> %LOGFILE% )
	else ( echo [%DATE% %TIME%] [ERROR014] Failed to disable Feedback Data Collection >> %LOGFILE% )
	
	:: 15 - Unload Default User Registry Hive
    reg unload HKU\Default_User >nul 2>&1
    if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF015] Successfully unloaded Default User registry hive >> %LOGFILE% )
	else ( echo [%DATE% %TIME%] [ERROR015] Failed to unload Default User registry hive >> %LOGFILE% ))
	
else ( echo [%DATE% %TIME%] [ERROR011] Failed to load Default User registry hive >> %LOGFILE% )

:: 16 - Disable Windows Privacy Setup Screen
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\OOBE" /v DisablePrivacyExperience /t REG_DWORD /d 1 /f >nul 2>&1
if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF016] Successfully disabled Windows Privacy Setup Screen >> %LOGFILE% )
else ( echo [%DATE% %TIME%] [ERROR016] Failed to disable Windows Privacy Setup Screen >> %LOGFILE% )

:: 17 - Enable the Built-in Administrator Account
net user Administrator /active:yes >nul 2>&1
if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF017] Successfully enabled the built-in Administrator account >> %LOGFILE% )
else ( echo [%DATE% %TIME%] [ERROR017] Failed to enable the built-in Administrator account >> %LOGFILE% )

:: Disable Administrator Account When Done
:: net user Administrator /active:no

:: 18 - Set a Password for Administrator
net user Administrator admin >nul 2>&1
if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF018] Successfully set a password for the Administrator account >> %LOGFILE% )
else ( echo [%DATE% %TIME%] [ERROR018] Failed to set a password for the Administrator account >> %LOGFILE% )

:: 19 - Enable Auto Login
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d 1 /f >nul 2>&1
if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF019] Successfully enabled Auto Login >> %LOGFILE% )
else ( echo [%DATE% %TIME%] [ERROR019] Failed to enable Auto Login >> %LOGFILE% )

:: 20 - Set Default Username for Auto Login
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d "Administrator" /f >nul 2>&1
if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF020] Successfully set DefaultUserName to Administrator >> %LOGFILE% )
else ( echo [%DATE% %TIME%] [ERROR020] Failed to set DefaultUserName >> %LOGFILE% )

:: 21 - Set Password for Auto Login (Security Risk - See Notes)
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d "admin" /f >nul 2>&1
if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF021] Successfully set DefaultPassword for Auto Login >> %LOGFILE% )
else ( echo [%DATE% %TIME%] [ERROR021] Failed to set DefaultPassword for Auto Login >> %LOGFILE% )

:: 22 - Setup Run Script at Login
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v AutoSetup /t REG_SZ /d "wscript.exe C:\Temp\config.vbs" /f >nul 2>&1
if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF022] Successfully added script to startup >> %LOGFILE% )
else ( echo [%DATE% %TIME%] [ERROR022] Failed to add script to startup >> %LOGFILE% )

:: 23 - Enable Developer Mode
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /v "AllowDevelopmentWithoutDevLicense" /t REG_DWORD /d 1 /f >nul 2>&1
if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF023] Successfully enabled Developer Mode >> %LOGFILE% )
else ( echo [%DATE% %TIME%] [ERROR023] Failed to enable Developer Mode >> %LOGFILE% )

:: 24 - Enable Remote Desktop
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f >nul 2>&1
if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF024] Successfully enabled Remote Desktop >> %LOGFILE% )
else ( echo [%DATE% %TIME%] [ERROR024] Failed to enable Remote Desktop >> %LOGFILE% )

:: 25 - Enable Remote Desktop Firewall Rule
netsh advfirewall firewall set rule group="Remote Desktop" new enable=Yes >nul 2>&1
if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF025] Successfully enabled Remote Desktop Firewall Rule >> %LOGFILE% )
else ( echo [%DATE% %TIME%] [ERROR025] Failed to enable Remote Desktop Firewall Rule >> %LOGFILE% )

:: 26 - Take Ownership of the Web Folder
set TARGET_DIR=C:\Windows\Web
takeown /f "%TARGET_DIR%" /r /d y >nul 2>&1
if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF026] Successfully took ownership of %TARGET_DIR% >> %LOGFILE% )
else ( echo [%DATE% %TIME%] [ERROR026] Failed to take ownership of %TARGET_DIR% >> %LOGFILE% )

:: 27 - Grant Full Control to Administrators
icacls "%TARGET_DIR%" /grant Administrators:F /t >nul 2>&1
if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF027] Successfully granted full control to Administrators >> %LOGFILE% )
else ( echo [%DATE% %TIME%] [ERROR027] Failed to grant full control to Administrators >> %LOGFILE% )

:: 28 - Loop through all directories inside "web" and delete them
for /d %%D in ("%TARGET_DIR%\*") do (
	rd /s /q "%%D" >nul 2>&1
	if !ERRORLEVEL! equ 0 ( echo [%DATE% %TIME%] [INF028] Successfully deleted %%D >> %LOGFILE% )
	else ( echo [%DATE% %TIME%] [ERROR028] Failed to delete %%D >> %LOGFILE% )
)

:: 29 - Copy the wallpaper to the destination folder
copy /y "C:\Temp\wallpaper.jpg" "C:\Windows\Web\wallpaper.jpg" >nul 2>&1
if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF029] Successfully copied wallpaper to Web >> %LOGFILE% )
else ( echo [%DATE% %TIME%] [ERROR029] Failed to copy wallpaper to Web >> %LOGFILE% )

set LOGFILE2=C:\Temp\user.txt
echo %USERNAME% > %LOGFILE2%

echo [%DATE% %TIME%] [END] System reboot initiated >> %LOGFILE%

:: Force reboot immediately
shutdown /r /f /t 5 /c "System Rebooting After OptView Setup Stage 1 Completed"