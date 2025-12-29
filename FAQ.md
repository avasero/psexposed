## 📘 FAQ

### 1. Why relying on Regular Expressions (RegEx)?

- Regex focuses on behavior patterns rather than static strings, making detections more resilient to small attacker changes like renamed files, modified arguments, or reordered commands.
- Regex-based indicators translate easily across SIEMs and EDRs, enabling vendor-agnostic detections that can be reused in Sigma, SPL, KQL, and other platforms.
- Regex is ideal for low-level signals that aren’t malicious alone but become high-value when combined with additional context, supporting precise, layered detections instead of noisy alerts.

---

### 2. Does it mean using Regular Expressions is enough?

Absolutely not!

Any regex match simply indicates yet another trace/behavior present in the PS command. By combining those with anomaly detection and general data analytics strategies (grouping, scoring, etc), the regular expressions are very powerful.

---

### 3. Why not creating Sigma rules instead?

There are multiple reasons here. Below a few highlights:

- The way Sigma is consumed today might not be idea for these type of indicators given they are simply that, not actual detections.
- The structure used in Sigma requires more metadata and we wanted to create a very simple regex DB of PS indicators.
- The regex value is easily expanded and fits pretty much any SIEM/EDR/Detection product as the values are PCRE-compliant.

### 3. What's the ReGex format used?

The regular expressions used in this project follow the [Perl Compatible Regular Expressions](https://www.pcre.org/) (PCRE) standard.

#### 3.1 A few notes to consider when using regex in Splunk/SPL:

- The reverse slash must be double escaped in SPL. Therefore, anywhere you see a "\\" consider adding an extra reverse slash to consume the regex in SPL. Reference [here](https://help.splunk.com/en/splunk-enterprise/search/search-manual/9.4/expressions-and-predicates/spl-and-regular-expressions).
- Some indicators (ex.: [Encoded command usage](https://github.com/avasero/psexposed/blob/main/indicators/ps_indicator_encodedcommand.yaml)) make use of unicode char references. PCRE follows \uXXXX template in patterns whereas Splunk's SPL expects unicode as \x{XXXX}. We are going to warn you about that in each indicator but consider that in case you consume the indicators 'as is'.

#### 3.2 A few notes to consider when consuming the regex values:

##### 3.2.1 All regex values are case **IN**sensitive by default, unless explicitly referenced in the description. Note: some implementation do support `(?-i)` flag in front of the regex value (e.g., KQL) so consider that.

##### 3.2.2 Make sure they are wrapped with double quotes as those are escaped within the values themselves, unless you want to revert it by escaping the single quotes instead.
