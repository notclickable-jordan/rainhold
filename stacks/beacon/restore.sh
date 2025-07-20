#!/bin/bash

# Restore all named Docker volumes in the beacon stack from individual backup files
set -e

# Set the backup file prefix (change this if your server uses a different name)
SERVER_NAME="rainhold-beacon"

# Source shared volumes variable
. "$(dirname "$0")/volumes.sh"

# Function to find the latest backup folder
find_latest_backup_folder() {
  # First check in current directory
  local latest_local=$(ls -1dt 20*-*-* 2>/dev/null | head -n 1)
  
  # Then check in backup path if it exists and is accessible
  local latest_remote=""
  if [ -n "$BACKUP_PATH" ] && timeout 10 ls "$BACKUP_PATH" >/dev/null 2>&1; then
    latest_remote=$(timeout 10 ls -1dt "$BACKUP_PATH"/20*-*-* 2>/dev/null | head -n 1)
  fi
  
  # Compare dates and return the most recent
  if [ -n "$latest_remote" ] && [ -n "$latest_local" ]; then
    # Extract dates and compare
    local remote_date=$(basename "$latest_remote")
    local local_date=$(basename "$latest_local")
    
    if [[ "$remote_date" > "$local_date" ]]; then
      echo "$latest_remote"
    else
      echo "$latest_local"
    fi
  elif [ -n "$latest_remote" ]; then
    echo "$latest_remote"
  elif [ -n "$latest_local" ]; then
    echo "$latest_local"
  else
    echo ""
  fi
}

# Allow user to specify a backup folder or find the latest one
if [ -n "$1" ]; then
  # User specified a backup folder/date
  if [[ "$1" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    # User provided a date, use it directly as folder name
    BACKUP_FOLDER="$1"
  else
    # User provided a full folder name
    BACKUP_FOLDER="$1"
  fi
  
  # Check if folder exists locally first
  if [ -d "$BACKUP_FOLDER" ]; then
    BACKUP_SOURCE="$BACKUP_FOLDER"
  elif [ -n "$BACKUP_PATH" ] && [ -d "$BACKUP_PATH/$BACKUP_FOLDER" ]; then
    BACKUP_SOURCE="$BACKUP_PATH/$BACKUP_FOLDER"
  else
    echo "Error: Backup folder '$BACKUP_FOLDER' not found locally or in $BACKUP_PATH"
    exit 1
  fi
else
  # Find the latest backup folder automatically
  BACKUP_SOURCE=$(find_latest_backup_folder)
  if [ -z "$BACKUP_SOURCE" ]; then
    echo "Error: No YYYY-MM-DD backup folders found"
    echo "Usage: $0 [backup-folder-or-date]"
    echo "Example: $0 2025-07-11"
    exit 1
  fi
fi

echo "Using backup source: $BACKUP_SOURCE"

# Verify backup files exist
echo "Verifying backup files..."
MISSING_BACKUPS=0
for entry in "${VOLUMES[@]}"; do
  VOLUME="${entry%%:*}"
  BACKUP_FILE="${VOLUME}.tgz"
  if ! ls "$BACKUP_SOURCE"/${BACKUP_FILE} >/dev/null 2>&1; then
    echo "Warning: No backup file found for volume $VOLUME"
    MISSING_BACKUPS=$((MISSING_BACKUPS + 1))
  fi
done

if [ $MISSING_BACKUPS -gt 0 ]; then
  echo "Warning: $MISSING_BACKUPS volume backup files are missing"
  read -p "Continue with restore? (y/N): " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Restore cancelled"
    exit 1
  fi
fi

# 1. Shut down all running docker services in each subfolder
echo "Stopping all docker compose services in subfolders..."
for compose in ./docker/*/compose.yml; do
  if [ -f "$compose" ]; then
    folder=$(dirname "$compose")
    service_name=$(basename "$folder")
    printf "Stopping %s... " "$service_name"
    if (cd "$folder" && docker compose down >/dev/null 2>&1); then
      echo "done."
    else
      echo "failed (may not be running)."
    fi
  fi
done

echo "All services stopped."

# 2. Restore each volume individually
echo "Restoring individual volumes..."
SUCCESSFUL_RESTORES=0
FAILED_RESTORES=0
TOTAL_VOLUMES=${#VOLUMES[@]}

for i in "${!VOLUMES[@]}"; do
  entry="${VOLUMES[$i]}"
  VOLUME="${entry%%:*}"
  MOUNT_PATH="${entry#*:}"
  
  # Find the backup file for this volume
  BACKUP_FILE="$BACKUP_SOURCE/${VOLUME}.tgz"
  
  printf "[%02d/%02d] Restoring %s..." "$((i+1))" "$TOTAL_VOLUMES" "$VOLUME"
  
  if [ -f "$BACKUP_FILE" ]; then
    # Restore this volume using a temporary container
    if docker run --rm \
      --mount type=volume,source="$VOLUME",target="$MOUNT_PATH" \
      -v "$BACKUP_SOURCE:/backup" \
      alpine:3.17.2 sh -c "
        rm -rf $MOUNT_PATH/*
        tar -xzf /backup/$(basename "$BACKUP_FILE") -C $MOUNT_PATH
      " >/dev/null 2>&1; then
      printf " done.\n"
      SUCCESSFUL_RESTORES=$((SUCCESSFUL_RESTORES + 1))
    else
      printf " failed.\n"
      FAILED_RESTORES=$((FAILED_RESTORES + 1))
    fi
  else
    printf " skipped (no backup file).\n"
    FAILED_RESTORES=$((FAILED_RESTORES + 1))
  fi
done

echo "Restore complete. Successful: $SUCCESSFUL_RESTORES, Failed: $FAILED_RESTORES"

echo "Restarting all docker compose services in subfolders..."

for compose in ./docker/*/compose.yml; do
  if [ -f "$compose" ]; then
    folder=$(dirname "$compose")
    service_name=$(basename "$folder")
    printf "Starting %s... " "$service_name"
    if (cd "$folder" && docker compose up -d >/dev/null 2>&1); then
      echo "done."
    else
      echo "failed."
    fi
  fi
done

echo "All services started."
