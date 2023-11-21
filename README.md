# chia-LogAnalyzer-DiscordWebhook

## English Version:

## Description
This script monitors the Chia log file in real-time and sends notifications to Discord when warnings, errors, or found blocks are detected.

## Requirements
- Bash environment
- `curl` installed for HTTP requests

## Configuration
1. Set the path to the Chia log file: `LOG_FILE="debug.log"`
2. Replace `placeholder_discord_webhook_url` with your Discord webhook URLs for warnings and found blocks.

## Usage
Run the script in terminal:
`./chia_log_filter.sh`

## How it Works
Monitors the Chia log file in real-time.
Filters for warnings, errors, and found block events.
Sends filtered messages to the respective Discord webhooks.

-------------------------------------------------------------------------------------------------------------------------------------------------------

## Deutsche Version

## Beschreibung
Dieses Skript überwacht die Chia-Log-Datei in Echtzeit und sendet Benachrichtigungen an Discord, wenn Warnungen, Fehler oder gefundene Blöcke erkannt werden.

## Voraussetzungen
- Bash-Umgebung
- `curl` installiert für HTTP-Anfragen

## Konfiguration
1. Setzen Sie den Pfad zur Chia-Log-Datei: `LOG_FILE="debug.log"`
2. Ersetzen Sie `placeholder_discord_webhook_url` mit den Webhook-URLs von Discord für Warnungen und gefundene Blöcke.

## Verwendung
Führen Sie das Skript im Terminal aus:
`./chia_log_filter.sh`

## Funktionsweise
Überwacht die Chia-Log-Datei in Echtzeit.
Filtert Warnungen, Fehler und Ereignisse von gefundenen Blöcken.
Sendet gefilterte Nachrichten an die entsprechenden Discord-Webhooks.
