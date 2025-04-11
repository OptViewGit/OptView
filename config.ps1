# Define the log file path
$LogFile = "C:\Temp\OptViewSetup.log"

function Write-Log {# Function to write to the log file
    param ([string]$Message)
    $Timestamp = Get-Date -Format "[yyyy-MM-dd HH:mm:ss.fff]"
    Add-Content -Path $LogFile -Value "$Timestamp $Message"
}
Write-Log "========== START SCRIPT =========="

# Check if the 'WinAPI' type already exists
if (-not ([System.Management.Automation.PSTypeName]'WinAPI').Type) {
    Add-Type @"
    using System;
    using System.Runtime.InteropServices;

    public class WinAPI {
        [DllImport("kernel32.dll")]
        public static extern IntPtr GetConsoleWindow();
        [DllImport("user32.dll")]
        public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    }
"@
}

