#!/bin/bash

# Path to journald.conf
CONF_FILE="/etc/systemd/journald.conf"

# Backup file
BACKUP_FILE="$CONF_FILE.bak.$(date +%F-%T)"

# Create backup
cp "$CONF_FILE" "$BACKUP_FILE"
echo "Backup created at: $BACKUP_FILE"

# Define settings to update
declare -A settings=(
  ["Storage"]="persistent"
  ["Compress"]="yes"
  ["SystemMaxUse"]="500M"
  ["SystemKeepFree"]="100M"
  ["SystemMaxFileSize"]="50M"
  ["SystemMaxFiles"]="100"
  ["MaxRetentionSec"]="1month"
  ["MaxFileSec"]="1month"
)

# Loop and apply changes
for key in "${!settings[@]}"; do
  value=${settings[$key]}

  # If key exists (commented or not), replace it
  if grep -qE "^[#]*\s*$key=" "$CONF_FILE"; then
    sed -i "s|^[#]*\s*$key=.*|$key=$value|" "$CONF_FILE"
  else
    # Append after [Journal] if missing
    sed -i "/^\[Journal\]/a $key=$value" "$CONF_FILE"
  fi
done

echo "journald.conf updated."

# Restart systemd-journald to apply changes
echo "Restarting systemd-journald..."
systemctl restart systemd-journald

# Show current journal disk usage
echo "Current journal disk usage:"
journalctl --disk-usage
