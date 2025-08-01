# PowerShell Signature Format Specification

## Overview

This document defines the format and requirements for PowerShell malicious command signatures used in the community contribution system.

## JSON Structure

Signatures are stored in JSON array format in `signatures/community-signatures.json`:

```json
[
  {
    "name": "SIGNATURE_NAME",
    "regex": "pattern",
    "flags": "i",
    "score": 75,
    "severity": "high",
    "description": "Description text",
    "category": "CATEGORY"
  }
]
```

## Field Specifications

### `name` (Required)
- **Type**: String
- **Format**: UPPERCASE with underscores
- **Pattern**: `^[A-Z_]+$`
- **Uniqueness**: Must be unique across all signatures
- **Purpose**: Unique identifier for the signature

**Examples:**
- ✅ `POWERSHELL_ENCODED_COMMAND`
- ✅ `INVOKE_EXPRESSION_SUSPICIOUS`
- ❌ `powershell-encoded` (lowercase)
- ❌ `PowerShell Encoded` (spaces)

### `regex` (Required)
- **Type**: String
- **Format**: Valid JavaScript regular expression
- **Escaping**: Backslashes must be properly escaped (`\\` for literal `\`)
- **Performance**: Should be efficient and avoid catastrophic backtracking
- **Purpose**: Pattern to match against PowerShell commands

**Examples:**
- ✅ `"New-Object\\s+System\\.Net\\.WebClient"`
- ✅ `"Invoke-Expression\\s*\\("`
- ✅ `"\\[System\\.Convert\\]::FromBase64String"`

**Escaping Guide:**
- Literal backslash: `\\\\` (4 backslashes become 1)
- Dot character: `\\.` (escaped dot)
- Word boundary: `\\b`
- Whitespace: `\\s`

### `flags` (Optional)
- **Type**: String
- **Default**: `"i"`
- **Common Values**:
  - `"i"` - Case insensitive (recommended for PowerShell)
  - `"g"` - Global matching
  - `"m"` - Multiline
  - `"gi"` - Global + case insensitive

### `score` (Required)
- **Type**: Number
- **Range**: 0-100
- **Purpose**: Risk assessment score

**Scoring Guidelines:**
- **0-30**: Low risk / Informational
  - Suspicious patterns that may have legitimate uses
  - Reconnaissance activities
  - Unusual but not necessarily malicious behavior

- **31-60**: Medium risk
  - Potentially malicious activities
  - Common attack techniques with possible false positives
  - Obfuscation attempts

- **61-80**: High risk
  - Likely malicious activities
  - Known attack patterns
  - Advanced obfuscation techniques

- **81-100**: Critical risk
  - Definitely malicious activities
  - Known malware signatures
  - Advanced persistent threat techniques

### `severity` (Required)
- **Type**: String
- **Values**: `"info"`, `"medium"`, `"high"`, `"critical"`
- **Alignment**: Should align with score ranges

**Severity Guidelines:**
- **info** (0-30): Informational alerts, potential indicators
- **medium** (31-60): Moderate threat level requiring attention
- **high** (61-80): High threat level requiring immediate attention
- **critical** (81-100): Critical threat requiring urgent response

### `description` (Required)
- **Type**: String
- **Length**: 50-200 characters recommended
- **Format**: Clear, concise explanation
- **Content**: What the signature detects and why it's significant

**Good Examples:**
- ✅ `"Detects PowerShell download cradle using WebClient.DownloadString method"`
- ✅ `"Identifies Base64 encoded command execution via -EncodedCommand parameter"`
- ✅ `"Detects PowerShell Empire staging communication pattern"`

**Poor Examples:**
- ❌ `"Bad stuff"` (too vague)
- ❌ `"This signature detects when PowerShell is used to download files from the internet using the WebClient class which is commonly used by attackers..."` (too long)

### `category` (Required)
- **Type**: String
- **Format**: UPPERCASE
- **Purpose**: Classification based on MITRE ATT&CK framework

**Standard Categories:**

#### `EXECUTION`
Techniques for running malicious code
- Command execution
- Script execution
- Process injection

#### `OBFUSCATION`
Techniques for hiding malicious code
- Base64 encoding
- String concatenation
- Variable substitution
- Character encoding

#### `PERSISTENCE`
Techniques for maintaining access
- Registry modifications
- Startup folder modifications
- WMI event subscriptions

#### `PRIVILEGE_ESCALATION`
Techniques for gaining higher privileges
- UAC bypass
- Token manipulation
- Service exploitation

#### `DEFENSE_EVASION`
Techniques for avoiding detection
- Logging disable
- Process hollowing
- Anti-debugging

#### `CREDENTIAL_ACCESS`
Techniques for stealing credentials
- Password dumping
- Keylogging
- Credential harvesting

#### `DISCOVERY`
Techniques for gathering information
- System enumeration
- Network scanning
- Process discovery

#### `LATERAL_MOVEMENT`
Techniques for moving through network
- Remote service execution
- Shared drive access
- Pass-the-hash

#### `COLLECTION`
Techniques for gathering data
- Data staging
- Screen capture
- Clipboard data

#### `EXFILTRATION`
Techniques for data theft
- Data compression
- Encrypted channels
- Alternative protocols

## Validation Rules

### Automatic Validation
The system automatically validates:
1. JSON syntax correctness
2. All required fields present
3. Field types match specifications
4. Severity values are valid
5. Score is within 0-100 range
6. Regex compiles successfully
7. Name uniqueness

### Manual Review
Human reviewers check for:
1. False positive potential
2. Signature effectiveness
3. Description accuracy
4. Appropriate categorization
5. Duplicate functionality

## Best Practices

### Regex Performance
- Avoid nested quantifiers: `(a+)+`
- Use atomic groups when possible: `(?>pattern)`
- Anchor patterns when appropriate: `^pattern$`
- Test with regex performance tools

### False Positive Minimization
- Include context in patterns
- Avoid overly broad matches
- Consider legitimate admin use cases
- Test against known good commands

### Documentation
- Provide clear, specific descriptions
- Include examples in comments
- Reference attack techniques
- Mention potential false positives

## Examples

### High-Quality Signature
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

### Common Mistakes to Avoid

#### Poor Regex Escaping
```json
{
  "regex": "New-Object System.Net.WebClient"  // ❌ Dots not escaped
}
```

#### Vague Description
```json
{
  "description": "Detects bad PowerShell"  // ❌ Too vague
}
```

#### Inconsistent Severity
```json
{
  "score": 90,
  "severity": "medium"  // ❌ Score and severity don't align
}
```

## Testing Your Signatures

### Local Testing
```bash
# Validate JSON and signature format
npm run validate

# Test specific regex pattern
node -e "console.log(/your-pattern/.test('test-command'))"
```

### Online Regex Testing
- [Regex101](https://regex101.com/) - Set to JavaScript flavor
- [RegExr](https://regexr.com/) - Interactive regex testing
- [RegexPal](https://www.regexpal.com/) - Simple testing interface

### Performance Testing
Monitor for:
- Execution time on large inputs
- Memory usage during matching
- Catastrophic backtracking patterns

## Troubleshooting

### Common Validation Errors

#### "Invalid JSON format"
- Check for missing commas, quotes, or brackets
- Validate JSON with online tools

#### "Invalid regex"
- Check for proper escaping
- Test regex pattern separately

#### "Duplicate signature name"
- Ensure name is unique
- Check existing signatures

#### "Invalid severity"
- Use only: `info`, `medium`, `high`, `critical`
- Check for typos

## Submission Checklist

Before submitting a signature:

- [ ] JSON is valid and properly formatted
- [ ] All required fields are present
- [ ] Regex pattern is properly escaped
- [ ] Name follows UPPERCASE_UNDERSCORE format
- [ ] Score and severity align appropriately
- [ ] Description is clear and specific
- [ ] Category is appropriate
- [ ] No duplicate signatures exist
- [ ] Local validation passes
- [ ] Tested for false positives

---

This specification ensures consistency and quality across all community-contributed signatures.