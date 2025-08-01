# Contributing to PowerShell Signatures Community

🎉 **Thank you for considering contributing to this project!**

This document provides guidelines for contributing PowerShell malicious command signatures to help improve cybersecurity detection capabilities.

## 🚀 Quick Start

1. **Fork** this repository
2. **Clone** your fork locally
3. **Create** a new branch for your contribution
4. **Add** your signature to `signatures/community-signatures.json`
5. **Test** your signature using `npm run validate`
6. **Commit** your changes with a descriptive message
7. **Push** to your fork and create a **Pull Request**

## 📝 Signature Guidelines

### Required Fields

Every signature must include all these fields:

```json
{
  "name": "UNIQUE_SIGNATURE_NAME",
  "regex": "your-regex-pattern",
  "flags": "i",
  "score": 75,
  "severity": "high",
  "description": "Clear description of what this detects",
  "category": "APPROPRIATE_CATEGORY"
}
```

### Field Specifications

#### `name`
- **Format**: UPPERCASE with underscores
- **Pattern**: `[A-Z_]+`
- **Example**: `POWERSHELL_ENCODED_COMMAND`
- **Must be unique** across all signatures

#### `regex`
- **Valid regex pattern** that compiles successfully
- **Escape special characters** properly
- **Test thoroughly** for false positives
- **Consider performance** - avoid overly complex patterns

#### `flags`
- **Common values**: `"i"` (case-insensitive), `"g"` (global), `"m"` (multiline)
- **Recommended**: `"i"` for most PowerShell signatures

#### `score`
- **Range**: 0-100
- **Guidelines**:
  - 0-30: Low risk / informational
  - 31-60: Medium risk
  - 61-80: High risk
  - 81-100: Critical risk

#### `severity`
- **Valid values**: `"info"`, `"medium"`, `"high"`, `"critical"`
- **Should align** with score ranges

#### `description`
- **Clear and concise** explanation
- **Include context** about the threat
- **Mention technique** or attack method
- **Example**: "Detects PowerShell download cradle using WebClient.DownloadString method"

#### `category`
- **Use existing categories** when possible
- **UPPERCASE** formatting
- **Common categories**:
  - `EXECUTION`
  - `OBFUSCATION`
  - `PERSISTENCE`
  - `PRIVILEGE_ESCALATION`
  - `DEFENSE_EVASION`
  - `CREDENTIAL_ACCESS`
  - `DISCOVERY`
  - `LATERAL_MOVEMENT`
  - `COLLECTION`
  - `EXFILTRATION`

## 🎯 Quality Standards

### Good Signature Examples

#### Command Execution Detection
```json
{
  "name": "POWERSHELL_INVOKE_EXPRESSION_SUSPICIOUS",
  "regex": "Invoke-Expression\\s*\\(\\s*\\$",
  "flags": "i",
  "score": 70,
  "severity": "high",
  "description": "Detects suspicious use of Invoke-Expression with variable input",
  "category": "EXECUTION"
}
```

#### Obfuscation Detection
```json
{
  "name": "POWERSHELL_BASE64_DECODE_PATTERN",
  "regex": "\\[System\\.Text\\.Encoding\\]::\\w+\\.GetString\\(\\[System\\.Convert\\]::FromBase64String",
  "flags": "i",
  "score": 85,
  "severity": "high",
  "description": "Detects Base64 decoding pattern commonly used in malicious PowerShell",
  "category": "OBFUSCATION"
}
```

### What Makes a Good Signature

✅ **Specific targeting**: Focuses on malicious patterns, not legitimate use
✅ **Low false positives**: Doesn't trigger on normal system operations  
✅ **Performance conscious**: Uses efficient regex patterns
✅ **Well documented**: Clear description of what it detects
✅ **Proper categorization**: Uses appropriate category and severity
✅ **Tested**: Verified to work as expected

### What to Avoid

❌ **Overly broad patterns**: Matching too many legitimate commands
❌ **Performance killers**: Extremely complex regex with catastrophic backtracking
❌ **Duplicate detections**: Signatures that detect the same thing as existing ones
❌ **Vague descriptions**: Unclear what the signature actually detects
❌ **Wrong severity**: Critical severity for minor issues

## 🧪 Testing Your Signatures

### Local Validation
```bash
# Install dependencies (if needed)
npm install

# Validate all signatures
npm run validate

# Test specific patterns (manual testing recommended)
```

### Testing Recommendations

1. **Test regex patterns** in a regex testing tool first
2. **Verify JSON syntax** is valid
3. **Check for duplicates** against existing signatures
4. **Consider edge cases** and potential false positives
5. **Test with real malicious samples** when possible

## 📋 Pull Request Process

### Before Submitting

- [ ] Signature follows all format requirements
- [ ] JSON is valid and properly formatted
- [ ] `npm run validate` passes successfully
- [ ] Description is clear and accurate
- [ ] No duplicate signatures exist
- [ ] Appropriate category and severity assigned

### PR Description Template

```markdown
## Signature Addition

**Signature Name**: `YOUR_SIGNATURE_NAME`

**Category**: CATEGORY_NAME

**Severity**: severity_level

**Description**: Brief description of what this signature detects

### Testing
- [ ] Validated JSON format
- [ ] Tested regex pattern
- [ ] Checked for false positives
- [ ] Verified uniqueness

### Additional Context
Add any additional context about the threat this signature detects, references to techniques, or real-world examples.
```

## 🔍 Review Process

1. **Automated validation** runs on all PRs
2. **Community review** by maintainers and contributors
3. **Feedback incorporation** if changes are needed
4. **Approval and merge** once requirements are met
5. **Automatic sync** to main repository

## 🤝 Community Guidelines

### Code of Conduct

- Be **respectful** and **professional**
- Focus on **constructive feedback**
- Help **newcomers** learn the process
- Share **knowledge and expertise**
- Maintain **security-focused** discussions

### Communication

- Use **clear, descriptive** commit messages
- Respond to **feedback promptly**
- Ask **questions** when unsure
- Share **references and sources** when helpful

## 📚 Resources

### Learning Resources
- [PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/)
- [MITRE ATT&CK Framework](https://attack.mitre.org/)
- [Regex Testing Tools](https://regex101.com/)

### Security References
- [PowerShell Security Best Practices](https://docs.microsoft.com/en-us/powershell/scripting/security/overview)
- [Common PowerShell Attack Techniques](https://attack.mitre.org/techniques/T1059/001/)

## 📞 Getting Help

- **GitHub Issues**: For bugs or feature requests
- **GitHub Discussions**: For questions and community discussion
- **Security Concerns**: Contact maintainers privately for sensitive issues

## 🙏 Recognition

Contributors will be recognized in:
- Repository contributors list
- Main project acknowledgments
- Community security publications (with permission)

---

**Thank you for helping make PowerShell environments more secure! 🛡️**
