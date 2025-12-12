#  ps.exposed

**Community-driven PowerShell Detection Indicators**

This project is a collaborative collection of pattern-based, **detection indicators** for spotting potential suspicious PowerShell (PS) commands, 'one-liners'.

Each indicator comprises of a regular expression (regex) mapped to **MITRE ATT&CK** framework, helping cybersecurity teams flag and detect potential threats leveraging PowerShell. Ultimately, the idea is to use those as input for detection models, not be be used as atomic alerts.

The [project website](https://ps.exposed) also provides a web application + API for systematically evaluating PS payloads.

###  Indicator Definition (Format)

Each indicator should follow this YAML format:

```yaml
name: Indicator Name
description: Detailed description of what the indicator detects
regex: regular_expression_here
basescore: 1.0-10.0
max_match: 1
tactic: MITRE_Tactic
technique: TXXXX.XXX
reference:
  - https://example.com/reference
```

####  Parameters Breakdown

In your Pull Request, include:
- **Name:** What the indicator spots?
- **Description:** Why it's important (brief)?
- **Reference:** What drives the new indicator?
- **Max Match:** See below
- **Base Score:** See below

#### Max Matches: Controlling how many regex groups are considered

Some indicators regex might contain multiple patterns in its definition, usually separated by the pipe character ("|"). For instance:

```yaml
# Snippet from an simple multi-match indicator
name: Invoke-Expression Cmdlet
regex: Invoke-Expression|\biex\b
max_match: 1
```

In that case, within the results, only 1 match will be considered and that affects what's displayed as 'matches' in the results, as well as model scoring (in case you do). The value of '1' is the **default**, which applies to the vast majority of indicators.

In case an indicator comprises of multiple patterns such as the one below, setting max_match>1 will not only display multiple 'matches' but can also influence in how your detection model deals with multiple matches given the indicator base score. 

```yaml
# Snippet from a larger multi-match indicator
name: Highly suspicious keywords
regex: bitstransfer|mimik|metasp|psrecon|-persistence|AssemblyBuilderAccess|Reflection\.Assembly|shellcode|injection|BypassUAC|UACBypass|Rc4ByteStream|\blsass|LastLoggedOn|hijack|BackupPrivilege|comsvcs|backdoor|brute.?force
max_match: 3
```

#### Example

```yaml
# Example indicator
name: Invoke-Expression Cmdlet
description: Spots potential use of Invoke-Expression cmdlet and its alias.
regex: Invoke-Expression|\biex\b
basescore: 5.0
max_match: 1 #maximum number of times an indicator can be triggered
tactic: Execution
technique: T1059.001
reference:
  - https://github.com/SigmaHQ/sigma/blob/master/rules/windows/process_creation/proc_creation_win_susp_web_request_cmd_and_cmdlets.yml
```

#### **Base Scoring**: The initial score for each individual indicator 

Each indicator entry defines a regular expression pattern that, when matched against a PowerShell payload, can signal the presence of specific behaviors or activities, whether benign or suspicious.

The "base" score helps determine the initial relevance of each indicator within the overall potential attack chain.

| Score | Severity | Color | Matching Pattern |
|-------|----------|-------|-------------|
| 1   | 🔵 Informational  | Blue | Extremely common, benign behavior |
| 2-4   | 🟢 Low       | Green | Notable activity |
| 5-7   | 🟡 Medium    | Yellow | Fairly suspicious activity |
| 8-9   | 🟠 High      | Orange | Highly suspicious activity |
| 10  | 🔴 Critical  | Red | Extremely suspicious activity |

Aside from _Critical_ indicators, no single indicator should be considered **alertable** on its own! ⚠️

That said, it’s strongly recommended to use indicators as part of a broader detection model.

##  How to Contribute

The contribution process is simple and straightforward:

1. **Create a branch** for your contribution
2. **Add a new indicator** in the `indicators/` folder following the standard YAML format
3. **Create a Pull Request** describing what the indicator does and its purpose
4. **After merge**, the indicator will be automatically integrated into the application

##  References

- [MITRE ATT&CK Framework](https://attack.mitre.org/)
- [SIGMA Detection Rules](https://github.com/SigmaHQ/sigma)
- [Atomic Red Team](https://github.com/redcanaryco/atomic-red-team)
- [PowerShell Security Best Practices](https://docs.microsoft.com/en-us/powershell/scripting/security/overview)

##  Community

-  [Discussions](https://github.com/en20/psexposed/discussions) - Questions and discussions
-  [Issues](https://github.com/en20/psexposed/issues) - Bugs and improvements
-  [Wiki](https://github.com/en20/psexposed/wiki) - Detailed documentation

##  License

This project is licensed under the [MIT License](LICENSE).

---

<div align="center">

** Spotting Suspicious PowerShell payloads, one indicator at a time.**

[Issues](https://github.com/avasero/psexposed/issues) • [Discussions](https://github.com/avasero/psexposed/discussions)

</div>
