import csv
import json
import os
import glob
import requests

API_URL = "https://api.powershell.exposed/evaluate"
API_TOKEN = "your_psexposed_api_key_here"
COMMANDS_DIR = "commands"
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

def process_csv(csv_file: str) -> None:
    print(f"\n{'='*60}")
    print(f"Processing: {csv_file}")
    print(f"{'='*60}")

    with open(csv_file, newline="", encoding="utf-8") as csvfile:
        reader = csv.reader(csvfile)

        # Skip header row
        next(reader, None)

        for line_number, row in enumerate(reader, start=2):
            if not row or not row[0].strip():
                continue

            command = row[0].strip()
            payload = {"command": command}

            output_data = {
                "source_file": os.path.basename(csv_file),
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
                print(f"[{os.path.basename(csv_file)}:Line {line_number}] Request failed: {e}")
                continue

            sev = extract_analysis_severity(output_data)
            ok = is_success(output_data)

            if ok and sev in SAVE_SEVERITIES:
                base_name = os.path.splitext(os.path.basename(csv_file))[0]
                output_file = os.path.join(OUTPUT_DIR, f"{base_name}_line_{line_number}.json")
                with open(output_file, "w", encoding="utf-8") as f:
                    json.dump(output_data, f, indent=2, ensure_ascii=False)

                print(f"[Line {line_number}] severity={sev} saved -> {output_file}")
            else:
                print(f"[Line {line_number}] severity={sev} not saved")

def main() -> None:
    csv_files = glob.glob(os.path.join(COMMANDS_DIR, "*.csv"))

    if not csv_files:
        print(f"No CSV files found in '{COMMANDS_DIR}/' directory.")
        print(f"Add your CSV files to the '{COMMANDS_DIR}/' folder and run again.")
        return

    print(f"Found {len(csv_files)} CSV file(s) to process.")

    for csv_file in csv_files:
        process_csv(csv_file)

    print(f"\n{'='*60}")
    print("Processing complete. Check the 'outputs/' folder for results.")
    print(f"{'='*60}")

if __name__ == "__main__":
    main()
