#!/bin/bash

# System monitoring script to detect resource issues
# Run this via cron every 5 minutes

LOG_FILE="/var/log/system-monitor.log"
EMAIL="admin@notclickable.com"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Check memory usage
MEMORY_USAGE=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100}')
if [ "$MEMORY_USAGE" -gt 90 ]; then
    echo "[$DATE] WARNING: Memory usage at ${MEMORY_USAGE}%" | tee -a "$LOG_FILE"
    echo "High memory usage detected: ${MEMORY_USAGE}%" | mail -s "Rainhold Memory Alert" "$EMAIL"
fi

# Check disk usage
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt 85 ]; then
    echo "[$DATE] WARNING: Disk usage at ${DISK_USAGE}%" | tee -a "$LOG_FILE"
    echo "High disk usage detected: ${DISK_USAGE}%" | mail -s "Rainhold Disk Alert" "$EMAIL"
fi

# Check if network shares are accessible
for mount_point in /mnt/backup /mnt/downloads /mnt/erotica /mnt/media; do
    if ! mountpoint -q "$mount_point"; then
        echo "[$DATE] ERROR: Network share $mount_point not mounted" | tee -a "$LOG_FILE"
        echo "Network share $mount_point is not accessible" | mail -s "Rainhold Mount Alert" "$EMAIL"
    fi
done

# Check for excessive log growth
NFTABLES_LOG_SIZE=$(journalctl --since="1 hour ago" | grep -c "nftables-" || echo 0)
if [ "$NFTABLES_LOG_SIZE" -gt 1000 ]; then
    echo "[$DATE] WARNING: Excessive nftables logging detected ($NFTABLES_LOG_SIZE entries in last hour)" | tee -a "$LOG_FILE"
    echo "Excessive nftables logging detected: $NFTABLES_LOG_SIZE entries in last hour" | mail -s "Rainhold Logging Alert" "$EMAIL"
fi

# Log system load
LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')
echo "[$DATE] System load: $LOAD_AVG, Memory: ${MEMORY_USAGE}%, Disk: ${DISK_USAGE}%" >> "$LOG_FILE"
