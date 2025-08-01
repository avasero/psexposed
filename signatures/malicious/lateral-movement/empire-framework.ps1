<#
.SYNOPSIS
PowerShell Empire framework detection

.DESCRIPTION
Detects execution of PowerShell Empire framework commands, a powerful post-exploitation agent framework commonly used by red teams and malicious actors for maintaining persistence and lateral movement.

.SEVERITY
critical

.CATEGORY
lateral-movement

.SCORE
90

.REGEX
Invoke-Empire|powershell\s+.*-sta\s+.*-Enc\s+[A-Za-z0-9+/]+|Empire\.ps1|PowerShellEmpire

.FLAGS
i

.EXAMPLES
powershell.exe -sta -Enc SABlAGwAbABvACAAVwBvAHIAbABkACEA
Invoke-Empire -Listener http -Server 192.168.1.100
Import-Module Empire.ps1; Invoke-EmpireAgent
#>

# PowerShell Empire framework execution example
powershell.exe -sta -Enc SABlAGwAbABvACAAVwBvAHIAbABkACEA
