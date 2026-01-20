import csv
import json
import os
import requests

API_URL = "https://api.powershell.exposed/evaluate"
API_TOKEN = "<ADD-YOUR-API-KEY>"
CSV_FILE = "commands.csv"
OUTPUT_DIR = "outputs"

SAVE_SEVERITIES = {"high", "critical"}  # only save if analysis.severity is one of these

os.makedirs(OUTPUT_DIR, exist_ok=True)

headers = {
    "Authorization": f"Bearer {API_TOKEN}",
    "Content-Type": "application/json",
}

def extract_analysis_severity(api_json: dict) -> str | None:
    """
    Expected shape (based on example):
    api_json["response"]["analysis"]["severity"]
    """
    try:
        sev = api_json["response"]["analysis"]["severity"]
        return sev.lower().strip() if isinstance(sev, str) else None
    except (KeyError, TypeError, AttributeError):
        return None

def is_success(api_json: dict) -> bool:
    try:
        return bool(api_json["response"]["success"]) is True
    except (KeyError, TypeError):
        return False

def main() -> None:
    with open(CSV_FILE, newline="", encoding="utf-8") as csvfile:
        reader = csv.reader(csvfile)

        # Skip header row
        next(reader, None)

        for line_number, row in enumerate(reader, start=2):
            if not row or not row[0].strip():
                continue

            command = row[0].strip()
            payload = {"command": command}

            output_data = {
                "line_number": line_number,
                "command": command,
                "request_payload": payload,
            }

            try:
                r = requests.post(API_URL, json=payload, headers=headers, timeout=10)
                output_data["status_code"] = r.status_code

                # Parse JSON if possible
                try:
                    output_data["response"] = r.json()
                except ValueError:
                    output_data["response"] = {"raw_text": r.text}

            except requests.exceptions.RequestException as e:
                output_data["error"] = str(e)
                print(f"[Line {line_number}] Request failed: {e}")
                continue

            sev = extract_analysis_severity(output_data)
            ok = is_success(output_data)

            if ok and sev in SAVE_SEVERITIES:
                output_file = os.path.join(OUTPUT_DIR, f"result_line_{line_number}.json")
                with open(output_file, "w", encoding="utf-8") as f:
                    json.dump(output_data, f, indent=2, ensure_ascii=False)

                print(f"[Line {line_number}] severity={sev} ✅ saved → {output_file}")
            else:
                print(f"[Line {line_number}] severity={sev} ❌ not saved")

if __name__ == "__main__":
    main()
