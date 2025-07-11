#!/bin/bash

# Backup all named Docker volumes in the beacon stack as individual files
set -e

# Set the server name (change this if your server uses a different name)
SERVER_NAME="rainhold-beacon"

# Source shared volumes variable
. "$(dirname "$0")/volumes.sh"

EMAIL="admin@notclickable.com"
DATE="$(date '+%Y-%m-%d %H:%M:%S')"
DATE_SUFFIX="$(date '+%Y-%m-%d')"
BACKUP_FOLDER="${SERVER_NAME}-${DATE_SUFFIX}"

# Get the number of entries in the VOLUMES variable
SERVICE_COUNT=${#VOLUMES[@]}

echo "[Backup] Starting backup of Docker volumes"

# Create a temporary directory for the backup
TMPDIR=$(mktemp -d)
echo "[Backup] Created temporary directory: $TMPDIR"

# Function to check if network path is accessible
check_network_path() {
  local path="$1"
  local timeout=10
  
  echo "[Backup] Checking network path accessibility: $path"
  
  # Test if we can access the directory with a timeout
  if timeout $timeout ls "$path" >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

# Function to safely copy file with retry logic
safe_copy_with_retry() {
  local source="$1"
  local target_dir="$2"
  local max_attempts=3
  local attempt=1
  
  while [ $attempt -le $max_attempts ]; do
    if timeout 30 cp "$source" "$target_dir/" 2>/dev/null; then
      return 0
    else
      attempt=$((attempt + 1))
      if [ $attempt -le $max_attempts ]; then
        sleep 2
      fi
    fi
  done
  
  return 1
}

# Build --mount args for all volumes
echo "[Backup] Preparing volume mount arguments"
MOUNT_ARGS=""
for entry in "${VOLUMES[@]}"; do
  VOLUME="${entry%%:*}"
  MOUNT_PATH="${entry#*:}"
  MOUNT_ARGS+=" --mount type=volume,source=$VOLUME,target=$MOUNT_PATH,readonly "
done

# Track start time
START_TIME=$(date +%s)

# Check if backup path is accessible
NETWORK_AVAILABLE=false
TARGET_FOLDER=""
if check_network_path "$BACKUP_PATH"; then
  echo "[Backup] Network path is accessible"
  TARGET_FOLDER="$BACKUP_PATH/$BACKUP_FOLDER"
  
  # Create the target folder if it doesn't exist
  if timeout 10 mkdir -p "$TARGET_FOLDER" 2>/dev/null; then
    echo "[Backup] Target folder created: $TARGET_FOLDER"
    NETWORK_AVAILABLE=true
  else
    echo "[Backup] Error: Could not create target folder on network path"
    echo "[Backup] Will keep backups locally"
  fi
else
  echo "[Backup] Error: Network backup path is not accessible"
  echo "[Backup] Will keep backups locally"
  TARGET_FOLDER="$BACKUP_FOLDER"
  mkdir -p "$TARGET_FOLDER"
fi

echo "[Backup] Processing individual volume backups"
# Process each volume individually
i=1
SUCCESSFUL_BACKUPS=0
FAILED_BACKUPS=0

for entry in "${VOLUMES[@]}"; do
  VOLUME="${entry%%:*}"
  MOUNT_PATH="${entry#*:}"
  BACKUP_FILE="${SERVER_NAME}-${VOLUME}-${DATE_SUFFIX}.tgz"
  
  printf "[%02d/%02d] Backing up %s..." "$i" "$SERVICE_COUNT" "$VOLUME"
  
  # Create backup for this volume
  if docker run --rm --mount type=volume,source="$VOLUME",target="$MOUNT_PATH",readonly -v "$TMPDIR:/backup" alpine:3.17.2 sh -c "tar -czf \"/backup/${BACKUP_FILE}\" -C \"$MOUNT_PATH\" ." 2>/dev/null; then
    printf " done."
    
    # Copy to target location immediately
    if [ "$NETWORK_AVAILABLE" = true ]; then
      printf " Copying..."
      if safe_copy_with_retry "$TMPDIR/$BACKUP_FILE" "$TARGET_FOLDER"; then
        printf " done.\n"
        rm -f "$TMPDIR/$BACKUP_FILE"
        SUCCESSFUL_BACKUPS=$((SUCCESSFUL_BACKUPS + 1))
      else
        printf " failed. Kept locally.\n"
        mv "$TMPDIR/$BACKUP_FILE" "./"
        FAILED_BACKUPS=$((FAILED_BACKUPS + 1))
      fi
    else
      mv "$TMPDIR/$BACKUP_FILE" "$TARGET_FOLDER/"
      printf " saved locally.\n"
      SUCCESSFUL_BACKUPS=$((SUCCESSFUL_BACKUPS + 1))
    fi
  else
    printf " failed.\n"
    FAILED_BACKUPS=$((FAILED_BACKUPS + 1))
  fi
  
  i=$((i + 1))
done

rm -rf "$TMPDIR"

HUMAN_DATE="$(date '+%B %-d, %Y at %I:%M %p')"

echo "[Backup] Backup complete on $HUMAN_DATE"
echo "[Backup] Successful: $SUCCESSFUL_BACKUPS, Failed: $FAILED_BACKUPS"

# After backup is complete
END_TIME=$(date +%s)
ELAPSED_SEC=$((END_TIME - START_TIME))
ELAPSED_MIN=$((ELAPSED_SEC / 60))
if [ $ELAPSED_MIN -eq 0 ]; then
  ELAPSED_STR="Less than 1 minute"
else
  ELAPSED_STR="$ELAPSED_MIN minutes"
fi

# Clean up old backup folders if using network storage
if [ "$NETWORK_AVAILABLE" = true ]; then
  echo "[Backup] Cleaning up old backup folders..."
  if timeout 30 find "$BACKUP_PATH" -maxdepth 1 -type d -name "${SERVER_NAME}-*" -mtime +7 -exec rm -rf {} \; 2>/dev/null; then
    echo "[Backup] Old backup folders cleaned up"
  else
    echo "[Backup] Warning: Cleanup of old backup folders timed out or failed"
  fi
fi

# Determine backup status and location for email
if [ "$NETWORK_AVAILABLE" = true ] && [ $FAILED_BACKUPS -eq 0 ]; then
  BACKUP_LOCATION="$TARGET_FOLDER"
  BACKUP_STATUS="Success - All files moved to network storage"
elif [ "$NETWORK_AVAILABLE" = true ] && [ $FAILED_BACKUPS -gt 0 ]; then
  BACKUP_LOCATION="Mixed: $TARGET_FOLDER and local directory"
  BACKUP_STATUS="Partial success - Some files kept locally due to network issues"
else
  BACKUP_LOCATION="$(pwd)/$TARGET_FOLDER"
  BACKUP_STATUS="Local backup - Network storage unavailable"
fi

# Calculate total backup size
if [ "$NETWORK_AVAILABLE" = true ] && [ -d "$TARGET_FOLDER" ]; then
  BACKUP_SIZE=$(du -sh "$TARGET_FOLDER" 2>/dev/null | awk '{print $1}' || echo "Unknown")
elif [ -d "$TARGET_FOLDER" ]; then
  BACKUP_SIZE=$(du -sh "$TARGET_FOLDER" 2>/dev/null | awk '{print $1}' || echo "Unknown")
else
  BACKUP_SIZE="Unknown"
fi

# Compose email body
MAIL_BODY="Backup completed on $HUMAN_DATE\nTime elapsed: $ELAPSED_STR\nStatus: $BACKUP_STATUS\n\nLocation: $BACKUP_LOCATION\nTotal size: $BACKUP_SIZE\nSuccessful backups: $SUCCESSFUL_BACKUPS\nFailed backups: $FAILED_BACKUPS\nTotal volumes: $SERVICE_COUNT\n"

echo -e "$MAIL_BODY" | mail -s "${SERVER_NAME} backup complete" "$EMAIL"
echo "[Backup] Notification email sent to $EMAIL"