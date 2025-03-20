Set objShell = CreateObject("WScript.Shell")
objShell.Run "powershell.exe -windowstyle hidden -ExecutionPolicy Bypass -File ""C:\Temp\config.ps1""", 0, True