<#
.SYNOPSIS
WMI persistence establishment

.DESCRIPTION
Detects PowerShell commands that establish persistence using Windows Management Instrumentation (WMI) event subscriptions. This technique is often used by advanced persistent threats (APTs) for maintaining long-term access.

.SEVERITY
high

.CATEGORY
persistence

.SCORE
85

.REGEX
Register-WmiEvent|New-WmiEventFilter|Set-WmiInstance.*__EventFilter|__IntervalTimerInstruction

.FLAGS
i

.EXAMPLES
Register-WmiEvent -Query "SELECT * FROM Win32_ProcessStartTrace" -Action { Start-Process powershell.exe }
Set-WmiInstance -Class __EventFilter -Arguments @{Name="MaliciousFilter"; EventNameSpace="root\cimv2"; Query="SELECT * FROM Win32_ProcessStartTrace"; QueryLanguage="WQL"}
New-WmiEventFilter -FilterName "SystemMonitor" -Query "SELECT * FROM __InstanceModificationEvent"
#>

# WMI persistence example
Register-WmiEvent -Query "SELECT * FROM Win32_ProcessStartTrace" -Action { Start-Process calc.exe }
