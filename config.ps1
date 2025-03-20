Add-Type -AssemblyName System.Windows.Forms

# Get User Name
$userName = $env:USERNAME

# Get PC Name
$pcName = $env:COMPUTERNAME

# Check Auto-Login Status
$autoLogin = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoAdminLogon" -ErrorAction SilentlyContinue
if ($autoLogin.AutoAdminLogon -eq "1") {
    $autoLoginStatus = " Enabled "
} else {
    $autoLoginStatus = " Disabled "
}

# Check UAC Status
$uacStatus = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -ErrorAction SilentlyContinue
if ($uacStatus.EnableLUA -eq 1) {
    $uacState = "UAC Enabled"
} else {
    $uacState = "UAC Disabled"
}

# Create Message
$message = "     User Name = $userName`n`n     PC Name = $pcName`n`n     Auto-Login = $autoLoginStatus`n`n     UAC Status = $uacState"

# Show Message Box
[System.Windows.Forms.MessageBox]::Show($message, "  OptView System Info  ", "  OK  ", "Information")
