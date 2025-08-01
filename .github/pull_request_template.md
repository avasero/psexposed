## 🛡️ Signature Contribution

**Type of contribution:** 
- [ ] New signature
- [ ] Bug fix
- [ ] Documentation update
- [ ] Other: ___________

### Signature Details

**Signature Name:** `YOUR_SIGNATURE_NAME`

**Category:** CATEGORY_NAME

**Severity:** severity_level (info/medium/high/critical)

**Score:** XX (0-100)

### Description
Brief description of what this signature detects and why it's important.

### Testing Checklist
- [ ] JSON format is valid
- [ ] `npm run validate` passes
- [ ] Regex pattern tested and works correctly
- [ ] Checked for potential false positives
- [ ] Verified signature name is unique
- [ ] Description is clear and accurate
- [ ] Appropriate category and severity assigned

### Examples
Provide examples of commands this signature should detect:

```powershell
# Example malicious command that should trigger this signature
Example-Command -Parameter "suspicious pattern"
```

### False Positives
List any legitimate commands that might trigger this signature and explain why the risk is acceptable:

- None identified
- OR
- Legitimate use case X might trigger, but this is rare because...

### References
- MITRE ATT&CK Technique: [TXXXX](https://attack.mitre.org/techniques/TXXXX/)
- Security research: [Link if applicable]
- CVE: CVE-XXXX-XXXX [if applicable]

### Additional Context
Add any other context about this signature, such as:
- Real-world attack campaigns where this pattern was observed
- Variations of the technique this signature covers
- Recommendations for response actions

---

### For Maintainers
- [ ] Code review completed
- [ ] Signature effectiveness verified
- [ ] Documentation is adequate
- [ ] No conflicts with existing signatures
