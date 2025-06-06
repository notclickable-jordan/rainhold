#!/bin/bash

# Backup all named Docker volumes in the beacon stack into a single archive
set -e

# Source shared volumes variable
. "$(dirname "$0")/volumes.sh"

EMAIL="admin@notclickable.com"
DATE="$(date '+%Y-%m-%d %H:%M:%S')"
DATE_SUFFIX="$(date '+%Y-%m-%d')"
BACKUP_FILE="rainhold-beacon-${DATE_SUFFIX}.tgz"

# Get docker service folder names under ./docker, format as list with dashes and capitalize
SERVICES=$(find ./docker -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort | sed 's/.*/- &/' | sed 's/- \(.*\)/- \U\1\E/' )

echo "[Backup] Starting backup of Docker volumes..."

# Create a temporary directory for the backup
TMPDIR=$(mktemp -d)
echo "[Backup] Created temporary directory: $TMPDIR"

# Build --mount args for all volumes
echo "[Backup] Preparing volume mount arguments..."
MOUNT_ARGS=""
for entry in "${VOLUMES[@]}"; do
  VOLUME="${entry%%:*}"
  MOUNT_PATH="${entry#*:}"
  MOUNT_ARGS+=" --mount type=volume,source=$VOLUME,target=$MOUNT_PATH,readonly "
done

echo "[Backup] Running backup container to archive each volume..."
# Use alpine:3.17.2 for tar support and compatibility with restore
docker run --rm $MOUNT_ARGS -v "$TMPDIR:/backup" alpine:3.17.2 sh -c '
  for entry in "$@"; do
    VOLUME="${entry%%:*}"
    MOUNT_PATH="${entry#*:}"
    echo "  [Backup] Archiving $VOLUME from $MOUNT_PATH..."
    tar -czf "/backup/${VOLUME}.tgz" -C "$MOUNT_PATH" .
  done
' _ "${VOLUMES[@]}"

echo "[Backup] Combining all volume archives into $BACKUP_FILE..."
cd "$TMPDIR"
tar -czf "$BACKUP_FILE" *.tgz
mv "$BACKUP_FILE" "$OLDPWD/"
cd "$OLDPWD"
rm -rf "$TMPDIR"

echo "[Backup] Backup complete: $BACKUP_FILE"

# Get human-readable backup size
BACKUP_SIZE=$(du -h "$BACKUP_FILE" | awk '{print $1}')

# Compose email body
MAIL_BODY="Backup completed on $DATE\n\nFile: $BACKUP_FILE\nSize: $BACKUP_SIZE\n\nServices:\n$SERVICES\n"

echo -e "$MAIL_BODY" | mail -s "[rainhold-beacon] Backup complete on $DATE" "$EMAIL"
echo "[Backup] Notification email sent to $EMAIL."
