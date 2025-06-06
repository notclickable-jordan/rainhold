#!/bin/bash

# Backup all named Docker volumes in the beacon stack into a single archive
set -e

# Source shared volumes variable
. "$(dirname "$0")/volumes.sh"

EMAIL="admin@notclickable.com"
DATE="$(date '+%Y-%m-%d %H:%M:%S')"
BACKUP_FILE="rainhold-beacon.tgz"

# Get docker service names from compose files
SERVICES=$(grep -hE '^\s{0,4}[a-zA-Z0-9_-]+:' ./docker/*/compose.yml | grep -vE 'services:' | sed 's/://;s/^ *//' | sort | uniq | xargs)

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

echo "[Backup] Combining all volume archives into rainhold-beacon.tgz..."
cd "$TMPDIR"
tar -czf rainhold-beacon.tgz *.tgz
mv rainhold-beacon.tgz "$OLDPWD/"
cd "$OLDPWD"
rm -rf "$TMPDIR"

echo "[Backup] Backup complete: $BACKUP_FILE"

# Get human-readable backup size
BACKUP_SIZE=$(du -h "$BACKUP_FILE" | awk '{print $1}')

# Compose email body
MAIL_BODY="Backup completed on $DATE

Backup file: $BACKUP_FILE
Size: $BACKUP_SIZE

Docker services backed up:\n$SERVICES\n"

echo -e "$MAIL_BODY" | mail -s "[rainhold-beacon] Backup complete on $DATE" "$EMAIL"
echo "[Backup] Notification email sent to $EMAIL."
