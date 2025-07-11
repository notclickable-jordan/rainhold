#!/bin/bash

# Restore all named Docker volumes in the beacon stack from ${SERVER_NAME}*.tgz
set -e

# Set the backup file prefix (change this if your server uses a different name)
SERVER_NAME="rainhold-beacon"

# Source shared volumes variable
. "$(dirname "$0")/volumes.sh"

# Find the latest ${SERVER_NAME}*.tgz file
BACKUP_FILE=$(ls -1t ${SERVER_NAME}*.tgz 2>/dev/null | head -n 1)
if [ -z "$BACKUP_FILE" ]; then
  echo "No ${SERVER_NAME}*.tgz backup file found in $(pwd)"
  exit 1
fi
echo "Using backup file: $BACKUP_FILE"

# 1. Shut down all running docker services in each subfolder
echo "Stopping all docker compose services in subfolders..."
for compose in ./docker/*/compose.yml; do
  folder=$(dirname "$compose")
  (cd "$folder" && docker compose down)
done

echo "All services stopped."

# 2. Extract backup archive to a temp dir
TMPDIR=$(mktemp -d)
tar -xzf "$BACKUP_FILE" -C "$TMPDIR"

# 3. Restore each volume using a temporary container
MOUNT_ARGS=""
for entry in "${VOLUMES[@]}"; do
  VOLUME="${entry%%:*}"
  MOUNT_PATH="${entry#*:}"
  MOUNT_ARGS+=" --mount type=volume,source=$VOLUME,target=$MOUNT_PATH "
done

docker run --rm $MOUNT_ARGS -v "$TMPDIR:/backup" ubuntu:22.04 sh -c '
  for entry in "$@"; do
    VOLUME="${entry%%:*}"
    MOUNT_PATH="${entry#*:}"
    TGZ="/backup/${VOLUME}.tgz"
    if [ -f "$TGZ" ]; then
      # Create temporary extraction directory
      mkdir -p "/tmp/${VOLUME}"
      
      # Extract archive to temporary location
      tar -xzf "$TGZ" -C "/tmp/${VOLUME}"
      
      # Use rsync to restore files with better handling of permissions, links, etc.
      # Clear destination first, then sync
      rm -rf "$MOUNT_PATH"/*
      rsync -av "/tmp/${VOLUME}/" "$MOUNT_PATH/"
      
      # Clean up temporary extraction directory
      rm -rf "/tmp/${VOLUME}"
      
      echo "Restored $VOLUME to $MOUNT_PATH using rsync"
    else
      echo "Warning: $TGZ not found, skipping $VOLUME"
    fi
  done
' _ "${VOLUMES[@]}"

rm -rf "$TMPDIR"
echo "Restore complete. Restarting all docker compose services in subfolders..."

for compose in ./docker/*/compose.yml; do
  folder=$(dirname "$compose")
  (cd "$folder" && docker compose up -d)
done

echo "All services started."
