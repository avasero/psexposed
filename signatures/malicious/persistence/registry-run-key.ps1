<#
.SYNOPSIS
Registry persistence via Run key detection

.DESCRIPTION
Detects PowerShell commands that attempt to establish persistence by modifying Windows Registry Run keys. This is a common technique used by malware for maintaining access.

.SEVERITY
high

.CATEGORY
persistence

.SCORE
80

.REGEX
Set-ItemProperty.*HKCU.*Run|New-ItemProperty.*HKCU.*Run|reg\s+add.*Run.*powershell

.EXAMPLES
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "UpdateCheck" -Value "powershell.exe -WindowStyle Hidden -File C:\temp\backdoor.ps1"
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "SecurityUpdate" -Value "powershell -enc <base64>"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "WindowsUpdate" /t REG_SZ /d "powershell.exe -ExecutionPolicy Bypass -File malware.ps1"
#>

# Registry persistence establishment
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "TestPersistence" -Value "powershell.exe -File test.ps1"
