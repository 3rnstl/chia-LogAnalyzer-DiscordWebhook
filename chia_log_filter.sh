#!/bin/bash

# Path to the Chia log file / Pfad zur Chia-Log-Datei
LOG_FILE="debug.log"

# Webhook URLs
WEBHOOK_URL_WARNINGS="placeholder_discord_webhook_url"
WEBHOOK_URL_BLOCKS="placeholder_discord_webhook_url"

# Function to send messages to Discord / Funktion, um Nachrichten an Discord zu senden
send_to_discord() {
    local webhook_url=$1
    local message=$2
    curl -H "Content-Type: application/json" \
         -d "{\"content\": \"$message\"}" \
         $webhook_url
}

# Check if the log file exists / Überprüfen, ob die Log-Datei existiert
if [ ! -f "$LOG_FILE" ]; then
    echo "Log-Datei nicht gefunden: $LOG_FILE"
    exit 1
fi

# Paths for the output filesPfade für die Ausgabedateien
OUTPUT_FILE_WARNINGS="$(dirname "$LOG_FILE")/$(basename "$LOG_FILE" .log)-warnings-errors.log"
OUTPUT_FILE_BLOCKS="$(dirname "$LOG_FILE")/$(basename "$LOG_FILE" .log)-found-blocks.log"

# Monitoring the log file in real time / Überwachung der Log-Datei in Echtzeit
tail -F "$LOG_FILE" | while read line; do
    if [[ "$line" =~ WARNING|Error ]]; then
        echo "$line" >> "$OUTPUT_FILE_WARNINGS"
        send_to_discord "$WEBHOOK_URL_WARNINGS" "$line"
    elif [[ "$line" =~ "Farmed unfinished_block" ]]; then
        echo "$line" >> "$OUTPUT_FILE_BLOCKS"
        send_to_discord "$WEBHOOK_URL_BLOCKS" "$line"
    fi
done
