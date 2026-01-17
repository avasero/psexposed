# 🤝 How to Contribute to PSExposed

his guide will help you submit new PowerShell security indicators for the community.

## 🚀 Ways to Contribute

### 1. 📝 Submit New Indicators

**Via Pull Request:**
1. Fork the repository
2. Create a branch: `git checkout -b new-indicator-[name]`
3. Add your file to the `indicators/` folder
4. Submit a Pull Request

### 2. 🐛 Report Issues

If you found a problem with an existing indicator:
1. [Report the bug here](https://github.com/en20/psexposed/issues/new?template=bug-report.md)
2. Describe the problem in detail
3. Include examples when possible

## 📋 Indicator Format

Each indicator must be a YAML file in the format:

```yaml
name: Indicator Name
description: Description of what the indicator detects
regex: regex_pattern_here
basescore: 5.0
tactic: [MITRE ATT&CK Tactic]
technique: [MITRE ATT&CK Technique]
reference:
  - https://link-to-documentation.com
```

### 📁 Naming Convention

Files must follow the pattern:
```
ps_indicator_[name_with_underscores].yaml
```

**Examples:**
- `ps_indicator_invoke_expression_cmdlet.yaml`
- `ps_indicator_scheduled_task_modification.yaml`


## 🧪 Testing Regex

We recommend testing your regex patterns using:
- [Regex101](https://regex101.com/) - For testing and documentation
- [RegExr](https://regexr.com/) - User-friendly testing interface

### Test Example
```powershell
# Command to be detected
Invoke-Expression "malicious_payload"

# Regex
Invoke-Expression|\biex\b

# Should match: ✅
# False positives: Check legitimate commands
```

## 📚 Useful Resources

### MITRE ATT&CK Framework
- [MITRE ATT&CK](https://attack.mitre.org/)
- [Techniques for Windows](https://attack.mitre.org/tactics/enterprise/)

### PowerShell Security References
- [SIGMA Rules](https://github.com/SigmaHQ/sigma)
- [Atomic Red Team](https://github.com/redcanaryco/atomic-red-team)
- [PowerShell Security Best Practices](https://docs.microsoft.com/en-us/powershell/scripting/security/overview)

## 🔄 Review Process

1. **Submission**: Via issue or PR
2. **Technical Review**: Quality and accuracy verification
3. **Testing**: Regex and examples validation
4. **Approval**: Merge to main repository
5. **Synchronization**: Automatic integration with detection systems

## 💬 Need Help?

- 📧 Open an [issue](https://github.com/en20/psexposed/issues)
- 💭 Use [Discussions](https://github.com/en20/psexposed/discussions) for questions
- 📖 Check documentation in `README.md`

## 🙏 Acknowledgments

All contributions are recognized and credited. The creators and maintainers are also listed at the [PowerShell.Exposed](https://powershell.exposed) website.

---

**Thank you for helping make PowerShell more secure! 🛡️**
