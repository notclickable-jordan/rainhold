#!/bin/bash

# Backup all named Docker volumes in the beacon stack into a single archive
set -e

# Source shared volumes variable
. "$(dirname "$0")/volumes.sh"

# Create a temporary directory for the backup
TMPDIR=$(mktemp -d)

# Build --mount args for all volumes
MOUNT_ARGS=""
for entry in "${VOLUMES[@]}"; do
  VOLUME="${entry%%:*}"
  MOUNT_PATH="${entry#*:}"
  MOUNT_ARGS+=" --mount type=volume,source=$VOLUME,target=$MOUNT_PATH,readonly "
done

# Use alpine:3.17.2 for tar support and compatibility with restore
docker run --rm $MOUNT_ARGS -v "$TMPDIR:/backup" alpine:3.17.2 sh -c '
  for entry in "$@"; do
    VOLUME="${entry%%:*}"
    MOUNT_PATH="${entry#*:}"
    tar -czf "/backup/${VOLUME}.tgz" -C "$MOUNT_PATH" .
  done
' _ "${VOLUMES[@]}"

# Combine all tars into one archive
cd "$TMPDIR"
tar -czf rainhold-beacon.tgz *.tgz
mv rainhold-beacon.tgz "$OLDPWD/"
cd "$OLDPWD"
rm -rf "$TMPDIR"

echo "Backup complete: rainhold-beacon.tgz"
