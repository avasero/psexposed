<#
.SYNOPSIS
    Credential Harvesting via Get-Credential

.DESCRIPTION
    Detects uso do cmdlet Get-Credential que pode ser usado para capturar credenciais de usuários

.SEVERITY
    high

.CATEGORY
    credential-theft

.SCORE
    85

.REGEX
    Get-Credential

.FLAGS
    i

.EXAMPLES
    $cred = Get-Credential
    Get-Credential -Message "Enter your credentials"
    $credential = Get-Credential -UserName "admin"
#>

# Exemplos de comandos que esta assinatura detecta
$cred = Get-Credential
$credential = Get-Credential -Message "Please enter your credentials"
Get-Credential -UserName "domain\admin" -Message "Authentication Required"
