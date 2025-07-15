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

# Check backup destination before attempting operations (SMB over mesh Wi-Fi)
echo "[Backup] Checking SMB backup destination: $BACKUP_PATH"
if ! timeout 30 touch "$BACKUP_PATH/.test" 2>/dev/null; then
  echo "[Backup] WARNING: SMB backup destination appears to have issues or is slow"
  df -h "$BACKUP_PATH" 2>/dev/null || echo "[Backup] Cannot get filesystem info for backup path"
  SMB_ACCESSIBLE=false
else
  rm -f "$BACKUP_PATH/.test"
  echo "[Backup] SMB backup destination is accessible"
  SMB_ACCESSIBLE=true
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

# Only attempt SMB operations if the mount is accessible
if [ "$SMB_ACCESSIBLE" = "true" ]; then
  # Create the target folder if it doesn't exist
  mkdir -p "$TARGET_FOLDER"

  # Use rsync for SMB over mesh Wi-Fi (more reliable than cp/mv for large files)
  echo "[Backup] Transferring backup file to SMB share using rsync..."
  if timeout 600 rsync -av --progress --partial --inplace "$BACKUP_FILE" "$TARGET_FOLDER/"; then
    echo "[Backup] Rsync transfer successful, removing local copy..."
    rm -f "$BACKUP_FILE"
    BACKUP_LOCATION="$TARGET_FOLDER/$BACKUP_FILE"
  else
    echo "[Backup] WARNING: Rsync transfer failed or timed out. Trying simple copy..."
    if timeout 300 cp "$BACKUP_FILE" "$TARGET_FOLDER/" 2>/dev/null; then
      echo "[Backup] Copy successful, syncing and removing local copy..."
      sync
      rm -f "$BACKUP_FILE"
      BACKUP_LOCATION="$TARGET_FOLDER/$BACKUP_FILE"
    else
      echo "[Backup] WARNING: All transfer methods failed. File remains at: $(pwd)/$BACKUP_FILE"
      echo "[Backup] SMB mount over mesh Wi-Fi may be too unstable for large files."
      BACKUP_LOCATION="$(pwd)/$BACKUP_FILE (local - SMB transfer failed)"
    fi
  fi
else
  echo "[Backup] Skipping SMB transfer due to mount accessibility issues."
  BACKUP_LOCATION="$(pwd)/$BACKUP_FILE (local - SMB not accessible)"
fi

# Clean up old files only if SMB is accessible and transfer was successful
if [ "$SMB_ACCESSIBLE" = "true" ] && [[ "$BACKUP_LOCATION" == *"$TARGET_FOLDER"* ]]; then
  echo "[Backup] Cleaning up old files from SMB share..."
  if timeout 120 find "$BACKUP_PATH" -type f -mtime +7 -print0 2>/dev/null | timeout 60 xargs -0 rm -f 2>/dev/null; then
    echo "[Backup] Old files cleaned up successfully"
  else
    echo "[Backup] WARNING: Old file cleanup timed out or failed (SMB/Wi-Fi issue)"
  fi

  # Clean up empty folders with timeout protection for SMB
  echo "[Backup] Cleaning up empty folders..."
  if timeout 60 find "$BACKUP_PATH" -type d -empty -print0 2>/dev/null | timeout 30 xargs -0 rmdir 2>/dev/null; then
    echo "[Backup] Empty folders cleaned up successfully"
  else
    echo "[Backup] Empty folder cleanup completed (some may remain due to SMB/Wi-Fi issues)"
  fi
else
  echo "[Backup] Skipping SMB cleanup operations (transfer failed or SMB not accessible)"
fi

echo "[Backup] Backup operations completed."

# Compose email body
MAIL_BODY="Backup completed on $HUMAN_DATE\nTime elapsed: $ELAPSED_STR\n\nFile: $BACKUP_LOCATION\nSize: $BACKUP_SIZE\nVolumes: $SERVICE_COUNT\n"

echo -e "$MAIL_BODY" | mail -s "${SERVER_NAME} backup complete" "$EMAIL"
echo "[Backup] Notification email sent to $EMAIL"