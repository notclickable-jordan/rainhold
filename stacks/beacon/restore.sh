#!/bin/bash

# Restore all named Docker volumes in the beacon stack from rainhold-beacon.tgz
set -e

# Source shared volumes variable
. "$(dirname "$0")/volumes.sh"

# 1. Shut down all running docker services in each subfolder
echo "Stopping all docker compose services in subfolders..."
for compose in ./docker/*/compose.yml; do
  folder=$(dirname "$compose")
  (cd "$folder" && docker compose down)
done

echo "All services stopped."

# 2. Extract backup archive to a temp dir
TMPDIR=$(mktemp -d)
tar -xzf rainhold-beacon.tgz -C "$TMPDIR"

# 3. Restore each volume using a temporary container
MOUNT_ARGS=""
for entry in "${VOLUMES[@]}"; do
  VOLUME="${entry%%:*}"
  MOUNT_PATH="${entry#*:}"
  MOUNT_ARGS+=" --mount type=volume,source=$VOLUME,target=$MOUNT_PATH "
done

docker run --rm $MOUNT_ARGS -v "$TMPDIR:/backup" alpine:3.17.2 sh -c '
  for entry in "$@"; do
    VOLUME="${entry%%:*}"
    MOUNT_PATH="${entry#*:}"
    TGZ="/backup/${VOLUME}.tgz"
    if [ -f "$TGZ" ]; then
      rm -rf "$MOUNT_PATH"/*
      tar -xzf "$TGZ" -C "$MOUNT_PATH"
      echo "Restored $VOLUME to $MOUNT_PATH"
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
