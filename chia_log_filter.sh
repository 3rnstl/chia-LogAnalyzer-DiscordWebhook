#!/bin/bash

# Pfad zur Chia-Log-Datei
LOG_FILE="debug.log"

# Webhook URLs
WEBHOOK_URL_WARNINGS="WEBHOOK_PLACEHOLDER"
WEBHOOK_URL_BLOCKS="WEBHOOK_PLACEHOLDER"

# Funktion, um Nachrichten an Discord zu senden
send_to_discord() {
    local webhook_url=$1
    local message=$2
    curl -H "Content-Type: application/json" \
         -d "{\"content\": \"$message\"}" \
         $webhook_url
}

# Skript erfolgreich gestartet
echo "Skript erfolgreich gestartet."

# Überprüfen, ob die Log-Datei existiert
if [ ! -f "$LOG_FILE" ]; then
    echo "Log-Datei nicht gefunden: $LOG_FILE"
    exit 1
fi

# Pfade für die Ausgabedateien
OUTPUT_FILE_WARNINGS="$(dirname "$LOG_FILE")/$(basename "$LOG_FILE" .log)-warnings-errors.log"
OUTPUT_FILE_BLOCKS="$(dirname "$LOG_FILE")/$(basename "$LOG_FILE" .log)-found-blocks.log"

# Timer initialisieren
LAST_LOG_TIME=$(date +%s)
FARM_OFFLINE_NOTIFIED=false

# Überwachung der Log-Datei in Echtzeit
tail -F "$LOG_FILE" | while read line; do
    # Aktuelle Zeit aktualisieren
    CURRENT_TIME=$(date +%s)

    # Überprüfen, ob 5 Minuten ohne jegliche Log-Nachricht vergangen sind
    if (( CURRENT_TIME - LAST_LOG_TIME > 300 )); then
        if [ "$FARM_OFFLINE_NOTIFIED" = false ]; then
            send_to_discord "$WEBHOOK_URL_WARNINGS" "Farm erzeugt keine Logs - Farm Offline"
            echo "Farm erzeugt keine Logs - Farm Offline"
            FARM_OFFLINE_NOTIFIED=true
        fi
    else
        if [ "$FARM_OFFLINE_NOTIFIED" = true ]; then
            send_to_discord "$WEBHOOK_URL_WARNINGS" "Farm erzeugt wieder Logs - Farm online"
            echo "Farm erzeugt wieder Logs - Farm online"
            FARM_OFFLINE_NOTIFIED=false
        fi
    fi

    # Aktualisiere den Timer für jede Log-Nachricht
    LAST_LOG_TIME=$CURRENT_TIME

    # Verarbeite und zeige nur WARNING und ERROR Nachrichten
    if [[ "$line" =~ WARNING|Error ]]; then
        echo "$line"
        echo "$line" >> "$OUTPUT_FILE_WARNINGS"
        send_to_discord "$WEBHOOK_URL_WARNINGS" "$line"
    elif [[ "$line" =~ "Farmed unfinished_block" ]]; then
        echo "$line" >> "$OUTPUT_FILE_BLOCKS"
        send_to_discord "$WEBHOOK_URL_BLOCKS" "$line"
    fi
done
