# shell-scripts

## Live Log Tailing with Highlighted Errors of Service

` journalctl -u pcds-global-api.service -f | grep -E --color=always "ERROR|WARN|EXCEPTION"`
