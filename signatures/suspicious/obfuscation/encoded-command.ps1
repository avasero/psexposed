<#
.SYNOPSIS
    Base64 Encoded Command Execution

.DESCRIPTION
    Detects PowerShell commands that use base64 encoding to obfuscate malicious payloads

.SEVERITY
    critical

.CATEGORY
    obfuscation

.SCORE
    95

.REGEX
    -EncodedCommand|-enc\s+[A-Za-z0-9+/]{20,}

.FLAGS
    i

.EXAMPLES
    powershell -EncodedCommand SQBuAHYAbwBrAGUALQBXAGUAYgBSAGUAcQB1AGUAcwB0AA==
    powershell -enc SQBuAHYAbwBrAGUALQBXAGUAYgBSAGUAcQB1AGUAcwB0AA==
#>

# Exemplos de comandos que esta assinatura detecta
powershell.exe -EncodedCommand SQBuAHYAbwBrAGUALQBXAGUAYgBSAGUAcQB1AGUAcwB0AA==
powershell -enc VwByAGkAdABlAC0ASABvAHMAdAAgACIASABlAGwAbABvACIAs
