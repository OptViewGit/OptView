::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdCuDJH2B50kkJwtoXwGWKXuFLrAX1+H44OTJq04SNA==
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSzk=
::cBs/ulQjdF65
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpSI=
::egkzugNsPRvcWATEpSI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCuDJH2B50kkJwtoYxSWCmK/EZwS4fy16vKCwg==
::YB416Ek+ZW8=
::
::
::978f952a14a936cc963da21a135fa983
:: ================== Setup Stage 1 ==================
start /min powershell -WindowStyle Hidden -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('<>   OptView Setup Stage 1 STARTED. Computer will Reboot by itself.', '<>   OptView Setup Info')"

mkdir "C:\Temp"
set LOGFILE=C:\Temp\setup.log
echo ========================= > %LOGFILE%
echo ===   SETUP STAGE 1   === > %LOGFILE%
echo ========================= > %LOGFILE%
echo [%DATE% %TIME%] [INF001] Folder Temp Created >> %LOGFILE%
echo [%DATE% %TIME%] [INF002] Log File Created >> %LOGFILE%

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
set DOWN_SUCCESS1=0 
set DOWN_SUCCESS2=0
set DOWN_SUCCESS3=0 

powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/OptViewGit/OptView/main/wallpaper.jpg', 'C:\Temp\wallpaper.jpg')"
set FILE_PATH=C:\Temp\wallpaper.jpg
if exist %FILE_PATH% (
	echo [%DATE% %TIME%] [INF006] Successfully downloaded wallpaper.jpg >> %LOGFILE%
	set DOWN_SUCCESS1=1
	) else ( echo [%DATE% %TIME%] [ERROR006] Failed to download wallpaper.jpg >> %LOGFILE% )

powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/OptViewGit/OptView/main/config.ps1', 'C:\Temp\config.ps1')"
set FILE_PATH=C:\Temp\config.ps1
if exist %FILE_PATH% (
	echo [%DATE% %TIME%] [INF007] Successfully downloaded config.ps1 >> %LOGFILE%
	set DOWN_SUCCESS2=1
	) else ( echo [%DATE% %TIME%] [ERROR007] Failed to download config.ps1 >> %LOGFILE% )

powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/OptViewGit/OptView/main/config.vbs', 'C:\Temp\config.vbs')"
set FILE_PATH=C:\Temp\config.vbs
if exist %FILE_PATH% (
	echo [%DATE% %TIME%] [INF008] Successfully downloaded config.vbs >> %LOGFILE%
	set DOWN_SUCCESS3=1
	) else ( echo [%DATE% %TIME%] [ERROR008] Failed to download config.vbs >> %LOGFILE% )

:: ===============================================================
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

:: ==============================================
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
if %DOWN_SUCCESS2% equ 1 if %DOWN_SUCCESS3% equ 1 (
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v AutoSetup /t REG_SZ /d "wscript.exe C:\Temp\config.vbs" /f >nul 2>&1
    if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF022] Successfully added script to startup >> %LOGFILE% )
	else ( echo [%DATE% %TIME%] [ERROR022] Failed to add script to startup >> %LOGFILE% )
) else ( echo [%DATE% %TIME%] [ERROR022] Startup script was NOT added because one or both downloads failed >> %LOGFILE% )

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

:: 26 - Remove Wallaper and Lockscreen Images
set TARGET_DIR=C:\Windows\Web
	:: 1 - Take Ownership of the Web Folder
	takeown /f "%TARGET_DIR%" /r /d y >nul 2>&1
	if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF026.1] Successfully took ownership of %TARGET_DIR% >> %LOGFILE% )
	else ( echo [%DATE% %TIME%] [ERROR026.1] Failed to take ownership of %TARGET_DIR% >> %LOGFILE% )
	:: 2 - Grant Full Control to Administrators
	icacls "%TARGET_DIR%" /grant Administrators:F /t >nul 2>&1
	if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF026.2] Successfully granted full control to Administrators >> %LOGFILE% )
	else ( echo [%DATE% %TIME%] [ERROR026.2] Failed to grant full control to Administrators >> %LOGFILE% )
	:: 3 - Remove Wallpaper and Lockscreen Images
	for %%D in (Wallpaper Screen 4K touchkeyboard) do (
		rd /s /q "%TARGET_DIR%\%%D" >nul 2>&1
		if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF026.3] Successfully deleted %TARGET_DIR%\%%D >> %LOGFILE% )
		else ( echo [%DATE% %TIME%] [ERROR026.3] Failed to delete %TARGET_DIR%\%%D >> %LOGFILE% )
	)

:: 27 - Set Wallpaper
set SOURCE_WALLPAPER=C:\Temp\wallpaper.jpg
set DEST_WALLPAPER=C:\Windows\Web\wallpaper.jpg
if %DOWN_SUCCESS1% equ 1 (
	
	:: Copy the wallpaper to the destination folder
    copy /y "%SOURCE_WALLPAPER%" "%DEST_WALLPAPER%" >nul 2>&1
	if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF027.1] Successfully copied wallpaper to %DEST_WALLPAPER% >> %LOGFILE% )
	else ( echo [%DATE% %TIME%] [ERROR027.1] Failed to copy wallpaper to %DEST_WALLPAPER% >> %LOGFILE% )

	:: Apply wallpaper settings for all users
    for /f "tokens=*" %%u in ('wmic useraccount get name') do (
        reg add "HKEY_USERS\%%u\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "%DEST_WALLPAPER%" /f >nul 2>&1
        if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF027.2] Successfully set wallpaper for user %%u >> %LOGFILE% )
		else ( echo [%DATE% %TIME%] [ERROR027.2] Failed to set wallpaper for user %%u >> %LOGFILE% )
    )
	
	:: Set wallpaper for the default user (Administrator login screen)
    reg add "HKEY_USERS\.DEFAULT\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "%DEST_WALLPAPER%" /f >nul 2>&1
    if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF027.3] Successfully set wallpaper for Administrator login >> %LOGFILE% )
	else ( echo [%DATE% %TIME%] [ERROR027.3] Failed to set wallpaper for Administrator login >> %LOGFILE% )
	
) else (
	echo [%DATE% %TIME%] [ERROR027] Wallpaper File Missing >> %LOGFILE%
    
	:: Remove wallpaper and set black background for all users if wallpaper was not successfully downloaded
	for /f "skip=1 tokens=*" %%u in ('wmic useraccount get name') do (
		reg add "HKEY_USERS\%%u\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "" /f >nul 2>&1
		if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF027.4] Successfully removed wallpaper for user %%u >> %LOGFILE% )
		else ( echo [%DATE% %TIME%] [ERROR027.4] Failed to remove wallpaper for user %%u >> %LOGFILE% )

		reg add "HKEY_USERS\%%u\Control Panel\Colors" /v Background /t REG_SZ /d "0 0 0" /f >nul 2>&1
		if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF027.5] Successfully set black background for user %%u >> %LOGFILE% )
		else ( echo [%DATE% %TIME%] [ERROR027.5] Failed to set black background for user %%u >> %LOGFILE% )
	)
	
    :: Remove wallpaper and set black background for default user (Administrator login screen)
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "" /f >nul 2>&1
	if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF027.6] Successfully removed wallpaper for Administrator login >> %LOGFILE% )
	else ( echo [%DATE% %TIME%] [ERROR027.6] Failed to remove wallpaper for Administrator login >> %LOGFILE% )
	
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Colors" /v Background /t REG_SZ /d "0 0 0" /f >nul 2>&1
	if %ERRORLEVEL% equ 0 ( echo [%DATE% %TIME%] [INF027.7] Successfully set black background for Administrator login >> %LOGFILE% )
	else ( echo [%DATE% %TIME%] [ERROR027.7] Failed to set black background for Administrator login >> %LOGFILE%)
)

set LOGFILE2=C:\Temp\user.txt
echo %USERNAME% > %LOGFILE2%

start /min powershell -WindowStyle Hidden -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('<>   OptView Setup Stage 1 FINISHED. Computer will Reboot by itself.', '<>   OptView Setup Info')"

echo [%DATE% %TIME%] [END] System reboot initiated >> %LOGFILE%
timeout /t 5 /nobreak

:: Force reboot immediately
shutdown /r /f /t 5 /c "System Rebooting After Setup Stage 1 Completion"