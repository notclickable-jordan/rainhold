#!/bin/bash

# Backup all named Docker volumes in the beacon stack into a single archive
set -e

# Source shared volumes variable
. "$(dirname "$0")/volumes.sh"

EMAIL="admin@notclickable.com"
DATE="$(date '+%Y-%m-%d %H:%M:%S')"
DATE_SUFFIX="$(date '+%Y-%m-%d')"
BACKUP_FILE="rainhold-beacon-${DATE_SUFFIX}.tgz"

# Get docker service folder count under ./docker
SERVICE_COUNT=$(find ./docker -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')

echo "[Backup] Starting backup of Docker volumes"

# Create a temporary directory for the backup
TMPDIR=$(mktemp -d)
echo "[Backup] Created temporary directory: $TMPDIR"

# Build --mount args for all volumes
echo "[Backup] Preparing volume mount arguments"
MOUNT_ARGS=""
for entry in "${VOLUMES[@]}"; do
  VOLUME="${entry%%:*}"
  MOUNT_PATH="${entry#*:}"
  MOUNT_ARGS+=" --mount type=volume,source=$VOLUME,target=$MOUNT_PATH,readonly "
done

echo "[Backup] Running backup container to archive each volume"
# Use alpine:3.17.2 for tar support and compatibility with restore
# Track start time
START_TIME=$(date +%s)
docker run --rm $MOUNT_ARGS -v "$TMPDIR:/backup" alpine:3.17.2 sh -c '
  total=$#
  i=1
  for entry in "$@"; do
    VOLUME="${entry%%:*}"
    MOUNT_PATH="${entry#*:}"
    echo "[$i/$total] $VOLUME from $MOUNT_PATH"
    tar -czf "/backup/${VOLUME}.tgz" -C "$MOUNT_PATH" .
    i=$((i+1))
  done
' _ "${VOLUMES[@]}"

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

# After backup is complete
END_TIME=$(date +%s)
ELAPSED_SEC=$((END_TIME - START_TIME))
ELAPSED_MIN=$((ELAPSED_SEC / 60))
if [ $ELAPSED_MIN -eq 0 ]; then
  ELAPSED_STR="Less than 1 minute"
else
  ELAPSED_STR="$ELAPSED_MIN minute(s)"
fi

# Compose email body
MAIL_BODY="Backup completed on $HUMAN_DATE\nTime elapsed: $ELAPSED_STR\n\nFile: $BACKUP_FILE\nSize: $BACKUP_SIZE\nServices: $SERVICE_COUNT\n"

echo -e "$MAIL_BODY" | mail -s "[rainhold-beacon] Backup complete on $DATE" "$EMAIL"
echo "[Backup] Notification email sent to $EMAIL"
