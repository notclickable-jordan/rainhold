#!/bin/bash

# Backup all named Docker volumes in the beacon stack into a single archive
set -e

# Set the server name (change this if your server uses a different name)
SERVER_NAME="rainhold-beacon"

# Source shared volumes variable
. "$(dirname "$0")/volumes.sh"

EMAIL="admin@notclickable.com"
DATE="$(date '+%Y-%m-%d %H:%M:%S')"
DATE_SUFFIX="$(date '+%Y-%m-%d')"
BACKUP_FILE="${SERVER_NAME}-${DATE_SUFFIX}.tgz"

# Get the number of entries in the VOLUMES variable
SERVICE_COUNT=${#VOLUMES[@]}

echo "[Backup] Starting backup of Docker volumes"

# Create a temporary directory for the backup
TMPDIR=$(mktemp -d)
echo "[Backup] Created temporary directory: $TMPDIR"

# Build mount args (no longer needed as we process individually)
echo "[Backup] Preparing to process volumes"

# Track start time
START_TIME=$(date +%s)

# Process volumes one at a time to reduce memory pressure
total=${#VOLUMES[@]}
i=1
for entry in "${VOLUMES[@]}"; do
  VOLUME="${entry%%:*}"
  MOUNT_PATH="${entry#*:}"
  echo "[$i/$total] Processing $VOLUME from $MOUNT_PATH"
  
  # Process each volume individually with direct compression
  docker run --rm \
    --mount type=volume,source="$VOLUME",target="$MOUNT_PATH",readonly \
    -v "$TMPDIR:/backup" \
    alpine:3.17 sh -c "
      echo 'Compressing $VOLUME...'
      tar -czf /backup/${VOLUME}.tgz -C $MOUNT_PATH .
      echo 'Completed $VOLUME'
    "
  
  i=$((i+1))
done

echo "[Backup] Combining all volume archives into $BACKUP_FILE"
cd "$TMPDIR"
tar -czf "$BACKUP_FILE" *.tgz
mv "$BACKUP_FILE" "$OLDPWD/"
cd "$OLDPWD"
rm -rf "$TMPDIR"

HUMAN_DATE="$(date '+%B %-d, %Y at %I:%M %p')"

echo "[Backup] Backup complete: $BACKUP_FILE on $HUMAN_DATE"

# Get human-readable backup size
BACKUP_SIZE=$(du -h "$BACKUP_FILE" | awk '{print $1}')

# Check backup destination before attempting operations
echo "[Backup] Checking backup destination: $BACKUP_PATH"
if ! touch "$BACKUP_PATH/.test" 2>/dev/null; then
  echo "[Backup] WARNING: Backup destination appears to have issues"
  df -h "$BACKUP_PATH" 2>/dev/null || echo "[Backup] Cannot get filesystem info for backup path"
else
  rm -f "$BACKUP_PATH/.test"
  echo "[Backup] Backup destination is accessible"
fi

# After backup is complete
END_TIME=$(date +%s)
ELAPSED_SEC=$((END_TIME - START_TIME))
ELAPSED_MIN=$((ELAPSED_SEC / 60))
if [ $ELAPSED_MIN -eq 0 ]; then
  ELAPSED_STR="Less than 1 minute"
else
  ELAPSED_STR="$ELAPSED_MIN minutes"
fi

DATE_FOLDER="$(date '+%Y-%m-%d')"
TARGET_FOLDER="$BACKUP_PATH"

# Create the target folder if it doesn't exist
mkdir -p "$TARGET_FOLDER"

# Copy backup file to target with error handling for network mounts
echo "[Backup] Moving backup file to $TARGET_FOLDER"
if ! mv "$BACKUP_FILE" "$TARGET_FOLDER/" 2>/dev/null; then
  echo "[Backup] Direct move failed, attempting copy with sync..."
  if cp "$BACKUP_FILE" "$TARGET_FOLDER/" && sync; then
    echo "[Backup] Copy successful, removing local copy..."
    rm -f "$BACKUP_FILE"
  else
    echo "[Backup] WARNING: Failed to copy to backup destination. File remains at: $(pwd)/$BACKUP_FILE"
    echo "[Backup] Network mount may be experiencing issues."
  fi
fi

# Clean up old files with error handling for network mounts
echo "[Backup] Cleaning up old files..."
if find "$BACKUP_PATH" -type f -mtime +7 -print0 2>/dev/null | xargs -0 rm -f 2>/dev/null; then
  echo "[Backup] Old files cleaned up successfully"
else
  echo "[Backup] WARNING: Some old files may not have been cleaned up (network mount issue)"
fi

# Clean up empty folders with error handling
echo "[Backup] Cleaning up empty folders..."
if find "$BACKUP_PATH" -type d -empty -print0 2>/dev/null | xargs -0 rmdir 2>/dev/null; then
  echo "[Backup] Empty folders cleaned up successfully"
else
  echo "[Backup] Empty folder cleanup completed (some may remain due to permissions)"
fi

echo "[Backup] Backup operations completed."

# Compose email body
MAIL_BODY="Backup completed on $HUMAN_DATE\nTime elapsed: $ELAPSED_STR\n\nFile: $BACKUP_FILE\nSize: $BACKUP_SIZE\nVolumes: $SERVICE_COUNT\n"

echo -e "$MAIL_BODY" | mail -s "${SERVER_NAME} backup complete" "$EMAIL"
echo "[Backup] Notification email sent to $EMAIL"