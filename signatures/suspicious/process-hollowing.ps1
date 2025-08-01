<#
.SYNOPSIS
Process hollowing technique detection

.DESCRIPTION
Detects PowerShell implementations of process hollowing, a technique where attackers create a legitimate process in suspended state, replace its memory with malicious code, and resume execution. This is a sophisticated evasion technique.

.SEVERITY
critical

.CATEGORY
lateral-movement

.SCORE
95

.REGEX
CreateProcess.*CREATE_SUSPENDED|NtUnmapViewOfSection|VirtualAllocEx.*PAGE_EXECUTE_READWRITE|WriteProcessMemory.*SetThreadContext|ResumeThread

.FLAGS
i

.EXAMPLES
$ProcessInfo = [Activator]::CreateInstance($ProcessStartupInfoType); $ProcessInfo.dwFlags = 0x00000001; $Success = $CreateProcess.Invoke($null, $CommandLine, [IntPtr]::Zero, [IntPtr]::Zero, $false, 0x00000004, [IntPtr]::Zero, $null, [Ref]$ProcessInfo, [Ref]$ProcessInformation)
$NtUnmapViewOfSection.Invoke($ProcessInformation.hProcess, $PebBaseAddress)
$VirtualAllocEx.Invoke($ProcessInformation.hProcess, $ImageBase, $SizeOfImage, 0x3000, 0x40)
#>

# Process hollowing example
$Success = $CreateProcess.Invoke($null, "svchost.exe", [IntPtr]::Zero, [IntPtr]::Zero, $false, 0x00000004, [IntPtr]::Zero, $null, [Ref]$ProcessInfo, [Ref]$ProcessInformation)
