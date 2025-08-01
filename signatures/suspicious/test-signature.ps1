<#
.SYNOPSIS
Test signature for validation purposes

.DESCRIPTION
This is a test signature used for validation testing. It detects suspicious test commands that might be used for testing malicious activities.

.SEVERITY
medium

.CATEGORY
other

.SCORE
50

.REGEX
Test-Command\s+\-Parameter\s+"[^"]*"

.EXAMPLES
Test-Command -Parameter "test"
Test-Command -Parameter "malicious_payload"
#>

Test-Command -Parameter "test"