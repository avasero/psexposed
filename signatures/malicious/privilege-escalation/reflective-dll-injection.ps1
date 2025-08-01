<#
.SYNOPSIS
Reflective DLL injection detection

.DESCRIPTION
Detects PowerShell commands that perform reflective DLL injection, a technique used to load malicious DLLs directly into memory without touching disk. This is commonly used in advanced malware and penetration testing tools.

.SEVERITY
critical

.CATEGORY
privilege-escalation

.SCORE
90

.REGEX
Invoke-ReflectivePEInjection|Invoke-DllInjection|\[System\.Reflection\.Assembly\]::Load|\[Reflection\.Assembly\]::Load|VirtualAlloc.*PAGE_EXECUTE_READWRITE

.FLAGS
i

.EXAMPLES
Invoke-ReflectivePEInjection -PEBytes $PEBytes -FuncReturnType Void
[System.Reflection.Assembly]::Load($bytes)
$VirtualAlloc = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VirtualAllocAddr, (Get-DelegateType @([IntPtr], [UInt32], [UInt32], [UInt32]) ([IntPtr])))
#>

# Reflective DLL injection example
[System.Reflection.Assembly]::Load($maliciousDllBytes)
