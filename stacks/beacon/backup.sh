#!/bin/bash

# Backup all named Docker volumes in the beacon stack into individual files
set -e

# Set the server name (change this if your server uses a different name)
SERVER_NAME="rainhold-beacon"

# Source shared volumes variable
. "$(dirname "$0")/volumes.sh"

EMAIL="admin@notclickable.com"
DATE_SUFFIX="$(date '+%Y-%m-%d')"
BACKUP_FOLDER="$DATE_SUFFIX"

# Get the number of entries in the VOLUMES variable
SERVICE_COUNT=${#VOLUMES[@]}

echo "Starting backup of Docker volumes"

# Create backup folder locally
mkdir -p "$BACKUP_FOLDER"

# Track start time
START_TIME=$(date +%s)

# Process volumes one at a time, creating individual backup files
for entry in "${VOLUMES[@]}"; do
  VOLUME="${entry%%:*}"
  MOUNT_PATH="${entry#*:}"
  BACKUP_FILE="${VOLUME}.tgz"
  
  echo "Backing up $VOLUME..."
  
  # Use the same tar command structure as the old backup script
  docker run --rm \
    --mount type=volume,source="$VOLUME",target="$MOUNT_PATH",readonly \
    -v "$(pwd)/$BACKUP_FOLDER:/backup" \
    alpine:3.17.2 sh -c "tar -C $MOUNT_PATH -czf /backup/${BACKUP_FILE} ."
done

# Calculate elapsed time
END_TIME=$(date +%s)
ELAPSED_SEC=$((END_TIME - START_TIME))
ELAPSED_MIN=$((ELAPSED_SEC / 60))
if [ $ELAPSED_MIN -eq 0 ]; then
  ELAPSED_STR="Less than 1 minute"
else
  ELAPSED_STR="$ELAPSED_MIN minutes"
fi

# Get total backup size
BACKUP_SIZE=$(du -h "$BACKUP_FOLDER" | tail -n 1 | awk '{print $1}')

echo "Backup complete: $BACKUP_FOLDER"

# Move backup folder to remote location
TARGET_FOLDER="$BACKUP_PATH"
if [ -d "$TARGET_FOLDER" ]; then
  echo "Moving backup to $TARGET_FOLDER"
  mv "$BACKUP_FOLDER" "$TARGET_FOLDER/"
  
  # Clean up old backups (keep last 7 days)
  find "$TARGET_FOLDER" -maxdepth 1 -name "20*" -type d -mtime +7 -exec rm -rf {} \;
  
  BACKUP_LOCATION="$TARGET_FOLDER/$BACKUP_FOLDER"
else
  echo "WARNING: Backup destination not accessible. Files remain local: $BACKUP_FOLDER"
  BACKUP_LOCATION="$(pwd)/$BACKUP_FOLDER"
fi

HUMAN_DATE="$(date '+%B %-d, %Y at %I:%M %p')"

# Compose email body
MAIL_BODY="Backup completed on $HUMAN_DATE\nTime elapsed: $ELAPSED_STR\n\nLocation: $BACKUP_LOCATION\nSize: $BACKUP_SIZE\nVolumes: $SERVICE_COUNT\n"

echo -e "$MAIL_BODY" | mail -s "${SERVER_NAME} backup complete" "$EMAIL"