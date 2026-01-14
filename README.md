#  ps.exposed

**Community-driven PowerShell Detection Indicators**

This project is a collaborative collection of pattern-based **detection indicators** designed to identify potentially suspicious PowerShell (PS) payloads. Its purpose is not only to surface notable indicators within full scripts, but also to analyze PowerShell **one-liners**, those small commands often containing encoded content, obfuscation, staging logic, or execution intent.

Each indicator comprises of a regular expression (regex) mapped to **MITRE ATT&CK** framework, helping cybersecurity teams flag and detect potential threats leveraging PowerShell. Ultimately, the idea is to use those as input for **detection models**, not be be used as atomic alerts.

The [project website](https://ps.exposed) also provides a web application + API for systematically evaluating PS payloads.

###  Indicator Definition (Format)

Each indicator must follow the following YAML format:

```yaml
name: Indicator Name
description: Brief description of what the indicator detects
regex: regular_expression_here (PCRE)
basescore: 1.0-10.0
max_match: 1-5
tactic: TXXXXX
technique: TXXXX.XXX
reference:
  - URL
```

####  Parameters Breakdown

- **Name:** What the indicator spots?
- **Description:** Why it's important (brief)?
- **Reference:** What has driven or inspired you?
- **Max Match:** See below
- **Base Score:** See below

#### Max Matches: Controlling how many maximum regex groups make into the results

Some indicators regex might contain multiple patterns, usually separated by the pipe character ("|"). For instance:

```yaml
name: WMI usage
description: Detects general WMI usage by matching against common WMI code references.
regex: WmiCommand|wmiclass|PowerShellWMI|wmiobject|WMIMethod|RemoteWMI|Win32_Process|(iwmi|gwmi)\s+
basescore: 5
tactic: [TA0002]
technique: [T1047]
reference:
  - https://attack.mitre.org/techniques/T1047/
```

In that case, only **one** match displayed in the results, even if the payload matches multiple patterns present in the regex. That's because there's an implied maxmatch = 1. That's the **default**, which applies to the vast majority of indicators.

Now, in case an indicator comprises of multiple patterns such as the one below, setting max_match>1 will not only display multiple 'matches' but can also influence in how your detection model deals with multiple matches given the indicator base score. 

```yaml
name: Highly suspicious keywords
description: Detects the presence of multiple high-risk PowerShell keywords and behavioral primitives commonly associated with post-exploitation, credential access, lateral movement, defense evasion, and payload staging.
regex: (start|complete)-bitstransfer|psrecon|-persistence|Reflection\.Assembly|spraying|shellcode|injection|BypassUAC|UACBypass|Rc4ByteStream|System\.Security\.Cryptography||DumpCreds|-decrypt # Truncated
maxmatch: 2
basescore: 8.2
tactic: TA0002
technique: T1059.001
reference:
  - https://github.com/SigmaHQ/sigma/blob/master/rules/windows/process_creation/proc_creation_win_powershell_malicious_cmdlets.yml
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

Aside from _Critical_ and some _High_ indicators, no single indicator should be considered **alertable** on its own! ⚠️

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

**Spotting Suspicious PowerShell payloads, one indicator at a time.**

[Issues](https://github.com/avasero/psexposed/issues) • [Discussions](https://github.com/avasero/psexposed/discussions)

</div>
